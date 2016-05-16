//
//  EACommentView.m
//  FamilyActivities
//
//  Created by LoveLi1y on 15/3/20.
//  Copyright (c) 2015年 LoveLi1y. All rights reserved.
//

#import "EACommentView.h"

@implementation EACommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    
//    [self.titleTextField becomeFirstResponder];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeLabel.hidden = YES;
    
   [self.contentView setFrame:CGRectMake(0, INCREMENT, SCREENWIDTH, 300)];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.contentView setFrame:CGRectMake(0, SCREENHEIGHT - 300, SCREENWIDTH, 300)];
}
- (IBAction)textFieldEditingAction:(UITextField *)sender
{
    [self.contentView setFrame:CGRectMake(0, INCREMENT, SCREENWIDTH, 300)];
}

- (IBAction)textFieldEndEditingAction:(UITextField *)sender
{
    [self.contentView setFrame:CGRectMake(0, SCREENHEIGHT - 300, SCREENWIDTH, 300)];
}
- (IBAction)cancelAction:(id)sender
{
    [self removeFromSuperview];
}
- (IBAction)submitAction:(id)sender
{
//    [self removeFromSuperview];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:DEVICEID forKey:MSN];
    [dic setValue:self.activityId forKey:@"id"];
    [dic setValue:self.titleTextField.text forKey:@"username"];
    [dic setValue:self.contentTextView.text forKey:@"content"];
    
    
    [ZYHttpRequest post:dic keyString:SUBMIT_COMMENT withBlock:^(id obj, NSError *error) {
        NSMutableDictionary *recivedDictionary = obj;
        if ([[recivedDictionary objectForKey:SUCCESS] isEqualToString:@"1"])
        {
//            [commentDataArray setArray:[recivedDictionary objectForKey:DATA][DISCUSSDATA]];
//            
//            [commentTableView reloadData];
            if ([self.delegate respondsToSelector:@selector(submitCommentSuccess)])
            {
                [self.delegate submitCommentSuccess];
            }
            [self removeFromSuperview];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"评论失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
}
@end
