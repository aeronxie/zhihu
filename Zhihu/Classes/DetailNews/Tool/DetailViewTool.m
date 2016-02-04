//
//  DetailViewTool.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "DetailViewTool.h"
#import "HttpTool.h"
#import "DetailStoryModel.h"
#import "MJExtension.h"
#import "StoryTabbarData.h"

static NSString *const detailUrl = @"http://news-at.zhihu.com/api/4/news/";
static NSString *const extralUrl = @"http://news-at.zhihu.com/api/4/story-extra/";

@implementation DetailViewTool

+(void)getDetailStoryWithStoryId:(NSNumber *)storyId Callback:(void (^)(id))callBack {
    
    [HttpTool get:[NSString stringWithFormat:@"%@%@",detailUrl,storyId] parameters:nil success:^(id json) {
        
        DetailStoryModel *story = [DetailStoryModel mj_objectWithKeyValues:json];
        story.htmlUrl = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",story.css[0],story.body];
        if (callBack) {
            callBack(story);
        }
    } failure:^(NSError *error) {
        nil;
    }];
    
}

+(void)getStoryToolDataWithStoryId:(NSNumber *)storyId Callback:(void (^)(id))callBack {
    
    [HttpTool get:[NSString stringWithFormat:@"%@%@",extralUrl,storyId] parameters:nil success:^(id json) {
        StoryTabbarData *extra = [StoryTabbarData mj_objectWithKeyValues:json];
        
        if (callBack) {
            callBack(extra);
        }
    } failure:^(NSError *error) {
        nil;
    }];
    
}
@end
