//
//  Database.m
//  rss reader
//
//  Created by Mac-Mini-3 on 10/12/15.
//  Copyright © 2015 Chinmay. All rights reserved.
//

#import "Database.h"

NSMutableArray *arrayOfPerson, *arrayOfUpcomingList, *arrayOfLogs;
sqlite3 *personDB;
NSString *dbPathString ,*dbPathString1, *lastlogdate;

@implementation Database

- (void)createOrOpenDB
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docPath = [path objectAtIndex:0];
    
    dbPathString = [docPath stringByAppendingPathComponent:@"person.db"];
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        
        if(sqlite3_open(dbPath, &personDB)== SQLITE_OK) {
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS PERSONS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, DATE TEXT);"
            "CREATE TABLE IF NOT EXISTS LICENSELOG (ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, LOG_TIME DATETIME DEFAULT(DATETIME(CURRENT_TIMESTAMP,'LOCALTIME')));";
            sqlite3_exec(personDB, sql_stmt, NULL, NULL, &error);
            sqlite3_close(personDB);
        }
    }
}

/*- (void)createOrOpenDBLog
 {
 NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
 NSString *docPath = [path objectAtIndex:0];
 
 dbPathString1 = [docPath stringByAppendingPathComponent:@"person.db"];
 
 char *error;
 
 NSFileManager *fileManager = [NSFileManager defaultManager];
 if(![fileManager fileExistsAtPath:dbPathString]) {
 const char *dbPath = [dbPathString1 UTF8String];
 
 if(sqlite3_open(dbPath, &personDB)== SQLITE_OK) {
 //const char *sql_stmt = "CREATE TABLE IF NOT EXISTS LICENSELOG (ID INTEGER PRIMARY KEY AUTOINCREMENT, DATE DATE)";
 const char *sql_stmt = "CREATE TABLE IF NOT EXISTS LICENSELOG (ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, LOG_TIME DATETIME DEFAULT(DATETIME(CURRENT_TIMESTAMP,'LOCALTIME')))";
 sqlite3_exec(personDB, sql_stmt, NULL, NULL, &error);
 sqlite3_close(personDB);
 }
 }
 }*/

- (int)insertData:(NSString *)licenseName expiryDate:(NSString *)expiryDate
{
    char *error;
    if(sqlite3_open([dbPathString UTF8String], &personDB)== SQLITE_OK) {
        
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO PERSONS(NAME,DATE) values ('%@' , '%@')",licenseName,expiryDate];
        const char *insert_stmt = [insertStmt UTF8String];
        if(!(sqlite3_exec(personDB, insert_stmt, NULL, NULL, &error)== SQLITE_OK)) {
            NSLog(@"error");
            return 0;
        }
        sqlite3_close(personDB);
    }
    return 1;
}

- (int)insertLogData:(NSDate *)logDate
{
    char *error;
    if(sqlite3_open([dbPathString UTF8String], &personDB)== SQLITE_OK) {
        
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO LICENSELOG(LOG_TIME) values (datetime(CURRENT_TIMESTAMP, 'LOCALTIME'))"];
        
        const char *insert_stmt = [insertStmt UTF8String];
        
        if(!(sqlite3_exec(personDB, insert_stmt, NULL, NULL, &error)== SQLITE_OK)) {
            NSLog(@"error");
            return 0;
        }
        sqlite3_close(personDB);
    }
    return 1;
}


- (int)updateData:(NSString *)orgLicenseName uLicenseName:(NSString *)uLicenceName uexpiryDate:(NSString *)uExpiryDate
{
    
    char *error;
    if(sqlite3_open([dbPathString UTF8String], &personDB)== SQLITE_OK) {
        
        NSString *insertStmt = [NSString stringWithFormat:@"UPDATE PERSONS SET NAME = '%@' ,DATE = '%@' WHERE NAME = '%@'", uLicenceName,uExpiryDate,orgLicenseName];
        
        const char *insert_stmt = [insertStmt UTF8String];
        
        if(!(sqlite3_exec(personDB, insert_stmt, NULL, NULL, &error)== SQLITE_OK)) {
            NSLog(@"error");
            return 0;
        }
        sqlite3_close(personDB);
    }
    return 1;
}

- (NSMutableArray *) listDetails
{
    arrayOfPerson = [[NSMutableArray alloc]init ];
    //  NSMutableDictionary *finalDictonary = [[NSMutableDictionary alloc] init];
    sqlite3_stmt *statement=NULL;
    
    if(sqlite3_open([dbPathString UTF8String], &personDB)== SQLITE_OK) {
        NSString *querySql = @"SELECT * FROM PERSONS";
        const char* query_sql = [querySql UTF8String];
        
        if(sqlite3_prepare(personDB, query_sql, -1, &statement, NULL)== SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSString *expiryDate = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                Database *person = [[Database alloc]init];
                
                [person setName:name];
                [person setExpiryDate:expiryDate];
                
                [arrayOfPerson addObject:person];
                
                //NSLog(@"%@ %@",expiryDate ,name);
            }
        }
    }
    //NSLog(@"finalDictonary=%@",arrayOfPerson);
    return arrayOfPerson;
}

- (NSMutableArray *) listUpcomingDetails:(NSString *)toDate fromDate:(NSString *) fromDate
{
    arrayOfUpcomingList = [[NSMutableArray alloc]init ];
    sqlite3_stmt *statement=NULL;
    
    if(sqlite3_open([dbPathString UTF8String], &personDB)== SQLITE_OK) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM PERSONS where DATE BETWEEN '%@' AND '%@'",toDate,fromDate ];
        const char* query_sql = [querySql UTF8String];
        
        if(sqlite3_prepare(personDB, query_sql, -1, &statement, NULL)== SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSString *expiryDate = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                Database *person = [[Database alloc]init];
                
                [person setName:name];
                [person setExpiryDate:expiryDate];
                
                [arrayOfUpcomingList addObject:person];
            }
        }
    }
    //NSLog(@"finalDictonary=%@",arrayOfUpcomingList);
    return arrayOfUpcomingList;
}


- (NSMutableArray *) listLogDetails
{
    
    
    arrayOfLogs = [[NSMutableArray alloc]init ];
    //  NSMutableDictionary *finalDictonary = [[NSMutableDictionary alloc] init];
    sqlite3_stmt *statement=NULL;
    
    if(sqlite3_open([dbPathString UTF8String], &personDB)== SQLITE_OK) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM LICENSELOG"];
        const char* query_sql = [querySql UTF8String];
        
        if(sqlite3_prepare(personDB, query_sql, -1, &statement, NULL)== SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
    
                NSString *logDate = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                
                Database *logs = [[Database alloc]init];
                
                [logs setLogDate:logDate];
                NSArray *trial = [[NSArray alloc]initWithObjects:logDate, nil];
                [arrayOfLogs addObjectsFromArray:trial];
            }
        }
    }
    NSLog(@"Logs=%@",arrayOfLogs);
    return arrayOfLogs;
}

- (NSString *) lastLogEntry
{
    
    NSString *lastlogdate = [[NSString alloc]init];
    sqlite3_stmt *statement=NULL;
    
    if(sqlite3_open([dbPathString UTF8String], &personDB)== SQLITE_OK) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT ID,LOG_TIME FROM LICENSELOG ORDER BY ID DESC LIMIT 1"];
        const char* query_sql = [querySql UTF8String];
        
        if(sqlite3_prepare(personDB, query_sql, -1, &statement, NULL)== SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
    
                NSString *lastdata = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                lastlogdate = lastdata ;
            }
        }
    }
    NSLog(@"Last Entry = %@",lastlogdate);
    return lastlogdate;
}

- (void)deleteData:(NSString *)deleteName {
    
    NSString *deleteRow = [NSString stringWithFormat:@"DELETE FROM PERSONS WHERE NAME = '%@'",deleteName];
    const char* deleteQuery = [deleteRow UTF8String];
    sqlite3_stmt *statement = NULL;
    
    if(sqlite3_prepare_v2(personDB, deleteQuery, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error preparing %@", deleteRow);
        NSLog(@"PersonDeleted");
        return;
    }
    if(sqlite3_step(statement)!= SQLITE_DONE) {
        NSLog(@"Error running delete: %s",deleteQuery);
        return;
    }
}

- (NSInteger)percentageCalculatn:(NSString *)firstDayOfPreviosWeek lastDayOfPreviousWeek:(NSString *)lastDayOfPreviousWeek
                  firstDayOfWeek: (NSString *)firstDayOfTheWeek lastDayOfWeek:(NSString *)lastDayOfWeek
{
    NSInteger lastWeekCount = 0, currentWeekCount = 0, finalResult = 0;
    currentWeekCount = [self getCurrentWeekCOunt:firstDayOfTheWeek lastDayOfWeek:lastDayOfWeek];
    lastWeekCount = [self getPreviousWeekCount:firstDayOfPreviosWeek lastDayOfWeek:lastDayOfPreviousWeek];
    if(lastWeekCount == 0) {
        finalResult = currentWeekCount;
    }
    else
    {
        finalResult = ((currentWeekCount - lastWeekCount)*100)/100;
    }
    NSLog(@"%ld",finalResult);
    return finalResult;
}

- (NSInteger)getCurrentWeekCOunt:(NSString *)firstDayOfTheWeek lastDayOfWeek:(NSString *)lastDayOfTheWeek {
    
    NSInteger currentWeekCount = 0;
    
    sqlite3_stmt *statement=NULL;
    
    if(sqlite3_open([dbPathString UTF8String], &personDB)== SQLITE_OK) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT COUNT(LOG_TIME) FROM LICENSELOG where LOG_TIME BETWEEN '%@' AND '%@'",firstDayOfTheWeek,lastDayOfTheWeek ];
        const char* query_sql = [querySql UTF8String];
        
        if(sqlite3_prepare(personDB, query_sql, -1, &statement, NULL)== SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *totalCount = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                currentWeekCount = [totalCount integerValue];
            }
        }
    }
    NSLog(@"%ld",(long)currentWeekCount);
    return currentWeekCount;
}


-(NSInteger) getPreviousWeekCount:(NSString *)firstDayOfPreviousWeek lastDayOfWeek:(NSString *)lastDayOfPreviousWeek {
    
    NSInteger lastWeekCount = 0;
    
    sqlite3_stmt *statement=NULL;
    
    if(sqlite3_open([dbPathString UTF8String], &personDB)== SQLITE_OK) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT COUNT(LOG_TIME) FROM LICENSELOG where LOG_TIME BETWEEN '%@' AND '%@'",firstDayOfPreviousWeek,lastDayOfPreviousWeek ];
        const char* query_sql = [querySql UTF8String];
        
        if(sqlite3_prepare(personDB, query_sql, -1, &statement, NULL)== SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *totalCount1 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                lastWeekCount = [totalCount1 integerValue];
            }
        }
    }
    NSLog(@"%ld",(long)lastWeekCount);
    return lastWeekCount;
}


-(NSDictionary *) weekLogChart:(NSString *)firstDayOfTheWeek lastDayOfWeek:(NSString *)lastDayOfWeek {
    NSMutableDictionary *weeklyLog = [[NSMutableDictionary alloc]init];
    sqlite3_stmt *statement=NULL;
    
    if(sqlite3_open([dbPathString UTF8String], &personDB)== SQLITE_OK) {
        NSString *querySql = @"Select count(LOG_TIME),strftime('%d/%m',LOG_TIME)  from LICENSELOG where LOG_TIME BETWEEN '2015-12-17' AND '2015-12-23' group by strftime('%d %m %Y',LOG_TIME)";
        const char* query_sql = [querySql UTF8String];
        
        if(sqlite3_prepare(personDB, query_sql, -1, &statement, NULL)== SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                NSString *weeklyLogCount = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                NSString *weeklyLogDate= [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:weeklyLogCount,weeklyLogDate, nil];
                
                [weeklyLog addEntriesFromDictionary:dict];
                
            }
        }
    }
    NSLog(@"%@",weeklyLog);
    return weeklyLog;
}


- (NSDictionary *) monthLogChart:(NSString *)firstDayOfTheMonth lastDayOfMonth:(NSString *)lastDayOfMonth {
    NSMutableDictionary *monthlyLog = [[NSMutableDictionary alloc]init];
    sqlite3_stmt *statement=NULL;
    
    if(sqlite3_open([dbPathString UTF8String], &personDB)== SQLITE_OK) {
        NSString *querySql = [NSString stringWithFormat:@"Select count(LOG_TIME),strftime('%@/%m',LOG_TIME)  from LICENSELOG  where LOG_TIME BETWEEN '%@' AND '%@' group by strftime('%d %m %Y',LOG_TIME)",firstDayOfTheMonth,lastDayOfMonth ];
        const char* query_sql = [querySql UTF8String];
        
        if(sqlite3_prepare(personDB, query_sql, -1, &statement, NULL)== SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                NSString *monthlyLogCount = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                NSString *monthlyLogDate= [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:monthlyLogCount,monthlyLogDate, nil];
                
                [monthlyLog addEntriesFromDictionary:dict];
                
            }
        }
    }
    NSLog(@"%@",monthlyLog);
    return monthlyLog;
}

- (NSDictionary *)yearlyLogChart:(NSString *)currentYear {
    
    NSMutableDictionary *yearlyLog = [[NSMutableDictionary alloc]init];
    sqlite3_stmt *statement=NULL;
    
    if(sqlite3_open([dbPathString UTF8String], &personDB)== SQLITE_OK) {
        NSString *querySql = @"Select count(LOG_TIME),strftime('%d/%m',LOG_TIME)  from LICENSELOG  where LOG_TIME BETWEEN '2015-11-01' AND '2015-11-30' group by strftime('%d %m %Y',LOG_TIME)";
        const char* query_sql = [querySql UTF8String];
        
        if(sqlite3_prepare(personDB, query_sql, -1, &statement, NULL)== SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                NSString *yearlyLogCount = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                NSString *yearlyLogDate= [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:yearlyLogCount,yearlyLogDate, nil];
                
                [yearlyLog addEntriesFromDictionary:dict];
                
            }
        }
    }
    NSLog(@"%@",yearlyLog);
    return yearlyLog;
    
}


@end
