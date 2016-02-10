//
//  ThemeNewsModel.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/10.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeNewsModel : NSObject
/**主题内容*/
@property (nonatomic, strong) NSArray *stories;
/**编辑*/
@property (nonatomic, strong) NSArray *editors;
/**主题背景图*/
@property (nonatomic, copy) NSString *image;
/**主题名称*/
@property (nonatomic, copy) NSString *name;

@end
