//
//  CYContactsListCell.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CY_CONTACTS_LIST_CELL_LEFT_GAP  20

@interface CYContactsListCell : UITableViewCell

@property (nonatomic, weak, readonly) UIImageView *headImageView;
@property (nonatomic, weak, readonly) UIImageView *accessoryImageView;

@property (nonatomic, weak, readonly) UILabel *nameLabel;

@property (nonatomic, assign) BOOL headImageHidden;

@end
