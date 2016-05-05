//
//  CYShare.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/24/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYShare.h"

@interface CYShare () <UIActionSheetDelegate>

// 分享的title
@property (nonatomic, copy) NSString *shareTitle;
// 分享的描述，文本分享时，为待分享文本
@property (nonatomic, copy) NSString *shareDescription;
// 网页分享的url
@property (nonatomic, copy) NSString *shareURLString;
// 分享的thumb图片，不能超过32k
@property (nonatomic, strong) NSData *shareThumbImage;
// 图片分享时，图片的Data
@property (nonatomic, strong) NSData *shareImageData;
// 图片分享时，图片的url，与shareImageData只能存在一个。仅微信支持
@property (nonatomic, copy) NSString *shareImageUrl;

// callback after share
@property (nonatomic, copy) CYShareCallback shareCallback;

@end

@implementation CYShare

static const NSInteger wechatWebShareActionSheetTag = 58723;
static const NSInteger wechatImageShareActionSheetTag = 58724;
static const NSInteger wechatTextShareActionSheetTag = 58725;
static const NSInteger qqWebShareActionSheetTag = 58726;
static const NSInteger qqImageShareActionSheetTag = 58727;
static const NSInteger qqTextShareActionSheetTag = 58728;

#pragma mark - getter
- (CYWechatUtil *)wechatUtil {
    
    return [CYWechatUtil sharedInstance];
}

- (CYQQUtil *)qqUtil {
    
    return [CYQQUtil sharedInstance];
}

- (CYSinaWeiboUtil *)sinaWeiboUtil {
    
    return [CYSinaWeiboUtil sharedInstance];
}

- (CYShareBySMSUtil *)shareBySMSUtil {
    
    return [CYShareBySMSUtil sharedInstance];
}

#pragma mark - share to wechat
- (void)shareWebToWechatWithTitle:(NSString *)title
                      description:(NSString *)description
                       thumbImage:(NSData *)thumbImage
                        urlString:(NSString *)urlString
              showSelectionInView:(UIView *)view
                         callback:(CYShareCallback)callback {
    
    self.shareTitle = title;
    self.shareDescription = description;
    self.shareThumbImage = thumbImage;
    self.shareURLString = urlString;
    self.shareCallback = callback;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"分享到微信朋友圈", @"分享给微信好友", nil];
    actionSheet.tag = wechatWebShareActionSheetTag;
    [actionSheet showInView:view];
    
}

- (void)shareImageToWechatWithTitle:(NSString *)title
                        description:(NSString *)description
                         thumbImage:(NSData *)thumbImage
                          imageData:(NSData *)imageData
                           imageUrl:(NSString *)imageUrl
                showSelectionInView:(UIView *)view
                           callback:(CYShareCallback)callback {
    
    self.shareTitle = title;
    self.shareDescription = description;
    self.shareThumbImage = thumbImage;
    self.shareImageData = imageData;
    self.shareImageUrl = imageUrl;
    self.shareCallback = callback;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"分享到微信朋友圈", @"分享给微信好友", nil];
    actionSheet.tag = wechatImageShareActionSheetTag;
    [actionSheet showInView:view];
}

- (void)shareTextToWechat:(NSString *)text
      showSelectionInView:(UIView *)view
                 callback:(CYShareCallback)callback {
    
    self.shareDescription = text;
    self.shareCallback = callback;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"分享到微信朋友圈", @"分享给微信好友", nil];
    actionSheet.tag = wechatTextShareActionSheetTag;
    [actionSheet showInView:view];
}

#pragma mark - share to qq
- (void)shareWebToQQWithTitle:(NSString *)title
                  description:(NSString *)description
                   thumbImage:(NSData *)thumbImage
                    urlString:(NSString *)urlString
          showSelectionInView:(UIView *)view
                     callback:(CYShareCallback)callback {
    
    self.shareTitle = title;
    self.shareDescription = description;
    self.shareThumbImage = thumbImage;
    self.shareURLString = urlString;
    self.shareCallback = callback;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"分享到QZone", @"分享给QQ好友", nil];
    actionSheet.tag = qqWebShareActionSheetTag;
    [actionSheet showInView:view];
    
}

- (void)shareImageToQQWithTitle:(NSString *)title
                    description:(NSString *)description
                     thumbImage:(NSData *)thumbImage
                      imageData:(NSData *)imageData
            showSelectionInView:(UIView *)view
                       callback:(CYShareCallback)callback {
    
    self.shareTitle = title;
    self.shareDescription = description;
    self.shareThumbImage = thumbImage;
    self.shareImageData = imageData;
    self.shareCallback = callback;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"分享到QZone", @"分享给QQ好友", nil];
    actionSheet.tag = qqImageShareActionSheetTag;
    [actionSheet showInView:view];
}

- (void)shareTextToQQ:(NSString *)text
  showSelectionInView:(UIView *)view
             callback:(CYShareCallback)callback {
    
    self.shareDescription = text;
    self.shareCallback = callback;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"分享到QZone", @"分享给QQ好友", nil];
    actionSheet.tag = qqTextShareActionSheetTag;
    [actionSheet showInView:view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
    if (buttonIndex == 0) {
        
        if (actionSheet.tag == wechatWebShareActionSheetTag) {
            
            // 微信朋友圈网页分享
            [self.wechatUtil shareWebToTimelineWithTitle:self.shareTitle
                                             description:self.shareDescription
                                               thumbData:self.shareThumbImage
                                               urlString:self.shareURLString
                                                callback:self.shareCallback];
        } else if (actionSheet.tag == wechatImageShareActionSheetTag) {
            
            // 微信朋友圈图片分享
            [self.wechatUtil shareImageToTimelineWithTitle:self.shareTitle
                                               description:self.shareDescription
                                                 thumbData:self.shareThumbImage
                                                  imageUrl:self.shareImageUrl
                                                 imageData:self.shareImageData
                                                  callback:self.shareCallback];
        } else if (actionSheet.tag == wechatTextShareActionSheetTag) {
            
            // 微信朋友圈文本分享
            [self.wechatUtil shareTextToTimeline:self.shareDescription
                                        callback:self.shareCallback];
        } else if (actionSheet.tag == qqWebShareActionSheetTag) {
            
            // qzone网页分享
            [self.qqUtil shareWebToQZoneWithTitle:self.shareTitle
                                      description:self.shareDescription
                                   thumbImageData:self.shareThumbImage
                                        urlString:self.shareURLString
                                         callback:self.shareCallback];
        } else if (actionSheet.tag == qqImageShareActionSheetTag) {
            
            // qzone图片分享
            [self.qqUtil shareImageToQZoneWithTitle:self.shareTitle
                                        description:self.shareDescription
                                     thumbImageData:self.shareThumbImage
                                          imageData:self.shareImageData
                                           callback:self.shareCallback];
        } else if (actionSheet.tag == qqTextShareActionSheetTag) {
            
            // qzone文本分享
            [self.qqUtil shareTextToQZone:self.shareDescription
                                 callback:self.shareCallback];
        }
        
    } else if (buttonIndex == 1) {
        
        if (actionSheet.tag == wechatWebShareActionSheetTag) {
            
            // 微信会话网页分享
            [self.wechatUtil shareWebToSessionWithTitle:self.shareTitle
                                            description:self.shareDescription
                                              thumbData:self.shareThumbImage
                                              urlString:self.shareURLString
                                               callback:self.shareCallback];
        } else if (actionSheet.tag == wechatImageShareActionSheetTag) {
            
            // 微信会话图片分享
            [self.wechatUtil shareImageToSessionWithTitle:self.shareTitle
                                              description:self.shareDescription
                                                thumbData:self.shareThumbImage
                                                 imageUrl:self.shareImageUrl
                                                imageData:self.shareImageData
                                                 callback:self.shareCallback];
        } else if (actionSheet.tag == wechatTextShareActionSheetTag) {
            
            // 微信会话文本分享
            [self.wechatUtil shareTextToSession:self.shareDescription
                                       callback:self.shareCallback];
        } else if (actionSheet.tag == qqWebShareActionSheetTag) {
            
            // qq会话网页分享
            [self.qqUtil shareWebToQQWithTitle:self.shareTitle
                                   description:self.shareDescription
                                thumbImageData:self.shareThumbImage
                                     urlString:self.shareURLString
                                      callback:self.shareCallback];
        } else if (actionSheet.tag == qqImageShareActionSheetTag) {
            
            // qq会话图片分享
            [self.qqUtil shareImageToQQWithTitle:self.shareTitle
                                     description:self.shareDescription
                                  thumbImageData:self.shareThumbImage
                                       imageData:self.shareImageData
                                        callback:self.shareCallback];
        } else if (actionSheet.tag == qqTextShareActionSheetTag) {
            
            // qq会话文本分享
            [self.qqUtil shareTextToQQ:self.shareDescription
                              callback:self.shareCallback];
        }
    }
}

#pragma mark - handle open
- (BOOL)handleOpenURL:(NSURL *)url {
    
    return ([self.wechatUtil handleOpenURL:url] || [self.qqUtil handleOpenURL:url] || [self.sinaWeiboUtil handleOpenURL:url]);
}

#pragma mark - static
+ (instancetype)sharedInstance {
    
    static CYShare *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[CYShare alloc] init];
    });
    return sharedInstance;
}


@end
