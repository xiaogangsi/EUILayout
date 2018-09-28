//
//  TestTEasyViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestTEasyViewController.h"
#import "TestTEasyViewController+View1.h"

@interface TestTEasyViewController () <EUILayouterDataSource>

@end

@implementation TestTEasyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _SETButton(1, @"视图1");
    _SETButton(2, @"视图2");
    _SETButton(3, @"视图3");
    _SETButton(4, @"视图4");
    _SETButton(5, @"视图5");
    _SETButton(6, @"视图6");
    
    [self.view eui_creatLayouterByDelegate:self];
    [self.view.eui_layouter update];
}

- (EUITemplet *)templetWithLayouter:(EUILayouter *)layouter {
    self.backBtn.eui_layout.margin = EUIEdgeMake(10, 30, 0, 0);
    self.backBtn.eui_layout.sizeType = EUILayoutSizeToFit;
    
//    self.view1.eui_layout.margin = EUIEdgeMake(10, 10, 10, 10);
    
    return TBase(self.backBtn);
}

- (void)action:(UIButton *)button {
    switch (button.tag) {
        case 1: [self setupView1]; break;
    }
    [self.view.eui_layouter update];
}

- (EUITemplet *)absoultBaseTemplet {
    return TBase(self.view1);
}


@end
