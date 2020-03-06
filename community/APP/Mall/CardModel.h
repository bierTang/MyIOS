//
//  CardModel.h
//  community
//
//  Created by 蔡文练 on 2019/11/11.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardModel : NSObject

@property (nonatomic,assign)NSInteger coin;

@property (nonatomic,copy)NSString *create_time;    //" = 1570707151;
@property (nonatomic,copy)NSString *day_time;    //" = 3;
@property (nonatomic,copy)NSString *descriptions;    // = "3\U5929\U671f\U9650";
@property (nonatomic,copy)NSString *idss;    // = 12;
@property (nonatomic,copy)NSString *images;    // = "uploads/files/20191007/487f8bf7c1dc5a3084eb8331be9ff7c5.jpeg";
@property (nonatomic,copy)NSString *pic_url;    //" = 56;
@property (nonatomic,copy)NSString *sort;    // = 50;
@property (nonatomic,copy)NSString *status;    // = 1;
@property (nonatomic,copy)NSString *title;    // = "3\U5929\U4f53\U9a8c\U5361";
@property (nonatomic,assign)NSInteger type;    // = 1;
@property (nonatomic,assign)NSInteger update_time;    //" = 1570762160;

@property (nonatomic,copy)NSString *path;

@end

NS_ASSUME_NONNULL_END
