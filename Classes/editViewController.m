    //
//  editViewController.m
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 11..
//  Copyright 2010 cordial. All rights reserved.
//

#import "editViewController.h"
#import "XMLParser.h"
#import "TreeNode.h"


@implementation editViewController
@synthesize root, treeSelected, returnData;
@synthesize View_ID, Doc_ID;

//- (id)init {
//	
//	self = [super init];
//	return self;
//}

- (void)loadView {
	myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
	//myTableView.rowHeight = 120;
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.autoresizesSubviews = YES;
	self.view = myTableView;				   
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.root.children count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	[[[self.root.children objectAtIndex:section] children] removeObjectAtIndex:2];
	return [[[self.root.children objectAtIndex:section] children] count];
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.textLabel.numberOfLines = 5;
	
	TreeNode *child = [[self.root children] objectAtIndex:[indexPath section]];
	
	
	if (indexPath.row == 0) {
		NSString *name = [[[child children] objectAtIndex:3] leafvalue];
		NSArray *stat = [name componentsSeparatedByString:@"|"];
		cell.textLabel.text = [NSString stringWithFormat:@"결재 상태 : %@",[stat objectAtIndex:0]];
	}
	else if (indexPath.row == 1) {
		NSString *name = [[[child children] objectAtIndex:4] leafvalue];
		cell.textLabel.text = [NSString stringWithFormat:@"수행 일시 : %@",name];
	}
	else if (indexPath.row == 2) {
		NSString *name = [[[child children] objectAtIndex:0] leafvalue];
		NSArray *stat = [name componentsSeparatedByString:@"("];
		cell.textLabel.text = [NSString stringWithFormat:@"    이름     : %@",[stat objectAtIndex:0]];
	}
	else if (indexPath.row == 3) {
		NSString *name = [[[child children] objectAtIndex:1] leafvalue];
		cell.textLabel.text = [NSString stringWithFormat:@"    직급     : %@",name];
	}
	else if (indexPath.row == 4) {
		NSString *name = [[[child children] objectAtIndex:2] leafvalue];
		cell.textLabel.text = [NSString stringWithFormat:@"    부서     : %@",name];
	}
	else{
		NSString *name = [[[child children] objectAtIndex:[indexPath row]] leafvalue];
		if ([name length] == 0) {
			name = @"의견 없음";
		}
		NSLog(@"%d",[name length]);
		cell.textLabel.text = [NSString stringWithFormat:@"%@",name];
	}
	
	// Set color
	if (child.isLeaf)
		cell.textLabel.textColor = [UIColor darkGrayColor];
	else
		cell.textLabel.textColor = [UIColor blackColor];
	
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	[cell setSelected:NO];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	TreeNode *child = [[self.root children] objectAtIndex:[indexPath section]];
	NSString *name = [[[child children] objectAtIndex:5] leafvalue];
	if ([indexPath row] == 5) {
		
	
	if ([name length] > 80 ) {
		return 120;
	}
	else if ([name length] > 60) {
		return 90;
	}
	else {
		return 44;
	}
}
	else {
		return 44;
	}

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.root = [[XMLParser sharedInstance] parseXMLFromData:self.returnData];
	[self.root.children removeObjectAtIndex:0];
	[self.root.children removeObjectAtIndex:0];
	self.title = @"결재 현황";
    [super viewDidLoad];
}



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
	[myTableView release];
    [super dealloc];
}


@end
