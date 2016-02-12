//
//  EditoCell.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/12.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditoCell : UITableViewCell
@property (nonatomic, strong) NSArray *editors;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier editors:(NSArray *)editors;
@end
