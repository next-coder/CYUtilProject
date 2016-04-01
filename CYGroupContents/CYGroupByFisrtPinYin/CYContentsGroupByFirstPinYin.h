//
//  CYContactsListAdapter.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYBaseContentsGroup.h"

typedef NSString *(^CYGroupByFirstPinYinGetProperty)(id content);

@interface CYContentsGroupByFirstPinYin : CYBaseContentsGroup

@property (nonatomic, copy, readonly) CYGroupByFirstPinYinGetProperty groupByPropertyBlock;

/**
 *
 *  待分组的contacts和获取分组依据的property回调，来初始化
 *
 */
- (instancetype)initWithContacts:(NSArray *)contacts
                 groupByProperty:(CYGroupByFirstPinYinGetProperty)property;

@end
