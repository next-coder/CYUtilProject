//
//  CYContactsListAdapter.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CYContactsModel;

typedef NSString* _Nonnull (^CYContactsGroupedBlock)(id<CYContactsModel> _Nonnull contact);
typedef NSComparisonResult (^CYContactsGroupKeySortedBlock)(NSString * _Nonnull key1, NSString * _Nonnull key2);

@interface CYContactsListAdapter : NSObject

/** 初始化数据
 *
 *  如果groupContacts为YES，则使用默认分组方式，分组key采用字母编码升序排序
 *  如果groupContacts为NO，则不对联系人进行分组，直接一个列表显示
 *  默认分组方式为，如果CYContactsModel的nameDescription第一个字母为汉字，则取其拼音首字母为分组关键字，
 *  如果为英文字母，则此字母作为分组关键字，
 *  其他情况分组关键字均为#
 *
 */
- (_Nullable instancetype)initWithContacts:( NSArray<id<CYContactsModel>> * _Nonnull )contacts
                             groupContacts:(BOOL)groupContacts;

/**
 *
 *  使用已经分组好的联系人列表和已经排序完成的分组关键字列表初始化数据
 *  使用此初始化方法会把groupContacts置为YES
 *
 *  注意：关键字列表必须包含所有联系人列表中的关键字，否则可能导致部分联系人无法显示
 *
 */
- (_Nullable instancetype)initWithGroupedContacts:(NSDictionary<NSString*, id<CYContactsModel>> * _Nonnull )groupedContacts
                                  sortedGroupKeys:(NSArray<NSString*> * _Nonnull )sortedGroupKeys;

/**
 *
 *  使用原始联系人列表初始化，并提供分组和分组关键字排序算法进行分组排序
 *  使用此初始化方法会把groupContacts置为YES
 *
 */
- (_Nullable instancetype)initWithContacts:(NSArray<id<CYContactsModel>> * _Nonnull )contacts
                                   groupBy:(CYContactsGroupedBlock _Nonnull )groupBy
                              keysSortedBy:(CYContactsGroupKeySortedBlock _Nonnull )keysSortedBy;

// 是否需要对联系人进行分组
@property (nonatomic, assign, readonly) BOOL groupContacts;

// 分组后的联系人列表，groupContacts为YES时有效
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSString*, NSArray<id<CYContactsModel>> *> *groupedContacts;

// 按一定顺序排列的组关键字，groupContacts为YES时有效
@property (nonatomic, strong, readonly, nullable) NSArray<NSString*> *sortedGroupKeys;

// 未分组的contacts，groupContacts为NO时有效
@property (nonatomic, strong, readonly, nullable) NSArray<id<CYContactsModel>> *contacts;

@end
