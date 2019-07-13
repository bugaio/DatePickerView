//
//  DatePickerConfiguration.m
//  DatePickerView
//
//  Created by das on 2019/7/13.
//  Copyright © 2019 das. All rights reserved.
//

#import "DatePickerConfiguration.h"
#import "DatePickerHeader.h"
@implementation DatePickerConfiguration

- (NSInteger)minYear {
    if (_minYear == 0) {
        _minYear = 1900;
    }
    return _minYear;
}
- (NSInteger)maxYear {
    if (_maxYear == 0) {
        _maxYear = 2999;
    }else if (_maxYear < self.minYear) {
        _maxYear = self.minYear + 1000;
    }
    return _maxYear;
}

- (UIColor *)dateTextColor {
    if (!_dateTextColor) {
        _dateTextColor = [UIColor blackColor];
    }
    return _dateTextColor;
}

- (UIFont *)dateTextFont {
    if (!_dateTextFont) {
        _dateTextFont = [UIFont systemFontOfSize:17];
    }
    return _dateTextFont;
}

- (UIColor *)handleButtonColor {
    if (!_handleButtonColor) {
        _handleButtonColor = kPickerRGB(10, 96, 255);
    }
    return _handleButtonColor;
}
- (UIColor *)hanleButtonTextColor {
    if (!_hanleButtonTextColor) {
        _hanleButtonTextColor = [UIColor blueColor];
    }
    return _hanleButtonTextColor;
}
- (UIFont *)handleButtonFont {
    if (!_handleButtonFont) {
        _handleButtonFont = [UIFont systemFontOfSize:17];
    }
    return _handleButtonFont;
}
- (UIColor *)dateLabelColor {
    if (!_dateLabelColor) {
        _dateLabelColor = kPickerRGB(84, 255, 159);
    }
    return _dateLabelColor;
}

@end
