//
//  DetailsViewController.h
//  
//
//  Created by Chinmay on 11/23/15.
//
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong,nonatomic) NSArray *DetailModal;

@property (copy,nonatomic) NSString *url;

@property NSInteger selectedLink;

@property NSInteger lastlink;


@property (weak, nonatomic) IBOutlet UILabel *articleNo;

- (IBAction)nextBtn:(id)sender;
- (IBAction)previousBtn:(id)sender;
@end
