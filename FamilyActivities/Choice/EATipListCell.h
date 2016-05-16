//
//  EATipListCell.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EATipListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headPicture;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, assign, readonly)CGFloat        cellHeight;
- (void)cellFrame:(NSDictionary*)dic;
@end
