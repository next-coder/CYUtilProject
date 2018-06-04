//
//  CYSinaWeiboShareUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/24/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYShareCtrlFlag.h"

#if CY_SINA_WEIBO_ENABLED
#import "CYBaseShare.h"

@class CYShareModel;

/**
 * 分享到微博
 *
 * 此类采用单例模式，请直接使用sharedInstance，不要创建新实例
 */
@interface CYSinaWeibo : CYBaseShare

/**
 * 分享到微博
 * 分享网页时，建议以文本的形式分享，把网页链接拼接到文本中
 */
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback;

#pragma mark - static
+ (instancetype)sharedInstance;

@end

#endif
