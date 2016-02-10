//
//  UIViewController+Extension.m
//  
//
//  Created by 谢飞 on 16/2/9.
//
//

#import "UIViewController+Extension.h"
#import <objc/runtime.h>

@implementation UIViewController (Extension)
+ (void)load {
    
    Method originaMethod = class_getInstanceMethod(self, @selector(viewDidLoad));
    Method swizzleMethod = class_getInstanceMethod(self, @selector(xf_viewDidLoad));
    
    method_exchangeImplementations(originaMethod, swizzleMethod);
    
    
}


-(void)xf_viewDidLoad {
    
    NSLog(@"%@",self);
    
    [self xf_viewDidLoad];
}

   


@end
