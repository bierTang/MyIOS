//
//  LiveRecommandVC.h
//  community
//
//  Created by MAC on 2020/2/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveListVC : UIViewController

@property (nonatomic,strong)LiveModel *model;
@property (nonatomic,strong)NSArray<LiveModel *> *dataArr;
@property (nonatomic, strong) NSString *recommNameStr;
@end

NS_ASSUME_NONNULL_END
