//
//  TopView.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/4.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "TopView.h"
#import "StoriesModel.h"
#import "UIImageView+WebCache.h"

@interface TopView ()
@property (nonatomic, strong) StoriesModel *storyModel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UIWebView *scrollView;
@property (nonatomic, assign, getter=isObserve) BOOL observe;

@end
@implementation TopView

-(instancetype)initWithFrame:(CGRect)frame storyModel:(StoriesModel *)storyModel {
    
    TopView *topView = [[[NSBundle mainBundle]loadNibNamed:@"TopView" owner:self options:nil] lastObject];
    topView.frame = frame;
    topView.storyModel = storyModel;
    
    return topView;
    
}

+(instancetype)addToView:(UIView *)view observeScorllView:(UIWebView *)webView {
    
    TopView *topView = [[[NSBundle mainBundle] loadNibNamed:@"TopView"
                                                      owner:self
                                                    options:nil]
                        lastObject];
    topView.frame = CGRectMake(0, -45, kScreenWidth, 265);
    topView.observe = YES;
    [view addSubview:topView];
    topView.scrollView = webView;
    [webView.scrollView addObserver:topView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    return topView;

    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    UIScrollView *scrollView = object;
    CGFloat offSetY = scrollView.contentOffset.y;
    
    if (offSetY<=0&&offSetY>=-90) {
        self.frame = CGRectMake(0, -45 - 0.5 * offSetY, kScreenWidth, 265 - 0.5 * offSetY);
    }else if(offSetY<-90){
        self.scrollView.scrollView.contentOffset = CGPointMake(0, -90);
    }else if(offSetY <= 500) {
        
        if (offSetY <= 220) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }else [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
        self.y = -45 - offSetY;
    }

}

- (void)dealloc{
    if (self.isObserve) {
        [self.scrollView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
}


-(void)setDetailStory:(DetailStoryModel *)detailStory {
    
    _detailStory = detailStory;
    self.titleLabel.text =  detailStory.title;
    self.sourceLabel.text = [NSString stringWithFormat:@"图片:%@",detailStory.image_source];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:detailStory.image] placeholderImage:[UIImage imageNamed:@"Field_Mask_Bg"]];
    
}

-(void)setStoryModel:(StoriesModel *)storyModel {
    
    _storyModel = storyModel;
    self.titleLabel.text = storyModel.title;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:storyModel.image] placeholderImage:[UIImage imageNamed:@"Field_Mask_Bg"]];
    
    
}




@end
