//
//  AddDetails.h
//  rss reader
//
//  Created by Mac-Mini-3 on 10/12/15.
//  Copyright © 2015 Chinmay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"

@interface AddDetails : UIViewController

@property (nonatomic,strong) Database *database;

@property (weak, nonatomic) IBOutlet UITextField *licenceName;

@property (weak, nonatomic) IBOutlet UILabel *expiryDate;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)dateChanged:(id)sender;

- (IBAction)btnSave:(id)sender;

- (IBAction)btnCancel:(id)sender;

@end
