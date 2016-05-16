//
//  EASequenceView.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/4/7.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EASequenceDelegate <NSObject>

- (void)selectSequeceByName:(NSString *)name andId:(NSString *)Id;

@end

@interface EASequenceView : UIView
@property (nonatomic, weak)id<EASequenceDelegate> delegate;
@end
