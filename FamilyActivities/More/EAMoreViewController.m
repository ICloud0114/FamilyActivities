//
//  EAMoreViewController.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EAMoreViewController.h"

#import "EAFavoritesViewController.h"
@interface EAMoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *moreTableView;
    NSArray *dataArray;
}
@end

@implementation EAMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    // Do any additional setup after loading the view.
    [self createNavigationItem];
    [self createContentView];
}
- (void)createContentView
{
    moreTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - INCREMENT - NAVHEIGHT - TABBARHEIGHT) style:UITableViewStylePlain];
    //    [choiceTableView setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
    //    choiceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    moreTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    [historyTableview setBackgroundColor:[UIColor redColor]];
    moreTableView.delegate = self;
    moreTableView.dataSource = self;
    moreTableView.bounces = NO;
    [self.view addSubview:moreTableView];
    
    dataArray = @[@"收藏",@"关于"];
    
//    
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - TABBARHEIGHT- INCREMENT - NAVHEIGHT - 80, SCREENWIDTH , 80)];
//    footerView.backgroundColor = [UIColor clearColor];
//    
//    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
//    line.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0];
//    [footerView addSubview:line];
//    
//    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 20)];
//    label1.text = @"深圳市跃启科技有限公司";
//    label1.textAlignment = NSTextAlignmentCenter;
//    label1.backgroundColor = [UIColor clearColor];
//    label1.font = [UIFont systemFontOfSize:15];
//    label1.textColor = [UIColor lightGrayColor];
//    
//    [footerView addSubview:label1];
//    
//    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, Y(label1) + HEIGHT(label1), SCREENWIDTH, 20)];
//    label2.text = @"http://www.yueqitech.com";
//    label2.textAlignment = NSTextAlignmentCenter;
//    label2.backgroundColor = [UIColor clearColor];
//    label2.font = [UIFont systemFontOfSize:15];
//    [footerView addSubview:label2];
//    label2.textColor = [UIColor lightGrayColor];
//    
//    [self.view addSubview:footerView];

}
- (void)createNavigationItem
{
    
    [self.navigationItem setItemWithTitle:@"更多" titleColor:[UIColor blackColor] fontSize:18.0f itemType:center];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 44.0;
    if (indexPath.section == 0)
    {
        return 44.0f;
    }
    else
    {
        return HEIGHT(tableView) - 80 - 44 - 20;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    EAMessageTableViewCell *cell = (EAMessageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        EAFavoritesViewController *detail = [[EAFavoritesViewController alloc]init];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}
#pragma mark tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [messageArray count];
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
        
        UILabel  *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 9, SCREENWIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0f];
        [view addSubview:line];
        view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        return view;
        
    }
    else
    {
        return nil;
    }
   
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
        view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        UILabel  *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, SCREENWIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0f];
        [view addSubview:line];
        return view;

    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    else
    {
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *identifier = @"reuseId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *identifier = @"about";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREENWIDTH - 10, HEIGHT(tableView) - 80 - 44 - 20)];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16.0f];
//        label.backgroundColor = [UIColor redColor];
        label.text = [[NSUserDefaults standardUserDefaults]objectForKey:INFO];
        [cell addSubview:label];
        return cell;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
