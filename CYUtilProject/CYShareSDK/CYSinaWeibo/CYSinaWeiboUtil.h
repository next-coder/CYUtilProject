//
//  CYSinaWeiboShareUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/24/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYShareBaseUtil.h"

@interface CYSinaWeiboUtil : CYShareBaseUtil

/**
 *  分享网页到微博
 *
 *  不建议使用此接口，建议使用分享文本接口。两者分享出来的效果一样
 *
 *  @param title       标题
 *  @param description 描述
 *  @param thumbImage  缩略图
 *  @param URLString   网页url
 */
- (void)shareWebWithTitle:(NSString *)title
              description:(NSString *)description
           thumbImageData:(NSData *)thumbImageData
                urlString:(NSString *)urlString
                 callback:(CYShareCallback)callback;

/**
 *  分享图片到微博
 *
 *  @param description 描述
 *  @param imageData   图片数据
 */
- (void)shareImageWithDescription:(NSString *)description
                        imageData:(NSData *)imageData
                         callback:(CYShareCallback)callback;

/**
 *  分享文本到微博
 *  
 *  分享网页是，也建议使用此接口，把网页地址包含在文本信息中
 *
 *  @param text 文本
 */
- (void)shareText:(NSString *)text
         callback:(CYShareCallback)callback;

#pragma mark - handle open
- (BOOL)handleOpenURL:(NSURL *)url;

#pragma mark - static
+ (instancetype)sharedInstance;

@end
