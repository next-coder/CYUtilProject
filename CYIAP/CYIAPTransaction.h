//
//  CYIAPTransaction.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 1/19/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CYIAPTransactionState) {
    
    CYIAPTransactionStateStart,
    CYIAPTransactionStatePurchasing,
    CYIAPTransactionStateFailed,
    CYIAPTransactionStateSuccess
};

@interface CYIAPTransaction : NSObject

@property (nonatomic, assign, readonly) CYIAPTransactionState state;

@property (nonatomic, strong, readonly) NSString *transactionReceipt;
@property (nonatomic, strong, readonly) NSString *productIdentifier;
@property (nonatomic, strong, readonly) NSString *quantity;

@property (nonatomic, strong, readonly) NSDictionary *additionalInfo;

@end
