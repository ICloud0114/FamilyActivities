//
//  EACommentListCell.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/22.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EACommentListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headPicture;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentTitle;
@property (nonatomic, assign, readonly)CGFloat        cellHeight;
- (void)cellFrame:(NSDictionary*)dic;
@end
