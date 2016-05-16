//
//  BMAdScrollView.m
//  UIPageController
//
//  Created by skyming on 14-5-31.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import "BMAdScrollView.h"
#import "UIButton+WebCache.h"
#import "ZZPageControl.h"
#import "UIImageView+WebCache.h"

//#define WIDTH ([UIScreen mainScreen].bounds.size.width)
//#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define PAGE_HEIGHT 37
#define rightDirection 1
#define zeroDirection 0
#define INTERVALE 2

@implementation BMButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end


@implementation BMImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            
    }
    return self;
}

//新定义初始化视图方法
-(id)initWithImageName:(NSString *)imageName title:(NSString *)titleStr x:(CGFloat)xPoint tFrame:(CGRect)titleFrame iHeight:(CGFloat)imageHeight titleHidden:(BOOL)isTitleHidden
{
    //调用原始初始化方法
    CGFloat imageH = imageHeight;
    if ( !isTitleHidden) {
        imageH = imageHeight - 30;
    }
    self = [super initWithFrame:CGRectMake(xPoint, 0, SCREENWIDTH, imageH)];
    if (self) {
        // Initialization code
        //设置图片视图
//        UrlImageButton *imageView = [[UrlImageButton alloc]initWithFrame:CGRectMake(0, 0, 320, imageH)];
        BMButton *imageView = [[BMButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, imageH)];
        //给定网络图片路径
//     [imageView setImageFromUrl:YES withUrl:imageName];
//        [imageView setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:imageView.bounds];
        [backgroundImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
//        [backgroundImageView setImageWithURL:[NSURL URLWithString:imageName]];
        [imageView addSubview:backgroundImageView];
        
    
                 //设置点击方法
        [imageView addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageView];
        
        if (isTitleHidden) {
            return self;
        }
        //设置背景条
        if (titleFrame.size.height == 0.0) {
            titleFrame = CGRectMake(0, self.frame.size.height - 30, SCREENWIDTH, 30);
        }
        
        UIView *titleBack = [[UIView alloc]initWithFrame:titleFrame];
        titleBack.backgroundColor =[UIColor whiteColor];
        titleBack.alpha = 1.0;
        [self addSubview:titleBack];
        
        //设置标题文字
        CGRect titleRect = titleFrame;
        titleRect.origin.x += 10;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:titleRect];
        titleLabel.text=titleStr;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.backgroundColor =[UIColor clearColor];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.alpha = 0.8;
        [self addSubview:titleLabel];
        // NSLog(@"%@,%@,%@",imageView,titleStr,self);
    }
    return self;
}

-(void)click
{
    [self.uBdelegate click:self.tag];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

@interface BMAdScrollView()<UIScrollViewDelegate,UrLImageButtonDelegate>
{
    int switchDirection;//方向
//    CGFloat offsetY;
    NSMutableArray *imageNameArr;//图片数组
    NSMutableArray *titleStrArr;//标题数组
    
    UIScrollView *imageSV;//滚动视图
    ZZPageControl *pageControl;
}
@end
static  int pageNumber;//页码

@implementation BMAdScrollView


//自定义实例化方法

- (instancetype)initWithNameArr:(NSMutableArray *)imageArr titleArr:(NSMutableArray *)titleArr height:(float)heightValue offsetY:(CGFloat)offsetY {
    
    self = [super initWithFrame:CGRectMake(0, offsetY, SCREENWIDTH, heightValue)];
    
    if (self) {
        
        pageNumber=0;//设置当前页为1
        imageNameArr = imageArr;
        titleStrArr=titleArr;

        [self addADScrollView:imageArr.count height:heightValue];
        [self addImages:imageArr titles:titleArr];
        
      //设置NSTimer
        _timer = [NSTimer scheduledTimerWithTimeInterval:INTERVALE target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;

        pageNumber=0;//设置当前页为1

//        UIImage *placeHolderImage = [UIImage imageNamed:@"pic_jieshao"];
//        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 216, 104)];
//        backgroundView.image = placeHolderImage;
//        [self addSubview:backgroundView];
//        backgroundView.center = CGPointMake(self.width/2.0f, self.height/2.0f);
        
        
        imageSV = [[UIScrollView alloc]initWithFrame:self.bounds];
        //设置sview属性
        
        imageSV.directionalLockEnabled = YES;//锁定滑动的方向
        imageSV.pagingEnabled = YES;//滑到subview的边界
        imageSV.bounces = NO;
        imageSV.delegate = self;
        imageSV.showsVerticalScrollIndicator = NO;//不显示垂直滚动条
        imageSV.showsHorizontalScrollIndicator = NO;//不显示水平滚动条
        
     
        [self addSubview:imageSV];
        
        
        pageControl = [[ZZPageControl alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 20, SCREENWIDTH, 20)];
        pageControl.backgroundColor = [UIColor clearColor];
        pageControl.hidden = YES;
        [pageControl setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        [self addSubview:pageControl];
    }
    return self;
}


- (void)addADScrollView:(NSInteger)count height:(CGFloat)heightValue
{
    //初始化scrollView
    imageSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, heightValue)];
    //设置sview属性
    
    imageSV.directionalLockEnabled = YES;//锁定滑动的方向
    imageSV.pagingEnabled = YES;//滑到subview的边界
    imageSV.bounces = NO;
    imageSV.delegate = self;
    imageSV.showsVerticalScrollIndicator = NO;//不显示垂直滚动条
    imageSV.showsHorizontalScrollIndicator = NO;//不显示水平滚动条
    
    CGSize newSize = CGSizeMake(SCREENWIDTH * (count + 2),  imageSV.frame.size.height);//设置scrollview的大小
    [imageSV setContentSize:newSize];
    [self addSubview:imageSV];

}


- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = [dataSource copy];
    
    for (BMImageView * subView in imageSV.subviews)
    {
        [subView removeFromSuperview];
    }
    
    if (dataSource == nil || dataSource.count == 0) {
        return;
    }
    
    if (dataSource.count > 0)
    {
        pageControl.hidden = NO;
        pageControl.numberOfPages = dataSource.count;
    }
    
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:INTERVALE target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];

    CGSize newSize = CGSizeMake(SCREENWIDTH * (_dataSource.count + 2),  imageSV.frame.size.height);//设置scrollview的大小
    [imageSV setContentSize:newSize];

    for (int i = 0; i <= dataSource.count +1; i++) {
        
        NSString *title = @"";
        NSString *imageURL = @"";
        if (i != dataSource.count +1 && i != 0) {
//            title = titleArr[i - 1]; 
//            imageURL = [dataSource[i - 1] objectForKey:@"imgurl"];
            imageURL = dataSource[i - 1];
        }
        if (i == 0) {
//            title = titleArr[dataSource.count - 1];
//            imageURL = [dataSource[dataSource.count - 1]objectForKey:@"imgurl"];
            imageURL = dataSource[dataSource.count - 1];
        }else if(i == dataSource.count +1)
        {
//            title = titleArr[0];
//            imageURL = [dataSource[0]objectForKey:@"imgurl"];
            imageURL = dataSource[0];
        }
        //创建内容对象
        CGRect titleRect = CGRectMake(0, 150, SCREENWIDTH, 30);
        BMImageView *imageView =  [[BMImageView alloc]initWithImageName:imageURL title:title x:SCREENWIDTH * i tFrame:titleRect iHeight:imageSV.frame.size.height titleHidden:YES];
        
        //制定AOView委托
        imageView.uBdelegate = self;
        //设置视图标示
        imageView.tag = i;
        if (i != dataSource.count +1 && i != 0) {
            //            title = titleArr[i - 1];
            imageView.tag = i - 1;
            
        }
        if (i == 0) {
            //            title = titleArr[dataSource.count - 1];
            imageView.tag = dataSource.count - 1;
        }else if(i == dataSource.count +1)
        {
            //            title = titleArr[0];
            imageView.tag = 0;
        }
        //添加视图
        [imageSV addSubview:imageView];
    }
    [imageSV setContentOffset:CGPointMake(0, -20)];
    [imageSV scrollRectToVisible:CGRectMake(SCREENHEIGHT,0,SCREENWIDTH,self.frame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
}

- (void)addImages:(NSArray *)imageArr titles:(NSArray *)titleArr
{
    //添加图片视图
//    for (int i = 0; i < imageArr.count && !isRepeat; i++) {
//        
//        NSString *title = @"";
//        NSString *imageURL = @"";
//        if (i < titleStrArr.count) {
//            title = titleArr[i];
//            imageURL = imageArr[i];
//        }
//
//        //创建内容对象
//        CGRect titleRect = CGRectMake(0, 150, 320, 30);
//        BMImageView *imageView =  [[BMImageView alloc]initWithImageName:imageURL title:title x:WIDTH*i tFrame:titleRect iHeight:imageSV.frame.size.height titleHidden:NO];
//        
//        //制定AOView委托
//        imageView.uBdelegate = self;
//        //设置视图标示
//        imageView.tag = i;
//        //添加视图
//        [imageSV addSubview:imageView];
//    }
//
    for (int i = 0; i <= imageArr.count +1; i++) {
        
        NSString *title = @"";
        NSString *imageURL = @"";
        if (i != titleStrArr.count +1 && i != 0) {
            title = titleArr[i - 1];
            imageURL = imageArr[i - 1];
        }
        if (i == 0) {
            title = titleArr[titleArr.count - 1];
            imageURL = imageArr[imageArr.count - 1];
        }else if(i == titleArr.count +1)
        {
            title = titleArr[0];
            imageURL = imageArr[0];
        }
        //创建内容对象
        CGRect titleRect = CGRectMake(0, 150, SCREENWIDTH, 30);
        BMImageView *imageView =  [[BMImageView alloc]initWithImageName:imageURL title:title x:SCREENWIDTH*i tFrame:titleRect iHeight:imageSV.frame.size.height titleHidden:NO];
        
        //制定AOView委托
        imageView.uBdelegate = self;
        //设置视图标示
        imageView.tag = i;
        //添加视图
        [imageSV addSubview:imageView];
    }
    [imageSV setContentOffset:CGPointMake(0, -20)];
    [imageSV scrollRectToVisible:CGRectMake(SCREENWIDTH,0,SCREENWIDTH,self.frame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页

}

//NSTimer方法
//-(void)changeView:(NSTimer *)timer
//{
//    NSLog(@"changeView");
//
//    BOOL isAuto = timer != nil;
//    if (pageNumber == imageNameArr.count) {
//        [imageSV setContentOffset:CGPointMake(WIDTH*pageNumber, 0) animated:YES];
//        pageNumber = 0;
//        [imageSV setContentOffset:CGPointMake(WIDTH*pageNumber, 0) animated:YES];
//        pageControl.currentPage = pageNumber;
//        return ;
//    }
//    //修改页码
//    if (pageNumber == 0 && isAuto) {
//        switchDirection = rightDirection;
//    }else if(pageNumber >= imageNameArr.count-1 && isAuto){
//        switchDirection = zeroDirection;
//    }
//    
//    if (switchDirection == rightDirection && isAuto) {
//        pageNumber ++;
//    }else if (switchDirection == zeroDirection && isAuto){
//        pageNumber = 0;
//    }
//    
//    //page++;
//    //    //判断是否大于上线
//    //    if (page==imageNameArr.count) {
//    //        //重置页码
//    //        page=0;
//    //    }
//    //设置滚动到第几页
//    [imageSV setContentOffset:CGPointMake(WIDTH*pageNumber, 0) animated:YES];
//    pageControl.currentPage = pageNumber;
//    
//    
//}

- (void)setPageCenter:(CGPoint)pageCenter
{
    pageControl.center = pageCenter;
}
//// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    NSLog(@"scrollViewDidEndDragging");
//    
//}

    // called when scroll view grinds to a halt
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidEndDecelerating");
//    CGPoint offset = scrollView.contentOffset;
//    pageNumber = (offset.x  + WIDTH * 0.5)/ WIDTH; // 0 1 2
//    NSLog(@"%f  %d",offset.x,pageNumber);
//    [self changeView:nil];
//
//}
// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = imageSV.frame.size.width;
    int page = floor((imageSV.contentOffset.x - pagewidth/([imageNameArr count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    
    page = page > self.dataSource.count-1 ? 0 : page ;
    pageControl.currentPage = page;

}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = imageSV.frame.size.width;
    int currentPage = floor((imageSV.contentOffset.x - pagewidth/ ([self.dataSource count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage == 0)
    {
        [imageSV scrollRectToVisible:CGRectMake(SCREENWIDTH * [self.dataSource count],0,SCREENWIDTH,SCREENHEIGHT) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage == ([self.dataSource count]+1))
    {
        [imageSV scrollRectToVisible:CGRectMake(SCREENWIDTH,0,SCREENWIDTH,SCREENHEIGHT) animated:NO]; // 最后+1,循环第1页
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    NSInteger page = pageControl.currentPage; // 获取当前的page
    [imageSV scrollRectToVisible:CGRectMake(SCREENWIDTH*(page+1),0,SCREENWIDTH,SCREENHEIGHT) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// 定时器 绑定的方法
- (void)runTimePage
{
    NSInteger page = pageControl.currentPage; // 获取当前的page
    
    page++;
    
    page = page > self.dataSource.count-1 ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}
- (void)fire
{
    [_timer fire];
}
- (void)invalidate
{
    [_timer invalidate];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
#pragma UBdelegate
-(void)click:(NSInteger)vid{
    //调用委托实现方法
    
    if ([self.vDelegate respondsToSelector:@selector(buttonClick:value:)])
    {
        NSDictionary *dictionary = [self.dataSource objectAtIndex:vid];
        [self.vDelegate buttonClick:vid value:dictionary];
    }
}
@end
