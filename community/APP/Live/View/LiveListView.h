//
//  LiveListView.h
//  community
//
//  Created by MAC on 2020/2/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveListItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveListView : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSArray *dataArr;

@property (nonatomic,assign)BOOL showHeader;

@property (nonatomic,copy) void (^liveBlock)(LiveModel *model);

-(void)reLoadCollectionView:(NSArray *)arr;



@end

NS_ASSUME_NONNULL_END
