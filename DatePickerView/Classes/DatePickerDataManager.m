//
//  DatePickerDataManager.m
//  DatePickerView
//
//  Created by das on 2019/7/11.
//  Copyright © 2019 das. All rights reserved.
//

#import "DatePickerDataManager.h"
static const NSCalendarUnit componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);

@interface DatePickerIndexModel : NSObject

@property (nonatomic, assign) NSInteger yearIndex;
@property (nonatomic, assign) NSInteger monthIndex;
@property (nonatomic, assign) NSInteger dayIndex;
@property (nonatomic, assign) NSInteger hourIndex;
@property (nonatomic, assign) NSInteger minuteIndex;
+ (DatePickerIndexModel *)createWithDate:(NSDate *)date minYear:(NSInteger)minyear;
@end

@implementation DatePickerIndexModel

+ (DatePickerIndexModel *)createWithDate:(NSDate *)date minYear:(NSInteger)minyear{
    DatePickerIndexModel *model = [[self alloc] init];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [calendar components:componentFlags fromDate:date];
    model.yearIndex = components.year - minyear;
    model.monthIndex = components.month - 1;
    model.dayIndex = components.day - 1;
    model.hourIndex = components.hour;
    model.minuteIndex = components.minute;
    return model;
}

@end
@implementation YearMonthModel

@end









@interface DatePickerDataManager ()

/**
 配置类
 */
@property (nonatomic, strong) DatePickerConfiguration *configuration;

/**
 * 年, 月 ,日 时, 分
 */
@property (nonatomic, strong) NSMutableArray *_yearArray;
@property (nonatomic, strong) NSMutableArray *_monthArray;
@property (nonatomic, strong) NSMutableArray *_hourArray;
@property (nonatomic, strong) NSMutableArray *_minuteArray;

@property (nonatomic, strong) NSArray *_currentDayArray;
@property (nonatomic, weak) id <DatePickerDataManagerDelegate> delegate;


/**
 * 文字宽度
 */
@property (nonatomic, assign) CGFloat yearTextWidth;
@property (nonatomic, assign) CGFloat otherTextWidth;
@end

@implementation DatePickerDataManager

#pragma mark- | --------------------------Method-------------------------------

#pragma mark- ----------------LifeCycle
- (instancetype)initWithDelegate:(id<DatePickerDataManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark- ----------------Public
/**
 初始化数据
 */
- (void)initializeDataWithConfiguration:(DatePickerConfiguration *)configuration {
    self.configuration = configuration;
    self._yearArray = [NSMutableArray array];
    self._monthArray = [NSMutableArray array];
    self._hourArray = [NSMutableArray array];
    self._minuteArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 60; i++) {
        NSString *num = [NSString stringWithFormat:@"%02ld",i];
        // 月
        if (0 < i && i <=12) {
            [self._monthArray addObject:num];
        }
        
        if (i < 24) {
            [self._hourArray addObject:num];
        }
        [self._minuteArray addObject:num];
    }
    for (NSInteger i = self.configuration.minYear; i <= self.configuration.maxYear; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [self._yearArray addObject:num];
    }
}


#pragma mark-| 多少列
/**
 每个类型多少列
 
 @param style 类型
 @return \
 */
- (NSInteger)numberOfComponentsWithStytle:(DatePickerStyle)style {
    switch (style) {
        case DatePickerStyle_YearMonthDayHourMinute:  //年月日时分
            return 5;
        case DatePickerStyle_YearMonthDay:  //年月日
            return 3;
        case DatePickerStyle_YearMonth: //年月
            return 2;
        case DatePickerStyle_HourMinute: //时分
            return 2;
        case DatePickerStyle_Year: //年
            return 1;
        case DatePickerStyle_Month:  //月
            return 1;
        default:
            return 0;
    }
}



#pragma mark-| 获取不同类型下, 每个列的行数
/**
 获取不同类型下, 每个列的行数
 
 @param component 列
 @param style 类型
 @return \
 */
- (NSInteger)numberOfRowsInComponent:(NSInteger)component Stytle:(DatePickerStyle)style {
    switch (style) {
        case DatePickerStyle_YearMonthDayHourMinute:  //年月日时分
            return [self YearMonthDayHourMinute_NumberOfComponent:component].count;
        case DatePickerStyle_YearMonthDay:  //年月日
            return [self YearMonthDay_NumberOfComponent:component].count;
        case DatePickerStyle_YearMonth: //年月
            return [self YearMonth_NumberOfComponent:component].count;
        case DatePickerStyle_HourMinute: //时分
            return [self HourMinute_NumberOfComponent:component].count;
        case DatePickerStyle_Year: //年
            return [self Year_NumberOfComponent:component].count;
        case DatePickerStyle_Month:  //月
            return [self Month_NumberOfComponent:component].count;
        default:
            return 0;
    }
}

#pragma mark-| 获取不同类型下, 每个列每行的文字
/**
 获取不同类型下, 每个列每行的文字
 
 @param row 行
 @param component 列
 @param style 类型
 @return \
 */
- (NSString *)textForRow:(NSInteger)row Component:(NSInteger)component Stytle:(DatePickerStyle)style {
    NSString *text = @"";
    switch (style) {
        case DatePickerStyle_YearMonthDayHourMinute:  //年月日时分
            text = [[self YearMonthDayHourMinute_NumberOfComponent:component] objectAtIndex:row];
            break;
        case DatePickerStyle_YearMonthDay:  //年月日
            text = [[self YearMonthDay_NumberOfComponent:component] objectAtIndex:row];
            break;
        case DatePickerStyle_YearMonth: //年月
            text = [[self YearMonth_NumberOfComponent:component] objectAtIndex:row];
            break;
        case DatePickerStyle_HourMinute: //时分
            text = [[self HourMinute_NumberOfComponent:component] objectAtIndex:row];
            break;
        case DatePickerStyle_Year: //年
            text =  [[self Year_NumberOfComponent:component] objectAtIndex:row];
            break;
        case DatePickerStyle_Month:  //月
            text = [[self Month_NumberOfComponent:component] objectAtIndex:row];
            break;
        default:
            break;
    }
    return text;
}


#pragma mark-| 获取 显示  提示的 文字 数组
/**
 获取 显示  提示的 文字 数组
 
 @param style 类型
 @return \
 */
- (NSArray<NSString *> *)promptTextOfPickerWithStytle:(DatePickerStyle)style {
    NSArray *textArray = @[];
    switch (style) {
        case DatePickerStyle_YearMonthDayHourMinute:  //年月日时分
            textArray = @[@"年", @"月", @"日", @"时", @"分"];
            break;
        case DatePickerStyle_YearMonthDay:  //年月日
            textArray = @[@"年", @"月", @"日"];
            break;
        case DatePickerStyle_YearMonth: //年月
            textArray = @[@"年", @"月"];
            break;
        case DatePickerStyle_HourMinute: //时分
            textArray = @[@"时", @"分"];
            break;
        case DatePickerStyle_Year: //年
            textArray =  @[@"年"];
            break;
        case DatePickerStyle_Month:  //月
            textArray = @[@"月"];
            break;
        default:
            break;
    }
    return textArray;
}

#pragma mark-| 获取当前 的关于日期显示的index数组
/**
 获取当前 的关于日期显示的index数组
 
 @param date 日期
 @param style 类型
 @return \
 */
- (NSArray<NSNumber *> *)indexArrayWithDate:(NSDate *)date Stytle:(DatePickerStyle)style {
    
    DatePickerIndexModel *model = [DatePickerIndexModel createWithDate:date minYear:self.configuration.minYear];
    NSArray *indexArray = @[];
    switch (style) {
        case DatePickerStyle_YearMonthDayHourMinute:  //年月日时分
            indexArray = @[@(model.yearIndex), @(model.monthIndex), @(model.dayIndex),@(model.hourIndex),@(model.minuteIndex)];
            break;
        case DatePickerStyle_YearMonthDay:  //年月日
            indexArray = @[@(model.yearIndex),@(model.monthIndex), @(model.dayIndex)];
            break;
        case DatePickerStyle_YearMonth: //年月
            indexArray = @[@(model.yearIndex), @(model.monthIndex)];
            break;
        case DatePickerStyle_HourMinute: //时分
            indexArray = @[@(model.hourIndex), @(model.minuteIndex)];
            break;
        case DatePickerStyle_Year: //年
            indexArray = @[@(model.yearIndex)];
            break;
        case DatePickerStyle_Month:  //月
            indexArray = @[@(model.monthIndex)];
        default:
            break;
    }
    return indexArray;
}


#pragma mark-|  根据index 获取当前  日期组成部分 的 实际值
/**
 根据index 获取当前  日期组成部分 的 实际值

 @param index index
 @param type 类型
 @return \
 */
- (NSInteger)currentValueForIndex:(NSInteger)index Type:(DatePickerComponentType)type {
    NSInteger value = 0;
    switch (type) {
        case DatePickerComponentType_Year: // 年
            value = [[self._yearArray objectAtIndex:index] integerValue];
            break;
        case DatePickerComponentType_Month: // 月
            value = [[self._monthArray objectAtIndex:index] integerValue];
            break;
        case DatePickerComponentType_Day:   // 日
        {
            if (self._currentDayArray && self._currentDayArray.count > index) {
                value = [[self._currentDayArray objectAtIndex:index] integerValue];
            }
        }
            break;
        case DatePickerComponentType_Hour: // 时
            value = [[self._hourArray objectAtIndex:index] integerValue];
            break;
        case DatePickerComponentType_Minute: // 分
            value = [[self._minuteArray objectAtIndex:index] integerValue];
            break;
        default:
            break;
    }
    
    return value;
}

#pragma mark- ----------------Private
#pragma mark-| 年月日时分  类型时, 返回每列
/**
 年月日时分  类型时, 返回每列
 
 @param component 列
 @return \
 */
- (NSArray *)YearMonthDayHourMinute_NumberOfComponent:(NSInteger)component {
    switch (component) {
        case 0: // 年
            return self._yearArray;
        case 1: // 月
            return self._monthArray;
        case 2: // 日
        {
            NSDate *date = [self createYearMonthDate];
            self._currentDayArray = [self dayArrayWithDate:date];
            return self._currentDayArray;
        }
        case 3: // 时
            return self._hourArray;
        case 4: // 分
            return self._minuteArray;
        default:
            return @[];
            
    }
}


#pragma mark-| 年月日  类型时, 返回每列
/**
 年月日 类型时, 返回每列
 
 @param component 列
 @return \
 */
- (NSArray *)YearMonthDay_NumberOfComponent:(NSInteger)component {
    switch (component) {
        case 0: // 年
            return self._yearArray;
        case 1: // 月
            return self._monthArray;
        case 2: // 日
        {
            NSDate *date = [self createYearMonthDate];
            self._currentDayArray = [self dayArrayWithDate:date];
            return self._currentDayArray;
        }
        default:
            return @[];
    }
}

#pragma mark-| 年月 类型时, 返回每列
/**
 年月 类型时, 返回每列
 
 @param component 列
 @return \
 */
- (NSArray *)YearMonth_NumberOfComponent:(NSInteger)component {
    switch (component) {
        case 0: // 年
            return self._yearArray;
        case 1: // 月
            return self._monthArray;
        default:
            return @[];
    }
}

#pragma mark-| 时分 类型时, 返回每列
/**
 时分 类型时, 返回每列
 
 @param component 列
 @return \
 */
- (NSArray *)HourMinute_NumberOfComponent:(NSInteger)component {
    switch (component) {
        case 0: // 时
            return self._hourArray;
        case 1: // 分
            return self._minuteArray;
        default:
            return @[];
    }
}
#pragma mark-| 年 类型时, 返回每列
/**
 年 类型时, 返回每列
 
 @param component 列
 @return \
 */
- (NSArray *)Year_NumberOfComponent:(NSInteger)component {
    switch (component) {
        case 0: // 年
            return self._yearArray;
        default:
            return @[];
    }
}
#pragma mark-| 月 类型时, 返回每列
/**
 月 类型时, 返回每列
 
 @param component 列
 @return \
 */
- (NSArray *)Month_NumberOfComponent:(NSInteger)component {
    switch (component) {
        case 0: // 月
            return self._monthArray;
        default:
            return @[];
    }
}

#pragma mark-| 获取 某个日期下的 当月天数
/**
 获取 某个日期下的 当月天数
 
 @param date 日期
 @return \
 */
- (NSArray *)dayArrayWithDate:(NSDate *)date {
    NSMutableArray *dayArray = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSRange dateRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    for (NSInteger i = 1; i <= dateRange.length; i++) {
        [dayArray addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    return dayArray;
}


#pragma mark-| 创建一个 只包含 年月的  日期
/**
 创建一个 只包含 年月的  日期
 
 @return \
 */
- (NSDate *)createYearMonthDate {
    YearMonthModel *model = [self.delegate currentSelectedDate];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = model.currentSelectedYear;
    components.month = model.currentSelectedMonth;
    NSDate *result =  [calendar dateFromComponents:components];
    return result;
}



#pragma mark-| Getter
- (CGFloat)yearTextWidth {
    if (_yearTextWidth == 0) {
        NSString *year = @"2019";
        NSDictionary *dict = @{ NSFontAttributeName: self.configuration.dateTextFont };
        CGSize size = [year sizeWithAttributes:dict];
        _yearTextWidth = size.width;
    }
    return _yearTextWidth;
}

- (CGFloat)otherTextWidth {
    if (!_otherTextWidth) {
        NSString *other = @"12";
        NSDictionary *dict = @{ NSFontAttributeName: self.configuration.dateTextFont };
        CGSize size = [other sizeWithAttributes:dict];
        _otherTextWidth = size.width;
    }
    return _otherTextWidth;
}

@end
