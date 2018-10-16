//
//  BaseViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "BaseTestViewController.h"

@interface BaseTestViewController ()
@end

@implementation BaseTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:({
        @weakify(self);
        self.backBtn = EButton(@"返回", ^{
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:NULL];
        });
        [self.backBtn setFrame:(CGRect){0, 0, 100, 40}];
        [self backBtn];
    })];
}

@end
