//
//  HeaderView.h
//  Zhihu
//
//  Created by Fay on 16/1/9.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UITableViewHeaderFooterView
@property (nonatomic,copy) NSString *date;

+ (instancetype)homeHeaderViewWithTableView:(UITableView *)tableView;

@end
