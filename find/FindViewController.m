//
//  FindViewController.h
//  
//
//  Created by 정환 on 10. 5. 10..
//  Copyright 2010 Decsers Co, Ltd. All rights reserved.
//

#import "FindViewController.h"
#import "TreeNode.h"
#import "XMLParsers.h"
#import "UserViewController.h"
#import "CustomCellFind.h"
#import "CustomCellEmpty.h"

#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]


#define kCustomCellFindRowHeight	54

@implementation FindViewController

@synthesize root;
@synthesize queryString;
@synthesize companyString;
@synthesize treeselected;
@synthesize companyName;
@synthesize searchBar;
@synthesize returnData;

#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
    [super viewDidLoad];

	self.root = [[XMLParsers sharedInstance] parseXMLFromData:self.returnData]; 
	
	// create a custom navigation bar button and set it to always say "Back"
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"뒤로";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	UIImageView *iv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]] autorelease];
	UIBarButtonItem *bbi = [[[UIBarButtonItem alloc] initWithCustomView:iv] autorelease ];
	
	self.navigationItem.rightBarButtonItem = bbi;
	self.navigationItem.title = @"사람찾기";
	
	isNone = 0;
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return ([self.root.children count]+1);
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kCustomCellFindRowHeight;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([indexPath row] == 0) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generic"];
		if (!cell){
			cell = [[[UITableViewCell alloc] 
					 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"generic"] autorelease];
		}
		
		TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]];
		if ([child.key isEqualToString:@"dataset"]) {
			cell.textLabel.text = @"찾은 사람   0 명" ;
			isNone = 1;
		}else {
			cell.textLabel.text = [NSString stringWithFormat:@"찾은 사람   %d 명", self.root.children.count];
			cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:24]; 
		}

		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
	else if(isNone){
		CustomCellEmpty *emptyCell = (CustomCellEmpty *)[tableView dequeueReusableCellWithIdentifier:@"neric"];
		NSArray *nibss = [[NSBundle mainBundle] loadNibNamed:@"CustomCellEmpty" owner:self options:nil];
		
		for (id oneObject in nibss) {
			if ([oneObject isKindOfClass:[CustomCellEmpty class]]) {
				emptyCell = (CustomCellEmpty *)oneObject;
			}
		}
		emptyCell.selectionStyle =UITableViewCellSelectionStyleNone;
		return emptyCell;
	}
	else {
		CustomCellFind *cells = (CustomCellFind *)[tableView dequeueReusableCellWithIdentifier:@"eneric"];
		TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]-1];
		
		if (!cells ) {
			NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CustomCellFind" owner:self options:nil];
			
			for (id oneObject in nibs) {
				if ([oneObject isKindOfClass:[CustomCellFind class]]) {
					cells = (CustomCellFind *)oneObject;
				}
			}


			if( [child.key isEqualToString:@"record" ]) {
			cells.nameLabel.text = [[[child children] objectAtIndex:0] leafvalue];
			cells.postLabel.text = [[[child children] objectAtIndex:1] leafvalue];
			cells.deptLabel.text = [[[child children] objectAtIndex:3] leafvalue];
			cells.handphoneLabel.text = [[[child children] objectAtIndex:5] leafvalue];
			
			
			
			//UIImage *theImage = [ UIImage imageNamed:@"search_user.png"];
			//cell.imageView.image = theImage;
		
			}else {
			cells.selectionStyle = UITableViewCellSelectionStyleNone;
			}
		}
	return cells;
	}
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([indexPath row] !=0) {
		
		TreeNode *child = [[self.root children] objectAtIndex:[indexPath row]-1];
		
		
		if( [child.key isEqualToString:@"record" ]) {
			
			self.treeselected = [[self.root children] objectAtIndex:[indexPath row]-1];
			
			/*
			 
			 UIActionSheet *menu = [[UIActionSheet alloc]
			 initWithTitle: [NSString stringWithFormat:@"%@ %@",
			 [[[child children] objectAtIndex:0] leafvalue],
			 [[[child children] objectAtIndex:1] leafvalue]]
			 delegate:self
			 cancelButtonTitle:@"취소"
			 destructiveButtonTitle:@"메일보내기"
			 otherButtonTitles:@"문자보내기", @"전화걸기", nil];
			 //[menu showInView:self.view];
			 [menu showInView:self.navigationController.view ];
			 */
			UserViewController *userViewController = [[[UserViewController alloc]
													   initWithNibName:@"UserViewController" 
													   bundle:nil] autorelease] ; 
			
			userViewController.nameString = [[[self.treeselected children] objectAtIndex:0] leafvalue];
			userViewController.companyString = [[[self.treeselected children] objectAtIndex:2] leafvalue];
			userViewController.organString = [[[self.treeselected children] objectAtIndex:3] leafvalue];
			
			userViewController.emailString = [[[self.treeselected children] objectAtIndex:8] leafvalue];
			
			//NSString *organ = [[[[child children] objectAtIndex:1] leafvalue] stringByTrimmingCharactersInSet:
			//				   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			NSString *newnum = [[[[self.treeselected children] objectAtIndex:5] leafvalue] stringByTrimmingCharactersInSet:
								[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			NSString *replaced = [newnum stringByReplacingOccurrencesOfString:@" " withString:@""];
			
			userViewController.phoneString = replaced;
			
			userViewController.titleString = [[[self.treeselected children] objectAtIndex:1] leafvalue];
			userViewController.homeString = [[[self.treeselected children] objectAtIndex:6] leafvalue];
			userViewController.officeString = [[[self.treeselected children] objectAtIndex:4] leafvalue];
			userViewController.faxString = [[[self.treeselected children] objectAtIndex:5] leafvalue];
			
			[[self navigationController] pushViewController:userViewController animated:YES];
		} 
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
	[self.returnData release];
	//[self.searchBar release];
	
    [super dealloc];
}


@end

