//
//  HeaderView.m
//  Zhihu
//
//  Created by Fay on 16/1/9.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "HeaderView.h"

static NSString *const headerID = @"header";
@implementation HeaderView

+(instancetype)homeHeaderViewWithTableView:(UITableView *)tableView {
    HeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (!header) {
        header = [[HeaderView alloc]init];
        header.contentView.backgroundColor = kColor(23, 144, 211);
    }
    return header;
}

//必须在layoutsubviews 里边写
- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.centerX = self.centerX;
}

-(void)setDate:(NSString *)date {
    _date = date;
    if (date) {
        _date = [NSString getDetailDate:date];
        self.textLabel.attributedText = [[NSAttributedString alloc]initWithString:_date attributes:@{NSFontAttributeName:
                                                                                                         [UIFont systemFontOfSize:18] ,
                                                                                                     NSForegroundColorAttributeName:
                                                                                                         [UIColor whiteColor]}];
    }
}
@end
