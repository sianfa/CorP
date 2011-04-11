//
//  SearchlistViewController.m
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 27..
//  Copyright 2010 cordial. All rights reserved.
//

#import "SearchlistViewController.h"
#import "XMLParser.h"
#import "TreeNode.h"
#import "eGateMobileIF.h"
#import "ContentViewController.h"

@implementation SearchlistViewController

@synthesize root, treeSelected, returnData, dataString;
@synthesize View_ID;
@synthesize myTableView, eGMIF;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	myTableView.rowHeight = 66;
	self.root = [[XMLParser sharedInstance] parseXMLFromData:self.returnData];
	
	[self.root.children removeObjectAtIndex:0];
	[self.root.children removeObjectAtIndex:0];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	if ([self.root.children count] == 0) {
		
	}
	else {
		
		
		
		TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]];
		
		ContentViewController *userViewController = [[[ContentViewController alloc]
													  initWithNibName:@"ContentViewController" 
													  bundle:nil] autorelease];     //SubsidiaryViewController.xib 초기화
		NSString *Doc_ID = [[[child children] objectAtIndex:4] leafvalue];
		eGMIF = [eGateMobileIF sharedInstance];
		
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		eGMIF.app  = @"APRV";
		
		eGMIF.xmlArg1 = View_ID;
		
		eGMIF.xmlArg2 = Doc_ID;
		
		returnData = [eGMIF doGenRequestXML:@"APRV0004"];
		
		
		userViewController.returnData = returnData;
		userViewController.View_ID = View_ID;
		userViewController.Doc_ID = Doc_ID;
		
		[[self navigationController] pushViewController:userViewController animated:YES];
	}
	[self.myTableView reloadData];
	
}



@end
