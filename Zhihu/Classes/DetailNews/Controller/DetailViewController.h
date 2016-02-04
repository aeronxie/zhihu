//
//  DetailViewController.h
//  Zhihu
//
//  Created by 谢飞 on 16/2/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewControllerDelegate <NSObject>

@optional

/**
 *  通知containerController滚动到上一个页面
 *
 */
- (void)scrollToNextViewWithNumber:(NSNumber *)storyId;
/**
 *  通知containerController滚动到下一个页面
 *
 */
- (void)scrollToLastViewWithNumber:(NSNumber *)storyId;

@end


@interface DetailViewController : UIViewController

/**故事ID */
@property (nonatomic, strong) NSNumber *storyId;

@property (nonatomic, strong) id tool;

@property (nonatomic, weak) id <DetailViewControllerDelegate> delegate;

@end
