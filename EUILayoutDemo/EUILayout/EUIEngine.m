//
//  EUILayouter.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIEngine.h"
#import "EUITemplet.h"
#import "UIView+EUILayout.h"

#pragma mark -

NSInteger EUIRootViewTag() {
    static NSInteger tag;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tag = @"euitag".hash;
    });
    return tag;
}

#pragma mark -

@interface EUIEngine()
@property (nonatomic, weak, readwrite) UIView *view;
@property (nonatomic, strong, readwrite) EUITemplet *rootTemplet;
@end

@implementation EUIEngine

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        _view = view;
    }
    return self;
}

- (void)dealloc {
    [_rootTemplet removeAllSubLayouts];
    NSLog(@"Engine dealloc");
}

#pragma mark - Update

- (void)layoutTemplet:(EUITemplet *)templet {
    [self.view setEui_templet:templet];
    [self setRootTemplet:templet];
    ///< -- 暂时根模板还是支持holder --
    templet.isHolder = YES;
    ///< ---------------------------
    if ([templet isHolder]) {
        [templet setView:self.rootContainer];
    } else {
        EUITempletView *one = [self.view viewWithTag:EUIRootViewTag()];
        if ( one && one.superview ) {
            [one removeFromSuperview];
             one = nil;
        }
    }
    ///< TODO: 使用 Parser 优化解析
    [self updateRootTempletFrame:templet];
    [templet layout];
}

- (void)updateRootTempletFrame:(EUITemplet *)templet {
    CGRect frame = (CGRect){.origin = {0}, .size = self.view.bounds.size};
    
    if (EUIValueIsValid(templet.x)) {
        frame.origin.x = templet.x;
    } else if (EUIValueIsValid(templet.margin.left)) {
        frame.origin.x = templet.margin.left;
    }
    if (EUIValueIsValid(templet.y)) {
        frame.origin.y = templet.y;
    } else if (EUIValueIsValid(templet.margin.top)) {
        frame.origin.y = templet.margin.top;
    }
    if (EUIValueIsValid(templet.width)) {
        frame.size.width = templet.width;
    } else if (EUIValueIsValid(templet.margin.right) || EUIValueIsValid(templet.margin.left)) {
        frame.size.width = self.view.bounds.size.width - EUIValue(templet.margin.left) - EUIValue(templet.margin.right);
    }
    if (EUIValueIsValid(templet.height)) {
        frame.size.height = templet.height;
    } else if (EUIValueIsValid(templet.margin.bottom) || EUIValueIsValid(templet.margin.top)) {
        frame.size.height = self.view.bounds.size.height - EUIValue(templet.margin.top) - EUIValue(templet.margin.bottom);
    }
    [templet setCacheFrame:frame];
    [templet.view setFrame:frame];
}

- (void)cleanUp {
    EUITemplet *one = self.rootTemplet;
    if (!one) return;
    
    if ([one isKindOfClass:EUITemplet.class]) {
        [one clearSubviewsIfNeeded];
    }
    [one removeAllSubLayouts];
    if (one.isHolder) {
        UIView *container = one.view;
        if ( container ) {
            [container removeFromSuperview];
            (container = nil);
        }
        one.view = nil;
    }
    self.rootTemplet = nil;
}

#pragma mark - Root Container

- (EUITempletView *)rootContainer {
    EUITempletView *one = [self.view viewWithTag:EUIRootViewTag()];
    if (one == nil) {
        one = [EUITempletView new];
        one.tag = EUIRootViewTag();
        [self.view addSubview:one];
    }
    return one;
}

@end