//
//  VDFlashLabel.h
//  VDFlashLabel
//
//  Created by Harwyn T'an on 2017/3/9.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VDFlashLabel;

@protocol VDFlashLabelDelegate <NSObject>

@optional

/**
 控件即将刷新
 */
- (void)flashLabelWillRefreshData:(VDFlashLabel *)flashLabel;

/**
 控件已经刷新
 */
- (void)flashLabelDidRefreshData:(VDFlashLabel *)flashLabel;

/**
 点击文本
 */
- (void)flashLabelDidTapView:(UIView *)view;

@end

/**
 自动滚动方向

 - VDFlashLabelAutoScrollDirectionLeft: 元素向左滚动
 - VDFlashLabelAutoScrollDirectionright: 元素向右滚动
 */
typedef NS_OPTIONS(NSUInteger, VDFlashLabelAutoScrollDirection) {
    VDFlashLabelAutoScrollDirectionLeft = 1 << 0,
    VDFlashLabelAutoScrollDirectionRight = 1 << 1,
};

@interface VDFlashLabel : UIView

/**
 水平间距
 */
@property (nonatomic, assign) CGFloat hspace;


/**
 自动滚动
 */
@property (nonatomic, assign) BOOL autoScroll;

/**
 允许用户滚动
 */
@property (nonatomic, assign) BOOL userScroolEnabled;

/**
 背景色
 */
@property (nonatomic, strong) UIColor *backColor;

/**
 自动滚动方向
 */
@property (nonatomic, assign) VDFlashLabelAutoScrollDirection autoScrollDirection;

/**
 数据源
 */
@property (nonatomic, strong) NSArray *stringArray;
@property (nonatomic, weak) id<VDFlashLabelDelegate> delegate;


/**
 初始化方法

 @param hspace 元素间距
 @param arr 文本数组（支持NSString/NSAttributedString）
 */
- (instancetype)initWithFrame:(CGRect)frame hspace:(CGFloat)hspace stringArray:(NSArray *)arr;
+ (instancetype)createFlashLabelWithFrame:(CGRect)frame hspace:(CGFloat)hspace stringArray:(NSArray *)arr;


/**
 展示并自动滚动

 @param pt 每次滚动的点距默认0.5
 */
- (void)showAndStartTextContentScrollWithPt:(CGFloat)pt;
- (void)showAndStartTextContentScroll;

/**
 仅展示
 */
- (void)show;

/**
 停止自动滚动
 */
- (void)stopAutoScroll;

/**
 继续自动滚动
 */
- (void)continueAutoScroll;

/**
 重新加载
 */
- (void)reloadData;

/**
 自杀
 */
- (void)kill;

@end
