//
//  SectionModel.h
//  Zhihu
//
//  Created by Fay on 16/1/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionModel : NSObject
/** date 日期 */
@property (nonatomic, copy) NSString *date;
/** stories  当日新闻*/
@property (nonatomic, strong) NSArray *stories;
/** top_stories  顶部新闻*/
@property (nonatomic, strong) NSArray *top_stories;

@end
