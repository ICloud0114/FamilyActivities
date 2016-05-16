//
//  EALocalViewController.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EALocalViewController.h"
#import "EALocalListCell.h"

#import "EADetailViewController.h"
@interface EALocalViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *localTableView;
    NSMutableArray *dataArray;
    
    ATMHud *hud;
    
    NSInteger pageIndex;
}
@end

@implementation EALocalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self createNavigationItem];
    
    [self createContentView];
    
    hud = [[ATMHud alloc]initWithDelegate:nil];
    [self.view addSubview:hud.view];
    
//    [self getLocationData];
}

- (void)createContentView
{
    localTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - INCREMENT - NAVHEIGHT ) style:UITableViewStylePlain];
    //    [choiceTableView setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
        localTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    localTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    [historyTableview setBackgroundColor:[UIColor redColor]];
    localTableView.delegate = self;
    localTableView.dataSource = self;
    [self.view addSubview:localTableView];
    
    __weak typeof(self) weakSelf = self;
    
    [localTableView addLegendHeaderWithRefreshingBlock:^{
        
        [weakSelf getLocationData:YES];
    }];
    [localTableView addLegendFooterWithRefreshingBlock:^{
        
        [weakSelf getLocationData:NO];
    }];
    
    [localTableView.header beginRefreshing];
    
//    hud = [[ATMHud alloc]initWithDelegate:nil];
    
//    [self.view addSubview:hud.view];
    //    __weak EAChoiceViewController *controller = self;
    
    //    [localTableView addPullToRefreshWithActionHandler:^{
    //        [controller getMessageList:YES];
    //    }];
    //    [localTableView addInfiniteScrollingWithActionHandler:^{
    //        [controller getMessageList:NO];
    //    }];
}
- (void)createNavigationItem
{
    
    //    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [backButton setFrame:CGRectMake(0, 0, 25, 22)];
    ////    [backButton setBackgroundImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
    //    [backButton setTitle:@"深圳" forState:UIControlStateNormal];
    //    [backButton addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.navigationItem setItemWithCustomView:backButton itemType:left];
    //    [self.navigationItem setItemWithTitle:@"深圳" titleColor:[UIColor blackColor] fontSize:15.0f itemType:left];
    
//    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 46, 30)];
//    leftLabel.text = @"深圳";
//    leftLabel.font = [UIFont systemFontOfSize:15];
//    [self.navigationItem setItemWithCustomView:leftLabel itemType:left];
    [self.navigationItem setItemWithTitle:@"附近活动" titleColor:[UIColor blackColor] fontSize:18.0f itemType:center];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EADetailViewController *detail = [[EADetailViewController alloc]init];
    detail.ActivityID = [dataArray objectAtIndex:indexPath.row][ACTID];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark tableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [messageArray count];
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
-(void)getLocationData:(BOOL)isRefresh
{
    
//    [hud setCaption:@"加载中"];
//    [hud setActivity:YES];
//    [hud show];
    
    if (isRefresh)
    {
        pageIndex = 0;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:DEVICEID forKey:MSN];
    [dic setValue:[NSNumber numberWithInteger:pageIndex] forKey:PP];
    
    [ZYHttpRequest post:dic keyString:NEARBY_ACTIVITIES withBlock:^(id obj, NSError *error) {
        
//        [hud hide];
        NSMutableDictionary *recivedDictionary = obj;
        if ([recivedDictionary[DATA][ACTDATA] isKindOfClass:[NSArray class]])
        {
            if ([recivedDictionary[DATA][ACTDATA] count] > 0)
            {
                if (isRefresh)
                {
                    [dataArray setArray:recivedDictionary[DATA][ACTDATA]];
                    [localTableView reloadData];
                    
                    [localTableView.header endRefreshing];
                    localTableView.footer.hidden = NO;
                    
                    ++ pageIndex;
                }
                else
                {
                    [dataArray addObjectsFromArray:recivedDictionary[DATA][ACTDATA]];
                    [localTableView reloadData];
                    
                    [localTableView.footer endRefreshing];
                    
                    ++ pageIndex;

                }
                
            }
        }
        else
        {
            if (isRefresh)
            {
                [localTableView.header endRefreshing];
                localTableView.footer.hidden = YES;
            }
            else
            {
                [localTableView.footer endRefreshing];
                localTableView.footer.hidden = YES;
            }
            
            
            [hud setCaption:@"无更多数据"];
            [hud show];
            [hud hideAfter:1.0];
        }
        
    }];
    
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
