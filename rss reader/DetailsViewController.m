//
//  DetailsViewController.m
//  
//
//  Created by Chinmay on 11/23/15.
//
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
{
    NSInteger rowvalue,rowvalue1,rowvalue2,rowvalue3;
    NSArray *linkdetails;
    NSArray *REQUIREDDATA;
    NSString *asdfgh;
}

@end

@implementation DetailsViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *myURL = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:request];
    
    rowvalue = self.selectedLink;
    linkdetails = self.DetailModal;
    
    rowvalue1 = rowvalue +1;
    NSLog(@"ROWVALUE : %ld",(long)rowvalue);
    
    //NSLog(@"ARRAY %lu",(unsigned long)linkdetails.count);
    self.articleNo.text = [NSString stringWithFormat:@"Article %ld ",(long)rowvalue1];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.webView addGestureRecognizer:swipeLeft];
    [self.webView addGestureRecognizer:swipeRight];
    
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if(swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        //[self.detailImageView goForward];
        
        /*rowvalue2 = rowvalue1 + 1;
        NSLog(@"%ld",(long)rowvalue);
        
        REQUIREDDATA = [linkdetails objectAtIndex:rowvalue1];
        
        asdfgh = [REQUIREDDATA valueForKey:@"link"];
        NSLog(@"REQUIRED  : %@",asdfgh);
        
        NSURL *myURL = [NSURL URLWithString:[asdfgh stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
        [self.webView loadRequest:request];
        
        NSLog(@"REQUIRED DATA : %@",REQUIREDDATA);
        self.articleNo.text = [NSString stringWithFormat:@"Article %ld ",(long)rowvalue2];*/
        
        [self next];
    }
    
    if(swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        //[self.detailImageView goBack];
        
        /*rowvalue2 = rowvalue1 - 1;
        rowvalue3 = rowvalue1 - 2;
        NSLog(@"%ld",(long)rowvalue);
        REQUIREDDATA = [linkdetails objectAtIndex:rowvalue3];
        
        asdfgh = [REQUIREDDATA valueForKey:@"link"];
        
        NSURL *myURL = [NSURL URLWithString:[asdfgh stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
        [self.webView loadRequest:request];
        
        
        
        NSLog(@"REQUIRED DATA : %@",REQUIREDDATA);
        
        self.articleNo.text = [NSString stringWithFormat:@"Article %ld ",(long)rowvalue2];*/
        
        [self previous];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextBtn:(id)sender {
    
   /* NSLog(@"Before NEXT : %ld",(long)rowvalue1);
    rowvalue2=rowvalue1 +1;
    NSLog(@"After NEXT : %ld",(long)rowvalue2);
    
    REQUIREDDATA = [linkdetails objectAtIndex:rowvalue1];
    
    asdfgh = [REQUIREDDATA valueForKey:@"link"];
    NSLog(@"REQUIRED  : %@",asdfgh);
    
    NSURL *myURL = [NSURL URLWithString:[asdfgh stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:request];
    
    
    NSLog(@"REQUIRED DATA : %@",REQUIREDDATA);
    self.articleNo.text = [NSString stringWithFormat:@"Article %ld ",(long)rowvalue2];*/
    
    [self next];
}

- (IBAction)previousBtn:(id)sender {
    
    /*NSLog(@"Before PREV : %ld",(long)rowvalue1);
    rowvalue2 = rowvalue1 - 1;
    rowvalue3 = rowvalue1 - 2;
    NSLog(@"After PREV : %ld",(long)rowvalue3);
    REQUIREDDATA = [linkdetails objectAtIndex:rowvalue3];
    
    asdfgh = [REQUIREDDATA valueForKey:@"link"];
    
    NSURL *myURL = [NSURL URLWithString:[asdfgh stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:request];
    
    NSLog(@"REQUIRED DATA : %@",REQUIREDDATA);
    
    self.articleNo.text = [NSString stringWithFormat:@"Article %ld ",(long)rowvalue2];*/
    
    [self previous];
}

- (void)next {
    
    NSLog(@"Before NEXT : %ld",(long)rowvalue1);
    rowvalue=rowvalue +1;
    NSLog(@"After NEXT : %ld",(long)rowvalue2);
    
    if(rowvalue >= [self lastlink]) {
        [self displayAlert:@"This is the Last Article"];
    }
    else
    {
        REQUIREDDATA = [linkdetails objectAtIndex:rowvalue];
        
        asdfgh = [REQUIREDDATA valueForKey:@"link"];
        NSLog(@"REQUIRED  : %@",asdfgh);
        
        NSURL *myURL = [NSURL URLWithString:[asdfgh stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
        [self.webView loadRequest:request];
        
        
        NSLog(@"REQUIRED DATA : %@",REQUIREDDATA);
        self.articleNo.text = [NSString stringWithFormat:@"Article %ld ",(long)rowvalue];
    }
}

- (void)previous {
    
    NSLog(@"Before PREV : %ld",(long)rowvalue1);
    rowvalue = rowvalue - 1;
    rowvalue2 = rowvalue1 - 1;
    NSLog(@"After PREV : %ld",(long)rowvalue3);
    
    if(rowvalue < 0) {
        [self displayAlert:@"This is the First Article"];
    }
    else
    {
        REQUIREDDATA = [linkdetails objectAtIndex:rowvalue];
        
        asdfgh = [REQUIREDDATA valueForKey:@"link"];
        
        NSURL *myURL = [NSURL URLWithString:[asdfgh stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
        [self.webView loadRequest:request];
        
        NSLog(@"REQUIRED DATA : %@",REQUIREDDATA);
        
        self.articleNo.text = [NSString stringWithFormat:@"Article %ld ",(long)rowvalue2];
        
    }
    
}

-(void) displayAlert: (NSString *) msg
{
    UIAlertView *displayAlert = [[UIAlertView alloc] initWithTitle:@"ALERT" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [displayAlert show];
}

@end
