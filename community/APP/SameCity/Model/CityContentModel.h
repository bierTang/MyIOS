//
//  CityContentModel.h
//  community
//
//  Created by 蔡文练 on 2019/9/24.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CityContentModel : NSObject
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)NSString *best;
@property(nonatomic,strong)NSString *city_id;
@property(nonatomic,strong)NSString *comment_num;
@property(nonatomic,strong)NSString *favorite_num;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *create_time;
@property(nonatomic,strong)NSString *idss;
@property(nonatomic,strong)NSString *like_num;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *update_time;
@property(nonatomic,strong)NSString *user_name;
@property(nonatomic,strong)NSString *user_avatar;
@property(nonatomic,assign)BOOL is_like;
@property(nonatomic,assign)BOOL is_favorite;

@property(nonatomic,strong)NSString *video;

@property(nonatomic,strong)NSString *logo;

@property(nonatomic,strong)NSArray *path;

@property(nonatomic,strong)NSArray *images;

@property(nonatomic,strong)NSString *nick_name;

@property(nonatomic,strong)NSNumber *isFold;


@property(nonatomic,strong)NSNumber *status;

//best = 0;
//"city_id" = 5;
//"comment_num" = 0;
//content = "<p>9</p>";
//"create_time" = 1569121095;
//id = 27;
//"like_num" = 0;
//title = "\U540c\U57ce9";
//uid = 0;
//"update_time" = 0;

@end

NS_ASSUME_NONNULL_END
