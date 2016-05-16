//
//  oneScrollView.h
//  photo
//
//  Created by IOS001 on 14-4-28.
//  Copyright (c) 2014年 IOS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@protocol popViewDelegate <NSObject>

-(void)popView;//单击手势通知

@end
@interface subScrollView : UIScrollView<UIScrollViewDelegate>
{
    UIImageView *PhotoImageview;
    UIActivityIndicatorView *act;
}
@property(nonatomic,weak)id<popViewDelegate>mydelegate;
@property(nonatomic,assign)CGFloat maxZoom;
@property(nonatomic,strong)UIImageView * PhotoImageview;
-(void)setLoadImagewithUrl:(NSString *)urlString withMode:(BOOL)mode andplaceholderImage:(UIImage *)placeholderImage; //NO为全图显示，Yes为拉伸显示
-(void)setminzoom;
@end
