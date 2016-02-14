//
//  PageViewController.m
//  Zhihu
//
//  Created by Fay on 16/1/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "PageViewController.h"
#import "SDCycleScrollView.h"
#import "SWRevealViewController.h"
#import "StoryModelTool.h"
#import "HeaderView.h"
#import "SectionModel.h"
#import "TableContentViewCell.h"
#import "MJEXtension.h"
#import "DataSource.h"
#import "TableContentViewCell.h"
#import "RefreshView.h"
#import "ContainerController.h"
#import "LanuchViewController.h"
#import "AppDelegate.h"


static CGFloat const rowHeight = 93.0f;
static CGFloat const sectionHeight = 35.0f;
static NSString *cellID = @"tableContentViewCell";

@interface PageViewController ()<UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) RefreshView *refreshView;
@property (nonatomic,strong) StoryModelTool *tool;
@property (nonatomic,strong) StoriesModel *storiesModel;
@property (nonatomic,strong) DataSource *newsArrayDataSource;
@property (nonatomic,strong) UIButton *leftNaviButton;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *stories;
@property (nonatomic,strong) NSArray *top_stories;
@property (nonatomic,strong) NSMutableArray *topPictures;
@property (nonatomic,strong) NSMutableArray *topTitles;
@property (nonatomic,strong) UIView *naviBar;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) NSMutableArray *topIds;

@property (nonatomic, assign, getter = isRefreshing) BOOL refreshing;



@end

@implementation PageViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置滚动条
    [self setCycleScrollView];



    [self.tool loadNewStoriesWithData:^(id obj) {

        [self setTableViewData:obj];
    
        [self.view addSubview:self.tableView];
        [self.view addSubview:_cycleScrollView];
        [self.view addSubview:self.naviBar];
        [self.view addSubview:self.titleLabel];
        [self.view addSubview:self.leftNaviButton];
        [self.view addSubview:self.refreshView];
        [self judgeFirst];
    }];
       
}

//判断是不是第一次进入
-(void)judgeFirst {

    //获取总代理
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.firstStart) {
        //如果是第一次启动
        UIView *launchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        launchView.alpha = 0.99;
        //得到第二启动页控制器并设置为子控制器
        LanuchViewController *launchViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"launchViewController"];
        [launchView addSubview:launchViewController.view];
        [self addChildViewController:launchViewController];
        [self.view addSubview:launchView];
        
        [UIView animateWithDuration:2.7f animations:^{
            launchView.alpha = 1;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                launchView.alpha = 0;
  
            } completion:^(BOOL finished) {
                [launchView removeFromSuperview];
            }];
        }];
        appDelegate.firstStart = NO;
    }else {
        
    }
    
}

//加载数据
-(void)setTableViewData:(id)data {
    self.stories = data;
    SectionModel *sm = self.stories.firstObject;
    [self setUpDataSource];
    self.top_stories = sm.top_stories;
    
    [self setToppictures];
    
}

//获取顶部图片和文字并设置
-(void)setToppictures {
    
    self.topPictures = [NSMutableArray array];
    self.topTitles = [NSMutableArray array];
    self.topIds = [NSMutableArray array];
    
    for (int i = 0; i < self.top_stories.count; i++) {
        
        TopStoriesModel *tsm = self.top_stories[i];
        [self.topTitles addObject:tsm.title];
        [self.topPictures addObject:tsm.image];
        [self.topIds addObject:tsm.id];
    }
    _cycleScrollView.imageURLStringsGroup = @[self.topPictures[0],self.topPictures[1],self.topPictures[2],self.topPictures[3],self.topPictures[4]];
    _cycleScrollView.titlesGroup = @[self.topTitles[0],self.topTitles[1],self.topTitles[2],self.topTitles[3],self.topTitles[4]];
}




#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    [self pushViewDetailViewControllerWithStoryID:index];
    
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableContentViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentLabel.textColor = [UIColor lightGrayColor];
    StoriesModel *storyModel = [self.newsArrayDataSource itemAtIndexPath:indexPath];
    [self pushViewDetailViewControllerWithStoryModel:storyModel];
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == 0) {
        _naviBar.height = 55;
        _titleLabel.alpha = 1;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == 0) {
        _naviBar.height = 20;
        _titleLabel.alpha = 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    
    return section?sectionHeight:CGFLOAT_MIN;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HeaderView *header = [HeaderView homeHeaderViewWithTableView:tableView];
    SectionModel *todayStory = self.stories[section];
    header.date = todayStory.date;
    
    return section?header:nil;
}

/**
 *  创建详细页面控制器
 *
 *  @param storyModel 数据
 */
- (void)pushViewDetailViewControllerWithStoryModel:(StoriesModel *)storyModel{
    ContainerController *container = [[ContainerController alloc] init];
    container.tool = self.tool;
    container.storyId = storyModel.id;
    [self.navigationController pushViewController:container animated:YES];
}

/**
 *  创建顶部滚动条详细控制器
 *
 *  @param index 点了是哪个
 */
-(void)pushViewDetailViewControllerWithStoryID:(NSInteger)index {
    ContainerController *container = [[ContainerController alloc] init];
    container.storyId = self.topIds[index];
    [self.navigationController pushViewController:container animated:YES];

}

//下拉刷新第一组
-(void)updateData{

    [self.tool refreshStoriesWithData:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        SectionModel *sm = self.stories.firstObject;
        self.top_stories = sm.top_stories;
        [self setToppictures];
    }];
}


//设置数据源
- (void)setUpDataSource{
    TableViewCellConfigureBlock configureCell = ^(TableContentViewCell *cell, StoriesModel * story) {
        cell.storyModel = story;        
    };
    self.newsArrayDataSource = [[DataSource alloc]initWithItems:self.stories
                                                      cellIdentifier:cellID
                                                  configureCellBlock:configureCell];
    self.tableView.dataSource = self.newsArrayDataSource;
    [self.tableView registerNib:[UINib nibWithNibName:@"TableContentViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:cellID];
}


#pragma mark - ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offSetY = scrollView.contentOffset.y;
    //上拉刷新
    if (offSetY > scrollView.contentSize.height - 1.5 * kScreenHeight) {
        [self.tool loadFormerStoriesWithData:^{
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.stories.count - 1] withRowAnimation:UITableViewRowAnimationFade];
            
        }];
    }
    
    if (offSetY<=0&&offSetY>=-90)  {
        _naviBar.alpha = 0;
        //加载菊花
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
    else if(offSetY <= 500) {
        _naviBar.alpha = offSetY/(kScreenHeight / 3);
        
    }
}
/**
 *  设置轮播图片
 */
-(void)setCycleScrollView {
    _cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, -45, self.view.width, 265)];
    _cycleScrollView.autoScrollTimeInterval = 5.0;
    _cycleScrollView.delegate = self;
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    _cycleScrollView.titleLabelHeight = 85;
    _cycleScrollView.titleLabelTextFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:18];
    _cycleScrollView.showPageControl = YES;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
}

//KVO 监听滑动
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
   
    if ([keyPath isEqualToString:@"contentOffset"]) {
        UIScrollView *scrollView = object;
        CGFloat offSetY = scrollView.contentOffset.y;
        if (offSetY<=0&&offSetY>=-90) {
            self.cycleScrollView.frame = CGRectMake(0, -45 - 0.5 * offSetY, kScreenWidth, 265 - 0.5 * offSetY);
        }else if(offSetY<-90){
            self.tableView.contentOffset = CGPointMake(0, -90);
        }else if(offSetY <= 500) {
            self.cycleScrollView.y = -45 - offSetY;
        }

    }
    
}

//改变状态栏为白色
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - getter and setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20)
                                                  style:UITableViewStylePlain];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = rowHeight;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    }
    return _tableView;
}



-(UIView *)naviBar {
    if (!_naviBar) {
        _naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
        _naviBar.backgroundColor = kColor(23, 144, 211);
        _naviBar.alpha = 0;

    }
    return _naviBar;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.attributedText = [[NSAttributedString alloc]
                                      initWithString:@"今日热闻"
                                      attributes:@{NSFontAttributeName:
                                                       [UIFont
                                                        systemFontOfSize:18],NSForegroundColorAttributeName:
                                                                                                    [UIColor whiteColor]}];
        [_titleLabel sizeToFit];
        _titleLabel.centerX = self.view.centerX;
        _titleLabel.centerY = 35;
    }
    return _titleLabel;
  
}

- (UIButton *)leftNaviButton{
    if (_leftNaviButton == nil) {
        SWRevealViewController *revealController = [self revealViewController];
        //开启手势
        [revealController panGestureRecognizer];
        [revealController tapGestureRecognizer];
        _leftNaviButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
        [_leftNaviButton addTarget:revealController
                            action:@selector(revealToggle:)
                  forControlEvents:UIControlEventTouchUpInside];
        [_leftNaviButton setImage:[UIImage imageNamed:@"Home_Icon"]
                         forState:UIControlStateNormal];
    }
    return _leftNaviButton;
}

-(RefreshView *)refreshView {
    
    if (!_refreshView) {
        _refreshView = [[RefreshView alloc]initWithFrame:CGRectMake(self.titleLabel.x - 30, 25, 20, 20)];
       
    }
   
    return _refreshView;
}

-(StoryModelTool *)tool {
    if (!_tool) {
        _tool = [[StoryModelTool alloc]init];
    }
    return _tool;
}

-(NSMutableArray *)stories {
    if (!_stories) {
        _stories = [NSMutableArray array];
    }
    return _stories;
}

-(NSArray *)top_stories {
    if (!_top_stories) {
        _top_stories = [NSArray array];
    }
    return _top_stories;
}

#warning 不销毁的话会报错（key value observers were still registered with it）
-(void)dealloc {
    
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
