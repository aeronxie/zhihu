//
//  Theme.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/10.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "Theme.h"
#import "MJExtension.h"

@implementation Theme
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

@end
