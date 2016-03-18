//
//  CYContactsListHeaderView.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYContactsListHeaderView.h"

@implementation CYContactsListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createContactsListHeaderSubviews];
        self.backgroundColor = [UIColor colorWithRed:240/255.f
                                               green:239/255.f
                                                blue:245/255.f
                                               alpha:1];
//        self.backgroundColor = [UIColor colorFromHexString:@"#f4f8fb"];
    }
    return self;
}

- (void)createContactsListHeaderSubviews {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(20, 0, self.frame.size.width - 40, self.frame.size.height);
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:label];
    _titleLabel = label;
}

@end
