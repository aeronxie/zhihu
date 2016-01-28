//
//  StoryModelTool.m
//  Zhihu
//
//  Created by Fay on 16/1/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "StoryModelTool.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "SectionModel.h"

static  NSString *const baseUrl = @"http://news-at.zhihu.com/api/4/news/latest";
static  NSString *const pastUrl = @"http://news-at.zhihu.com/api/4/news/before/";

@interface StoryModelTool ()
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,assign,getter=isLoading) BOOL loading;
@property (nonatomic,strong) NSMutableArray *newsIds;
@property (nonatomic,strong) NSString *date;
@end

@implementation StoryModelTool
//加载最新数据
-(void)loadNewStoriesWithData:(void (^)(id))getDataBlock {
    
    __weak typeof(self) weakSelf = self;
    [HttpTool get:baseUrl parameters:nil success:^(id json) {
        SectionModel *sectionModel = [SectionModel mj_objectWithKeyValues:json];
        [weakSelf.data addObject:sectionModel];
        //计算ID
        [weakSelf calculteNewsIds];
        weakSelf.date = sectionModel.date;
        if (getDataBlock) {
            getDataBlock(weakSelf.data);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
//刷新数据
-(void)refreshStoriesWithData:(void (^)(id obj))refreshDataBlock {
    
    __weak typeof(self) weakSelf = self;
    
    [HttpTool get:baseUrl parameters:nil success:^(id json) {
        SectionModel *section = [SectionModel mj_objectWithKeyValues:json];
        [weakSelf.data replaceObjectAtIndex:0 withObject:section];
        [weakSelf calculteNewsIds];
        if (refreshDataBlock) {
            refreshDataBlock(weakSelf.data);
        }
    } failure:^(NSError *error) {
        
    }];
    
}
//加载以前的数据
- (void)loadFormerStoriesWithData:(void(^)())refreshDataBlock {
    
     __weak typeof(self) weakSelf = self;
    if (self.isLoading) {
        return;
    }
    self.loading = !self.loading;
    NSString *newUrl  = [NSString stringWithFormat:@"%@%@",baseUrl,self.date];
    [HttpTool get:newUrl parameters:nil success:^(id json) {
        SectionModel *section = [SectionModel mj_objectWithKeyValues:json];
        [weakSelf.data addObject:section];
        [weakSelf calculteNewsIds];
        if (refreshDataBlock) {
            refreshDataBlock();
        }
        self.loading = !self.loading;
    } failure:^(NSError *error) {
        
    }];
}

//计算最新ID
- (void)calculteNewsIds {
    self.newsIds = [self.data valueForKeyPath:@"stories.id"];
    NSMutableArray *newArray = [NSMutableArray array];
    for (int i = 0; i<self.newsIds.count; i++) {
        NSArray *array = self.newsIds[i];
        [newArray addObjectsFromArray:array];
    }

    self.newsIds = newArray;
}

//是否为第一条
- (BOOL)isTheFirstNewsWithStoryId:(NSNumber *)number {
    if([number isEqual:self.newsIds[0]]) {
        return YES;
    }else {
        return NO;
    }
    
}
//是否是最后一条
- (BOOL)isTheLastNewsWithStoryId:(NSNumber *)number {
    if ([number isEqual:self.newsIds.lastObject]) {
        return YES;
    }else {
    
        return NO;
    }
}

//下一条ID
- (NSNumber *)getNextNewsWithId:(NSNumber *)number {
    
    NSInteger index = [self.newsIds indexOfObject:number];
    return [self.newsIds objectAtIndex:++index];
    
}

//上一条ID
- (NSNumber *)getLastNewsWithId:(NSNumber *)number {
    
    NSInteger index = [self.newsIds indexOfObject:number];
    return [self.newsIds objectAtIndex:--index];
  
}


-(NSMutableArray *)data {
    
    if (!_data) {
        _data = [NSMutableArray array];
        
    }
    return _data;
}
@end
