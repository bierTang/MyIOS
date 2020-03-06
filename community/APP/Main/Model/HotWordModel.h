//
//  HotWordModel.h
//  community
//
//  Created by 蔡文练 on 2019/10/14.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotWordModel : NSObject

@property (nonatomic,strong)NSString *cat_desc;
@property (nonatomic,strong)NSString *cat_img;
@property (nonatomic,strong)NSString *cat_name;
@property (nonatomic,strong)NSString *keyword; // = "\U56fd\U4ea7\U81ea\U62cd";


@property (nonatomic,strong)NSString *update_info; //" = "\U5df2\U66f4\U65b0";
@property (nonatomic,strong)NSString *view_count; //" = 0;


@end

NS_ASSUME_NONNULL_END
