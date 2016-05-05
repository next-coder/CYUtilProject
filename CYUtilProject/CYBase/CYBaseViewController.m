//
//  CYBaseViewController.m
//  MoneyJar2
//
//  Created by Charry on 6/3/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import "CYBaseViewController.h"

@interface CYBaseViewController ()

@end

@implementation CYBaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)cy_backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setHideBackButton:(BOOL)hideBackButton {
    
    _hideBackButton = hideBackButton;
    _navigationBackButton.hidden = hideBackButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_hideBackButton) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        _navigationBackButton.hidden = _hideBackButton;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (_hideBackButton) {
        
        // 如果隐藏了返回按钮，则手势返回也应该禁用
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    if (_hideBackButton) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - resignFirstResponderTapGestureRecognizer
- (void)cy_setNeedsResignFirstResponderTap {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTappedInBase:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    _resignFirstResponderTapGestureRecognizer = tap;
}

- (void)cy_removeResignFirstResponderTap {
    
    [_resignFirstResponderTapGestureRecognizer removeTarget:self action:@selector(viewTappedInBase:)];
    _resignFirstResponderTapGestureRecognizer.delegate = nil;
    [self.view removeGestureRecognizer:_resignFirstResponderTapGestureRecognizer];
}

#pragma mark - tap
- (void)viewTappedInBase:(id)sender {
    
    [self.view endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer
        || otherGestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        
        return YES;
    }
    return NO;
}

@end
