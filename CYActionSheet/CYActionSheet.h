//
//  CYActionSheet.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/18/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CYActionSheetSection.h"
#import "CYActionSheetAction.h"

@interface CYActionSheet : UIView

@property (nonatomic, strong, readonly) NSString *cancelTitle;
@property (nonatomic, strong, readonly) CYActionSheetSection *cancelSection;
@property (nonatomic, strong, readonly) NSArray<CYActionSheetSection *> *sections;

// default YES，点击空白区域，是否dismiss
@property (nonatomic, assign) BOOL dimissOnBlankAreaTapped;

- (instancetype)initWithCancelTitle:(NSString *)cancelTitle;

- (void)addActionSheetSection:(CYActionSheetSection *)section;

#pragma mark - show
- (void)showAnimated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;

@end
