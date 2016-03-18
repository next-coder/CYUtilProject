//
//  CYContactViewModel.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CYContacts.h"

@interface CYContactViewModel : NSObject <CYContactsModel>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;

@end
