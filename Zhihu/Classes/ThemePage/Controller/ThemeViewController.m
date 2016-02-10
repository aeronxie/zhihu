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
#import "DataSource.h"
#import "RefreshView.h"
#import "SWRevealViewController.h"
#import "StoriesModel.h"
#import "TableContentViewCell.h"
#import "ContainerController.h"
#import "Theme.h"
#import "ThemeNewsModel.h"
#import "UIImageView+WebCache.h"

static NSString *cellID = @"tableContentViewCell";
@interface ThemeViewController ()<UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TopImageView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) ThemeNewsModel *themeNews;

@property (nonatomic, strong) DataSource *tableViewDataSource;

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

- (void)dealloc{
    [self.tableView removeObserver:self.topView forKeyPath:@"contentOffset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableContentViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentLabel.textColor = [UIColor lightGrayColor];
    StoriesModel *storyModel = [self.tableViewDataSource itemAtIndexPath:indexPath];
    [self pushViewDetailViewControllerWithStoryModel:storyModel];
    
}

/**
 *  创建详细页面控制器
 */
- (void)pushViewDetailViewControllerWithStoryModel:(StoriesModel *)storyModel{
    ContainerController *container = [[ContainerController alloc] init];
    container.tool = self.tool;
    container.storyId = storyModel.ID;
    [self.navigationController pushViewController:container animated:YES];
}


//设置数据源
- (void)setUpDataSource{
    TableViewCellConfigureBlock configureCell = ^(TableContentViewCell *cell, StoriesModel * story) {
        story.multipic = NO;
        cell.storyModel = story;
    
    };
    self.tableViewDataSource = [[DataSource alloc]initWithItems:self.themeNews.stories
                                                 cellIdentifier:cellID
                                             configureCellBlock:configureCell];
    self.tableView.dataSource = self.tableViewDataSource;
    [self.tableView registerNib:[UINib nibWithNibName:@"TableContentViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:cellID];
}

//刷新数据
- (void)updateData{
    [self.tool getThemeNewsWithId:self.theme.id SuccessfulBlock:^(id obj) {
        self.themeNews = obj;
        [self.topView sd_setImageWithURL:[NSURL URLWithString:self.themeNews.image]];
        [self setUpDataSource];
        [self.refreshView stopAnimation];
    }];
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
        
        [self updateData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
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
        [_backBtn addTarget:revealController
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
    
    //[self updateData];
    
    
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