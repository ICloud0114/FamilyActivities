//
//  EASpecialViewController.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/4/13.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EASpecialViewController : UIViewController
@property (nonatomic, copy)NSDictionary *dataDict;


- (void)refreshSuperTableView:(void(^)(void))block;
@end
