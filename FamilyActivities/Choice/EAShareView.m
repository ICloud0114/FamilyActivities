//
//  EAShareView.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/31.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EAShareView.h"
#import <ShareSDK/ShareSDK.h>


@interface EAShareView ()<ATMHudDelegate>

@end

@implementation EAShareView
{
    ATMHud *hud;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    hud = [[ATMHud alloc]init];
    [self addSubview:hud.view];
}


- (void)awakeFromNib
{
    
}
- (IBAction)copyAction:(id)sender
{
    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeCopy, nil];
    id<ISSContent> publishContent = [ShareSDK content:self.shareURL
                                       defaultContent:self.shareURL
                                                image:nil
                                                title:nil //QQ空间必须要
                                                  url:self.shareURL           //QQ空间必须要
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    id<ISSContainer> container = [ShareSDK container];
    [ShareSDK showShareViewWithType:ShareTypeCopy
                          container:container
                            content:publishContent
                      statusBarTips:NO
                        authOptions:nil
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:shareList
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [hud setCaption:@"复制成功"];
                                     [hud setActivity:NO];
                                     [hud setDelegate:self];
                                     [hud show];
                                     [hud hideAfter:1.0];
                                                                          
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     
                                     [hud setCaption:@"复制失败"];
                                     [hud setActivity:NO];
                                     [hud show];
                                     [hud setDelegate:nil];
                                     [hud hideAfter:1.0];
                                     
                                 }
                             }];
    
}
- (IBAction)cancelAction:(id)sender
{
    
    [self removeFromSuperview];
   
}
- (IBAction)shareAction:(id)sender
{
    UIButton *btn =sender;
    DLog(@"%ld",(long)btn.tag);
    
    //创建分享内容
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeWeixiSession,
                          ShareTypeSinaWeibo,
                          ShareTypeWeixiTimeline,
                          ShareTypeQQSpace,
                          ShareTypeTencentWeibo,
//                          ShareTypeQQ,
//                          ShareTypeSMS,
                          nil];
    
    
    id<ISSContent> publishContent = [ShareSDK content:self.shareString
                                       defaultContent:self.shareString
                                                image:[ShareSDK imageWithUrl:self.shareImage]
                                                title:self.shareTitle //QQ空间必须要
                                                  url:self.shareURL           //QQ空间必须要
                                          description:self.shareString
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    int type = 0;
    switch (btn.tag)
    {
        case 10000:
            
            type = ShareTypeWeixiSession; //微信
            break;
        case 10001:
            type = ShareTypeSinaWeibo; //新浪微博
            
            break;
        case 10002:
            type = ShareTypeWeixiTimeline; //朋友圈
            break;
        case 10003:
            type = ShareTypeQQSpace;    //QQ空间

            break;
        case 10004:
            type = ShareTypeTencentWeibo;//腾讯微博
            break;
            
//        case 10005:
//            
//            type = ShareTypeQQ;       //QQ
//            break;
//        case 10006:
//            type = ShareTypeSMS;
//            break;
        default:
            break;
            
    }
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:type
                          container:container
                            content:publishContent
                      statusBarTips:NO
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:shareList
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [hud setCaption:@"分享成功"];
                                     [hud setActivity:NO];
                                     [hud setDelegate:self];
                                     [hud show];
                                     [hud hideAfter:1.0];
                                     
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     
                                     [hud setCaption:[error errorDescription]];
                                     [hud setActivity:NO];
                                     [hud show];
                                     [hud setDelegate:nil];
                                     [hud hideAfter:1.0];
                                     
                                 }
                             }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
- (void)hudDidDisappear:(ATMHud *)_hud
{
    [self removeFromSuperview];
}

@end
