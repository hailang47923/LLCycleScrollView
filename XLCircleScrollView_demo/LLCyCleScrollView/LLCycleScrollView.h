//
//  LLCycleScrollView.h
//  XLCircleScrollView_demo
//
//  Created by lxl on 16/3/3.
//  Copyright © 2016年 lxl. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,PageControlStyle){
    PageControlStyleLeft,
    PageControlStyleCenter,
    PageControlStyleRight,
};

@protocol  LLCycleScrollViewDelegate <NSObject>

- (void)clickImageAtIndex:(NSInteger)index;

@end

@interface LLCycleScrollView : UIView

/**
 *  自动滑动的时间间隔 时间不能小于0.3，会有卡顿bug
 */
@property (assign, nonatomic) NSTimeInterval autoTime;

@property (nonatomic, assign) PageControlStyle pageStyle;

@property (nonatomic, assign) id<LLCycleScrollViewDelegate>delegate;

- (instancetype)initWithUrlArray:(NSArray *)urlArray andFrame:(CGRect)frame autoScroll:(BOOL)autoScroll placeHolderImage:(UIImage *)placeHolderImage;

@end
