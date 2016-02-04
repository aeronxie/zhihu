//
//  AppDelegate.h
//  Zhihu
//
//  Created by Fay on 15/12/9.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL firstStart;
@property (nonatomic, strong) SWRevealViewController *swVc;
@end

