//
//  CYAddressBookUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/27/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CYAddressBookAuthorizedStatus) {
    
    CYAddressBookAuthorizedStatusNotDetermine,      // 未决定
    CYAddressBookAuthorizedStatusRestricted,         // 受限访问
    CYAddressBookAuthorizedStatusDenied,            // 拒绝访问
    CYAddressBookAuthorizedStatusAuthorized,        // 允许访问
};

typedef NS_ENUM(NSInteger, CYAddressBookNameFormat)  {
    
    CYAddressBookNameFormatFirstNameFirst,          // first name 在前
    CYAddressBookNameFormatLastNameFirst            // last name 在前
};

@interface CYAddressBookUtils : NSObject

// fectch list @[@{phonenumber: fullname}]
- (NSArray *)fetchAllPeopleInAddressBookWithNameFormat:(CYAddressBookNameFormat)format;

// address book authorization
- (void)requestAddressBookAccessWithCompletion:(void (^)(BOOL granted, NSError *error))completion;
- (CYAddressBookAuthorizedStatus)addressBookGetAuthorizationStatus;

@end
