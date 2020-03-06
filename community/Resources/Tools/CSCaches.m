//
//  WHCaches.m
//  WealthHo
//
//  Created by 888 on 2019/3/20.
//  Copyright © 2019 GF. All rights reserved.
//

#import "CSCaches.h"

@implementation CSCaches

static CSCaches *sharedInstance;

+(CSCaches *) shareInstance{
    
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init] ;
    }) ;
    
    return sharedInstance ;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}
-(NSUserDefaults *)userDefault{
    if (!_userDefault) {
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    return _userDefault;
}
-(void)saveUserDefalt:(NSString *)key value:(NSString *)value{
    [self.userDefault setValue:value forKey:key];
    [self.userDefault synchronize];
}

-(void)saveUserDefaltFloat:(NSString *)key value:(CGFloat)value{
    [self.userDefault setFloat:value forKey:key];
    [self.userDefault synchronize];
}

-(void)saveModelArray:(NSString *)key value:(NSString *)modelstr{
    
    [self.userDefault setValue:modelstr forKey:key];
    [self.userDefault synchronize];
}


-(void)saveModel:(NSString *)key value:(nonnull id)obj{
    [self.userDefault setValue:[obj mj_JSONString] forKey:key];
    
    [self.userDefault synchronize];
}
-(UserModel *)getUserModel:(NSString *)key{
    NSString *str = [self.userDefault valueForKey:key];
    return [UserModel mj_objectWithKeyValues:str];
}

-(void)removeDefaultValueKey:(NSString *)key{
    [self.userDefault removeObjectForKey:key];
}

-(NSString *)getValueForKey:(NSString *)key{
    return [self.userDefault valueForKey:key];
}

@end
