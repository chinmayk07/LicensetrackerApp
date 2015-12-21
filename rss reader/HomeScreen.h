//
//  HomeScreen.h
//  rss reader
//
//  Created by Mac-Mini-3 on 10/12/15.
//  Copyright © 2015 Chinmay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "AddDetails.h"
#import "EditView.h"

@interface HomeScreen : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic,strong)Database *database;

@property (weak, nonatomic) IBOutlet UITableView *tblUpcomingList;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarHome;

- (IBAction)btnEdit:(id)sender;
@end
