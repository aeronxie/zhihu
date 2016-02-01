//
//  MainViewController.m
//  Zhihu
//
//  Created by Fay on 15/12/9.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "ParallaxHeaderView.h"
#import "SDCycleScrollView.h"
#import "AppDelegate.h"
#import "LanuchViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "TopStoriesModel.h"
#import "MJExtension.h"
#import "StoriesModel.h"

#import "TableContentViewCell.h"
#import "TableSeparatorViewCell.h"
#import "UIImageView+WebCache.h"

static NSString *const contentCell = @"tableContentViewCell";
static NSString *const separatorCell = @"tableSeparatorViewCell";
static NSString *const url = @"http://news.at.zhihu.com/api/4/news/before/";

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,ParallaxHeaderViewDelegate>
@property (nonatomic,strong) ParallaxHeaderView *headerSubView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UIBarButtonItem *leftItem;
/**
 *  滚动视图图片
 */
@property (nonatomic,strong) NSMutableArray *top_images;
/**
 *  滚动视图标题
 */
@property (nonatomic,strong) NSMutableArray *top_titles;
/**
 *  文章图片
 */
@property (nonatomic,strong) NSMutableArray *stories_images;
/**
 *  过去数据
 */
@property (nonatomic,strong) NSMutableArray *aDayData;
/**
 *  当天数据(轮播数据)
 */
@property (nonatomic,strong) NSArray *top_stories;
/**
 *  当天正文数据
 */
@property (nonatomic,strong) NSArray *stories;
@property (nonatomic,strong) NSMutableArray *selectedIndex;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getTodayData];
    
    [self getPastData];
    
    [self setCycleScrollView];

    [self addrevealController];
    
    [self judgeFirst];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}



/**
 *  判断是不是第一次进入
 */
-(void)judgeFirst {
    
    //获取总代理
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.firstStart) {
        //如果是第一次启动
        UIView *launchView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, self.view.width, self.view.height)];
        launchView.alpha = 0.99;
        //得到第二启动页控制器并设置为子控制器
        LanuchViewController *launchViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"launchViewController"];
        [launchView addSubview:launchViewController.view];
        [self addChildViewController:launchViewController];
        [self.view addSubview:launchView];
        
        [UIView animateWithDuration:2.5f animations:^{
            launchView.alpha = 1;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                launchView.alpha = 0;
                [self.navigationItem setLeftBarButtonItem:_leftItem];
                self.title = @"今日热闻";
                
            } completion:^(BOOL finished) {
                [launchView removeFromSuperview];
                
            }];
            
        }];
        appDelegate.firstStart = NO;
    }else {
        [self.navigationItem setLeftBarButtonItem:_leftItem];
    }
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self setTableView];

}
//懒加载
-(NSMutableArray *)top_titles {
    if (!_top_titles) {
        _top_titles = [NSMutableArray array];
    }
    return _top_titles;
}

-(NSMutableArray *)top_images {
    if (!_top_images) {
        _top_images = [NSMutableArray array];
    }
    return _top_images;
}
-(NSMutableArray *)stories_images {
    if (!_stories_images) {
        _stories_images = [NSMutableArray array];
    }
    return _stories_images;
}
//
//-(NSArray *)top_stories {
//    if (!_top_stories) {
//        _top_stories = [NSArray array];
//    }
//    return _top_stories;
//}
//
//-(NSMutableArray *)aDayData {
//    if (!_aDayData) {
//        _aDayData = [NSMutableArray array];
//    }
//    return _aDayData;
//}
//-(NSArray *)stories {
//    if (!_stories) {
//        _stories = [NSArray array];
//    }
//    return _stories;
//    
//}
//-(NSMutableArray *)selectedIndex {
//    if (!_selectedIndex) {
//        _selectedIndex = [NSMutableArray array];
//    }
//    return _selectedIndex;
//}

/**
 *  tableView基本设置
 */
-(void)setTableView {
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/**
 *  添加图片轮播
 */
-(void)setCycleScrollView {

    _cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 154)];
    _cycleScrollView.autoScrollTimeInterval = 5.0;
    _cycleScrollView.delegate = self;
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    _cycleScrollView.titleLabelHeight = 85;
    
    _cycleScrollView.titleLabelTextFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:18];
    _cycleScrollView.showPageControl = YES;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;

    //将其添加到ParallaxView
    _headerSubView = [ParallaxHeaderView parallaxHeaderViewWithSubView:_cycleScrollView forSize:CGSizeMake(self.tableView.width, 154)];
    _headerSubView.delegate = self;
    self.tableView.tableHeaderView = _headerSubView;
}

/**
 *  添加侧栏
 */
-(void)addrevealController {
    
    SWRevealViewController *revealController = [self revealViewController];
    //开启手势
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    //添加左边按钮跟设置颜色
    _leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_menu_black_24dp"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    _leftItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

/**
 *  获取当天数据
 */
-(void)getTodayData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5.0;
    
    [manager GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //图片轮播数据
        self.top_stories = [TopStoriesModel mj_objectArrayWithKeyValuesArray:responseObject[@"top_stories"]];
        for (int i = 0; i<_top_stories.count; i++) {
            TopStoriesModel *topModel = _top_stories[i];
            NSString *title = topModel.title;
            NSString *image = topModel.image;
            [self.top_titles addObject:title];
            [self.top_images addObject:image];
            
        }
        //正文数据
        self.stories = [StoriesModel mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]];
        
        [self.tableView reloadData];
        
        _cycleScrollView.imageURLStringsGroup = @[self.top_images[0],self.top_images[1],self.top_images[2],self.top_images[3],self.top_images[4]];
        _cycleScrollView.titlesGroup = @[self.top_titles[0],self.top_titles[1],self.top_titles[2],self.top_titles[3],self.top_titles[4]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
        [SVProgressHUD showErrorWithStatus:@"加载失败..."];
    }];
    
   }
/**
 *  获取过去的数据
 */
-(void)getPastData {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 5.0f;
    //昨天数据的时间
    NSString *aDayBeforeString = [NSString getDateString:[NSDate date]];
    //前天数据时间
    NSString *twoDayBeforeString = [NSString getDateString:[NSDate dateWithTimeIntervalSinceNow:-(24 * 60 * 60)]];
    //三天前数据时间
    NSString *threeDayBeforeString = [NSString getDateString:[NSDate dateWithTimeIntervalSinceNow:-(2 * 24 * 60 * 60)]];
    
    NSString *aDayBeforeUrl = [NSString stringWithFormat:@"%@%@",url,aDayBeforeString];
    NSString *twoDayBeforeUrl = [NSString stringWithFormat:@"%@%@",url,twoDayBeforeString];
    NSString *threeDayBeforeUrl = [NSString stringWithFormat:@"%@%@",url,threeDayBeforeString];
    
    //昨天的数据
    [mgr GET:aDayBeforeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       self.aDayData = [StoriesModel mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]];
       [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
        [SVProgressHUD showErrorWithStatus:@"加载失败..."];

    }];
    
    //前天的数据
    [mgr GET:twoDayBeforeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.aDayData addObjectsFromArray:[StoriesModel mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]]];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
        [SVProgressHUD showErrorWithStatus:@"加载失败..."];
        
    }];
    
    //前天的数据
    [mgr GET:threeDayBeforeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.aDayData addObjectsFromArray:[StoriesModel mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]]];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
        [SVProgressHUD showErrorWithStatus:@"加载失败..."];
        
    }];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //设置状态栏颜色为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - ParallaxHeaderViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == 0) {
        self.navigationController.navigationBar.height = 44;
        //_titleLabel.alpha = 1;
        self.navigationItem.titleView.alpha = 1;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == 0) {
        self.navigationController.navigationBar.height = 20;
        self.navigationItem.titleView.alpha = 0;
        //_titleLabel.alpha = 0;
    }
}

- (void)lockDirection {
    //设置滑动极限修改该值需要一并更改layoutHeaderViewForScrollViewOffset中的对应值
    if (self.tableView.contentOffset.y <= -154) {
        self.tableView.contentOffset = CGPointMake(0, -154);
        
    }
   
}

#pragma mark - ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //Parallax效果
    [_headerSubView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
   
    
    UIColor *color = [UIColor colorWithRed:1/255.0 green:131/255.0 blue:209/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= -64) {
        CGFloat alpha = MIN(1, (64 + offsetY) / (64 + 90));
       
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        //[self.navigationController setNavigationBarHidden:NO animated:NO];
#warning - hidden navigationBar
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        //[self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"%ld",(long)index);
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[TableContentViewCell class]]) {
        NSNumber *rowNumber = [NSNumber numberWithInteger:indexPath.row];
        [self.selectedIndex addObject:rowNumber];
        TableContentViewCell *contentCell = [tableView cellForRowAtIndexPath:indexPath];
        //contentCell.contentLabel.textColor = [UIColor lightGrayColor];
    }
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stories.count + self.aDayData.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSInteger newIndenx = indexPath.row - self.stories.count;
//    if (indexPath.row < self.stories.count) {
//        TableContentViewCell *cell = (TableContentViewCell *)[tableView dequeueReusableCellWithIdentifier:contentCell];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"TableContentViewCell" owner:self options:nil] lastObject];
//        }
//        StoriesModel *stories = self.stories[indexPath.row];
//        [cell.contentImage sd_setImageWithURL:[NSURL URLWithString:stories.images[0]]];
//        cell.contentLabel.text = stories.title;
//        return cell;
//    }else {
//       
//        TableSeparatorViewCell *separaCell = (TableSeparatorViewCell *)[tableView dequeueReusableCellWithIdentifier:separatorCell];
//        if (!separatorCell) {
//            separaCell = [[[NSBundle mainBundle] loadNibNamed:@"TableSeparatorViewCell" owner:self options:nil] lastObject];
//        }
//        separaCell.dateLabel.text = [NSString getDetailDate:[NSDate date]];
//        return separaCell;
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"这里是第%ld行",indexPath.row];
    return cell;
  
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    background.backgroundColor = [UIColor colorWithRed:1/255.0 green:131/255.0 blue:209/255.0 alpha:1];
    
    UILabel *dateL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    dateL.textAlignment = NSTextAlignmentCenter;
    dateL.text = [NSString getDetailDate:[NSDate date]];
    dateL.textColor = [UIColor whiteColor];
    [background addSubview:dateL];
    
    return background;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 93;
}


@end
