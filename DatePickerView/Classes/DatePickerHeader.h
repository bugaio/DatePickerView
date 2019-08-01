//
//  DatePicker.h
//  DatePickerView
//
//  Created by das on 2019/7/12.
//  Copyright © 2019 das. All rights reserved.
//

typedef NS_ENUM(NSUInteger, DatePickerStyle) {
    DatePickerStyle_YearMonthDayHourMinute,  //年月日时分
    DatePickerStyle_YearMonthDayHour, //年月日时
    DatePickerStyle_YearMonthDay,   //年月日
    DatePickerStyle_YearMonth,  //年月
    DatePickerStyle_HourMinute, //时分
    DatePickerStyle_Year,   //年
    DatePickerStyle_Month, //月
};



typedef NS_ENUM(NSUInteger, DatePickerComponentType) {
    DatePickerComponentType_Year, // 年
    DatePickerComponentType_Month, //月
    DatePickerComponentType_Day, // 日
    DatePickerComponentType_Hour, // 时
    DatePickerComponentType_Minute, // 分
};





typedef NS_ENUM(NSUInteger, DatePickerContentPosition) {
    DatePickerContentPosition_Top,
    DatePickerContentPosition_Bottom
};








#define kPickerRGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])
#define kPickerRGB(r, g, b) kPickerRGBA(r,g,b,1)

#define kPickerScreenWidth [UIScreen mainScreen].bounds.size.width
#define kPickerScreenHeight [UIScreen mainScreen].bounds.size.height



