//
//  ZYHttpRequest.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/18.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "ZYHttpRequest.h"
#import "MKNetworkEngine.h"
#import "MKNetworkOperation.h"
#import "JSONKit.h"
@implementation ZYHttpRequest


+(void)post:(NSDictionary *)dic keyString:(NSString *)keyString withBlock:(void (^)(id, NSError *))block
{
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:BASEURL customHeaderFields:nil];
    
    
    MKNetworkOperation *op = [engine operationWithPath:keyString params:dic httpMethod:@"POST"];
    
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        DLog(@"data--> %@",completedOperation);
        
        if (block) {
            
            NSString *jsonString = [completedOperation responseString];
            NSDictionary *dics = [jsonString objectFromJSONString];
            DLog(@"get Data -->%@",dics);
            NSMutableDictionary *mtaDic =
            [NSMutableDictionary
             dictionaryWithDictionary:dics];
            block(mtaDic, nil);
        }
        
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        block(nil, error);
    }];
    
    
    [engine enqueueOperation:op];
    
}

@end
