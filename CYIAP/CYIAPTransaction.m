//
//  CYIAPTransaction.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 1/19/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYIAPTransaction.h"

@interface CYIAPTransaction ()

@property (nonatomic, assign, readwrite) CYIAPTransactionState state;

@property (nonatomic, strong, readwrite) NSString *transactionReceipt;
@property (nonatomic, strong, readwrite) NSString *productIdentifier;
@property (nonatomic, strong, readwrite) NSString *quantity;

@property (nonatomic, strong, readwrite) NSDictionary *additionalInfo;

@end

@implementation CYIAPTransaction

@end
