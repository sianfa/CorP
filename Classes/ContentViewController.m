//
//  ContentViewController.m
//  IconTest
//
//  Created by 권혁 on 10. 5. 6..
//  Copyright 2010 코디얼. All rights reserved.
//

#import "ContentViewController.h"
#import "webViewController.h"
#import "TreeNode.h"
#import "XMLParser.h"
#import "approvalViewController.h"
#import "editViewController.h"
#import "appfilelistViewController.h"
#import "eGateMobileIF.h"


@implementation ContentViewController

@synthesize name, date, line, down;
@synthesize nameString, lineString, downString, dateString;
@synthesize webView, htmlFile;
@synthesize root, treeselected, returnData;
@synthesize EditViewController;
@synthesize View_ID,Doc_ID,appButton;

@synthesize temp,eGMIF;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	if ([View_ID isEqualToString:@"eGPAprvWait"] ) {
		
		UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
										initWithTitle:@"결재"
										style:UIBarButtonItemStyleBordered
										target:self
										action:@selector(approval)];
		self.navigationItem.rightBarButtonItem = rightButton;

	}
	
		//appButton.style = UIBarButtonSystemItemFixedSpace;
	
	self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
    
	TreeNode *child = [[self.root children] objectAtIndex:1];
	
	self.name.text = [[[child children] objectAtIndex:0] leafvalue] ;
	self.date.text = [[[child children] objectAtIndex:4] leafvalue] ;
	self.line.text = [[[child children] objectAtIndex:2] leafvalue] ;
	self.down.text = [[[child children] objectAtIndex:3] leafvalue] ;
	htmlFile = [[[child children] objectAtIndex:5] leafvalue];
	temp = [[[child children] objectAtIndex:3] leafvalue] ;
	
	NSString *str = [[[child children] objectAtIndex:3] leafvalue] ;
	
	[self.webView loadHTMLString:htmlFile baseURL:nil];
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"뒤로";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	self.navigationItem.title = [[[child children] objectAtIndex:1] leafvalue] ;
}



 - (void)viewWillAppear:(BOOL)animated {
	 //appButton.style = UIBarButtonSystemItemFixedSpace;
 }
 

 - (void)viewDidAppear:(BOOL)animated {
	
	 [super viewDidAppear:animated];
 }


#pragma mark -
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"결재를 승인하시겠습니까?" message:nil
													   delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
		app = @"승인";
		[alert show];
		[alert release];
	}
	else if (buttonIndex ==1){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"결재를 반려하시겠습니까?" message:nil
													   delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
		app = @"반려";
		[alert show];
		[alert release];
		
	}
	else {
		
	}

	
}
-(IBAction)full{
	
	webViewController *wViewController = [[webViewController alloc] initWithNibName:@"webViewController" bundle:nil];
	[self.navigationController pushViewController:wViewController animated:YES];
//	NSLog(@"%@",htmlFile);
	wViewController.htmFile = htmlFile;
	wViewController.title = @"전체화면";
	NSLog(@"ddddddds%@",wViewController.htmFile); 
	[wViewController.webView loadHTMLString:wViewController.htmFile baseURL:nil];
	[wViewController release];
	
}

-(void)approval{
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"결재"
														delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
											   otherButtonTitles:@"승인", @"반려", @"취소", nil];
	action.actionSheetStyle = UIActionSheetStyleAutomatic;
	action.destructiveButtonIndex = 2;	// make the second button red (destructive)
	[action showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[action release];
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// use "buttonIndex" to decide your action
	//
	if(buttonIndex ==1){
		//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		approvalViewController *approval = [[approvalViewController alloc] initWithNibName:@"approvalViewController" 
																					bundle:nil];
		approval.View_ID = View_ID;
		approval.Doc_ID = Doc_ID;
		approval.app = app;
		[approval.navigationController setNavigationBarHidden:YES];
		[self.navigationController pushViewController:approval animated:YES];
		[approval release];

	}
}



-(IBAction)filelist {
	NSLog(@" 파일 리스트 %d",self.temp);
	NSLog(@"%@",self.temp);
	
	if ([self.temp isEqualToString:@""]) {
		NSLog(@"첨부없다");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"첨부 파일 없음." message:nil
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	
	else {
		appfilelistViewController *fvc = [[appfilelistViewController alloc] initWithNibName:@"appfilelistViewController" bundle:nil];
		fvc.title = @"첨부파일 리스트";
		fvc.temp = temp;
		fvc.View_ID = View_ID;
		fvc.Doc_ID = Doc_ID;
		
		[self.navigationController pushViewController:fvc animated:YES];
		
	}

}

-(IBAction)approvalline{

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	editViewController *evc = [[editViewController alloc] init];
	self.EditViewController = evc;
	[evc release];
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	eGMIF.app  = @"APRV";
	eGMIF.xmlArg1 = View_ID;
	eGMIF.xmlArg2 = Doc_ID;
	returnData = [eGMIF doGenRequestXML:@"APRV0008"];
	
	EditViewController.returnData = returnData;
	
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:EditViewController animated:YES];

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
    [super dealloc];
}


@end
