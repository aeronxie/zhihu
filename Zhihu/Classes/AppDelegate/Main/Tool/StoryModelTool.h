//
//  StoryModelTool.h
//  Zhihu
//
//  Created by Fay on 16/1/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoriesModel.h"

@interface StoryModelTool : NSObject
/**
 *  加载最新数据
 *
 *  @param getSectionBlock section数据
 */
-(void)loadNewStoriesWithData:(void(^)(id obj))getDataBlock;
/**
 *  刷新第一天数据
 *
 *  @param refreshDataBlock 数据
 */
-(void)refreshStoriesWithData:(void(^)(id obj))refreshDataBlock;
/**
 *  加载以前的数据
 *
 *  @param refreshDataBlock 数据
 */
- (void)loadFormerStoriesWithData:(void(^)())refreshDataBlock;
/**
 *  是否是第一条
 *
 *  @param number ID
 *
 *  @return BOOL
 */
- (BOOL)isTheFirstNewsWithStoryId:(NSNumber *)number;
/**
 *  是否是最后一条
 *
 *  @param number ID
 *
 *  @return BOOL
 */
- (BOOL)isTheLastNewsWithStoryId:(NSNumber *)number;
/**
 *  获取下一条新闻ID
 *
 *  @param number ID
 *
 *  @return NSNumber
 */
- (NSNumber *)getNextNewsWithId:(NSNumber *)number;
/**
 *  获取下一条新闻ID
 *
 *  @param number ID
 *
 *  @return NSNumber
 */
- (NSNumber *)getLastNewsWithId:(NSNumber *)number;

@end
