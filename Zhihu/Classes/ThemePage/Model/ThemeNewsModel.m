//
//  ThemeNewsModel.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/10.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "ThemeNewsModel.h"
#import "MJExtension.h"
#import "StoriesModel.h"
#import "EditorMoedel.h"

@implementation ThemeNewsModel
+(NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"stories" : [StoriesModel class],
             @"editors" : [EditorMoedel class]
             };
}
@end
