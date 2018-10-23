//
//  EUITBaseIntroViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/22.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITBaseIntroViewController.h"

@interface EUITBaseIntroViewController ()
@end

@implementation EUITBaseIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  在 TBase 模板中的，Node 只和模板产生约束，Node 之间互不影响；
     *  多用于处理比较动态的布局关系，如 Frame 或者 Masonry 指定布局
     */

    @weakify(self)
    UIButton *gravity = EButton(@"\n Gravity ：Tap Me ! \n", ^{
        @strongify(self)
        [self randomGravity];
    });
    gravity.eui_gravity  = EUIGravityHorzCenter | EUIGravityVertCenter;
    gravity.eui_sizeType = EUISizeTypeToFit;
    gravity.tag = 1;
    
    UIButton *sizeType = EButton(@"SizeType : Tap Me !", ^{
        @strongify(self)
        [self randomSizeType];
    });
    sizeType.tag = 2;
    sizeType.eui_sizeType = EUISizeTypeToFill;
    sizeType.eui_gravity  = EUIGravityHorzCenter | EUIGravityVertCenter;
    
    self.backButton.eui_size = CGSizeMake(100, 40);
    self.backButton.eui_margin.top  = 30;
    self.backButton.eui_margin.left = 10;
    
    EUITemplet *templet = TBase(sizeType, gravity, self.backButton);
    [self.view eui_layout:templet];
    
    /* 也可以这样
     ...
     EUITemplet *one = TBase
     (
        ///< 可以这样用，直接使用“eui_”属性
        ({
            self.backButton.eui_size = CGSizeMake(100, 40);
            self.backButton.eui_margin.top  = 30;
            self.backButton.eui_margin.left = 10;
            self.backButton;
        }),
        ///< 也可以使用 eui_configure：做配置，使用 block 可以很好的做代码的结构化
        [gravity eui_configure:^(EUILayout *layout) {
            layout.gravity  = EUIGravityHorzCenter | EUIGravityVertCenter;
            layout.sizeType = EUISizeTypeToFit;
        }],
        sizeType
     );
     ...
     *
     */
}

#pragma mark - 

#pragma mark - EUILayoutDelegate

- (EUITemplet *)templetWithLayout:(EUIEngine *)layout {
    UIView *button = [self.view viewWithTag:1];
    ///< 模板的参数包不允许塞空，可以塞个空字符串
    return TBase(self.backButton,
                 button ?: @""
                 );
}

#pragma mark - Size Type

- (void)randomSizeType {
    int i = EUIRandom(1, 4);
    UIView *one = [self.view viewWithTag:2];
    EUILayout *node = one.eui_layout;
    switch (i) {
        case 1:node.sizeType = EUISizeTypeToFit;
            break;
        case 2:node.sizeType = EUISizeTypeToFill;
            break;
        case 3:node.sizeType = EUISizeTypeToVertFit | EUISizeTypeToHorzFill;
            break;
        case 4:node.sizeType = EUISizeTypeToHorzFit | EUISizeTypeToVertFill;
            break;
    }
    [self.view eui_reload];
}

#pragma mark - Gravity

- (void)randomGravity {
    int i = EUIRandom(1, 3);
    UIView *one = [self gravityButton];
    EUILayout *node = one.eui_layout;
    switch (i) {
        case 1:{
            node.gravity = EUIGravityHorzCenter | EUIGravityVertCenter;
        } break;
        case 2:{
            node.gravity = EUIGravityHorzStart | EUIGravityVertCenter;
        } break;
        case 3:{
            node.gravity = EUIGravityHorzEnd | EUIGravityVertEnd;
        } break;
    }
    [self.view eui_reload];
}

- (UIView *)gravityButton {
    /**
     *  1.可以使用 index 的方式寻找模板中的 node
     */
    EUILayout *node = [self.view.eui_templet nodeAtIndex:1];

    /**
     *  2.可以使用 唯一标识 UniqueID 的方式寻找模板中的 node
     */
//    if (node == nil) {
//        node = [self.view.eui_templet nodeWithUniqueID:@"gravityButton"];
//    }
    
    return node.view;
}

@end
