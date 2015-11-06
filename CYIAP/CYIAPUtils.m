//
//  CYIAPUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#import "CYIAPUtils.h"
#import "CYIAPKeychainUtils.h"

@interface CYIAPUtils () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@end

@implementation CYIAPUtils

#pragma mark - pay
- (NSInteger)startIAPPayWithProductId:(NSString *)productId
                          amount:(NSUInteger)amount
                  additionalInfo:(NSString *)additionalInfo {
    
    if (!productId) {
        
        return -1;
    }
    if (amount == 0) {
        
        return -1;
    }
    if (_isPaying) {
        
        return 1;
    }
    if (_havePayWaiting) {
        
        return 2;
    }
    if (self.haveIncompletePay) {
        
        [self startIAPIncompletePay];
        return 3;
    }
    _isPaying = YES;
    
    _productId = productId;
    _amount = amount;
    _additionalInfo = additionalInfo;
    
    // 支付需要先请求产品
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productId]];
    request.delegate = self;
    [request start];
    return 0;
}

#pragma mark - 未完成交易
- (void)startIAPIncompletePay {
    
    if (self.haveIncompletePay
        && _delegate
        && [_delegate respondsToSelector:@selector(IAPPayDidFinishedWithReceipt:additionalInfo:)]) {
        
        NSString *receipt = [CYIAPKeychainUtils receiptFromKeychain];
        NSString *additionalInfo = [CYIAPKeychainUtils receiptAddtionalInfoFromKeychain];
        [_delegate IAPPayDidFinishedWithReceipt:receipt
                                 additionalInfo:additionalInfo];
    }
}

#pragma mark - 支付等待
- (void)startIAPPayWaiting {
    
    _havePayWaiting = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _havePayWaiting = NO;
    });
}

#pragma mark - getter setter
- (BOOL)haveIncompletePay {
    
    NSString *receiptInKeychain = [CYIAPKeychainUtils receiptFromKeychain];
    if (receiptInKeychain
        && ![receiptInKeychain isEqualToString:@""]) {
        
        return YES;
    }
    return NO;
}

- (void)setDelegate:(id<CYIAPUtilsDelegate>)delegate {
    
    _delegate = delegate;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.haveIncompletePay
            && _delegate
            && [_delegate respondsToSelector:@selector(IAPPayDidFinishedWithReceipt:additionalInfo:)]) {
            
            NSString *receipt = [CYIAPKeychainUtils receiptFromKeychain];
            NSString *additionalInfo = [CYIAPKeychainUtils receiptAddtionalInfoFromKeychain];
            [_delegate IAPPayDidFinishedWithReceipt:receipt
                                     additionalInfo:additionalInfo];
        }
    });
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSArray *products = response.products;
    if (!products
        || [products count] == 0) {
        
        // 获取产品失败
        _isPaying = NO;
        if (_delegate
            && [_delegate respondsToSelector:@selector(IAPPayDidFailedWithError:)]) {
            
            [_delegate IAPPayDidFailedWithError:[NSError errorWithDomain:CY_IAP_COMMON_ERROR_DOMAIN
                                                                    code:-1
                                                                userInfo:@{ @"msg": @"产品获取失败" }]];
        }
    } else {
        
        // 取到产品，在此判断数量
        if (_amount > 0) {
            
            _isPaying = YES;
            SKProduct *product = [products firstObject];
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
            payment.quantity = _amount;
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        } else {
            
            _isPaying = NO;
        }
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    // 获取产品请求失败
    _isPaying = NO;
    if ([request isKindOfClass:[SKProductsRequest class]]) {
        
        if (_delegate
            && [_delegate respondsToSelector:@selector(IAPPayDidFailedWithError:)]) {
            
            [_delegate IAPPayDidFailedWithError:[NSError errorWithDomain:CY_IAP_COMMON_ERROR_DOMAIN
                                                                    code:-1
                                                                userInfo:@{ @"msg": @"产品获取失败" }]];
        }
    }
}

- (void)requestDidFinish:(SKRequest *)request {
    
    
}

#pragma mark - SKPaymentTransactionObserver
// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
// 苹果IAP支付回调方法，支付状态发生变化时，会回调此方法
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    if (!transactions
        || [transactions count] == 0) {
        return;
    }
    
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateFailed: {
                
                // 支付失败，直接通知游戏
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                _isPaying = NO;
                
                if (_delegate
                    && [_delegate respondsToSelector:@selector(IAPPayDidFailedWithError:)]) {
                    
                    [_delegate IAPPayDidFailedWithError:transaction.error];
                }
                break;
            }
                
            case SKPaymentTransactionStatePurchased: {
                
                // 该方法会验证票据
                [self appleIAPPurchasedWithTransaction:transaction];
                break;
            }
                
            case SKPaymentTransactionStatePurchasing: {
                
                // 支付开始
                if (_delegate
                    && [_delegate respondsToSelector:@selector(IAPPayDidStart:)]) {
                    
                    [_delegate IAPPayDidStart:self];
                }
                break;
            }
                
            case SKPaymentTransactionStateRestored: {
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                _isPaying = NO;
                
                break;
            }
                
            default: {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                _isPaying = NO;
                
                break;
            }
                
        }
        
    }
    
}

- (void)appleIAPPurchasedWithTransaction:(SKPaymentTransaction *)transaction {
    
    NSString *receipt = nil;
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // Test whether the receipt is present at the above URL
    if([[NSFileManager defaultManager] fileExistsAtPath:[receiptURL path]]) {
        
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
        receipt = [receiptData base64EncodedStringWithOptions:0];
    } else {
        
        receipt = [transaction.transactionReceipt base64EncodedStringWithOptions:0];
    }
    
    if (receipt) {
        
        // 保存残留交易
        [CYIAPKeychainUtils saveReceipt:receipt];
        
        // 保存完成，通知苹果交易结束，此处必须调用，否则苹果会一直回调
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
        // 先取出 additionalInfo
        if (!_additionalInfo) {
            
            _additionalInfo = [CYIAPKeychainUtils receiptAddtionalInfoFromKeychain];
        }
        
        if (_delegate
            && [_delegate respondsToSelector:@selector(IAPPayDidFinishedWithReceipt:additionalInfo:)]) {
            
            [_delegate IAPPayDidFinishedWithReceipt:receipt
                                     additionalInfo:_additionalInfo];
        }
        
    } else {
        
        // 通知苹果交易结束
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
    _isPaying = NO;
    _havePayWaiting = NO;
}

#pragma mark - end pay
- (void)finishAllPayingSteps {
    
    [CYIAPKeychainUtils removeReceiptFromKeychainWithAdditionalInfo:YES];
}

#pragma mark - sharedInstance
+ (instancetype)sharedInstance {
    
    static CYIAPUtils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[CYIAPUtils alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:sharedInstance];
        [sharedInstance startIAPPayWaiting];
    });
    return sharedInstance;
}


@end
