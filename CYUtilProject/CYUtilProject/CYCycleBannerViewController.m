//
//  CYCycleBannerViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/4/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYCycleBannerViewController.h"

#import "CYCycleBannerView.h"

@implementation CYCycleBannerViewController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CYCycleBannerView *banner = [[CYCycleBannerView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 100)];
    [banner setImages:@[ @"http://m2.xiaoniuapp.com/backend/images/ad/5.jpg",
                         @"http://m2.xiaoniuapp.com/backend/images/ad/1.jpg",
                         @"http://m2.xiaoniuapp.com/backend/images/ad/2.jpg",
                         [UIImage imageNamed:@"introduction_3_5_1.png"],
                         [UIImage imageNamed:@"introduction_3_5_2.png"],
                         [UIImage imageNamed:@"introduction_3_5_3.png"] ]
          placeholder:nil
           continuous:YES];
    [self.view addSubview:banner];
    
    CYCycleBannerView *banner2 = [[CYCycleBannerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 100)];
    [banner2 setImages:@[ @"http://m2.xiaoniuapp.com/backend/images/ad/5.jpg",
                          @"http://m2.xiaoniuapp.com/backend/images/ad/1.jpg",
                          @"http://m2.xiaoniuapp.com/backend/images/ad/2.jpg",
                          [UIImage imageNamed:@"introduction_3_5_1.png"],
                         [UIImage imageNamed:@"introduction_3_5_2.png"],
                         [UIImage imageNamed:@"introduction_3_5_3.png"] ]
           placeholder:nil
           continuous:NO];
    [self.view addSubview:banner2];
    
    CYCycleBannerView *banner3 = [[CYCycleBannerView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 100)];
    [banner3 setImages:@[ @"http://m2.xiaoniuapp.com/backend/images/ad/5.jpg" ]
           placeholder:nil
            continuous:YES];
    [self.view addSubview:banner3];
}

@end
