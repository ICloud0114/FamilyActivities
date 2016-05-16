//
//  EANavigationController.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EANavigationController.h"

#import "EADetailViewController.h"
#import "EASpecialViewController.h"
#import "EAFavoritesViewController.h"
#import "EAActivityListViewController.h"
@interface EANavigationController ()

@end

@implementation EANavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setBackgroundColor:[UIColor redColor]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:YES];
    
    if ( [self.viewControllers count] > 1)
    {
        if ([viewController isKindOfClass:[EADetailViewController class] ])
        {
            
        }
        else
        {
            UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];//55 34
            backBtn.frame = CGRectMake(0, 0, 44, 44);
            [backBtn addTarget:self action:@selector(popself:) forControlEvents:UIControlEventTouchUpInside];
            //        [backBtn setTitle:@"  返回" forState:UIControlStateNormal];
            backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
            [viewController.navigationController.navigationBar addSubview:backBtn];
            //
            //        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
            [viewController.navigationItem setHidesBackButton:YES];
        }
    }
    
    
}

-(void)popself:(UIButton *)sender
{
    if ( [self.viewControllers count] <= 2 ||[[self.viewControllers objectAtIndex:[self.viewControllers count]- 2 ] isKindOfClass:[EADetailViewController class] ]||[[self.viewControllers objectAtIndex:[self.viewControllers count]- 2 ] isKindOfClass:[EAFavoritesViewController class] ]||[[self.viewControllers objectAtIndex:[self.viewControllers count]- 2 ] isKindOfClass:[EAActivityListViewController class] ])
    {
        [sender removeFromSuperview];
    }
    else
    {
        
    }
    
    [self popViewControllerAnimated:YES];
    
    
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
