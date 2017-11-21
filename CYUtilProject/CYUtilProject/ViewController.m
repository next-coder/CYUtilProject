//
//  ViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/13/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "ViewController.h"
#import "CYSendSMSUtils.h"
#import "CYAnimatedTextLabelViewController.h"
#import "CYCycleBannerViewController.h"
#import "CYIAPTestViewController.h"
#import "CYFullScreenImageView.h"
#import "CYBannerImageBrowserView.h"
#import "CYAlertView.h"
#import "CYActionSheet.h"

#import "CYQQ.h"

#import "CYContactsListTestViewController.h"
#import "CYShareSDKTestViewController.h"

#import "CYChat.h"

#import "UIImage+CYUtils.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.imageView.image = [[UIImage imageNamed:@"share_message"] cy_roundCornerimageWithCornerRadius:5];
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"CYChatViewController \u26b2";
    } else if (indexPath.row == 1) {
        
        cell.textLabel.text = @"CYSendSMSUtils \u26b2";
    } else if (indexPath.row == 2) {
        
        cell.textLabel.text = @"CYAnimatedTextLabel \u26b2";
    } else if (indexPath.row == 3) {
        
        cell.textLabel.text = @"CYCycleBannerView \u26b2";
    } else if (indexPath.row == 4) {
        
        cell.textLabel.text = @"CYBannerImageBrowserView \u26b2";
    } else if (indexPath.row == 5) {
        
        cell.textLabel.text = @"CYAlertView \u26b2";
    } else if (indexPath.row == 6) {
        
        cell.textLabel.text = @"CYIAPUtils  \u26b2";
    } else if (indexPath.row == 7) {
        
        cell.textLabel.text = @"CYContacts \u26b2";
    } else if (indexPath.row == 8) {
        
        cell.textLabel.text = @"CYActionSheet \u26b2";
    } else if (indexPath.row == 9) {
        
        cell.textLabel.text = @"CYShareSDK \u26b2";
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        CYChatUser *user1 = [[CYChatUser alloc] init];
        user1.userId = @"11";
        user1.nickname = @"天王盖地虎";
        user1.headImageUrl = @"http://mapp.xiaoniuapp.com/static/images/app_vip_icon/app_vip_03_big.png";
        
        CYChatUser *user2 = [[CYChatUser alloc] init];
        user2.userId = @"22";
        user2.nickname = @"宝塔镇河妖";
        user2.headImageUrl = @"http://mapp.xiaoniuapp.com/static/images/app_vip_icon/app_vip_03_big.png";
        
        CYChatDataSource *dataSource = [[CYChatDataSource alloc] initWithChattingUser:[[CYChatUserViewModel alloc] initWithUser:user1]
                                                                     currentLoginUser:[[CYChatUserViewModel alloc] initWithUser:user2]];
        
        CYChatViewController *chat = [[CYChatViewController alloc] initWithDataSource:dataSource];
        [self.navigationController pushViewController:chat animated:YES];
    } else if (indexPath.row ==1) {
        
        [[CYSendSMSUtils defaultInstance] sendTextSMS:@"fafsadfasdf"
                                             toMobile:@"15810542983"
                                       withCompletion:^(CYSendSMSCompletionStatus status, CYSendSMSUtils * _Nonnull sendSMSUtils) {
                                           
                                           NSLog(@"message send status : %ld", (long)status);
                                       }
                                          presentFrom:self];
    } else if (indexPath.row == 2) {
        
        CYAnimatedTextLabelViewController *vc = [[CYAnimatedTextLabelViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        
        CYCycleBannerViewController *vc = [[CYCycleBannerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 4) {
        
//        CYFullScreenImageViewController *vc = [[CYFullScreenImageViewController alloc] init];
//        [self presentViewController:vc animated:YES completion:nil];
        [CYBannerImageBrowserView showImagesInKeyWindow:@[ @"http://m2.xiaoniuapp.com/backend/images/ad/5.jpg",
                                                       @"http://m2.xiaoniuapp.com/backend/images/ad/1.jpg",
                                                       @"http://m2.xiaoniuapp.com/backend/images/ad/2.jpg",
                                                       [UIImage imageNamed:@"introduction_3_5_1.png"],
                                                       [UIImage imageNamed:@"introduction_3_5_2.png"],
                                                       [UIImage imageNamed:@"introduction_3_5_3.png"] ]
                                         placeholder:[UIImage imageNamed:@"share_message.png"]
                                   firstShowingIndex:1
                                            fromRect:CGRectMake(50, 100, 100, 100)];
    } else if (indexPath.row == 5) {
        
        
        CYAlertViewAction *action1 = [[CYAlertViewAction alloc] initWithTitle:@"试一下1" handler:^(CYAlertView *alertView, CYAlertViewAction *action) {
            
            NSLog(@"tapped : %@", action);
        }];
        action1.normalBackgroundColor = [UIColor redColor];

        CYAlertViewAction *action2 = [[CYAlertViewAction alloc] initWithTitle:@"试一下2" handler:^(CYAlertView *alertView, CYAlertViewAction *action) {
            
            NSLog(@"tapped : %@", action);
        }];
        action2.normalBackgroundColor = [UIColor greenColor];

        CYAlertViewAction *action3 = [[CYAlertViewAction alloc] initWithTitle:@"试一下3" handler:^(CYAlertView *alertView, CYAlertViewAction *action) {
            
            NSLog(@"tapped : %@", action);
        }];
        action3.normalBackgroundColor = [UIColor redColor];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_message"]];
        
        UITextField *textField1 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        textField1.backgroundColor = [UIColor redColor];
        
        UITextField *textField2 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        textField2.backgroundColor = [UIColor greenColor];
        
//        CYAlertView *alert = [[CYAlertView alloc] initWithTitle:@"fdafdaf"
//                                                        message:@"fdasjlf;dasjkfljasdklffdasfjadksl;fjakdsl;f"
//                                                    cancelTitle:nil
//                                                    actionStyle:CYAlertViewActionStyleRoundRect
//                                                    customViews:@[ imageView, textField1, textField2 ]
//                                                        actions:@[ action1, action2 ]];
//        alert.dimissOnBlankAreaTapped = YES;
//        alert.backgroundColor = [UIColor clearColor];

        CYAlertView *alert = [[CYAlertView alloc] initWithTitle:@"fdafdas"
                                                        message:@"fdafdasfds"
                                                    cancelTitle:nil
                                                    actionStyle:CYAlertViewActionStyleDefault];
        [alert addMessageView:imageView];
        [alert addMessageView:textField1];
        [alert addMessageView:textField2];
        [alert addAction:action1];
        [alert addAction:action2];
//        [alert addAction:action3];

        [alert show];
//        [alert showWithBottomInset:50];
    } else if (indexPath.row == 6) {
        
        CYIAPTestViewController *vc = [[CYIAPTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 7) {
        
        CYContactsListTestViewController *vc = [[CYContactsListTestViewController alloc] init];
//        vc.selected = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 8) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_message"]];
        UITextField *textField1 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
        textField1.backgroundColor = [UIColor redColor];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"fadjklf;asdjkfl;asjkl f;jasdkl;fjaksdl;fjasdkl;fjkasdl;fjkasdl;fjkalsd;jfkl;asdjkfl;sajkl;";
        label.numberOfLines = 0;
//        label.frame = CGRectMake(0, 0, 200, 100);
//        [label sizeToFit];
        
        CYActionSheetSection *section = [[CYActionSheetSection alloc] initWithTitle:@"分享fdal;ajf;lajkfladsjk;fasjk;fka;fjksa;fjkasl;fjkalds;fjkl;asdfa" message:@"分享内容到以下fjksal;fjkasdl;fjkals;djfkl;asjfkl;asdjfkl;asdfkl;sdajfkl;asdkfl;saf方式" contentViews:@[ imageView, textField1, label ]];
        section.showSeperatorForContents = YES;
        
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:label
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:section
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1
                                                                 constant:10];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:section
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:-10];
        [section addConstraints:@[ left, right ]];
        
        CYActionSheet *actionSheet = [[CYActionSheet alloc] initWithCancelTitle:@"取消" style:CYActionSheetStylePlain];
        [actionSheet addActionSheetSection:section];
        [actionSheet showAnimated:YES];
    } else if (indexPath.row == 9) {
        
        CYShareSDKTestViewController *share = [[CYShareSDKTestViewController alloc] init];
        [self.navigationController pushViewController:share animated:YES];
    }
}

@end
