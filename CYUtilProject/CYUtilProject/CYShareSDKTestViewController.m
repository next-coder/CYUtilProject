//
//  CYShareSDKTestViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/22/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYShareSDKTestViewController.h"

#import "CYWechatUtil.h"
#import "CYQQUtil.h"
#import "CYSinaWeiboUtil.h"

@implementation CYShareSDKTestViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"Wechat web session";
    } else if (indexPath.row == 1) {
        
        cell.textLabel.text = @"Wechat web timeline";
    } else if (indexPath.row == 2) {
        
        cell.textLabel.text = @"Wechat image session";
    } else if (indexPath.row == 3) {
        
        cell.textLabel.text = @"Wechat image timeline";
    } else if (indexPath.row == 4) {
        
        cell.textLabel.text = @"qq web session";
    } else if (indexPath.row == 5) {
        
        cell.textLabel.text = @"qq web qzone";
    } else if (indexPath.row == 6) {
        
        cell.textLabel.text = @"qq image session";
    } else if (indexPath.row == 7) {
        
        cell.textLabel.text = @"qq image qzone";
    } else if (indexPath.row == 8) {
        
        cell.textLabel.text = @"sina weibo web";
    } else if (indexPath.row == 9) {
        
        cell.textLabel.text = @"sina weibo image";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
    // Wechat web session";
        
//        [[CYWechatUtil sharedInstance] shareWebToSessionWithTitle:@"小牛钱罐子" description:@"小牛钱罐子官网" thumbImage:[UIImage imageNamed:@"share_message.png"] URLString:@"http://www.xiaoniuapp.com" callback:^(NSInteger code, NSString *msg) {
//            
//            NSLog(@"CYWechatUtil message code = %ld, message = %@", (long)code, msg);
//        }];
    } else if (indexPath.row == 1) {
        // wechat web timeline
//        [[CYWechatUtil sharedInstance] shareWebToTimelineWithTitle:@"小牛钱罐子" description:@"小牛钱罐子官网" thumbImage:[UIImage imageNamed:@"share_message.png"] URLString:@"http://www.xiaoniuapp.com" callback:^(NSInteger code, NSString *msg) {
//            
//            NSLog(@"CYWechatUtil message code = %ld, message = %@", (long)code, msg);
//        }];
    } else if (indexPath.row == 2) {
        
        // Wechat image session";
//        [[CYWechatUtil sharedInstance] shareImageToSessionWithTitle:@"小牛钱罐子" description:@"小牛钱罐子宣传图" thumbImage:[UIImage imageNamed:@"share_message.png"] imageUrl:nil
//                                                                imageData:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"]) callback:^(NSInteger code, NSString *msg) {
//            
//            NSLog(@"CYWechatUtil message code = %ld, message = %@", (long)code, msg);
//        }];
    } else if (indexPath.row == 3) {
        
        // Wechat image timeline";
//        [[CYWechatUtil sharedInstance] shareImageToTimelineWithTitle:@"小牛钱罐子" description:@"小牛钱罐子宣传图" thumbImage:[UIImage imageNamed:@"share_message.png"] imageUrl:nil
//                                                                 imageData:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"])  callback:^(NSInteger code, NSString *msg) {
//            
//            NSLog(@"CYWechatUtil message code = %ld, message = %@", (long)code, msg);
//        }];
    } else if (indexPath.row == 4) {
        
        
        [[CYQQUtil sharedInstance] shareWebToQQWithTitle:@"小牛钱罐子" description:@"小牛钱罐子官网" thumbImageData:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"]) urlString:@"http://www.xiaoniuapp.com" callback:^(NSInteger code, NSString *msg) {
            
            NSLog(@"CYQQUtils message code = %ld, message = %@", (long)code, msg);
        }];
    } else if (indexPath.row == 5) {
        
        // qq web qzone";
        [[CYQQUtil sharedInstance] shareWebToQZoneWithTitle:@"小牛钱罐子" description:@"小牛钱罐子官网" thumbImageData:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"]) urlString:@"http://www.xiaoniuapp.com" callback:^(NSInteger code, NSString *msg) {
            
            NSLog(@"CYQQUtils message code = %ld, message = %@", (long)code, msg);
        }];
    } else if (indexPath.row == 6) {
        
        // qq image session";
        [[CYQQUtil sharedInstance] shareImageToQQWithTitle:@"小牛钱罐子" description:@"小牛钱罐子官网" thumbImageData:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"]) imageData:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"]) callback:^(NSInteger code, NSString *msg) {
            
            NSLog(@"CYQQUtils message code = %ld, message = %@", (long)code, msg);
        }];
    } else if (indexPath.row == 7) {
        
        // qq image qzone";
        [[CYQQUtil sharedInstance] shareImageToQZoneWithTitle:@"小牛钱罐子" description:@"小牛钱罐子官网" thumbImageData:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"]) imageData:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"]) callback:^(NSInteger code, NSString *msg) {
            
            NSLog(@"CYQQUtils message code = %ld, message = %@", (long)code, msg);
        }];
    } else if (indexPath.row == 8) {
        
//        [[CYSinaWeiboUtil sharedInstance] shareWebWithDescription:@"小牛钱罐子官网" urlString:@"http://www.xiaoniuapp.com" callback:^(NSInteger code, NSString *msg) {
//            
//            NSLog(@"CYSinaWeiboUtil message code = %ld, message = %@", (long)code, msg);
//        }];
        [[CYSinaWeiboUtil sharedInstance] shareWebWithTitle:@"小牛钱罐子官网"  description:@"小牛钱罐子官网"  thumbImageData:nil urlString:@"http://www.xiaoniuapp.com" callback:^(NSInteger code, NSString *msg) {
            NSLog(@"CYSinaWeiboUtil message code = %ld, message = %@", (long)code, msg);
        }];
    } else if (indexPath.row == 9) {
        
        [[CYSinaWeiboUtil sharedInstance] shareImageWithDescription:@"小牛钱罐子宣传图" imageData:UIImagePNGRepresentation([UIImage imageNamed:@"share_message.png"]) callback:^(NSInteger code, NSString *msg) {
            NSLog(@"CYSinaWeiboUtil message code = %ld, message = %@", (long)code, msg);
        }];
    }
}

@end
