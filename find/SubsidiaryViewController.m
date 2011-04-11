//
//  SubsidiaryViewController.m
//  Posco
//
//  Created by Hojun Park on 10. 3. 26..
//  Copyright 2010 Decsers Co, Ltd. All rights reserved.
//

#import "SubsidiaryViewController.h"
#import "TreeNode.h"
#import "XMLParsers.h"
#import "FindViewController.h"
#import "UserViewController.h"
#import "eGateMobileIF.h"
#import "CustomCell.h"

#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]
#define showAlert(format, ...) myShowAlert(__LINE__, (char *)__FUNCTION__, format, ##__VA_ARGS__)


@implementation SubsidiaryViewController

@synthesize root;
@synthesize queryString;
@synthesize companyString;
@synthesize treeselected;
@synthesize companyName;
@synthesize searchBar;
@synthesize groupCode;
@synthesize returnData;
@synthesize eGMIF;

#pragma mark -
#pragma mark View lifecycle




- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	//eGMIF = [[eGateMobileIF alloc] init];
	eGMIF = [eGateMobileIF sharedInstance];
	
	if (returnData == nil) {
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		eGMIF.app  = @"FindPeople";
		
		eGMIF.xmlArg1 = @"T_DeptName";
		eGMIF.xmlArg2 = @"A00";		
		eGMIF.xmlArg3 = @"T_OrgCode";
		eGMIF.xmlArg4 = @"T_PrevDeptCode";
		
		returnData = [eGMIF doGenRequestXML:@"FIND0001" ];
			
		self.companyName = @"코디얼";
		self.navigationItem.title = @"사람찾기";

	}	
	
	self.root = [[XMLParsers sharedInstance] parseXMLFromData:self.returnData];
	
	// Create a search bar
	self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
	//self.searchBar.tintColor = COOKBOOK_PURPLE_COLOR;
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeDefault;

	self.searchBar.delegate = self;
	self.searchBar.showsCancelButton = YES;
	
	self.tableView.tableHeaderView = self.searchBar;

	
	// create a custom navigation bar button and set it to always say "Back"
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"뒤로";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	//UIImageView *iv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
	//UIBarButtonItem *bbi = [[[UIBarButtonItem alloc] initWithCustomView:iv] autorelease ];
	
	//self.navigationItem.rightBarButtonItem = bbi;
	
	if (self.navigationItem.title == nil) {
		self.navigationItem.title = companyName;
	}
		
}


// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self.searchBar resignFirstResponder];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	
	NSString *nameStr = [NSString stringWithString:searchBar.text];
	
	
	
	//	NSString *sourceString = nameStr;  
	NSLog(@"Search string: %@", nameStr);  
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	//////////////////////////
	
	eGMIF.app  = @"FindPeople";
	
	if ([self.companyString isEqualToString:@"none"]) {
		eGMIF.xmlArg1 = @"A00";
	}else {
		eGMIF.xmlArg1 = self.companyString;
	}
	eGMIF.xmlArg2 = nameStr;		
		
	returnData = [eGMIF doGenRequestXML:@"FIND0002" ];
	
	
	//NSLog 관련
	NSString *parsedString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"\n FindPeople SearchResult = %@", parsedString);
	
	FindViewController *findViewController = [[[FindViewController alloc]
												   initWithNibName:@"FindViewController" 
												   bundle:nil] autorelease] ; 
	
	//다음  subsidiaryview의 CompanyName은 각 테이블 뷰의 detailText로 사용된다.
	findViewController.companyName = self.companyName;
	
	findViewController.returnData = returnData;
	
	[[self navigationController] pushViewController:findViewController animated:YES];
	
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.searchBar resignFirstResponder];	
}


// Simple Alert Utility
void myShowAlert(int line, char *functname, id formatstring,...)
{
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	id outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
	va_end(arglist);
	
	NSString *filename = [[NSString stringWithCString:__FILE__] lastPathComponent];
	
	NSString *debugInfo = [NSString stringWithFormat:@"%@:%d\n%s", filename, line, functname];
    
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:outstring message:debugInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[av show];
}

- (void) rightAction: (id) sender
{
	showAlert(@"You pressed the right button");
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.root.children count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
		
	TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]];
	
	
	if( [child.key isEqualToString:@"record" ] | [child.key isEqualToString:@"record_d" ]) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generic"];
		if (!cell) {
			cell = [[[UITableViewCell alloc] 
					 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"generic"] autorelease];	
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		cell.textLabel.text = [[[child children] objectAtIndex:0] leafvalue];
		
		cell.detailTextLabel.text = self.companyName;
		
		UIImage *theImage = [ UIImage imageNamed:@"search_team.png"];
		cell.imageView.image = theImage;
		
		// Set color
		if (child.isLeaf)
			cell.textLabel.textColor = [UIColor darkGrayColor];
		else
			cell.textLabel.textColor = [UIColor blackColor];
		
			return cell;
	} else if( [child.key isEqualToString:@"record_p" ]) {
		CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"generic"];
		if (!cell) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
			
			for (id oneObject in nib) {
				if ([oneObject isKindOfClass:[CustomCell class]]) {
					cell = (CustomCell *)oneObject;
				}
			}
	
		}
		cell.nameLabel.text = [[[child children] objectAtIndex:1] leafvalue];
		cell.deptLabel.text = [[[child children] objectAtIndex:8] leafvalue];
		
			return cell;
		
//		cell.textLabel.text = [[[child children] objectAtIndex:1] leafvalue];
//		cell.detailTextLabel.text = [[[child children] objectAtIndex:8] leafvalue];
//		
//		UIImage *theImage = [ UIImage imageNamed:@"search_user.png"];
//		cell.imageView.image = theImage;
//		
		
	} else {
		//내용이 없을때 로직 여기
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generic"];
		cell.textLabel.text = child.leafvalue;
			return cell;
	}
	
	


	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]];
	
	
	eGMIF = [eGateMobileIF sharedInstance];

	if( [child.key isEqualToString:@"record" ] || [child.key isEqualToString:@"record_d" ] ){
		
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

		
		
		eGMIF.app  = @"FindPeople";
		
		eGMIF.xmlArg1 = @"T_DeptName";
		eGMIF.xmlArg2 = [[[child children] objectAtIndex:1] leafvalue];		
		eGMIF.xmlArg3 = @"T_OrgCode";
		eGMIF.xmlArg4 = @"T_PrevDeptCode";
		
		
		returnData = [eGMIF doGenRequestXML:@"FIND0001" ];
		
		
		
		//NSLog 관련 
		NSString *parsedString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
		NSLog(@"\n did selected table row Result = %@", parsedString);
		
		SubsidiaryViewController *subsidiaryViewController = [[[SubsidiaryViewController alloc]
															   initWithNibName:@"SubsidiaryViewController" 
															   bundle:nil] autorelease] ; 
		
		//다음  subsidiaryview의 CompanyName은 각 테이블 뷰의 detailText로 사용된다.
		subsidiaryViewController.companyName = [[[child children] objectAtIndex:0] leafvalue];
		
		subsidiaryViewController.returnData = returnData;
		
		
		[[self navigationController] pushViewController:subsidiaryViewController animated:YES];
		
		
		
		
	} else if ( [child.key isEqualToString:@"record_p" ] ) {
		
		
		self.treeselected = [[self.root children] objectAtIndex:[indexPath row]];
		
		
		//  조직을 타고 들어가는 경우와 검색을 해서 찾는 경우가 다름.
		
		UserViewController *userViewController = [[[UserViewController alloc]
												   initWithNibName:@"UserViewController" 
												   bundle:nil] autorelease] ; 
		
		// 조직도에서 들어가는 경우 
		NSLog(@"nameString 1=> %@",[[[self.treeselected children] objectAtIndex:1] leafvalue]);
		NSLog(@"phoneString 2=> %@",[[[self.treeselected children] objectAtIndex:2] leafvalue]);
		NSLog(@"officeString 3=> %@",[[[self.treeselected children] objectAtIndex:3] leafvalue]);
		NSLog(@"emailString 6=> %@",[[[self.treeselected children] objectAtIndex:6] leafvalue]);
		NSLog(@"titleString 8=> %@",[[[self.treeselected children] objectAtIndex:8] leafvalue]);
		NSLog(@"organString 9=> %@",[[[self.treeselected children] objectAtIndex:9] leafvalue]);
		//NSLog(@"companyString 9=> %@",[[[self.treeselected children] objectAtIndex:9] leafvalue]);
		
		
		
		userViewController.nameString = [[[self.treeselected children] objectAtIndex:1] leafvalue];
		userViewController.phoneString = [[[self.treeselected children] objectAtIndex:2] leafvalue];
		userViewController.officeString = [[[self.treeselected children] objectAtIndex:3] leafvalue];
		userViewController.emailString = [[[self.treeselected children] objectAtIndex:6] leafvalue];
		userViewController.titleString = [[[self.treeselected children] objectAtIndex:8] leafvalue];
		userViewController.organString = [[[self.treeselected children] objectAtIndex:9] leafvalue];
		//userViewController.companyString = [[[self.treeselected children] objectAtIndex:9] leafvalue];
		userViewController.homeString = [[[self.treeselected children] objectAtIndex:4] leafvalue];
		userViewController.faxString = [[[self.treeselected children] objectAtIndex:5] leafvalue];
		
		
		
		[[self navigationController] pushViewController:userViewController animated:YES];
		
		
		
	}
	
	
	
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [actionSheet release];
	
	//Look at UIApplicationpenURL:
	
	//you simply need to call it with a URL of the form "tel:+1-800-275-2273"
	
	//[self say:@"User Pressed Button %d\n", buttonIndex + 1];
	switch (buttonIndex) {
		case 0: // 메일
		{
			// [[[self.treeselected children] objectAtIndex:1] leafvalue]
			NSURL *mail = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", [[[self.treeselected children] objectAtIndex:4] leafvalue]]];
			[[ UIApplication sharedApplication ] openURL:mail];
			
			break;
		}
		case 1: // 문자 
		{
			NSURL *mail = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", [[[self.treeselected children] objectAtIndex:2] leafvalue]]];
			[[ UIApplication sharedApplication ] openURL:mail];
			
			break;
		}
		case 2: // 전화걸기
		{
			NSURL *mail = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [[[self.treeselected children] objectAtIndex:2] leafvalue]]];
			[[ UIApplication sharedApplication ] openURL:mail];
			
			break;
		}
		default:
			break;
	}
}


- (void) say: (id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	
	UIAlertView *av = [[[UIAlertView alloc] initWithTitle:statement message:nil delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
    [av show];
	[statement release];
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
	[self.queryString release];
	[self.companyName release];
	[self.companyString release];
	//[self.searchBar release];
	[self.groupCode release];
	
    [super dealloc];
	
}


@end

