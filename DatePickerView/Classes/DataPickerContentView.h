//
//  DataPickerContentView.h
//  DatePickerView
//
//  Created by das on 2019/7/11.
//  Copyright © 2019 das. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataPickerContentView : UIView

/**
 操作按钮
 */
@property (nonatomic, strong, readonly) UIButton *handleButton;
/**
 pickerView
 */
@property (nonatomic,strong, readonly) UIPickerView *datePicker;
@end

NS_ASSUME_NONNULL_END
