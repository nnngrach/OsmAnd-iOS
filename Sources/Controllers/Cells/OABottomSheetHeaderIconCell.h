//
//  OABottomSheetHeaderIconCell.m
//  OsmAnd
//
//  Created by Paul on 29/05/2019.
//  Copyright © 2018 OsmAnd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OABottomSheetHeaderIconCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

+ (CGFloat) getHeight:(NSString *)text cellWidth:(CGFloat)cellWidth;

@end
