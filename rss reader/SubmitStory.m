//
//  SubmitStory.m
//  rss reader
//
//  Created by Mac-Mini-3 on 03/12/15.
//  Copyright (c) 2015 Chinmay. All rights reserved.
//

#import "SubmitStory.h"

@interface SubmitStory ()

@end

@implementation SubmitStory

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)btnAddFromGallery:(id)sender {
    imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [picker dismissModalViewControllerAnimated:YES];
    
    //selecting and assigning this image to imageview
    UIImage *newImage = image;
    _imageSelector.image = newImage;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    //UIImage *image = _imageSelector.image; // imageView is my image from camera
    //NSData *imageData = UIImagePNGRepresentation(image);
    //[imageData writeToFile:savedImagePath atomically:NO];
    NSLog(@"%@",savedImagePath);
    
    
}

- (IBAction)btnAddFromCamera:(id)sender {
    
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Camera Available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

- (IBAction)btnSendStory:(id)sender {
    
    //validating Email ID
    NSString *emailid = self.txtEmail.text;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];
    
    
    if(([self.txtTitle.text isEqualToString:@""] || [self.txtName.text isEqualToString:@""] || [self.txtStory.text isEqualToString:@""] || [self.txtEmail.text isEqualToString:@""] ) ){
        
        [self displayAlert:@"Enter Valid Data in all Fields"];
        
    }
    else if ( myStringMatchesRegEx == 0) {
        [self displayAlert:@"Enter Valid Email"];
    }
    else {
        
        //Email subject
        NSString *emailTitle = self.txtTitle.text;
        
        //Email content
        NSString *messageBody = self.txtStory.text;
        
        //to address
        NSArray *toRecipents = [NSArray arrayWithObject:self.txtEmail.text];
        
        
        // Attach an image to the email
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"project existing photo" ofType:@"jpg"];
        //NSData *myData = [NSData dataWithContentsOfFile:path];
        //[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"photo name"];
        
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc]init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];        
        
        UIImage *myImage = self.imageSelector.image;
        NSData *myImageData = UIImagePNGRepresentation(myImage);
        
        [mc addAttachmentData:myImageData mimeType:@"image/jpeg" fileName:@"photo name"];
        
        [self presentViewController:mc animated:YES completion:NULL];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtName endEditing:YES];
    [self.txtEmail endEditing:YES];
    [self.txtStory endEditing:YES];
    [self.txtTitle endEditing:YES];
}

-(void) displayAlert: (NSString *) msg
{
    UIAlertView *displayAlert = [[UIAlertView alloc] initWithTitle:@"ALERT" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [displayAlert show];
}
@end
