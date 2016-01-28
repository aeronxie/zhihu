//
//  SectionModel.m
//  Zhihu
//
//  Created by Fay on 16/1/3.
//  Copyright © 2016年 Fay. All rights reserved.
//


#import "SectionModel.h"

@implementation SectionModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{ @"stories" : [StoriesModel class],
              @"top_stories" : [TopStoriesModel class],
             };
}

@end
