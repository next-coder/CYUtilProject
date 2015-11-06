//
//  CYIAPKeychainUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CY_IAP_KEY_CHAIN_ERROR_DOMAIN   @"CYIAPKeychainError"

@interface CYIAPKeychainUtils : NSObject

// 保存票据
+ (void)saveReceipt:(NSString *)receipt
     additionalInfo:(NSString *)additionalInfo;
+ (void)saveReceipt:(NSString *)receipt;
+ (void)saveReceiptAdditionalInfo:(NSString *)additionalInfo;

// 获取
+ (NSString *)receiptFromKeychain;
+ (NSString *)receiptAddtionalInfoFromKeychain;

// 删除
+ (void)removeReceiptFromKeychainWithAdditionalInfo:(BOOL)removeAdditionalInfo;
+ (void)removeReceiptAdditionalInfo;

@end
