//
//  DatePickerView.h
//  DatePickerView
//
//  Created by das on 2019/7/11.
//  Copyright © 2019 das. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerHeader.h"



NS_ASSUME_NONNULL_BEGIN
@class DatePickerConfiguration;
@class DatePickerView;

@protocol DatePickerViewDelegate <NSObject>

/**
 点击确定后获得 结果

 @param datePickerView 日期选择view
 @param components 结果
 */
- (void)datePickerView:(DatePickerView *)datePickerView didGetResult:(NSDateComponents *)components;

@end

@interface DatePickerView : UIView

@property (nonatomic, weak) id<DatePickerViewDelegate> delegate;
/**
 配置类
 */
@property (nonatomic, strong, readonly) DatePickerConfiguration *configuration;

- (instancetype)initWithDatePickerStyle:(DatePickerStyle)style;
- (instancetype)initWithDatePickerStyle:(DatePickerStyle)style ScrollToDate:(NSDate *)scrollToDate;
- (instancetype)initWithDatePickerStyle:(DatePickerStyle)style Configuration:(DatePickerConfiguration *)configuration ScrollToDate:(NSDate *)scrollToDate ;



- (void)showOnView:(UIView *)onView;
- (void)dissmiss;
@end

NS_ASSUME_NONNULL_END
