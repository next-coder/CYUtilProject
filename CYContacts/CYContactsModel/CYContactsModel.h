//
//  CYContactsModel.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CYContactsModel <NSObject>

@required
// 显示的联系人名称
@property (nonatomic, strong, readonly) NSString *cy_nameDescription;

// 显示的联系人头像
@property (nonatomic, strong, readonly) NSString *cy_headImageUrl;

@end
