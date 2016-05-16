//
//  photoViewScroll.h
//  photoTe
//
//  Created by IOS001 on 14-4-29.
//  Copyright (c) 2014年 IOS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "subScrollView.h"
@interface photoViewScroll : UIScrollView<UIScrollViewDelegate>
{
    NSMutableArray *urlStringArr;
    CGFloat *hight;
    CGFloat *width;
    UIImage *Pimage;
    int allPageNumber;
    int curPageNumber;
}
@property(nonatomic,assign)BOOL mode;
-(void)setImageUrlStringArr:(NSMutableArray *)arr withMode:(BOOL)mode andBeginPage:(int)page andplaceholderImage:(UIImage *)placeholderImage; //imageURLstring放入arr  mode的NO为全图显示，Yes为拉伸显示 page为开始页面 可加入加载图片placeholderImage
-(void)curView;//改变mode 调用此函数刷新
/*
 如本类加入UINavigationController中，请关闭系统在IOS7.0以上的自适应坐标，在父控制器的viewdidload方法中加入下面一段
 if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
 {
 self.automaticallyAdjustsScrollViewInsets=NO;
 }
 */
@end
