//
//  DetailViewController.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailStoryModel.h"
#import "TopView.h"
#import "DetailHeaderView.h"
#import "DetailFooterView.h"
#import "DetailViewTool.h"
#import "StoryModelTool.h"
#import "BrowserViewController.h"

@interface DetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) DetailStoryModel *detailStory;
@property (nonatomic, strong) TopView *topView;

@property (nonatomic, strong) UILabel *lastLabel;
@property (nonatomic, strong) UILabel *firstLabel;

@property (nonatomic, strong) DetailHeaderView *headerView;
@property (nonatomic, strong) DetailFooterView *footerView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [self.webView.scrollView removeObserver:self.headerView forKeyPath:@"contentOffset"];
    [self.webView.scrollView removeObserver:self.footerView forKeyPath:@"contentOffset"];
    
}

#pragma mark - WebViewDelgate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //调整字号
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    
    //    上拉加载
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    CGFloat height = [height_str floatValue];
    if ([self.tool isTheLastNewsWithStoryId:self.storyId]) {
        [self.webView.scrollView addSubview:self.lastLabel];
        self.lastLabel.y = height + 20;
    }else{
        self.footerView.y = height + 15;
        [self.webView.scrollView addSubview:self.footerView];
    }

    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *str = request.URL.absoluteString;
    //去掉连接签名多余部分
    if ([str hasPrefix:@"myweb:imageClick:"]) {
        str = [str stringByReplacingOccurrencesOfString:@"myweb:imageClick:"
                                             withString:@""];
        //[WebImgScrollView showImageWithStr:str];
        return YES;
        
    }else if ([str isEqualToString:@"about:blank"]){
        
    } else{
        BrowserViewController *webVC = [[BrowserViewController alloc] initWithNSString:str];
        [self.navigationController pushViewController:webVC animated:YES];
        return NO;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return YES;

  
    return YES;
}


// 加载下一条新闻
- (void)loadNextNews{
    
    if ([self.delegate respondsToSelector:@selector(scrollToNextViewWithNumber:)]) {
        [self.delegate scrollToNextViewWithNumber:[self.tool getNextNewsWithId:self.storyId]];
    }
    
}
//加载上一条新闻
- (void)loadLastNews{
    
    if ([self.delegate respondsToSelector:@selector(scrollToLastViewWithNumber:)]) {
        [self.delegate scrollToLastViewWithNumber:[self.tool getLastNewsWithId:self.storyId]];
    }
    
}


//计算frame
- (void)calculateFrameWithDetailStory:(DetailStoryModel *)detailStory{
    
    [self.webView loadHTMLString:self.detailStory.htmlUrl
                         baseURL:nil];
    
    if (detailStory.image) {
        [self.view addSubview:self.topView];
        self.topView.detailStory = detailStory;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    //    第一个有图
    if ([self.tool isTheFirstNewsWithStoryId:self.storyId] && detailStory.image) {
        
        self.firstLabel.y =  20;
        [self.topView addSubview:self.firstLabel];
        //      第一个没图
    }else if([self.tool isTheFirstNewsWithStoryId:self.storyId] && !detailStory.image){
        
        self.firstLabel.y = -50;
        [self.webView.scrollView addSubview:self.firstLabel];
        //        不是第一个有图
    }else if (![self.tool isTheFirstNewsWithStoryId:self.storyId] && detailStory.image){
        self.headerView.y = 20;
        [self.topView addSubview:self.headerView];
        //        不是第一个没图
    }else{
        self.headerView.y = -50;
        [self.webView.scrollView addSubview:self.headerView];
    }
    
}


#pragma mark - getter and setter
- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20 - 40)];
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (TopView *)topView{
    if (_topView == nil) {
        _topView = [TopView addToView:self.view observeScorllView:self.webView];
    }
    return _topView;
}

- (void)setStoryId:(NSNumber *)storyId{
    _storyId = storyId;
    __weak typeof(self) weakSelf = self;
    [DetailViewTool getDetailStoryWithStoryId:storyId Callback:^(id obj) {
        weakSelf.detailStory = obj;
    }];
}

- (UILabel *)lastLabel{
    if (_lastLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"这已经是最后一篇了";
        [label sizeToFit];
        label.textColor = [UIColor grayColor];
        label.centerX = self.view.centerX;
        label.font = [UIFont systemFontOfSize:14.0];
        _lastLabel = label;
    }
    return _lastLabel;
}

- (DetailHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [DetailHeaderView addObserveToScrollView:self.webView.scrollView target:self action:@selector(loadLastNews)];
    }
    return _headerView;
}

- (DetailFooterView *)footerView{
    if (_footerView == nil) {
        _footerView = [DetailFooterView addObserveToScrollView:self.webView.scrollView target:self action:@selector(loadNextNews)];
    }
    return _footerView;
}

- (UILabel *)firstLabel{
    if (_firstLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"这已经是第一篇了";
        [label sizeToFit];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.f];
        label.centerX = self.view.centerX;
        _firstLabel = label;
    }
    return _firstLabel;
}

- (void)setDetailStory:(DetailStoryModel *)detailStory{
    _detailStory = detailStory;
    
    [self calculateFrameWithDetailStory:detailStory];
}

@end
