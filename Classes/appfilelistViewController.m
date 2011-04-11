//
//  filelistViewController.m
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 17..
//  Copyright 2010 cordial. All rights reserved.
//

#import "appfilelistViewController.h"
#import "appfileViewController.h"


@implementation appfilelistViewController
@synthesize temp, filelist;
@synthesize View_ID, Doc_ID;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {

//	NSLog(temp);
//	NSLog(View_ID);
//	NSLog(Doc_ID);

	self.filelist = [temp componentsSeparatedByString:@"::"];
	NSLog(@"filecount %d",[self.filelist count]);
	for (int i = 0; i < [self.filelist count]; i++) {
		NSLog(@"asdfasdf%@",[self.filelist objectAtIndex:i]);
	}

	[super viewDidLoad];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.filelist count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	NSString *tt = [self.filelist objectAtIndex:[indexPath row] ];
	NSArray *text = [tt componentsSeparatedByString:@"|"];
    cell.textLabel.text = [text objectAtIndex:0];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@B", [text objectAtIndex:1]];
    // Configure the cell...
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	appfileViewController *fvc = [[appfileViewController alloc] initWithNibName:@"appfileViewController" bundle:nil];
	NSString *tt = [self.filelist objectAtIndex:[indexPath row] ];
	NSArray *text = [tt componentsSeparatedByString:@"|"];
	fvc.title = [text objectAtIndex:0];
	fvc.Attached =[text objectAtIndex:0];
	fvc.View_ID = View_ID;
	fvc.Doc_ID = Doc_ID;
	
	
	[self.navigationController pushViewController:fvc animated:YES];
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
}


- (void)dealloc {
    [super dealloc];
}


@end

