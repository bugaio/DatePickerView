//
//  DatePickerConfiguration.h
//  DatePickerView
//
//  Created by das on 2019/7/13.
//  Copyright © 2019 das. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DatePickerConfiguration : NSObject

/**
 最小年份
 */
@property (nonatomic, assign) NSInteger minYear;

/**
 最大年份
 */
@property (nonatomic, assign) NSInteger maxYear;



/**
 底部操作按钮 颜色
 */
@property (nonatomic, strong) UIColor *handleButtonColor;

/**
 操作按钮 文字颜色
 */
@property (nonatomic, strong) UIColor *hanleButtonTextColor;

/**
 操作按钮的 font
 */
@property (nonatomic, strong) UIFont *handleButtonFont;
/**
 时间文字  颜色
 */
@property (nonatomic, strong) UIColor *dateTextColor;

/**
 时间文字  字体
 */
@property (nonatomic, strong) UIFont *dateTextFont;

/**
 *  提示 文字的颜色
 */
@property (nonatomic,strong)UIColor *dateLabelColor;

@end

NS_ASSUME_NONNULL_END
