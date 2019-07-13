//
//  DataPickerContentView.m
//  DatePickerView
//
//  Created by das on 2019/7/11.
//  Copyright © 2019 das. All rights reserved.
//

#import "DataPickerContentView.h"

@interface DataPickerContentView ()
/**
 操作按钮
 */
@property (nonatomic, strong) UIButton *handleButton;
/**
 pickerView
 */
@property (nonatomic,strong) UIPickerView *datePicker;
@end

@implementation DataPickerContentView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addHandleBtn];
        [self addPickerView];
    }
    return self;
}

#pragma mark-| 添加操作按钮
/**
 添加操作按钮
 */
- (void)addHandleBtn {
    [self addSubview:self.handleButton];
    self.handleButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.handleButton attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeRight) multiplier:1 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.handleButton attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.handleButton attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.handleButton attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeLeft) multiplier:1 constant:0];
    [self addConstraints:@[right, height, bottom, left]];
}


#pragma mark-| 添加 选择器
/**
 添加 选择器
 */
- (void)addPickerView {
        [self addSubview:self.datePicker];
        self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.datePicker attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:216];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.datePicker attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeLeft) multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.datePicker attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeRight) multiplier:1 constant:0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.datePicker attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeTop) multiplier:1 constant:0];
        [self addConstraints:@[height,left, right, top]];
}


- (UIButton *)handleButton {
    if (!_handleButton) {
        _handleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    }
    return  _handleButton;
}


- (UIPickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] init];
        _datePicker.showsSelectionIndicator = YES;
    }
    return _datePicker;
}

@end
