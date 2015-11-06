//
//  CYIAPKeychainUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYIAPKeychainUtils.h"

#define CY_IAP_RECEIPT_KEY_CHAIN_SERVICE                    @"CYIAPReceiptKeyChainService"
#define CY_IAP_RECEIPT_ADDITIONAL_INFO_KEY_CHAIN_SERVICE    @"CYIAPReceiptAdditionalInfoKeyChainService"

@implementation CYIAPKeychainUtils

+ (void)saveReceipt:(NSString *)receipt
     additionalInfo:(NSString *)additionalInfo {
    
    [self saveReceipt:receipt];
    [self saveReceiptAdditionalInfo:additionalInfo];
}

+ (void)saveReceipt:(NSString *)receipt {
    
    [self storeObject:receipt
               forKey:CY_IAP_RECEIPT_KEY_CHAIN_SERVICE
          serviceName:CY_IAP_RECEIPT_KEY_CHAIN_SERVICE];
}

+ (void)saveReceiptAdditionalInfo:(NSString *)additionalInfo {
    
    [self storeObject:additionalInfo
               forKey:CY_IAP_RECEIPT_ADDITIONAL_INFO_KEY_CHAIN_SERVICE
          serviceName:CY_IAP_RECEIPT_ADDITIONAL_INFO_KEY_CHAIN_SERVICE];
}

+ (NSString *)receiptFromKeychain {
    
    return [self objectForKey:CY_IAP_RECEIPT_KEY_CHAIN_SERVICE
                  serviceName:CY_IAP_RECEIPT_KEY_CHAIN_SERVICE];
}

+ (NSString *)receiptAddtionalInfoFromKeychain {
    
    return [self objectForKey:CY_IAP_RECEIPT_ADDITIONAL_INFO_KEY_CHAIN_SERVICE
                  serviceName:CY_IAP_RECEIPT_ADDITIONAL_INFO_KEY_CHAIN_SERVICE];
}

+ (void)removeReceiptFromKeychainWithAdditionalInfo:(BOOL)removeAdditionalInfo {
    
    [self deleteItemInKeychainForKey:CY_IAP_RECEIPT_KEY_CHAIN_SERVICE
                      andServiceName:CY_IAP_RECEIPT_KEY_CHAIN_SERVICE
                               error:NULL];
    if (removeAdditionalInfo) {
        
        [self removeReceiptAdditionalInfo];
    }
}

+ (void)removeReceiptAdditionalInfo {
    
    [self deleteItemInKeychainForKey:CY_IAP_RECEIPT_ADDITIONAL_INFO_KEY_CHAIN_SERVICE
                      andServiceName:CY_IAP_RECEIPT_ADDITIONAL_INFO_KEY_CHAIN_SERVICE
                               error:NULL];
}

#pragma mark - generic method

+ (NSString *)objectForKey:(NSString *)theKey serviceName:(NSString *)serviceName
{
    NSError *error = nil;
    NSString *object = [self fetchValueInKeychainForKey:theKey
                                         andServiceName:serviceName
                                                  error:&error];
    
    return object;
} /* objectForKey */


+ (void)storeObject:(NSString *)object forKey:(NSString *)theKey serviceName:(NSString *)serviceName
{
    NSString *objectString = object;
    NSError *error = nil;
    
    [self writeValueToKeychain:objectString
                       withKey:theKey
                forServiceName:serviceName
                updateExisting:YES
                         error:&error];
} /* storeObject */

+ (BOOL)checkKeyChainExistWithKey:(NSString *)aKey serviceName:(NSString *)serviceName
{
    NSError *error = nil;
    NSString *value = [self fetchValueInKeychainForKey:aKey
                                        andServiceName:serviceName
                                                 error:&error];
    
    if (nil == value && nil == error) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Private Methods

#if USE_MAC_KEYCHAIN_API

+ (NSString *)fetchValueInKeychainForKey:(NSString *)theKey
                          andServiceName:(NSString *)serviceName
                                   error:(NSError **)error
{
    if (!theKey || !serviceName) {
        *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:-2000 userInfo:nil];
        return nil;
    }
    
    SecKeychainItemRef item = [WMKeychain fetchKeychainItemReferenceFortheKey:theKey andServiceName:serviceName error:error];
    if (*error || !item) {
        return nil;
    }
    
    // from Advanced Mac OS X Programming, ch. 16
    UInt32 length;
    char *password;
    SecKeychainAttribute attributes[8];
    SecKeychainAttributeList list;
    
    attributes[0].tag = kSecAccountItemAttr;
    attributes[1].tag = kSecDescriptionItemAttr;
    attributes[2].tag = kSecLabelItemAttr;
    attributes[3].tag = kSecModDateItemAttr;
    
    list.count = 4;
    list.attr = attributes;
    
    OSStatus status = SecKeychainItemCopyContent(item, NULL, &list, &length, (void **)&password);
    
    if (status != noErr) {
        *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:status userInfo:nil];
        return nil;
    }
    
    NSString *passwordString = nil;
    
    if (password != NULL) {
        char passwordBuffer[1024];
        
        if (length > 1023) {
            length = 1023;
        }
        strncpy(passwordBuffer, password, length);
        
        passwordBuffer[length] = '\0';
        passwordString = [NSString stringWithCString:passwordBuffer encoding:NSUTF8StringEncoding];
    }
    
    SecKeychainItemFreeContent(&list, password);
    
    CFRelease(item);
    
    return passwordString;
} /* fetchValueInKeychainForKey */

+ (BOOL)writeValueToKeychain:(NSString *)theValue
                     withKey:(NSString *)theKey
              forServiceName:(NSString *)serviceName
              updateExisting:(BOOL)updateExisting
                       error:(NSError **)error
{
    if (!theKey || !theValue || !serviceName) {
        *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:-2000 userInfo:nil];
        return NO;
    }
    
    OSStatus status = noErr;
    
    SecKeychainItemRef item = [WMKeychain fetchKeychainItemReferenceFortheKey:theKey andServiceName:serviceName error:error];
    
    if (*error && [*error code] != noErr) {
        return NO;
    }
    
    *error = nil;
    
    if (item) {
        status = SecKeychainItemModifyAttributesAndData(item,
                                                        NULL,
                                                        (UInt32)[theValue lengthOfBytesUsingEncoding: NSUTF8StringEncoding],
                                                        [theValue UTF8String]);
        
        CFRelease(item);
    } else {
        status = SecKeychainAddGenericPassword(NULL,
                                               (UInt32)[serviceName lengthOfBytesUsingEncoding: NSUTF8StringEncoding],
                                               [serviceName UTF8String],
                                               (UInt32)[theKey lengthOfBytesUsingEncoding: NSUTF8StringEncoding],
                                               [theKey UTF8String],
                                               (UInt32)[theValue lengthOfBytesUsingEncoding: NSUTF8StringEncoding],
                                               [theValue UTF8String],
                                               NULL);
    }
    
    if (status != noErr) {
        *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:status userInfo:nil];
        return NO;
    }
    
    return YES;
} /* writeValueToKeychain */

+ (BOOL)deleteItemFortheKey:(NSString *)theKey
             andServiceName:(NSString *)serviceName
                      error:(NSError **)error
{
    if (!theKey || !serviceName) {
        *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:2000 userInfo:nil];
        return NO;
    }
    
    *error = nil;
    
    SecKeychainItemRef item = [WMKeychain fetchKeychainItemReferenceFortheKey:theKey andServiceName:serviceName error:error];
    
    if (*error && [*error code] != noErr) {
        return NO;
    }
    
    OSStatus status;
    
    if (item) {
        status = SecKeychainItemDelete(item);
        
        CFRelease(item);
    }
    
    if (status != noErr) {
        *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:status userInfo:nil];
        return NO;
    }
    
    return YES;
} /* deleteItemFortheKey */

// NOTE: Item reference passed back by reference must be released!
+ (SecKeychainItemRef)fetchKeychainItemReferenceFortheKey:(NSString *)theKey
                                           andServiceName:(NSString *)serviceName
                                                    error:(NSError **)error
{
    if (!theKey || !serviceName) {
        *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:-2000 userInfo:nil];
        return nil;
    }
    
    *error = nil;
    
    SecKeychainItemRef item;
    
    OSStatus status = SecKeychainFindGenericPassword(NULL,
                                                     (UInt32)[serviceName lengthOfBytesUsingEncoding: NSUTF8StringEncoding],
                                                     [serviceName UTF8String],
                                                     (UInt32)[theKey lengthOfBytesUsingEncoding: NSUTF8StringEncoding],
                                                     [theKey UTF8String],
                                                     NULL,
                                                     NULL,
                                                     &item);
    
    if (status != noErr) {
        if (status != errSecItemNotFound) {
            *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:status userInfo:nil];
        }
        
        return nil;
    }
    
    return item;
} /* fetchKeychainItemReferenceFortheKey */

#else /* if USE_MAC_KEYCHAIN_API */

+ (NSString *)fetchValueInKeychainForKey:(NSString *)theKey
                          andServiceName:(NSString *)serviceName
                                   error:(NSError **)error
{
    if (!theKey || !serviceName) {
        if (error != nil) {
            *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:-2000 userInfo:nil];
        }
        return nil;
    }
    
    if (error != nil) {
        *error = nil;
    }
    
    // Set up a query dictionary with the base query attributes: item type (generic), theKey, and service
    
    NSArray *keys = [[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrAccount, kSecAttrService, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, theKey, serviceName, nil];
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
    
    // First do a query for attributes, in case we already have a Keychain item with no password data set.
    // One likely way such an incorrect item could have come about is due to the previous (incorrect)
    // version of this code (which set the password as a generic attribute instead of password data).
    
    NSMutableDictionary *attributeQuery = [query mutableCopy];
    [attributeQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
    
    CFDictionaryRef cfDic = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)attributeQuery, (CFTypeRef *)&cfDic);
    
    if (cfDic) {
        
        CFRelease(cfDic);
    }
    
    if (status != noErr) {
        // No existing item found--simply return nil for the password
        if (error != nil && status != errSecItemNotFound) {
            // Only return an error if a real exception happened--not simply for "not found."
            *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:status userInfo:nil];
        }
        
        return nil;
    }
    
    // We have an existing item, now query for the password data associated with it.
    
    NSMutableDictionary *passwordQuery = [query mutableCopy];
    [passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    CFDataRef cfData = nil;
    status = SecItemCopyMatching((CFDictionaryRef)passwordQuery, (CFTypeRef *)&cfData);
    
    NSData *resultData = (__bridge_transfer NSData*)cfData;
    
    if (status != noErr) {
        if (status == errSecItemNotFound) {
            // We found attributes for the item previously, but no password now, so return a special error.
            // Users of this API will probably want to detect this error and prompt the user to
            // re-enter their credentials.  When you attempt to store the re-entered credentials
            // using writeValueToKeychain:andPassword:forServiceName:updateExisting:error
            // the old, incorrect entry will be deleted and a new one with a properly encrypted
            // password will be added.
            if (error != nil) {
                *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:-1999 userInfo:nil];
            }
        } else if (error != nil) {
            // Something else went wrong. Simply return the normal Keychain API error code.
            *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:status userInfo:nil];
        }
        
        return nil;
    }
    
    NSString *valueTobeFetched = nil;
    
    if (resultData) {
        valueTobeFetched = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    } else if (error != nil) {
        // There is an existing item, but we weren't able to get password data for it for some reason,
        // Possibly as a result of an item being incorrectly entered by the previous code.
        // Set the -1999 error so the code above us can prompt the user again.
        *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:-1999 userInfo:nil];
    }
    
    return valueTobeFetched;
} /* fetchValueInKeychainForKey */

+ (BOOL)writeValueToKeychain:(NSString *)theValue
                     withKey:(NSString *)theKey
              forServiceName:(NSString *)serviceName
              updateExisting:(BOOL)updateExisting
                       error:(NSError **)error
{
    if (!theKey || !theValue || !serviceName) {
        if (error != nil) {
            *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:-2000 userInfo:nil];
        }
        
        return NO;
    }
    
    // See if we already have a password entered for these credentials.
    NSError *getError = nil;
    NSString *existingValueInKeychain = [self fetchValueInKeychainForKey:theKey andServiceName:serviceName error:&getError];
    
    if ([getError code] == -1999) {
        // There is an existing entry without a password properly stored (possibly as a result of the previous incorrect version of this code.
        // Delete the existing item before moving on entering a correct one.
        
        getError = nil;
        
        [self deleteItemInKeychainForKey:theKey andServiceName:serviceName error:&getError];
        
        if ([getError code] != noErr) {
            if (error != nil) {
                *error = getError;
            }
            return NO;
        }
    } else if ([getError code] != noErr) {
        if (error != nil) {
            *error = getError;
        }
        return NO;
    }
    
    if (error != nil) {
        *error = nil;
    }
    
    OSStatus status = noErr;
    
    if (existingValueInKeychain) {
        // We have an existing, properly entered item with a password.
        // Update the existing item.
        
        if (![existingValueInKeychain isEqualToString:theValue] && updateExisting) {
            // Only update if we're allowed to update existing.  If not, simply do nothing.
            
            NSArray *keys = [[NSArray alloc] initWithObjects:(NSString *)kSecClass,
                              kSecAttrService,
                              kSecAttrLabel,
                              kSecAttrAccount,
                              nil];
            
            NSArray *objects = [[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword,
                                 serviceName,
                                 serviceName,
                                 theKey,
                                 nil];
            
            NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            
            status = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)[NSDictionary
                                                                             dictionaryWithObject:[theValue dataUsingEncoding:NSUTF8StringEncoding]
                                                                             forKey: (NSString *)kSecValueData]);
        }
    } else {
        // No existing entry (or an existing, improperly entered, and therefore now
        // deleted, entry).  Create a new entry.
        
        NSArray *keys = [[NSArray alloc] initWithObjects:(NSString *)kSecClass,
                          kSecAttrService,
                          kSecAttrLabel,
                          kSecAttrAccount,
                          kSecValueData,
                          nil];
        
        NSArray *objects = [[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword,
                             serviceName,
                             serviceName,
                             theKey,
                             [theValue dataUsingEncoding:NSUTF8StringEncoding],
                             nil];
        
        NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        
        status = SecItemAdd((CFDictionaryRef)query, NULL);
    }
    
    if (status != noErr) {
        // Something went wrong with adding the new item. Return the Keychain error code.
        if (error != nil) {
            *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:status userInfo:nil];
        }
        return NO;
    }
    
    return YES;
} /* writeValueToKeychain */

+ (BOOL)deleteItemInKeychainForKey:(NSString *)theKey
                    andServiceName:(NSString *)serviceName
                             error:(NSError **)error
{
    if (!theKey || !serviceName) {
        if (error != nil) {
            *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:-2000 userInfo:nil];
        }
        return NO;
    }
    
    if (error != nil) {
        *error = nil;
    }
    
    NSArray *keys = [[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes,
                      nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, theKey, serviceName, kCFBooleanTrue, nil];
    
    NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    OSStatus status = SecItemDelete((CFDictionaryRef)query);
    
    if (status != noErr) {
        if (error != nil) {
            *error = [NSError errorWithDomain:CY_IAP_KEY_CHAIN_ERROR_DOMAIN code:status userInfo:nil];
        }
        return NO;
    }
    
    return YES;
} /* deleteItemInKeychainForKey */

#endif /* if USE_MAC_KEYCHAIN_API */

@end
