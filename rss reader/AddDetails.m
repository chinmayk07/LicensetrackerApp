//
//  AddDetails.m
//  rss reader
//
//  Created by Mac-Mini-3 on 10/12/15.
//  Copyright © 2015 Chinmay. All rights reserved.
//

#import "AddDetails.h"

@interface AddDetails ()

@end

@implementation AddDetails

NSString *datechanged;

- (Database *)database {
    if(!_database){
        _database = [[Database alloc]init];
    }
    return _database;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.database createOrOpenDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.licenceName endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) Notify {
    NSDate *fireDate = [[NSDate alloc]init];
    fireDate = self.datePicker.date;
    NSLog(@"The orginal date is %@",fireDate);
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComp = [cal components:(NSCalendarUnitHour | NSCalendarUnitMinute| NSCalendarUnitSecond)
                                        fromDate:fireDate];
    [dateComp setHour: -24];
    [dateComp setMinute:0];
    [dateComp setSecond:+20];
    
    NSDate *dd = [cal dateByAddingComponents:dateComp toDate:fireDate options:0];
    NSLog(@"The modified date is %@",dd);
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    [notification setFireDate:dd];
    
    NSString *alert1 = @"HI ";
    alert1 = [alert1 stringByAppendingString:self.licenceName.text];
    alert1 = [alert1 stringByAppendingString:@" Will Expire tommorrow"];
    [notification setAlertBody:alert1];
    [notification setAlertAction:@"View in App"];
    
    NSUInteger nextBadgeNumber = [[[UIApplication sharedApplication]scheduledLocalNotifications]count]+1;
    [notification setApplicationIconBadgeNumber:nextBadgeNumber];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    NSString *display = [NSDateFormatter localizedStringFromDate:dd dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
    self.expiryDate.text = display;
    
}


- (IBAction)dateChanged:(id)sender {
    
    NSDateFormatter *datef = [[NSDateFormatter alloc]init];
    [datef setDateFormat:@"yyyy-MM-dd"];
    datechanged = [datef stringFromDate:self.datePicker.date];
    self.expiryDate.text = datechanged;
}

- (IBAction)btnSave:(id)sender {
    
    if([self.licenceName.text isEqualToString:@""])
    {
        /*UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Licence Name is Mandatory" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [errorAlert show];
         */
        [self displayAlert:@"Licence Name is Mandatory..!"];
    }
    else
    {
        NSDate *now = [NSDate date];
        NSComparisonResult result = [now compare:self.datePicker.date];
        
        if(result == 1)
        {
            [self displayAlert:@"Invalid Expiry Date"];
        }
        else
        {
            [self Notify];
            
            int reslt = [self.database insertData:self.licenceName.text expiryDate:datechanged];
            if(reslt == 1) {
                
                [self displayAlert:@"Data Entered Successfully"];
                self.licenceName.text=@"";
                self.expiryDate.text=@"";
                [self.datePicker setDate:[NSDate date]];
                
            }
        }
    }

}

- (IBAction)btnCancel:(id)sender {
    
    self.licenceName.text = [NSString stringWithFormat:@""];
    [self.tabBarController setSelectedIndex:1];
}

-(void) displayAlert: (NSString *) msg
{
    UIAlertView *displayAlert = [[UIAlertView alloc] initWithTitle:@"ALERT" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [displayAlert show];
}
@end
