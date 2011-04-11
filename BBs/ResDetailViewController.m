//
//  BbsDetailViewController.m
//  Bbs
//
//  Created by Hyeonu on 10. 5. 10..
//  Copyright 2010 CORDIAL. All rights reserved.
//

#import "TreeNode.h"
#import "XMLParser.h"
#import "WriterAViewController.h"
#import "WriterBViewController.h"
#import "WriterMViewController.h"
#import "BbsResViewController.h"
#import "ResDetailViewController.h"
#import "BbsRepViewController.h"
#import "WriterViewController.h"
#import "SearchViewController.h"
#import "filelistViewController.h"
#import "eGateMobileIF.h"


@implementation ResDetailViewController

@synthesize name, date, title, rCount, cCount,attach;
@synthesize nameString, titleString, dateString, contextString,parent_string, Bbs_string, Doc_ID, mtitle, status;
@synthesize root,treeselected, returnData, tableView;
@synthesize webView, eGMIF;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[super viewDidLoad];
	
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	eGMIF.app = @"BBS";
	
	eGMIF.xmlArg1 = self.Bbs_string;			// Bbs_ID
	eGMIF.xmlArg2 = Doc_ID;						// Doc_ID					-	응답글 달릴 위치
	eGMIF.xmlArg3 = @"2";							// Display_Type		-	문서 보기 유형 1.Text   2.HTML
	
	
	NSData *returnData = [eGMIF doGenRequestXML:@"BBS0003"];

	
	self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
	
	TreeNode *child = [[self.root children] objectAtIndex:1];
	
	self.name.text = [[[child children] objectAtIndex:3] leafvalue] ;
	self.date.text = [[[child children] objectAtIndex:4] leafvalue] ;
	self.title.text = [[[child children] objectAtIndex:2] leafvalue] ;
	mtitle =  [[[child children] objectAtIndex:2] leafvalue] ;
	files = [[[child children] objectAtIndex:5] leafvalue] ;
	status =  [[[child children] objectAtIndex:6] leafvalue] ;
	NSLog(files);
	self.rCount.text = [NSString stringWithFormat:@"(%@)",[[[child children] objectAtIndex:8] leafvalue]];
	self.cCount.text = [NSString stringWithFormat:@"(%@)",[[[child children] objectAtIndex:9] leafvalue]];
	self.attach.text = [NSString stringWithFormat:@"%@",[[[child children] objectAtIndex:5] leafvalue]];
	
	
	NSString *htmlFile = [[[child children] objectAtIndex:7] leafvalue];
	
	[self.webView loadHTMLString:htmlFile baseURL:nil];
	
	self.navigationItem.title = [[[child children] objectAtIndex:2] leafvalue];
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.tableView reloadData];
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
	
	
	[self.nameString release];
	
	[self.titleString release];
	
	[self.dateString release];
	
	[self.contextString release];
	[self.name release];
	[self.date release];
	[self.webView release];
	[self.title release];
	[self.rCount release];
	[self.cCount release];
	
	
    [super dealloc];
}


#pragma mark -
#pragma mark ActionSheet

- (IBAction)actionPressed{
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@""
								  delegate:self
								  cancelButtonTitle:nil
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"응답문서 작성", @"댓글 작성", @"문서 수정", @"취소", nil];
	actionSheet.destructiveButtonIndex = 3;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		WriterAViewController *writerAViewController  = [[WriterAViewController  alloc] initWithNibName:@"WriterAViewController" bundle:nil];
		[self.navigationController pushViewController:writerAViewController  animated:YES];
		writerAViewController.Bbs_string = Bbs_string;
		writerAViewController.parent_string = parent_string;
		writerAViewController.title = @"응답 문서 작성";
		NSLog(@"아놔. 돌겠구만 -_-");
		[writerAViewController release];
	}
	else if (buttonIndex == 1)
	{
		WriterBViewController *writerBViewController = [[WriterBViewController alloc] initWithNibName:@"WriterBViewController" bundle:nil];
		[self.navigationController pushViewController:writerBViewController animated:YES];
		writerBViewController.Bbs_string = Bbs_string;
		writerBViewController.parent_string = parent_string;
		writerBViewController.title = @"댓글 작성";
		[writerBViewController release];
	}
	else if (buttonIndex == 2)
	{
		NSArray *stat = [status componentsSeparatedByString:@"::"];
		NSLog(@"status = %@", [stat objectAtIndex:2]);
		if ([[stat objectAtIndex:2] isEqualToString:@"1"]) {
			
		TreeNode *child = [[self.root children] objectAtIndex:1];
		
		WriterMViewController *writerMViewController = [[WriterMViewController alloc] initWithNibName:@"WriterMViewController" bundle:nil];
		
		eGMIF = [eGateMobileIF sharedInstance];

		eGMIF.app = @"BBS";
		eGMIF.xmlArg1 = self.Bbs_string;			// Bbs_ID
		eGMIF.xmlArg2 = Doc_ID;						// Doc_ID					-	응답글 달릴 위치
		eGMIF.xmlArg3 = @"1";							// Display_Type		-	문서 보기 유형 1.Text   2.HTML
		NSData *returnData = [eGMIF doGenRequestXML:@"BBS0003"];
		
		writerMViewController.returnData = returnData;
		writerMViewController.title = @"문서 수정";
		writerMViewController.Bbs_string = Bbs_string;
		writerMViewController.parent_string = parent_string;
		writerMViewController.DocID = Doc_ID;
		writerMViewController.m_title =  mtitle;

		[self.navigationController pushViewController:writerMViewController animated:YES];
		[writerMViewController release];
		}
		else {
			
		}

    }
}


- (IBAction)resList{
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	BbsResViewController *bbsResViewController = [[[BbsResViewController alloc]
												   initWithNibName:@"BbsResViewController"
												   bundle:nil]autorelease];
	
	bbsResViewController.title = @"응답 문서";
	bbsResViewController.returnData = returnData;
	bbsResViewController.Bbs_string = Bbs_string;
	bbsResViewController.parent_string = parent_string;
	NSLog(@"parent_string = %@", parent_string);
	
	
	[[self navigationController] pushViewController:bbsResViewController animated:YES];

}

- (IBAction)repList{
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	eGMIF.app = @"BBS";
	eGMIF.xmlArg1 = Bbs_string;					// Bbs_ID
	eGMIF.xmlArg2 = parent_string;				// Parent_ID	-	응답글 달릴 위치
	eGMIF.xmlArg3 = @"1";							// Req_Page
	eGMIF.xmlArg4 = @"9";		// ItemPerPage
	

	NSData *returnData = [eGMIF doGenRequestXML:@"BBS0008"];
	
	BbsRepViewController *bbsRepViewController = [[[BbsRepViewController alloc]
												   initWithNibName:@"BbsRepViewController"
												   bundle:nil]autorelease];
	
	bbsRepViewController.returnData = returnData;
	bbsRepViewController.Bbs_string = Bbs_string;
	bbsRepViewController.parent_string = parent_string;
	//[array addObject:bbsRepViewController];
	
	[[self navigationController] pushViewController:bbsRepViewController animated:YES];
	bbsRepViewController.title = @"댓글 보기";
}



- (IBAction)trash{
	
	NSArray *stat = [status componentsSeparatedByString:@"::"];
	NSLog(@"status = %@", [stat objectAtIndex:3]);
	
	// open a alert with an OK and cancel button
	if ([[stat objectAtIndex:3] isEqualToString:@"1"]) {
		
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:@"정말 삭제 하시겠습니까?"
												   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
	}
	else {
	
	}

}


- (IBAction) download {
	NSLog(@" 파일 리스트 %d",files);
	if (files == 30072816 ) {
		NSLog(@"첨부없다");
	}
	else {
		filelistViewController *fvc = [[filelistViewController alloc] initWithNibName:@"filelistViewController" bundle:nil];
		fvc.title = @"첨부파일 리스트";
		fvc.temp = files;
		fvc.View_ID = Bbs_string;
		fvc.Doc_ID = Doc_ID;
		
		
		[self.navigationController pushViewController:fvc animated:YES];
		
	}
}


- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) // "확인" 버튼
    {
		eGMIF = [eGateMobileIF sharedInstance];
		
		eGMIF.app = @"BBS";
		eGMIF.xmlArg1 = Bbs_string;					// Bbs_ID
		eGMIF.xmlArg2 = @"1";							// Doc_ID_Count	-	응답글 달릴 위치
		eGMIF.xmlArg3 = Doc_ID;						// Doc ID		-	응답글을 저장
		
		
		[eGMIF doGenRequestXML:@"BBS0009"];
	
		[self.navigationController popViewControllerAnimated:YES];	
    }
}


- (IBAction)fileList{
	
	
}




@end
