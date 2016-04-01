//
//  CYContactsListAdapter.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYContentsGroupByFirstPinYin.h"
#import "pinyin.h"

@interface CYContentsGroupByFirstPinYin ()

@property (nonatomic, strong) NSDictionary *internalGroupedContacts;
@property (nonatomic, strong) NSArray *internalSortedGroupKeys;

@end

@implementation CYContentsGroupByFirstPinYin

- (instancetype)initWithContacts:(NSArray *)contacts
                 groupByProperty:(CYGroupByFirstPinYinGetProperty)property {
    
    if (self = [super initWithContacts:contacts]) {
        
        _groupByPropertyBlock = property;
        
        [self groupContacts];
        [self sortGroupKeys];
    }
    return self;
}

#pragma mark - getter
- (NSDictionary<NSString*, NSArray*> *)groupedContacts {
    
    return self.internalGroupedContacts;
}

- (NSArray<NSString *> *)sortedGroupKeys {
    
    return self.internalSortedGroupKeys;
}

#pragma mark - default group style

- (void)groupContacts {
    
    // 对联系人进行分组
    NSMutableDictionary<NSString*, NSMutableArray *> *dictionary = [NSMutableDictionary dictionary];
    [self.contacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 获取分组key
        NSString *key = _groupByPropertyBlock(obj);
        
        // 对汉字取拼音首字母大写，其他返回原字符
        char cKey = [key uppercasePinYinFirstLetter];
        // 非字母全部以#作为关键字
        if (cKey < 'A' || cKey > 'Z') {
            
            cKey = '#';
        }
        
        // 组内已分组其他元素列表
        NSMutableArray *array = [dictionary objectForKey:key];
        if (!array) {
            
            // 如果之前没有过，则新建数组
            array = [NSMutableArray array];
            [dictionary setObject:array forKey:key];
        }
        [array addObject:obj];
    }];
    
    // 对分组后的联系人，在每组内再进行排序
    NSMutableDictionary<NSString*, NSArray *> *groupedContacts = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *obj, BOOL * _Nonnull stop) {
        
        NSArray *array = [obj sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            // 获取分组key
            NSString *key1 = _groupByPropertyBlock(obj1);
            NSString *key2 = _groupByPropertyBlock(obj2);
            
            if (key1 == key2) {
                
                return NSOrderedSame;
            } else if (!key1) {
                
                return NSOrderedAscending;
            } else if (!key2) {
                
                return NSOrderedDescending;
            } else {
                
                return [key1 compare:key2];
            }
            
        }];
        [groupedContacts setObject:array forKey:key];
    }];
    
    _internalGroupedContacts = [groupedContacts copy];
}

- (void)sortGroupKeys {
    
    // 对所有的分组关键字进行排序
    _internalSortedGroupKeys = [_internalGroupedContacts.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        
        // #放在最后面
        if ([obj1 isEqualToString:@"#"]) {
            
            return NSOrderedDescending;
        } else if ([obj2 isEqualToString:@"#"]) {
            
            return NSOrderedAscending;
        } else {
            
            // 其他按字符串升序排列
            return [obj1 compare:obj2];
        }
    }];
}

@end
