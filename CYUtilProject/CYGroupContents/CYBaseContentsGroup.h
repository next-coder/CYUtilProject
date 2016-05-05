//
//  CYBaseContentsGroup.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 4/1/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NSString* _Nonnull (^CYContactsGroupedBlock)(id _Nonnull contact);
//typedef NSComparisonResult (^CYContactsGroupKeySortedBlock)(NSString * _Nonnull key1, NSString * _Nonnull key2);

@interface CYBaseContentsGroup : NSObject

// 分组后的联系人列表，groupContacts为YES时有效
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSString*, NSArray *> *groupedContacts;

// 按一定顺序排列的组关键字，groupContacts为YES时有效
@property (nonatomic, strong, readonly, nullable) NSArray<NSString*> *sortedGroupKeys;

// 未分组的contacts，groupContacts为NO时有效
@property (nonatomic, strong, readonly, nullable) NSArray *contacts;

/** 初始化数据
 *
 *  如果groupContacts为YES，则使用默认分组方式，分组key采用字母编码升序排序
 *  如果groupContacts为NO，则不对联系人进行分组，直接一个列表显示
 *  默认分组方式为，如果CYContactsModel的nameDescription第一个字母为汉字，则取其拼音首字母为分组关键字，
 *  如果为英文字母，则此字母作为分组关键字，
 *  其他情况分组关键字均为#
 *
 */
- (_Nullable instancetype)initWithContacts:( NSArray * _Nonnull )contacts;

/**
 *
 *  使用已经分组好的联系人列表和已经排序完成的分组关键字列表初始化数据
 *  使用此初始化方法会把groupContacts置为YES
 *
 *  注意：关键字列表必须包含所有联系人列表中的关键字，否则可能导致部分联系人无法显示
 *
 */
- (_Nullable instancetype)initWithGroupedContacts:(NSDictionary<NSString*, id> * _Nonnull )groupedContacts
                                  sortedGroupKeys:(NSArray<NSString*> * _Nonnull )sortedGroupKeys;

@end
