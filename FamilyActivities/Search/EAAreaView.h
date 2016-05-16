//
//  EAAreaView.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/16.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EAAreaDelegate <NSObject>

- (void)orderBySelectArea:(NSString *)area andValue:(NSString *)value;

@end

@interface EAAreaView : UIView
@property (weak, nonatomic) IBOutlet UITableView *firstLevelTableView;
@property (weak, nonatomic) IBOutlet UITableView *secondLevelTableView;

@property (nonatomic, weak) id<EAAreaDelegate> delegate;
@end
