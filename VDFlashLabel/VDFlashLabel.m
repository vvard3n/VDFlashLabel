//
//  VDFlashLabel.m
//  VDFlashLabel
//
//  Created by Harwyn T'an on 2017/3/9.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import "VDFlashLabel.h"
#import "UIView+VDFrame.h"
#import "NSTimer+VDAdd.h"
#import "Masonry.h"

@interface VDFlashLabel () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray <UILabel *>*lblArr;

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIScrollView *shufflingInfoScrollView;
@property (nonatomic, weak) UIView *topInfoLine;

@property (nonatomic, assign) CGFloat scrollX;
@property (nonatomic, assign) CGFloat scrollY;
@property (nonatomic, assign) CGFloat everyScrollPt;
@property (nonatomic, assign) CGFloat trueWidth;
@property (nonatomic, assign) CGFloat trueHeight;

@property (nonatomic, strong) NSTimer *autoRefreshTimer;
@property (nonatomic, strong) CADisplayLink *autoScrollDisplayLink;


@end

@implementation VDFlashLabel

#pragma mark - Set
- (void)setUserScroolEnabled:(BOOL)userScroolEnabled {
    _userScroolEnabled = userScroolEnabled;
    _autoScroll = !userScroolEnabled;
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    _userScroolEnabled = !autoScroll;
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero hspace:0 stringArray:@[]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame hspace:0 stringArray:@[]];
}

- (instancetype)initWithFrame:(CGRect)frame hspace:(CGFloat)hspace stringArray:(NSArray *)arr {
    if (self = [super initWithFrame:frame]) {
        self.hspace = hspace;
        self.stringArray = arr;
        self.scrollX = 0.0;
        self.autoScroll = YES;
        self.scrollDirection = VDFlashLabelScrollDirectionLeft;
        self.everyScrollPt = 0.5;
//        self.pagingEnabled = NO;
//        self.autoPagingTime = 3.0;
        self.lineHeight = 40.0;
    }
    return self;
}

+ (instancetype)createFlashLabelWithFrame:(CGRect)frame hspace:(CGFloat)hspace stringArray:(NSArray *)arr {
    return [[self alloc] initWithFrame:frame hspace:(CGFloat)hspace stringArray:arr];
}

#pragma mark - UI
- (void)createShufflingInfoView {
    
    UIView *containerView = [[UIView alloc] init];
    self.containerView = containerView;
    [self addSubview:containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *shufflingInfoScrollView = [[UIScrollView alloc] init];
    self.shufflingInfoScrollView = shufflingInfoScrollView;
    [containerView addSubview:shufflingInfoScrollView];
    shufflingInfoScrollView.delegate = self;
    shufflingInfoScrollView.showsVerticalScrollIndicator = NO;
    shufflingInfoScrollView.showsHorizontalScrollIndicator = NO;
    shufflingInfoScrollView.scrollEnabled = self.userScroolEnabled;
    if (self.backColor) {
        shufflingInfoScrollView.backgroundColor = self.backColor;
    }
    
    UIView *topInfoLine = [[UIView alloc] init];
    self.topInfoLine = topInfoLine;
    topInfoLine.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    [containerView addSubview:topInfoLine];
    
    [self makeContentViewConstraints];
}

- (void)makeContentViewConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.shufflingInfoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.containerView);
    }];
    [self.topInfoLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
        make.height.offset(0.5);
    }];
}

#pragma mark - Data
- (void)showData:(NSArray *)dataArr {
    if (!self.containerView) {
        [self createShufflingInfoView];
    }
    if (dataArr && dataArr.count > 0) {
        
        self.lblArr = [NSMutableArray arrayWithCapacity:self.stringArray.count];
        for (NSInteger i = 0; i < self.stringArray.count * 3; i++) {
            UILabel *lbl = [[UILabel alloc] init];
            lbl.tag = i % self.stringArray.count;
            lbl.font = [UIFont systemFontOfSize:14];
            lbl.userInteractionEnabled = YES;
            [lbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)]];
            [self.shufflingInfoScrollView addSubview:lbl];
            [self.lblArr addObject:lbl];
        }
        
        __block CGFloat contentSizeWidth = 0.0;
        __block CGFloat contentSizeHeight = 0.0;
        [dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                self.lblArr[idx].text = obj;
            }
            else if ([obj isKindOfClass:[NSAttributedString class]]) {
                self.lblArr[idx].attributedText = obj;
            }
            else {
                NSLog(@"No support data：%@", obj);
            }
            [self.lblArr[idx] sizeToFit];
            self.lblArr[idx].height = self.lineHeight;
            if (self.scrollDirection & VDFlashLabelScrollDirectionTop || self.scrollDirection & VDFlashLabelScrollDirectionDown) {
                if (idx == 0) {
                    self.lblArr[idx].y = 0;
                }
                else {
                    self.lblArr[idx].y = self.lblArr[idx - 1].y + self.lblArr[idx - 1].height;
                }
                contentSizeHeight += self.lblArr[idx].height;
            }
            else if (self.scrollDirection & VDFlashLabelScrollDirectionLeft || self.scrollDirection & VDFlashLabelScrollDirectionRight) {
                if (idx == 0) {
                    self.lblArr[idx].x = self.hspace;
                }
                else {
                    self.lblArr[idx].x = self.hspace + self.lblArr[idx - 1].x + self.lblArr[idx - 1].width;
                }
                contentSizeWidth += self.hspace + self.lblArr[idx].width;
            }
        }];
        
        self.trueWidth = contentSizeWidth;
        self.trueHeight = contentSizeHeight;
        
        [dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            idx += self.stringArray.count;
            if ([obj isKindOfClass:[NSString class]]) {
                self.lblArr[idx].text = obj;
            }
            else if ([obj isKindOfClass:[NSAttributedString class]]) {
                self.lblArr[idx].attributedText = obj;
            }
            else {
                NSLog(@"No support data：%@", obj);
            }
            [self.lblArr[idx] sizeToFit];
            self.lblArr[idx].height = self.lineHeight;
            if (self.scrollDirection & VDFlashLabelScrollDirectionTop || self.scrollDirection & VDFlashLabelScrollDirectionDown) {
                if (idx == 0) {
                    self.lblArr[idx].y = 0;
                }
                else {
                    self.lblArr[idx].y = self.lblArr[idx - 1].y + self.lblArr[idx - 1].height;
                }
                contentSizeHeight += self.lblArr[idx].height;
            }
            else if ((self.scrollDirection & VDFlashLabelScrollDirectionLeft) || (self.scrollDirection & VDFlashLabelScrollDirectionRight)) {
                if (idx == 0) {
                    self.lblArr[idx].x = self.hspace;
                }
                else {
                    self.lblArr[idx].x = self.hspace + self.lblArr[idx - 1].x + self.lblArr[idx - 1].width;
                }
                contentSizeWidth += self.hspace + self.lblArr[idx].width;
            }
        }];
        [dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            idx += self.stringArray.count * 2;
            if ([obj isKindOfClass:[NSString class]]) {
                self.lblArr[idx].text = obj;
            }
            else if ([obj isKindOfClass:[NSAttributedString class]]) {
                self.lblArr[idx].attributedText = obj;
            }
            else {
                NSLog(@"No support data：%@", obj);
            }
            [self.lblArr[idx] sizeToFit];
            self.lblArr[idx].height = self.lineHeight;
            if ((self.scrollDirection & VDFlashLabelScrollDirectionTop) || (self.scrollDirection & VDFlashLabelScrollDirectionDown)) {
                if (idx == 0) {
                    self.lblArr[idx].y = 0;
                }
                else {
                    self.lblArr[idx].y = self.lblArr[idx - 1].y + self.lblArr[idx - 1].height;
                }
                contentSizeHeight += self.lblArr[idx].height;
            }
            else if (self.scrollDirection & VDFlashLabelScrollDirectionLeft || self.scrollDirection & VDFlashLabelScrollDirectionRight) {
                if (idx == 0) {
                    self.lblArr[idx].x = self.hspace;
                }
                else {
                    self.lblArr[idx].x = self.hspace + self.lblArr[idx - 1].x + self.lblArr[idx - 1].width;
                }
                contentSizeWidth += self.hspace + self.lblArr[idx].width;
            }
        }];
        
        self.shufflingInfoScrollView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
        self.shufflingInfoScrollView.contentOffset = CGPointMake(self.trueWidth, self.trueHeight);
    }
}

#pragma mark - Show
- (void)show {
    [self showData:self.stringArray];
}

- (void)showAndStartTextContentScroll {
    [self showData:self.stringArray];
    [self startAutoScroll];
}

- (void)showAndStartTextContentScrollWithPt:(CGFloat)pt {
    [self showData:self.stringArray];
    self.everyScrollPt = pt;
    [self startAutoScroll];
}

- (void)startAutoScroll {
    if (self.autoScroll && !self.autoScrollDisplayLink && self.lblArr.count != 0) {
//        if (self.shufflingInfoScrollView.contentSize.width >= self.bounds.size.width) {
//            <#statements#>
//        }
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeContentOffset)];
        self.autoScrollDisplayLink = displayLink;
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
    }
}

//- (void)startAutoRefreshStock {
//    if (!self.autoRefreshTimer) {
//        NSTimer *autoRefreshTimer = [NSTimer timerWithTimeInterval:30 block:^(NSTimer * _Nonnull timer) {
//            
//        } repeats:YES];
//        self.autoRefreshTimer = autoRefreshTimer;
//        [[NSRunLoop mainRunLoop] addTimer:autoRefreshTimer forMode:NSRunLoopCommonModes];
//    }
//}

- (void)stopAutoScroll {
    [self.autoScrollDisplayLink invalidate];
    self.autoScrollDisplayLink = nil;
}

- (void)continueAutoScroll {
    if (!self.autoScrollDisplayLink && self.lblArr.count != 0) {
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeContentOffset)];
        self.autoScrollDisplayLink = displayLink;
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)reloadData {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(flashLabelWillRefreshData:)]) {
            [self.delegate flashLabelWillRefreshData:self];
        }
    }
    
    [self.lblArr enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.lblArr removeAllObjects];
    [self showData:self.stringArray];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(flashLabelDidRefreshData:)]) {
            [self.delegate flashLabelDidRefreshData:self];
        }
    }
}

- (void)changeContentOffset {
    if (self.shufflingInfoScrollView) {
        if (self.scrollDirection & VDFlashLabelScrollDirectionLeft) {
            self.scrollX += self.everyScrollPt;
        }
        else if (self.scrollDirection & VDFlashLabelScrollDirectionRight) {
            self.scrollX -= self.everyScrollPt;
        }
        else if (self.scrollDirection & VDFlashLabelScrollDirectionTop) {
            self.scrollY += self.everyScrollPt;
        }
        else if (self.scrollDirection & VDFlashLabelScrollDirectionDown) {
            self.scrollY -= self.everyScrollPt;
        }
        self.shufflingInfoScrollView.contentOffset = CGPointMake(self.scrollX, self.scrollY);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.lblArr.count == 0) return;
    if (self.scrollDirection & VDFlashLabelScrollDirectionLeft || self.scrollDirection & VDFlashLabelScrollDirectionRight) {
        if (scrollView.contentOffset.x > self.lblArr[self.stringArray.count * 2 - 1].x + self.lblArr[self.stringArray.count - 1].width) {
            scrollView.contentOffset = CGPointMake(self.trueWidth, 0);
            self.scrollX = self.trueWidth;
        }
        else if (scrollView.contentOffset.x <= 0) {
            scrollView.contentOffset = CGPointMake(self.trueWidth, 0);
            self.scrollX = self.trueWidth;
        }
    }
    else if (self.scrollDirection & VDFlashLabelScrollDirectionTop || self.scrollDirection & VDFlashLabelScrollDirectionDown) {
        if (scrollView.contentOffset.y > self.lblArr[self.stringArray.count * 2 - 1].y + self.lblArr[self.stringArray.count - 1].height) {
            scrollView.contentOffset = CGPointMake(0, self.trueHeight);
            self.scrollY = self.trueHeight;
        }
        else if (scrollView.contentOffset.y <= 0) {
            scrollView.contentOffset = CGPointMake(0, self.trueHeight);
            self.scrollY = self.trueHeight;
        }
    }
}

- (void)tapContentView:(UITapGestureRecognizer *)tapAction {
    UIView *actionView = tapAction.view;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(flashLabelDidTapView:)]){
            [self.delegate flashLabelDidTapView:actionView];
        }
    }
}

- (void)kill {
    [self.autoRefreshTimer invalidate];
    [self.autoScrollDisplayLink invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [self.autoRefreshTimer invalidate];
    [self.autoScrollDisplayLink invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"VDFlashLabel dealloc");
}

@end
