//
//  TableContentViewCell.m
//  Zhihu
//
//  Created by Fay on 15/12/27.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "TableContentViewCell.h"

@implementation TableContentViewCell

- (void)awakeFromNib {
    // Initialization code
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 91, [UIScreen mainScreen].bounds.size.width - 30, 1)];
    line.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    [self addSubview:line];
    
}

//重写取消掉选中效果
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
    
}
//重写取消高亮效果
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

@end
