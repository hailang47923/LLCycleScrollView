//
//  ViewController.m
//  XLCircleScrollView_demo
//
//  Created by lxl on 16/3/3.
//  Copyright © 2016年 lxl. All rights reserved.
//

#import "ViewController.h"
#import "LLCycleScrollView.h"

@interface ViewController ()<LLCycleScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     NSArray *urlArray = @[@"http://pic.58pic.com/58pic/16/38/57/02958PICizD_1024.jpg",@"http://pic38.nipic.com/20140225/12213820_113430471000_2.jpg",@"http://image.tianjimedia.com/uploadImages/2012/004/67U0IYRSH5GP.jpg",@"http://pic34.nipic.com/20131019/12213820_163423919000_2.jpg",@"http://image.tianjimedia.com/uploadImages/2015/013/24/K71I70KFJ9CK_1000x500.jpg",@"http://image.tianjimedia.com/uploadImages/2012/004/60WAXP6GG189.jpg"];

    LLCycleScrollView *scrollView = [[LLCycleScrollView alloc] initWithUrlArray:urlArray andFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) autoScroll:YES placeHolderImage:nil];
    scrollView.delegate = self;
    scrollView.autoTime = 1.5;
    scrollView.pageStyle = PageControlStyleCenter;
    [self.view addSubview:scrollView];
}

#pragma mark - LLCycleScrollViewDelegate
- (void)clickImageAtIndex:(NSInteger)index
{
    NSLog(@"index = %zd",index);
}

@end
