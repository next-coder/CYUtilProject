//
//  UIScreen+CYUtils.m
//  CYUtilProject
//
//  Created by xn011644 on 5/26/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "UIScreen+CYUtils.h"

@implementation UIScreen (CYUtils)

- (CYDeviceScreenType)currentDeviceScreenType {

    CGSize screenSize = self.bounds.size;
    CGFloat screenMaxSide = MAX(screenSize.width, screenSize.height);
    if (screenMaxSide <= 480) {

        return CYDeviceScreenType_3_5;
    } else if (screenMaxSide <= 568) {

        return CYDeviceScreenType_4_0;
    } else if (screenMaxSide <= 667) {

        return CYDeviceScreenType_4_7;
    } else if (screenMaxSide <= 736) {

        return CYDeviceScreenType_5_5;
    } else if (screenMaxSide <= 1024) {

        return CYDeviceScreenType_iPad;
    } else {

        return CYDeviceScreenType_Unknown;
    }
}

- (CGFloat)screenLongerSideLength {

    CGSize screenSize = self.bounds.size;
    return MAX(screenSize.width, screenSize.height);
}

- (CGFloat)screenShorterSideLength {

    CGSize screenSize = self.bounds.size;
    return MIN(screenSize.width, screenSize.height);
}

- (CGFloat)screenWidth {

    return self.bounds.size.width;
}

- (CGFloat)screenHeight {
    
    return self.bounds.size.height;
}

- (NSString *)screenPixelResolution {

    CGFloat width = self.bounds.size.width * self.scale;
    CGFloat height = self.bounds.size.height * self.scale;
    return [NSString stringWithFormat:@"%0.f*%.0f", width, height];
}

@end
