//
//  EASpecialViewController.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/4/13.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EASpecialViewController.h"
#import "EAFavoritesViewController.h"
#import "EAShareView.h"
#import "DataLibrary.h"
@interface EASpecialViewController ()<UIWebViewDelegate>
{
    UIImageView *agreeImage;
    
    DataLibrary *dataLib;
    
    ATMHud *hud;

}

@property (nonatomic,copy) void(^refreshSuperBlock)(void);
@end

@implementation EASpecialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    
    dataLib = [DataLibrary shareDataLibrary];
    [dataLib creatProductTable:FAVORITIES_TB];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, SCREENWIDTH - 10, 70)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, WIDTH(topView), 30)];
    titleLabel.text = [self.dataDict objectForKey:@"title"];
    [topView addSubview:titleLabel];
    
    UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y(titleLabel) + HEIGHT(titleLabel) + 5, WIDTH(topView) / 2, 25)];
    locationLabel.font = [UIFont systemFontOfSize:13];
    locationLabel.text = [self.dataDict objectForKey:@"location"];
    [topView addSubview:locationLabel];
    [self.view addSubview:topView];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, Y(topView) + HEIGHT(topView), SCREENWIDTH, SCREENHEIGHT - INCREMENT - NAVHEIGHT - HEIGHT(topView))];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.dataDict objectForKey:RURL]]]];
    
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:webView];
    
    hud = [[ATMHud alloc]initWithDelegate:nil];
    [self.view addSubview:hud.view];
    
    [self createNavigationItem];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRemove)];
    [hud.view addGestureRecognizer:tap];
    
}

- (void)tapRemove
{

    [hud hide];
    
}
- (void)createNavigationItem
{

    CustomBarItem *shareButton = [CustomBarItem itemWithImage:@"fenxiang" size:CGSizeMake(46, 44) type:right];

    [shareButton addTarget:self selector:@selector(shareAction:) event:UIControlEventTouchUpInside];

    CustomBarItem *saveButton = [CustomBarItem itemWithImage:@"plus" size:CGSizeMake(46, 44) type:right];
    
    [saveButton addTarget:self selector:@selector(saveAction:) event:UIControlEventTouchUpInside];
    
    CustomBarItem *agreeButton = [CustomBarItem itemWithImage:@"heart" size:CGSizeMake(46, 44) type:right];
    
    [agreeButton addTarget:self selector:@selector(agreeAction:) event:UIControlEventTouchUpInside];
    
    [self.navigationItem addCustomBarItems:@[agreeButton,saveButton,shareButton] itemType:right];
    
    agreeImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 100 - 12, 0, 100, 40)];
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


- (void)shareAction:(UIButton *)sender
{
    
    
    EAShareView *shareView = [[NSBundle mainBundle]loadNibNamed:@"EAShareView" owner:self options:nil][0];
    [shareView setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    //    shareView.delegate = self;
    shareView.shareImage = [self.dataDict objectForKey:@"image"];
    
    NSString *contentString = [self.dataDict objectForKey:@"title"] ;
    if ([contentString length] > 140)
    {
        contentString = [contentString substringToIndex:140];
    }
    shareView.shareString = contentString;
    
    shareView.shareURL = [self.dataDict objectForKey:@"rUrl"];
    shareView.shareTitle = [self.dataDict objectForKey:@"title"];
    [self.view.window addSubview:shareView];
    
}
- (void)saveAction:(id)sender
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"MM-dd HH:mm";
//    NSString *addTime =  [formatter stringFromDate:[NSDate date]];
//    
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                          self.dataDict [@"title"],@"title",
//                          self.dataDict [@"image"],@"image",
//                          self.dataDict [@"location"],@"site",
//                          self.dataDict [@"actid"],@"actid",
//                          @"1", @"type",
//                          addTime,@"date",
//                          self.dataDict [@"count"],@"agree",
//                          self.dataDict [@"distance"],@"distance",
//                          self.dataDict [RURL],RURL,
//                          nil];
//
//    
//    if ([dataLib insertData:dict intoTable:FAVORITIES_TB])
//    {
//        DLog(@"收藏成功");
////        EAFavoritesViewController *favorites = [[EAFavoritesViewController alloc]init];
////        [self.navigationController pushViewController:favorites animated:YES];
//        
//        [hud setCaption:@"收藏成功"];
//        [hud show];
//        [hud hideAfter:1.0];
//    }
//    else
//    {
//        DLog(@"收藏失败");
//        [hud setCaption:@"收藏失败"];
//        [hud show];
//        [hud hideAfter:1.0];
//    }

if (![dataLib searchActivityIdByTable:FAVORITIES_TB andActivityId:self.dataDict [@"actid"]])
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *addTime =  [formatter stringFromDate:[NSDate date]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.dataDict [@"title"],@"title",
                          self.dataDict [@"image"],@"image",
                          self.dataDict [@"location"],@"site",
                          self.dataDict [@"actid"],@"actid",
                          @"1", @"type",
                          addTime,@"date",
                          self.dataDict [@"count"],@"agree",
                          self.dataDict [@"distance"],@"distance",
                          self.dataDict [RURL],RURL,
                          nil];
    
    if ([dataLib insertData:dict intoTable:FAVORITIES_TB])
    {
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


//FIXME: 已经顶了,已经修复

/**
 @author Giv, 15-05-25 11:05:28
 
 Deviceid 使用已openudid
 
 @param sender
 */
- (void)upAction:(UIButton *)sender
{
    agreeImage.hidden = YES;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:DEVICEID forKey:MSN];
    [dic setValue:DEVICEID forKey:MSN];
    [dic setValue:self.dataDict[@"actid"] forKey:ID];
    
    [ZYHttpRequest post:dic keyString:SET_UP withBlock:^(id obj, NSError *error) {
        NSMutableDictionary *recivedDictionary = obj;
        
        [self.view bringSubviewToFront:hud.view];
        
        if ([[recivedDictionary objectForKey:SUCCESS] isEqualToString:@"1"])
        {
            [hud setCaption:@" + 1 "];
            [hud setActivity:NO];
            [hud show];
            [hud hideAfter:1.0];
            
            if (self.refreshSuperBlock)
            {
                self.refreshSuperBlock();
            }
            
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
    [dic setValue:self.dataDict[@"actid"] forKey:ID];
    
    [ZYHttpRequest post:dic keyString:SET_DOWN withBlock:^(id obj, NSError *error) {
        NSMutableDictionary *recivedDictionary = obj;
        if ([[recivedDictionary objectForKey:SUCCESS] isEqualToString:@"1"])
        {
            [self.view bringSubviewToFront:hud.view];
            [hud setCaption:@" + 1 "];
            [hud setActivity:NO];
            [hud show];
            [hud hideAfter:1.0];
//            
            if (self.refreshSuperBlock)
            {
                self.refreshSuperBlock();
            }
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
- (void)agreeAction:(id)sender
{
    agreeImage.hidden = !agreeImage.hidden;
    //    [agreeImage setHidden:NO];
}

#pragma mark webViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [hud setCaption:@"加载中.."];
    [hud setActivity:YES];
    [hud show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud hide];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refreshSuperTableView:(void (^)(void))block
{
    if (block)
    {
        self.refreshSuperBlock = block;
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
