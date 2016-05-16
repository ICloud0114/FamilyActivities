//
//  EAFavoritesViewController.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/21.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EAFavoritesViewController.h"
#import "YFJLeftSwipeDeleteTableView.h"
#import "EALocalListCell.h"
#import "DataLibrary.h"
#import "FavoritiesModel.h"

#import "EADetailViewController.h"
@interface EAFavoritesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    YFJLeftSwipeDeleteTableView *favoritiesTableView;
    NSMutableArray *dataArray;
    DataLibrary *dataLib;
}
@end

@implementation EAFavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self createNavigationItem];
    
    [self createContentView];
    dataLib = [DataLibrary shareDataLibrary];
    
    dataArray = [dataLib getallDataByTable:FAVORITIES_TB];
}
- (void)createContentView
{
    favoritiesTableView = [[YFJLeftSwipeDeleteTableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT ) style:UITableViewStylePlain];
    //    [choiceTableView setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
    favoritiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    favoritiesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    [historyTableview setBackgroundColor:[UIColor redColor]];
    favoritiesTableView.delegate = self;
    favoritiesTableView.dataSource = self;
    [self.view addSubview:favoritiesTableView];
    
}
- (void)createNavigationItem
{
    
    [self.navigationItem setItemWithTitle:@"收藏" titleColor:[UIColor blackColor] fontSize:18.0f itemType:center];
    
    
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
    FavoritiesModel *model = [dataArray objectAtIndex:indexPath.row];
    
    detail.ActivityID = model.actid;
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
    FavoritiesModel *model = [dataArray objectAtIndex:indexPath.row];
    [cell.headPicture sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"boytouxiang"]];
    cell.titleLabel.text = model.title;

    cell.timeLabel.text = model.date;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%0.1f km",[model.distance floatValue] / 1000.0f];
    cell.addressLabel.text = model.site;
    cell.agreeLabel.text = model.agree;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        FavoritiesModel *model = [dataArray objectAtIndex:indexPath.row];
        [dataLib deleteProductByProductID:model.actid FromTable:FAVORITIES_TB];
        [dataArray removeObject:model];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
