//
//  ADsView.h
//  community
//
//  Created by 蔡文练 on 2019/11/5.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADsView : UIView

@property (nonatomic,copy) void(^backBlock)(NSString *url);

@property (nonatomic,strong)UIImageView *bgImage;
@property (nonatomic,strong)NSString *linkUrl;


-(void)setImageUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
