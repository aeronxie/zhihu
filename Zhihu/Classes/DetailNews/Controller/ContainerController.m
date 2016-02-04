//
//  ContainerController.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "ContainerController.h"
#import "ToolsTabbar.h"


typedef NS_OPTIONS(NSInteger, ToolsTabbarTag) {
    ToolsTabbarTagBack = 1 << 0,
    ToolsTabbarTagNext = 1 << 1,
    ToolsTabbarTagPraise = 1 << 2,
    ToolsTabbarTagShare = 1 << 3,
    ToolsTabbarTagComment = 1 << 3,

};
static CGFloat const animationDuraion = 0.2f;
@interface ContainerController ()<ToolsTabbarDelegate>

@end

@implementation ContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
