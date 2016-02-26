//
//  CYChatImageCell.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/19/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatBaseCell.h"

@interface CYChatImageCell : CYChatBaseCell

//// Draw background or not, if YES, this will draw the content arrow and round corner, if NO, this will use the contentBackgroundImageView to show the content background, default is YES
//@property (nonatomic, assign) BOOL drawContentBackground;

- (CGSize)contentImageViewSize;

+ (CGFloat)heightOfCellWithImage:(UIImage *)image
                   hideHeadImage:(BOOL)hideHeadImage
                        hideName:(BOOL)hideName;

@end
