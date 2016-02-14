//
//  LeftMenuViewController.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/13.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "HomeCell.h"
#import "ContentCell.h"
#import "ThemeTool.h"
#import "Theme.h"
#import "ThemeViewController.h"
#import "SWRevealViewController.h"
#import "PageViewController.h"

@interface LeftMenuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ThemeTool *tool;
@property (nonatomic, strong) UINavigationController *navi;
@property (nonatomic, strong) ThemeViewController *themeVc;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    [self.tool getThemesWithSuccessfulBlock:^(id obj) {
        [self.themesArray addObjectsFromArray:obj];
        self.tableView.dataSource = self;
        [self.tableView reloadData];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.themesArray.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //默认选中第一行
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

    if (indexPath.row == 0) {
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
        return cell;
    } else {
    Theme *theme = self.themesArray[indexPath.row - 1];
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell"];
    cell.theme = theme;
    
    return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.row == 0) {
        PageViewController *pageVc = [[PageViewController alloc]init];
        pageVc.view.backgroundColor = [UIColor whiteColor];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:pageVc];
        navi.navigationBarHidden = YES;
        SWRevealViewController *swVc = self.revealViewController;
        
        [swVc pushFrontViewController:navi animated:YES];

    }else {
        
        Theme *theme = self.themesArray[indexPath.row - 1];
        
        self.themeVc.theme = theme;
        SWRevealViewController *swVc = self.revealViewController;
        
        [swVc pushFrontViewController:self.navi animated:YES];
    }
    
}


- (ThemeTool *)tool{
    if (_tool == nil) {
        _tool = [[ThemeTool alloc]init];
        
    }
    return _tool;
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


- (NSMutableArray *)themesArray{
    if (_themesArray == nil) {
        _themesArray = [NSMutableArray array];
        
    }
    return _themesArray;
}
@end
