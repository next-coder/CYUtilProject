//
//  CYBaseService.m
//  MoneyJar2
//
//  Created by Charry on 15/6/17.
//  Copyright (c) 2015年 Charry. All rights reserved.
//

#import "CYBaseService.h"

@implementation CYBaseService

+ (NSDictionary *)commonRequestParameters {
    
#warning You can add parameters which must contained in all request
    return nil;
}

+ (CYResponseStatusModel *)responseStatusWithResponse:(NSDictionary *)response {
    
#warning You can check the response status code or msg here
    return nil;
//    CYResponseStatusModel *status = nil;
//    if (!response
//        || ![response isKindOfClass:[NSDictionary class]]) {
//        
//        status = [CYResponseStatusModel responseStatusFromCode:1
//                                                       message:@"网络出错啦"];
//        
//    } else {
//        
//        NSInteger code = [response integerValueForKey:@"code"];
//        NSString *msg = [response stringValueForKey:@"msg"];
//        status = [CYResponseStatusModel responseStatusFromCode:code
//                                                       message:msg];
//        
//        if (code == CY_OFFLINE_ERROR_CODE) {
//            
//            status.message = nil;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:kCYShouldLoginNotification
//                                                                    object:self];
//            });
//        }
//    }
//    
//    return status;
}

@end
