//
//  CYQQUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/10/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYQQUtil.h"

#import "TencentOpenApi/TencentOAuth.h"
#import "TencentOpenApi/QQApiInterface.h"

@interface CYQQUtil () <TencentSessionDelegate, QQApiInterfaceDelegate>

@property (nonatomic, strong) TencentOAuth *oauth;

@property (nonatomic, copy) CYShareCallback shareCallback;

@end

@implementation CYQQUtil

- (instancetype)init {
    
    if (self = [super init]) {
        
        _oauth = [[TencentOAuth alloc] initWithAppId:self.appId andDelegate:self];
        //        NSArray *permissions = @[ kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE ];
        //        [oauth authorize:permissions inSafari:NO];
    }
    return self;
}

#pragma mark - login
- (void)tencentDidLogin {
    
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
    
}

- (void)tencentDidNotNetWork {
    
    
}


#pragma mark - share url
- (void)shareWebToQQWithTitle:(NSString *)title
                  description:(NSString *)description
               thumbImageData:(NSData *)thumbImageData
                    urlString:(NSString *)urlString
                     callback:(CYShareCallback)callback {
    
    [self shareWebWithTitle:title description:description
             thumbImageData:thumbImageData
                  urlString:urlString
                         to:kQQAPICtrlFlagQQShare
                   callback:callback];
}

- (void)shareWebToQZoneWithTitle:(NSString *)title
                     description:(NSString *)description
                  thumbImageData:(NSData *)thumbImageData
                       urlString:(NSString *)urlString
                        callback:(CYShareCallback)callback {
    
    [self shareWebWithTitle:title description:description
             thumbImageData:thumbImageData
                  urlString:urlString
                         to:kQQAPICtrlFlagQZoneShareOnStart
                   callback:callback];
}

- (void)shareWebWithTitle:(NSString *)title
              description:(NSString *)description
           thumbImageData:(NSData *)thumbImageData
                urlString:(NSString *)urlString
                       to:(uint64_t)flag
                 callback:(CYShareCallback)callback {
    
    QQApiNewsObject *object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:urlString]
                                                       title:title
                                                 description:description
                                            previewImageData:thumbImageData];
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

#pragma mark - share image
- (void)shareImageToQQWithTitle:(NSString *)title
                    description:(NSString *)description
                 thumbImageData:(NSData *)thumbImageData
                      imageData:(NSData *)imageData
                       callback:(CYShareCallback)callback {
    
    [self shareImageWithTitle:title
                  description:description
               thumbImageData:thumbImageData
                    imageData:imageData
                           to:kQQAPICtrlFlagQQShare
                     callback:callback];
}

- (void)shareImageToQZoneWithTitle:(NSString *)title
                       description:(NSString *)description
                    thumbImageData:(NSData *)thumbImageData
                         imageData:(NSData *)imageData
                          callback:(CYShareCallback)callback {
    
    [self shareImageWithTitle:title
                  description:description
               thumbImageData:thumbImageData
                    imageData:imageData
                           to:kQQAPICtrlFlagQZoneShareOnStart
                     callback:callback];
}

- (void)shareImageWithTitle:(NSString *)title
                description:(NSString *)description
             thumbImageData:(NSData *)thumbImageData
                  imageData:(NSData *)imageData
                         to:(uint64_t)flag
                   callback:(CYShareCallback)callback {
    
    QQApiImageObject *object = [[QQApiImageObject alloc] initWithData:imageData
                                                     previewImageData:thumbImageData
                                                                title:title
                                                          description:description];
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

- (void)shareTextToQQ:(NSString *)text
             callback:(CYShareCallback)callback {
    
    [self shareText:text
                 to:kQQAPICtrlFlagQQShare
           callback:callback];
}

- (void)shareTextToQZone:(NSString *)text
                callback:(CYShareCallback)callback {
    
    [self shareText:text
                 to:kQQAPICtrlFlagQZoneShareOnStart
           callback:callback];
}

- (void)shareText:(NSString *)text
               to:(uint64_t)flag
         callback:(CYShareCallback)callback {
    
    QQApiTextObject *object = [QQApiTextObject objectWithText:text];
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
    
    static CYQQUtil *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[CYQQUtil alloc] init];
    });
    return util;
}

//+ (void)registerWithAppId:(NSString *)appId appKey:(NSString *)appKey {
//    [super registerWithAppId:appId appKey:appKey];
//
////    QQApiInterface
//}

@end
