//
//  EAMapViewController.m
//  Grassland
//
//  Created by LoveLi1y on 15/1/6.
//  Copyright (c) 2015年 LXH. All rights reserved.
//

#import "EAMapViewController.h"
#import "MKMapView+ZoomLevel.h"
#import  "MapDeatilViewController.h"
#import "CustonMKAnnotation.h"
//#import "NearbyController.h"
#define ZOOM_LEVEL 1
@interface EAMapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
{
    
    MKMapView *mapView;
}
@end

@implementation EAMapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    [self createNavigationItem];
    
    mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - INCREMENT - NAVHEIGHT)];
    [mapView setDelegate:self];
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    NSMutableArray *citems = [[NSMutableArray alloc] init];

    CustonMKAnnotation *ann = [[CustonMKAnnotation alloc] init];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude =self.lat;
    coordinate.longitude =self.lng;
    ann.coordinate = coordinate;
    [ann setTitle:@"111"];
    [ann setSubtitle:self.title];
    
//    [ann setSubtitle:@"222"];
    ann.tag = 1000;
    [citems addObject:ann];
    
    [mapView addAnnotations:citems];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate,5000, 500);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    //                        以上代码创建出来一个符合MapView横纵比例的区域
    [mapView setRegion:adjustedRegion animated:YES];
    
}

- (void)createNavigationItem
{
    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setFrame:CGRectMake(0, 0, 30, 44)];
//    [backButton setImage:[UIImage imageNamed:@"button_back"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setItemWithCustomView:backButton itemType:left];
//    
//    [self.navigationItem setItemWithTitle:@"服务中心" titleColor:[UIColor whiteColor] fontSize:18.0f itemType:center];
    [self.navigationItem setItemWithTitle:@"定位信息" titleColor:[UIColor blackColor] fontSize:18.0f itemType:center];
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
