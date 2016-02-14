//
//  NSArray+Extension.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/14.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "NSMutableArray+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Extension)

+ (void)load {
    
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method originaMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
        
        Method swizzleMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(xf_objectAtIndex:));
        
        method_exchangeImplementations(originaMethod, swizzleMethod);
   
    });
}

- (id)xf_objectAtIndex:(NSUInteger)index {
    if (self.count <= index) {
        // 这里做一下异常处理，不然都不知道出错了。
        @try {
            return [self xf_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息，方便我们调试。
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        }
        @finally {}
    } else {
        return [self xf_objectAtIndex:index];
    }
}
@end

