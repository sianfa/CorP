//
//  BbsRepViewController.m
//  Bbs
//
//  Created by Hyeonu on 10. 5. 11..
//  Copyright 2010 CORDIAL. All rights reserved.
//

#import "TreeNode.h"
#import "XMLParser.h"
#import "BbsRepViewController.h"
#import "WriterBViewController.h"
#import "BbsDetailViewController.h"
#import "eGateMobileIF.h"


@implementation BbsRepViewController

@synthesize parent_string;
@synthesize root;
@synthesize Bbs_string;
@synthesize status;
@synthesize treeselected;
@synthesize returnData;
@synthesize tableView;
@synthesize eGMIF;

#pragma mark -
#pragma mark View lifecycle

- (IBAction)toggleEdit:(id)sender{
	NSLog(@"edit");
	[self.tableView setEditing:!self.tableView.editing];
	if (self.tableView.editing) {
		[self.navigationItem.rightBarButtonItem setTitle:@"확인"];
	} else {
		[self.navigationItem.rightBarButtonItem setTitle:@"삭제"];
	}
}

- (void)viewDidLoad {
	
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"삭제"
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(toggleEdit:)];
	
	self.navigationItem.rightBarButtonItem = editButton;
	[editButton release];
	
    [super viewDidLoad];
	
	//self.root = [[XMLParser sharedInstance] parseXMLFromURL:[NSURL URLWithString:self.Bbs_string] ];  //XMLParser 에 넣는다.
	self.root = [[XMLParser sharedInstance] parseXMLFromData:self.returnData];
	
	

	
	[self.root.children removeObjectAtIndex:0];
	[self.root.children removeObjectAtIndex:0];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	eGMIF.app = @"BBS";
	eGMIF.xmlArg1 = Bbs_string;				// Bbs_ID
	eGMIF.xmlArg2 = parent_string;			// Parent_ID
	eGMIF.xmlArg3 = @"1";					// Req_Page
	eGMIF.xmlArg4 = @"9";					// ItemPerPage
	
	NSData *returnData = [eGMIF doGenRequestXML:@"BBS0008"];
	NSLog(@"나 여기서 뻑나니? 11111 ------------------");
	
	self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
	
		
	NSLog(@"나 여기서 뻑나니? 22222 ------------------");
	[self.root.children removeObjectAtIndex:0];
	[self.root.children removeObjectAtIndex:0];
	NSLog(@"나 여기서 뻑나니? 33333 ------------------");
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.tableView reloadData];
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


// Customize the appearance of table view cells.
// 하나의 셀을 표현하기 위한 정의
- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableViews dequeueReusableCellWithIdentifier:@"generic"];
	
	if (!cell) 
		cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"generic"] autorelease];
	
	TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]];
	
	if( [child.key isEqualToString:@"record" ]) {
		NSLog(@"OK");
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		NSMutableString *subStr = [NSMutableString stringWithCapacity:2048];
		if ([[[[child children] objectAtIndex:0] key] isEqualToString:@"Doc_ID"] ) {
			cell.textLabel.numberOfLines = 7;
			//			cell.detailTextLabel.text = [[[child children] objectAtIndex:2] leafvalue];
			//			cell.detailTextLabel.text = [[[child children] objectAtIndex:3] leafvalue];
			NSString *celStr1  = [[[child children] objectAtIndex:2] leafvalue];
			NSString *celStr2  = [[[child children] objectAtIndex:3] leafvalue];
			
			[subStr appendFormat:@"%@", celStr1];
			[subStr appendFormat:@" l "];
			[subStr appendFormat:@"%@", celStr2];
			NSLog([[[child children] objectAtIndex:1] leafvalue]);
			cell.detailTextLabel.text = subStr;
			
			cell.textLabel.text = [[[child children] objectAtIndex:1] leafvalue];

		}
		
		else
			cell.textLabel.text = [[[child children] objectAtIndex:0] leafvalue];
		
		
		
		UIImage *theImage = [ UIImage imageNamed:@"board_list.png"];
		cell.imageView.image = theImage;
		
	} 
	
	cell.font = [UIFont systemFontOfSize:15.0];
	
	// Set color
	if (child.isLeaf)
		cell.textLabel.textColor = [UIColor darkGrayColor];
	else
		cell.textLabel.textColor = [UIColor blackColor];
	
	return cell;
	
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (void)tableView: (UITableView *)tableView
commitEditingStyle: (UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath: (NSIndexPath *)indexPath {
	TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]];
	Doc = [[[child children] objectAtIndex:0] leafvalue];
	NSArray *del = [[[[child children] objectAtIndex:4] leafvalue] componentsSeparatedByString:@"::"];
	if ([[del objectAtIndex:1] isEqualToString:@"1"] ) {
		[[self.root children] removeObjectAtIndex:[indexPath row]];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationFade];
		//삭제 xml
		eGMIF = [eGateMobileIF sharedInstance];
		
		eGMIF.app = @"BBS";
		eGMIF.xmlArg1 = Bbs_string;				// Bbs_ID
		eGMIF.xmlArg2 = @"1";					// Bbs_ID_Count
		eGMIF.xmlArg3 = Doc;			// Doc_ID
		
		[eGMIF doGenRequestXML:@"BBS0009"];	
	}
	//NSUInteger row = [indexPath row];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]];
	
	NSString *text = [[[child children] objectAtIndex:1] leafvalue];
	NSInteger len = [text length];
	
	NSLog(@" 길이 %d",len);
	if (len > 90) {
		return 160;
	}
	else if (len > 75) {
		return 140;
	}
	else if (len > 60) {
		return 120;
	}
	else if (len > 45){
		return 100;
	}
	else if (len > 30){
		return 84;
	}
	else if (len > 15){
		return 60;
	}
	
	else 
		//CGSize withinSize = CGSizeMake(myTableView.width, FLT_MAX); 
		
		//CGSize size = [text sizeWithFont:font constrainedToSize:withinSiz lineBreakMode:UILineBreakModeWordWrap];
		
		return 44;//size.height + somePadding;
}




- (IBAction)compose{
	WriterBViewController *writerBViewController = [[[WriterBViewController alloc]
													 initWithNibName:@"WriterBViewController"
													 bundle:nil]autorelease];
	
	[[self navigationController] pushViewController:writerBViewController animated:YES];
	writerBViewController.title = @"댓글 작성";
	writerBViewController.Bbs_string = Bbs_string;
	writerBViewController.parent_string = parent_string;
}




- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}





@end