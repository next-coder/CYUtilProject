//
//  CYIAPTransaction.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 1/19/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYIAPTransaction.h"

#import "CYIAPUtils.h"

@interface CYIAPTransaction ()

@property (nonatomic, assign, readwrite) CYIAPTransactionState state;

@property (nonatomic, strong, readwrite) NSString *transactionIdentifier;
@property (nonatomic, strong, readwrite) NSString *transactionReceipt;
@property (nonatomic, strong, readwrite) NSString *productIdentifier;
@property (nonatomic, assign, readwrite) NSUInteger quantity;

@property (nonatomic, strong, readwrite) NSDictionary *additionalInfo;

@property (nonatomic, copy, readwrite) CYIAPTransactionStateChangedBlock stateChangedBlock;

@end

@implementation CYIAPTransaction

- (instancetype)init {
    
    if (self = [super init]) {
        
        _transactionIdentifier = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    }
    return self;
}

- (NSString *)description {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:5];
    [dic setObject:[NSNumber numberWithInteger:self.state] forKey:@"state"];
    [dic setObject:[NSNumber numberWithInteger:self.quantity] forKey:@"quantity"];
    if (self.transactionReceipt) {
        
        [dic setObject:self.transactionReceipt forKey:@"transactionReceipt"];
    }
    if (self.productIdentifier) {
        
        [dic setObject:self.productIdentifier forKey:@"productIdentifier"];
    }
    if (self.additionalInfo) {
        
        [dic setObject:self.additionalInfo forKey:@"additionalInfo"];
    }
    if (self.transactionIdentifier) {
        [dic setObject:self.transactionIdentifier forKey:@"transactionIdentifier"];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
