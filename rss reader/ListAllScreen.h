//
//  ListAllScreen.h
//  rss reader
//
//  Created by Mac-Mini-3 on 10/12/15.
//  Copyright © 2015 Chinmay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "AddDetails.h"
#import "EditView.h"

@interface ListAllScreen : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate >

@property (nonatomic,strong) Database *database;

@property (weak, nonatomic) IBOutlet UITableView *tblListDetails;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;

- (IBAction)btnEdit:(id)sender;
@end
