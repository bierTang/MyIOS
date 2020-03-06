//
//  SetModel.h
//  community
//
//  Created by 蔡文练 on 2019/9/23.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetModel : NSObject

@property (nonatomic,copy)NSString *iconName;

@property (nonatomic,copy)NSString *leftTitle;
@property (nonatomic,copy)NSString *midTitle;
@property (nonatomic,copy)NSString *rightTitle;

@property (nonatomic,copy)NSString *btnName;

//@property (nonatomic,copy)NSString *message;

@end

NS_ASSUME_NONNULL_END
