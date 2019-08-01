//
//  kbViewController.m
//  DatePickerView
//
//  Created by wyj317005934@163.com on 07/13/2019.
//  Copyright (c) 2019 wyj317005934@163.com. All rights reserved.
//

#import "kbViewController.h"
#import <DatePickerView.h>
@interface kbViewController () <DatePickerViewDelegate>

@end

@implementation kbViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    DatePickerConfiguration *con = [[DatePickerConfiguration alloc] init];
    con.hanleButtonTextColor = UIColor.whiteColor;
    DatePickerView *dd = [[DatePickerView alloc] initWithDatePickerStyle:(DatePickerStyle_YearMonthDayHour) Configuration:con ScrollToDate:[NSDate date]];
    dd.delegate = self;
    [dd showOnView:self.view];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    DatePickerConfiguration *con = [[DatePickerConfiguration alloc] init];
    con.hanleButtonTextColor = UIColor.whiteColor;
    DatePickerView *dd = [[DatePickerView alloc] initWithDatePickerStyle:(DatePickerStyle_YearMonthDayHour) Configuration:con ScrollToDate:[NSDate date]];
    dd.delegate = self;
    [dd showOnView:self.view];
}


/**
 点击确定后获得 结果
 
 @param datePickerView 日期选择view
 @param components 结果
 */
- (void)datePickerView:(DatePickerView *)datePickerView didGetResult:(NSDateComponents *)components {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *date = [calendar dateFromComponents:components];
    if (date) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStrig = [formatter stringFromDate:date];
        NSLog(@"~~%@", dateStrig);
    }
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
