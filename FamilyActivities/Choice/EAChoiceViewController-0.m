//
//  EAChoiceViewController.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EAChoiceViewController.h"
#import "EADetailViewController.h"
#import "EAChoiceListCell.h"

#import "EATabBarController.h"
@interface EAChoiceViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *choiceTableView;
    ATMHud *hud;
    NSMutableArray *dataArray;
}
@end

@implementation EAChoiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.

    [self createNavigationItem];
    
    [self createContentView];
    
    [self getChoiceData];
}

- (void)createContentView
{
    choiceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - INCREMENT - NAVHEIGHT) style:UITableViewStylePlain];
    [choiceTableView setBackgroundColor:[UIColor clearColor]];
    choiceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    choiceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    [historyTableview setBackgroundColor:[UIColor redColor]];
    choiceTableView.delegate = self;
    choiceTableView.dataSource = self;
    [self.view addSubview:choiceTableView];
    hud = [[ATMHud alloc]initWithDelegate:nil];
    
    [self.view addSubview:hud.view];
//    __weak EAChoiceViewController *controller = self;
    
//    [choiceTableView addPullToRefreshWithActionHandler:^{
//        [controller getMessageList:YES];
//    }];
//    [choiceTableView addInfiniteScrollingWithActionHandler:^{
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
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 46, 30)];
    leftLabel.text = @"深圳";
    leftLabel.font = [UIFont systemFontOfSize:15];
    [self.navigationItem setItemWithCustomView:leftLabel itemType:left];
    [self.navigationItem setItemWithTitle:@"精品活动" titleColor:[UIColor blackColor] fontSize:18.0f itemType:center];
    
    
}
- (void)selectCity:(UIButton *)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 126.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    EAMessageTableViewCell *cell = (EAMessageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    EADetailViewController *detail = [[EADetailViewController alloc]init];
    detail.ActivityID = [dataArray objectAtIndex:indexPath.row][ACTID];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark tableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [dataArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID=@"cellID";
    EAChoiceListCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell==nil)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"EAChoiceListCell" owner:self options:nil]lastObject];
    }
   
    [cell.bgImage sd_setImageWithURL:[NSURL URLWithString:[dataArray objectAtIndex:indexPath.row][@"image"]] placeholderImage:[UIImage imageNamed:@"bg"]];
    cell.bgImage.contentMode = UIViewContentModeScaleToFill;

    cell.titleName.text = [dataArray objectAtIndex:indexPath.row][@"title"];
    cell.address.text = [dataArray objectAtIndex:indexPath.row][@"location"];
//    cell.dayNumber.text =   [dataArray objectAtIndex:indexPath.row][@"location"];
    cell.agreeNumber.text = [dataArray objectAtIndex:indexPath.row][@"count"];
    CGFloat distance = [[dataArray objectAtIndex:indexPath.row][@"distance"] doubleValue]/ 1000.0f;
    cell.distance.text = [NSString stringWithFormat:@"%0.1fkm",distance];
    return cell;
}
-(void)getChoiceData{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:DEVICEID forKey:MSN];
    [hud setCaption:@"加载中.."];
    [hud setActivity:YES];
    [hud show];
    [ZYHttpRequest post:dic keyString:GET_CHOICE withBlock:^(id obj, NSError *error) {
        
        [hud hide];
        NSMutableDictionary *recivedDictionary = obj;
        if ([recivedDictionary[DATA][ACTDATA] isKindOfClass:[NSArray class]])
        {
            if ([recivedDictionary[DATA][ACTDATA] count] > 0)
            {
                [dataArray setArray:recivedDictionary[DATA][ACTDATA]];
                [choiceTableView reloadData];
                
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
