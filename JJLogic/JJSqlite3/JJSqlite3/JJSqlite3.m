//
//  JJSqlite3.m
//  JJSqlite3
//
//  Created by WilliamLiuWen on 16/7/19.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJSqlite3.h"
#import "JJFormat.h"
#import <sqlite3.h>

#define SQLIET_FILE  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SQLITE_FILE.sqlite"]

@implementation JJSqlite3

// 创建数据库表：根据doorID和appID
+ (void)creatSqliteTimeTableWithDoorID:(NSString *)doorID appID:(NSString *)appID{
    NSData *currentTime = [self formatTotNSDataTimeWithCurrentTime];
    
    // SQLITE_FILE.sqlite
    sqlite3 *db = nil;
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:SQLIET_FILE];
    
    if (!success) {
        NSString *defaultPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SQLITE_FILE.sqlite"];
        success = [fileManager copyItemAtPath:defaultPath toPath:SQLIET_FILE error:&error];
    }
    
    //
    if (sqlite3_open([SQLIET_FILE UTF8String],&db) == SQLITE_OK) {
        // create table : " time_table "
        const char *creatTableSQL = "CREATE TABLE IF NOT EXISTS time_table (id integer PRIMARY KEY AUTOINCREMENT, DOORID text NOT NULL, APPID text NOT NULL, TIME text NOT NULL);";
        char *error = NULL;
        // exec sql
        int result = sqlite3_exec(db, creatTableSQL, NULL, NULL, &error);
        
        if (result == SQLITE_OK) {
            // insert value
            NSString *insertDataSQL = [NSString stringWithFormat:@"INSERT INTO time_table (DOORID,APPID,TIME) VALUES ('%@','%@','%@');", doorID,appID,currentTime];
            char *erroMsg = NULL;
            // exec sql
            sqlite3_exec(db, insertDataSQL.UTF8String, NULL, NULL, &erroMsg);
            
            // close db
            if (erroMsg){
                sqlite3_close(db);
                db = nil;
            } else {
                sqlite3_close(db);
                db = nil;
            }
        } else {
            sqlite3_close(db);
            db = nil;
        }
    }else{
        sqlite3_close(db);
        db = nil;
    }
}

// SQLITE：获取数据库表
+ (NSData*)getDataOfTimeTable{
    // SQLIET_FILE
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        success = [fileManager fileExistsAtPath:SQLIET_FILE];
        if (!success)  return nil;
    //
        sqlite3 *db = nil;
        NSMutableData *mutableData;
        sqlite3_stmt *stmt = nil;
        if (sqlite3_open([SQLIET_FILE UTF8String],&db) == SQLITE_OK) {
        
        NSString *getDataSQL = [NSString stringWithFormat:@"SELECT * FROM time_table"];
        int result = sqlite3_prepare_v2(db, getDataSQL.UTF8String, -1, &stmt, nil);
        if (result == SQLITE_OK) {
            mutableData = [NSMutableData data];
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                UInt64 doorID = sqlite3_column_int(stmt, 1);
                UInt64 appID = sqlite3_column_int(stmt, 2);
                UInt64 date = sqlite3_column_int(stmt, 3);
            }
            // close
        }else {
            sqlite3_finalize(stmt);
            sqlite3_close(db);
            db = nil;
        }
    }else{
        sqlite3_finalize(stmt);
        sqlite3_close(db);
        db = nil;
    }
    
    return mutableData;
}

// SQLITE：创建数据库表
+ (void)creatSqliteTimeTable {
    
    // current time
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
        NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
        NSInteger year = [comps year];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        NSInteger hour = [comps hour];
        NSInteger min = [comps minute];
        NSInteger sec = [comps second];
    
    // SQLITE_FILE.sqlite
        sqlite3 *db = nil;
        BOOL success;
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        success = [fileManager fileExistsAtPath:SQLIET_FILE];
        
        if (!success) {
            NSString *defaultPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SQLITE_FILE.sqlite"];
            success = [fileManager copyItemAtPath:defaultPath toPath:SQLIET_FILE error:&error];
        }
    
    //
        if (sqlite3_open([SQLIET_FILE UTF8String],&db) == SQLITE_OK) {
        // create table : " time_table "
            const char *creatTableSQL = "CREATE TABLE IF NOT EXISTS time_table (id integer PRIMARY KEY AUTOINCREMENT, year text NOT NULL, month text NOT NULL, day text NOT NULL, hour text NOT NULL, min text NOT NULL, sec text NOT NULL);";
            char *error = NULL;
            // exec sql
            int result = sqlite3_exec(db, creatTableSQL, NULL, NULL, &error);
            
            if (result == SQLITE_OK) {
        // insert value
                NSString *insertDataSQL = [NSString stringWithFormat:@"INSERT INTO time_table (year,month,day,hour,min,sec) VALUES ('%ld','%ld','%ld','%ld','%ld','%ld');", (long)year,(long)month,(long)day,(long)hour,(long)min,(long)sec];
                char *erroMsg = NULL;
                // exec sql
                sqlite3_exec(db, insertDataSQL.UTF8String, NULL, NULL, &erroMsg);
                
            // close db
                if (erroMsg){
                    sqlite3_close(db);
                    db = nil;
                } else {
                    sqlite3_close(db);
                    db = nil;
                }
            } else {
                sqlite3_close(db);
                db = nil;
            }
        }else{
            sqlite3_close(db);
            db = nil;
        }
    
}

// SQLITE：删除限制的前几条
+ (void)handleDeleteTimeDataWithCount:(int)dataCount{
    
    // SQLIET_FILE
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        success = [fileManager fileExistsAtPath:SQLIET_FILE];
        if (!success) return ;
    //
        sqlite3 *db = nil;
        if (sqlite3_open([SQLIET_FILE UTF8String],&db) == SQLITE_OK) {
            char *error = NULL;
            NSString *deleteSQL = [NSString stringWithFormat:@"Delete from FBBLE_TimeTable where rowid IN (Select rowid from FBBLE_TimeTable limit %d)",dataCount];
            int result = sqlite3_exec(db, deleteSQL.UTF8String, NULL, NULL, &error);
            
        // close db
            if (result == SQLITE_OK) {
                sqlite3_close(db);
                db = nil;
            }else {
                sqlite3_close(db);
                db = nil;
            }
        }else{
            sqlite3_close(db);
            db = nil;
        }
    
}

// SQLITE：获取限制的前几条
+ (NSData*)getDataOfTimeTableWithLimitCount:(int)dataCount{
    // SQLIET_FILE
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        success = [fileManager fileExistsAtPath:SQLIET_FILE];
        if (!success)  return nil;
    //
    sqlite3 *db = nil;
    NSMutableData *mutableData;
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open([SQLIET_FILE UTF8String],&db) == SQLITE_OK) {
        
        NSString *getDataSQL = [NSString stringWithFormat:@"SELECT * FROM time_table LIMIT %d", dataCount];
        int result = sqlite3_prepare_v2(db, getDataSQL.UTF8String, -1, &stmt, nil);
        if (result == SQLITE_OK) {
            mutableData = [NSMutableData data];
            
            unsigned short timeCount = [self getTimeToByte:dataCount];// 时间的条数，动态
            [mutableData appendBytes:&timeCount length:2];
            
            unsigned short eachTimeLength = 0x08;// 每条时间的长度
            [mutableData appendBytes:&eachTimeLength length:2];
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                int year = sqlite3_column_int(stmt, 1);
                unsigned short yearbyte = [self getTimeToShort:year];
                [mutableData appendBytes:&yearbyte length:2];
                
                int month = sqlite3_column_int(stmt, 2);
                unsigned char monthbyte = [self getTimeToByte:month];
                [mutableData appendBytes:&monthbyte length:1];
                
                int day = sqlite3_column_int(stmt, 3);
                unsigned char daybyte = [self getTimeToByte:day];
                [mutableData appendBytes:&daybyte length:1];
                
                int hour = sqlite3_column_int(stmt, 4);
                unsigned char hourbyte = [self getTimeToByte:hour];
                [mutableData appendBytes:&hourbyte length:1];
                
                int min = sqlite3_column_int(stmt, 5);
                unsigned char minbyte = [self getTimeToByte:min];
                [mutableData appendBytes:&minbyte length:1];
                
                int sec = sqlite3_column_int(stmt, 6);
                unsigned char secbyte = [self getTimeToByte:sec];
                [mutableData appendBytes:&secbyte length:1];
                
                unsigned char RFU = 0x00;
                [mutableData appendBytes:&RFU length:1];
                
            }
        }else {
            sqlite3_finalize(stmt);
            sqlite3_close(db);
            db = nil;
        }
    }else{
        sqlite3_finalize(stmt);
        sqlite3_close(db);
        db = nil;
    }
    
    return mutableData;
}

// SQLITE:获取数据库的条目总数
+ (int)getCountOfSqliteTimeTable{
    // SQLIET_FILE
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        success = [fileManager fileExistsAtPath:SQLIET_FILE];
        if (!success) return 0;
    
    sqlite3 *db = nil;
    int count = 0;
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open([SQLIET_FILE UTF8String],&db) == SQLITE_OK) {
        int result = sqlite3_prepare_v2(db, "SELECT COUNT(*) FROM time_table", -1, &stmt, nil);
        if (result == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                // answer
                count = sqlite3_column_int(stmt, 0);
            }
        }else {
            sqlite3_finalize(stmt);
            sqlite3_close(db);
            db = nil;
        }
    }else{
        sqlite3_finalize(stmt);
        sqlite3_close(db);
        db = nil;
    }
    
    return count;
}

// 获取当前的时间：拼接成固定格式
+ (NSData *)formatTotNSDataTimeWithCurrentTime{
    NSMutableData* mutableTimeData = [NSMutableData data];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger year = [comps year];
    unsigned short yearbyte = [self getTimeToShort:year];
    [mutableTimeData appendBytes:&yearbyte length:2];
    
    NSInteger month = [comps month];
    unsigned char monthbyte = [self getTimeToByte:month];
    [mutableTimeData appendBytes:&monthbyte length:1];
    
    NSInteger day = [comps day];
    unsigned char daybyte = [self getTimeToByte:day];
    [mutableTimeData appendBytes:&daybyte length:1];
    
    NSInteger hour = [comps hour];
    unsigned char hourbyte = [self getTimeToByte:hour];
    [mutableTimeData appendBytes:&hourbyte length:1];
    
    NSInteger min = [comps minute];
    unsigned char minbyte = [self getTimeToByte:min];
    [mutableTimeData appendBytes:&minbyte length:1];
    
    NSInteger sec = [comps second];
    unsigned char secbyte = [self getTimeToByte:sec];
    [mutableTimeData appendBytes:&secbyte length:1];
    
    unsigned char RFU = 0x00;
    [mutableTimeData appendBytes:&RFU length:1];
    
    return mutableTimeData;
}

+ (unsigned short)getTimeToShort:(NSInteger)decimal{
    // 辅助方法ToShort-数据区
    NSString *string = [JJFormat formatToHexadecimalStringWithDecimalNSUInteger:decimal]; // 16进制字符串
    return strtoul([string UTF8String],0,16);
}

+ (unsigned char)getTimeToByte:(NSInteger)decimal {
    // 辅助方法ToByte-数据区
    NSString *string = [JJFormat formatToHexadecimalStringWithDecimalNSUInteger:decimal]; // 16进制字符串
    return strtoul([string UTF8String],0,16);
}

@end
