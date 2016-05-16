//
//  EAAgeView.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/16.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EAAgeView.h"
#import "DataLibrary.h"
#import "AgeModel.h"
#define ROWHEIGHT 40
@implementation EAAgeView
{
    NSArray *ageArray;
    DataLibrary *dataLib;
    
}

- (void)awakeFromNib
{
    dataLib  = [DataLibrary shareDataLibrary];
    
    ageArray = [NSArray arrayWithArray:[dataLib getallDataByTable:AGE_TB]];
    self.ageTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROWHEIGHT;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(orderBySelectAge: andValue:)])
    {
        AgeModel *model = [ageArray objectAtIndex:indexPath.row];
        
        [self.delegate orderBySelectAge:model.title andValue:model.age_id];
        [self removeFromSuperview];
    }
    
}
#pragma mark tableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ageArray count];
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
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 39, SCREENWIDTH  - 20, 1)];
    [line setImage:[UIImage imageNamed:@"line_2"]];
    [cell addSubview:line];
    AgeModel *model = [ageArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    return cell;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(orderBySelectAge: andValue:)])
    {
        AgeModel *model = [ageArray firstObject];
        
        [self.delegate orderBySelectAge:model.title andValue:model.age_id];
    }
    [self removeFromSuperview];
}

@end
