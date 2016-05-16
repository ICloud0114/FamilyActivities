//
//  EATitleCell.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/22.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EATitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *openTimeTitle;

@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (nonatomic, assign, readonly)CGFloat        cellHeight;
- (void)cellFrame:(NSDictionary*)dic;
@end
