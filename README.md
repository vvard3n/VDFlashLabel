# VDFlashLabel
an auto scroll TextView



## init

```objective-c
VDFlashLabe *flashLbl = [VDFlashLabel createFlashLabelWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40) hspace:10 stringArray:strArr];
[self.view addSubview:flashLbl];
[self.flashLabel showAndStartTextContentScrollWithPt:1.0];
```

## dealloc

```
[flashLabel kill];
```

## property

```
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

