//
//  CYAddressBookUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/27/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <AddressBook/AddressBook.h>

#import "CYAddressBookUtils.h"

@interface CYAddressBookUtils ()

@property (nonatomic, assign) ABAddressBookRef addressBook;

@end

@implementation CYAddressBookUtils

- (void)dealloc {
    
    if (_addressBook) {
        
        CFRelease(_addressBook);
    }
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    return self;
}

#pragma mark - 通讯录
- (CYAddressBookAuthorizedStatus)addressBookGetAuthorizationStatus {
    
    CYAddressBookAuthorizedStatus status = CYAddressBookAuthorizedStatusAuthorized;
    
    ABAuthorizationStatus abStatus = ABAddressBookGetAuthorizationStatus();
    switch (abStatus) {
        case kABAuthorizationStatusNotDetermined: {
            
            status = CYAddressBookAuthorizedStatusNotDetermine;
            break;
        }
            
        case kABAuthorizationStatusRestricted: {
            
            status = CYAddressBookAuthorizedStatusRestricted;
            break;
        }
            
        case kABAuthorizationStatusDenied: {
            
            status = CYAddressBookAuthorizedStatusDenied;
            break;
        }
            
        case kABAuthorizationStatusAuthorized: {
            
            status = CYAddressBookAuthorizedStatusAuthorized;
            break;
        }
            
        default:
            break;
    }
    
    return status;
}

- (void)requestAddressBookAccessWithCompletion:(void (^)(BOOL granted, NSError *error))completion {
    
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        
        if (completion) {
            
            completion(granted ? YES : NO, (__bridge NSError *)error);
        }
    });
}

- (NSArray *)fetchAllPeopleInAddressBookWithNameFormat:(CYAddressBookNameFormat)format {
    
    NSMutableArray *allPeople = [NSMutableArray arrayWithCapacity:0];
    NSArray *allSources = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(self.addressBook);
    
    if (allSources
        && [allSources count] > 0) {
        
        for (id source in allSources) {
            
            ABRecordRef person = (__bridge void*)source;
            
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            
            NSString *fullName = nil;
            switch (format) {
                case CYAddressBookNameFormatFirstNameFirst: {
                    
                    fullName = [NSString stringWithFormat:@"%@%@", firstName ? firstName : @"", lastName ? lastName : @""];
                    break;
                }
                    
                case CYAddressBookNameFormatLastNameFirst:
                default: {
                    fullName = [NSString stringWithFormat:@"%@%@", lastName ? lastName : @"", firstName ? firstName : @""];
                    break;
                }
            }
            
            //处理联系人电话号码
            ABMultiValueRef  phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for(int i = 0; i < ABMultiValueGetCount(phones); i++)
            {
                
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
                NSString * phoneNumber = (__bridge NSString *)phoneNumberRef;
                phoneNumber = [self phoneNumberWithRemovePrefix:phoneNumber];
                phoneNumber = [self phoneNumberWithRemoveMiddleLine:phoneNumber];
                
                if (phoneNumber
                    && [self validateMobile:phoneNumber]
                    && fullName) {
                    
                    [allPeople addObject:[NSDictionary dictionaryWithObject:fullName forKey:phoneNumber]];
                }
                CFRelease(phoneNumberRef);
            }
            
            if (phones) {
                
                CFRelease((CFStringRef)phones);
            }
            
        }
    }
    
    if (allSources) {
        
        CFRelease((CFArrayRef)allSources);
    }
    
    return allPeople;
}

#pragma mark - 处理电话号码
// 检查手机号是否合法
- (BOOL)validateMobile:(NSString *)mobile
{
    if ([mobile length] == 0) {
        return NO;
    }
    // 1开头都可以
    NSString *mobileRegex = @"^1\\d{10}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:mobile];
}

// 删除电话开头的+86
- (NSString *)phoneNumberWithRemovePrefix:(NSString *)phoneNumber {
    
    if (phoneNumber
        && [phoneNumber hasPrefix:@"+86"]) {
        
        return [phoneNumber substringFromIndex:3];
    }
    return phoneNumber;
}

// 删除电话中的-，(，)，空格
- (NSString *)phoneNumberWithRemoveMiddleLine:(NSString *)phoneNumber {
    
    NSString *phone = phoneNumber;
    if (phone) {
        
        phone = [phone stringByReplacingOccurrencesOfString:@"[-\\(\\)\\s]"
                                                 withString:@""
                                                    options:NSRegularExpressionSearch
                                                      range:NSMakeRange(0, phone.length)];
    }
    return phone;
}

@end
