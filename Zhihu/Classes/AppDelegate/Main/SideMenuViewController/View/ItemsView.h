//
//  ItemsView.h
//  Zhihu
//
//  Created by Fay on 15/12/11.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsView : UIView
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *contentButton;

@end
