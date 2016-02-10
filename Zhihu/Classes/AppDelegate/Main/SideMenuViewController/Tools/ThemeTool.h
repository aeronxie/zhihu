//
//  ThemeTool.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/10.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"
@interface ThemeTool : NSObject
/**
 *  获得主题日报的列表
 */
- (void)getThemesWithSuccessfulBlock:(void(^)(id obj))block;

@end
