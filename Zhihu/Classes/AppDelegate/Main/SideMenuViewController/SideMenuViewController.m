//
//  SideMenuViewController.m
//  Zhihu
//
//  Created by Fay on 15/12/10.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "SideMenuViewController.h"
#import "ItemsView.h"
#import "ThemeTool.h"
#import "Theme.h"
#import "MJExtension.h"
#import "TableContentViewCell.h"
#import "DataSource.h"
#import "ThemeViewController.h"
#import "SWRevealViewController.h"
#import "PageViewController.h"

#define kRowHeight 44
@interface SideMenuViewController ()<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign,nonatomic) CGFloat startHeight;
@property (weak, nonatomic) IBOutlet UIButton *homePageBtn;
@property (nonatomic, strong) ThemeTool *tool;
@property (nonatomic, strong) NSMutableArray *themesArray;
@property (nonatomic, strong) DataSource *tableViewDataSource;
@property (nonatomic, strong) ThemeViewController *themeVc;

@property (nonatomic, strong) UINavigationController *navi;
@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.tool getThemesWithSuccessfulBlock:^(id obj) {
        [self.themesArray addObjectsFromArray:obj];
        [self setScrollView];
    }];
  
}

/**
 *  设置scrollView
 */
-(void)setScrollView {
    
        _startHeight = 47;
    for (int i = 0; i<self.themesArray.count; i++) {
        ItemsView *itemsView = [[[NSBundle mainBundle]loadNibNamed:@"ItemsView" owner:self options:nil] lastObject];
        
        itemsView.frame = CGRectMake(0, _startHeight, _scrollView.width, kRowHeight);
        [_scrollView addSubview:itemsView];
        _startHeight += kRowHeight;
        [itemsView.contentButton addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchDown];
        [itemsView.contentButton setImage:[UIImage imageNamed:@"Dark_Action_Button"] forState:UIControlStateHighlighted];
        itemsView.contentButton.tag = i;
        
        Theme *theme = self.themesArray[i];
        itemsView.itemName.text = theme.name;
        
    }

    [_homePageBtn addTarget:self action:@selector(homePageClick) forControlEvents:UIControlEventTouchDown];
}


-(void)homePageClick {
    
    PageViewController *pageVc = [[PageViewController alloc]init];
    pageVc.view.backgroundColor = [UIColor whiteColor];
    
    SWRevealViewController *swVc = self.revealViewController;
    
    [swVc pushFrontViewController:pageVc animated:YES];
 
}

-(void)touch:(UIButton *)button {
    
    Theme *theme = self.themesArray[button.tag];
    
    self.themeVc.theme = theme;
    SWRevealViewController *swVc = self.revealViewController;
    
    [swVc pushFrontViewController:self.navi animated:YES];
    
}

//重新计算大小
-(void)viewDidLayoutSubviews {
    self.scrollView.contentSize = CGSizeMake(0,_startHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ThemeTool *)tool{
    if (_tool == nil) {
        _tool = [[ThemeTool alloc]init];
        
    }
    return _tool;
}

- (NSMutableArray *)themesArray{
    if (_themesArray == nil) {
        _themesArray = [NSMutableArray array];
        
    }
    return _themesArray;
}

- (UINavigationController *)navi{
    if (_navi == nil) {
        _navi = [[UINavigationController alloc]initWithRootViewController:self.themeVc];
        _navi.navigationBarHidden = YES;
        
    }
    return _navi;
}


- (ThemeViewController *)themeVc{
    if ( _themeVc == nil) {
        _themeVc = [[ThemeViewController alloc]init];
        _themeVc.view.backgroundColor = [UIColor whiteColor];
    }
    return _themeVc;
}

@end
