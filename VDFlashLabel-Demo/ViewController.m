//
//  ViewController.m
//  VDFlashLabel
//
//  Created by Harwyn T'an on 2017/3/9.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import "ViewController.h"
#import "VDFlashLabel.h"

@interface ViewController () <VDFlashLabelDelegate>

@property (nonatomic, weak) VDFlashLabel *flashLabel;
@property (nonatomic, weak) VDFlashLabel *flashLabel1;
@property (nonatomic, weak) VDFlashLabel *flashLabel2;
@property (nonatomic, weak) VDFlashLabel *flashLabel3;
@property (nonatomic, weak) VDFlashLabel *flashLabel4;

@end

@implementation ViewController

- (IBAction)rightBtnClick:(id)sender {
    NSArray *strArr = @[
                        @"1111普通文本普通文本普通文本普通文本普通文本普通文本",
                        @"2222普通文本普通文本普通文本普通文本普通文本普通文本普通文本普通文本普通文本",
                        @"3333普通文本普通文本普通文本"
                        ];
    self.flashLabel.stringArray = strArr;
    [self.flashLabel reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *strArr = @[
                        @"普通文本普通文本普通文本普通文本普通文本普通文本",
                        @"普通文本普通文本普通文本普通文本普通文本普通文本普通文本普通文本普通文本",
                        @"普通文本普通文本普通文本"
                        ];
    
    NSArray *attStrArr = @[
                           [[NSAttributedString alloc] initWithString:@"红色红色红色红色红色红色红色" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor redColor]}],
                           
                           [[NSAttributedString alloc] initWithString:@"黄色黄色黄色黄色黄色黄色黄色" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8], NSForegroundColorAttributeName:[UIColor yellowColor]}],
                           
                           [[NSAttributedString alloc] initWithString:@"蓝色蓝色" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor blueColor]}],
                           ];
    
    NSArray *mutiStrArr = @[
                            @"普通文本普通文本普通文本普通文本普通文本普通文本普通文本普通文本普通文本",
                            @"普通文本普通文本普通文本",
                            [[NSAttributedString alloc] initWithString:@"红色红色红色红色红色红色红色" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor redColor]}],
                            
                            [[NSAttributedString alloc] initWithString:@"黄色黄色黄色黄色黄色" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8], NSForegroundColorAttributeName:[UIColor yellowColor]}],
                            
                            @"普通文本",
                            [[NSAttributedString alloc] initWithString:@"蓝色" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor blueColor]}],
                            ];
    
    // 便利构造器创建普通字符串
    VDFlashLabel *flashLbl = [VDFlashLabel createFlashLabelWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40) hspace:10 stringArray:strArr];
    [self.view addSubview:flashLbl];
    self.flashLabel = flashLbl;
    
    // 便利构造器创建带样式字符串
    VDFlashLabel *flashLbl1 = [VDFlashLabel createFlashLabelWithFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, 40) hspace:10 stringArray:attStrArr];
    flashLbl1.autoScrollDirection = VDFlashLabelAutoScrollDirectionRight;
    [self.view addSubview:flashLbl1];
    self.flashLabel1 = flashLbl1;
    
    // 普通init方式初始化
    VDFlashLabel *flashLbl2 = [[VDFlashLabel alloc] init];
    flashLbl2.frame = CGRectMake(0, 144, [UIScreen mainScreen].bounds.size.width, 40);
    flashLbl2.hspace = 30;
    flashLbl2.stringArray = attStrArr;
    flashLbl2.backColor = [UIColor greenColor];
    [self.view addSubview:flashLbl2];
    self.flashLabel2 = flashLbl2;
    
    VDFlashLabel *flashLbl3 = [[VDFlashLabel alloc] initWithFrame:CGRectMake(0, 184, [UIScreen mainScreen].bounds.size.width, 40)];
    flashLbl3.stringArray = @[@"固定文字",@"固定文字固定文字固定文字固定文字固定文字",@"固定文字固定文字固定文字固定文字"];
    flashLbl3.hspace = 5;
    flashLbl3.userScroolEnabled = YES;
    [self.view addSubview:flashLbl3];
    self.flashLabel3 = flashLbl3;
    
    // 混合样式
    VDFlashLabel *flashLbl4 = [VDFlashLabel createFlashLabelWithFrame:CGRectMake(0, 224, [UIScreen mainScreen].bounds.size.width, 40) hspace:10 stringArray:mutiStrArr];
    flashLbl4.autoScroll = NO;
    flashLbl4.userScroolEnabled = YES;
    [self.view addSubview:flashLbl4];
    self.flashLabel4 = flashLbl4;
    
    self.flashLabel.delegate = self;
    self.flashLabel1.delegate = self;
    self.flashLabel2.delegate = self;
    self.flashLabel3.delegate = self;
    self.flashLabel4.delegate = self;
    // 开始滚动
    [self.flashLabel showAndStartTextContentScrollWithPt:1.0];
    [self.flashLabel1 showAndStartTextContentScrollWithPt:0.5];
    [self.flashLabel2 showAndStartTextContentScrollWithPt:1.5];
    [self.flashLabel3 showAndStartTextContentScroll];
    [self.flashLabel4 showAndStartTextContentScroll];
}

- (void)flashLabelDidTapView:(UIView *)view {
    NSLog(@"flashLabel Tap Action, View Index:%zd", view.tag);
}

- (void)dealloc {
    NSLog(@"ViewController dealloc");
    [self.flashLabel kill];
    [self.flashLabel1 kill];
    [self.flashLabel2 kill];
    [self.flashLabel3 kill];
    [self.flashLabel4 kill];
}


@end
