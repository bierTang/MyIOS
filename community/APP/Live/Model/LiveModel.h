//
//  LiveModel.h
//  community
//
//  Created by MAC on 2020/2/17.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveModel : NSObject

@property (nonatomic,strong)NSString *pull;
@property (nonatomic,strong)NSString *imgUrl;
@property (nonatomic,strong)NSString *userName;

@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *nums;
@property (nonatomic,strong)NSString *stream;

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *img;
@property (nonatomic,strong)NSString *pass;
@end

NS_ASSUME_NONNULL_END
