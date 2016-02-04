//
//  TopView.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/4.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailStoryModel.h"

@interface TopView : UIView
@property (nonatomic, strong) DetailStoryModel *detailStory;

+ (instancetype)addToView:(UIView *)view observeScorllView:(UIWebView *)webView;

@end
