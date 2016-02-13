//
//  EditorInfoCell.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/13.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "EditorInfoCell.h"
#import "UIImageView+WebCache.h"
#import "EditorMoedel.h"

@interface EditorInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bio;

@end

@implementation EditorInfoCell


-(void)setEditor:(EditorMoedel *)editor {
    _editor = editor;
    self.avatar.layer.cornerRadius = 15;
    self.avatar.clipsToBounds = YES;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:editor.avatar] placeholderImage:[UIImage imageNamed:@"Account_Avatar"]];
    self.name.text = editor.name;
    self.bio.text = editor.bio;
    
}

- (void)awakeFromNib {
    // Initialization code
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    [self addSubview:line];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}
@end
