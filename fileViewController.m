//
//  fileViewController.m
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 17..
//  Copyright 2010 cordial. All rights reserved.
//

#import "fileViewController.h"
#import "eGateMobileIF.h"
#import "XMLParser.h"
#import "TreeNode.h"


@implementation fileViewController

@synthesize myWebView;
@synthesize View_ID, Doc_ID, Attached;
@synthesize root, treeselected, eGMIF;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	eGMIF.app = @"BBS";
	eGMIF.xmlArg1 = View_ID;				// Bbs_ID
	eGMIF.xmlArg2 = Doc_ID;					// Doc_ID
	eGMIF.xmlArg3 = Attached;				// Attached_File_Name
	
	NSData *returnData = [eGMIF doGenRequestXML:@"BBS0011"];
	
	self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
	TreeNode *child = [[self.root children] objectAtIndex:1];
	NSString *viewString = [[[child children] objectAtIndex:0] leafvalue] ;
		//NSLog(viewString);
	//[self loadDocument:viewString inView:self.myWebView];
	[self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:viewString]]];
}

//-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView
//{
//    //NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:documentName];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
//}

// Calling -loadDocument:inView:
//[self loadDocument:@"mydocument.rtfd.zip" inView:self.myWebview];



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
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
