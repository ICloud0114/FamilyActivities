//
//  EATitleCell.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/22.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EATitleCell.h"
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define EA_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:CGSizeMake((maxSize.width), (maxSize.height)) options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define EA_MULTILINE_TEXTSIZE(text, font, maxSize,mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode: mode] : CGSizeZero;
#endif

@implementation EATitleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellFrame:(NSDictionary *)dic
{
    self.infoLabel.text = [dic objectForKey:@"aWhat"];
    
    if (![[dic objectForKey:@"aWhen"] isEqualToString:@""])
    {
        self.openTimeLabel.text =  [dic objectForKey:@"aWhen"];
    }
    else
    {
        self.openTimeTitle.hidden = YES;
        self.openTimeLabel.hidden = YES;
    }
    
    
    [self.addressButton setTitle:[dic objectForKey:@"aWhere"] forState:UIControlStateNormal];
    
    CGSize contentSize = EA_MULTILINE_TEXTSIZE(self.infoLabel.text, self.infoLabel.font, CGSizeMake(SCREENWIDTH - 92, 9999), self.infoLabel.lineBreakMode);
    CGRect contentRect = self.infoLabel.frame;
    
    contentRect.size.height = contentSize.height;
    
    [self.infoLabel setFrame:contentRect];
    
    _cellHeight =  HEIGHT(self.infoLabel) + 105;

}
@end
