//
//  ZYHttpRequest.h
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/18.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EADefine.h"
@interface ZYHttpRequest : NSObject


+(void)post:(NSDictionary *)dic keyString:(NSString *)keyString withBlock:(void(^)(id obj,NSError *error))block;

@end
