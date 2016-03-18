//
//  CYContactsListAdapter.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYContactsListAdapter.h"
#import "CYContactsModel.h"
#import "pinyin.h"

@interface CYContactsListAdapter ()

@property (nonatomic, strong, readwrite) NSArray<id<CYContactsModel>> *contacts;

@end

@implementation CYContactsListAdapter

- (instancetype)initWithContacts:(NSArray<id<CYContactsModel>> *)contacts
                   groupContacts:(BOOL)groupContacts {
    
    if (self = [super init]) {
        
        _groupContacts = groupContacts;
        _contacts = contacts;
        
        if (_groupContacts) {
            
            [self groupContactsWithDefaultStyle];
            [self sortGroupKeysWithDefaultStyle];
        }
    }
    return self;
}

- (instancetype)initWithGroupedContacts:(NSDictionary<NSString*, NSArray<id<CYContactsModel>> *> *)groupedContacts
                        sortedGroupKeys:(NSArray<NSString *> *)sortedGroupKeys {
    
    if (self = [super init]) {
        
        _groupContacts = YES;
        _groupedContacts = groupedContacts;
        _sortedGroupKeys = sortedGroupKeys;
    }
    return self;
}

- (instancetype)initWithContacts:(NSArray<id<CYContactsModel>> *)contacts
                         groupBy:(CYContactsGroupedBlock)groupBy
                    keysSortedBy:(CYContactsGroupKeySortedBlock)keysSortedBy {
    
    if (self = [super init]) {
        
        _groupContacts = YES;
        _contacts = contacts;
        
        // 对联系人分组
        if (!groupBy) {
            
            [self groupContactsWithDefaultStyle];
        } else {
            
            [self groupContacts:groupBy];
        }
        
        // 联系人分组关键字排序
        if (!keysSortedBy) {
            
            [self sortGroupKeysWithDefaultStyle];
        } else {
            
            // 对所有的分组关键字进行排序
            _sortedGroupKeys = [_groupedContacts.allKeys sortedArrayUsingComparator:keysSortedBy];
        }
    }
    return self;
}

#pragma mark - getter
- (NSArray<id<CYContactsModel>> *)contacts {
    
    if (!_contacts) {
        
        // 没有设置分组前联系人列表时，把所有分组好的联系人列表放入分组前联系人列表
        NSMutableArray *array = [NSMutableArray array];
        [_sortedGroupKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSArray *contacts = _groupedContacts[obj];
            if (contacts) {
                
                [array addObjectsFromArray:contacts];
            }
        }];
        
        _contacts  = [array copy];
    }
    return _contacts;
}

#pragma mark - default group style
- (void)groupContactsWithDefaultStyle {
    
    [self groupContacts:^NSString * _Nonnull(id<CYContactsModel>  _Nonnull contact) {
        
        // 对汉字取拼音首字母大写，其他返回原字符
        char cKey = [contact.cy_nameDescription uppercasePinYinFirstLetter];
        // 非字母全部以#作为关键字
        if (cKey < 'A' || cKey > 'Z') {
            
            cKey = '#';
        }
        
        return [NSString stringWithFormat:@"%c", cKey];
    }];
}

- (void)groupContacts:(CYContactsGroupedBlock)groupBlock {
    
    // 对联系人进行分组
    NSMutableDictionary<NSString*, NSMutableArray<id<CYContactsModel>> *> *dictionary = [NSMutableDictionary dictionary];
    [_contacts enumerateObjectsUsingBlock:^(id<CYContactsModel>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 获取分组key
        NSString *key = groupBlock(obj);
        
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
    NSMutableDictionary<NSString*, NSArray<id<CYContactsModel>> *> *groupedContacts = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *obj, BOOL * _Nonnull stop) {
        
        NSArray *array = [obj sortedArrayUsingComparator:^NSComparisonResult(id<CYContactsModel> obj1, id<CYContactsModel> obj2) {
            
            if (obj1.cy_nameDescription == obj2.cy_nameDescription) {
                
                return NSOrderedSame;
            } else if (!obj1.cy_nameDescription) {
                
                return NSOrderedAscending;
            } else if (!obj2.cy_nameDescription) {
                
                return NSOrderedDescending;
            } else {
                
                return [obj1.cy_nameDescription compare:obj2.cy_nameDescription];
            }
            
        }];
        [groupedContacts setObject:array forKey:key];
    }];
    
    _groupedContacts = [groupedContacts copy];
}

- (void)sortGroupKeysWithDefaultStyle {
    
    // 对所有的分组关键字进行排序
    _sortedGroupKeys = [_groupedContacts.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        
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
