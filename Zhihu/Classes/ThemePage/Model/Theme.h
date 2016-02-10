//
//  Theme.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/10.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject
/** thumbnail  图片地址*/
@property (nonatomic, copy) NSString *thumbnail;

/** id  编号*/
@property (nonatomic, copy) NSNumber *id;

/** name  名称*/
@property (nonatomic, copy) NSString *name;
@end
