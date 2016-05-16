//
//  EAAreaView.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/16.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EAAreaView.h"
#import "DataLibrary.h"
#import "FirstLevelAreaModel.h"
#import "SecondLevelAreaModel.h"

#define ROWHEIGHT 35
@implementation EAAreaView
{
    NSArray *level1Array;
    NSMutableArray *level2Array;
    DataLibrary *dataLib;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/
- (void)awakeFromNib
{
//    level1Array = @[@"福田区",@"罗湖区",@"南山区",@"盐田区",@"宝安区",@"龙岗区",@"光明新区",@"龙华新区",@"坪山新区",@"大鹏新区"];
//    
//    level2Array = @[@"所有",@"皇岗",@"景田",@"梅林",@"华强北",@"市民中心",@"竹子林"];
    level2Array = [NSMutableArray array];
    self.firstLevelTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.secondLevelTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    dataLib = [DataLibrary shareDataLibrary];
    level1Array = [dataLib getallDataByTable:FIRST_LEVEL_AREA_TB];
    
    [level2Array setArray:[dataLib getallDataByTable:SECOND_LEVEL_AREA_TB]];
    
    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.firstLevelTableView
     selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROWHEIGHT;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.firstLevelTableView)
    {
        if (indexPath.row == 0)
        {
            if ([self.delegate respondsToSelector:@selector(orderBySelectArea: andValue:)])
            {
                FirstLevelAreaModel *model = [level1Array objectAtIndex:indexPath.row];
                
                [self.delegate orderBySelectArea:model.title andValue:model.level1_id];
                [self removeFromSuperview];
            }
        }
        else
        {
            FirstLevelAreaModel *model = [level1Array objectAtIndex:indexPath.row];
            [level2Array setArray: [dataLib getDataByTable:SECOND_LEVEL_AREA_TB andSuperLevel:model.level1_id]];
        }
        
        [self.secondLevelTableView reloadData];
    }
    else if (tableView == self.secondLevelTableView)
    {
        if (indexPath.row == 0)
        {
            SecondLevelAreaModel *model = [level2Array firstObject];
            
            FirstLevelAreaModel *firstModel = [dataLib getTitleByTable:FIRST_LEVEL_AREA_TB andLevelId:model.level1_id];
            if ([self.delegate respondsToSelector:@selector(orderBySelectArea: andValue:)])
            {
                
                [self.delegate orderBySelectArea:firstModel.title andValue:firstModel.level1_id];
                [self removeFromSuperview];
            }
            
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(orderBySelectArea: andValue:)])
            {
                SecondLevelAreaModel *model = [level2Array objectAtIndex:indexPath.row];
                
                [self.delegate orderBySelectArea:model.title andValue:model.level2_id];
                [self removeFromSuperview];
            }
        }
        
    }

}
#pragma mark tableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [messageArray count];
    if (tableView == self.firstLevelTableView)
    {
        return [level1Array count];
    }
    else
    {
        return [level2Array count];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.backgroundColor = [UIColor clearColor];
//        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (tableView == self.firstLevelTableView)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, ROWHEIGHT - 1, SCREENWIDTH / 2, 1)];
        [line setImage:[UIImage imageNamed:@"line_2"]];
        [cell addSubview:line];
        
        FirstLevelAreaModel *model = [level1Array objectAtIndex:indexPath.row];
        cell.textLabel.text = model.title;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    else
    {
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 34, SCREENWIDTH / 2 - 10, 1)];
        [line setImage:[UIImage imageNamed:@"line_2"]];
        [cell addSubview:line];
        SecondLevelAreaModel *model = [level2Array objectAtIndex:indexPath.row];
        cell.textLabel.text = model.title;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return cell;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(orderBySelectArea: andValue:)])
    {
        SecondLevelAreaModel *model = [level2Array firstObject];
        
        [self.delegate orderBySelectArea:model.title andValue:model.level2_id];
        
    }
    [self removeFromSuperview];
}
@end
