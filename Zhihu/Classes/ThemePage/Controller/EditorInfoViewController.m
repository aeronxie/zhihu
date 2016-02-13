//
//  EditorInfoViewController.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/13.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "EditorInfoViewController.h"
#import "EditorMoedel.h"
#import "UIImageView+WebCache.h"
#import "EditorInfoCell.h"

static NSString *const cellID = @"editorInfo";
@interface EditorInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UINavigationController *navi;
@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftNaviButton;
@end

@implementation EditorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBar];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.leftNaviButton];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)leftClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.editors.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EditorMoedel *editor = self.editors[indexPath.row];
    EditorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EditorInfoCell" owner:self options:nil]lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.editor = editor;
    }
    
    return cell;
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, 55, kScreenWidth, kScreenHeight-55);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

-(UIView *)naviBar {
    if (!_naviBar) {
        _naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
        _naviBar.backgroundColor = kColor(23, 144, 211);
        
    }
    return _naviBar;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.attributedText = [[NSAttributedString alloc]
                                      initWithString:@"主编"
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
        
        _leftNaviButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
        [_leftNaviButton addTarget:self
                            action:@selector(leftClick)
                  forControlEvents:UIControlEventTouchUpInside];
        [_leftNaviButton setImage:[UIImage imageNamed:@"News_Arrow"]
                         forState:UIControlStateNormal];
    }
    return _leftNaviButton;
}


@end
