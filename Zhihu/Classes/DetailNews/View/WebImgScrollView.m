//
//  WebImgScrollView.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/14.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "WebImgScrollView.h"
#import "SDWebImageManager.h"
#import "SVProgressHUD.h"

static CGFloat const animationDutation = 0.2f;

@interface WebImgScrollView  ()<UIScrollViewDelegate>

//图片的大小
@property (nonatomic, assign) CGSize imgSize;
//图片
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIScrollView *scrollView;
//和scrollview一般大的缩放用的
@property (nonatomic, strong) UIView *scaleView;
//下载按钮
@property (nonatomic, strong) UIButton *downLoadBtn;

@end

@implementation WebImgScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

+ (WebImgScrollView *)showImageWithStr:(NSString *)url{
    
    WebImgScrollView *imgSV = [[self alloc] initWithFrame:kScreenBounds];
    
    [[UIApplication sharedApplication].keyWindow addSubview:imgSV];

    imgSV.imgUrl = url;
    
    return imgSV;
}


#pragma mark - UIScrollView  delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scaleView;
}

#pragma mark - private method
- (void)initSubViews{
    
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.f;
    
    
    [self.scrollView addSubview:self.scaleView];
    [self.scaleView addSubview:self.imageView];
    [self addSubview:self.downLoadBtn];
    
    [UIView animateWithDuration:animationDutation animations:^{
        self.alpha = 0.8f;
    }];
    
}

//计算图片尺寸
- (void)calculateImageFrame:(UIImage *)image{
    
    self.imageView.image = image;
    
    float scaleX = self.scrollView.width / image.size.width;
    float scaleY = self.scrollView.height / image.size.height;
    
    if (scaleX > scaleY)
    {
        float imgViewWidth = image.size.width * scaleY;
        
        self.imageView.frame = CGRectMake((self.scrollView.width - imgViewWidth) * 0.5,0 ,imgViewWidth, self.scrollView.height);
    }else{
        float imgViewHeight = image.size.height * scaleX;
        
        self.imageView.frame = CGRectMake(0, (self.scrollView.height - imgViewHeight) * 0.5, self.scrollView.width, imgViewHeight);
    }
    
    self.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:animationDutation animations:^{
        self.imageView.transform = CGAffineTransformIdentity;
    }];
    
}

//下载图片
- (void)downLoadImg{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [SVProgressHUD showErrorWithStatus:@"无法读取相册"];
    }
    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
   
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [SVProgressHUD showSuccessWithStatus:@"已保存至相册"];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeView];
}

//移除透明View
- (void)removeView{
    [UIView animateWithDuration:animationDutation animations:^{
        self.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        self.alpha = 0.5;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.scrollView removeFromSuperview];
    }];
}


#pragma mark - setter and getter
- (void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.scrollView];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.image = image;
        [self calculateImageFrame:image];
    }];
    
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bouncesZoom = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 40);
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIView *)scaleView{
    if (_scaleView == nil) {
        _scaleView = [[UIView alloc] init];
        _scaleView.frame = _scrollView.frame;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
        [_scaleView addGestureRecognizer:tap];
        _scaleView.backgroundColor = [UIColor clearColor];
    }
    return _scaleView;
}

- (UIButton *)downLoadBtn{
    if (_downLoadBtn == nil) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downLoadBtn addTarget:self action:@selector(downLoadImg) forControlEvents:UIControlEventTouchUpInside];
        [_downLoadBtn setImage:[UIImage imageNamed:@"News_Picture_Save"] forState:UIControlStateNormal];
        _downLoadBtn.x = kScreenWidth - 50;
        _downLoadBtn.y = kScreenHeight - 40;
        [_downLoadBtn sizeToFit];
    }
    return _downLoadBtn;
}

@end
