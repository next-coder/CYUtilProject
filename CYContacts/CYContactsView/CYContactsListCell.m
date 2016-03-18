//
//  CYContactsListCell.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYContactsListCell.h"

@interface CYContactsListCell ()

@property (nonatomic, weak) NSLayoutConstraint *nameLeftConstraint;

@end

@implementation CYContactsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createContactsListSubviews];
        [self createConstraintsForSubviews];
        
        self.separatorInset = UIEdgeInsetsMake(0, CY_CONTACTS_LIST_CELL_LEFT_GAP, 0, 0);
    }
    return self;
}

- (void)createContactsListSubviews {
    
    UIImageView *head = [[UIImageView alloc] init];
    head.backgroundColor = [UIColor redColor];
    head.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:head];
    _headImageView = head;
    
    UIImageView *accessory = [[UIImageView alloc] init];
    accessory.backgroundColor = [UIColor redColor];
    accessory.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:accessory];
    _accessoryImageView = accessory;
    
    UILabel *name = [[UILabel alloc] init];
    name.backgroundColor = [UIColor redColor];
    name.font = [UIFont systemFontOfSize:15];
    name.textColor = [UIColor darkGrayColor];
    name.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:name];
    _nameLabel = name;
}

- (void)createConstraintsForSubviews {
    
    NSLayoutConstraint *headLeft = [NSLayoutConstraint constraintWithItem:_headImageView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.contentView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1
                                                                 constant:CY_CONTACTS_LIST_CELL_LEFT_GAP];
    NSLayoutConstraint *headCenterY = [NSLayoutConstraint constraintWithItem:_headImageView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.contentView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1
                                                                    constant:0];
    NSLayoutConstraint *headWidth = [NSLayoutConstraint constraintWithItem:_headImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:35];
    NSLayoutConstraint *headHeight = [NSLayoutConstraint constraintWithItem:_headImageView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:35];
    [self addConstraints:@[ headLeft, headCenterY, headWidth, headHeight ]];
    
    NSLayoutConstraint *nameLeft = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_headImageView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:10];
    NSLayoutConstraint *nameCenterY = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.contentView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1
                                                                    constant:0];
    [self addConstraints:@[ nameLeft, nameCenterY ]];
    _nameLeftConstraint = nameLeft;
    
    NSLayoutConstraint *accessoryRight = [NSLayoutConstraint constraintWithItem:_accessoryImageView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1
                                                                       constant:-20];
    NSLayoutConstraint *accessoryCenterY = [NSLayoutConstraint constraintWithItem:_accessoryImageView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1
                                                                         constant:0];
    NSLayoutConstraint *accessoryWidth = [NSLayoutConstraint constraintWithItem:_accessoryImageView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1
                                                                       constant:15];
    NSLayoutConstraint *accessoryHeight = [NSLayoutConstraint constraintWithItem:_accessoryImageView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:15];
    [self addConstraints:@[ accessoryRight, accessoryCenterY, accessoryWidth, accessoryHeight ]];
}

#pragma mark - setter
- (void)setHeadImageHidden:(BOOL)headImageHidden {
    
    if (_headImageHidden != headImageHidden) {
        
        _headImageHidden = headImageHidden;
        
        self.headImageView.hidden = headImageHidden;
        [self refreshNameLayout];
    }
}

- (void)refreshNameLayout {
    
    // 删除原来的constraint
    [self removeConstraint:self.nameLeftConstraint];
    if (self.headImageHidden) {
        
        NSLayoutConstraint *nameLeft = [NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1
                                                                     constant:CY_CONTACTS_LIST_CELL_LEFT_GAP];
        [self addConstraint:nameLeft];
    } else {
        
        NSLayoutConstraint *nameLeft = [NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.headImageView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1
                                                                     constant:10];
        [self addConstraint:nameLeft];
    }
}

@end
