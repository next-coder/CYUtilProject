//
//  CYSecurityUtils.m
//  CYUtilProject
//
//  Created by xn011644 on 5/26/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYSecurityUtils.h"

#import <zlib.h>

@implementation CYSecurityUtils

+ (unsigned long)crc32Value:(NSData *)data {

    uLong crc = crc32(0, NULL, 0);
    uLong crcValue = crc32(crc, [data bytes], (uInt)data.length);
    return crcValue;
}

@end
