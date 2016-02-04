//
//  DetailStoryModel.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailStoryModel : NSObject
/**body  HTML 格式的新闻*/
@property (nonatomic,copy) NSString *body;
/**image-source  图片的内容提供方*/
@property (nonatomic,copy) NSString *image_source;
/**title  新闻标题*/
@property (nonatomic,copy) NSString *title;
/**image  图片*/
@property (nonatomic,copy) NSString *image;
/**share_url  分享至 SNS 用的 URL*/
@property (nonatomic,copy) NSString *share_url;
/**id  新闻的 id*/
@property (nonatomic,strong) NSNumber *id;
/**css  供手机端的 WebView(UIWebView) 使用的样式 */
@property (nonatomic, strong) NSArray *css;


/**html  供手机端的 WebView(UIWebView) 使用的内容*/
@property (nonatomic, copy) NSString *htmlUrl;
/**recommenders  这篇文章的推荐者*/
@property (nonatomic,copy) NSString *recommenders;
@end
