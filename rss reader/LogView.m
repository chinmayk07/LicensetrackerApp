//
//  LogView.m
//  rss reader
//
//  Created by Mac-Mini-3 on 10/12/15.
//  Copyright © 2015 Chinmay. All rights reserved.
//

#import "LogView.h"

@interface LogView ()
{
    NSMutableArray *noOfLogEntries;
}

@end

@implementation LogView

NSString *presentdate;

- (Database *)database {
    if(!_database) {
        _database = [[Database alloc]init];
    }
    return _database;
}

- (void)getLogData {
    
    noOfLogEntries = [self.database listLogDetails];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tblLogView.dataSource = self;
    self.tblLogView.delegate = self;
    // Do any additional setup after loading the view.
    //[self.database createOrOpenDBLog];
    [self getLogData];
    [self GetCurrentTime];
    [self.tblLogView reloadData];
    NSLog(@"LOG DATA : %@",noOfLogEntries);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)GetCurrentTime {
    
    NSDateFormatter *datel = [[NSDateFormatter alloc]init];
    [datel setDateFormat:@"EEEE HH:mm aa | MMMM dd, yyyy"];
    self.lblcurrentDate.text = [datel stringFromDate:[NSDate date]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.tblLogView.dataSource = self;
    self.tblLogView.delegate = self;
    [self getLogData];
    
    [self GetCurrentTime];
    [self.tblLogView reloadData];    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [noOfLogEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [noOfLogEntries objectAtIndex:indexPath.row];
    
    NSLog(@"LOG DATA : %@",noOfLogEntries);
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnLog:(id)sender {
    
    NSDateFormatter *datel = [[NSDateFormatter alloc]init];
    [datel setDateFormat:@"EEEE HH:mm aa | MMMM dd, yyyy "];
    self.lblcurrentDate.text = [datel stringFromDate:[NSDate date]];
    
    NSDate *currDate = [NSDate date];
    
    //NSLog(@"Logged %@",self.lblcurrentDate.text);
    NSLog(@"Logged CURRDATE %@",currDate);
    
    int results = [self.database insertLogData:currDate];
    //int results = [self.database insertLogData:self.lblcurrentDate.text];
    if(results == 1) {
        [self displayAlert:@"Date and time Logged"];
    }
    [self.tblLogView reloadData];
}

-(void) displayAlert: (NSString *) msg
{
    UIAlertView *displayAlert = [[UIAlertView alloc] initWithTitle:@"DATE LOGGED" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [displayAlert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0)
    {
        // Database *a = [arrayList ob]
        [self.tblLogView reloadData];
        
        NSLog(@"Cancled Action");
    }
}
@end
