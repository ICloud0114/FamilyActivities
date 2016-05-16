//
//  EACommentView.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EASubmitCommentSuccess <NSObject>

- (void)submitCommentSuccess;

@end
@interface EACommentView : UIView
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, copy) NSString * activityId; //活动编号
@property (weak, nonatomic)id<EASubmitCommentSuccess> delegate;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end
