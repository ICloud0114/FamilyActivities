//
//  EADetailViewController.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EADetailViewController.h"
#import "BMAdScrollView.h"
#import "EATipListCell.h"
#import "EACommentListCell.h"
#import "EATitleCell.h"
#import "EADetailCell.h"
#import "EACommentView.h"
#import "EAMapViewController.h"
#import "DataLibrary.h"
#import "FavoritiesModel.h"
#import "EAFavoritesViewController.h"
#import "EACloseViewController.h"
#import "EASeeTipViewController.h"
#import "EAShareView.h"
#import <ShareSDK/ShareSDK.h>

#import "photoViewScroll.h"



@interface EADetailViewController ()<UITableViewDelegate,UITableViewDataSource,ValueClickDelegate,EASubmitCommentSuccess>
{
    
    UIScrollView *mainScrollView;
    
    BMAdScrollView *AdScrollView;
    
    UITableView *mainTableView;
    UITableView *tipTableView;
    UITableView *commentTableView;
    
    NSMutableDictionary *dataDictionary;
    
    NSMutableArray *tipDataArray;
    NSMutableArray *commentDataArray;
    
    UIButton *selectButton;
    
    NSMutableArray *moreArray;
    
    UILabel *titleLabel;
    UILabel *locationLabel;
    
    UIButton *commentBtn;//评论按钮
    
    DataLibrary *dataLib;
    UIImageView *agreeImage;
    ATMHud *hud;
    
    UIView *photoView;
    
    CGFloat firstRowHeight;
    CGFloat secondRowHeight;
    NSInteger tipIndex;
    NSInteger commentIndex;
}
@property (nonatomic, copy) void(^refreshBack)(void);
@end


@implementation EADetailViewController

- (void)dealloc
{
    [AdScrollView invalidate];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewDidAppear:(BOOL)animated
{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tipIndex = 0;
    commentIndex = 0;
     self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    dataDictionary = [NSMutableDictionary dictionary];
    
    tipDataArray = [NSMutableArray array];
    commentDataArray = [NSMutableArray array];
    
    dataLib = [DataLibrary shareDataLibrary];
    [dataLib creatProductTable:FAVORITIES_TB];
    
//    moreArray = @[@"去购买",@"去看攻略",@"访问官网",@"相关活动"];
    moreArray = [NSMutableArray array];
    
    firstRowHeight = 0.0f;
    secondRowHeight = 0.0f;

    
    [self getActivityDetailInfo];
    
    [self createContentView];
    
    [self createNavigationItem];
    
    hud = [[ATMHud alloc]initWithDelegate:nil];
    [self.view addSubview:hud.view];
}

- (void)createContentView
{
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
    
    [self.view addSubview:mainScrollView];
    
    
    
    //广告
    AdScrollView = [[BMAdScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    [AdScrollView setBackgroundColor:[UIColor whiteColor]];
    AdScrollView.vDelegate = self;
    [mainScrollView addSubview:AdScrollView];
    
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(AdScrollView), SCREENWIDTH, 70)];
    titleView.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:titleView];
    
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, SCREENWIDTH - 16, 25)];
//    titleLabel.text = [dataDictionary objectForKey:@"title"];
    titleLabel.text = @"深圳市博物馆";
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textColor = [UIColor blackColor];
    [titleView addSubview:titleLabel];
    
    locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(8,Y(titleLabel) +HEIGHT(titleLabel) + 8, SCREENWIDTH - 16, 20)];
    locationLabel.font = [UIFont systemFontOfSize:13];
    locationLabel.text = @"福田区市民中心    距离 2.5km";
//    locationLabel.text = [NSString stringWithFormat:@"%@     %@",[dataDictionary objectForKey:@"location"],[dataDictionary objectForKey:@"distance"]];
    [titleView addSubview:locationLabel];

    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, Y(titleView) + HEIGHT(titleView), SCREENWIDTH, 44)];
    [mainScrollView addSubview:selectView];

    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailButton setFrame:CGRectMake(0, 0, SCREENWIDTH / 3, 44)];
    [detailButton setTitle:@"简介" forState:UIControlStateNormal];
    [detailButton setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [detailButton setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [detailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [detailButton setTitleColor:[UIColor colorwithHexString:@"#FF8B84"]  forState:UIControlStateSelected];
    detailButton.tag = 1001;
    detailButton.selected = YES;
//    [detailButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [detailButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:detailButton];
    
    selectButton = detailButton;
    
    UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tipButton setFrame:CGRectMake(SCREENWIDTH / 3, 0, SCREENWIDTH / 3, 44)];
    [tipButton setTitle:@"攻略" forState:UIControlStateNormal];
    [tipButton setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [tipButton setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [tipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tipButton setTitleColor:[UIColor colorwithHexString:@"#FF8B84"]  forState:UIControlStateSelected];
    tipButton.tag = 1002;
//    [tipButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [tipButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:tipButton];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setFrame:CGRectMake(SCREENWIDTH / 3 * 2, 0, SCREENWIDTH / 3, 44)];
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [commentButton setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [commentButton setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor colorwithHexString:@"#FF8B84"]  forState:UIControlStateSelected];
    commentButton.tag = 1003;
//    [commentButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:commentButton];
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,Y(selectView) + HEIGHT(selectView), SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    //    [mainTableView setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
    //    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [mainTableView setBackgroundColor:[UIColor whiteColor]];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainScrollView addSubview:mainTableView];
    
  //攻略列表
    tipTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,Y(selectView) + HEIGHT(selectView), SCREENWIDTH, SCREENHEIGHT - HEIGHT(AdScrollView) - HEIGHT(titleView) - HEIGHT(selectView)) style:UITableViewStylePlain];
    //    [tipTableView setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
    //    tipTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tipTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [tipTableView setBackgroundColor:[UIColor whiteColor]];
    tipTableView.delegate = self;
    tipTableView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    
    
    [tipTableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf needGetTipListData:YES];
    }];
    
    [tipTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf needGetTipListData:NO];
    }];
    
//    [tipTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(needGetTipListData)];
    
  //评论列表
    
    commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,Y(selectView) + HEIGHT(selectView), SCREENWIDTH, SCREENHEIGHT - HEIGHT(AdScrollView) - HEIGHT(titleView) - HEIGHT(selectView) - 37) style:UITableViewStylePlain];
    //    [commentTableView setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
    //    commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [commentTableView setBackgroundColor:[UIColor whiteColor]];
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    
    
    [commentTableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf needGetCommentListData:YES];
    }];
    
    [commentTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf needGetCommentListData:NO];
    }];
    
    commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setFrame:CGRectMake(0, Y(commentTableView) + HEIGHT(commentTableView), SCREENWIDTH, 37)];
    
    [commentBtn setBackgroundColor:[UIColor whiteColor]];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"pinglun_bg"] forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(startCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    hud = [[ATMHud alloc]initWithDelegate:nil];
    
//    [self.view addSubview:hud.view];
    //    __weak EAChoiceViewController *controller = self;
    
    //    [choiceTableView addPullToRefreshWithActionHandler:^{
    //        [controller getMessageList:YES];
    //    }];
    //    [choiceTableView addInfiniteScrollingWithActionHandler:^{
    //        [controller getMessageList:NO];
    //    }];
//    mainTableView.estimatedRowHeight = 44.0f;
//    mainTableView.rowHeight = UITableViewAutomaticDimension;
}
- (void)selectAction:(UIButton *)sender
{
    switch (selectButton.tag) {
        case 1001:
        {
            [mainTableView removeFromSuperview];
           
            
        }
            break;
        case 1002:
        {
            [tipTableView removeFromSuperview];
            
        }
            break;
        case 1003:
        {
            [commentTableView removeFromSuperview];
            [commentBtn removeFromSuperview];
            
            
        }
            break;
        default:
            break;
    }

    selectButton.selected = NO;
    selectButton = sender;
    selectButton.selected = YES;
    
    switch (sender.tag) {
        case 1001:
        {
            [mainScrollView addSubview:mainTableView];
             mainScrollView.contentSize = CGSizeMake(SCREENWIDTH, firstRowHeight + secondRowHeight +[moreArray count] * 44 + 200 + 70 + 44);
        }
            break;
        case 1002:
        {
            [mainScrollView addSubview:tipTableView];

            mainScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
            if (![tipDataArray count])
            {
//                [self needGetTipListData];
                [tipTableView.header beginRefreshing];
            }
            
        }
            break;
        case 1003:
        {
            [mainScrollView addSubview:commentTableView];
            [mainScrollView addSubview:commentBtn];
            mainScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
            
            if (![commentDataArray count])
            {
                [commentTableView.header beginRefreshing];
            }
        }
            break;
        default:
            break;
    }
}

- (void)createNavigationItem
{
    self.navigationController.navigationBarHidden = YES;
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, INCREMENT + NAVHEIGHT)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 10, 44, 44)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(SCREENWIDTH - 44 - 44 - 44 - 10 - 10 - 10 , 10, 46, 44)];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:shareButton];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(SCREENWIDTH - 44 - 44 - 10 - 10, 10, 46, 44)];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:saveButton];
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeButton setFrame:CGRectMake(SCREENWIDTH -44 - 10, 10, 46, 44)];
    [agreeButton setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    [agreeButton addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:agreeButton];
    
    agreeImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 100 - 12, 44, 100, 40)];
    [agreeImage setImage:[UIImage imageNamed:@"dianzan"]];
    agreeImage.userInteractionEnabled = YES;
    [agreeImage setHidden:YES];
    [self.view addSubview:agreeImage];
    
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [upButton setFrame:CGRectMake(10, 7, 40, 35)];
    [upButton setImage:[UIImage imageNamed:@"shangzhi"] forState:UIControlStateNormal];
    [upButton addTarget:self action:@selector(upAction:) forControlEvents:UIControlEventTouchUpInside];
    [agreeImage addSubview:upButton];
    
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [downButton setFrame:CGRectMake(50, 7, 40, 35)];
    [downButton setImage:[UIImage imageNamed:@"xiazhi"] forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(downAction:) forControlEvents:UIControlEventTouchUpInside];
    [agreeImage addSubview:downButton];
    
//    [self.navigationItem setItemWithTitle:@"活动介绍" titleColor:[UIColor blackColor] fontSize:18.0f itemType:center];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareAction:(UIButton *)sender
{
    
   EAShareView *shareView = [[NSBundle mainBundle]loadNibNamed:@"EAShareView" owner:self options:nil][0];
    [shareView setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
//    shareView.delegate = self;
    shareView.shareImage = [dataDictionary objectForKey:@"image"];
    
    NSString *contentString = [dataDictionary objectForKey:@"aWhat"] ;
    if ([contentString length] > 140)
    {
        contentString = [contentString substringToIndex:140];
    }
    shareView.shareString = contentString;
    
    shareView.shareURL = [dataDictionary objectForKey:@"shareUrl"];
    shareView.shareTitle = [dataDictionary objectForKey:@"title"];
    [self.view.window addSubview:shareView];

}
- (void)saveAction
{
    
    
    if (![dataLib searchActivityIdByTable:FAVORITIES_TB andActivityId:dataDictionary [@"actid"]])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"MM-dd HH:mm";
        NSString *addTime =  [formatter stringFromDate:[NSDate date]];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              dataDictionary [@"title"],@"title",
                              dataDictionary [@"logo"],@"image",
                              dataDictionary [@"aWhere"],@"site",
                              dataDictionary [@"actid"],@"actid",
                              @"0",@"type",
                              addTime,@"date",
                              dataDictionary [@"count"],@"agree",
                              dataDictionary [@"distance"],@"distance",
                              
                              nil];
        
        
        if ([dataLib insertData:dict intoTable:FAVORITIES_TB])
        {
            DLog(@"收藏成功");
            
            [hud setCaption:@"收藏成功"];
            [hud show];
            [hud hideAfter:1.0];
            //        EAFavoritesViewController *favorites = [[EAFavoritesViewController alloc]init];
            //        [self.navigationController pushViewController:favorites animated:YES];
        }
        else
        {
            DLog(@"收藏失败");
            [hud setCaption:@"收藏失败"];
            [hud show];
            [hud hideAfter:1.0];
        }
    }
    else
    {
        [hud setCaption:@"已收藏"];
        [hud show];
        [hud hideAfter:1.0];
    }
    
    
   
}
- (void)upAction:(UIButton *)sender
{
    agreeImage.hidden = YES;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:DEVICEID forKey:MSN];
    [dic setValue:self.ActivityID forKey:ID];
    
    [ZYHttpRequest post:dic keyString:SET_UP withBlock:^(id obj, NSError *error) {
        NSMutableDictionary *recivedDictionary = obj;
        
        [self.view bringSubviewToFront:hud.view];
        
        if ([[recivedDictionary objectForKey:SUCCESS] isEqualToString:@"1"])
        {
            [hud setCaption:@" + 1 "];
            [hud setActivity:NO];
            [hud show];
            [hud hideAfter:1.0];
            
//            if (self.refreshBack)
//            {
//                self.refreshBack();
//            }
        }
        else
        {
            [hud setCaption:[recivedDictionary objectForKey:@"msg"]];
            [hud setActivity:NO];
            [hud show];
            [hud hideAfter:1.0];
        }
        
    }];

}

- (void)downAction:(UIButton *)sender
{
    agreeImage.hidden = YES;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:DEVICEID forKey:MSN];
    [dic setValue:self.ActivityID forKey:ID];
    
    [ZYHttpRequest post:dic keyString:SET_DOWN withBlock:^(id obj, NSError *error) {
        NSMutableDictionary *recivedDictionary = obj;
        if ([[recivedDictionary objectForKey:SUCCESS] isEqualToString:@"1"])
        {
            [hud setCaption:@" + 1 "];
            [hud setActivity:NO];
            [hud show];
            [hud hideAfter:1.0];
            
//            if (self.refreshBack)
//            {
//                self.refreshBack();
//            }
        }
        else
        {
            [self.view bringSubviewToFront:hud.view];
            [hud setCaption:recivedDictionary[@"msg"]];
            [hud setActivity:NO];
            [hud show];
            [hud hideAfter:1.0];
        }
        
    }];

}
- (void)agreeAction
{
    agreeImage.hidden = !agreeImage.hidden;
//    [agreeImage setHidden:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == mainTableView)
    {
        if (indexPath.row == 0)
        {
            EATitleCell *cell = (EATitleCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
            firstRowHeight = cell.cellHeight;
           return  cell.cellHeight;
            
//            return 200;
        }
        else if(indexPath.row == 1)
        {
            EADetailCell *cell = (EADetailCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
            secondRowHeight = cell.cellHeight;
            return cell.cellHeight;
//            return 110;
        }
        else
        {
            return 44;
            
        }
    }
    else if(tableView == tipTableView)
    {
//        return 44;
        EATipListCell *cell = (EATipListCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell.cellHeight;
    }
    else if(tableView == commentTableView)
    {
//        return 44;
        EACommentListCell *cell = (EACommentListCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell.cellHeight;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    DLog(@"%ld",indexPath.row);
    if (tableView == tipTableView)
    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tipDataArray[indexPath.row][@"aUrl"]]];
        EASeeTipViewController *seeTips = [[EASeeTipViewController alloc]init];
        seeTips.url = tipDataArray[indexPath.row][@"aUrl"];
        [self.navigationController pushViewController:seeTips animated:YES];
    }
    else if(tableView == mainTableView)
    {
        
        if (indexPath.row >= 2)
        {
            //        @[@"去购买",@"去看攻略",@"访问官网",@"相关活动"];
            if ([[moreArray objectAtIndex:(indexPath.row - 2)] isEqualToString:@"去购买"])
            {
                EASeeTipViewController *seeTips = [[EASeeTipViewController alloc]init];
                seeTips.url = dataDictionary [@"buyUrl"];
                [self.navigationController pushViewController:seeTips animated:YES];
            }
            else if ([[moreArray objectAtIndex:(indexPath.row - 2)] isEqualToString:@"去看攻略"])
            {
                EASeeTipViewController *seeTips = [[EASeeTipViewController alloc]init];
                seeTips.url = dataDictionary [@"howUrl"];
                [self.navigationController pushViewController:seeTips animated:YES];
            }
            else if ([[moreArray objectAtIndex:(indexPath.row - 2)] isEqualToString:@"访问官网"])
            {
                EASeeTipViewController *seeTips = [[EASeeTipViewController alloc]init];
                seeTips.url = dataDictionary [@"outUrl"];
                [self.navigationController pushViewController:seeTips animated:YES];
            }
            else if ([[moreArray objectAtIndex:(indexPath.row - 2)] isEqualToString:@"相关活动"])
            {
                
                EACloseViewController *close = [[EACloseViewController alloc]init];
                close.actID = self.ActivityID;
                [self.navigationController pushViewController:close animated:YES];
            }
        }

    }
    
}
#pragma mark tableviewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [messageArray count];
    
    if (tableView == mainTableView)
    {
        return [moreArray count] + 2;
    }
    else if(tableView == tipTableView)
    {
        return [tipDataArray count];
    }
    else if(tableView == commentTableView)
    {
        return [commentDataArray count];
    }
    else
    {
        return 0;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == mainTableView)
    {
        if (indexPath.row == 0)
        {
            static NSString *reuseID=@"title";
            EATitleCell  *titleCell =[tableView dequeueReusableCellWithIdentifier:reuseID];
            titleCell =[[[NSBundle mainBundle]loadNibNamed:@"EATitleCell" owner:self options:nil]firstObject];
            [titleCell cellFrame:dataDictionary];
            [titleCell.addressButton addTarget:self action:@selector(clickMapAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return titleCell;
        }
        else if(indexPath.row == 1)
        {
            static NSString *reuseID=@"detail";
            EADetailCell *detailCell =[tableView dequeueReusableCellWithIdentifier:reuseID];
            detailCell =[[[NSBundle mainBundle]loadNibNamed:@"EADetailCell" owner:self options:nil]lastObject];
            
            [detailCell cellFrame:dataDictionary];

            return detailCell;
        }
        else
        {
            
            static NSString *reuseID=@"more";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
            cell.textLabel.text = [moreArray objectAtIndex:indexPath.row - 2];
            return cell;
        }
    }
    else if(tableView == tipTableView)
    {
        static NSString *reuseID=@"tip";
        EATipListCell  *tipCell =[tableView dequeueReusableCellWithIdentifier:reuseID];
        tipCell =[[[NSBundle mainBundle]loadNibNamed:@"EATipListCell" owner:self options:nil]firstObject];
        
        [tipCell cellFrame:[tipDataArray objectAtIndex:indexPath.row]];
        return tipCell;
    }
    else if(tableView == commentTableView)
    {
        static NSString *reuseID=@"comment";
        EACommentListCell  *commentCell =[tableView dequeueReusableCellWithIdentifier:reuseID];
        commentCell =[[[NSBundle mainBundle]loadNibNamed:@"EACommentListCell" owner:self options:nil]firstObject];
        
        [commentCell cellFrame:[commentDataArray objectAtIndex:indexPath.row]];
//        [commentCell addTarget:self action:@selector(clickMapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return commentCell;
    }
    else
    {
        return nil;
    }
    
    
}

- (void)clickMapAction:(UIButton *)sender
{
    EAMapViewController *location = [[EAMapViewController alloc] init];
    location.lat = [[dataDictionary objectForKey:@"latitude"]doubleValue];
    location.lng = [[dataDictionary objectForKey:@"longitude"]doubleValue];
    location.title = [dataDictionary objectForKey:@"aWhere"];
    [self.navigationController pushViewController:location animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)startCommentAction:(UIButton *)sender
{
    EACommentView *commentView = [[NSBundle mainBundle]loadNibNamed:@"EACommentView" owner:self options:nil][0];
    commentView.activityId = self.ActivityID;
    [commentView setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    commentView.delegate = self;
    [self.view.window addSubview:commentView];
}
- (void)getActivityDetailInfo
{
    [hud setCaption:@"加载中.."];
    [hud setActivity:YES];
    [hud show];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:DEVICEID forKey:MSN];
    [dic setValue:self.ActivityID forKey:ID];
    
    [ZYHttpRequest post:dic keyString:ACTIVITIES_INFO withBlock:^(id obj, NSError *error) {
        
        [hud hide];
        
        NSMutableDictionary *recivedDictionary = obj;
        if ([[recivedDictionary objectForKey:SUCCESS] isEqualToString:@"1"])
        {
            [dataDictionary setDictionary:[recivedDictionary objectForKey:DATA][ACTDETAIL]];
            
            titleLabel.text = [dataDictionary objectForKey:@"title"];
            
            locationLabel.text = [NSString stringWithFormat:@"%@    距离%.1fkm",[dataDictionary objectForKey:@"location"],[[dataDictionary objectForKey:@"distance"] doubleValue]/ 1000.0];
            
            AdScrollView.dataSource = [dataDictionary objectForKey:@"pictures"];
            [AdScrollView fire];
            
//            @[@"去购买",@"去看攻略",@"访问官网",@"相关活动"];
            if (![[dataDictionary objectForKey:@"buyUrl"]isEqualToString:@""])
            {
                [moreArray addObject:@"去购买"];
            }
            if (![[dataDictionary objectForKey:@"howUrl"] isEqualToString:@""])
            {
                [moreArray addObject:@"去看攻略"];
            }
            
            if (![[dataDictionary objectForKey:@"outUrl"] isEqualToString:@""])
            {
                 [moreArray addObject:@"访问官网"];
            }
            [moreArray addObject:@"相关活动"];
            
            [mainTableView reloadData];
            
            
            
            
            mainScrollView.contentSize = CGSizeMake(SCREENWIDTH, (firstRowHeight + secondRowHeight +[moreArray count] * 44 + 200 + 70 + 44) > SCREENHEIGHT ?(firstRowHeight + secondRowHeight +[moreArray count] * 44 + 200 + 70 + 44):SCREENHEIGHT);
            [self refreshFrameByHeight:(firstRowHeight + secondRowHeight +[moreArray count] * 44 + 200 + 70 + 44) > SCREENHEIGHT ?(firstRowHeight + secondRowHeight +[moreArray count] * 44 + 200 + 70 + 44):SCREENHEIGHT];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[recivedDictionary objectForKey:MSG] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
}

- (void)refreshFrameByHeight:(CGFloat)height
{
    CGRect rect = mainTableView.frame;
    
    rect.size.height = height;
    
    mainTableView.frame = rect;
}



- (void)needGetTipListData:(BOOL)isRefresh
{
    if (isRefresh)
    {
        tipIndex = 0;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:DEVICEID forKey:MSN];
    [dic setValue:self.ActivityID forKey:ID];
    [dic setValue:[NSNumber numberWithInteger:tipIndex] forKey:PP];
    
    
    [ZYHttpRequest post:dic keyString:MORE_INFO withBlock:^(id obj, NSError *error) {
        NSMutableDictionary *recivedDictionary = obj;
        if ([[recivedDictionary objectForKey:SUCCESS] isEqualToString:@"1"])
        {
            
            if (isRefresh)
            {
                [tipDataArray setArray:[recivedDictionary objectForKey:DATA][ARTICLEDATA]];
                
                [tipTableView reloadData];
                
                [tipTableView.header endRefreshing];
                
                ++ tipIndex;
                tipTableView.footer.hidden = NO;

            }
            else
            {
                [tipDataArray addObjectsFromArray:[recivedDictionary objectForKey:DATA][ARTICLEDATA]];
                
                [tipTableView reloadData];
                
                [tipTableView.footer endRefreshing];
                
                ++ tipIndex;
            }
            
        }
        else
        {
            [hud setCaption:[recivedDictionary objectForKey:MSG]];
            [hud show];
            [hud hideAfter:1.0];
            
            if (isRefresh)
            {
                [tipTableView.header endRefreshing];
                tipTableView.footer.hidden = YES;
            }
            else
            {
                [tipTableView.footer endRefreshing];
                tipTableView.footer.hidden = YES;
            }
            

        }
        
    }];

}

- (void)needGetCommentListData:(BOOL)isRefresh
{
    if (isRefresh)
    {
        commentIndex = 0;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:DEVICEID forKey:MSN];
    [dic setValue:self.ActivityID forKey:ID];
    [dic setValue:[NSNumber numberWithInteger:commentIndex] forKey:PP];
    
    [ZYHttpRequest post:dic keyString:ACTIVITIES_COMMENT withBlock:^(id obj, NSError *error) {
        NSMutableDictionary *recivedDictionary = obj;
        if ([[recivedDictionary objectForKey:SUCCESS] isEqualToString:@"1"])
        {
            if (isRefresh)
            {
                [commentDataArray setArray:[recivedDictionary objectForKey:DATA][DISCUSSDATA]];
                
                [commentTableView reloadData];
                
                [commentTableView.header endRefreshing];
                
                ++ commentIndex;
                
                commentTableView.footer.hidden = NO;
            }
            else
            {
                [commentDataArray addObjectsFromArray:[recivedDictionary objectForKey:DATA][DISCUSSDATA]];
                
                [commentTableView reloadData];
                
                [commentTableView.footer endRefreshing];
                
                ++ commentIndex;
            }
            
        }
        else
        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[recivedDictionary objectForKey:MSG] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            [hud setCaption:[recivedDictionary objectForKey:MSG]];
            [hud show];
            [hud hideAfter:1.0];
            
            if (isRefresh)
            {
                [commentTableView.header endRefreshing];
                commentTableView.footer.hidden = YES;
            }
            else
            {
                [commentTableView.footer endRefreshing];
                commentTableView.footer.hidden = YES;
            }
            
        }
        
    }];

}

#pragma mark 评论成功
- (void)submitCommentSuccess
{
    [self needGetCommentListData:YES];
}


#pragma mark ADScrollDelegate
- (void)buttonClick:(NSInteger)vid value:(NSDictionary *)dictionary
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    NSMutableArray *arr1=[NSMutableArray arrayWithArray:[dataDictionary objectForKey:@"pictures"]];
    photoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
  photoViewScroll *photo=[[photoViewScroll alloc]initWithFrame:CGRectMake(0, 0, photoView.bounds.size.width, photoView.bounds.size.height)];
    [photo setImageUrlStringArr:arr1 withMode:NO andBeginPage:0 andplaceholderImage:[UIImage imageNamed:@"1"]];
    photoView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:photoView];
    [photoView addSubview:photo];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, INCREMENT, 44, 44)];
//    [backButton setBackgroundColor:[UIColor whiteColor]];
    [backButton setImage:[UIImage imageNamed:@"back_btn_h"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismissSelfAction) forControlEvents:UIControlEventTouchUpInside];
    [photoView addSubview:backButton];
}
- (void)dismissSelfAction
{
    [photoView removeFromSuperview];
}


- (void)refreshChoiceTableView:(void (^)(void))block
{
    if (block)
    {
        self.refreshBack = block;
    }
}
@end
