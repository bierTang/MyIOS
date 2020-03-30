//
//  WebModel.h
//  community


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebModel : NSObject


@property (nonatomic,assign)NSInteger create_time;
@property (nonatomic,strong)NSString *over_time;
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,assign)NSInteger id;
@property (nonatomic,assign)NSInteger update_time;  
@end

NS_ASSUME_NONNULL_END
