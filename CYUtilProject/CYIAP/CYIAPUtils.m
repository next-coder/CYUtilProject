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

@interface CYIAPTransaction ()

@property (nonatomic, copy, readwrite) CYIAPTransactionStateChangedBlock stateChangedBlock;

// private setting method
- (void)setState:(CYIAPTransactionState)state;
- (void)setTransactionReceipt:(NSString *)transactionReceipt;
- (void)setProductIdentifier:(NSString *)productIdentifier;
- (void)setQuantity:(NSUInteger)quantity;
- (void)setAdditionalInfo:(NSDictionary *)additionalInfo;

@end

@interface CYIAPUtils () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

// CYIAPTransaction list, contain all the transactions that would be started, include current paying transaction
@property (nonatomic, strong) NSMutableArray *paymentList;
@property (nonatomic, strong) SKMutablePayment *sharedPayment;

// current paying transaction
@property (nonatomic, strong) CYIAPTransaction *payingTransaction;

@property (nonatomic, copy) CYIAPTransactionStateChangedBlock unfinishedIAPCallback;

// a flag indicate that current has unfinished waiting.
// 未完成交易等待机制，是一种处理异步返回票据的方法。当用户在支付过程中，杀掉App进程后，IAP还是又可以继续完成支付，这种情况下，当SKPaymentQueue有SKPaymentTransactionObserver时，就会异步回调SKPaymentTransactionObserver中的方法，返回上次支付完成的SKPaymentTransaction。这种也是支付成功，需要验证票据等操作。由于SKPaymentTransactionObserver中的方法是异步回调，故当注册了SKPaymentTransactionObserver之后，需要等待一段时间，判断会不会有异步返回票据的情况，未完成交易等待机制。按以往的经验，如果有未完成的支付，会在注册了SKPaymentTransactionObserver之后的很短时间收到回调，一般不超过1s，这里采取5s的冗余时间，以支持意外情况
@property (nonatomic, assign) BOOL unfinishedWaiting;
// 是否有为完成交易，当有未完成交易是，需要先处理未完成交易，然后才能进行下一次支付
@property (nonatomic, assign) BOOL hasValidUnfinishedPay;

@end

@implementation CYIAPUtils

- (instancetype)init {
    
    if (self = [super init]) {
        
        _paymentList = [NSMutableArray array];
    }
    return self;
}

#pragma mark - pay
+ (void)addNewIAPWithProductID:(NSString *)productID
                      quantity:(NSUInteger)quantity
                additionalInfo:(NSDictionary *)additionalInfo
                  stateChanged:(CYIAPTransactionStateChangedBlock)stateChanged {
    
    if (!productID
        || quantity <= 0) {
        
        return;
    }
    
    CYIAPTransaction *transaction = [[CYIAPTransaction alloc] init];
    transaction.state = CYIAPTransactionStateStart;
    transaction.productIdentifier = productID;
    transaction.quantity = quantity;
    transaction.additionalInfo = additionalInfo;
    [transaction setStateChangedBlock:stateChanged];
    
    [[CYIAPUtils sharedInstance].paymentList addObject:transaction];
    
    // TODO start pay
    [[CYIAPUtils sharedInstance] startIAPIfNeeded];
}

- (void)startIAPIfNeeded {
    
    if (self.unfinishedWaiting) {
        
        // 未完成支付等待时，不进行下一次支付
        return;
    }
    if (self.payingTransaction) {
        
        // 有其他支付正在进行，不进行下一次支付
        return;
    }
    if (self.hasValidUnfinishedPay) {
        
        // 处理未完成支付，不进行下一次支付
        [self startUnfinishedIAP];
        return;
    }
    
    //TODO 开始支付
    self.payingTransaction = [self.paymentList firstObject];
    if (self.payingTransaction) {
        
        // 保存当前正在支付的Transaction
        [self.paymentList removeObjectAtIndex:0];
        [CYIAPKeychainUtils saveIAPTransaction:self.payingTransaction];
        
        // 配置SKPayment
        if (!self.sharedPayment) {
            
            self.sharedPayment = [[SKMutablePayment alloc] init];
        }
        self.sharedPayment.productIdentifier = self.payingTransaction.productIdentifier;
        self.sharedPayment.quantity = self.payingTransaction.quantity;
        
        // 开始苹果端支付
        [[SKPaymentQueue defaultQueue] addPayment:self.sharedPayment];
    }
}

#pragma mark - 未完成交易
- (void)startUnfinishedIAP {
    
    if (self.hasValidUnfinishedPay
        && self.unfinishedIAPCallback) {
        
        CYIAPTransaction *transaction = [CYIAPKeychainUtils transactionFromKeychain];
        self.payingTransaction = transaction;
        self.unfinishedIAPCallback(transaction);
    }
}

- (BOOL)hasValidUnfinishedPay {
    
    CYIAPTransaction *transaction = [CYIAPKeychainUtils transactionFromKeychain];
    if (transaction
        && transaction.state == CYIAPTransactionStateSuccess
        && transaction.transactionReceipt
        && ![transaction.transactionReceipt isEqualToString:@""]) {
        
        return YES;
    }
    return NO;
}

#pragma mark - 支付等待
- (void)startIAPUnfinishedWaiting {
    
    _unfinishedWaiting = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _unfinishedWaiting = NO;
        // 支付等待完成，如果有必要，进行下一个支付
        [self startIAPIfNeeded];
    });
}

#pragma mark - getter setter

//#pragma mark - SKProductsRequestDelegate
//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
//    
//    NSArray *products = response.products;
//    if (!products
//        || [products count] == 0) {
//        
//        // 获取产品失败
//        _isPaying = NO;
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(IAPPayDidFailedWithError:)]) {
//            
//            [_delegate IAPPayDidFailedWithError:[NSError errorWithDomain:CY_IAP_COMMON_ERROR_DOMAIN
//                                                                    code:-1
//                                                                userInfo:@{ @"msg": @"产品获取失败" }]];
//        }
//    } else {
//        
//        // 取到产品，在此判断数量
//        if (_amount > 0) {
//            
//            _isPaying = YES;
//            SKProduct *product = [products firstObject];
//            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
//            payment.quantity = _amount;
//            [[SKPaymentQueue defaultQueue] addPayment:payment];
//        } else {
//            
//            _isPaying = NO;
//        }
//    }
//}
//
//- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
//    
//    // 获取产品请求失败
//    _isPaying = NO;
//    if ([request isKindOfClass:[SKProductsRequest class]]) {
//        
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(IAPPayDidFailedWithError:)]) {
//            
//            [_delegate IAPPayDidFailedWithError:[NSError errorWithDomain:CY_IAP_COMMON_ERROR_DOMAIN
//                                                                    code:-1
//                                                                userInfo:@{ @"msg": @"产品获取失败" }]];
//        }
//    }
//}
//
//- (void)requestDidFinish:(SKRequest *)request {
//    
//    
//}

#pragma mark - SKPaymentTransactionObserver
// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
// 苹果IAP支付回调方法，支付状态发生变化时，会回调此方法
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    if (!transactions
        || [transactions count] == 0) {
        return;
    }
    
    // 如果没有正在支付的transaction，则从keychain中获取
    if (!self.payingTransaction) {
        
        self.payingTransaction = [CYIAPKeychainUtils transactionFromKeychain];
        [self.payingTransaction setStateChangedBlock:self.unfinishedIAPCallback];
    }
    
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateFailed: {
                
                // 支付失败，结束支付
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                self.payingTransaction.state = CYIAPTransactionStateFailed;
                // 通知游戏
                if (self.payingTransaction.stateChangedBlock) {
                    
                    self.payingTransaction.stateChangedBlock(self.payingTransaction);
                }
                
                [self finishIAPWithTransaction:self.payingTransaction];
                break;
            }
                
            case SKPaymentTransactionStatePurchased: {
                
                // 该方法会验证票据
                [self appleIAPPurchasedWithTransaction:transaction];
                break;
            }
                
            case SKPaymentTransactionStatePurchasing: {
                
                // 支付中
                self.payingTransaction.state = CYIAPTransactionStatePurchasing;
                // 通知游戏
                if (self.payingTransaction.stateChangedBlock) {
                    
                    self.payingTransaction.stateChangedBlock(self.payingTransaction);
                }
                break;
            }
                
            case SKPaymentTransactionStateRestored: {
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [self finishIAPWithTransaction:self.payingTransaction];
                
                break;
            }
                
            default: {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [self finishIAPWithTransaction:self.payingTransaction];
                
                break;
            }
                
        }
        
    }
    
}

- (void)appleIAPPurchasedWithTransaction:(SKPaymentTransaction *)transaction {
    
    NSString *receipt = nil;
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 获取票据
    if([[NSFileManager defaultManager] fileExistsAtPath:[receiptURL path]]) {
        
        // iOS7之后采用这种方式获取，票据放到文件中
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
        receipt = [receiptData base64EncodedStringWithOptions:0];
    } else {
        
        // iOS6之前采用这种方式,票据是transaction一个属性
        receipt = [transaction.transactionReceipt base64EncodedStringWithOptions:0];
    }
    
    if (receipt) {
        
        self.payingTransaction.transactionReceipt = receipt;
        self.payingTransaction.state = CYIAPTransactionStateSuccess;
        
        // 保存交易
        [CYIAPKeychainUtils saveIAPTransaction:self.payingTransaction];
        
        // 保存transaction完成，通知苹果交易结束，此处必须调用，否则苹果会一直回调
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
        // 通知游戏支付成功
        if (self.payingTransaction.stateChangedBlock) {
            
            self.payingTransaction.stateChangedBlock(self.payingTransaction);
        }
    } else {
        
        // 通知苹果交易结束
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
        [self finishIAPWithTransaction:self.payingTransaction];
    }
}

// 结束支付，删除keychain中保存的数据
- (void)finishIAPWithTransaction:(CYIAPTransaction *)transaction {
    
    if ([transaction.transactionIdentifier isEqualToString:self.payingTransaction.transactionIdentifier]) {
        
        self.payingTransaction = nil;
        [CYIAPKeychainUtils removeIAPTransaction];
    }
    
    [self startIAPIfNeeded];
}

#pragma mark - finish IAP
+ (void)finishIAPWithTransaction:(CYIAPTransaction *)transaction {
    
    [[CYIAPUtils sharedInstance] finishIAPWithTransaction:transaction];
}

+ (void)setUnfinishedIAPCallback:(CYIAPTransactionStateChangedBlock)callback {
    
    [CYIAPUtils sharedInstance].unfinishedIAPCallback = callback;
    [[CYIAPUtils sharedInstance] startUnfinishedIAP];
}

#pragma mark - sharedInstance
+ (instancetype)sharedInstance {
    
    static CYIAPUtils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[CYIAPUtils alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:sharedInstance];
        [sharedInstance startIAPUnfinishedWaiting];
    });
    return sharedInstance;
}


@end
