//
//  ThemeData.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/11.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ThemeCellConfigureBlock)(id cell, id item);

@interface ThemeData : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)stories
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(ThemeCellConfigureBlock)aConfigureCellBlock;


- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
