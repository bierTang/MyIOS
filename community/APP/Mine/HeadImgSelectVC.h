//
//  HeadImgSelectVC.h
//  community
//
//  Created by MAC on 2020/1/17.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeadImgSelectVC : UIViewController

@property (nonatomic,copy) void (^ImgSelectBlock)(NSString *data);

@end

NS_ASSUME_NONNULL_END
