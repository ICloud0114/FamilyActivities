//
//  EASequenceView.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/4/7.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EASequenceView.h"

@implementation EASequenceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)sequenceAction:(id)sender
{
    UIButton *btn = sender;
    
    NSString *nameString;
    NSString *idString;
    switch (btn.tag)
    {
        case 100:
        {
            nameString = @"距离";
            idString = @"1";
        }
            break;
        case 101:
        {
            nameString = @"人气";
            idString = @"2";
        }
            break;
        case 102:
        {
            nameString = @"智能排序";
            idString = @"0";
        }
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(selectSequeceByName:andId:)])
    {
        [self.delegate selectSequeceByName:nameString andId:idString];
    }
    [self removeFromSuperview];
}

@end
