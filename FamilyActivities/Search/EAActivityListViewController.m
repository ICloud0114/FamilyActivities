//
//  EAActivityListViewController.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/17.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EAActivityListViewController.h"
#import "EALocalListCell.h"

#import "EADetailViewController.h"
#import "EASequenceView.h"

#import "EASpecialViewController.h"
@interface EAActivityListViewController ()<UITableViewDataSource, UITableViewDelegate,EASequenceDelegate>
{
    UIButton *selectArea;//所有区域
    UIButton *sequenceButton;//智能排序
    NSMutableArray *dataArray;
    UITableView *searchTableView;
    EASequenceView *sequenceView;
    
    NSString *sortString;
    
    ATMHud *hud;
    
    NSInteger pageIndex;
    
}
@end

@implementation EAActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    
    sortString = @"0";//默认智能排序
    
    
    // Do any additional setup after loading the view.
    [self.navigationItem setItemWithTitle:@"活动列表" titleColor:[UIColor blackColor] fontSize:18.0f itemType:center];
    
    [self createContentView];
    
    hud = [[ATMHud alloc]initWithDelegate:nil];
    [self.view addSubview:hud.view];
    
//    [self getActivitiesList];
    
    
}
- (void)createContentView
{
    
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
    selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectView];
    selectArea = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectArea setFrame:CGRectMake(0, 0, SCREENWIDTH / 2, 34)];
//    [selectArea setBackgroundImage:[UIImage imageNamed:@"paixu-quyu"] forState:UIControlStateNormal];
//    [selectArea setBackgroundImage:[UIImage imageNamed:@"paixu-quyu"] forState:UIControlStateSelected];
    [selectArea setTitle:self.areaName forState:UIControlStateNormal];
    [selectArea setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectArea addTarget:self action:@selector(orderByArea:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:selectArea];
    
    sequenceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sequenceButton setFrame:CGRectMake(SCREENWIDTH / 2, 0, SCREENWIDTH / 2, 34)];
//    [sequenceButton setBackgroundImage:[UIImage imageNamed:@"paixu-paixugreen"] forState:UIControlStateNormal];
//    [sequenceButton setBackgroundImage:[UIImage imageNamed:@"paixu-paixu"] forState:UIControlStateSelected];
    [sequenceButton setTitle:@"  智能排序" forState:UIControlStateNormal];
    [sequenceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sequenceButton setTitleColor:[UIColor colorwithHexString:@"#FF8B84"] forState:UIControlStateSelected];
    [sequenceButton setImage:[UIImage imageNamed:@"shangjiantou"] forState:UIControlStateNormal];
    [sequenceButton setImage:[UIImage imageNamed:@"xiajiantou"] forState:UIControlStateSelected];
    [sequenceButton addTarget:self action:@selector(sequenceAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:sequenceButton];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0,  HEIGHT(selectView) - 1, SCREENWIDTH, 1)];
    [line setImage:[UIImage imageNamed:@"line_2"]];
    [selectView addSubview:line];
    
    UIImageView *line_v = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/ 2, 5, 1, 25)];
    [line_v setImage:[UIImage imageNamed:@"line_v"]];
    [selectView addSubview:line_v];
    
    searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Y(selectView) + HEIGHT(selectView), SCREENWIDTH, SCREENHEIGHT - INCREMENT - NAVHEIGHT    - HEIGHT(selectView)) style:UITableViewStylePlain];
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    searchTableView.backgroundColor = [UIColor whiteColor];
    
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    
    [self.view addSubview:searchTableView];
    
    
    __weak typeof(self) weakSelf = self;
    
    [searchTableView addLegendFooterWithRefreshingBlock:^{
        
        [weakSelf getActivitiesList:NO];
    }];
    
    [searchTableView addLegendHeaderWithRefreshingBlock:^{
        
        [weakSelf getActivitiesList:YES];
    }];
    
    [searchTableView.header beginRefreshing];
    
    
    
}
- (void)orderByArea:(UIButton *)sender
{
    
}
- (void)sequenceAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        sequenceView = [[NSBundle mainBundle]loadNibNamed:@"EASequenceView" owner:self options:nil][0];
        [sequenceView setFrame:CGRectMake(SCREENWIDTH / 2, Y(searchTableView), SCREENWIDTH / 2, 95)];
        sequenceView.delegate = self;
        [self.view addSubview:sequenceView];
    }
    else
    {
        [sequenceView removeFromSuperview];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    EADetailViewController *detail = [[EADetailViewController alloc]init];
//    detail.ActivityID = [dataArray objectAtIndex:indexPath.row][ACTID];
//    detail.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detail animated:YES];
    
    if ([[dataArray objectAtIndex:indexPath.row][TYPE] isEqualToString:@"0"])
    {
        EADetailViewController *detail = [[EADetailViewController alloc]init];
        detail.ActivityID = [dataArray objectAtIndex:indexPath.row][ACTID];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        EASpecialViewController *special = [[EASpecialViewController alloc]init];
        special.dataDict = [dataArray objectAtIndex:indexPath.row];
        special.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:special animated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseID=@"cellID";
    EALocalListCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell==nil)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"EALocalListCell" owner:self options:nil]lastObject];
    }
    [cell.headPicture sd_setImageWithURL:[NSURL URLWithString:dataArray[indexPath.row][@"image"]] placeholderImage:[UIImage imageNamed:@"info_photo_img1"]];
    cell.titleLabel.text = dataArray[indexPath.row][@"title"];
    //    cell.timeLabel.text = dataArray[indexPath.row][@"image"];
    
    if ([dataArray[indexPath.row][@"distance"] isEqualToString:@""])
    {
        cell.distanceBG.hidden = YES;
        cell.distanceLabel.hidden = YES;
    }
    else
    {
       cell.distanceLabel.text = [NSString stringWithFormat:@"%0.1f km",[dataArray[indexPath.row][@"distance"] floatValue] / 1000.0f];
    }
    
    cell.addressLabel.text = dataArray[indexPath.row][@"location"];
    cell.agreeLabel.text = dataArray[indexPath.row][@"count"];
    return cell;
    
}

- (void)getActivitiesList:(BOOL)isRefresh
{
//    [hud setCaption:@"加载中.."];
//    [hud setActivity:YES];
//    [hud show];
    if (isRefresh)
    {
        pageIndex = 0;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:DEVICEID forKey:MSN];
    
    if ([self.menuString isKindOfClass:[NSString class]])
    {
        [dic setValue:self.menuString forKey:@"w"];
    }
    else
    {
       [dic setValue:self.keyString forKey:@"w"];
    }
    [dic setValue:self.areaString forKey:@"area"];
    [dic setValue:self.ageString forKey:@"ages"];
    [dic setValue:sortString forKey:@"sort"];
    
    [dic setValue:[NSNumber numberWithInteger:pageIndex] forKey:PP];
    
    DLog(@"send dic-->%@",dic);
    [ZYHttpRequest post:dic keyString:SEARCH_BY_CLASS withBlock:^(id obj, NSError *error) {
        
//        [hud hide];
        NSMutableDictionary *recivedDictionary = obj;
        if ([recivedDictionary[DATA][ACTDATA] isKindOfClass:[NSArray class]])
        {
            if ([recivedDictionary[DATA][ACTDATA] count] > 0)
            {
                if (isRefresh)
                {
                    [dataArray setArray:recivedDictionary[DATA][ACTDATA]];
                    [searchTableView reloadData];
                    
                    [searchTableView.header endRefreshing];
                    searchTableView.footer.hidden = NO;
                    ++ pageIndex;
                }
                else
                {
                    [dataArray addObjectsFromArray:recivedDictionary[DATA][ACTDATA]];
                    [searchTableView reloadData];
                    
                    [searchTableView.footer endRefreshing];
                    
                    ++ pageIndex;
                }
            }
        }
        
        else
        {
            if (isRefresh)
            {
                [searchTableView.header endRefreshing];
                searchTableView.footer.hidden = YES;
            }
            else
            {
                [searchTableView.footer endRefreshing];
                searchTableView.footer.hidden = YES;
            }
            
            
            [hud setCaption:@"无更多数据"];
            [hud show];
            [hud hideAfter:1.0];
        }
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SequenceDelegate

- (void)selectSequeceByName:(NSString *)name andId:(NSString *)Id
{
    sequenceButton.selected = NO;
    
    [sequenceButton setTitle:[NSString stringWithFormat:@"  %@",name] forState:UIControlStateNormal];
    
    sortString = Id;
    
//    [self getActivitiesList];
    [searchTableView.header beginRefreshing];
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
