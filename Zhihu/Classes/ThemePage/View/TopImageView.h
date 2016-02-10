//
//  TopImageView.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/10.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopImageView : UIImageView
/**
 *  顶部图片
 *
 *  @param tableView tableView
 *
 *  @return TopImageView
 */
+ (TopImageView *)addToTableView:(UITableView *)tableView;
@end
