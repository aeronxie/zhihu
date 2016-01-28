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


static CGFloat const rowHeight = 93.0f;
static CGFloat const sectionHeight = 35.0f;

@interface PageViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UIButton *leftNaviButton;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *stories;
@property (nonatomic,strong) StoryModelTool *tool;
@property (nonatomic,strong) UIView *naviBar;
@property (nonatomic,strong) UILabel *titleLabel;



@end

@implementation PageViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self.view addSubview:self.tableView];
    [self setCycleScrollView];
    [self.view addSubview:self.naviBar];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.leftNaviButton];
    
    [self.tool loadNewStoriesWithData:^(id obj) {
        [self setTableViewData:obj];
    }];
    
    
}



-(void)setTableViewData:(id)data {
    self.stories = data;
    //SectionModel *sm = self.stories.firstObject;
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    
    
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
    SectionModel *todayStory = self.stories.firstObject;
    header.date = todayStory.date;
    
    return section?header:nil;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"hah";
    return cell;
    
}


#pragma mark - ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY <= 500) {
     
        _naviBar.alpha = offSetY / (kScreenHeight / 3);
     
    }else if (offSetY<=0 && offSetY >= -200) {
        _naviBar.alpha = 0;
        
    }
    
    //NSLog(@"%f",offSetY);

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
    _cycleScrollView.imageURLStringsGroup = @[@"http://img.taopic.com/uploads/allimg/130501/240451-13050106450911.jpg",@"http://www.diadany.com/img/aHR0cDovL3BpYzE2Lm5pcGljLmNvbS8yMDExMDkxOS84MzcxMjU2XzE5MTQyMDU5NDAwMF8yLmpwZw==.jpg",@"http://imgsrc.baidu.com/forum/pic/item/e4d2cf1349540923d1687ff29258d109b2de499f.jpg",@"http://pic37.nipic.com/20140209/8821914_163234218136_2.jpg"];
    [self.view addSubview:_cycleScrollView];
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

#pragma mark - getter and setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20)
                                                  style:UITableViewStylePlain];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        _tableView.rowHeight = rowHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

@end
