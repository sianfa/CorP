//
//  RootViewController.m
//  IconTest
//
//  Created by 권혁 on 10. 5. 4..
//  Copyright 코디얼 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "BbsViewController.h"
#import "ListViewController.h"
#import "setupViewController.h"
#import "XMLParser.h"
#import "TreeNode.h"
#import "SubsidiaryViewController.h"
#import "eGateMobileIF.h"
#import "loginViewController.h"
#import "BbsListViewController.h"



@implementation RootViewController

@synthesize bbsViewController; 
@synthesize findViewController;
@synthesize listViewController;
@synthesize myTableView;
@synthesize root, treeSelected;
@synthesize eGMIF,returnData;
@synthesize pimsID,pimsPW;

#pragma mark -
#pragma mark View lifecycle


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;	//색션의 개수
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;	//셀의 개수
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.textLabel.textColor = [UIColor whiteColor];		//샐의 텍스트 색 (흰색)
	tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_bg.png"]];
	cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_overbg.png"]];
	if ([indexPath row] == 0) {	//결재 대기함
		
		cell.textLabel.text = [NSString stringWithFormat:@"결재 대기함  (%@)",wCount];
		cell.imageView.image = [UIImage imageNamed:@"list_document.png"];
	}

	else if([indexPath row] == 1){	//공지사항

		cell.textLabel.text = @"공지사항";
		cell.imageView.image = [UIImage imageNamed:@"list_notice.png"];
	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath row] == 0) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		NSString *ViewID = @"eGPAprvWait";
		DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
		
		detailViewController.View_ID = ViewID;
		detailViewController.title = @"결재 대기함";
		

		[self.navigationController pushViewController:detailViewController animated:YES];

		
	}
	else {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		BbsListViewController *blvc = [[[BbsListViewController alloc] initWithNibName:@"BbsListViewController" bundle:nil] autorelease];
		blvc.Bbs_string = @"C815409BDDC28CE34925745100456456";
		blvc.title = @"공지사항";
		blvc.rere = 20;
		blvc.refreshed = @"list";
		[self.navigationController pushViewController:blvc animated:YES];
		
		
	}

}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
	UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(104, 8, 109, 28)] autorelease];
	[iv setImage:[UIImage imageNamed:@"logo.png"]];
	self.navigationItem.titleView = iv;
	
    [super viewDidLoad];
	UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
	back.title = @"뒤로";
	self.navigationItem.backBarButtonItem = back;
	[back release];

}


-(void)setup {
	setupViewController *lvc = [[setupViewController alloc] initWithNibName:@"setupViewController" bundle:nil];
	[self.navigationController pushViewController:lvc animated:YES];
	[lvc release];
}


-(void)login {
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"on"] isEqualToString:@"2"]) {
		NSUserDefaults *stringDefault = [NSUserDefaults standardUserDefaults];
		[stringDefault setObject:@"1" forKey:@"on"];
		
	}
	loginViewController *lvc = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
	[self.navigationController pushViewController:lvc animated:YES];
	[lvc release];
}




- (void)viewWillAppear:(BOOL)animated {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [super viewWillAppear:animated];
	NSUserDefaults *stringDefault = [NSUserDefaults standardUserDefaults];
	NSString *ids = [stringDefault objectForKey:@"id"];
	NSString *passwords = [stringDefault objectForKey:@"password"];
	
	NSString *server = [stringDefault objectForKey:@"reserver"];
	[stringDefault setObject:server forKey:@"server"];
	
	if (![[NSUserDefaults standardUserDefaults] objectForKey:@"server"]) {
			//NSLog(@"서버정보없음");
		setupViewController *svc = [[setupViewController alloc] initWithNibName:@"setupViewController" bundle:nil];
		[self.navigationController pushViewController:svc animated:YES];
		[svc release];
	}
	else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"connect"] isEqualToString:@"out"]) {
			//NSLog(@"서버정보없음");
		setupViewController *svc = [[setupViewController alloc] initWithNibName:@"setupViewController" bundle:nil];
		[self.navigationController pushViewController:svc animated:YES];
		[svc release];
	}
	
	else if (ids.length == 0 ) {
			//NSLog(@"Id field 없음");
		loginViewController *lvc = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
		[self.navigationController pushViewController:lvc animated:YES];
		[lvc release];
	}
	else {
		if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"on"] isEqualToString:@"1"]) {
				//NSLog(@" Root 자동저장 아님");
				//NSLog(@"로그인 정보         %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]);
			eGMIF = [eGateMobileIF sharedInstance];
			eGMIF.app  = @"APRV";
			returnData = [eGMIF doGenRequestXML:@"APRV0001"];
				//NSLog(@"접속 성공");
		
			self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
			TreeNode *child = [[self.root children] objectAtIndex:0];
			
			wCount = [[[child children] objectAtIndex:5] leafvalue];
			if ([wCount isEqualToString:@"220"]) {
					//NSLog(@"망했다");
			}
			else {
				TreeNode *child = [[self.root children] objectAtIndex:1];
				wCount = [[[child children] objectAtIndex:0] leafvalue];
					//NSLog(@"대기문서개수 %@",wCount);
				[self.myTableView reloadData];
			}

		}
		else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"on"] isEqualToString:@"2"]) {
			eGMIF = [eGateMobileIF sharedInstance];
			eGMIF.app  = @"APRV";
			returnData = [eGMIF doGenRequestXML:@"APRV0001"];
				//NSLog(@"자동 저장 접속 성공");
			self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
			
			TreeNode *child = [[self.root children] objectAtIndex:1];
			wCount = [[[child children] objectAtIndex:0] leafvalue];
				//NSLog(@"대기문서개수 %@",wCount);
			[self.myTableView reloadData];
		}
		else {
			loginViewController *lvc = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
			[self.navigationController pushViewController:lvc animated:YES];
			[lvc release];
		}
	}
}

-(IBAction) bbs {
	BbsViewController *bbs = [[BbsViewController alloc] init];
	self.bbsViewController = bbs;
	self.bbsViewController.title = @"게시판";
	[bbs release];
	[self.navigationController pushViewController:bbsViewController animated:YES];
}

-(IBAction)find {
	SubsidiaryViewController *find = [[SubsidiaryViewController alloc] init];
	self.findViewController = find;
	[find release];
	[self.navigationController pushViewController:findViewController animated:YES];
}

- (IBAction) approval {
	ListViewController *app = [[ListViewController alloc] init];
	app.title = @"전자 결재";
	self.listViewController = app;
	[app release];
	[self.navigationController pushViewController:listViewController animated:YES];
}

-(IBAction) mail{
	pimsID= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
	pimsPW = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
	NSString *mStr = [NSURL URLWithString:
					  [NSString stringWithFormat:@"http://mail.cordial.co.kr/names.nsf?login&username=%@&password=%@&redirectto=http://mail.cordial.co.kr/cs/rss.nsf/redirectmail?openform"
					   ,pimsID,pimsPW]];
	[[UIApplication sharedApplication] openURL:mStr];
}							

-(IBAction) calendar{	pimsID= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
	pimsPW = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
	NSString *mStr = [NSURL URLWithString:
					  [NSString stringWithFormat:@"http://mail.cordial.co.kr/names.nsf?login&username=%@&password=%@&redirectto=http://mail.cordial.co.kr/cs/rss.nsf/redirectCal?openform"
					   ,pimsID,pimsPW]];
	[[UIApplication sharedApplication] openURL:mStr];}		

-(IBAction) address{
	pimsID= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
	pimsPW = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
	NSString *mStr = [NSURL URLWithString:
					  [NSString stringWithFormat:@"http://mail.cordial.co.kr/names.nsf?login&username=%@&password=%@&redirectto=http://mail.cordial.co.kr/cs/rss.nsf/redirectCont?openform"
					   ,pimsID,pimsPW]];
	[[UIApplication sharedApplication] openURL:mStr];
}							


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	returnData = nil;
	wCount = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[eGMIF release];
	[bbsViewController release];
	[findViewController release];
	[listViewController release];
	[returnData release];
	[wCount release];
	[root release];
	[treeSelected release];
	[eGMIF release];
	[listViewController release];
	[bbsViewController release];
	[findViewController release];
	[myTableView release];
	[returnData release];
    [super dealloc];
	
}


@end

