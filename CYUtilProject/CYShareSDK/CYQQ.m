//
//  CYQQUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/10/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYQQ.h"

#if CY_SHARE_QQ_ENABLED
#import <UIKit/UIKit.h>
#import "CYShareModel.h"

#import "TencentOpenApi/TencentOAuth.h"
#import "TencentOpenApi/QQApiInterface.h"

@interface CYQQ() <TencentSessionDelegate, QQApiInterfaceDelegate>

@property (nonatomic, strong) TencentOAuth *oauth;

@end

@implementation CYQQ

NSString *const CYQQAPICtrlFlagKey = @"CYUtil.CYQQAPICtrlFlagKey";

#pragma mark - register
- (void)registerWithAppId:(NSString *)appId {
    [super registerWithAppId:appId];

    self.oauth = [[TencentOAuth alloc] initWithAppId:self.appId
                                         andDelegate:self];
}

#pragma mark - login
- (void)tencentDidLogin {


}

- (void)tencentDidNotLogin:(BOOL)cancelled {


}

- (void)tencentDidNotNetWork {


}


#pragma mark - share
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback {

    CYQQAPICtrlFlag flag = [[model.userInfo objectForKey:CYQQAPICtrlFlagKey] unsignedLongLongValue];;
    [self share:model
             to:flag
       callback:callback];
}

- (void)share:(CYShareModel *)model
presentActionSheetFrom:(UIViewController *)viewController
     callback:(CYShareCallback)callback {


    // 未指定分享方式，则让用户选择分享给好友，或者分享到朋友圈
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                     style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                                                         if (callback) {
                                                             callback(-1, @"User cancel");
                                                         }
                                                     }];
    [actionSheet addAction:cancel];

    UIAlertAction *session = [UIAlertAction actionWithTitle:NSLocalizedString(@"分享给QQ好友", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [self shareToQQ:model
                                                               callback:callback];
                                                    }];
    [actionSheet addAction:session];

    UIAlertAction *timeline = [UIAlertAction actionWithTitle:NSLocalizedString(@"分享到QQ空间", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self shareToQZone:model
                                                                   callback:callback];
                                                     }];
    [actionSheet addAction:timeline];

    [viewController presentViewController:actionSheet animated:YES completion:nil];
}

- (void)shareToQQ:(CYShareModel *)model
         callback:(CYShareCallback)callback {

    [self share:model
             to:CYQQAPICtrlFlagQQShare
       callback:callback];
}

- (void)shareToQZone:(CYShareModel *)model
            callback:(CYShareCallback)callback {
    [self share:model
             to:CYQQAPICtrlFlagQZoneShareOnStart
       callback:callback];
}

- (void)share:(CYShareModel *)model
           to:(CYQQAPICtrlFlag)flag
     callback:(CYShareCallback)callback {
    if (!model.isValid) {
        NSLog(@"The share model is invalid!!!");
        return ;
    }

    QQApiObject *object = nil;
    switch (model.type) {
        case XNShareContenTypeText: {
            object = [QQApiTextObject objectWithText:model.content];
            break;
        }

        case XNShareContenTypeURL: {
            object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:model.url]
                                              title:model.title
                                        description:model.content
                                   previewImageData:model.thumbnail];
        }

        case XNShareContenTypeImage: {
            object = [QQApiImageObject objectWithData:model.data
                                     previewImageData:model.thumbnail
                                                title:model.title
                                          description:model.content];
        }

        default:
            break;
    }
    object.cflag = flag;

    SendMessageToQQReq *request = [SendMessageToQQReq reqWithContent:object];
    QQApiSendResultCode code = [QQApiInterface sendReq:request];

    self.shareCallback = callback;

    if (code != EQQAPISENDSUCESS
        && self.shareCallback) {

        self.shareCallback(code, nil);
        self.shareCallback = nil;
    }

}

#pragma mark - QQApiInterfaceDelegate
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req {
    
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp {
    
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        
        if (self.shareCallback) {
            
            self.shareCallback([resp.result integerValue], resp.errorDescription);
            self.shareCallback = nil;
        }
    }
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response {
    
}

#pragma mark - handle open
- (BOOL)handleOpenURL:(NSURL *)url {
    
    return [QQApiInterface handleOpenURL:url delegate:self];
}

#pragma mark - api
+ (BOOL)openApp {
    
    return [QQApiInterface openQQ];
}

+ (BOOL)appInstalled {
    
    return [QQApiInterface isQQInstalled];
}

#pragma mark - sharedInstance
+ (instancetype)sharedInstance {
    
    static CYQQ *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[CYQQ alloc] init];
    });
    return util;
}

//+ (void)registerWithAppId:(NSString *)appId appKey:(NSString *)appKey {
//    [super registerWithAppId:appId appKey:appKey];
//
////    QQApiInterface
//}

@end

#endif
