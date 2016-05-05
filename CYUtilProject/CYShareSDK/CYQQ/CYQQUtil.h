//
//  CYQQUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/10/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYShareBaseUtil.h"

@interface CYQQUtil : CYShareBaseUtil

#pragma mark - share url
/**
 *  分享到qq会话
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbImage  缩略图
 *  @param URLString   网页url
 */
- (void)shareWebToQQWithTitle:(NSString *)title
                  description:(NSString *)description
               thumbImageData:(NSData *)thumbImageData
                    urlString:(NSString *)urlString
                     callback:(CYShareCallback)callback;

/**
 *  分享到qzone
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbImage  缩略图
 *  @param URLString   网页url
 */
- (void)shareWebToQZoneWithTitle:(NSString *)title
                     description:(NSString *)description
                  thumbImageData:(NSData *)thumbImageData
                       urlString:(NSString *)urlString
                        callback:(CYShareCallback)callback;

#pragma mark - share image
/**
 *  分享到qq会话
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbImage  缩略图
 *  @param imageData   图片数据
 */
- (void)shareImageToQQWithTitle:(NSString *)title
                    description:(NSString *)description
                 thumbImageData:(NSData *)thumbImageData
                      imageData:(NSData *)imageData
                       callback:(CYShareCallback)callback;

/**
 *  分享到qzone
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbImage  缩略图
 *  @param imageData   图片数据
 */
- (void)shareImageToQZoneWithTitle:(NSString *)title
                       description:(NSString *)description
                    thumbImageData:(NSData *)thumbImageData
                         imageData:(NSData *)imageData
                          callback:(CYShareCallback)callback;

/**
 *  分享到qq会话
 *
 *  @param title       文本内容
 */
- (void)shareTextToQQ:(NSString *)text
             callback:(CYShareCallback)callback;

/**
 *  分享到qzone
 *
 *  @param title       文本内容
 */
- (void)shareTextToQZone:(NSString *)text
                callback:(CYShareCallback)callback;


#pragma mark - handle open
- (BOOL)handleOpenURL:(NSURL *)url;

#pragma mark - sharedInstance
+ (instancetype)sharedInstance;

@end
