//
//  AppDelegate.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "AppDelegate.h"

#import "EATabBarController.h"
#import <CoreLocation/CoreLocation.h>
#import "DataLibrary.h"


#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "WXApi.h"

#import "WeiboSDK.h"
#import "WeiboApi.h"
#import "WeiboApiObject.h"

@interface AppDelegate ()<UITabBarControllerDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    double lat;
    double lng;
    DataLibrary *dataLib;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadLocation];
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    [self getConfigFile];
    
    
    EATabBarController *tabBar = [[EATabBarController alloc]init];
    tabBar.delegate = self;
    self.window.rootViewController = tabBar;

    /********************Share SDK ****************************/
    [ShareSDK registerApp:@"663811a0bb0b"];//字符串api20为您的ShareSDK的AppKey
    [self initializePlat];
    /********************Share SDK ****************************/
    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{

    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"1916132876"
                               appSecret:@"d78d123ecf1f5b57a1cfff0b3f55257c"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"1104463472"
                           appSecret:@"ngddaUSyNsIHMUuy"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    //    [ShareSDK connectWeChatWithAppId:@"wx7c2df1fcb181b6b5"
    //                           wechatCls:[WXApi class]];
    //微信客户端
    [ShareSDK connectWeChatSessionWithAppId: @"wx5a01d780a022784b"
                                  appSecret: @"1cd99d562635e6e40cb80fd135187987"
                                  wechatCls: [WXApi class]];
    //微信朋友圈
    [ShareSDK connectWeChatTimelineWithAppId: @"wx5a01d780a022784b"
                                   appSecret: @"1cd99d562635e6e40cb80fd135187987"
                                   wechatCls: [WXApi class]];

    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"1104463472"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectCopy];//拷贝
 
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark UITabBarControllerDelegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    EANavigationController *nowNav = (EANavigationController *)viewController;
//    if ([nowNav isKindOfClass:[EANavigationController class]])
//    {
//        int classId=100;
//        if ([nowNav.viewControllers[0] isKindOfClass:[EAChoiceViewController class]])
//        {
//            classId = 0;
//            
//        }else if ([nowNav.viewControllers[0] isKindOfClass:[EALocalViewController class]]){
//            classId = 1;
//        }else if ([nowNav.viewControllers[0] isKindOfClass:[EASearchViewController class]]){
//            classId = 2;
//        }else if ([nowNav.viewControllers[0] isKindOfClass:[EAMoreViewController class]]){
//            classId = 3;
//        }
//        NSInteger nowSelect = tabBarController.selectedIndex;
//        if (classId == nowSelect)
//        {
//            return NO;
//        }
//        
//    }
    
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger  selectIndex = tabBarController.selectedIndex;
    
    NSLog(@"select = %ld",(long)selectIndex);
//    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bottom_btn0%ld",selectIndex+1]]];
    [tabBarController setSelectedIndex:selectIndex];
}

-(void)loadLocation
{
    locationManager = [[CLLocationManager alloc]init];
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
    {
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 1000.0f;
        [locationManager startUpdatingLocation];
    }
    
    else
    {
        
        
        
    }
    
}
#pragma mark CLLocationDelegate
- (void) locationManager: (CLLocationManager *) manager
     didUpdateToLocation: (CLLocation *) newLocation
            fromLocation: (CLLocation *) oldLocation{
    
    [manager stopUpdatingLocation];
    lat = newLocation.coordinate.latitude;
    lng = newLocation.coordinate.longitude;
    DLog(@"定位成功");
    CLGeocoder *clgeo=[[CLGeocoder alloc]init];
    [clgeo reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error){
        if ([placemarks count]>0)
        {
//            [self getlocInfo];
            [self Initialization];
        }
        else
        {
            EATabBarController *tabBar = [[EATabBarController alloc]init];
            tabBar.delegate = self;
            [[[UIApplication sharedApplication]keyWindow] setRootViewController:tabBar];
        }
        
    }];
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    if (locations.count > 0)
    {
        lat = ((CLLocation *)[locations objectAtIndex:0]).coordinate.latitude;
        lng = ((CLLocation *)[locations objectAtIndex:0]).coordinate.longitude;
        
    }
    
    CLGeocoder *clgeo=[[CLGeocoder alloc]init];
    [clgeo reverseGeocodeLocation:[locations objectAtIndex:0] completionHandler:^(NSArray *placemarks,NSError *error){
        if ([placemarks count]>0)
        {
//            [self getlocInfo];
            [self Initialization];
        }
        else
        {
            EATabBarController *tabBar = [[EATabBarController alloc]init];
            tabBar.delegate = self;
            [[[UIApplication sharedApplication]keyWindow] setRootViewController:tabBar];
        }
        
    }];
    
    
}
- (void) locationManager: (CLLocationManager *) manager
        didFailWithError: (NSError *) error
{
    [manager stopUpdatingLocation];
    
    EATabBarController *tabBar = [[EATabBarController alloc]init];
    tabBar.delegate = self;
    
    [[[UIApplication sharedApplication]keyWindow] setRootViewController:tabBar];
    DLog(@"定位失败");
    
}

-(void)getConfigFile{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:DEVICEID forKey:MSN];
    [ZYHttpRequest post:dic keyString:GET_CONFIG withBlock:^(id obj, NSError *error) {
        

        NSMutableDictionary *recivedDictionary = obj;
        if ([recivedDictionary[@"data"][@"config"][@"contents"] isKindOfClass:[NSDictionary class]])
        {
            dataLib = [DataLibrary shareDataLibrary];
            [dataLib creatProductTable:AGE_TB];
            [dataLib creatProductTable:SEARCH_MENU_TB];
            [dataLib creatProductTable:FIRST_LEVEL_AREA_TB];
            [dataLib creatProductTable:SECOND_LEVEL_AREA_TB];
            NSArray *ageArray = [NSArray arrayWithArray:recivedDictionary[@"data"][@"config"][@"contents"][@"ages"]];
            for (NSDictionary *dic in ageArray)
            {
                [dataLib insertData:dic intoTable:AGE_TB];
            }
            NSArray *searchArray = [NSArray arrayWithArray:recivedDictionary[@"data"][@"config"][@"contents"][@"searchmenu"]];
            for (NSDictionary *dic in searchArray)
            {
                [dataLib insertData:dic intoTable:SEARCH_MENU_TB];
            }
            NSArray *cityArray = [NSArray arrayWithArray:recivedDictionary[@"data"][@"config"][@"contents"][@"city"]];
            for (NSDictionary *dic in cityArray)
            {
                NSArray *level1Array = [dic objectForKey:@"level1"];
                for (NSDictionary *level1  in level1Array)
                {
                    [dataLib insertData:level1 intoTable:FIRST_LEVEL_AREA_TB];
                    
                    NSArray *level2Array = [level1 objectForKey:@"level2"];
                    for (NSDictionary *level2 in level2Array)
                    {
                        NSMutableDictionary *level2Dic = [NSMutableDictionary dictionaryWithDictionary:level2];
                        [level2Dic setObject:[level1 objectForKey:@"value"] forKey:@"super_level"];
                        [dataLib insertData:level2Dic intoTable:SECOND_LEVEL_AREA_TB];
                    }
                }
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:recivedDictionary[@"data"][@"config"][@"contents"][@"cominfo"] forKey:INFO];
            
//            DLog(@"cominfo-->%@",[[NSUserDefaults standardUserDefaults]objectForKey:INFO]);
            
        }
        
    }];
    
}
- (void)Initialization
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:DEVICEID forKey:MSN];
    [dic setValue:[NSNumber numberWithDouble:lat] forKey:@"lat"];
    [dic setValue:[NSNumber numberWithDouble:lng] forKey:@"lon"];
    
    DLog(@"%@",dic);
    [ZYHttpRequest post:dic keyString:INITIALIZATION withBlock:^(id obj, NSError *error) {
        
        
        NSMutableDictionary *recivedDictionary = obj;
        if ([recivedDictionary[DATA][@"config"] isKindOfClass:[NSDictionary class]])
        {
            if ([recivedDictionary [DATA][@"config"]objectForKey:@"version"])
            {
                [self getConfigFile];
                
                EATabBarController *tabBar = [[EATabBarController alloc]init];
                tabBar.delegate = self;
                
                [[[UIApplication sharedApplication]keyWindow] setRootViewController:tabBar];
//                self.window.rootViewController = tabBar;

            }
        }
        
    }];

}
@end
