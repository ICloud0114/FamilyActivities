//
//  EALocalListCell.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/21.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EALocalListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headPicture;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *distanceBG;

@end
