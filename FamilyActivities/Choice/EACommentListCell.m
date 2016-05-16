//
//  EACommentListCell.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/1/22.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EACommentListCell.h"
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define EA_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:CGSizeMake((maxSize.width), (maxSize.height)) options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define EA_MULTILINE_TEXTSIZE(text, font, maxSize,mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode: mode] : CGSizeZero;
#endif
@implementation EACommentListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellFrame:(NSDictionary *)dic
{
    self.userLabel.text = [dic objectForKey:@"user"];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:[dic objectForKey:@"edittime"]];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    formatter2.dateFormat = @"MM-dd HH:mm";
    self.timeLabel.text = [formatter2 stringFromDate:date1];
//    self.timeLabel.text =  [dic objectForKey:@"edittime"];
    self.commentTitle.text = [dic objectForKey:@"content"];
    
    CGSize contentSize = EA_MULTILINE_TEXTSIZE(self.commentTitle.text, self.commentTitle.font, CGSizeMake(SCREENWIDTH - 65, 9999), self.commentTitle.lineBreakMode);
    CGRect contentRect = self.commentTitle.frame;
    
    contentRect.size.height = contentSize.height;
    
    [self.commentTitle setFrame:contentRect];
    
    _cellHeight =  (HEIGHT(self.commentTitle) + 53 > 74 ? HEIGHT(self.commentTitle) + 53: 74);
    
}

@end
