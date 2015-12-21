//
//  MasterTableViewController.m
//  
//
//  Created by Chinmay on 11/23/15.
//
//

#import "MasterTableViewController.h"
#import "DetailsViewController.h"
#import "TableViewCell.h"

@interface MasterTableViewController ()
{
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *imagelink, *description, *contentLink;
    NSString *element, *resultString, *ActualUrl;
}


@end

@implementation MasterTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    feeds = [[NSMutableArray alloc]init];
    NSURL *url = [NSURL URLWithString:@"http://www.ozarkareanetwork.com/category/app-feed/feed/rss2"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DetailsViewController *dvc = segue.destinationViewController;
    
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [feeds[indexPath.row] objectForKey:@"link"];
        NSInteger row = indexPath.row;
        NSInteger last = feeds.count;
        
        NSString *data =[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        dvc.DetailModal = [feeds copy];
        dvc.selectedLink = row;
        dvc.url = data;
        dvc.lastlink = last;
                
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feeds.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"DID SELECT : %ld",(long)[indexPath row]);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   int row = (int)[indexPath row];
    
    /*for(int i=0; i<row ; i++) {
    NSLog(@"NAMESATINDEX : %@ ",[self.tableView ])
    }*/
    
    NSLog(@" ROW : %d",row);
    
    static NSString *CellIdentifier = @"Cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.cellTitle.text = [[feeds objectAtIndex:indexPath.row]objectForKey:@"title"];
    cell.cellDescription.text = [[feeds objectAtIndex:indexPath.row]objectForKey:@"description"];
   
    //fetching image from URL
    NSURL *img = [NSURL URLWithString:[[feeds objectAtIndex:indexPath.row]objectForKey:@"imagelink"]];
    NSData *data = [NSData dataWithContentsOfURL:img];
    UIImage *image = [UIImage imageWithData:data];
    
    if(![[img absoluteString] isEqualToString:@""]) {
        cell.cellImageView.image = image;
    }
    else
    {
        cell.cellImageView.image = [UIImage imageNamed:@"NoImage"];
    }
    return cell;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if([element isEqualToString:@"item"]) {
        
        item = [[NSMutableDictionary alloc] init];
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        imagelink = [[NSMutableString alloc] init];
        contentLink = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
        resultString = [[NSString alloc] init];
        ActualUrl = [[NSString alloc] init];
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if([element isEqualToString:@"title"]) {
        [title appendString:string];
    }
    else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
        
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.:/-"] invertedSet];
        resultString = [[link componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        //NSLog (@"Result: %@", resultString);
    }
    else if ([element isEqualToString:@"content:encoded"]) {
      [contentLink appendString:string];
        if([contentLink rangeOfString:@"<img"].location != NSNotFound )
        {
            //NSLog(@"Contains");
            NSRange firstRange = [contentLink rangeOfString:@"src=\""];
            NSRange secondRange = [[contentLink substringFromIndex:firstRange.location] rangeOfString:@".jpg"];
            NSString *hashtagWord = [contentLink substringWithRange:NSMakeRange(firstRange.location, secondRange.location)];
            //NSLog(@"hashtagWord: %@", hashtagWord);
            
            NSString *match = @"src=\"";
            NSString *postMatch;
            
            NSScanner *scanner = [NSScanner scannerWithString:hashtagWord];
            [scanner scanString:match intoString:nil];
            postMatch = [hashtagWord substringFromIndex:scanner.scanLocation];
            //NSLog(@"POSTMATCHHHHHHHH %@",postMatch);
            
            ActualUrl = [postMatch stringByAppendingString:@".jpg"];
            //NSLog(@"HSFJKAHASHDKHASKHDKJASH %@",ActualUrl);
        }
    }
    else if ([element isEqualToString:@"description"]) {
        [description appendString:string];
    }
}


-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:resultString forKey:@"link"];
        
        //[item setObject:contentLink forKey:@"content:encoded"];
        [item setObject:ActualUrl forKey:@"imagelink"];
        [item setObject:description forKey:@"description"];
        
        //NSLog(@"RSS FEED :%@",item);
        [feeds addObject:[item copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.tableView reloadData];
}

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 [self.objects removeObjectAtIndex:indexPath.row];
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }
 }*/

@end
