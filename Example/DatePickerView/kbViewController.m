//
//  kbViewController.m
//  DatePickerView
//
//  Created by wyj317005934@163.com on 07/13/2019.
//  Copyright (c) 2019 wyj317005934@163.com. All rights reserved.
//

#import "kbViewController.h"
#import <DatePickerView.h>
@interface kbViewController ()

@end

@implementation kbViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    DatePickerView *dd = [[DatePickerView alloc] initWithDatePickerStyle:(DatePickerStyle_YearMonth)];
    [dd showOnView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
