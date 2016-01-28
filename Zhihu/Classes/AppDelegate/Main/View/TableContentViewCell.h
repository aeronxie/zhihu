//
//  TableContentViewCell.h
//  Zhihu
//
//  Created by Fay on 15/12/27.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableContentViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;

@end
