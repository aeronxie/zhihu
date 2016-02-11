//
//  ThemeViewController.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/10.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "ThemeViewController.h"
#import "TopImageView.h"
#import "ThemeNewsTool.h"
#import "ThemeData.h"
#import "RefreshView.h"
#import "SWRevealViewController.h"
#import "StoriesModel.h"
#import "ThemeCell.h"
#import "ContainerController.h"
#import "Theme.h"
#import "ThemeNewsModel.h"
#import "UIImageView+WebCache.h"

static NSString *cellID = @"ThemeCell";

@interface ThemeViewController ()<UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TopImageView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) ThemeNewsModel *themeNews;
@property (nonatomic, strong) ThemeData *tableViewDataSource;
@property (nonatomic, strong) ThemeNewsTool *tool;
@property (nonatomic, assign, getter = isRefreshing) BOOL refreshing;

@end

@implementation ThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.refreshView];
    
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentLabel.textColor = [UIColor lightGrayColor];
    StoriesModel *storyModel = [self.tableViewDataSource itemAtIndexPath:indexPath];
    [self pushViewDetailViewControllerWithStoryModel:storyModel];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 40.f;
    }else {
        return 93.f;
    }
}

/**
 *  创建详细页面控制器
 */
- (void)pushViewDetailViewControllerWithStoryModel:(StoriesModel *)storyModel{
    ContainerController *container = [[ContainerController alloc] init];
    container.tool = self.tool;
    container.storyId = storyModel.id;
    [self.navigationController pushViewController:container animated:YES];
}


//设置数据源
- (void)setUpDataSource{
    ThemeCellConfigureBlock configureCell = ^(ThemeCell *cell, StoriesModel * story) {
        story.multipic = NO;
        cell.storyModel = story; 
    
    };
//    self.tableViewDataSource = [[ThemeData alloc]initWithItems:self.themeNews.stories
//                                                 cellIdentifier:cellID
//                                             configureCellBlock:configureCell];
    
    self.tableViewDataSource = [[ThemeData alloc]initWithItems:self.themeNews.stories editors:self.themeNews.editors cellIdentifier:cellID configureCellBlock:configureCell];
    self.tableView.dataSource = self.tableViewDataSource;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ThemeCell"
                                               bundle:nil]
         forCellReuseIdentifier:cellID];
    [self.tableView reloadData];
  
}

//刷新数据
- (void)updateData{
    [self.tool getThemeNewsWithId:self.theme.ID SuccessfulBlock:^(id obj) {
        self.themeNews = obj;
        [self.topView sd_setImageWithURL:[NSURL URLWithString:self.themeNews.image]];
        [self setUpDataSource];
        [self.refreshView stopAnimation];
    }];
}

//改变状态栏
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)dealloc{
    NSLog(@"ThemeViewController  Dealloc");
    [self.tableView removeObserver:self.topView forKeyPath:@"contentOffset"];
}

#pragma mark - ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offSetY = scrollView.contentOffset.y;
    if (-offSetY <= 60) {
        if (!self.isRefreshing) {
            [_refreshView drawFromProgress:-offSetY/60];
        }else {
            [_refreshView drawFromProgress:0];
        }
        
    }
    if (-offSetY > 60&&-offSetY<90&&!scrollView.isDragging) {
        [_refreshView startAnimation];
        self.refreshing = YES;
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateData];
            [_refreshView stopAnimation];
            self.refreshing = NO;
        });
    }
  
    
}


#pragma mark - getter and setter

- (TopImageView *)topView{
    
    if (_topView == nil) {
        _topView = [TopImageView addToTableView:self.tableView];
        _topView.backgroundColor = kColor(23, 144, 211);
    }
    return _topView;
    
}

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, kScreenWidth, kScreenHeight - 55)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.centerY = 25;
    }
    return _titleLabel;
}

- (UIButton *)backBtn{
    if (_backBtn == nil) {
        
        SWRevealViewController *revealController = [self revealViewController];
        //开启手势
        [revealController panGestureRecognizer];
        [revealController tapGestureRecognizer];
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 25, 25)];
        [_backBtn addTarget:self.revealViewController
                     action:@selector(revealToggle:)
           forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:@"News_Arrow"]
                  forState:UIControlStateNormal];
        
    }
    return _backBtn;
}

- (void)setTheme:(Theme *)theme{
    _theme = theme;
    
    self.tableView.contentOffset = CGPointMake(0, 0);
    
    self.titleLabel.attributedText = [[NSAttributedString alloc]
                                      initWithString:self.theme.name
                                      attributes:@{NSFontAttributeName:
                                                       [UIFont systemFontOfSize:18] ,
                                                   NSForegroundColorAttributeName:
                                                       [UIColor whiteColor]}];
    [self.titleLabel sizeToFit];
    _titleLabel.centerX = self.view.centerX;
    self.refreshView.x = self.titleLabel.x - 30;
    
    [self updateData];
    
    
}

-(RefreshView *)refreshView {
    
    if (!_refreshView) {
        _refreshView = [[RefreshView alloc]initWithFrame:CGRectMake(self.titleLabel.x - 30, 25, 20, 20)];
        
    }
    
    return _refreshView;
}


- (ThemeNewsTool *)tool{
    if (_tool == nil) {
        _tool = [[ThemeNewsTool alloc] init];
    }
    return _tool;
}



@end
