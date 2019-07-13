//
//  DatePickerDataManager.h
//  DatePickerView
//
//  Created by das on 2019/7/11.
//  Copyright © 2019 das. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatePickerHeader.h"
#import <UIKit/UIKit.h>
#import "DatePickerConfiguration.h"
NS_ASSUME_NONNULL_BEGIN

@interface YearMonthModel : NSObject
@property (nonatomic, assign) NSInteger currentSelectedYear;
@property (nonatomic, assign) NSInteger currentSelectedMonth;
@end


@protocol DatePickerDataManagerDelegate <NSObject>
- (YearMonthModel *)currentSelectedDate;
@end




@interface DatePickerDataManager : NSObject



/**
 * 文字宽度
 */
@property (nonatomic, assign, readonly) CGFloat yearTextWidth;
@property (nonatomic, assign, readonly) CGFloat otherTextWidth;

- (instancetype)initWithDelegate:(id<DatePickerDataManagerDelegate>)delegate  NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

/**
 初始化数据
 */
- (void)initializeDataWithConfiguration:(DatePickerConfiguration *)configuration;


/**
 每个类型多少列
 
 @param style 类型
 @return \
 */
- (NSInteger)numberOfComponentsWithStytle:(DatePickerStyle)style;
/**
 获取不同类型下, 每个列的行数

 @param component 列
 @param style 类型
 @return \
 */
- (NSInteger)numberOfRowsInComponent:(NSInteger)component Stytle:(DatePickerStyle)style;

/**
 获取不同类型下, 每个列每行的文字
 
 @param row 行
 @param component 列
 @param style 类型
 @return \
 */
- (NSString *)textForRow:(NSInteger)row Component:(NSInteger)component Stytle:(DatePickerStyle)style;


/**
 获取 显示  提示的 文字 数组

 @param style 类型
 @return \
 */
- (NSArray<NSString *> *)promptTextOfPickerWithStytle:(DatePickerStyle)style;

/**
 获取当前 的关于日期显示的index数组
 
 @param date 日期
 @param style 类型
 @return \
 */
- (NSArray<NSNumber *> *)indexArrayWithDate:(NSDate *)date Stytle:(DatePickerStyle)style;




/**
 根据index 获取当前  日期组成部分 的 实际值
 
 @param index index
 @param type 类型
 @return \
 */
- (NSInteger)currentValueForIndex:(NSInteger)index Type:(DatePickerComponentType)type;

@end

NS_ASSUME_NONNULL_END
