//
//  SideMenuViewController.m
//  Zhihu
//
//  Created by Fay on 15/12/10.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "SideMenuViewController.h"
#import "ItemsView.h"


#define kRowHeight 44
@interface SideMenuViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign,nonatomic) CGFloat startHeight;
@property (weak, nonatomic) IBOutlet UIButton *homePageBtn;
@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setScrollView];
   }

/**
 *  设置scrollView
 */
-(void)setScrollView {
    
        _startHeight = 47;
    for (int i = 0; i<15; i++) {
        ItemsView *itemsView = [[[NSBundle mainBundle]loadNibNamed:@"ItemsView" owner:self options:nil] lastObject];
        
        itemsView.frame = CGRectMake(0, _startHeight, _scrollView.width, kRowHeight);
        [_scrollView addSubview:itemsView];
        _startHeight += kRowHeight;
        [itemsView.contentButton addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchDown];
        [itemsView.contentButton setImage:[UIImage imageNamed:@"Dark_Action_Button"] forState:UIControlStateHighlighted];
        itemsView.contentButton.tag = i;
    }

    [_homePageBtn addTarget:self action:@selector(homePageClick) forControlEvents:UIControlEventTouchDown];
}

-(void)homePageClick {
    
    NSLog(@"点击了首页");
  
}
-(void)touch:(UIButton *)button {
    
    NSLog(@"点击了我了 %ld",(long)button.tag);
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.scrollView.contentSize = CGSizeMake(0, _startHeight);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
