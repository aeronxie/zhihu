//
//  ToolsTabbar.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToolsTabbar;

@protocol  ToolsTabbarDelegate <NSObject>

@optional

-(void)touchupTabbar:(ToolsTabbar *)tabbar btnTag:(NSInteger)tag;

@end

@interface ToolsTabbar : UIView

@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,weak) id <ToolsTabbarDelegate> delegate;
@end
