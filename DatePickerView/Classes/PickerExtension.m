//
//  PickerExtension.m
//  DatePickerView
//
//  Created by das on 2019/7/12.
//  Copyright © 2019 das. All rights reserved.
//

#import "PickerExtension.h"

@implementation UIView (Extension)
- (UIViewController *)viewController {
    id nextResponder = [self nextResponder];
    while (nextResponder != nil) {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)nextResponder;
            return vc;
        }
        nextResponder = [nextResponder nextResponder];
    }
    return nil;
}


@end

@implementation NSDate (Extension)

- (NSInteger)year {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return  [calendar component:NSCalendarUnitYear fromDate:self];
}

- (NSInteger)month {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return  [calendar component:NSCalendarUnitMonth fromDate:self];
}
- (NSInteger)day {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return  [calendar component:NSCalendarUnitDay fromDate:self];
}
- (NSInteger)hour {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return  [calendar component:NSCalendarUnitHour fromDate:self];
}
- (NSInteger)minute {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return  [calendar component:NSCalendarUnitMinute fromDate:self];
}

@end
