//
//  oneScrollView.m
//  photo
//
//  Created by IOS001 on 14-4-28.
//  Copyright (c) 2014年 IOS001. All rights reserved.
//

#import "subScrollView.h"
#import "SDWebImageManager.h"
@implementation subScrollView
@synthesize PhotoImageview;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate=self;
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
        self.backgroundColor = [UIColor clearColor];
        self.bounces=NO;
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap:)];
    
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        self.userInteractionEnabled=YES;
        
        PhotoImageview =[[UIImageView alloc]initWithFrame:self.bounds];
        

         [self addSubview:PhotoImageview];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taponce:)];
        tap.numberOfTapsRequired=1;

        [tap requireGestureRecognizerToFail:doubleTap];
        act=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        act.frame=CGRectMake(self.frame.size.width/2-10, self.frame.size.height/2-10, 20, 20);
        [self addSubview:act];
    }
    return self;
}
-(void)taponce:(UITapGestureRecognizer *)tap{
    if ([self.mydelegate respondsToSelector:@selector(popView)]) {
        [self.mydelegate popView];
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView==self) {
    return PhotoImageview;
    }
    return Nil;
}

//imageview居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView==self) {
        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    PhotoImageview.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
    }
    
}
-(void)DoubleTap:(UITapGestureRecognizer *)tap{
    CGPoint point=[tap locationInView:self];
    if (self.zoomScale==self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }else{
        [self zoomToRect:CGRectMake(point.x, point.y, 1, 1) animated:YES];
    }
}
//下载图片

-(void)setLoadImagewithUrl:(NSString *)urlString withMode:(BOOL)mode andplaceholderImage:(UIImage *)placeholderImage{
    __block subScrollView *one=self;

    [act startAnimating];
    PhotoImageview.frame=self.bounds;
    
   [ PhotoImageview sd_setImageWithURL:[NSURL URLWithString:urlString]placeholderImage:placeholderImage     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       [one imageDidFinishedLoad:image withmode:mode];
        
    }];
  
}
-(void)setminzoom{
    [self setZoomScale:self.minimumZoomScale ];
}
-(void)imageDidFinishedLoad:(UIImage *)image withmode:(BOOL)mode{
//     PhotoImageview.image=image;
    if (image) {
        [self adjustFramewithMode:mode];
    }
}
//调整imageview的frame
-(void)adjustFramewithMode:(BOOL)mode {
    
    if (!PhotoImageview.image) {
        return;
    }
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = PhotoImageview.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    CGFloat widthRatio = boundsWidth/imageWidth;
    CGFloat heightRatio = boundsHeight/imageHeight;
    CGFloat minScale = (widthRatio > heightRatio) ? heightRatio : widthRatio;
    if (minScale >= 1) {
		minScale = 0.8;
	}
	CGFloat maxScale = 4.0;
    self.minimumZoomScale=minScale;
    self.maximumZoomScale=maxScale;
    self.zoomScale=minScale;
    //重设imageview的frame
    self.contentSize=CGSizeMake(0, 0);
    if (mode==YES) {
        CGFloat heightImage=imageHeight*widthRatio;
        if (heightImage<=self.frame.size.height) {
            PhotoImageview.frame=CGRectMake(0, (boundsHeight-heightImage)/2, boundsWidth, heightImage);
        }
        else{
            PhotoImageview.frame=CGRectMake(0, 0, boundsWidth, heightImage);
            self.contentSize=CGSizeMake(0, PhotoImageview.frame.size.height);
            self.contentOffset=CGPointMake(0, (heightImage-boundsHeight)/2);
        }
    }else{
        if (imageWidth/imageHeight>=boundsWidth/boundsHeight) {
            imageHeight=imageHeight * widthRatio;
            PhotoImageview.frame=CGRectMake(0, (boundsHeight-imageHeight)/2, boundsWidth,imageHeight);
            
        }else{
            imageWidth=imageWidth *heightRatio;
           CGRect re =CGRectMake((boundsWidth-imageWidth)/2, 0, imageWidth, boundsHeight);
            
            PhotoImageview.frame=re;
        }
        
    }
    [act stopAnimating];
//    [self addSubview:PhotoImageview];
//    NSLog(@"test.y==%f",self.frame.origin.y);
    
}
-(void)dealloc{
    self.mydelegate=nil;
}
@end
