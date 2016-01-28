//
//  StoriesModel.m
//  Zhihu
//
//  Created by Fay on 15/12/27.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "StoriesModel.h"
#import "MJExtension.h"

@implementation StoriesModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}


@end

