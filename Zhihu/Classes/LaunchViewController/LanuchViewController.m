//
//  LanuchViewController.m
//  Zhihu
//
//  Created by Fay on 15/12/9.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "LanuchViewController.h"
#import "JSAnimatedImagesView.h"
#import "AFNetworking.h"
#import <SDWebImageManager.h>
#import "GradientView.h"

static NSString *const launchImageKey = @"launchImageKey";
static NSString *const launchTextKey  = @"launchTextKey";
static NSString *const url = @"http://news-at.zhihu.com/api/4/start-image/1080*1776";

@interface LanuchViewController ()<JSAnimatedImagesViewDataSource>

@property (weak, nonatomic) IBOutlet JSAnimatedImagesView *animatedImagesView;
@property (weak, nonatomic) IBOutlet UILabel *text;


@end

@implementation LanuchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self saveTextAndImg];
    
    [self addLayerMasks];
    
}


#pragma mark - JSAnimatedImagesViewDataSource
- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView {
    
    return 2;
}

/**
 Implement this method to provide an image for `JSAnimatedImagesView` to display immediately after.
 @param animatedImagesView The view that is requesting the image object.
 @param index The index of the image to return. This is a value between `0` and `totalNumberOfImages - 1` (@see `animatedImagesNumberOfImages:`).
 */
- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index {
    
    //有下载好的图片直接使用
    if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:launchImageKey]!= nil) {
        
        return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:launchImageKey];
        
    }
    return [UIImage imageNamed:@"77fab92338869abdec50071982b75246"];
    
}

/**
 *  添加遮罩
 */
-(void)addLayerMasks {
    
    //添加半透明遮罩层
    UIView *blurView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    blurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.21];
    [_animatedImagesView addSubview:blurView];
    
    //渐变遮罩层
    GradientView *gradientView = [[GradientView alloc]initWithFrame:CGRectMake(0, self.view.height / 3 * 2, self.view.width, self.view.height / 3) type:TRANSPARENT_GRADIENT_TYPE];
    [_animatedImagesView addSubview:gradientView];
    
    //遮罩层渐变
    [UIView animateWithDuration:2.5f animations:^{
        //blurView.backgroundColor = [UIColor clearColor];
    }];
    
}

/**
 *  发送请求并保存text和img
 */
-(void)saveTextAndImg {
    
    //有下载好的文字则直接使用
    _text.text = [[NSUserDefaults standardUserDefaults] objectForKey:launchTextKey];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        //拿到最新的text并保存起来
        NSString *newText = responseObject[@"text"];
        _text.text = newText;
        [[NSUserDefaults standardUserDefaults] setObject:newText forKey:launchTextKey];
        
        //拿到图片url并保存起来
        NSString *newUrl = responseObject[@"img"];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:newUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //将图片保存至本地磁盘
            [[SDImageCache sharedImageCache] storeImage:image forKey:launchImageKey toDisk:YES];
            
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"下载失败");
        
    }];
    
    //设置自己为JSAnimatedImagesView的数据源
    _animatedImagesView.dataSource = self;

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
