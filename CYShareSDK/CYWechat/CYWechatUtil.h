//
//  XNWechatUtil.h
//  MoneyJar2
//
//  Created by XNKJ on 6/4/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYShareBaseUtil.h"

@interface CYWechatUtil : CYShareBaseUtil <UIActionSheetDelegate>

/**
 *  微信登陆
 *
 *  @param from     没有安装微信时，用于web登陆present
 *  @param callback 登陆回调
 */
- (void)startWechatLoginFrom:(UIViewController *)from
                withCallback:(CYThirdPartyLoginCallback)callback;

#pragma mark - share

/**
 *  分享到微信朋友圈
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbData  缩略图
 *  @param URLString   网页url
 */
- (void)shareWebToTimelineWithTitle:(NSString *)title
                        description:(NSString *)description
                          thumbData:(NSData *)thumbData
                          urlString:(NSString *)URLString
                           callback:(CYShareCallback)callback;

/**
 *  分享到微信好友
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbData  缩略图
 *  @param URLString   网页url
 */
- (void)shareWebToSessionWithTitle:(NSString *)title
                       description:(NSString *)description
                         thumbData:(NSData *)thumbData
                         urlString:(NSString *)URLString
                          callback:(CYShareCallback)callback;

/**
 *  分享到微信好友
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbData  缩略图
 *  @param imageUrl       分享图片url
 */
- (void)shareImageToSessionWithTitle:(NSString *)title
                         description:(NSString *)description
                           thumbData:(NSData *)thumbData
                            imageUrl:(NSString *)imageUrl
                           imageData:(NSData *)data
                            callback:(CYShareCallback)callback;

/**
 *  分享到微信朋友圈
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbData  缩略图
 *  @param imageUrl       分享图片url
 */
- (void)shareImageToTimelineWithTitle:(NSString *)title
                          description:(NSString *)description
                            thumbData:(NSData *)thumbData
                             imageUrl:(NSString *)imageUrl
                            imageData:(NSData *)data
                             callback:(CYShareCallback)callback;

/**
 *  分享到微信会话
 *
 *  @param text       文本内容
 */
- (void)shareTextToSession:(NSString *)text
                  callback:(CYShareCallback)callback;

/**
 *  分享到微信朋友圈
 *
 *  @param title       文本内容
 */
- (void)shareTextToTimeline:(NSString *)text
                   callback:(CYShareCallback)callback;

#pragma mark - handle open url
- (BOOL)handleOpenURL:(NSURL *)URL;

#pragma mark - static single
+ (instancetype)sharedInstance;

@end
