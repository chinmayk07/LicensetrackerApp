//
//  Database.h
//  rss reader
//
//  Created by Mac-Mini-3 on 10/12/15.
//  Copyright © 2015 Chinmay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface Database : NSObject


@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *expiryDate;
@property(nonatomic,strong)NSString *logDate;
@property(nonatomic,strong)NSString *lastLogDate;

- (void)createOrOpenDB;
//- (void)createOrOpenDBLog;

- (NSDictionary *)yearlyLogChart:(NSString *)currentYear;
- (NSDictionary *) monthLogChart:(NSString *)firstDayOfTheMonth lastDayOfMonth:(NSString *)lastDayOfMonth;
- (NSDictionary *) weekLogChart:(NSString *)firstDayOfTheWeek lastDayOfWeek:(NSString *)lastDayOfWeek;


- (int)insertLogData:(NSDate *)logDate;
- (int)insertData:(NSString *)licenseName expiryDate:(NSString *)expiryDate;
- (NSMutableArray *) listUpcomingDetails:(NSString *)toDate fromDate:(NSString *) fromDate;
- (NSMutableArray *) listDetails;
- (NSMutableArray *) listLogDetails;
- (NSString *) lastLogEntry;
- (void)deleteData:(NSString *)deleteQuery;
- (int)updateData:(NSString *)orgLicenseName uLicenseName:(NSString *)uLicenceName uexpiryDate:(NSString *)uExpiryDate;
- (NSInteger)percentageCalculatn:(NSString *)firstDayOfPreviosWeek lastDayOfPreviousWeek:(NSString *)lastDayOfPreviousWeek
                  firstDayOfWeek: (NSString *)firstDayOfTheWeek lastDayOfWeek:(NSString *)lastDayOfWeek;


@end
