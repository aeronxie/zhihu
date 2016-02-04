//
//  DataSource.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/1.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface DataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)stories
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;


- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
