//
//  DetailViewTool.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailViewTool : NSObject
/**
 *  获得某个id的详细内容
 */
+ (void)getDetailStoryWithStoryId:(NSNumber *)storyId Callback:(void (^)(id obj))callBack;
/**
 *  获得id的点赞评论数
 */
+ (void)getStoryToolDataWithStoryId:(NSNumber *)storyId Callback:(void (^)(id obj))callBack;

@end
