//
//  BbsSearchListViewController.m
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 27..
//  Copyright 2010 cordial. All rights reserved.
//
#import "TreeNode.h"
#import "XMLParser.h"
#import "BbsSearchListViewController.h"
#import "BbsDetailViewController.h"
#import "eGateMobileIF.h"

@implementation BbsSearchListViewController

@synthesize root;
@synthesize Bbs_string;
@synthesize treeselected;
@synthesize returnData;
@synthesize myTableView;
@synthesize eGMIF;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"검색 결과";
	self.root = [[XMLParser sharedInstance] parseXMLFromData:self.returnData];
	
	[self.root.children removeObjectAtIndex:0];
	[self.root.children removeObjectAtIndex:0];
	myTableView.rowHeight = 66;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSLog(@"%d", [self.root.allLeaves count]);
    return [self.root.children count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generic"];
	if (!cell) 
		cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"generic"] autorelease];
	
	TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	NSMutableString *subStr = [NSMutableString stringWithCapacity:2048];
	
	cell.textLabel.text = [[[child children] objectAtIndex:1] leafvalue];
	cell.textLabel.numberOfLines = 2;
	NSString *celStr1  = [[[child children] objectAtIndex:2] leafvalue];
	NSString *celStr2  = [[[child children] objectAtIndex:3] leafvalue];
	NSString *celStr3  = [NSString stringWithFormat:@"%@B",[[[child children] objectAtIndex:4] leafvalue]];
	
	[subStr appendFormat:@"%@", celStr1];
	[subStr appendFormat:@" l "];
	[subStr appendFormat:@"%@", celStr2];
	[subStr appendFormat:@" l "];
	[subStr appendFormat:@"%@", celStr3];
	
	cell.detailTextLabel.text = subStr;
	
	
	
	UIImage *image = [ UIImage imageNamed:@"board_list.png"];
	UIImage *fileImage = [ UIImage imageNamed:@"board_list_file.png"];
	
	if ([[[[child children] objectAtIndex:5] leafvalue] isEqualToString:@"0"] ) {
		cell.imageView.image = image;
	}
	else {
		cell.imageView.image = fileImage;
	}
	
	//cell.textAlignment.
	
	
	
	
	// Set color
	if (child.isLeaf)
		cell.textLabel.textColor = [UIColor darkGrayColor];
	else
		cell.textLabel.textColor = [UIColor blackColor];
	
	return cell;
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
		
	BbsDetailViewController *bbsDetailViewController = [[[BbsDetailViewController alloc]
														 initWithNibName:@"BbsDetailViewController"
														 bundle:nil] autorelease];     //SubsidiaryViewController.xib 초기화
	
	TreeNode *child = [[self.root children] objectAtIndex:indexPath.row];
	NSString *DocID = [[[child children] objectAtIndex:0] leafvalue];
	NSLog(@"DocID = %@", DocID);
	
	
	bbsDetailViewController.returnData = returnData;
	bbsDetailViewController.parent_string = [[[child children] objectAtIndex:0] leafvalue];
	bbsDetailViewController.Bbs_string = Bbs_string;
	bbsDetailViewController.Doc_ID = DocID;
	NSLog(@"parent_string = %@", bbsDetailViewController.parent_string);
	
	
	[[self navigationController] pushViewController:bbsDetailViewController animated:YES];

	
}


@end
