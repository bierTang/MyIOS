//
//  CSDataBase.m
//  community
//
//  Created by MAC on 2019/12/25.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSDataBase.h"
static CSDataBase * sharedInstance = nil;
@implementation CSDataBase


/**
 *获取单例
 */
+ (CSDataBase *)sharedInstance{
    @synchronized(self){
        if (sharedInstance == nil)
            sharedInstance = [[CSDataBase alloc] init];
    }
    return sharedInstance;
}

+ (FMDatabaseQueue *)creatDataBaseQueue{
    
    NSFileManager *filemanager=[NSFileManager defaultManager];
    NSString *cachePath= [CTBFileMannger CachePath];
    NSString *writableDBPath=PathAppend(cachePath, DataBaseName);
//    NSLog(@"writableDBPath == %@",writableDBPath);
    BOOL sucess=[filemanager fileExistsAtPath:writableDBPath];
    if (!sucess) {
        NSString *defaultDBPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DataBaseName];
        NSError *error;
        sucess=[filemanager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!sucess) {
            NSLog(@"create Database error:%@",[error localizedDescription]);
        }
    }
    FMDatabaseQueue* dbQueue=[FMDatabaseQueue databaseQueueWithPath:writableDBPath];
    return dbQueue;
}

+ (FMDatabaseQueue *)creatDataBaseQueue:(NSString *)fileName{
    NSFileManager *filemanager=[NSFileManager defaultManager];
    NSString *cachePath= [CTBFileMannger CachePath];
    NSString *writableDBPath=PathAppend(cachePath, fileName);
    BOOL sucess=[filemanager fileExistsAtPath:writableDBPath];
    
    if (!sucess) {
        NSString *defaultDBPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        NSError *error;
        sucess=[filemanager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!sucess) {
            NSLog(@"create Database error:%@",[error localizedDescription]);
        }
    }
    FMDatabaseQueue* dbQueue=[FMDatabaseQueue databaseQueueWithPath:writableDBPath];
    return dbQueue;
}

+ (FMDatabase *)creatDataBase{
    //    NSFileManager *file=[NSFileManager defaultManager];
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSString *cachePath= [CTBFileMannger CachePath];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = PathAppend(cachePath, DataBaseName);
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    if ([db open]) {
        [db setShouldCacheStatements:YES];//存储执行的语句等
    }
    return db;
}

+ (FMDatabase *)creatDataBase:(NSString *)fileName{
    //    NSFileManager *file=[NSFileManager defaultManager];
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSString *cachePath= [CTBFileMannger CachePath];;
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = PathAppend(cachePath, fileName);
    NSLog(@"writableDBPath == %@",dbPath);
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    if ([db open]) {
        [db setShouldCacheStatements:YES];//存储执行的语句等
    }
    return db;
}

/**
 *某表的sql语句
 */
+ (NSString *)SQL:(NSString *)sql inTable:(NSString *)table{
    return [NSString stringWithFormat:sql,table];
}

#pragma mark  ---------------业务层-----------------
/**
 创建数据库此app下所有表格
 */
+(void)creatAppDataBaseTable{
    /*首页菜单*/
    [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:DB_Main];
    [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:DB_MainAds];
//    /*首页菜单单modelArray*/
    [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:DB_GIF];
//    [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:MarketIdCacheDataInfo];
//     [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:CourseIdCacheDataInfo];
//     [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:TechnicalIdCacheDataInfo];
//     [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:ArticleMainIdCacheDataInfo];
//     [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:SpcUserCacheDataInfo];
//     [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:UnFinishUploadVideoCacheDataInfo];
//     [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:DownloadCourseCacheDataInfo];
//    [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:NewVCSearchCacheDataInfo];
//    [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:ArticleGoodsSearchCacheDataInfo];
//    [self creatTableWithsql:@"CREATE TABLE IF NOT EXISTS '%@' ('id' TEXT,'cacheType' TEXT, 'versionCode' TEXT, 'data' TEXT);" tableName:DownloadSingleVideoCacheDataInfo];

    
}

/** 建表
 *参数设置:
 *1.创建此表的sql语句 2.表的名称
 */
+ (void)creatTableWithsql:(NSString *)sqlStr tableName:(NSString *)tableName{
    FMDatabase *db=[self creatDataBase];
    
    if (![db tableExists:tableName]) {
        NSString *sql = [self SQL:sqlStr inTable:tableName];
        BOOL result = [db executeUpdate:sql];
//        if/ (result) {
            NSLog(@"创建sql::%d",result);
//        }
    }
    [db close];
}
#pragma mark closeDatabase
+ (void)closeDataBase{
    [[self creatDataBase] close];
}

+ (void)closeDataBase:(NSString *)fileName{
    [[self creatDataBase:fileName] close];
}


#pragma mark -- common 存储
/**
 *插入或者更新
 */
+ (void)insertCacheDataByIdentify:(NSString *)identify CacheType:(NSString *)cacheType versionCode:(NSString *)versionCode data:(id)data{
    [[self creatDataBaseQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *sql=[self SQL:@"SELECT * FROM '%@' WHERE cacheType=? and versionCode=? and id=?" inTable:cacheType];
        NSString *dataBase = [db stringForQuery:sql,cacheType,versionCode,identify];
        if (dataBase == nil){
            NSString *sql = [self SQL:@"INSERT INTO '%@' (id,cacheType,versionCode,data) VALUES (?,?,?,?)" inTable:cacheType];
            BOOL result=[db executeUpdate: sql,identify,cacheType,versionCode,data];
            if (result==YES){
                NSLog(@"suc");
            }else{
                 NSLog(@"error");
            }
        }else{
            [CSDataBase updateCacheDataByCacheType:cacheType Identify:identify versionCode:versionCode data:data];
        }
    }];
}

/**
 *更新
 */
+ (void)updateCacheDataByCacheType:(NSString *)cacheType Identify:(NSString *)identify   versionCode:(NSString *)versionCode data:(NSString *)json{
    [[self creatDataBaseQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [self SQL:@"UPDATE '%@' SET data=? WHERE id=? and versionCode=? and cacheType=? " inTable:cacheType];
        BOOL result=[db executeUpdate: sql,json,identify,versionCode,cacheType];
        if (result==YES) {
            NSLog(@"suc");
        }else{
            NSLog(@"error");
        }
    }];
}

/**
 *插入数据
 */
+ (void)insertCacheDataByCacheType:(NSString *)cacheType Identify:(NSString *)identify   versionCode:(NSString *)versionCode data:(NSString *)json{
    [[self creatDataBaseQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [self SQL:@"INSERT INTO '%@' (id,cacheType,versionCode,data) VALUES (?,?,?,?)" inTable:cacheType];
        BOOL result=[db executeUpdate: sql,json,identify,versionCode,cacheType];
        if (result==YES) {
            NSLog(@"插入数据成功");
        }else{
            NSLog(@"插入数据失败");
        }
    }];
}

/**
 *删除表中数据
 */
+ (void)deleteCacheDataByCacheType:(NSString *)cacheType Identify:(NSString *)identify VersionCode:(NSString *)versionCode{
    [[self creatDataBaseQueue] inDatabase:^(FMDatabase *db) {
        NSString *deletestr = [self SQL:@"DELETE FROM '%@' WHERE versionCode=? and cacheType = ? and id=?" inTable:cacheType];
        BOOL result = [db executeUpdate:deletestr,versionCode,cacheType,identify];
//        NSString *deleteTableAllSql =[NSString stringWithFormat:@"DELETE FROM %@ WHERE versionCode = %@",cacheType,versionCode];
        
//        BOOL result =  [db executeUpdate:deleteTableAllSql];
        
        if (result==YES) {
            NSLog(@"success");
        }else{
            NSLog(@"error");
        }
    }];
}

/**
 *删除表中所有数据
 */
+ (void)deleteCacheDataByCacheType:(NSString *)cacheType{
    [[self creatDataBaseQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteTableAllSql =[NSString stringWithFormat:@"%@%@",@"DELETE FROM ",cacheType];
        
        BOOL result =  [db executeUpdate:deleteTableAllSql];
        
        if (result==YES) {
            NSLog(@"success");
        }else{
            NSLog(@"error");
        }
    }];
}

/**
 *按条件查询
 */
+(id)cacheDataByCacheType:(NSString *)cacheType Identify:(NSString *)identify versionCode:(NSString *)versionCode{
    __block NSString *data = nil;
    [[self creatDataBaseQueue] inDatabase:^(FMDatabase *db){
        NSString *selStr=[self SQL:@"SELECT * FROM '%@' WHERE versionCode =? and id=?" inTable:cacheType];
        FMResultSet *rs = [db executeQuery:selStr,versionCode,identify];
        while ([rs next]) {
            data = [rs stringForColumn:@"data"];
        }
        [rs close];
    }];
    return data;
}


/**
 *查询表获取数组
 */
+(NSMutableArray *)cacheArrayDataByCacheType:(NSString *)cacheType Identify:(NSString *)identify{
    __block NSString *data = nil;
    __block NSMutableArray *array = [NSMutableArray array];
    [[self creatDataBaseQueue] inDatabase:^(FMDatabase *db){
        NSString *selStr=[self SQL:@"SELECT * FROM '%@' WHERE cacheType=? and id=? " inTable:cacheType];
        FMResultSet *rs = [db executeQuery:selStr,cacheType,identify];
        while ([rs next]) {
            data = [rs stringForColumn:@"data"];
            [array addObject:[data mj_JSONObject]];
        }
        [rs close];
    }];
    return array;
}


/**
 *查询
 */
+(id)cacheDataByCacheType:(NSString *)cacheType Identify:(NSString *)identify{
    __block NSString *data = nil;
    [[self creatDataBaseQueue] inDatabase:^(FMDatabase *db){
        NSString *selStr=[self SQL:@"SELECT * FROM '%@' WHERE cacheType=? and id=?" inTable:cacheType];
        FMResultSet *rs = [db executeQuery:selStr,cacheType,identify];
        while ([rs next]) {
            data = [rs stringForColumn:@"data"];
        }
        [rs close];
    }];
    return data;
}

/**
 *查询表
 */
+(NSString *)cacheDataOnlyByCacheType:(NSString *)cacheType{
    __block NSString *data = nil;
    [[self creatDataBaseQueue] inDatabase:^(FMDatabase *db){
        NSString *selStr=[self SQL:@"SELECT * FROM '%@' WHERE cacheType=? " inTable:cacheType];
        FMResultSet *rs = [db executeQuery:selStr,cacheType];
        while ([rs next]) {
            data = [rs stringForColumn:@"data"];
        }
        [rs close];
    }];
    return data;
}

/**
 *查询表获取数组
 */
+(NSMutableArray *)cacheArrayDataByCacheType:(NSString *)cacheType{
    __block NSString *data = nil;
    __block NSMutableArray *array = [NSMutableArray array];
    [[self creatDataBaseQueue] inDatabase:^(FMDatabase *db){
        NSString *selStr=[self SQL:@"SELECT * FROM '%@' WHERE cacheType=? " inTable:cacheType];
        FMResultSet *rs = [db executeQuery:selStr,cacheType];
        while ([rs next]) {
            data = [rs stringForColumn:@"data"];
            [array addObject:[data mj_JSONObject]];
        }
        [rs close];
    }];
    return array;
}


@end
