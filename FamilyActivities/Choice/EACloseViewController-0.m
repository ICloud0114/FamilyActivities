//
//  EACloseViewController.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/25.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EACloseViewController.h"
#import "EALocalListCell.h"
@interface EACloseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *closeTableView;
    NSMutableArray *dataArray;
}


@end

@implementation EACloseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self createNavigationItem];
    
    [self createContentView];
    [self getCloseActivityData];
}
- (void)createContentView
{
    closeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - INCREMENT - NAVHEIGHT ) style:UITableViewStylePlain];
    //    [choiceTableView setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
    closeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    closeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    [historyTableview setBackgroundColor:[UIColor redColor]];
    closeTableView.delegate = self;
    closeTableView.dataSource = self;
    [self.view addSubview:closeTableView];
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
    [self.navigationItem setItemWithTitle:@"相关活动" titleColor:[UIColor blackColor] fontSize:18.0f itemType:center];
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
    
    //    EAMessageTableViewCell *cell = (EAMessageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    //    EADetailViewController *detail = [[EADetailViewController alloc]init];
    //    detail.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:detail animated:YES];
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
    
    [cell.headPicture sd_setImageWithURL:[NSURL URLWithString:dataArray[indexPath.row][@"image"]] placeholderImage:[UIImage imageNamed:@"boytouxiang"]];
    cell.titleLabel.text = dataArray[indexPath.row][@"title"];
    //    cell.timeLabel.text = dataArray[indexPath.row][@"image"];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%0.1f km",[dataArray[indexPath.row][@"distance"] floatValue] / 1000.0f];
    cell.addressLabel.text = dataArray[indexPath.row][@"location"];
    cell.agreeLabel.text = dataArray[indexPath.row][@"count"];
    return cell;
}
-(void)getCloseActivityData{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:DEVICEID forKey:MSN];
    [dic setValue:self.actID forKey:ID];
    [dic setValue:@"0" forKey:@"pp"];
    [ZYHttpRequest post:dic keyString:CLOSE_ACTIVITIES withBlock:^(id obj, NSError *error) {
        NSMutableDictionary *recivedDictionary = obj;
        if ([recivedDictionary[DATA][ACTDATA] isKindOfClass:[NSArray class]])
        {
            if ([recivedDictionary[DATA][ACTDATA] count] > 0)
            {
                [dataArray setArray:recivedDictionary[DATA][ACTDATA]];
                [closeTableView reloadData];
                
            }
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
