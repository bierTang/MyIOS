//
//  SJVideoDefinitionSwitchingInfo.m
//  Pods
//
//  Created by 畅三江 on 2019/7/12.
//

#import "SJVideoDefinitionSwitchingInfo.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const _SJVideoDefinitionSwitchingStatusDidChangeNotification = @"_SJVideoDefinitionSwitchingStatusDidChangeNotification";

@implementation SJVideoDefinitionSwitchingInfoObserver {
    id _token;
}

- (instancetype)initWithInfo:(SJVideoDefinitionSwitchingInfo *)info {
    self = [super init];
    if ( self ) {
        __weak typeof(self) _self = self;
        _token = [NSNotificationCenter.defaultCenter addObserverForName:_SJVideoDefinitionSwitchingStatusDidChangeNotification object:info queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            if ( self.statusDidChangeExeBlock ) self.statusDidChangeExeBlock(note.object);
        }];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:_token];
}
@end

@interface SJVideoDefinitionSwitchingInfo ()
@property (nonatomic, weak, nullable) SJVideoPlayerURLAsset *currentPlayingAsset;

@property (nonatomic, weak, nullable) SJVideoPlayerURLAsset *switchingAsset;

@property (nonatomic) SJMediaPlaybackSwitchDefinitionStatus status;
@end

@implementation SJVideoDefinitionSwitchingInfo
- (SJVideoDefinitionSwitchingInfoObserver *)getObserver {
    return [[SJVideoDefinitionSwitchingInfoObserver alloc] initWithInfo:self];
}

- (void)setStatus:(SJMediaPlaybackSwitchDefinitionStatus)status {
    if ( status != _status ) {
        _status = status;
        [NSNotificationCenter.defaultCenter postNotificationName:_SJVideoDefinitionSwitchingStatusDidChangeNotification object:self];
    }
}
@end
NS_ASSUME_NONNULL_END
