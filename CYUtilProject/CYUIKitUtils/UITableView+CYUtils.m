//
//  UITableView+CYUtils.m
//  CYUtilProject
//
//  Created by xn011644 on 6/1/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "UITableView+CYUtils.h"

@implementation UITableView (CYUtils)

- (NSIndexPath *)cy_indexPathForCell:(UITableViewCell *)cell {

    if (!cell) {

        return nil;
    }
    CGPoint cellPoint = [cell convertPoint:cell.contentView.center toView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:cellPoint];

    return indexPath;
}

@end
