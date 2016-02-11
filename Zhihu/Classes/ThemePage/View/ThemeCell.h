//
//  ThemeCell.h
//  Zhihu
//
//  Created by Fay on 16/02/11.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoriesModel.h"

@interface ThemeCell : UITableViewCell

@property (nonatomic,strong) StoriesModel *storyModel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
