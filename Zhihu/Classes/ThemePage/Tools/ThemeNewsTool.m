//
//  ThemeNewsTool.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/10.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "ThemeNewsTool.h"
#import "MJExtension.h"
#import "HttpTool.h"
#import "ThemeNewsModel.h"

static NSString *const themeUrl = @"http://news-at.zhihu.com/api/4/theme/";

@interface ThemeNewsTool ()
@property (nonatomic, strong) NSArray *newsIds;

@end
@implementation ThemeNewsTool

- (void)getThemeNewsWithId:(NSNumber *)Id SuccessfulBlock:(void(^)(id obj))block {
    NSString *url = [NSString stringWithFormat:@"%@%@",themeUrl,Id];
    __weak typeof(self) weakSelf = self;
    [HttpTool get:url parameters:nil success:^(id json) {
        ThemeNewsModel *themes = [ThemeNewsModel mj_objectWithKeyValues:json];
        weakSelf.newsIds = [themes.stories valueForKeyPath:@"id"];
        if (block) {
            block(themes);
        }
    } failure:^(NSError *error) {
        nil;
    }];
    
    
}

- (BOOL)isTheFirstNewsWithStoryId:(NSNumber *)number {
    if ([number isEqual:self.newsIds[0]]) {
        return YES;
    }
    return NO;
    
}

- (BOOL)isTheLastNewsWithStoryId:(NSNumber *)number {
    if ([number isEqual:self.newsIds.lastObject]) {
        return YES;
    }
    return NO;
    
}

- (NSNumber *)getNextNewsWithId:(NSNumber *)number {
    NSInteger index = [self.newsIds indexOfObject:number];
    return [self.newsIds objectAtIndex:++index];
    
}

- (NSNumber *)getLastNewsWithId:(NSNumber *)number {
    NSInteger index = [self.newsIds indexOfObject:number];
    return [self.newsIds objectAtIndex:--index];
   
}

@end
