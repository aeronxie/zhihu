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

#define kRowHeight 44
@interface SideMenuViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign,nonatomic) CGFloat startHeight;
@property (weak, nonatomic) IBOutlet UIButton *homePageBtn;
@property (nonatomic, strong) ThemeTool *tool;
@property (nonatomic, strong) NSArray *themesArray;

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.tool getThemesWithSuccessfulBlock:^(id obj) {
        self.themesArray = obj;
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
    
    NSLog(@"点击了首页");
  
}
-(void)touch:(UIButton *)button {
    
    NSLog(@"点击了我了 %ld",(long)button.tag);
}

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//    NSLog(@"%f",_startHeight);
//    self.scrollView.contentSize = CGSizeMake(0, _startHeight);
//
//}

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


@end
