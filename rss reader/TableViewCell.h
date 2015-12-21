//
//  TableViewCell.h
//  rss reader
//
//  Created by Mac-Mini-3 on 02/12/15.
//  Copyright (c) 2015 Chinmay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellDescription;

@end
