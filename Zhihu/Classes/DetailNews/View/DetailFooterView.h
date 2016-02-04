//
//  DetailFooterView.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/4.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailFooterView : UIView
+ (DetailFooterView *)addObserveToScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action;

@end
