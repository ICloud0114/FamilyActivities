//
//  DataLibrary.m
//  SOMY
//
//  Created by smile on 14-10-17.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "DataLibrary.h"
#import "FavoritiesModel.h"
#import "AgeModel.h"
#import "FirstLevelAreaModel.h"
#import "SecondLevelAreaModel.h"
#import "SearchMenuModel.h"

@implementation DataLibrary
{
    FMDatabase *dataBase;
}

+(DataLibrary*)shareDataLibrary
{
    static DataLibrary *library ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (library == nil)
        {
            library = [[DataLibrary alloc] init];
        }
    });
    return library;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        path = [path  stringByAppendingPathComponent:DATABASENAME];
        dataBase = [FMDatabase databaseWithPath:path];
    }
    return self;
}

-(BOOL)creatProductTable:(NSString *)tableName
{
//    actid imageUrl title site distance date
    
    [dataBase open];
    NSString *sql = @"";
    if ([tableName isEqualToString:FAVORITIES_TB])
    {
        sql = [NSString stringWithFormat:@"create table if not exists %@ (id primary key,title varchar,imgUrl varchar,site varchar,actid varchar Unique,distance varchar,date varchar,agree varchar)",tableName];
    }
    else if([tableName isEqualToString:AGE_TB])
    {
        sql = [NSString stringWithFormat:@"create table if not exists %@ (id primary key,title varchar,age_id varchar Unique)",tableName];
    }
    else if([tableName isEqualToString:FIRST_LEVEL_AREA_TB])
    {
        sql = [NSString stringWithFormat:@"create table if not exists %@ (id primary key,title varchar,level1_id varchar Unique)",tableName];
    }
    else if([tableName isEqualToString:SECOND_LEVEL_AREA_TB])
    {
        sql = [NSString stringWithFormat:@"create table if not exists %@ (id primary key,title varchar,level1_id varchar,level2_id varchar Unique)",tableName];
    }
    else if([tableName isEqualToString:SEARCH_MENU_TB])
    {
        sql = [NSString stringWithFormat:@"create table if not exists %@ (id primary key,title varchar,search_id varchar Unique,imgUrl varchar)",tableName];
    }
    if ([dataBase executeUpdate:sql])
    {
        [dataBase close];
        return YES;
    }
    else
    {
        [dataBase close];
        return NO;
    }
    
}

- (NSMutableArray *)getDataByTable:(NSString *)tableName andSuperLevel:(NSString *)firstLevel
{
    
    [dataBase open];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where level1_id= '%@'",tableName,firstLevel];

    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([rs next])
    {
        SecondLevelAreaModel *model = [[SecondLevelAreaModel alloc]init];
        model.title = [rs stringForColumn:@"title"];
        model.level1_id = [rs stringForColumn:@"level1_id"];
        model.level2_id = [rs stringForColumn:@"level2_id"];
        [arr addObject:model];
        
        DLog(@"table-- >%@ -->%@ -->%@",tableName,model.level1_id,model.level2_id);
    }
    [dataBase close];
    
    return arr;
}
- (id)getFirstDataByTable:(NSString *)tableName
{
    [dataBase open];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by id ASC",tableName];
    
    FMResultSet *rs = [dataBase executeQuery:sql];
    
    if ([tableName isEqualToString:FAVORITIES_TB])
    {
        while ([rs next])
        {
            FavoritiesModel *model = [[FavoritiesModel alloc]init];
            model.title = [rs stringForColumn:@"title"];
            model.imgUrl = [rs stringForColumn:@"imgUrl"];
            model.site = [rs stringForColumn:@"site"];
            model.actid = [rs stringForColumn:@"actid"];
            model.distance = [rs stringForColumn:@"distance"];
            model.date = [rs stringForColumn:@"date"];
            model.agree = [rs stringForColumn:@"agree"];
            DLog(@"table-- >%@ id-->%@",tableName,model.actid);
            return model;
        }
    }
    else if([tableName isEqualToString:AGE_TB])
    {
        while ([rs next])
        {
            AgeModel *model = [[AgeModel alloc]init];
            model.title = [rs stringForColumn:@"title"];
            model.age_id = [rs stringForColumn:@"age_id"];
            
            DLog(@"table-- >%@ id-->%@",tableName,model.age_id);
            
            return model;
        }
    }
    else if([tableName isEqualToString:FIRST_LEVEL_AREA_TB])
    {
        while ([rs next])
        {
            FirstLevelAreaModel *model = [[FirstLevelAreaModel alloc]init];
            model.title = [rs stringForColumn:@"title"];
            model.level1_id = [rs stringForColumn:@"level1_id"];
            
            //            DLog(@"table-- >%@ id-->%@",tableName,model.level1_id);
            return model;
        }
    }
    else if([tableName isEqualToString:SECOND_LEVEL_AREA_TB])
    {
        while ([rs next])
        {
            SecondLevelAreaModel *model = [[SecondLevelAreaModel alloc]init];
            model.title = [rs stringForColumn:@"title"];
            model.level1_id = [rs stringForColumn:@"level1_id"];
            model.level2_id = [rs stringForColumn:@"level2_id"];
            
            DLog(@"table-- >%@ id-->%@",tableName,model.level2_id);
            return model;
        }
    }
    else if([tableName isEqualToString:SEARCH_MENU_TB])
    {
        while ([rs next])
        {
            SearchMenuModel *model = [[SearchMenuModel alloc]init];
            model.title = [rs stringForColumn:@"title"];
            model.search_id = [rs stringForColumn:@"search_id"];
            model.imgUrl = [rs stringForColumn:@"imgUrl"];
            
            DLog(@"table-- >%@ id-->%@",tableName,model.search_id);
            return model;
        }
    }
    
    [dataBase close];
    return nil;
}

- (id)getTitleByTable:(NSString *)tableName andLevelId:(NSString *)Id
{
    [dataBase open];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where level1_id= '%@'",tableName,Id];
    
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([rs next])
    {
        FirstLevelAreaModel *model = [[FirstLevelAreaModel alloc]init];
        model.title = [rs stringForColumn:@"title"];
        model.level1_id = [rs stringForColumn:@"level1_id"];
        [arr addObject:model];
        
        DLog(@"table-- >%@ -->%@",tableName,model.level1_id);
        
        return model;
    }
    [dataBase close];
    
    return nil;

}

- (NSMutableArray*)getallDataByTable:(NSString *)tableName
{
    [dataBase open];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by id ASC",tableName];

    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    
    if ([tableName isEqualToString:FAVORITIES_TB])
    {
        while ([rs next])
        {
            FavoritiesModel *model = [[FavoritiesModel alloc]init];
            model.title = [rs stringForColumn:@"title"];
            model.imgUrl = [rs stringForColumn:@"imgUrl"];
            model.site = [rs stringForColumn:@"site"];
            model.actid = [rs stringForColumn:@"actid"];
            model.distance = [rs stringForColumn:@"distance"];
            model.date = [rs stringForColumn:@"date"];
            model.agree = [rs stringForColumn:@"agree"];
            [arr addObject:model];
            
            DLog(@"table-- >%@ id-->%@",tableName,model.actid);
        }
    }
    else if([tableName isEqualToString:AGE_TB])
    {
        while ([rs next])
        {
            AgeModel *model = [[AgeModel alloc]init];
            model.title = [rs stringForColumn:@"title"];
            model.age_id = [rs stringForColumn:@"age_id"];
            [arr addObject:model];
            
            DLog(@"table-- >%@ id-->%@",tableName,model.age_id);
        }
    }
    else if([tableName isEqualToString:FIRST_LEVEL_AREA_TB])
    {
        while ([rs next])
        {
            FirstLevelAreaModel *model = [[FirstLevelAreaModel alloc]init];
            model.title = [rs stringForColumn:@"title"];
            model.level1_id = [rs stringForColumn:@"level1_id"];
            [arr addObject:model];
            
//            DLog(@"table-- >%@ id-->%@",tableName,model.level1_id);
        }
    }
    else if([tableName isEqualToString:SECOND_LEVEL_AREA_TB])
    {
        while ([rs next])
        {
            SecondLevelAreaModel *model = [[SecondLevelAreaModel alloc]init];
            model.title = [rs stringForColumn:@"title"];
            model.level1_id = [rs stringForColumn:@"level1_id"];
            model.level2_id = [rs stringForColumn:@"level2_id"];
            [arr addObject:model];
            
            DLog(@"table-- >%@ id-->%@",tableName,model.level2_id);
        }
    }
    else if([tableName isEqualToString:SEARCH_MENU_TB])
    {
        while ([rs next])
        {
            SearchMenuModel *model = [[SearchMenuModel alloc]init];
            model.title = [rs stringForColumn:@"title"];
            model.search_id = [rs stringForColumn:@"search_id"];
            model.imgUrl = [rs stringForColumn:@"imgUrl"];
            [arr addObject:model];
            
            DLog(@"table-- >%@ id-->%@",tableName,model.search_id);
        }
    }
    
    [dataBase close];
    
    return arr;
}

//- (NSString *)getMaxTemperatureFromTable:(NSString *)tableName
//{
//    
//    NSString *sql = [NSString stringWithFormat:@"SELECT MAX(TEMP) FROM %@",tableName];
//    
//    FMResultSet *rs = [dataBase executeQuery:sql];
//
//    while ([rs next])
//    {
//        NSString *string = [rs stringForColumnIndex:0];
//        return string;
//    }
//    return 0;
//}

- (BOOL)insertData:(NSDictionary *)data intoTable:(NSString *)tableName
{
//    NSString *sql = [NSString stringWithFormat:@"create table if not exists Activities (id primary key,title varchar,imageUrl varchar,site varchar,actid varchar Unique,distance varchar,date varchar)"];

//        sql = [NSString stringWithFormat:@"create table if not exists %@ (id primary key,title varchar,age_id varchar)",tableName];
//        sql = [NSString stringWithFormat:@"create table if not exists %@ (id primary key,title varchar,level1_id varchar)",tableName];

//        sql = [NSString stringWithFormat:@"create table if not exists %@ (id primary key,title varchar,level1_id varchar,level2_id varchar)",tableName];

//        sql = [NSString stringWithFormat:@"create table if not exists %@ (id primary key,title varchar,search_id,imgUrl varchar)",tableName];



    [dataBase open];
    
    NSString *sql = @"";
    if ([tableName isEqualToString:FAVORITIES_TB])
    {
        sql = [NSString stringWithFormat:@"replace into %@ (title,imgUrl,site,actid,distance,date,agree) values ('%@','%@','%@','%@','%@','%@','%@')",tableName, data[@"title"], data[@"imgUrl"], data[@"site"], data[@"actid"], data[@"distance"],data[@"date"],data[@"agree"]];
    }
    else if([tableName isEqualToString:AGE_TB])
    {
        sql = [NSString stringWithFormat:@"replace into %@ (title,age_id) values ('%@','%@')",tableName, data[@"name"], data[@"value"]];
    }
    else if([tableName isEqualToString:FIRST_LEVEL_AREA_TB])
    {
        sql = [NSString stringWithFormat:@"replace into %@ (title,level1_id) values ('%@','%@')",tableName, data[@"name"], data[@"value"]];
    }
    else if([tableName isEqualToString:SECOND_LEVEL_AREA_TB])
    {
       sql = [NSString stringWithFormat:@"replace into %@ (title,level1_id,level2_id) values ('%@','%@','%@')",tableName, data[@"name"], data[@"super_level"], data[@"value"]];
    }
    else if([tableName isEqualToString:SEARCH_MENU_TB])
    {
        sql = [NSString stringWithFormat:@"replace into %@ (title,search_id,imgUrl) values ('%@','%@','%@')",tableName, data[@"name"], data[@"value"], data[@"image"]];
    }
    
    if ([dataBase executeUpdate:sql])
    {
        [dataBase close];
        return YES;
    }
    else
    {
        DLog(@"ERROR----> %@",[dataBase lastError]);
        [dataBase close];
        return NO;
    }
    
}


//- (BOOL)deleteData:(NSDictionary *)data withTime:(NSString *)time
//{
//    return [dataBase executeUpdate:@"delete from Product where time = ?",time] ;
//}
- (BOOL)deleteProductByProductID:(NSString *)pid FromTable:(NSString *)tableName
{

    [dataBase open];
     NSString *sql = [NSString stringWithFormat:@"delete from %@ where actid = %@",tableName,pid];
    if ([dataBase executeUpdate:sql])
    {
        [dataBase close];
        DLog(@"删除成功");
        return YES;
    }
    else
    {
        [dataBase close];
        DLog(@"删除失败");
        DLog(@"ERROR----> %@",[dataBase lastError]);
        return NO;
    }
}
- (BOOL)cleanTable:(NSString *)name
{
    return [dataBase executeUpdate:@"delete from temperature"];
}

- (BOOL)deleteTable:(NSString *)name
{
    NSString *sql = [NSString stringWithFormat:@"drop table %@",name];
    return [dataBase executeUpdate:sql];
}
//查找数据库中所有表名
- (BOOL)queryByTableName:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"select * from sqlite_master where type = 'table'"];
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([rs next])
    {
        NSString *string = [rs stringForColumn:@"name"];
        [arr addObject:string];
    }
    return YES;
}

@end
