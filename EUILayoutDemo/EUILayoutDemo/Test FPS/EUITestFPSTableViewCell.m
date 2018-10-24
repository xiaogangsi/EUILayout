//
//  EUITestFPSTableViewCell.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/24.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITestFPSTableViewCell.h"
#import "EUILayoutKit.h"

@interface EUITestFPSTableViewCell()
@property (nonatomic, strong) EUITemplet *cardTemplet;
@end

@implementation EUITestFPSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cardTemplet = TRow(self.topCard, self.midCard, self.bottomCard);
        self.cardTemplet.margin.top = 10;
        self.cardTemplet.margin.bottom = 10;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self eui_layout:self.cardTemplet];
}

+ (CGFloat)cellHeight:(id)model {
    CGFloat top    = [EUITestTopCard height:model];
    CGFloat mid    = [EUITestTopCard height:model];
    CGFloat bottom = [EUITestTopCard height:model];

    return 10 + top + mid + bottom + 10;
}

#pragma mark -

- (UIView *)topCard {
    if (_topCard == nil) {
        _topCard = [EUITestTopCard new];
    }
    return _topCard;
}

- (UIView *)midCard {
    if (_midCard == nil) {
        _midCard = [EUITestMidCard new];
    }
    return _midCard;
}

- (UIView *)bottomCard {
    if (_bottomCard == nil) {
        _bottomCard = [EUITestBottomCard new];
    }
    return _bottomCard;
}

@end