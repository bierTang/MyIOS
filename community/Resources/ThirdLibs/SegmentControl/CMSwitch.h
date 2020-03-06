//
//  CMSwitch.h
//  CloudMoney
//
//  Created by CMGF on 14-12-16.
//  Copyright (c) 2014年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSwitch : UIControl
@property (nonatomic, assign, getter = isOn) BOOL on;

@property (nonatomic, strong) UIColor *onTintColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *thumbTintColor;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) NSString *onText;
@property (nonatomic, strong) NSString *offText;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (void)setOnStats:(BOOL)on animated:(BOOL)animated;
@end
