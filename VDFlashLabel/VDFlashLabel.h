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
 滚动方向

 - VDFlashLabelScrollDirectionLeft: 元素向左滚动
 - VDFlashLabelScrollDirectionRight: 元素向右滚动
 - VDFlashLabelScrollDirectionTop: 元素向上滚动
 - VDFlashLabelScrollDirectionDown: 元素向下滚动
 */
typedef NS_OPTIONS(NSUInteger, VDFlashLabelScrollDirection) {
    VDFlashLabelScrollDirectionLeft = 1 << 0,
    VDFlashLabelScrollDirectionRight = 1 << 1,
    VDFlashLabelScrollDirectionTop = 1 << 2,
    VDFlashLabelScrollDirectionDown = 1 << 3,
};

/**
 自动滚动方式

 - VDFlashLabelAutoScrollModePoint: 按Pt滚动
 - VDFlashLabelAutoScrollModePaging: 按页滚动
 */
typedef NS_OPTIONS(NSUInteger, VDFlashLabelAutoScrollMode) {
    VDFlashLabelAutoScrollModePoint = 1 << 0,
    VDFlashLabelAutoScrollModePaging = 1 << 1,
};

@interface VDFlashLabel : UIView

/**
 水平间距
 */
@property (nonatomic, assign) CGFloat hspace;

/**
 行高
 */
@property (nonatomic, assign) CGFloat lineHeight;

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
 滚动方向
 */
@property (nonatomic, assign) VDFlashLabelScrollDirection scrollDirection;

///**
// 开启翻页模式，非像素滚动
// */
//@property (nonatomic, assign) BOOL pagingEnabled;
//
///**
// 自动翻页间隔时间，默认三秒
// */
//@property (nonatomic, assign) CGFloat autoPagingTime;

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
