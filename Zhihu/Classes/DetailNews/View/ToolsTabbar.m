//
//  ToolsTabbar.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "ToolsTabbar.h"
#import "DetailStoryModel.h"
#import "StoryTabbarData.h"
#import "DetailViewTool.h"

@interface ToolsTabbar ()

@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *commentBtn;

@property (nonatomic,strong) UILabel *praiseLabel;
@property (nonatomic,strong) UILabel *commentLabel;

@end

@implementation ToolsTabbar

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.backBtn];
        [self addSubview:self.nextBtn];
        [self addSubview:self.praiseBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.commentBtn];
        [self.praiseBtn addSubview:self.praiseLabel];
        [self.commentBtn addSubview:self.commentLabel];
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.backBtn.frame = self.bounds;
    self.backBtn.width = self.width * 0.2;
    
    self.nextBtn.frame = self.backBtn.frame;
    self.nextBtn.x = self.backBtn.x + self.backBtn.width;
    
    self.praiseBtn.frame = self.nextBtn.frame;
    self.praiseBtn.x = self.nextBtn.x + self.nextBtn.width;
    
    self.shareBtn.frame = self.praiseBtn.frame;
    self.shareBtn.x = self.praiseBtn.x + self.shareBtn.width;
    
    self.commentBtn.frame = self.shareBtn.frame;
    self.commentBtn.x = self.shareBtn.x + self.shareBtn.width;
    
    self.praiseLabel.x = self.praiseBtn.width * 0.5;
    self.praiseLabel.y = self.praiseBtn.height * 0.2;
    self.praiseLabel.width = self.praiseBtn.width * 0.3;
    self.praiseLabel.height = self.praiseBtn.height * 0.2;
    
    self.commentLabel.x = self.commentBtn.width * 0.5;
    self.commentLabel.y = self.commentBtn.height * 0.2;
    self.commentLabel.width = self.commentBtn.width * 0.3;
    self.commentLabel.height = self.commentBtn.height * 0.2;
   
    
}

-(void)touchupTabbar:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(touchupTabbar:btnTag:)]) {
        [self.delegate touchupTabbar:self btnTag:sender.tag];
    }
    
}

#pragma mark - getter and setter
- (void)setId:(NSNumber *)number{
    _id = number;
    
    [DetailViewTool getStoryToolDataWithStoryId:number Callback:^(StoryTabbarData *obj) {
        self.commentLabel.text = [NSString stringWithFormat:@"%@",obj.comments];
        self.praiseLabel.text = [NSString stringWithFormat:@"%@",obj.popularity];
    }];
    
    
}


- (UIButton *)backBtn{
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"News_Navigation_Arrow"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(touchupTabbar:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.tag = 1;
    }
    return _backBtn;
}

- (UIButton *)nextBtn{
    if (_nextBtn == nil) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setImage:[UIImage imageNamed:@"News_Navigation_Next"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(touchupTabbar:) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.tag = 2;
    }
    return _nextBtn;
}

- (UIButton *)praiseBtn{
    if (_praiseBtn == nil) {
        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseBtn setImage:[UIImage imageNamed:@"News_Navigation_Vote"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"News_Navigation_Voted"] forState:UIControlStateSelected];
        [_praiseBtn addTarget:self action:@selector(touchupTabbar:) forControlEvents:UIControlEventTouchUpInside];
        _praiseBtn.tag = 4;
    }
    return _praiseBtn;
}

- (UIButton *)shareBtn{
    if (_shareBtn == nil) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"News_Navigation_Share"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(touchupTabbar:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.tag = 8;
    }
    return _shareBtn;
}

- (UIButton *)commentBtn{
    if (_commentBtn == nil) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"News_Navigation_Comment"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(touchupTabbar:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.tag = 16;
    }
    return _commentBtn;
}

- (UILabel *)praiseLabel{
    if (_praiseLabel == nil) {
        _praiseLabel = [[UILabel alloc] init];
        _praiseLabel.textColor = [UIColor grayColor];
        _praiseLabel.font = [UIFont systemFontOfSize:8.f];
        _praiseLabel.text = @"888";
        _praiseLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _praiseLabel;
}

- (UILabel *)commentLabel{
    if (_commentLabel == nil) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor whiteColor];
        _commentLabel.font = [UIFont systemFontOfSize:8.f];
        _commentLabel.text =  @"999";
        _commentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _commentLabel;
}


@end
