//
//  BbsListViewController.m
//  Bbs
//
//  Created by Hyeonu on 10. 5. 10..
//  Copyright 2010 CORDIAL. All rights reserved.
//

#import "TreeNode.h"
#import "XMLParser.h"
#import "BbsViewController.h"
#import "BbsListViewController.h"
#import "BbsDetailViewController.h"
#import "searchViewController.h"
#import "WriterViewController.h"
#import "WriterMViewController.h"
#import "eGateMobileIF.h"


@implementation BbsListViewController

//@synthesize SearchViewController;
@synthesize root;
@synthesize Bbs_string;
@synthesize treeselected;
@synthesize returnData;
@synthesize myTableView;
@synthesize refreshed;
@synthesize eGMIF, rere;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	myTableView.rowHeight = 66;
	
	
	
	//self.root = [[XMLParser sharedInstance] parseXMLFromURL:[NSURL URLWithString:self.Bbs_string] ];  //XMLParser 에 넣는다.
	self.root = [[XMLParser sharedInstance] parseXMLFromData:self.returnData];
	

	
	//	UIImageView *iv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cordial.jpg"]] autorelease];
	//	UIBarButtonItem *bbi = [[[UIBarButtonItem alloc] initWithCustomView:iv] autorelease ];
	//	
	//	self.navigationItem.rightBarButtonItem = bbi;
	//self.navigationItem.title = @"게시판";
	
	[self.root.children removeObjectAtIndex:0];
	[self.root.children removeObjectAtIndex:0];
	
}

- (void)viewWillAppear:(BOOL)animated {
	if ([refreshed isEqualToString:@"list"]) {
		
		NSString *arg3 = [NSString stringWithFormat:@"%d",rere];
		NSLog(arg3);
		
		eGMIF = [eGateMobileIF sharedInstance];
		
		
		eGMIF.app = @"BBS";
		eGMIF.xmlArg1 = Bbs_string;				// Bbs_ID
		eGMIF.xmlArg2 = @"1";					// Req_Page
		eGMIF.xmlArg3 = arg3;					// ItemPerPage
		
		NSData *returnData = [eGMIF doGenRequestXML:@"BBS0002"];
		
		self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
		
		[self.root.children removeObjectAtIndex:0];
		[self.root.children removeObjectAtIndex:0];
	}
	else {
		
	}

    [super viewWillAppear:animated];
	
	
	
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.myTableView reloadData];
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
    return [self.root.children count]+1;
}


// Customize the appearance of table view cells.
// 하나의 셀을 표현하기 위한 정의
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] < ([self.root.children count])) {
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
	else {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eneric"];
		if (!cell) 
			cell = [[[UITableViewCell alloc] 
					 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eneric"] autorelease];
		
		
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.text = @"                  More...";
		return cell;
	}

}


#pragma mark -
#pragma mark Table view delegate
// 셀이 선택 되었을때..
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//	
//	TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]];
//	
//	NSString *text = [[[child children] objectAtIndex:1] leafvalue];
//	NSInteger len = [text length];
//	
//	NSLog(@" 길이 %d",len);
//	if (len >15) {
//		return 66;
//	}
//	else 
//		//CGSize withinSize = CGSizeMake(myTableView.width, FLT_MAX); 
//		
//		//CGSize size = [text sizeWithFont:font constrainedToSize:withinSiz lineBreakMode:UILineBreakModeWordWrap];
//		
//		return 66;//size.height + somePadding;
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	if ([indexPath row] < ([self.root.children count])) {
	
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
	else {
		self.rere = rere + 20;
		
		NSString *arg3 = [NSString stringWithFormat:@"%d",rere];
		NSLog(arg3);
		
		eGMIF = [eGateMobileIF sharedInstance];
		
		
		eGMIF.app = @"BBS";
		eGMIF.xmlArg1 = Bbs_string;				// Bbs_ID
		eGMIF.xmlArg2 = @"1";					// Req_Page
		eGMIF.xmlArg3 = arg3;					// ItemPerPage
		
		NSData *returnData = [eGMIF doGenRequestXML:@"BBS0002"];
		
		self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
		
		[self.root.children removeObjectAtIndex:0];
		[self.root.children removeObjectAtIndex:0];
		
		[self.myTableView reloadData];
		
		
	}

}

- (IBAction)compose{
	WriterViewController *bbsWriteController = [[[WriterViewController alloc]
											   initWithNibName:@"WriterViewController"
											   bundle:nil]autorelease];
	
	[[self navigationController] pushViewController:bbsWriteController animated:YES];
	bbsWriteController.title = @"문서 작성";
	bbsWriteController.Bbs_string = Bbs_string;
}

- (IBAction)search{
	//searchViewController *lvc = [[searchViewController alloc] init];
//	self.SearchViewController = lvc;
//	lvc.View_ID = self.Bbs_string;
//	[lvc release];
//	[self.navigationController pushViewController:SearchViewController animated:YES];
	searchViewController *SearchViewController = [[[searchViewController alloc]
												  initWithNibName:@"searchViewController"
												   bundle:nil]autorelease];
	[[self navigationController] pushViewController:SearchViewController animated:YES];
	SearchViewController.title = @"검색";
	SearchViewController.View_ID = self.Bbs_string;
	
}

- (IBAction)refresh{
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	eGMIF.app = @"BBS";
	eGMIF.xmlArg1 = Bbs_string;				// Bbs_ID
	eGMIF.xmlArg2 = @"1";					// Req_Page
	eGMIF.xmlArg3 = @"50";					// ItemPerPage
	
	NSData *returnData = [eGMIF doGenRequestXML:@"BBS0002"];
	self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
	[self.root.children removeObjectAtIndex:0];
	[self.root.children removeObjectAtIndex:0];
	[self.myTableView reloadData];
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
	
	[self.root release];
	[self.treeselected release];
	[self.Bbs_string release];
	
    [super dealloc];
	
}


@end

