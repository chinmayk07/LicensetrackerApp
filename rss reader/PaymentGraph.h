//
//  PaymentGraph.h
//  rss reader
//
//  Created by Mac-Mini-3 on 10/12/15.
//  Copyright © 2015 Chinmay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "BEMSimpleLineGraphView.h"

@interface PaymentGraph : UIViewController <BEMSimpleLineGraphDataSource,BEMSimpleLineGraphDelegate>

@property (nonatomic,strong) Database *database;
@property (strong,nonatomic) NSMutableArray *arrayOfValues;
@property (strong,nonatomic) NSMutableArray *arrayOfDates;

@property (weak, nonatomic) IBOutlet UILabel *timeSincePayment;
@property (weak, nonatomic) IBOutlet UILabel *upDownPercent;

- (IBAction)btn7Days:(id)sender;
- (IBAction)btn1Month:(id)sender;
- (IBAction)btn1Year:(id)sender;

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *paymentGraph;


@end
