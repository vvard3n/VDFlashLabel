# VDFlashLabel
an auto scroll TextView



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

```
/**
 点击文本
 */
- (void)flashLabelWillRefreshData:(VDFlashLabel *)flashLabel;

/**
 控件即将刷新
 */
- (void)flashLabelWillTapView:(UIView *)view;

/**
 控件已经刷新
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
```

