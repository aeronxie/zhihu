//
//  DetailHeaderView.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailHeaderView : UIView
+ (DetailHeaderView *)addObserveToScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action;
@end
