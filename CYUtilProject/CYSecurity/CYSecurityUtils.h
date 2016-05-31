//
//  CYSecurityUtils.h
//  CYUtilProject
//
//  Created by xn011644 on 5/26/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYSecurityUtils : NSObject

+ (unsigned long)crc32Value:(NSData *)data;

@end
