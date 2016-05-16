//
//  EASearchViewController.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EASearchViewController.h"

#import "EAAgeView.h"
#import "EAAreaView.h"

#import "EAActivityListViewController.h"
#import "DataLibrary.h"
#import "SearchMenuModel.h"
#import "FirstLevelAreaModel.h"
#import "AgeModel.h"

#import "EASearchCell.h"
@interface EASearchViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,EAAreaDelegate,EAAgeDelegate>
{
    NSArray *dataArray;
    UIButton *selectArea;
    UIButton *selectAge;
    EAAgeView *ageView;
    EAAreaView *areaView;
    DataLibrary *dataLib;
    UITableView *searchTableView;
    UITextField *searchTextField;
    NSString *areaString;
    NSString *ageString;
    NSString *keyString;
    NSString *searchString;
    
}
@end

@implementation EASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    // Do any additional setup after loading the view.
//    dataArray = @[@"主题/专题",@"户外活动",@"轻松娱乐",@"接触大自然",@"DIY手动/体验",@"本周活动",@"当季活动"];
    dataLib  = [DataLibrary shareDataLibrary];
    dataArray = [NSArray arrayWithArray:[dataLib getallDataByTable:SEARCH_MENU_TB]];
    
    if ([[dataLib getFirstDataByTable:FIRST_LEVEL_AREA_TB] isKindOfClass:[FirstLevelAreaModel class]])
    {
        FirstLevelAreaModel *areaModel = [dataLib getFirstDataByTable:FIRST_LEVEL_AREA_TB];
        areaString = areaModel.level1_id;
    }
    
    if ([[dataLib getFirstDataByTable:AGE_TB] isKindOfClass:[AgeModel class]])
    {
        AgeModel *ageModel = [dataLib getFirstDataByTable:AGE_TB];
        ageString = ageModel.age_id;
    }
    
    [self.navigationItem setItemWithTitle:@"找活动" titleColor:[UIColor blackColor] fontSize:18.0f itemType:center];
    
    [self createContentView];
}
- (void)createContentView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
    topView.backgroundColor = [UIColor colorwithHexString:@"#FF8B84"];
    UIImageView *searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, SCREENWIDTH - 40, 35)];
    [searchImage setImage:[UIImage imageNamed:@"search_icon"]];
    [topView addSubview:searchImage];
    [self.view addSubview:topView];
    searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 12, SCREENWIDTH - 80, 20)];
    searchTextField.placeholder = @"搜索";
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.delegate = self;
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.backgroundColor = [UIColor clearColor];
    [topView addSubview:searchTextField];
    
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, Y(topView) + HEIGHT(topView), SCREENWIDTH, 35)];
    selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectView];
    selectArea = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectArea setFrame:CGRectMake(0, 0, SCREENWIDTH / 2, 35)];
//    [selectArea setBackgroundImage:[UIImage imageNamed:@"quanbuquyu"] forState:UIControlStateNormal];
//    [selectArea setBackgroundImage:[UIImage imageNamed:@"quanbuquyu-fen"] forState:UIControlStateSelected];
    [selectArea setTitle:@"  全部区域" forState:UIControlStateNormal];
    [selectArea setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectArea setTitleColor:[UIColor colorwithHexString:@"#FF8B84"] forState:UIControlStateSelected];
    [selectArea setImage:[UIImage imageNamed:@"shangjiantou"] forState:UIControlStateNormal];
    [selectArea setImage:[UIImage imageNamed:@"xiajiantou"] forState:UIControlStateSelected];
    [selectArea addTarget:self action:@selector(orderByArea:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:selectArea];
    
    selectAge = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectAge setFrame:CGRectMake(SCREENWIDTH / 2, 0, SCREENWIDTH / 2, 35)];
//    [selectAge setBackgroundImage:[UIImage imageNamed:@"suoyounianling-black"] forState:UIControlStateNormal];
//    [selectAge setBackgroundImage:[UIImage imageNamed:@"suoyounianling-fen"] forState:UIControlStateSelected];
    
    [selectAge setTitle:@"  所有年龄" forState:UIControlStateNormal];
    [selectAge setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAge setTitleColor:[UIColor colorwithHexString:@"#FF8B84"] forState:UIControlStateSelected];
    [selectAge setImage:[UIImage imageNamed:@"shangjiantou"] forState:UIControlStateNormal];
    [selectAge setImage:[UIImage imageNamed:@"xiajiantou"] forState:UIControlStateSelected];
    [selectAge addTarget:self action:@selector(orderByAge:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:selectAge];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, Y(selectAge) + HEIGHT(selectAge) - 1, SCREENWIDTH, 1)];
    [line setImage:[UIImage imageNamed:@"line_2"]];
    [selectView addSubview:line];
    
    UIImageView *line_v = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/ 2, 5, 1, 25)];
    [line_v setImage:[UIImage imageNamed:@"line_v"]];
    [selectView addSubview:line_v];
    
    searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Y(selectView) + HEIGHT(selectView), SCREENWIDTH, SCREENHEIGHT - INCREMENT - NAVHEIGHT - TABBARHEIGHT  - HEIGHT(topView) - HEIGHT(selectView)) style:UITableViewStylePlain];
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    searchTableView.backgroundColor = [UIColor whiteColor];
    
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    
    [self.view addSubview:searchTableView];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchMenuModel *model = [dataArray objectAtIndex:indexPath.row];
    
    EAActivityListViewController *activityList = [[EAActivityListViewController alloc]init];
    
    activityList.menuString = model.search_id;
    activityList.areaString = areaString;
    activityList.ageString  = ageString;
     activityList.areaName = selectArea.titleLabel.text;
    activityList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityList animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==searchTableView )
    {
        static NSString *reuseID=@"search";
        EASearchCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
        if (cell==nil)
        {
            cell =  [[NSBundle mainBundle]loadNibNamed:@"EASearchCell" owner:self options:nil][0];
            
        }
        
        SearchMenuModel *model = [dataArray objectAtIndex:indexPath.row];

        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
        
        cell.titleLabel.text = model.title;
        return cell;
    }
    return nil;

}

- (void)orderByArea:(UIButton *)sender
{
    if (selectAge.selected)
    {
        selectAge.selected = NO;
        [ageView removeFromSuperview];
    }
    if (selectArea.selected)
    {
        [areaView removeFromSuperview];
    }
    else
    {
        areaView = [[NSBundle mainBundle]loadNibNamed:@"EAAreaView" owner:self options:nil][0];
        [areaView setFrame:CGRectMake(0, INCREMENT + NAVHEIGHT + 45 + 35, SCREENWIDTH, SCREENHEIGHT - INCREMENT - NAVHEIGHT - 45 - 35)];
        areaView.delegate = self;
        [self.view.window addSubview:areaView];
    }
    sender.selected = !sender.selected;
}

- (void)orderByAge:(UIButton *)sender
{
    if (selectArea.selected)
    {
        selectArea.selected = NO;
        [areaView removeFromSuperview];
    }
    if (sender.selected)
    {
        [ageView removeFromSuperview];
    }
    else
    {
        
        ageView = [[NSBundle mainBundle]loadNibNamed:@"EAAgeView" owner:self options:nil][0];
        [ageView setFrame:CGRectMake(0, INCREMENT + NAVHEIGHT + 45 + 35, SCREENWIDTH, SCREENHEIGHT - INCREMENT - NAVHEIGHT - 45 - 35)];
        ageView.delegate = self;
        [self.view.window addSubview:ageView];
    }
    sender.selected = !sender.selected;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark EASelectAreaDelegate

- (void)orderBySelectArea:(NSString *)area andValue:(NSString *)value
{
    selectArea.selected = NO;
    
    [selectArea setTitle:[NSString stringWithFormat:@"  %@",area] forState:UIControlStateNormal];
    
    areaString = value;
    DLog(@"select--->%@",area);
    
}

#pragma  mark EASelectAgeDelegate

- (void)orderBySelectAge:(NSString *)age andValue:(NSString *)value
{
    selectAge.selected = NO;
    
    [selectAge setTitle:[NSString stringWithFormat:@"  %@",age] forState:UIControlStateNormal];
    
    ageString = value;
    DLog(@"select Age -->%@",age);
    
}

#pragma mark TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([textField.text isEqualToString:@""])
    {
        return NO;
    }
    EAActivityListViewController *activityList = [[EAActivityListViewController alloc]init];
    
    activityList.keyString =  searchTextField.text;
    activityList.areaString = areaString;
    activityList.ageString  = ageString;
    activityList.areaName = selectArea.titleLabel.text;
    activityList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityList animated:YES];
    return YES;
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
