//
//  EATabBarController.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EATabBarController.h"

#import "EANavigationController.h"

#import "EAChoiceViewController.h"
#import "EALocalViewController.h"
#import "EASearchViewController.h"
#import "EAMoreViewController.h"

#define  TAG  999
@interface EATabBarController ()<UITabBarControllerDelegate>
{
//    UIButton *selectButton;
}
@end

@implementation EATabBarController


+(EAChoiceViewController*)shareChoiceViewController
{
    static EAChoiceViewController *choice;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (choice == nil)
        {
            choice = [[EAChoiceViewController alloc] init];
        }
    });
    
    return choice;
}
+(EALocalViewController*)shareLocalViewController
{
    static EALocalViewController *Local;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (Local == nil)
        {
            Local = [[EALocalViewController alloc] init];
        }
    });
    
    return Local;
}
+(EASearchViewController*)shareSearchViewController
{
    static EASearchViewController *search;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (search == nil)
        {
            search = [[EASearchViewController alloc] init];
        }
    });
    
    return search;
}
+(EAMoreViewController*)shareMoreViewController
{
    static EAMoreViewController *more;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (more == nil)
        {
            more = [[EAMoreViewController alloc] init];
        }
    });
    
    return more;
}

- (void)viewWillAppear:(BOOL)animated
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self crecteTabBarController];
    // Do any additional setup after loading the view.
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, TABBARHEIGHT)];
    
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    CGFloat ColWidth = (SCREENWIDTH - 4 * 49)/8;
    for (NSInteger i = 1; i <= 4; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setFrame:CGRectMake(ColWidth * (2 * ( i - 1) + 1) + 49 *(i - 1), 0, 49, 49)];
        button.tag = i + TAG;
        if (i == 1)
        {
            button.selected = YES;
//            selectButton = button;
        }
        
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bottom0%ld",(long)i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bottom0%ld_h",(long)i]] forState:UIControlStateSelected];
//        [button addTarget:self action:@selector(selectViewController:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
    }

    [self.tabBar addSubview:_bottomView];
    
    
}

//- (void)selectViewController:(UIButton *)sender
//{
//    selectButton.selected = NO;
//    
//    sender.selected = YES;
//    
//    selectButton = sender;
//    NSInteger index = sender.tag - TAG - 1;
//    self.selectedIndex = index;
//}
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    for (UIButton *btn in _bottomView.subviews)
    {
        btn.selected = NO;
        if (btn.tag - TAG - 1 == selectedIndex)
        {
            btn.selected = YES;
        }
    }
}
- (void)crecteTabBarController
{
    
    EANavigationController *navChoice = [[EANavigationController alloc]initWithRootViewController:[EATabBarController shareChoiceViewController]];
    
    
    EANavigationController *navLocal = [[EANavigationController alloc]initWithRootViewController:[EATabBarController shareLocalViewController]];
    
    EANavigationController *navSearch = [[EANavigationController alloc]initWithRootViewController:[EATabBarController shareSearchViewController]];
    
    EANavigationController *navMore = [[EANavigationController alloc]initWithRootViewController:[EATabBarController shareMoreViewController]];
    
    [self addChildViewController:navChoice];
    [self addChildViewController:navLocal];
    [self addChildViewController:navSearch];
    [self addChildViewController:navMore];

    
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
