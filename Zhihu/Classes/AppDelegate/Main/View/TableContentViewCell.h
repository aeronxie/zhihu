//
//  TableContentViewCell.h
//  Zhihu
//
//  Created by Fay on 15/12/27.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoriesModel.h"

@interface TableContentViewCell : UITableViewCell

@property (nonatomic,strong) StoriesModel *storyModel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
