//
//  XNWechatUtil.m
//  MoneyJar2
//
//  Created by XNKJ on 6/4/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYWechatUtil.h"

#import "WXApi.h"

#define CY_WECHAT_GET_ACCESS_TOKEN_URL   @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"

#define XN_WECHAT_STATE         @"XNWechatState"

@interface CYWechatUtil () <WXApiDelegate>

@property (nonatomic, copy) CYThirdPartyLoginCallback loginCallback;
@property (nonatomic, copy) CYShareCallback shareCallback;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation CYWechatUtil

- (NSOperationQueue *)operationQueue {
    
    if (!_operationQueue) {
        
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

#pragma mark - Wechat login
- (void)startWechatLoginFrom:(UIViewController *)from
                withCallback:(CYThirdPartyLoginCallback)callback {
    
    //构造SendAuthReq结构体
    SendAuthReq* request =[[SendAuthReq alloc ] init];
    request.scope = @"snsapi_userinfo" ;
    request.state = XN_WECHAT_STATE;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendAuthReq:request viewController:from delegate:self];
    
    self.loginCallback = callback;
}

- (void)getWechatAccessTokenWithCode:(NSString *)code {
    
    NSString *urlString = [NSString stringWithFormat:CY_WECHAT_GET_ACCESS_TOKEN_URL, [[self class] appId], [[self class] appKey], code];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:30.f];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.operationQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               // 回到主线程，这个是通过子线程回调的
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                   if (data) {
                                       
                                       NSError *error = nil;
                                       NSDictionary *wechatResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                       if (!error
                                           && wechatResponse
                                           && [wechatResponse isKindOfClass:[NSDictionary class]]) {
                                           
                                           NSInteger  errorCode = [[wechatResponse objectForKey:@"errcode"] integerValue];
                                           
                                           if (errorCode != 0) {
                                               
                                               if (self.loginCallback) {
                                                   
                                                   self.loginCallback(errorCode,
                                                                      [wechatResponse objectForKey:@"errmsg"],
                                                                      wechatResponse);
                                               }
                                           } else {
                                               
                                               if (self.loginCallback) {
                                                   
                                                   self.loginCallback(0,
                                                                      @"",
                                                                      wechatResponse);
                                               }
                                           }
                                       } else {
                                           
                                           if (self.loginCallback) {
                                               
                                               self.loginCallback(error.code, [error.userInfo objectForKey:@"msg"], @{});
                                           }
                                       }
                                   }
                               });
                               
                           }];
    
}

#pragma mark - share

- (void)shareWebToTimelineWithTitle:(NSString *)title
                        description:(NSString *)description
                          thumbData:(NSData *)thumbData
                          urlString:(NSString *)urlString
                           callback:(CYShareCallback)callback {
    
    [self shareWebWithTitle:title
                description:description
                  thumbData:thumbData
                  urlString:urlString
                      scene:WXSceneTimeline
                   callback:callback];
}

- (void)shareWebToSessionWithTitle:(NSString *)title
                       description:(NSString *)description
                         thumbData:(NSData *)thumbData
                         urlString:(NSString *)urlString
                          callback:(CYShareCallback)callback {
    
    [self shareWebWithTitle:title
                description:description
                  thumbData:thumbData
                  urlString:urlString
                      scene:WXSceneSession
                   callback:callback];
}

- (void)shareWebWithTitle:(NSString *)title
              description:(NSString *)description
                thumbData:(NSData *)thumbData
                urlString:(NSString *)urlString
                    scene:(enum WXScene)scene
                 callback:(CYShareCallback)callback {
    
    WXWebpageObject *webPage = [WXWebpageObject object];
    webPage.webpageUrl = urlString;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.thumbData = thumbData;
    message.mediaObject = webPage;
    
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
    request.message = message;
    request.bText = NO;
    request.scene = scene;
    [WXApi sendReq:request];
    
    self.shareCallback = callback;
}

- (void)shareImageToSessionWithTitle:(NSString *)title
                         description:(NSString *)description
                           thumbData:(NSData *)thumbData
                            imageUrl:(NSString *)imageUrl
                           imageData:(NSData *)data
                            callback:(CYShareCallback)callback {
    
    [self shareImageWithTitle:title
                  description:description
                    thumbData:thumbData
                     imageUrl:imageUrl
                    imageData:data
                        scene:WXSceneSession
                     callback:callback];
}

- (void)shareImageToTimelineWithTitle:(NSString *)title
                          description:(NSString *)description
                            thumbData:(NSData *)thumbData
                             imageUrl:(NSString *)imageUrl
                            imageData:(NSData *)data
                             callback:(CYShareCallback)callback {
    
    self.shareCallback = callback;
    [self shareImageWithTitle:title
                  description:description
                    thumbData:thumbData
                     imageUrl:imageUrl
                    imageData:data
                        scene:WXSceneTimeline
                     callback:callback];
}

- (void)shareImageWithTitle:(NSString *)title
                description:(NSString *)description
                  thumbData:(NSData *)thumbData
                   imageUrl:(NSString *)imageUrl
                  imageData:(NSData *)data
                      scene:(enum WXScene)scene
                   callback:(CYShareCallback)callback {
    
    WXImageObject *imageObject = [WXImageObject object];
    if (data) {
        
        imageObject.imageData = data;
    } else {
        
        imageObject.imageUrl = imageUrl;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.thumbData = thumbData;
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
    request.message = message;
    request.bText = NO;
    request.scene = scene;
    [WXApi sendReq:request];
    
    self.shareCallback = callback;
}

- (void)shareTextToSession:(NSString *)text
                  callback:(CYShareCallback)callback {
    
    [self shareTextWithText:text
                      scene:WXSceneSession
                   callback:callback];
}

- (void)shareTextToTimeline:(NSString *)text
                   callback:(CYShareCallback)callback {
    
    [self shareTextWithText:text
                      scene:WXSceneTimeline
                   callback:callback];
}

- (void)shareTextWithText:(NSString *)text
                    scene:(enum WXScene)scene
                 callback:(CYShareCallback)callback {
    
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
    request.text = text;
    request.bText = YES;
    request.scene = scene;
    [WXApi sendReq:request];
    
    self.shareCallback = callback;
}

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req {
    
    
}

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        // 登录回调
        [self receiveAuthResponse:(SendAuthResp *)resp];
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
        // 分享回调
        NSInteger errorCode = resp.errCode;
        if (errorCode == WXErrCodeUserCancel) {
            
            errorCode = 2;
        } else if (errorCode != 0) {
            
            errorCode = 1;
        }
        if (_shareCallback) {
            
            _shareCallback(errorCode, resp.errStr);
        }
    }
}

// 登录回调
- (void)receiveAuthResponse:(SendAuthResp *)response {
    
    NSString *wechatCode = response.code;
    NSInteger errorCode = response.errCode;
    
    if (errorCode == 0) {
        
        [self getWechatAccessTokenWithCode:wechatCode];
    } else {
        
        if (errorCode == WXErrCodeUserCancel) {
            
            errorCode = 2;
        } else {
            
            errorCode = 1;
        }
        
        if (self.loginCallback) {
            
            self.loginCallback(errorCode, response.errStr, nil);
        }
    }
}

#pragma mark - handle open url
- (BOOL)handleOpenURL:(NSURL *)URL {
    
    return [WXApi handleOpenURL:URL delegate:self];
}

#pragma mark - api
+ (BOOL)openApp {
    
    return [WXApi openWXApp];
}

+ (BOOL)appInstalled {
    
    return [WXApi isWXAppInstalled];
}

#pragma mark - static single
+ (instancetype)sharedInstance {
    
    static CYWechatUtil *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[CYWechatUtil alloc] init];
    });
    return util;
}

@end
