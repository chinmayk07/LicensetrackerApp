//
//  HomeScreen.m
//  rss reader
//
//  Created by Mac-Mini-3 on 10/12/15.
//  Copyright © 2015 Chinmay. All rights reserved.
//

#import "HomeScreen.h"

@interface HomeScreen ()
{
    NSArray *searchResults;
    NSMutableArray *searchData;
}
@property (nonatomic,strong) NSMutableArray *searchUpcomingResult;

@end

@implementation HomeScreen
{
    NSMutableArray *upComingArray;
    int value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tblUpcomingList.dataSource = self;
    self.tblUpcomingList.delegate = self;
    [self.database createOrOpenDB];
    
    [self.tblUpcomingList reloadData];
    
    upComingArray= [self.database listDetails];
    searchResults = [self.database listDetails];
    NSLog(@"arrayList count=%lu",(unsigned long)[upComingArray count]);
    NSLog(@"searchresults count=%lu",(unsigned long)[searchResults count]);    
    
    NSLog(@"%@",upComingArray);
    searchData = [[NSMutableArray alloc]init];
    searchResults = [[NSArray alloc]init];
    
    UISearchBar *searchBarHome = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, 375, 44)];
    
    CGRect newBounds = [[self tblUpcomingList]bounds];
    newBounds.origin.y = newBounds.origin.y + searchBarHome.bounds.size.height;
    [[self tblUpcomingList]setBounds:newBounds];
}

- (Database *)database {
    if(!_database) {
        _database = [[Database alloc]init];
    }
    return _database;
}

- (void)viewWillAppear:(BOOL)animated {
    //[super viewWillAppear];
    
    //self.tblUpcomingList.dataSource = self;
    //self.tblUpcomingList.delegate = self;
    //[self.database createOrOpenDB];
    [self getDate];
    
    [self.tblUpcomingList reloadData];
    [self reloadInputViews];
    NSLog(@"second");
    
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

- (IBAction)btnEdit:(id)sender {
    
    NSString *title = self.editBtn.title;
    NSLog(@"%@",title);
    if([title isEqualToString:@"Edit"]) {
        [self.tblUpcomingList setEditing:YES animated:YES];
        self.tblUpcomingList.allowsSelectionDuringEditing = YES;
        self.editBtn.title = @"Done";
    }
    else {
        [self.tblUpcomingList setEditing:NO animated:YES];
        self.editBtn.title = @"Edit";
        
    }
}

-(void) getDate
{
    NSDate *now = [[NSDate alloc]init];
    NSDateFormatter *formatedDate = [[NSDateFormatter alloc]init];
    [formatedDate setDateFormat:@"yyyy-MM-dd"];
    NSString *datechanged = [formatedDate stringFromDate:now];
    NSDate *weekLater = [now dateByAddingTimeInterval:+7*24*60*60];
    NSString *formatedWeekLaterDate = [formatedDate stringFromDate:weekLater];
    
    upComingArray = [[NSMutableArray alloc]init];
    
    upComingArray = [self.database listUpcomingDetails: datechanged fromDate:formatedWeekLaterDate];
    //NSLog(@"Upcoming = %ld",[upComingArray count]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else {
        return [upComingArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    Database *aPerson = [upComingArray objectAtIndex:indexPath.row];
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [searchResults objectAtIndex:indexPath.row];
        //[searchData addObject:aPerson.name];
    }
    else {
        cell.textLabel.text =  aPerson.name;
        cell.detailTextLabel.text = aPerson.expiryDate;
        NSLog(@"Name = %@",aPerson.name);
        
        [searchData addObject:aPerson.name];
        //[searchData addObject:aPerson.expiryDate];
    }
    NSLog(@"searchDATA=%@",searchData);
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Confirm Delete" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [errorAlert show];
        
        NSLog(@"ROW number %ld",indexPath.row);
        
        value = (int)indexPath.row;
        
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tblUpcomingList.editing) {
        
        EditView *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editView"];
        
        //editVC.orgLicenseName = [arrayList objectAtIndex:indexPath.row];
        //editVC.orgExpiryDate = [arrayList objectAtIndex:indexPath.row];
        [self presentViewController:editVC animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0)
    {
        // Database *a = [arrayList ob]
        [self.tblUpcomingList reloadData];
        
        NSLog(@"Cancled Action");
    }
    else
    {
        Database *a = [upComingArray objectAtIndex:value];
        [self.database deleteData:a.name];
        [upComingArray removeObjectAtIndex:value];
        [self.tblUpcomingList reloadData];
        NSLog(@"OK Action %d",value);
    }
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@",searchText];
    searchResults = [searchData filteredArrayUsingPredicate:predicate];
    NSLog(@"SEARCH TEXT = %@",searchText);
    NSLog(@"SEARCH RESULTS = %@",searchResults);
    NSLog(@"SEARCH DATA = %@",searchData);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}


@end
