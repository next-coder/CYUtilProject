//
//  CYShareSDKTestViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/22/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYShareSDKTestViewController.h"

#import "CYShare.h"

@implementation CYShareSDKTestViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 16;
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
        presentActionSheetFrom:self
                      callback:^(NSInteger code, NSString *msg) {

                          NSLog(@"Wechat user select message code = %ld, message = %@", (long)code, msg);
                      }];
    }  else if (indexPath.row == 5) {

        // Wechat image user select";
        [CYShare shareToWechat:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
                                                         content:@"小牛钱罐子"
                                                       thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                            data:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])]
        presentActionSheetFrom:self
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
    presentActionSheetFrom:self
                  callback:^(NSInteger code, NSString *msg) {
                      NSLog(@"qq web user select message code = %ld, message = %@", (long)code, msg);
                  }];
    } else if (indexPath.row == 11) {

        // qq image user select";
        [CYShare shareToQQ:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
                                                     content:@"小牛钱罐子"
                                                   thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                        data:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])]
    presentActionSheetFrom:self
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
                   presentShareFrom:self
                           callback:^(NSInteger code, NSString *msg) {
                               NSLog(@"Apple social web message code = %ld, message = %@", (long)code, msg);
                           }];
    } else if (indexPath.row == 15) {

        [CYShare shareByAppleActivity:[CYShareModel imageModelWithTitle:@"小牛钱罐子"
                                                              content:@"小牛钱罐子"
                                                            thumbnail:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])
                                                                 data:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])]
                   presentShareFrom:self
                           callback:^(NSInteger code, NSString *msg) {
                               NSLog(@"Apple social image message code = %ld, message = %@", (long)code, msg);
                           }];
    }
}

@end
