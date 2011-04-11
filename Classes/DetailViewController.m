//
//  DetailViewController.m
//  IconTest
//
//  Created by 권혁 on 10. 5. 4..
//  Copyright 2010 코디얼. All rights reserved.
//

#import "DetailViewController.h"
#import "ContentViewController.h"
#import "XMLParser.h"
#import "TreeNode.h"
#import "appsearchViewController.h"
#import "eGateMobileIF.h"


@implementation DetailViewController

@synthesize root, treeSelected, returnData;
@synthesize View_ID;
@synthesize SearchViewController;
@synthesize myTableView, eGMIF;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
	self.myTableView.rowHeight = 66;
}

-(IBAction)refresh {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	eGMIF.app  = @"APRV";
	
	eGMIF.xmlArg1 = View_ID;
	
	returnData = [eGMIF doGenRequestXML:@"APRV0003"];
	self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
	
	[self.root.children removeObjectAtIndex:0];
	[self.root.children removeObjectAtIndex:0];
	
	[self.myTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
		
	
		eGMIF = [eGateMobileIF sharedInstance];
		
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		eGMIF.app  = @"APRV";
		
		eGMIF.xmlArg1 = View_ID;
		
			//eGMIF.tempRe
		
		returnData = [eGMIF doGenRequestXML:@"APRV0003"];
			//NSLog(@"문서함 열기");

	
	self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
	
	[self.root.children removeObjectAtIndex:0];
	[self.root.children removeObjectAtIndex:0];

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.myTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
	
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if ([self.root.children count] == 0) {
		return 1;
	}
	else
		return [self.root.children count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	if ([self.root.children count] == 0) {
		[self.myTableView deleteRowsAtIndexPaths:0 withRowAnimation:NO];
		
		cell.textLabel.text = @"   결재 문서가 없습니다.";
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}

	else{
		
	
		TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.text = [[[child children] objectAtIndex:5] leafvalue];
		cell.textLabel.numberOfLines = 2;
		
		NSString *author = [[[child children] objectAtIndex:6] leafvalue];
		NSString *date = [[[child children] objectAtIndex:7] leafvalue];
		
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@      |       %@ ",date,author ];
		
		NSString *temp = [[[child children] objectAtIndex:9] leafvalue];		
		NSArray *doc = [temp componentsSeparatedByString:@"::"];

		if ([[doc objectAtIndex:2] isEqualToString:@"0"] ) {
			UIImage *theImage = [ UIImage imageNamed:@"approval_list.png"];
			cell.imageView.image = theImage;
		}
		else {
			UIImage *theImage = [ UIImage imageNamed:@"approval_list_file.png"];
			cell.imageView.image = theImage;
		}

		
		// Set color
		if (child.isLeaf)
			cell.textLabel.textColor = [UIColor darkGrayColor];
		else
			cell.textLabel.textColor = [UIColor blackColor];
	}
	
	return cell;
}

-(IBAction)search {
	NSLog(@"search");
	appsearchViewController *lvc = [[appsearchViewController alloc] init];
	self.SearchViewController = lvc;
	lvc.View_ID = self.View_ID;
	[lvc release];
	[self.navigationController pushViewController:SearchViewController animated:YES];
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	if ([self.root.children count] == 0) {
		
	}
	else {
		TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]];
		
		ContentViewController *contentViewController = [[[ContentViewController alloc]
														 initWithNibName:@"ContentViewController" 
														 bundle:nil] autorelease];     //SubsidiaryViewController.xib 초기화
		NSString *Doc_ID = [[[child children] objectAtIndex:4] leafvalue];
		
		eGMIF = [eGateMobileIF sharedInstance];
	
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		eGMIF.app  = @"APRV";
		
		eGMIF.xmlArg1 = View_ID;
		
		eGMIF.xmlArg2 = Doc_ID;
		
		returnData = [eGMIF doGenRequestXML:@"APRV0004"];
	
	
		contentViewController.returnData = returnData;
		contentViewController.View_ID = View_ID;
		contentViewController.Doc_ID = Doc_ID;
			
		[[self navigationController] pushViewController:contentViewController animated:YES];
	}
	//[self.myTableView reloadData];
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[eGMIF release];
	[myTableView release];
	[SearchViewController release];
	[self.root release];
	[self.treeSelected release];
	[self.returnData release];
	[self.View_ID release];
    [super dealloc];
}


@end

