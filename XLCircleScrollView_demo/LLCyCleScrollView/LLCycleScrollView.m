//
//  LLCycleScrollView.m
//  XLCircleScrollView_demo
//
//  Created by lxl on 16/3/3.
//  Copyright © 2016年 lxl. All rights reserved.
//

#define urlCount self.urlArray.count

#import "LLCycleScrollView.h"
#import "UIImageView+WebCache.h"

@interface LLCycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  url数组
 */
@property (nonatomic, strong) NSArray *urlArray;

/**
 *  是否允许自动滚动（默认自动滚动）
 */
@property (nonatomic, assign) BOOL autoScroll;

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImage *placeHolderImage; //占位图片
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LLCycleScrollView

- (instancetype)initWithUrlArray:(NSArray *)urlArray andFrame:(CGRect)frame autoScroll:(BOOL)autoScroll placeHolderImage:(UIImage *)placeHolderImage;
{
    self = [super init];
    if (self) {
        self.autoScroll = autoScroll;
        self.placeHolderImage = placeHolderImage;
        self.urlArray = urlArray;
        self.frame = frame;
        [self setScrollView];
        [self setPageControl];
        [self setImages];
        [self setUpAutoScroll];
    }
    return self;
}

- (void)setScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
    self.scrollView.scrollEnabled = (self.urlArray.count != 1);
    
    
    [self.scrollView setContentSize:CGSizeMake( (self.urlArray.count + 2) *self.frame.size.width, self.frame.size.height)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
}

- (void)setPageControl
{
    if (urlCount <= 1) return;
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
    [self addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.urlArray.count;
    self.pageControl.currentPage = 0;
    
    self.pageControl.defersCurrentPageDisplay = YES;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];

}
- (void)setPageStyle:(PageControlStyle)pageStyle
{
    if (self.urlArray.count <=1) return;

    switch (pageStyle) {
        case PageControlStyleLeft:
            self.pageControl.frame = CGRectMake(0, self.frame.size.height - 20, 20 * self.pageControl.numberOfPages, 20);
            break;
        case PageControlStyleCenter:
            
            self.pageControl.frame = CGRectMake( (self.frame.size.width - 20 * self.pageControl.numberOfPages) * 0.5, self.frame.size.height - 20, 20 * self.pageControl.numberOfPages, 20);
            break;
        case PageControlStyleRight:
            self.pageControl.frame = CGRectMake(self.frame.size.width - 20 * self.pageControl.numberOfPages, self.frame.size.height - 20, 20 * self.pageControl.numberOfPages, 20);
            break;
        default:
            break;
    }
}

- (void)setImages
{
    for (int i = 0; i < urlCount + 2; i++) {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1,self.frame.size.width + 2 , self.frame.size.height + 2)];

        if (i == 0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[urlCount - 1]] placeholderImage:self.placeHolderImage];
            
            imageView.tag = urlCount - 1;
        }else if (i == urlCount + 1)
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[0]]placeholderImage:self.placeHolderImage];
            imageView.tag = 0;
            
        }else
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[i - 1]] placeholderImage:self.placeHolderImage];
            imageView.tag = i - 1;
        }
        
        [scroll addSubview:imageView];
        [self.scrollView addSubview:scroll];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (void)setAutoTime:(NSTimeInterval)autoTime
{
    _autoTime = autoTime;
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self setUpAutoScroll];
}

/**
 *  自动轮播
 */
- (void)setUpAutoScroll
{
    if (self.autoScroll && urlCount > 1) {
        if (!_autoTime) {
            _autoTime = 2.0;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_autoTime target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)runTimePage
{
    NSInteger page = self.pageControl.currentPage;
    page++;
    [self turnPage:page];
}

- (void)turnPage:(NSInteger)page
{
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * (page + 1), 0) animated:YES];
}

//点击图片代理
- (void)imageClick:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickImageAtIndex:)]) {
        [self.delegate clickImageAtIndex:imageView.tag];
    }
}

#pragma mark - UITableViewDataSource
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger x = scrollView.contentOffset.x / self.frame.size.width;
    
    if (x == urlCount + 1 ) {
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
        [self.pageControl setCurrentPage:0];
    }else if (scrollView.contentOffset.x <= 0){
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width *urlCount, 0)];
        [self.pageControl setCurrentPage:urlCount - 1];
    }else{
        [self.pageControl setCurrentPage:x-1];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setUpAutoScroll];
}


//#pragma mark --- UIScrollView Delegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (_scrollView.contentOffset.x == 0) {
//        _centerImageIndex = _centerImageIndex - 1;
//        _leftImageIndex = _leftImageIndex - 1;
//        _rightImageIndex = _rightImageIndex - 1;
//        
//        if (_leftImageIndex == -1) _leftImageIndex = _imageURLArray.count - 1;
//        if (_centerImageIndex == -1) _centerImageIndex = _imageURLArray.count - 1;
//        if (_rightImageIndex == -1) _rightImageIndex = _imageURLArray.count - 1;
//        
//    } else if(_scrollView.contentOffset.x == CGRectGetWidth(_scrollView.frame) * 2) {
//        _centerImageIndex = _centerImageIndex + 1;
//        _leftImageIndex = _leftImageIndex + 1;
//        _rightImageIndex = _rightImageIndex + 1;
//        
//        if (_leftImageIndex == _imageURLArray.count) _leftImageIndex = 0;
//        if (_centerImageIndex == _imageURLArray.count) _centerImageIndex = 0;
//        if (_rightImageIndex == _imageURLArray.count) _rightImageIndex = 0;
//        
//    } else {
//        return;
//    }
//    
//    [_leftImageView yy_setImageWithURL:[NSURL URLWithString:_imageURLArray[_leftImageIndex]] placeholder:_placeHolderImage];
//    [_centerImageView yy_setImageWithURL:[NSURL URLWithString:_imageURLArray[_centerImageIndex]] placeholder:_placeHolderImage];
//    [_rightImageView yy_setImageWithURL:[NSURL URLWithString:_imageURLArray[_rightImageIndex]] placeholder:_placeHolderImage];
//    
//    _pageControl.currentPage = _centerImageIndex;
//    
//    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
//    
//    //手动控制图片滚动应该取消那个三秒的计时器
//    if (!_isTimeUp) {
//        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollTime]];
//    }
//    _isTimeUp = NO;
//}


//#pragma mark --- UIScrollView Delegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (_scrollView.contentOffset.x == 0) {
//        _centerImageIndex = _centerImageIndex - 1;
//        _leftImageIndex = _leftImageIndex - 1;
//        _rightImageIndex = _rightImageIndex - 1;
//        
//        if (_leftImageIndex == -1) _leftImageIndex = _imageURLArray.count - 1;
//        if (_centerImageIndex == -1) _centerImageIndex = _imageURLArray.count - 1;
//        if (_rightImageIndex == -1) _rightImageIndex = _imageURLArray.count - 1;
//        
//    } else if(_scrollView.contentOffset.x == CGRectGetWidth(_scrollView.frame) * 2) {
//        _centerImageIndex = _centerImageIndex + 1;
//        _leftImageIndex = _leftImageIndex + 1;
//        _rightImageIndex = _rightImageIndex + 1;
//        
//        if (_leftImageIndex == _imageURLArray.count) _leftImageIndex = 0;
//        if (_centerImageIndex == _imageURLArray.count) _centerImageIndex = 0;
//        if (_rightImageIndex == _imageURLArray.count) _rightImageIndex = 0;
//        
//    } else {
//        return;
//    }
//    
//    [_leftImageView yy_setImageWithURL:[NSURL URLWithString:_imageURLArray[_leftImageIndex]] placeholder:_placeHolderImage];
//    [_centerImageView yy_setImageWithURL:[NSURL URLWithString:_imageURLArray[_centerImageIndex]] placeholder:_placeHolderImage];
//    [_rightImageView yy_setImageWithURL:[NSURL URLWithString:_imageURLArray[_rightImageIndex]] placeholder:_placeHolderImage];
//    
//    _pageControl.currentPage = _centerImageIndex;
//    
//    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
//    
//    //手动控制图片滚动应该取消那个三秒的计时器
//    if (!_isTimeUp) {
//        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollTime]];
//    }
//    _isTimeUp = NO;
//}

@end
