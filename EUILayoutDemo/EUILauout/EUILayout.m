//
//  EUILayouter.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUILayout.h"
#import "UIView+EUILayout.h"

#pragma mark -

NSInteger EUIRootViewTag() {
    static NSInteger tag;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tag = @"RootTag".hash;
    });
    return tag;
}

#pragma mark -

@interface EUILayout()
@property (nonatomic, weak, readwrite) UIView *view;
@property (nonatomic, strong, readwrite) EUITemplet *rootTemplet;
@end

@implementation EUILayout

+ (instancetype)layouterByView:(UIView *)view {
    if (!view) {
        return nil;
    }
    EUILayout *one = [[EUILayout alloc] init];
    one.view = view;
    return one;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addObserver:self
               forKeyPath:@"view"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        
        [self addObserver:self
               forKeyPath:@"rootTemplet"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
    return self;
}

- (void)dealloc {
     _view = nil;
    [_rootTemplet removeAllNodes];
    [self removeObserver:self forKeyPath:@"view"];
    [self removeObserver:self forKeyPath:@"rootTemplet"];
    NSLog(@"EUILayout dealloc");
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    NSLog(@"keyPath:%@, object:%@, change:%@, context:%@",keyPath,object,change,context);
    if ([keyPath isEqualToString:@"rootTemplet"]) {
        if ([change[@"new"] isEqual:[NSNull null]]) {
            [self.view eui_removeLayout];
        }
    }
}

#pragma mark - Update

- (void)update {
    if (!(self.view) ||
        !(self.delegate) ||
        ![self.delegate respondsToSelector:@selector(templetWithLayout:)])
    {
        return;
    }
    EUITemplet *templet = [self.delegate templetWithLayout:self];
    [self updateTemplet:templet];
}

- (void)updateTemplet:(EUITemplet *)templet {
    [self setRootTemplet:templet];
    
    if ([templet isHolder]) {
        [templet setView:self.rootContainer];
    } else {
        EUITempletView *one = [self.view viewWithTag:EUIRootViewTag()];
        if ( one && one.superview ) {
            [one removeFromSuperview];
        }
        one = nil;
    }
    ///< TODO: 使用 Parser 优化解析
    [self updateRootTempletFrame:templet];
    [templet layoutTemplet];
}

- (void)updateRootTempletFrame:(EUITemplet *)templet {
    CGRect frame = (CGRect){.origin = {0}, .size = self.view.bounds.size};
    
    if (EUIValid(templet.x)) {
        frame.origin.x = templet.x;
    } else if (EUIValid(templet.margin.left)) {
        frame.origin.x = templet.margin.left;
    }
    if (EUIValid(templet.y)) {
        frame.origin.y = templet.y;
    } else if (EUIValid(templet.margin.top)) {
        frame.origin.y = templet.margin.top;
    }
    if (EUIValid(templet.width)) {
        frame.size.width = templet.width;
    } else if (EUIValid(templet.margin.right) || EUIValid(templet.margin.left)) {
        frame.size.width = self.view.bounds.size.width - EUIValue(templet.margin.left) - EUIValue(templet.margin.right);
    }
    if (EUIValid(templet.height)) {
        frame.size.height = templet.height;
    } else if (EUIValid(templet.margin.bottom) || EUIValid(templet.margin.top)) {
        frame.size.height = self.view.bounds.size.height - EUIValue(templet.margin.top) - EUIValue(templet.margin.bottom);
    }
    [templet.view setFrame:frame];
}

#pragma mark -

- (void)clean {
    EUITemplet *one = self.rootTemplet;
    if ([one isKindOfClass:EUITemplet.class]) {
        [one reset];
    }
    [one removeAllNodes];
    if (one.isHolder) {
        UIView *container = one.view;
        if (container) {
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
