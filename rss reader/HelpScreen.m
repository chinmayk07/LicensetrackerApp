//
//  HelpScreen.m
//  rss reader
//
//  Created by Mac-Mini-3 on 10/12/15.
//  Copyright © 2015 Chinmay. All rights reserved.
//

#import "HelpScreen.h"
#import "SVModalWebViewController.h"
#import "SVWebViewControllerActivity.h"

@interface HelpScreen ()

@end

@implementation HelpScreen

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


- (IBAction)helpBtn:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"https://www.facebook.com/sjinnovation"];
    
    //OPENING IN WEBVIEW
    //SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
    //webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    //[self presentViewController:webViewController animated:YES completion:NULL];
    
    //OPENING IN SAFARI BROWSER
    if([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL];
    }
}
@end
