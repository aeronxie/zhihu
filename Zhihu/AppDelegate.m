//
//  AppDelegate.m
//  Zhihu
//
//  Created by Fay on 15/12/9.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "AppDelegate.h"
#import "PageViewController.h"
#import "SideMenuViewController.h"
#import "SWRevealViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.firstStart = YES;
    
    [self setMainViewController];
    //[self judgeFirst];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 *  判断是否是第一次打开页面
 */
-(void)judgeFirst {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"first");
    
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstStart"];
        NSLog(@"Not first");
    }

}

/**
 *  设置主控制器
 */
-(void)setMainViewController {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    PageViewController *main = [[PageViewController alloc]init];
    
    //UINavigationController *VC = [[UINavigationController alloc]initWithRootViewController:main];
    
    [self.window makeKeyAndVisible];
    
    SideMenuViewController *sideVc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"slider"];
    SWRevealViewController *swVc = [[SWRevealViewController alloc]initWithRearViewController:sideVc frontViewController:main];
    swVc.rearViewRevealWidth = 250;
    self.window.rootViewController = swVc;

}

@end
