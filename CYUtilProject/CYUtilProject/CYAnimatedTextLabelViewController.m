//
//  CYAnimatedTextLabelViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/29/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYAnimatedTextLabelViewController.h"
#import "CYAnimatedTextLabel.h"

@interface CYAnimatedTextLabelViewController () <CYAnimatedTextLabelDelegate>

@property (nonatomic, weak) CYAnimatedTextLabel *label;

@end

@implementation CYAnimatedTextLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    CYAnimatedTextLabel *label = [[CYAnimatedTextLabel alloc] initWithFrame:CGRectMake(10, 100, 200, 50)];
    label.backgroundColor = [UIColor redColor];
    label.delegate = self;
    [self.view addSubview:label];
    _label = label;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"back" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    back.frame = CGRectMake(10, 20, 50, 50);
    [back addTarget:self action:@selector(backToPrevios:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeCustom];
    [reset setTitle:@"再来一次" forState:UIControlStateNormal];
    [reset setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    reset.frame = CGRectMake(200, 20, 100, 50);
    [reset addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reset];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reset:nil];
}

- (void)backToPrevios:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reset:(id)sender {
    
    [_label startAnimatingTextWithDuration:0.5f];
}

#pragma mark - CYAnimatedTextLabelDelegate
- (NSString *)textWithAnimationProgress:(CGFloat)progress {
    
    return [NSString stringWithFormat:@"%.2f", progress];
}

- (void)textAniamtionDidEnd {
    
    
}

@end
