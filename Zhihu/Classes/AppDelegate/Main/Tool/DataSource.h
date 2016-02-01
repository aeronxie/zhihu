//
//  DataSource.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/1.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject <UITableViewDataSource>
typedef void (^TableViewCellConfigureBlock)(id cell, id item);


- (id)initWithItems:(NSArray *)stories
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(void (^)(id cell,id item))configureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
