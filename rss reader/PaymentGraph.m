//
//  PaymentGraph.m
//  rss reader
//
//  Created by Mac-Mini-3 on 10/12/15.
//  Copyright © 2015 Chinmay. All rights reserved.
//

#import "PaymentGraph.h"

@interface PaymentGraph ()
{
    NSString *lastlogentrydata;
    NSString *firstDate,*lastDate,*resultString;
    NSArray *graphValues,*graphDates;
    
}

@end

@implementation PaymentGraph

- (Database *)database {
    if(!_database) {
        _database = [[Database alloc]init];
    }
    return _database;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //call function to get time between last payment
    [self getDateInterval];
    
    //Reloading the Graph
    [self.paymentGraph reloadGraph];
    self.paymentGraph.enableBezierCurve = YES;
    
    //calling function to get up/down %
    [self getWeekUpDownPercentage];
    
    //calling function to display charts
    [self displayWeekChart];
    
    self.paymentGraph.enableTouchReport = YES;
}

- (void)getLogData {
    
    lastlogentrydata = [self.database lastLogEntry];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getDateInterval {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formatedCurrentDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"current date %@",formatedCurrentDate);
    
    NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
    [dateF setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateF setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self getLogData];
    NSLog(@"LAST LOG ENTRY DATA : %@",lastlogentrydata);
    
    NSDate *date1 = [dateF dateFromString:lastlogentrydata];
    NSDate *date2 = [dateF dateFromString:formatedCurrentDate];
    NSLog(@"Date 1 :%@",date1);
    NSLog(@"Date 2 :%@",date2);
    NSTimeInterval interval = [date2 timeIntervalSinceDate:date1];
    int hours = (int)interval / 3600;
    int minutes = (interval - (hours*3600)) / 60;
    NSString *timeDiff = [NSString stringWithFormat:@"%d hours %02d minutes",hours,minutes];
    self.timeSincePayment.text = timeDiff;
    
}

- (void)getWeekUpDownPercentage {
    NSDate *weekDate = [NSDate date];
    NSCalendar *celender = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *curntDateComponents = [celender components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:weekDate];
    int ff = (int)curntDateComponents.weekOfYear;
    [curntDateComponents setWeekday:1];     //sunday
    NSDate *firstDayOfTheWeek = [celender dateFromComponents:curntDateComponents];
    
    [curntDateComponents setWeekday:7];     //satrday
    NSDate *lastDayOfTheWeek = [celender dateFromComponents:curntDateComponents];
    
    [curntDateComponents setWeekday:1];
    [curntDateComponents setWeekOfYear:ff-1];
    NSDate *firstDayOfPreviousWeek = [celender dateFromComponents:curntDateComponents];
    
    [curntDateComponents setWeekday:7];
    [curntDateComponents setWeekOfYear:ff-1];
    NSDate *lastDayOfPreviousWeek = [celender dateFromComponents:curntDateComponents];
    
    
    NSLog(@"FDOPW : %@",firstDayOfPreviousWeek);
    NSLog(@"LDOPW : %@",lastDayOfPreviousWeek);
    NSLog(@"FDOW : %@",firstDayOfTheWeek);
    NSLog(@"LDOW : %@",lastDayOfTheWeek);
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMM dd,yyyy"];
    
    /*
    NSString *firstday1 = [format stringFromDate:firstDayOfTheWeek];
    NSString *firstdayend1 = [format stringFromDate:lastDayOfTheWeek];
    NSString *firstday2 = [format stringFromDate:firstDayOfPreviousWeek];
    NSString *firstdayend2 = [format stringFromDate:lastDayOfPreviousWeek];
    
    NSLog(@"FDOPW : %@",firstday1);
    NSLog(@"LDOPW : %@",firstdayend1);
    NSLog(@"FDOW : %@",firstday2);
    NSLog(@"LDOW : %@",firstdayend2);
    */
    NSInteger value = [self.database percentageCalculatn:firstDayOfPreviousWeek lastDayOfPreviousWeek:lastDayOfPreviousWeek firstDayOfWeek:firstDayOfTheWeek lastDayOfWeek:lastDayOfTheWeek];
    
    NSLog(@"VVVVVAAAAALLLLLUUUEEE :%ld",(long)value);
    
    NSString *valuestring = [NSString stringWithFormat:@"%ld", (long)value];
    //NSString *valuestring = @"-25";
    NSLog(@"VALUESTRING : %@",valuestring);
   
    
    if ([self doesString:valuestring containCharacter:'-']) {
        
        
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        resultString = [[valuestring componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        NSLog (@"Result: %@", resultString);
        
        
        NSString *negativeString = @"Down by ";
        negativeString = [negativeString stringByAppendingString:resultString];
        negativeString = [negativeString stringByAppendingString:@"%"];
        
        self.upDownPercent.text = negativeString;
        NSLog(@"NEGATIVE VALUE%@",valuestring);
    }
    else {
        
        NSString *positiveString = @"Up by ";
        positiveString = [positiveString stringByAppendingString:valuestring];
        positiveString = [positiveString stringByAppendingString:@"%"];
        
        self.upDownPercent.text = positiveString;
        NSLog(@"POSITIVE VALUE%@",valuestring);
    }
}

-(BOOL)doesString:(NSString *)string containCharacter:(char)character
{
    if ([string rangeOfString:[NSString stringWithFormat:@"%c",character]].location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

- (void) displayWeekChart {
    NSDictionary *dataOfWeek = [[NSDictionary alloc]init];
    dataOfWeek = [self.database weekLogChart:firstDate lastDayOfWeek:lastDate];
    
    NSArray *weekCount = [dataOfWeek allKeys];
    NSArray *weekDate = [dataOfWeek allValues];
    
    if([weekDate count]>1) {
        graphValues = [weekCount copy];
        graphDates = [weekDate copy];
        
        [self hydrateDatasets];
        
        //NSLog(@"keys = %@ values = %@ and graphValues =%@ and graphDates=%@",weekCount,weekDate,graphValues,graphDates);
        //NSLog(@"Array of values = %lu",(unsigned long)[self.arrayOfValues count]);
        //NSLog(@"Key of values = %@",[[]self.arrayOfValues objectAtIndex:index] doubleValue]);
        [self.paymentGraph reloadGraph];
        
    }
    else {
        [self displayAlert:@"Insuffecient Data to plat Graph"];
    }
}

- (void) displayMonthlyChart {
    NSDictionary *dataOfMonth = [[NSDictionary alloc]init];
    dataOfMonth = [self.database monthLogChart:firstDate lastDayOfMonth:lastDate];
    
    NSArray *monthCount = [dataOfMonth allKeys];
    NSArray *monthDate = [dataOfMonth allValues];
    
    if([monthCount count]>1) {
        graphValues = [monthCount copy];
        graphDates = [monthDate copy];
        
        [self hydrateDatasets];
        
        [self.paymentGraph reloadGraph];
    }
    else {
        [self displayAlert:@"Insuffecient Data To plot Graph"];
    }
}

- (void) displayYearlyChart {
    NSDictionary *dataOfYear = [[NSDictionary alloc]init];
    dataOfYear = [self.database yearlyLogChart:firstDate];
    
    NSArray *yearCount = [dataOfYear allKeys];
    NSArray *yearDate = [dataOfYear allValues];
    
    if([yearCount count]>1) {
        graphValues = [yearCount copy];
        graphDates = [yearDate copy];
        
        [self hydrateDatasets];
        
        [self.paymentGraph reloadGraph];
    }
    else {
        [self displayAlert:@"Insuffecient Data To plot Graph"];
    }
}


- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.arrayOfValues count];   // Number of points in the graph.
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue]; // The value of the point on the Y-Axis for the index.
}


- (void)hydrateDatasets {
    // Reset the arrays of values (Y-Axis points) and dates (X-Axis points / labels)
    if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];
    for(int i=0; i<[graphValues count]; i++) {
        
        [self.arrayOfValues addObject:graphDates[i]];
        [self.arrayOfDates addObject:graphValues[i]];
        
    }
    
}


- (IBAction)btn7Days:(id)sender {
    
    [self displayWeekChart];
}

- (IBAction)btn1Month:(id)sender {
    
    [self displayMonthlyChart];
}

- (IBAction)btn1Year:(id)sender {
    
    [self displayYearlyChart];
}

-(void) displayAlert: (NSString *) msg
{
    UIAlertView *displayAlert = [[UIAlertView alloc] initWithTitle:@"License Expiry Tracker" message:msg delegate:nil cancelButtonTitle:@"OK"                                                otherButtonTitles: nil];
    [displayAlert show];
}
@end
