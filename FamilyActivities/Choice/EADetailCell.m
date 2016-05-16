//
//  EADetailCell.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/22.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EADetailCell.h"
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define EA_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:CGSizeMake((maxSize.width), (maxSize.height)) options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define EA_MULTILINE_TEXTSIZE(text, font, maxSize,mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode: mode] : CGSizeZero;
#endif

@interface EADetailCell()
{
    NSDictionary *dataDictionary;
}
@end

@implementation EADetailCell

- (void)awakeFromNib {
    // Initialization code
    
    
}


- (void)drawRect:(CGRect)rect
{
    
    
    if (![[dataDictionary objectForKey:@"age"] isEqualToString:@""])
    {
        self.ageLabel.text = [dataDictionary objectForKey:@"age"];
        [self.ageTitle setFrame:CGRectMake(X(self.ageTitle), Y(self.ageTitle), WIDTH(self.ageTitle), HEIGHT(self.ageTitle))];
        [self.ageLabel setFrame:CGRectMake(X(self.ageLabel), Y(self.ageTitle), WIDTH(self.ageLabel), HEIGHT(self.ageLabel))];
    }
    else
    {
        
        [self.ageTitle setFrame:CGRectMake(X(self.ageTitle), Y(self.ageTitle), WIDTH(self.ageTitle), 0)];
        [self.ageLabel setFrame:CGRectMake(X(self.ageLabel), Y(self.ageTitle), WIDTH(self.ageLabel), 0)];
        
    }
    
    if (![[dataDictionary objectForKey:@"worktime"] isEqualToString:@""])
    {
        self.timeLabel.text = [dataDictionary objectForKey:@"worktime"];
        
        [self.timeTitle setFrame:CGRectMake(X(self.timeTitle), Y(self.ageTitle) + HEIGHT(self.ageTitle) + 8, WIDTH(self.timeTitle), HEIGHT(self.timeTitle))];
        [self.timeLabel setFrame:CGRectMake(X(self.timeLabel), Y(self.timeTitle) , WIDTH(self.timeLabel), HEIGHT(self.timeLabel))];
    }
    else
    {
        
        [self.timeTitle setFrame:CGRectMake(X(self.timeTitle), Y(self.ageTitle) + HEIGHT(self.ageTitle), WIDTH(self.timeTitle), 0)];
        [self.timeLabel setFrame:CGRectMake(X(self.timeLabel), Y(self.timeTitle), WIDTH(self.timeLabel), 0)];
    }
    
    if (![[dataDictionary objectForKey:@"fee"] isEqualToString:@""])
    {
        self.costLabel.text = [dataDictionary objectForKey:@"fee"];
        
        [self.costTitle setFrame:CGRectMake(X(self.costTitle),  Y(self.timeTitle) + HEIGHT(self.timeTitle) + 8, WIDTH(self.costTitle), HEIGHT(self.costTitle))];
        [self.costLabel setFrame:CGRectMake(X(self.costLabel), Y(self.costTitle), WIDTH(self.costLabel), HEIGHT(self.costLabel))];
        
    }
    else
    {
        [self.costTitle setFrame:CGRectMake(X(self.costTitle), Y(self.timeTitle) + HEIGHT(self.timeTitle), WIDTH(self.costTitle), 0)];
        
        [self.costLabel setFrame:CGRectMake(X(self.costLabel), Y(self.costTitle), WIDTH(self.costLabel), 0)];
        
        
    }
    
    if (![[dataDictionary objectForKey:@"contact"] isEqualToString:@""])
    {
        self.phoneLabel.text = [dataDictionary objectForKey:@"contact"];
        
        [self.phoneTitle setFrame:CGRectMake(X(self.phoneTitle), Y(self.costTitle) + HEIGHT(self.costTitle) + 8, WIDTH(self.phoneTitle), HEIGHT(self.phoneTitle))];
        [self.phoneLabel setFrame:CGRectMake(X(self.phoneLabel), Y(self.phoneTitle), WIDTH(self.phoneLabel), HEIGHT(self.phoneLabel))];
        
    }
    else
    {
        [self.phoneTitle setFrame:CGRectMake(X(self.phoneTitle), Y(self.costTitle) + HEIGHT(self.costTitle), WIDTH(self.phoneTitle), 0)];
        [self.phoneLabel setFrame:CGRectMake(X(self.phoneLabel), Y(self.phoneTitle), WIDTH(self.phoneLabel), 0)];
        
    }
    
    
    if (![[dataDictionary objectForKey:@"extInfo"] isEqualToString:@""])
    {
        self.detailLabel.text = [dataDictionary objectForKey:@"extInfo"];
        
        
        [self.detailLabel setFont:[UIFont systemFontOfSize:15]];
        
        [self.detailTitle setFrame:CGRectMake(X(self.detailTitle), Y(self.phoneTitle) + HEIGHT(self.phoneTitle) + 8, WIDTH(self.detailTitle), HEIGHT(self.detailTitle))];
        
        CGSize contentSize = EA_MULTILINE_TEXTSIZE(self.detailLabel.text, self.detailLabel.font, CGSizeMake(SCREENWIDTH - 92, 9999), self.detailLabel.lineBreakMode);
        
        [self.detailLabel setFrame:CGRectMake(X(self.detailLabel), Y(self.detailTitle), WIDTH(self.detailLabel), contentSize.height)];
        
        
        
        
        
    }
    else
    {
        [self.detailTitle setFrame:CGRectMake(X(self.detailTitle), Y(self.phoneTitle) + HEIGHT(self.phoneTitle), WIDTH(self.detailTitle), 0)];
        [self.detailLabel setFrame:CGRectMake(X(self.detailLabel), Y(self.detailTitle) , WIDTH(self.detailLabel), 0)];
        
    }
    
    
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellFrame:(NSDictionary *)dic
{
    dataDictionary = dic;
    
    CGFloat labelHeight = 0.0f;
    if (![[dataDictionary objectForKey:@"age"] isEqualToString:@""])
    {
        self.ageLabel.text = [dataDictionary objectForKey:@"age"];
        labelHeight += 29;
    }
    else
    {
        self.ageLabel.text  = @"";
        self.ageTitle.text  = @"";
    }
    
    if (![[dataDictionary objectForKey:@"worktime"] isEqualToString:@""])
    {
        self.timeLabel.text = [dataDictionary objectForKey:@"worktime"];
        labelHeight += 29;
    }
    else
    {
        self.timeTitle.text = @"";
        self.timeLabel.text = @"";
    }
    
    if (![[dataDictionary objectForKey:@"fee"] isEqualToString:@""])
    {
        self.costLabel.text = [dataDictionary objectForKey:@"fee"];
        labelHeight += 29;
    }
    else
    {
        self.costTitle.text = @"";
        self.costLabel.text = @"";
        
    }
    
    if (![[dataDictionary objectForKey:@"contact"] isEqualToString:@""])
    {
        self.phoneLabel.text = [dataDictionary objectForKey:@"contact"];
        labelHeight += 29;
    }
    else
    {
        self.phoneLabel.text = @"";
        self.phoneTitle.text = @"";
    }
    
    
    if (![[dataDictionary objectForKey:@"extInfo"] isEqualToString:@""])
    {
        self.detailLabel.text = [dataDictionary objectForKey:@"extInfo"];
        
        CGSize contentSize = EA_MULTILINE_TEXTSIZE(self.detailLabel.text, self.detailLabel.font, CGSizeMake(SCREENWIDTH - 92, 9999), self.detailLabel.lineBreakMode);
        CGRect contentRect = self.detailLabel.frame;
        
        contentRect.size.height = contentSize.height;
        
        [self.detailLabel setFrame:contentRect];
        
        labelHeight += contentSize.height;
    }
    else
    {
        self.detailTitle.text = @"";
        self.detailLabel.text = @"";
    }
    
    _cellHeight =  (labelHeight + 58);
}


- (void)setframe:(UILabel *)low superLabel:(UILabel *)height
{
    CGRect label = low.frame;
    label.origin.y = Y(height) + HEIGHT(height);
    low.frame = label;
}

- (void)setLabelHeigtToZero:(UILabel *)label
{
    CGRect rect = label.frame;
    rect.size.height = 0;
    label.frame = rect;
}
@end
