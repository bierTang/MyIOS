//
//  LiveSegView.h
//  community
//
//  Created by MAC on 2020/2/12.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveSegView : UIView

@property (nonatomic,strong)UIButton *saveBtn;

@property (nonatomic,copy) void(^backBlock)(UIButton *sender);


-(void)changeSeg:(NSInteger)tag;



@end

NS_ASSUME_NONNULL_END
