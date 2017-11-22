//
//  CYShareSDKTestViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/22/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYShareSDKTestViewController.h"

#import "CYShare.h"
#import "CYShare+Login.h"

@interface CYShareSDKTestViewController()

@property (nonatomic, strong) CYLoginInfo *wechatLoginInfo;
@property (nonatomic, strong) CYLoginInfo *sinaWeiboLoginInfo;
@property (nonatomic, strong) CYLoginInfo *qqLoginInfo;
@property (nonatomic, strong) CYLoginInfo *facebookLoginInfo;

@end

@implementation CYShareSDKTestViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 29;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"Wechat web session \u26b2";
    } else if (indexPath.row == 1) {
        
        cell.textLabel.text = @"Wechat web timeline \u26b2";
    } else if (indexPath.row == 2) {
        
        cell.textLabel.text = @"Wechat image session \u26b2";
    } else if (indexPath.row == 3) {
        
        cell.textLabel.text = @"Wechat image timeline \u26b2";
    } else if (indexPath.row == 4) {

        cell.textLabel.text = @"Wechat web user selected \u26b2";
    } else if (indexPath.row == 5) {

        cell.textLabel.text = @"Wechat image user selected \u26b2";
    } else if (indexPath.row == 6) {
        
        cell.textLabel.text = @"qq web session \u26b2";
    } else if (indexPath.row == 7) {
        
        cell.textLabel.text = @"qq web qzone \u26b2";
    } else if (indexPath.row == 8) {
        
        cell.textLabel.text = @"qq image session \u26b2";
    } else if (indexPath.row == 9) {
        
        cell.textLabel.text = @"qq image qzone \u26b2";
    } else if (indexPath.row == 10) {

        cell.textLabel.text = @"qq web user select \u26b2";
    } else if (indexPath.row == 11) {

        cell.textLabel.text = @"qq image user select  \u26b2";
    } else if (indexPath.row == 12) {
        
        cell.textLabel.text = @"sina weibo web \u26b2";
    } else if (indexPath.row == 13) {
        
        cell.textLabel.text = @"sina weibo image \u26b2";
    } else if (indexPath.row == 14) {
        cell.textLabel.text = @"Apple Social Web \u26b2";
    } else if (indexPath.row == 15) {
        cell.textLabel.text = @"Apple Social Image \u26b2";
    } else if (indexPath.row == 16) {
        cell.textLabel.text = @"SMS Web \u26b2";
    } else if (indexPath.row == 17) {
        cell.textLabel.text = @"SMS Image \u26b2";
    } else if (indexPath.row == 18) {
        cell.textLabel.text = @"Facebook Web \u26b2";
    } else if (indexPath.row == 19) {
        cell.textLabel.text = @"Facebook Image \u26b2";
    } else if (indexPath.row == 20) {
        cell.textLabel.text = @"Facebook Login \u26b2";
    } else if (indexPath.row == 21) {
        cell.textLabel.text = @"Wechat Login \u26b2";
    } else if (indexPath.row == 22) {
        cell.textLabel.text = @"wechat userinfo \u26b2";
    } else if (indexPath.row == 23) {
        cell.textLabel.text = @"Weibo Login \u26b2";
    } else if (indexPath.row == 24) {
        cell.textLabel.text = @"weibo user info \u26b2";
    } else if (indexPath.row == 25) {
        cell.textLabel.text = @"QQ Login \u26b2";
    } else if (indexPath.row == 26) {
        cell.textLabel.text = @"qq user info \u26b2";
    } else if (indexPath.row == 27) {
        cell.textLabel.text = @"facebook Login \u26b2";
    } else if (indexPath.row == 28) {
        cell.textLabel.text = @"facebook user info \u26b2";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
    // Wechat web session";
        [CYShare shareToWechat:[CYShareModel urlModelWithTitle:@"小牛钱罐子"
                                                       content:@"小牛钱罐子官网"
                                                     thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                           url:@"http://www.xiaoniuapp.com"]
                         scene:CYWechatSceneSession
                      callback:^(NSInteger code, NSString *msg) {
                          NSLog(@"Wechat session message code = %ld, message = %@", (long)code, msg);
                      }];
    } else if (indexPath.row == 1) {
        // wechat web timeline
        [CYShare shareToWechat:[CYShareModel urlModelWithTitle:@"小牛钱罐子"
                                                       content:@"小牛钱罐子官网"
                                                     thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                           url:@"http://www.xiaoniuapp.com"]
                         scene:CYWechatSceneTimeline
                      callback:^(NSInteger code, NSString *msg) {
                          NSLog(@"Wechat timeline message code = %ld, message = %@", (long)code, msg);
                      }];
    } else if (indexPath.row == 2) {
        
        // Wechat image session";
        [CYShare shareToWechat:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
                                                         content:@"小牛钱罐子"
                                                       thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                            data:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])]
                         scene:CYWechatSceneSession
                      callback:^(NSInteger code, NSString *msg) {
                          NSLog(@"Wechat timeline message code = %ld, message = %@", (long)code, msg);
                      }];
    } else if (indexPath.row == 3) {
        
        // Wechat image timeline";
        [CYShare shareToWechat:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
                                                         content:@"小牛钱罐子"
                                                       thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                            data:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])]
                         scene:CYWechatSceneTimeline
                      callback:^(NSInteger code, NSString *msg) {
                          NSLog(@"Wechat timeline message code = %ld, message = %@", (long)code, msg);
                      }];
    } else if (indexPath.row == 4) {

        // Wechat web user select";
        [CYShare shareToWechat:[CYShareModel urlModelWithTitle:@"小牛钱罐子"
                                                       content:@"小牛钱罐子官网"
                                                     thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                           url:@"http://www.xiaoniuapp.com"]
            fromViewController:self
                      callback:^(NSInteger code, NSString *msg) {

                          NSLog(@"Wechat user select message code = %ld, message = %@", (long)code, msg);
                      }];
    }  else if (indexPath.row == 5) {

        // Wechat image user select";
        [CYShare shareToWechat:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
                                                         content:@"小牛钱罐子"
                                                       thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                            data:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])]
        fromViewController:self
                      callback:^(NSInteger code, NSString *msg) {
                          NSLog(@"Wechat user select message code = %ld, message = %@", (long)code, msg);
                      }];
    }  else if (indexPath.row == 6) {
        
        // qq web
        [CYShare shareToQQ:[CYShareModel urlModelWithTitle:@"小牛钱罐子"
                                                   content:@"小牛钱罐子官网"
                                                 thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                       url:@"http://www.xiaoniuapp.com"]
                  ctrlFlag:CYQQAPICtrlFlagQQShare
                  callback:^(NSInteger code, NSString *msg) {
                      NSLog(@"qq web message code = %ld, message = %@", (long)code, msg);
                  }];
    } else if (indexPath.row == 7) {
        
        // qq web qzone";
        [CYShare shareToQQ:[CYShareModel urlModelWithTitle:@"小牛钱罐子"
                                                   content:@"小牛钱罐子官网"
                                                 thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                       url:@"http://www.xiaoniuapp.com"]
                  ctrlFlag:CYQQAPICtrlFlagQZoneShareOnStart
                  callback:^(NSInteger code, NSString *msg) {
                      NSLog(@"qzone web message code = %ld, message = %@", (long)code, msg);
                  }];
    } else if (indexPath.row == 8) {
        
        // qq image session";
        [CYShare shareToQQ:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
                                                     content:@"小牛钱罐子"
                                                   thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                        data:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])]
                  ctrlFlag:CYQQAPICtrlFlagQQShare
                  callback:^(NSInteger code, NSString *msg) {
                      NSLog(@"qq image message code = %ld, message = %@", (long)code, msg);
                  }];
    } else if (indexPath.row == 9) {
        
        // qq image qzone";
        [CYShare shareToQQ:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
                                                     content:@"小牛钱罐子"
                                                   thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                        data:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])]
                  ctrlFlag:CYQQAPICtrlFlagQZoneShareOnStart
                  callback:^(NSInteger code, NSString *msg) {
                      NSLog(@"qzone image message code = %ld, message = %@", (long)code, msg);
                  }];
    } else if (indexPath.row == 10) {

        // qq web userselect";
        [CYShare shareToQQ:[CYShareModel urlModelWithTitle:@"小牛钱罐子"
                                                   content:@"小牛钱罐子官网"
                                                 thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                       url:@"http://www.xiaoniuapp.com"]
    fromViewController:self
                  callback:^(NSInteger code, NSString *msg) {
                      NSLog(@"qq web user select message code = %ld, message = %@", (long)code, msg);
                  }];
    } else if (indexPath.row == 11) {

        // qq image user select";
        [CYShare shareToQQ:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
                                                     content:@"小牛钱罐子"
                                                   thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                        data:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])]
    fromViewController:self
                  callback:^(NSInteger code, NSString *msg) {
                      NSLog(@"qq image userselect message code = %ld, message = %@", (long)code, msg);
                  }];
    } else if (indexPath.row == 12) {

        [CYShare shareToWeibo:[CYShareModel urlModelWithTitle:@"小牛钱罐子"
                                                      content:@"小牛钱罐子官网"
                                                    thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                          url:@"http://www.xiaoniuapp.com"]
                     callback:^(NSInteger code, NSString *msg) {
                         NSLog(@"Weibo web message code = %ld, message = %@", (long)code, msg);
        }];
    } else if (indexPath.row == 13) {

        [CYShare shareToWeibo:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
                                                        content:@"小牛钱罐子"
                                                      thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                           data:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])]
                     callback:^(NSInteger code, NSString *msg) {
                         NSLog(@"Weibo image message code = %ld, message = %@", (long)code, msg);
                     }];
    } else if (indexPath.row == 14) {

        [CYShare shareByAppleActivity:[CYShareModel urlModelWithTitle:@"小牛钱罐子"
                                                            content:@"小牛钱罐子官网"
                                                          thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                                url:@"http://www.xiaoniuapp.com"]
                   fromViewController:self
                           callback:^(NSInteger code, NSString *msg) {
                               NSLog(@"Apple social web message code = %ld, message = %@", (long)code, msg);
                           }];
    } else if (indexPath.row == 15) {

        [CYShare shareByAppleActivity:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
                                                              content:@"小牛钱罐子"
                                                            thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                                 data:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])]
                   fromViewController:self
                           callback:^(NSInteger code, NSString *msg) {
                               NSLog(@"Apple social image message code = %ld, message = %@", (long)code, msg);
                           }];
    } else if (indexPath.row == 16) {
        [CYShare shareBySMS:[CYShareModel urlModelWithTitle:@"小牛钱罐子"
                                                    content:@"小牛钱罐子官网"
                                                  thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                        url:@"http://www.xiaoniuapp.com"]
                         to:nil
         fromViewController:self
                   callback:^(NSInteger code, NSString *msg) {
                       NSLog(@"sms web message code = %ld, message = %@", (long)code, msg);
                   }];
    } else if (indexPath.row == 17) {

        // 暂不支持图片分享
//        [CYShare shareBySMS:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
//                                                      content:@"小牛钱罐子图片"
//                                                    thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
//                                                         data:UIImagePNGRepresentation([UIImage imageNamed:@"tab_origin"])]
//                         to:nil
//                presentFrom:self
//                   callback:^(NSInteger code, NSString *msg) {
//                       NSLog(@"sms image message code = %ld, message = %@", (long)code, msg);
//                   }];
    } else if (indexPath.row == 18) {

        [CYShare shareToFacebook:[CYShareModel urlModelWithTitle:@"小牛钱罐子"
                                                         content:@"小牛钱罐子官网"
                                                       thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                             url:@"http://www.xiaoniuapp.com"] fromViewController:self callback:^(NSInteger code, NSString *msg) {
            NSLog(@"facebook web message code = %ld, message = %@", (long)code, msg);
        }];

    } else if (indexPath.row == 19) {

        [CYShare shareToFacebook:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
                                                           content:@"小牛钱罐子"
                                                         thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                              data:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])] fromViewController:self callback:^(NSInteger code, NSString *msg) {
            NSLog(@"facebook image message code = %ld, message = %@", (long)code, msg);
        }];

    } else if (indexPath.row == 20) {
        // facebook 登录
        [CYShare loginByFacebook:^(NSInteger code, NSString *msg, CYLoginInfo *loginInfo) {
            NSLog(@"facebook login message code = %ld, message = %@", (long)code, msg);
            self.facebookLoginInfo = loginInfo;
        }];
    } else if (indexPath.row == 21) {
        // 微信登陆
        [CYShare loginByWechat:^(NSInteger code, NSString *msg, CYLoginInfo *loginInfo) {
            NSLog(@"wechat login message code = %ld, message = %@", (long)code, msg);
            self.wechatLoginInfo = loginInfo;
        }];
    } else if (indexPath.row == 22) {
        // 微信个人信息
        if (!self.wechatLoginInfo) {
            NSLog(@"微信未登录，请先登录");
            return;
        }
        [[CYWechat sharedInstance] getUserInfoWithAccessToken:self.wechatLoginInfo.accessToken openid:self.wechatLoginInfo.userId callback:^(NSInteger code, NSString *msg, CYUserInfo *userInfo) {
            NSLog(@"wechat user info message code = %ld, message = %@", (long)code, msg);
        }];
    } else if (indexPath.row == 23) {
        // 微博登录
        [CYShare loginBySinaWeibo:^(NSInteger code, NSString *msg, CYLoginInfo *loginInfo) {
            NSLog(@"sinaweibo login message code = %ld, message = %@", (long)code, msg);
            self.sinaWeiboLoginInfo = loginInfo;
        }];
    } else if (indexPath.row == 24) {
        // 微博个人信息
        if (!self.sinaWeiboLoginInfo) {
            NSLog(@"微博未登录，请先登录");
            return;
        }
        [[CYSinaWeibo sharedInstance] getUserInfoWithAccessToken:self.sinaWeiboLoginInfo.accessToken userId:self.sinaWeiboLoginInfo.userId callback:^(NSInteger code, NSString *msg, CYUserInfo *userInfo) {
            NSLog(@"weibo user info message code = %ld, message = %@", (long)code, msg);
        }];
    } else if (indexPath.row == 25) {

        // qq登陆
        [CYShare loginByQQ:^(NSInteger code, NSString *msg, CYLoginInfo *loginInfo) {
            NSLog(@"qq login message code = %ld, message = %@", (long)code, msg);
            self.qqLoginInfo = loginInfo;
        }];
    } else if (indexPath.row == 26) {
        // qq个人信息
        [[CYQQ sharedInstance] getUserInfoWithCallback:^(NSInteger code, NSString *msg, CYUserInfo *userInfo) {
            NSLog(@"qq user info message code = %ld, message = %@", (long)code, msg);
        }];
    } else if (indexPath.row == 27) {
        // facebook 登录
        [CYShare loginByFacebook:^(NSInteger code, NSString *msg, CYLoginInfo *loginInfo) {
            NSLog(@"facebook login message code = %ld, message = %@", (long)code, msg);
            self.facebookLoginInfo = loginInfo;
        }];
    }  else if (indexPath.row == 28) {
        // facebook user info
        [[CYFacebook sharedInstance] getUserInfo:self.facebookLoginInfo.userId callback:^(NSInteger code, NSString *msg, CYUserInfo *userInfo) {

            NSLog(@"facebook user info message code = %ld, message = %@", (long)code, msg);
        }];
    }
}

@end
