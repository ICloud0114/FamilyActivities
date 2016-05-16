//
//  EAAgeView.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/16.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EAAgeDelegate <NSObject>

- (void)orderBySelectAge:(NSString *)age andValue:(NSString *)value;

@end
@interface EAAgeView : UIView


@property (weak, nonatomic) IBOutlet UITableView *ageTableView;
@property (nonatomic, weak) id<EAAgeDelegate> delegate;
@end
