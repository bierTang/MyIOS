//
//  ClassifyVC.h
//  community
//
//  Created by MAC on 2020/1/6.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassifyVC : UIViewController

@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)SJVideoPlayer *videoPlayer;
@property (nonatomic,strong)CSTimerManager *timerManager;
@end

NS_ASSUME_NONNULL_END
