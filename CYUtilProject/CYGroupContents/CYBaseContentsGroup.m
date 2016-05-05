//
//  CYBaseContentsGroup.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 4/1/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYBaseContentsGroup.h"

@interface CYBaseContentsGroup ()

@property (nonatomic, strong, readwrite) NSArray *contacts;

@end

@implementation CYBaseContentsGroup

- (instancetype)initWithContacts:(NSArray *)contacts {
    
    if (self = [super init]) {
        
        _contacts = contacts;
    }
    return self;
}

- (instancetype)initWithGroupedContacts:(NSDictionary<NSString*, NSArray *> *)groupedContacts
                        sortedGroupKeys:(NSArray<NSString *> *)sortedGroupKeys {
    
    if (self = [super init]) {
        
        _groupedContacts = groupedContacts;
        _sortedGroupKeys = sortedGroupKeys;
    }
    return self;
}

#pragma mark - getter
- (NSArray *)contacts {
    
    if (!_contacts) {
        
        // 没有设置分组前联系人列表时，把所有分组好的联系人列表放入分组前联系人列表
        NSMutableArray *array = [NSMutableArray array];
        [self.sortedGroupKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSArray *contacts = self.groupedContacts[obj];
            if (contacts) {
                
                [array addObjectsFromArray:contacts];
            }
        }];
        
        _contacts  = [array copy];
    }
    return _contacts;
}

@end
