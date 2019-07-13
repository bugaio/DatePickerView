//
//  PickerExtension.h
//  DatePickerView
//
//  Created by das on 2019/7/12.
//  Copyright © 2019 das. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIView (Extension)

- (nullable UIViewController *)viewController;

@end


@interface NSDate (Extension)
/**
 年
 */
@property (nonatomic, assign, readonly) NSInteger year;
/**
 月
 */
@property (nonatomic, assign, readonly) NSInteger month;

/**
 日
 */
@property (nonatomic, assign, readonly) NSInteger day;
/**
 时
 */
@property (nonatomic, assign, readonly) NSInteger hour;

/**
 分
 */
@property (nonatomic, assign, readonly) NSInteger minute;

@end


NS_ASSUME_NONNULL_END
