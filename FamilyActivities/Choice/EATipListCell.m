//
//  EATipListCell.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EATipListCell.h"
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define EA_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:CGSizeMake((maxSize.width), (maxSize.height)) options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define EA_MULTILINE_TEXTSIZE(text, font, maxSize,mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode: mode] : CGSizeZero;
#endif
@implementation EATipListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellFrame:(NSDictionary *)dic
{
    self.userLabel.text = [dic objectForKey:@"tag"];
    self.dateLabel.text =  [dic objectForKey:@"author"];
    self.contentLabel.text = [dic objectForKey:@"title"];
    
    CGSize contentSize = EA_MULTILINE_TEXTSIZE(self.contentLabel.text, self.contentLabel.font, CGSizeMake(SCREENWIDTH - 96, 9999), self.contentLabel.lineBreakMode);
    CGRect contentRect = self.contentLabel.frame;
    
    contentRect.size.height = contentSize.height;
    
    [self.contentLabel setFrame:contentRect];
    
    _cellHeight =  (HEIGHT(self.contentLabel) + 45 > 88 ? HEIGHT(self.contentLabel) + 45: 88);
    
}
@end
