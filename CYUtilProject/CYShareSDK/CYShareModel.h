//
//  CYShareModel.h
//  CYUtilProject
//
//  Created by xn011644 on 13/10/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 分享内容的类型，目前支持文本、链接和图片分享
 */
typedef NS_ENUM(NSInteger, XNShareContenType) {
    XNShareContenTypeText,
    XNShareContenTypeURL,
    XNShareContenTypeImage
};

@interface CYShareModel : NSObject

@property (nonatomic, assign, readonly) XNShareContenType type;

// share title
@property (nonatomic, strong) NSString *title;
// share description
@property (nonatomic, strong) NSString *content;

// thumbnail, available on share url or image
@property (nonatomic, strong) NSData *thumbnail;

// shared url, or image url
// 当type == XNShareContenTypeURL时，此属性不能为空
// 当type == XNShareContenTypeImage时，此属性和data属性不能同时为空，两个都有值时，使用data中的数据
@property (nonatomic, strong) NSString *url;

// Image data
// 当type == XNShareContenTypeImage时，此属性和url属性不能同时为空，两个都有值时，使用data中的数据
@property (nonatomic, strong) NSData *data;

// custom user info
// use this property to store some useful info, which you can use it later
@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, assign, readonly, getter=isValid) BOOL valid;

/**
 * 初始化方法
 */
- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                    thumbnail:(NSData *)thumbnail
                          url:(NSString *)url
                         data:(NSData *)data
                         type:(XNShareContenType)type;

/**
 * 创建文本分享Model
 */
+ (instancetype)textModelWithContent:(NSString *)content;
/**
 * 创建链接分享Model
 */
+ (instancetype)urlModelWithTitle:(NSString *)title
                          content:(NSString *)content
                        thumbnail:(NSData *)thumbnail
                              url:(NSString *)url;
/**
 * 创建图片分享Model
 */
+ (instancetype)imageModelWithTitle:(NSString *)title
                            content:(NSString *)content
                          thumbnail:(NSData *)thumbnail
                               data:(NSData *)data;
/**
 * 创建图片分享Model，数据为网络图片，仅适用于微信分享
 */
+ (instancetype)imageModelWithTitle:(NSString *)title
                            content:(NSString *)content
                          thumbnail:(NSData *)thumbnail
                                url:(NSString *)url;

@end
