//
//  RefreshView.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/2.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshView : UIView
- (void)drawFromProgress:(CGFloat)progress;
- (void)startAnimation;
- (void)stopAnimation;
-(void)hiddenView;
@end
