//
//  DatePickerView.m
//  DatePickerView
//
//  Created by das on 2019/7/11.
//  Copyright © 2019 das. All rights reserved.
//


#import "DatePickerView.h"
#import "DataPickerContentView.h"
#import "DatePickerDataManager.h"
#import "PickerExtension.h"
@interface DatePickerView () <UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, DatePickerDataManagerDelegate>


/**
 配置类
 */
@property (nonatomic, strong) DatePickerConfiguration *configuration;
/**
 类型
 */
@property (nonatomic, assign) DatePickerStyle pickerStyle;

/**
 滚到指定日期
 */
@property (nonatomic, retain) NSDate *currentScrollDate;

/**
 内容视图
 */
@property ( nonatomic,strong) DataPickerContentView *contentView;

/**
 数据
 */
@property (nonatomic, strong) DatePickerDataManager *dataManager;


/**
 当调用 show的时候 的 safeAreaiInsets
 */
@property (nonatomic, strong) NSValue *whenShowSafeAreaInsets;

@end

@implementation DatePickerView

#pragma mark- | --------------------------Method-------------------------------
#pragma mark- ----------------LifeCycle
- (instancetype)initWithDatePickerStyle:(DatePickerStyle)style {
    self = [[DatePickerView alloc] initWithDatePickerStyle:style ScrollToDate:[NSDate date]];
    return self;
}

- (instancetype)initWithDatePickerStyle:(DatePickerStyle)style ScrollToDate:(NSDate *)scrollToDate {
    self = [[DatePickerView alloc] initWithDatePickerStyle:style Configuration:[[DatePickerConfiguration alloc] init] ScrollToDate:scrollToDate];
    return self;
}
- (instancetype)initWithDatePickerStyle:(DatePickerStyle)style Configuration:(DatePickerConfiguration *)configuration ScrollToDate:(NSDate *)scrollToDate {
    self = [super init];
    if (self) {
        self.configuration = configuration;
        self.pickerStyle = style;
        self.currentScrollDate = scrollToDate;
        // 配置
        [self configurationDatePicker];
        // 配置数据
        [self configuratioPickerData];
        // 添加提示 文字
        [self addPromptLabel];
        // 跳转到指定日期
        [self pickerScrollToDateAnimated:NO];
    }
    return self;
}

#pragma mark-| 安全区域变了
/**
 安全区域变了
 */
- (void)safeAreaInsetsDidChange API_AVAILABLE(ios(11.0),tvos(11.0)) {
    [super safeAreaInsetsDidChange];
    if (self.whenShowSafeAreaInsets) {
        // 说明先 show, 然后 safeare发生变化
        UIEdgeInsets last = [self.whenShowSafeAreaInsets UIEdgeInsetsValue];
        if (last.bottom != self.safeAreaInsets.bottom) {
            [self handleContentViewWithPostion:(DatePickerContentPosition_Top)];
        }
    }
}

#pragma mark- ----------------Public
- (void)showOnView:(UIView *)onView {
    [onView addSubview:self];
    if (@available(iOS 11.0, *)) {
        self.whenShowSafeAreaInsets = [NSValue valueWithUIEdgeInsets:self.safeAreaInsets];
    }
    [UIView animateWithDuration:.3 animations:^{
        [self handleContentViewWithPostion:(DatePickerContentPosition_Top)];
        self.backgroundColor = kPickerRGBA(0, 0, 0, 0.4);
        [self layoutIfNeeded];
    }];
    
}

- (void)dissmiss {
    if (self.superview) {
        self.whenShowSafeAreaInsets = nil;
        [UIView animateWithDuration:.3 animations:^{
            [self handleContentViewWithPostion:(DatePickerContentPosition_Bottom)];
            self.backgroundColor = kPickerRGBA(0, 0, 0, 0);
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}


#pragma mark- ----------------Private
#pragma mark-| 配置
/**
 配置
 */
- (void)configurationDatePicker {
    self.frame = CGRectMake(0, 0,kPickerScreenWidth, kPickerScreenHeight);
    self.backgroundColor = kPickerRGBA(0, 0, 0, 0);
    // 内容视图
    [self addSubview:self.contentView];
    self.contentView.datePicker.delegate = self;
    self.contentView.datePicker.dataSource = self;
    // 添加显示的 内容视图 约束
    [self addContentViewWithPostion:(DatePickerContentPosition_Bottom)];
    [self layoutIfNeeded];
    
    self.contentView.handleButton.backgroundColor = self.configuration.handleButtonColor;
    UIColor *titleColor = self.configuration.hanleButtonTextColor;
    [self.contentView.handleButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    [self.contentView.handleButton setTitle:@"确定" forState:(UIControlStateNormal)];
    self.contentView.handleButton.titleLabel.font = self.configuration.handleButtonFont;
    
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    [self.contentView.handleButton addTarget:self action:@selector(handleButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}


#pragma mark-| 添加 主内容视图
/**
 添加 主内容视图
 */
- (void)addContentViewWithPostion:(DatePickerContentPosition)postion {
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:270];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeLeft) multiplier:1 constant:10];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeRight) multiplier:1 constant:-10];
    NSLayoutConstraint *bottom;
    if (postion == DatePickerContentPosition_Top) {
        // 要显示
        if (@available(iOS 11.0, *)) {
            CGFloat bottom_row = self.safeAreaInsets.bottom == 0 ? -10 : -self.safeAreaInsets.bottom;
            bottom =  [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self.safeAreaLayoutGuide attribute:(NSLayoutAttributeBottom) multiplier:1 constant:bottom_row];
        }else {
            // 判断 vc
            if (self.viewController) {
                bottom =  [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self.viewController.bottomLayoutGuide attribute:(NSLayoutAttributeTop) multiplier:1 constant:-10];
            }else {
                bottom =  [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeBottom) multiplier:1 constant:-10];
            }
        }
    }else {
        // 要隐藏
        if (@available(iOS 11.0, *)) {
            CGFloat bottom_row = kPickerScreenHeight;
            bottom =  [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self.safeAreaLayoutGuide attribute:(NSLayoutAttributeBottom) multiplier:1 constant:bottom_row];
        }else {
            // 判断 vc
            if (self.viewController) {
                bottom =  [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self.viewController.bottomLayoutGuide attribute:(NSLayoutAttributeTop) multiplier:1 constant:kPickerScreenHeight];
            }else {
                bottom =  [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeBottom) multiplier:1 constant:kPickerScreenHeight];
            }
        }
    }
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addConstraints:@[height, left, right, bottom]];
}



#pragma mark-| 操作 内容视图  显隐
/**
 操作 内容视图  显隐
 */
- (void)handleContentViewWithPostion:(DatePickerContentPosition)postion {
    // 清除原来的约束
    [self.contentView.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.firstItem == self.contentView && obj.secondItem == nil) {
            obj.active = NO;
        }
    }];
    [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.firstItem == self.contentView) {
            obj.active = NO;
        }
    }];
    [self addContentViewWithPostion:(postion)];
}
#pragma mark-| 配置 数据
/**
 配置 数据
 */
- (void)configuratioPickerData {
    [self.dataManager initializeDataWithConfiguration:self.configuration];
}

#pragma mark-| 点击手势
/**
 点击手势
 
 @param tap \
 */
- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self dissmiss];
}
#pragma mark-| 跳转到指定日期
- (void)pickerScrollToDateAnimated:(BOOL)animated {
    NSArray *indexArray = [self.dataManager indexArrayWithDate:self.currentScrollDate Stytle:self.pickerStyle];
    [self.contentView.datePicker reloadAllComponents];
    
    for (NSInteger i = 0; i < indexArray.count; i++) {
        // 跳转
        NSInteger row = [[indexArray objectAtIndex:i] integerValue];
        [self.contentView.datePicker selectRow:row inComponent:i animated:animated];
    }
}


#pragma mark-| 添加提示 文字
- (void)addPromptLabel {
    NSArray<NSString *> *promptTextArray = [self.dataManager promptTextOfPickerWithStytle:self.pickerStyle];
    // 文本宽度的一半
    CGFloat halfYearTextRow = ceil(self.dataManager.yearTextWidth / 2);
    CGFloat halfOtherTextRow = ceil(self.dataManager.otherTextWidth / 2);
    CGFloat labelHeight = 15;
    CGFloat labelWidth = 15;
    
    CGFloat y = self.contentView.datePicker.frame.size.height / 2 - labelHeight / 2;
    
    CGFloat componentRow = 5 * (promptTextArray.count - 1);
    componentRow = componentRow > 0 ? componentRow : 0;
    CGFloat textCenter = (self.contentView.datePicker.frame.size.width - componentRow) / (promptTextArray.count * 2);
    
    for (NSInteger i = 0; i < promptTextArray.count; i ++) {
        UILabel *label = [[UILabel alloc] init];
        NSString *text = promptTextArray[i];
        label.text = text;
        label.textColor = self.configuration.dateLabelColor;
        // 不要贴太紧, 加个2 吧
        
        if ([text isEqualToString:@"年"]) {
            
            CGFloat x = textCenter + halfYearTextRow + i * (textCenter * 2 + 5) + 2;
            label.frame = CGRectMake(x, y , labelWidth, labelHeight);
        }else {
            CGFloat x = textCenter + halfOtherTextRow + i * (textCenter * 2 + 5) + 2;
            label.frame = CGRectMake(x, y , labelWidth, labelHeight);
        }
        [self.contentView.datePicker addSubview:label];
    }
}




#pragma mark-| 点击 确定按钮
- (void)handleButtonAction:(UIButton *)button {
    [self dissmiss];
    if (_delegate && [_delegate respondsToSelector:@selector(datePickerView:didGetResult:)]) {
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [self currentScrollDateComponentsWithCalendar:calendar];
        [self.delegate datePickerView:self didGetResult:components];
    }
    
}


#pragma mark-| 当前 选中日期组成 的 各个部分组件
- (NSDateComponents *)currentScrollDateComponentsWithCalendar:(NSCalendar *)calendar {
    NSCalendarUnit componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [calendar components:componentFlags fromDate:self.currentScrollDate];
    return components;
}


#pragma mark-| 修改当前选择中的日期
/**
 修改当前选择中的日期

 @param type 用户操作的列 类型
 @param value 值
 */
- (void)changeCurrentScrollDateWithType:(DatePickerComponentType)type Value:(NSInteger)value {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [self currentScrollDateComponentsWithCalendar:calendar];
    
    BOOL needReload = NO;
    switch (type) {
        case DatePickerComponentType_Year: // 年
            components.year = value;
            needReload = YES;
            break;
        case DatePickerComponentType_Month: // 月
            components.month = value;
            needReload = YES;
            break;
        case DatePickerComponentType_Day:   // 日
            components.day = value;
            break;
        case DatePickerComponentType_Hour: // 时
            components.hour = value;
            break;
        case DatePickerComponentType_Minute: // 分
            components.minute = value;
            break;
        default:
            break;
    }
    self.currentScrollDate = [calendar dateFromComponents:components];
    if (needReload) {
        [self.contentView.datePicker reloadAllComponents];
    }
}


#pragma mark- | --------------------------协议-------------------------------
#pragma mark- ----------------UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

#pragma mark- ----------------系统Picker协议
#pragma mark-| 多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self.dataManager numberOfComponentsWithStytle:self.pickerStyle];
}
#pragma mark-| 多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataManager numberOfRowsInComponent:component Stytle:self.pickerStyle];
}
#pragma mark-| 高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
#pragma mark-| 每行的 view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        customLabel.font = self.configuration.dateTextFont;
        customLabel.textColor = self.configuration.dateTextColor;
    }
    NSString *text = [[self dataManager] textForRow:row Component:component Stytle:self.pickerStyle];
    customLabel.text = text;
    
    return customLabel;
}
#pragma mark-| 选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // 如果修改了年, 或者  月, 要 动态修改    天数
    switch (self.pickerStyle) {
        case DatePickerStyle_YearMonthDayHourMinute:  //年月日时分
        case DatePickerStyle_YearMonthDayHour: //年月日时
        case DatePickerStyle_YearMonthDay:  //年月日
        case DatePickerStyle_YearMonth: //年月
        case DatePickerStyle_Year: // 年
            if (component == 0) {
                // 修改年
                NSInteger yearIndex = [self.contentView.datePicker selectedRowInComponent:0];
                [self changeCurrentScrollDateWithType:(DatePickerComponentType_Year)
                                                Value:[self.dataManager currentValueForIndex:yearIndex Type:(DatePickerComponentType_Year)]];
                
            }else if (component == 1) {
                // 修改月
                NSInteger monthIndex = [self.contentView.datePicker selectedRowInComponent:1];
                [self changeCurrentScrollDateWithType:(DatePickerComponentType_Month)
                                                Value:[self.dataManager currentValueForIndex:monthIndex Type:(DatePickerComponentType_Month)]];
            }else if (component == 2) {
                // 修改 日
                NSInteger dayIndex = [self.contentView.datePicker selectedRowInComponent:2];
                [self changeCurrentScrollDateWithType:(DatePickerComponentType_Day)
                                                Value:[self.dataManager currentValueForIndex:dayIndex Type:(DatePickerComponentType_Day)]];
            }else if (component == 3) {
                // 修改 时
                NSInteger hourIndex = [self.contentView.datePicker selectedRowInComponent:3];
                [self changeCurrentScrollDateWithType:(DatePickerComponentType_Hour)
                                                Value:[self.dataManager currentValueForIndex:hourIndex Type:(DatePickerComponentType_Hour)]];
            }else {
                // 修改 分
                NSInteger minuteIndex = [self.contentView.datePicker selectedRowInComponent:4];
                [self changeCurrentScrollDateWithType:(DatePickerComponentType_Minute)
                                                Value:[self.dataManager currentValueForIndex:minuteIndex Type:(DatePickerComponentType_Minute)]];
            }
            break;
        case DatePickerStyle_HourMinute: //时分
        {
            if (component == 0) {
                // 修改 时
                NSInteger hourIndex = [self.contentView.datePicker selectedRowInComponent:0];
                [self changeCurrentScrollDateWithType:(DatePickerComponentType_Hour)
                                                Value:[self.dataManager currentValueForIndex:hourIndex Type:(DatePickerComponentType_Hour)]];
            }else {
                // 修改 分
                NSInteger minuteIndex = [self.contentView.datePicker selectedRowInComponent:1];
                [self changeCurrentScrollDateWithType:(DatePickerComponentType_Minute)
                                                Value:[self.dataManager currentValueForIndex:minuteIndex Type:(DatePickerComponentType_Minute)]];
            }
        }
            break;
        case DatePickerStyle_Month:  //月
        {
            // 修改月
            NSInteger monthIndex = [self.contentView.datePicker selectedRowInComponent:0];
            [self changeCurrentScrollDateWithType:(DatePickerComponentType_Month)
                                            Value:[self.dataManager currentValueForIndex:monthIndex Type:(DatePickerComponentType_Month)]];
        }
            break;
        default:
            break;
    }
}



#pragma mark- ----------------DatePickerDataManagerDelegate
- (YearMonthModel *)currentSelectedDate {
    YearMonthModel *model = [[YearMonthModel alloc] init];
    model.currentSelectedYear = self.currentScrollDate.year;
    model.currentSelectedMonth = self.currentScrollDate.month;
    return model;
}



#pragma mark- ----------------Setter, Getter
- (DatePickerConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [[DatePickerConfiguration alloc] init];
    }
    return _configuration;
}

- (DataPickerContentView *)contentView {
    if (!_contentView) {
        _contentView = [[DataPickerContentView alloc] init];
    }
    return _contentView;
}
- (DatePickerDataManager *)dataManager {
    if (!_dataManager) {
        _dataManager = [[DatePickerDataManager alloc] initWithDelegate:self];
    }
    return _dataManager;
}



@end
