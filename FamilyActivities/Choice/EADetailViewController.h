//
//  EADetailViewController.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADetailViewController : UIViewController


@property (nonatomic, copy)NSString* ActivityID;


- (void)refreshChoiceTableView:(void(^)(void))block;
@end
