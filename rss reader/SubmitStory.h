//
//  SubmitStory.h
//  rss reader
//
//  Created by Mac-Mini-3 on 03/12/15.
//  Copyright (c) 2015 Chinmay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SubmitStory : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>
{
    UIImagePickerController *imagePickerController;
    UIPopoverController *popover;
}

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;

@property (weak, nonatomic) IBOutlet UITextView *txtStory;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imageSelector;


- (IBAction)btnAddFromGallery:(id)sender;

- (IBAction)btnAddFromCamera:(id)sender;

- (IBAction)btnSendStory:(id)sender;

@end
