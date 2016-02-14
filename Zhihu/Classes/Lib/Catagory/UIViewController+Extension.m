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
    //保证交换方法只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method originaMethod = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method swizzleMethod = class_getInstanceMethod(self, @selector(xf_viewDidLoad));
        
        method_exchangeImplementations(originaMethod, swizzleMethod);
        
    });
}


-(void)xf_viewDidLoad {
    
    NSLog(@"%@",self.class);
    
    [self xf_viewDidLoad];
}

   


@end
