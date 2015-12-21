//
//  ListAllScreen.m
//  rss reader
//
//  Created by Mac-Mini-3 on 10/12/15.
//  Copyright © 2015 Chinmay. All rights reserved.
//

#import "ListAllScreen.h"

@interface ListAllScreen ()
{
    NSArray *resultSearch;
    NSMutableArray *dataSearch;
}

@end

@implementation ListAllScreen
{
    NSMutableArray *arrayList;
    int value;
}

- (Database *)database {
    if(!_database) {
        _database = [[Database alloc]init];
    }
    return _database;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tblListDetails.dataSource = self;
    self.tblListDetails.delegate = self;
    [self.database createOrOpenDB];
    
    arrayList = [self.database listDetails];
    resultSearch = [self.database listDetails];
    NSLog(@"arrayList count = %lu",(unsigned long)[arrayList count]);
    
    [self.tblListDetails reloadData];
    
    [self tocLoad];
    
    NSLog(@"%@",arrayList);
    dataSearch = [[NSMutableArray alloc]init];
    resultSearch = [[NSMutableArray alloc]init];
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, 375, 44)];
    CGRect newBounds = [[self tblListDetails]bounds];
    newBounds.origin.y = newBounds.origin.y + searchBar.bounds.size.height;
    [[self tblListDetails]setBounds:newBounds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tocLoad {
    dispatch_async(dispatch_get_main_queue(), ^{ [self.tblListDetails reloadData]; });
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
        [self.tblListDetails setEditing:YES animated:YES];
        self.tblListDetails.allowsSelectionDuringEditing=YES;
        self.editBtn.title = @"Done";
    }
    else {
        [self.tblListDetails setEditing:NO animated:YES];
        self.editBtn.title = @"Edit";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.tblListDetails.dataSource = self;
    self.tblListDetails.delegate = self;
    
    arrayList= [self.database listDetails];
    NSLog(@"arrayList count=%lu",(unsigned long)[arrayList count]);
    
    [self reloadInputViews];
    [self.tblListDetails reloadData];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [resultSearch count];
    }
    else {
        return [arrayList count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    Database *aPerson = [arrayList objectAtIndex:indexPath.row];
    //Database *search = [searchResults objectAtIndex:indexPath.row];
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [resultSearch objectAtIndex:indexPath.row];
        //cell.detailTextLabel.text = search.expiryDate;
        
    }
    else {
        cell.textLabel.text =  aPerson.name;
        cell.detailTextLabel.text = aPerson.expiryDate;
        NSLog(@"Name = %@",aPerson.name);
        
        [dataSearch addObject:aPerson.name];
    }
    NSLog(@"searchDATA=%@",dataSearch);
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0)
    {
        [self.tblListDetails reloadData];
        NSLog(@"Cancled Action");
    }
    else
    {
        Database *a = [arrayList objectAtIndex:value];
        [self.database deleteData:a.name];
        [arrayList removeObjectAtIndex:value];
        [self.tblListDetails reloadData];
        NSLog(@"OK Action %d",value);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tblListDetails.editing) {
        
        //EditView *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editView"];
        
        //editVC.orgLicenseName = [arrayList objectAtIndex:indexPath.row];
        //editVC.orgExpiryDate = [arrayList objectAtIndex:indexPath.row];
        //[self presentViewController:editVC animated:YES completion:nil];
    }
}

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@",searchText];
    
    resultSearch = [dataSearch filteredArrayUsingPredicate:predicate];
    
    NSLog(@"SEARCHTEXT = %@",searchText);
    NSLog(@"SEARCH RESULTS = %@",resultSearch);
    NSLog(@"SEARCH DATA = %@",dataSearch);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}


@end
