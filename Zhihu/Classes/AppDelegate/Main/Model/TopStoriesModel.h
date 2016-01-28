//
//  TopStoriesModel.h
//  Zhihu
//
//  Created by Fay on 15/12/23.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopStoriesModel : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *ga_prefix;

@end

