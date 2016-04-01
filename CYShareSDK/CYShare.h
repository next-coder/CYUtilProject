//
//  CYShare.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/24/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CYWechatUtil.h"
#import "CYQQUtil.h"
#import "CYSinaWeiboUtil.h"
#import "CYShareBySMSUtil.h"

@interface CYShare : NSObject

@property (nonatomic, weak, readonly) CYWechatUtil *wechatUtil;
@property (nonatomic, weak, readonly) CYQQUtil *qqUtil;
@property (nonatomic, weak, readonly) CYSinaWeiboUtil *sinaWeiboUtil;
@property (nonatomic, weak, readonly) CYShareBySMSUtil *shareBySMSUtil;

#pragma mark - share to wechat
/**
 *  分享网页到微信
 *  弹出ActionSheet让用户选择分享到朋友圈或会话
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbImage  缩略图
 *  @param URLString   网页url
 *  @param view        ActionSheet显示的View
 */
- (void)shareWebToWechatWithTitle:(NSString *)title
                      description:(NSString *)description
                       thumbImage:(NSData *)thumbImage
                        urlString:(NSString *)urlString
              showSelectionInView:(UIView *)view
                         callback:(CYShareCallback)callback;

/**
 *  分享图片到微信
 *  弹出ActionSheet让用户选择分享到朋友圈或会话，
 *  其中imageData和imageUrl只能有一个值
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbImage  缩略图
 *  @param imageData   图片Data
 *  @param imageUrl    图片url
 *  @param view        ActionSheet显示的View
 */
- (void)shareImageToWechatWithTitle:(NSString *)title
                        description:(NSString *)description
                         thumbImage:(NSData *)thumbImage
                          imageData:(NSData *)imageData
                           imageUrl:(NSString *)imageUrl
                showSelectionInView:(UIView *)view
                           callback:(CYShareCallback)callback;

/**
 *  分享文本到微信
 *  弹出ActionSheet让用户选择分享到朋友圈或会话
 *
 *  @param text       文本内容
 *  @param view       ActionSheet显示的View
 */
- (void)shareTextToWechat:(NSString *)text
      showSelectionInView:(UIView *)view
                 callback:(CYShareCallback)callback;

#pragma mark - share to qq
/**
 *  分享网页到QQ
 *  弹出ActionSheet让用户选择分享到QZone或会话
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbImage  缩略图
 *  @param URLString   网页url
 *  @param view        ActionSheet显示的View
 */
- (void)shareWebToQQWithTitle:(NSString *)title
                  description:(NSString *)description
                   thumbImage:(NSData *)thumbImage
                    urlString:(NSString *)urlString
          showSelectionInView:(UIView *)view
                     callback:(CYShareCallback)callback;

/**
 *  分享图片到QQ
 *  弹出ActionSheet让用户选择分享到QZone或会话，
 *  其中imageData和imageUrl只能有一个值
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbImage  缩略图
 *  @param imageData   图片Data
 *  @param view        ActionSheet显示的View
 */
- (void)shareImageToQQWithTitle:(NSString *)title
                    description:(NSString *)description
                     thumbImage:(NSData *)thumbImage
                      imageData:(NSData *)imageData
            showSelectionInView:(UIView *)view
                       callback:(CYShareCallback)callback;

/**
 *  分享文本到QQ
 *  弹出ActionSheet让用户选择分享到QZone或会话
 *
 *  @param text       文本内容
 *  @param view       ActionSheet显示的View
 */
- (void)shareTextToQQ:(NSString *)text
  showSelectionInView:(UIView *)view
             callback:(CYShareCallback)callback;

#pragma mark - handle open
- (BOOL)handleOpenURL:(NSURL *)url;

#pragma mark - static
+ (instancetype)sharedInstance;

@end
