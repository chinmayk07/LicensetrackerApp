//
//  ViewController.m
//  rss reader
//
//  Created by Chinmay on 11/22/15.
//  Copyright (c) 2015 Chinmay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callBtn:(id)sender {
    
    NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"417-256-3131"]];
    
    if([[UIApplication sharedApplication] canOpenURL:callUrl])
    {
        [[UIApplication sharedApplication] openURL:callUrl];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ALERT" message:@"This Function is only Available on iPhone" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)mailBtn:(id)sender {
    
    //Email subject
    NSString *emailTitle = @"Test App";
    
    //Email content
    NSString *messageBody = @"Test app programming Result";
    
    //to address
    NSArray *toRecipents = [NSArray arrayWithObject:@"merlynferns@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc]init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (IBAction)callBtn2:(id)sender {
    
    NSString *add = [NSString stringWithFormat:@"888-485-9390"];
    NSURL *callUrl = [NSURL URLWithString:add];
    
    if([[UIApplication sharedApplication] canOpenURL:callUrl])
    {
        [[UIApplication sharedApplication] openURL:callUrl];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ALERT" message:@"This Function is only Available on iPhone" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail Cancelled");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Mail Saved");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Mail Sent");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure : %@",[error localizedDescription]);
            break;
            
        default:
            break;
    }
    //close the mail interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}






@end
