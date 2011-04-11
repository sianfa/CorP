//
//  ListViewController.m
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 18..
//  Copyright 2010 cordial. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"

static NSString *TitleKey = @"title";

@implementation ListViewController

@synthesize menuList;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.menuList = [NSMutableArray array];
	
	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"결재 대기함", TitleKey, nil]];
	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"결재 진행함", TitleKey, nil]];
	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"결재 완료함", TitleKey, nil]];
	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"결재 반려함", TitleKey, nil]];
	self.tableView.rowHeight = 66;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.menuList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
	cell.textLabel.text = [[self.menuList objectAtIndex:indexPath.row] objectForKey:TitleKey];
	UIImage *theImage = [ UIImage imageNamed:@"approval_main.png"];
	cell.imageView.image = theImage;
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSString *ViewID;
	if (indexPath.row == 0) {
		ViewID = @"eGPAprvWait";
	}
	else if (indexPath.row == 1) {
		ViewID = @"eGPAprvIng";
	}
	else if (indexPath.row == 2) {
		ViewID = @"eGPAprvComp";
	}
	else {
		ViewID = @"eGPAprvRej";
	}

	
	DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];

   
	detailViewController.View_ID = ViewID;
	detailViewController.title = [[self.menuList objectAtIndex:indexPath.row] objectForKey:TitleKey];
	
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
}


- (void)dealloc {
	[menuList release];
    [super dealloc];
}


@end

