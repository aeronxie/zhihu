//
//  ThemeNewsTool.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/10.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeNewsTool : NSObject
- (void)getThemeNewsWithId:(NSNumber *)Id SuccessfulBlock:(void(^)(id obj))block;

- (BOOL)isTheFirstNewsWithStoryId:(NSNumber *)number;

- (BOOL)isTheLastNewsWithStoryId:(NSNumber *)number;

- (NSNumber *)getNextNewsWithId:(NSNumber *)number;

- (NSNumber *)getLastNewsWithId:(NSNumber *)number;

@end
