//
//  photoViewScroll.m
//  photoTe
//
//  Created by IOS001 on 14-4-29.
//  Copyright (c) 2014年 IOS001. All rights reserved.
//

#import "photoViewScroll.h"

@implementation photoViewScroll

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate=self;
        self.pagingEnabled=YES;
        self.showsHorizontalScrollIndicator=NO;
        curPageNumber=0;
    }
    return self;
}
static bool isCount=NO;
-(void)setImageUrlStringArr:(NSMutableArray *)arr withMode:(BOOL)mode andBeginPage:(int)page andplaceholderImage:(UIImage *)placeholderImage{
    Pimage=placeholderImage;
    
    curPageNumber=page;
    urlStringArr = arr;
    //判断起始位置
    if (arr.count>2) {
        isCount=YES;
        if (curPageNumber==0) {
            self.contentOffset=CGPointMake(0, 0);
        }else if(curPageNumber==(urlStringArr.count-1))
        {
            self.contentOffset=CGPointMake(self.frame.size.width*2, 0);
        }
        else{
            self.contentOffset=CGPointMake(self.frame.size.width, 0);
        }
        self.contentSize=CGSizeMake(self.frame.size.width*3, 0);
        
        for (int i=0; i<3; i++) {
            subScrollView *sub=[[subScrollView alloc]initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
            sub.tag=i+100;
            if (curPageNumber==0) {
                [sub setLoadImagewithUrl:urlStringArr[curPageNumber+i] withMode:mode andplaceholderImage:placeholderImage];
            }else if(curPageNumber==(urlStringArr.count-1))
            {
                [sub setLoadImagewithUrl:urlStringArr[curPageNumber+i-2] withMode:mode andplaceholderImage:placeholderImage];
            }
            else{
                [sub setLoadImagewithUrl:urlStringArr[curPageNumber+i-1] withMode:mode andplaceholderImage:placeholderImage];
            }
            
            [self addSubview:sub];
        }
        self.mode=mode;

    }else{
        isCount=NO;
        for (int i=0; i<arr.count; i++) {
            subScrollView *sub=[[subScrollView alloc]initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
            [sub setLoadImagewithUrl:urlStringArr[i] withMode:mode andplaceholderImage:placeholderImage];
            [self addSubview:sub];
        }
        if (curPageNumber==0) {
            self.contentOffset=CGPointMake(0, 0);
        }else{
            self.contentOffset=CGPointMake(self.frame.size.width, 0);
        }
        self.contentSize=CGSizeMake(self.frame.size.width*arr.count, 0);
    }
    
    }
#pragma mark scrollviewdelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (isCount==YES) {
        if (scrollView==self&&curPageNumber>1&&curPageNumber<(urlStringArr.count-2)) {
            
            self.contentOffset=CGPointMake(self.frame.size.width, 0);
        }
    }
    
    self.userInteractionEnabled=YES;
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.userInteractionEnabled=NO;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isCount==YES) {
        if (curPageNumber==0&&self.contentOffset.x==self.frame.size.width) {
            curPageNumber=1;
        }
        if (scrollView==self) {
            subScrollView *sub1=(subScrollView *)[self viewWithTag:100];
            subScrollView *sub2=(subScrollView *)[self viewWithTag:101];
            subScrollView *sub3=(subScrollView *)[self viewWithTag:102];
            
            if (self.contentOffset.x<=0&&curPageNumber>1) {
                sub1.PhotoImageview.image=nil;
                sub2.PhotoImageview.image=nil;
                sub3.PhotoImageview.image=nil;
                curPageNumber--;
                [self curView];
                self.contentOffset=CGPointMake(self.frame.size.width, 0);
            }
            else if (self.contentOffset.x>=self.frame.size.width*2&&curPageNumber<(urlStringArr.count-2)){
                sub1.PhotoImageview.image=nil;
                sub2.PhotoImageview.image=nil;
                sub3.PhotoImageview.image=nil;
                curPageNumber++;
                [self curView];
                self.contentOffset=CGPointMake(self.frame.size.width, 0);
            }
        }

    }
    }
//刷新
-(void)curView{
    if (isCount==YES) {
        subScrollView *sub1=(subScrollView *)[self viewWithTag:100];
        subScrollView *sub2=(subScrollView *)[self viewWithTag:101];
        subScrollView *sub3=(subScrollView *)[self viewWithTag:102];
        [sub1 setLoadImagewithUrl:urlStringArr[curPageNumber-1] withMode:self.mode andplaceholderImage:Pimage];
        [sub2 setLoadImagewithUrl:urlStringArr[curPageNumber] withMode:self.mode andplaceholderImage:Pimage];
        [sub3 setLoadImagewithUrl:urlStringArr[curPageNumber+1] withMode:self.mode andplaceholderImage:Pimage];
    }else{
        int i=0;
        for (UIView *sub in self.subviews) {
            if ([sub isKindOfClass:[subScrollView class]]) {
                [(subScrollView *)sub setLoadImagewithUrl:urlStringArr[i] withMode:self.mode andplaceholderImage:Pimage];
                i++;
            }
           
        }
    }
    
}
@end
