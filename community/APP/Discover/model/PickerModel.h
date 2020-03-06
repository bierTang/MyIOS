//
//  PickerModel.h
//  community
//
//  Created by 蔡文练 on 2019/10/17.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickerModel : NSObject

@property (nonatomic,strong)NSString *link;

@property (nonatomic,strong)UIImage *image;

@property (nonatomic,assign)BOOL isAddIcon;
@property (nonatomic,assign)int tag;

@end

NS_ASSUME_NONNULL_END
