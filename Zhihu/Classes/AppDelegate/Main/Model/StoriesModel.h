//
//  StoriesModel.h
//  Zhihu
//
//  Created by Fay on 15/12/27.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoriesModel : NSObject

/** id  内容id */
@property (nonatomic, assign) NSInteger ID;
/** title 新闻标题 */
@property (nonatomic, copy) NSString *title;
/** 类型 */
@property (nonatomic, assign) NSInteger type;
/** image  界面顶部的图片 */
@property (nonatomic, strong) NSArray *images;
/** 供 Google Analytics 使用 */
@property (nonatomic, copy) NSString *ga_prefix;
/** multipic   是否多图 */
@property (nonatomic, assign, getter=isMutipic) BOOL multipic;

@end
