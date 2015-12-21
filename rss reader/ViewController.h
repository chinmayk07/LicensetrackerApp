//
//  ViewController.h
//  rss reader
//
//  Created by Chinmay on 11/22/15.
//  Copyright (c) 2015 Chinmay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)callBtn:(id)sender;

- (IBAction)mailBtn:(id)sender;

- (IBAction)callBtn2:(id)sender;
@end

