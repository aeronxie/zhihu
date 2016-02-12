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

static NSString *const cellID = @"editorCell";
@interface EditorInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UINavigationController *navi;
@end

@implementation EditorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = kColor(23, 144, 211);
    self.title = @"主编";
    
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return 44;
//    
//    
//}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.editors.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EditorMoedel *editor = self.editors[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.imageView.layer.cornerRadius = 10;
        cell.imageView.clipsToBounds = YES;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:editor.avatar] placeholderImage:[UIImage imageNamed:@"Account_Avatar"]];
        cell.textLabel.text = editor.name;
        cell.detailTextLabel.text = editor.bio;
        
    }
    
    return cell;
}



- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}




@end
