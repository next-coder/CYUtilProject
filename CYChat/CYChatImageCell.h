//
//  CYChatImageCell.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/19/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatBaseCell.h"

@class CYChatImageCell;

@protocol CYChatImageCellDelegate <CYChatBaseCellDelegate>

- (void)cellDidSelectContentImage:(CYChatImageCell *)cell;

@end

@interface CYChatImageCell : CYChatBaseCell

@property (nonatomic, weak) IBOutlet id<CYChatImageCellDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;

// Draw background or not, if YES, this will draw the content arrow and round corner, if NO, this will use the contentBackgroundImageView to show the content background, default is YES
@property (nonatomic, assign) BOOL drawContentBackground;

- (IBAction)contentImageTapped:(id)sender;

- (CGSize)contentImageViewSize;

+ (CGFloat)heightOfCellWithImage:(UIImage *)image
                   hideHeadImage:(BOOL)hideHeadImage
                        hideName:(BOOL)hideName;

@end
