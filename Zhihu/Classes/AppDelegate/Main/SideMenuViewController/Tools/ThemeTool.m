
//
//  ThemeTool.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/10.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "ThemeTool.h"
#import "MJExtension.h"
#import "HttpTool.h"

static NSString *const themeUrl = @"http://news-at.zhihu.com/api/4/themes";
@implementation ThemeTool
- (void)getThemesWithSuccessfulBlock:(void(^)(id obj))block {
    
    [HttpTool get:themeUrl parameters:nil success:^(id json) {
        NSArray *array = [NSArray array];
        array = [Theme mj_objectArrayWithKeyValuesArray: json[@"others"]];
        block(array);
    } failure:^(NSError *error) {
        nil;
    }];
}
@end
