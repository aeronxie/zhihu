//
//  ContainerController.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "ContainerController.h"
#import "ToolsTabbar.h"
#import "DetailViewController.h"
#import "DetailStoryModel.h"
#import "DetailViewTool.h"
#import "AppDelegate.h"
#import "StoryModelTool.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"


typedef NS_OPTIONS(NSInteger, ToolsTabbarTag) {
    ToolsTabbarTagBack = 1 << 0,
    ToolsTabbarTagNext = 1 << 1,
    ToolsTabbarTagPraise = 1 << 2,
    ToolsTabbarTagShare = 1 << 3,
    ToolsTabbarTagComment = 1 << 3,

};
static CGFloat const animationDuraion = 0.2f;

@interface ContainerController ()<ToolsTabbarDelegate,DetailViewControllerDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) ToolsTabbar *toolsTabbar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DetailViewController *detailVc;
@property (nonatomic, strong) DetailStoryModel *story;
@end

@implementation ContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.toolsTabbar];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    self.detailVc = [self setContainerController];
    //成为子控制器
    [self.scrollView addSubview:self.detailVc.view];
    [self addChildViewController:self.detailVc];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DetailViewControllerDelegate
- (void)scrollToNextViewWithNumber:(NSNumber *)storyId{
    
    self.storyId = storyId;
    [self setContentOffset:2.f];
    
}

- (void)scrollToLastViewWithNumber:(NSNumber *)storyId{
    
    self.storyId = storyId;
    [self setContentOffset:0.f];
    
    
}

#pragma mark - NewsNavigationDelegate
-(void)touchupTabbar:(ToolsTabbar *)tabbar btnTag:(NSInteger)tag {
    
    switch (tag) {
        case ToolsTabbarTagBack:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case ToolsTabbarTagNext:
            if (![self.tool isTheLastNewsWithStoryId:self.storyId]) {
                [self scrollToNextViewWithNumber:[self.tool getNextNewsWithId:self.storyId]];
            }
            break;
         case ToolsTabbarTagShare:
            [self share];
        default:
            break;
    }

}

-(void)share {
    
    //设置QQ分享内容
    [UMSocialData defaultData].extConfig.qqData.title = self.story.title;
    [UMSocialData defaultData].extConfig.qqData.url = self.story.share_url;
    //设置微信分享内容
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.story.share_url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.story.title;
    
    //设置分享类型
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.story.image];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                              appKey:nil
                                           shareText:self.story.title
                                          shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.story.image]]]
                                     shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToEmail,UMShareToRenren,UMShareToWechatSession,UMShareToLWTimeline,UMShareToWhatsapp,UMShareToTencent,UMShareToSms,UMShareToQzone,UMShareToAlipaySession, nil]
                                            delegate:self];
    
}

-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

#pragma mark - getter and setter
- (void)setStoryId:(NSNumber *)storyId{
    _storyId = storyId;
    [DetailViewTool getDetailStoryWithStoryId:storyId Callback:^(id obj) {
        self.story = obj;
        
    }];
}


//设置滚动偏移值
- (void)setContentOffset:(CGFloat)number {
    
    DetailViewController *detailVc = [self setContainerController];
    [UIView animateWithDuration:animationDuraion animations:^{
        
        self.scrollView.contentOffset = CGPointMake(0, number * kScreenHeight);
    } completion:^(BOOL finished) {
        [self.detailVc removeFromParentViewController];
        [self.detailVc.view removeFromSuperview];
        self.detailVc = nil;
        self.scrollView.contentOffset = CGPointMake(0, kScreenHeight);
        self.detailVc = detailVc;
        [self.scrollView addSubview:self.detailVc.view];
        [self addChildViewController:self.detailVc];
        
    }];
 
}


//创建一个子控制器
-(DetailViewController *)setContainerController {
    
    DetailViewController *detailVc = [[DetailViewController alloc]init];
    detailVc.view.frame = CGRectMake(0, self.scrollView.height, kScreenWidth, self.scrollView.height);
    detailVc.storyId = self.storyId;
    _toolsTabbar.id = self.storyId;
    detailVc.tool = self.tool;
    detailVc.delegate = self;
 
    return detailVc;
}

- (ToolsTabbar *)toolsTabbar{
    if (_toolsTabbar == nil) {
        _toolsTabbar = [[ToolsTabbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40)];
        _toolsTabbar.delegate = self;
    }
    return _toolsTabbar;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, 3 * kScreenHeight);
        _scrollView.contentOffset = CGPointMake(0, kScreenHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}


@end
