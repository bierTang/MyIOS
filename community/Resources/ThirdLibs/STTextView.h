//
//  STTextView.h
//  lover
//
//  Created by stoneobs on 16/4/28.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  说明:带有plceholeder 的UITextview

#import <UIKit/UIKit.h>
@interface STTextView : UITextView
@property(nonatomic,strong) NSString          *placeholder;
@property(nonatomic,strong)UIColor            *placeholderColor;
@property(nonatomic,strong)UILabel * label;
-(void)setText:(NSString *)text;
@end
