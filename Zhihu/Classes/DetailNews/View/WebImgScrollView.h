//
//  WebImgScrollView.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/14.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebImgScrollView : UIView
/** imgUrl  图片地址*/
@property (nonatomic, copy) NSString *imgUrl;

+ (WebImgScrollView *)showImageWithStr:(NSString *)url;

@end
