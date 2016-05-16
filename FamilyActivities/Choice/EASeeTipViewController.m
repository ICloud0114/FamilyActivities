//
//  EASeeTipViewController.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/4/14.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EASeeTipViewController.h"

@interface EASeeTipViewController ()<UIWebViewDelegate>
{
    ATMHud *hud;
}
@end

@implementation EASeeTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNavigationItem];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - INCREMENT - NAVHEIGHT)];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.view addSubview:webView];
    
    hud = [[ATMHud alloc]initWithDelegate:nil];
    [self.view addSubview:hud.view];
}
- (void)createNavigationItem
{
    
    [self.navigationItem setItemWithTitle:@"查看攻略" titleColor:[UIColor blackColor] fontSize:18.0f itemType:center];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
