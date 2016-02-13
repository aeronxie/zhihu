//
//  BrowserViewController.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/13.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "BrowserViewController.h"
#import "UMSocial.h"


@interface BrowserViewController ()<UIWebViewDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) UIButton *tabbarBackBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *tabBarView;

@property (nonatomic, strong) UIButton *naviBackBtn;
@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, strong) UIButton *goBackBtn;
@property (nonatomic, strong) UIButton *goForwardBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) NSString *shareText;
@property (nonatomic, assign) UIStatusBarStyle oldStyle;
@end

@implementation BrowserViewController

-(instancetype)initWithNSString:(NSString *)str {
    
    if (self = [super init]) {
        self.url = [NSURL URLWithString:str];
        self.view.backgroundColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.naviBackBtn];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tabBarView];
    
    [self.tabBarView addSubview:self.tabbarBackBtn];
    [self.tabBarView addSubview:self.refreshBtn];
    [self.tabBarView addSubview:self.goBackBtn];
    [self.tabBarView addSubview:self.goForwardBtn];
    [self.tabBarView addSubview:self.shareBtn];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _tabbarBackBtn.frame = _tabBarView.bounds;
    _tabbarBackBtn.width = _tabBarView.width * 0.2;
    
    _refreshBtn.frame = _tabbarBackBtn.frame;
    _refreshBtn.x = _tabbarBackBtn.width;
    
    _goBackBtn.frame = _refreshBtn.frame;
    _goBackBtn.x = _goBackBtn.x + _goBackBtn.width;
    
    _goForwardBtn.frame = _goBackBtn.frame;
    _goForwardBtn.x = _goForwardBtn.x + _goForwardBtn.width;
    
    _shareBtn.frame = _goForwardBtn.frame;
    _shareBtn.x = _shareBtn.x + _shareBtn.width;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self calculateBtnIsDisable];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self calculateBtnIsDisable];
    self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.shareText = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - private method
- (void)backLastView{
    [self.navigationController popViewControllerAnimated:YES];
}

//按钮是不是可以按
- (void)calculateBtnIsDisable{
    self.goBackBtn.enabled = self.webView.canGoBack;
    self.goForwardBtn.enabled = self.webView.canGoForward;
}

- (void)share{
        
    //设置QQ分享内容
    [UMSocialData defaultData].extConfig.qqData.title = @"知乎";
    [UMSocialData defaultData].extConfig.qqData.url = [self.url absoluteString];
    //设置微信分享内容
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [self.url absoluteString];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"知乎";
        
    //设置分享类型
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:nil
                                          shareText:self.shareText
                                         shareImage:[UIImage imageNamed:@"share"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToEmail,UMShareToRenren,UMShareToWechatSession,UMShareToLWTimeline,UMShareToWhatsapp,UMShareToTencent,UMShareToSms,UMShareToQzone,UMShareToAlipaySession, nil]
                                           delegate:self];
        
    }
    
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}



#pragma mark - getter and setter

- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight - 60 - 40)];
        _webView.delegate = self;
    }
    return _webView;
}

- (void)setUrl:(NSURL *)url{
    _url = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (UIView *)naviView{
    if (_naviView == nil) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _naviView.backgroundColor = kColor(23, 144, 211);
    }
    return _naviView;
}

- (UIButton *)naviBackBtn{
    
    if (_naviBackBtn == nil) {
        _naviBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_naviBackBtn addTarget:self action:@selector(backLastView)
           forControlEvents:UIControlEventTouchUpInside];
        [_naviBackBtn setBackgroundImage:[UIImage imageNamed:@"Back_White"]
                            forState:UIControlStateNormal];
        
        _naviBackBtn.frame = CGRectMake(5, 18, 40, 40);
        
    }
    return _naviBackBtn;
}

- (UIButton *)tabbarBackBtn{
    
    if (_tabbarBackBtn == nil) {
        _tabbarBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tabbarBackBtn addTarget:self action:@selector(backLastView)
            forControlEvents:UIControlEventTouchUpInside];
        [_tabbarBackBtn setImage:[UIImage imageNamed:@"Back_White"]
                   forState:UIControlStateNormal];
    }
    return _tabbarBackBtn;
}

- (UIButton *)refreshBtn{
    
    if (_refreshBtn == nil) {
        
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_refreshBtn addTarget:self.webView
                        action:@selector(reload)
              forControlEvents:UIControlEventTouchUpInside];
        
        [_refreshBtn setImage:[UIImage imageNamed:@"Browser_Icon_Reload"]
                     forState:UIControlStateNormal];
    }
    return _refreshBtn;
}

- (UIButton *)goBackBtn{
    if (_goBackBtn == nil) {
        _goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBackBtn addTarget:self.webView
                       action:@selector(goBack)
             forControlEvents:UIControlEventTouchUpInside];
        [_goBackBtn setImage:[UIImage imageNamed:@"Browser_Icon_Back"]
                    forState:UIControlStateNormal];
        [_goBackBtn setImage:[UIImage imageNamed:@"Browser_Icon_Back_Disable"]
                    forState:UIControlStateDisabled];
    }
    return _goBackBtn;
}

- (UIButton *)goForwardBtn{
    
    if (_goForwardBtn == nil) {
        _goForwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goForwardBtn addTarget:self.webView
                          action:@selector(goForward)
                forControlEvents:UIControlEventTouchUpInside];
        [_goForwardBtn setImage:[UIImage imageNamed:@"Browser_Icon_Forward"]
                       forState:UIControlStateNormal];
        [_goForwardBtn setImage:[UIImage imageNamed:@"Browser_Icon_Forward_Disable"]
                       forState:UIControlStateDisabled];
    }
    return _goForwardBtn;
}

- (UIButton *)shareBtn{
    if (_shareBtn == nil) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn addTarget:self
                      action:@selector(share)
            forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn setImage:[UIImage imageNamed:@"Browser_Icon_Action"]
                   forState:UIControlStateNormal];
    }
    return _shareBtn;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 23, kScreenWidth - 80, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)tabBarView{
    if (_tabBarView == nil) {
        _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40)];
        _tabBarView.backgroundColor = kColor(70, 67, 70);
    }
    return _tabBarView;
}

@end
