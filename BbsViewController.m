//
//  BbsViewController.m
//  Bbs
//
//  Created by Hyeonu on 10. 5. 10..
//  Copyright CORDIAL 2010. All rights reserved.
//

#import "BbsViewController.h"
#import "BbsListViewController.h"
#import "SearchViewController.h"
#import "TreeNode.h"
#import "XMLParser.h"
#import "eGateMobileIF.h"


static NSString *CellIdentifier = @"MyIdentifier";
static NSString *TitleKey = @"title";

@implementation BbsViewController

//@synthesize menuList;
@synthesize root;
@synthesize treeselected;
@synthesize eGMIF;

- (void)viewDidLoad{
	[super viewDidLoad];
	
	//self.menuList = [NSMutableArray array];
//	
//	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"공지사항", TitleKey, nil]];
//	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"자유 게시판", TitleKey, nil]];
//	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"연구소 공지사항", TitleKey, nil]];
//	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"연구소 버그노트", TitleKey, nil]];
//	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"경조사", TitleKey, nil]];
//	[self.menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"버룩시장", TitleKey, nil]];
//	
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	eGMIF.app = @"BBS";
	eGMIF.xmlArg1 = @"1";				// Req_Page
	eGMIF.xmlArg2 = @"9";				// ItemPerPage	
	
	NSData *returnData = [eGMIF doGenRequestXML:@"BBS0001"];
	
	self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
	
	
	[self.root.children removeObjectAtIndex:0];
	[self.root.children removeObjectAtIndex:0];
	
}


- (void)viewDidUnload {
	[super viewDidUnload];
	//self.menuList = nil;
}


- (void)dealloc {
	//[menuList release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIViewController delegate

//- (void)viewWillAppear:(BOOL)animated{
//	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
//	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
//}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	/*
	 @"A2FB082CE0E753E749257424001F13F4";
	 @"6C67B4E01D02C53F49257449003232AF";
	 @"D1DC2B6D6CB7C65B4925744900353DA9";
	 @"F5DDAC3D7DDB78CB4925744900353E1B";
	 */
	BbsListViewController *bbsListViewController = [[[BbsListViewController alloc]
													 initWithNibName:@"BbsListViewController" 
													 bundle:nil] autorelease];     //BbsListViewController.xib 초기화
	TreeNode *child = [[self.root children] objectAtIndex:indexPath.row];
	bbsListViewController.Bbs_string = [[[child children] objectAtIndex:1] leafvalue];
	bbsListViewController.title = [[[child children] objectAtIndex:0] leafvalue];
	//switch (indexPath.row) {
//		case 0: { 
//			sendViewID =  @"C815409BDDC28CE34925745100456456";
//			bbsListViewController.title = @"공지사항";
//			bbsListViewController.Bbs_string = sendViewID;
//			
//			break;
//		}
//		case 1: {
//			sendViewID =  @"F7A30B801C258D02492574510048DDD2";
//			bbsListViewController.title = @"자유 게시판";
//			bbsListViewController.Bbs_string = sendViewID;
//			break;
//		}
//		case 2: {
//			sendViewID = @"25127FBFC4050AE2492574510049002A";
//			bbsListViewController.title = @"연구소 공지사항";
//			bbsListViewController.Bbs_string = sendViewID;
//			break;
//		}
//		case 3: {
//			sendViewID = @"808F30D753C1B4494925745100491498";
//			bbsListViewController.title = @"연구소 버그노트";
//			bbsListViewController.Bbs_string = sendViewID;
//			break;
//		}		
//		case 4: {
//			sendViewID = @"15C3FFD1F57347D0492574510048EB03";
//			bbsListViewController.title = @"경조사";
//			bbsListViewController.Bbs_string = sendViewID;
//			break;
//		}
//		case 5: {
//			sendViewID = @"95FB5A9CA9AB8BE449257721001C51B7";
//			bbsListViewController.title = @"벼룩시장";
//			bbsListViewController.Bbs_string = sendViewID;
//			break;
//		}
//			
//	}
	bbsListViewController.refreshed = @"list";
	bbsListViewController.rere = 20;
	[[self navigationController] pushViewController:bbsListViewController animated:YES];
	//[bbsListViewController release];
}


#pragma mark -
#pragma mark UITableViewDataSource

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.root.children count];
	
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]];
	//NSString *menu =  [[self.menuList objectAtIndex:indexPath.row] objectForKey:TitleKey];
	NSString *count = [NSString stringWithFormat:@"%@ (%@/%@)",[[[child children] objectAtIndex:0] leafvalue], [[[child children] objectAtIndex:2] leafvalue], [[[child children] objectAtIndex:3] leafvalue]];
	
	cell.textLabel.text = count;
	UIImage *theImage = [ UIImage imageNamed:@"board_main.png"];
	cell.imageView.image = theImage;
	
	return cell;
}




@end