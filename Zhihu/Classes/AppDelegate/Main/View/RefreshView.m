//
//  RefreshView.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/2.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "RefreshView.h"

@interface RefreshView ()
@property (strong,nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong,nonatomic) CAShapeLayer *whiteCircleLayer;
@property (strong,nonatomic) CAShapeLayer *grayCircleLayer;

@end


@implementation RefreshView

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //菊花指示器
        _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self addSubview:_indicatorView];
        
        CGFloat radius = MIN(frame.size.width, frame.size.height)/2;
        
        //灰色圆圈
        _grayCircleLayer = [[CAShapeLayer alloc]init];
        _grayCircleLayer.lineWidth = 1.f;
        _grayCircleLayer.strokeColor = [UIColor grayColor].CGColor;
        _grayCircleLayer.fillColor = [UIColor clearColor].CGColor;
        _grayCircleLayer.opacity = 0.f;
        _grayCircleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.width/2 - radius, self.height/2 - radius, 2 * radius, 2 * radius)].CGPath;
        [self.layer addSublayer:_grayCircleLayer];
        
        //白色填充
        _whiteCircleLayer = [[CAShapeLayer alloc] init];
        _whiteCircleLayer.lineWidth = 1.5f;
        _whiteCircleLayer.strokeColor = [UIColor whiteColor].CGColor;
        _whiteCircleLayer.fillColor = [UIColor clearColor].CGColor;
        _whiteCircleLayer.strokeEnd = 0.f;
        _whiteCircleLayer.opacity = 0.f;
        _whiteCircleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius:radius startAngle:M_PI_2 endAngle:M_PI*5/2 clockwise:YES].CGPath;
        [self.layer addSublayer:_whiteCircleLayer];
    }
   
    
    return self;
}

-(void)drawFromProgress:(CGFloat)progress {
    
    if (progress>0) {
        _whiteCircleLayer.opacity = 1.f;
        _grayCircleLayer.opacity = 1.f;
    }else if (progress <= 0){
        _whiteCircleLayer.opacity = 0.f;
        _grayCircleLayer.opacity = 0.f;
    }
    _whiteCircleLayer.strokeEnd = progress;
    
}

-(void)hiddenView {
    _whiteCircleLayer.opacity = 0.f;
    _grayCircleLayer.opacity = 0.f;
}

- (void)startAnimation {
    [_indicatorView startAnimating];
}

- (void)stopAnimation {
    [_indicatorView stopAnimating];
}

@end
