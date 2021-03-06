# VDFlashLabel
an auto scroll TextView

![](http://p1.bqimg.com/4851/05a3ba2b2ae70476.gif)

## init

```objective-c
VDFlashLabe *flashLbl = [VDFlashLabel createFlashLabelWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40) hspace:10 stringArray:strArr];
[self.view addSubview:flashLbl];
[self.flashLabel showAndStartTextContentScrollWithPt:1.0];
```

## dealloc

```objective-c
[flashLabel kill];
```

## Func

```objective-c
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
 重新设置数据源后可调用此方法刷新数据
 */
- (void)reloadData;
```



## Delegate

```objective-c
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
```



## property

```objective-c
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
 允许用户滚动，打开后自动关闭自动滚动
 */
@property (nonatomic, assign) BOOL userScroolEnabled;

/**
 背景色
 */
@property (nonatomic, strong) UIColor *backColor;

/**
 滚动方向
    VDFlashLabelScrollDirectionLeft,
    VDFlashLabelScrollDirectionRight,
    VDFlashLabelScrollDirectionTop,
    VDFlashLabelScrollDirectionDown,
 */
@property (nonatomic, assign) VDFlashLabelScrollDirection scrollDirection;

/**
 数据源
 */
@property (nonatomic, strong) NSArray *stringArray;
```

