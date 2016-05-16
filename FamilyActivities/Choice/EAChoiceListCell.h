//
//  EAChoiceListCell.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EAChoiceListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *dayNumber;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *agreeNumber;
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;

@end
