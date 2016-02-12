//
//  EditoCell.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/12.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "EditoCell.h"
#import "UIImageView+WebCache.h"
#import "EditorMoedel.h"
@implementation EditoCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier editors:(NSArray *)editors{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        for (NSInteger i = 0; i < editors.count; i++) {
            EditorMoedel *editor = editors[i];
            UIImageView *avatar = [[UIImageView alloc]init];
            [avatar sd_setImageWithURL:[NSURL URLWithString:editor.avatar]placeholderImage:[UIImage imageNamed:@"Account_Avatar"]];
            avatar.clipsToBounds = YES;
            avatar.layer.cornerRadius = 10;
            avatar.contentMode = UIViewContentModeScaleAspectFit;
            avatar.frame = CGRectMake( 60 + (i * 20) + (i * 10), 10, 20, 20);
            [self.contentView addSubview:avatar];
        }
            self.textLabel.text = @"主编";
            self.textLabel.textColor = [UIColor lightGrayColor];
            self.textLabel.font = [UIFont systemFontOfSize:14];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 38, kScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
        [self addSubview:line];

    }
        return self;
}


//重写取消掉选中效果
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
    
    
}
//重写取消高亮效果
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
}

@end


