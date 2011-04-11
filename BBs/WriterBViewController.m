//
//  BbsRepViewController.m
//  Bbs
//
//  Created by Hyeonu on 10. 5. 10..
//  Copyright 2010 CORDIAL. All rights reserved.
//

#import "WriterBViewController.h"
#import "eGateMobileIF.h"

@implementation WriterBViewController

@synthesize subjectFieldB;
@synthesize textView;
@synthesize Bbs_string;
@synthesize parent_string;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


- (void)setupTextView
{
	self.textView = [[[UITextView alloc] initWithFrame:CGRectMake(0.0, 43.0, 320.0, 196.0)] autorelease];
	self.textView.textColor = [UIColor blackColor];
	self.textView.font = [UIFont fontWithName:@"AppleMyungjo" size:20];
	self.textView.delegate = self;
	self.textView.backgroundColor = [UIColor whiteColor];
	
	self.textView.text = @"";
	self.textView.returnKeyType = UIReturnKeyDefault;
	self.textView.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
	self.textView.scrollEnabled = YES;
	
	// this will cause automatic vertical resize when the table is resized
	self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	// note: for UITextView, if you don't like autocompletion while typing use:
	// myTextView.autocorrectionType = UITextAutocorrectionTypeNo;
	[self.textView becomeFirstResponder];
	[self.view addSubview: self.textView];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self setupTextView];
    [super viewDidLoad];
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
									initWithTitle:@"등록"
									style:UIBarButtonItemStyleBordered
									target:self
									action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
}

-(void)save {
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	eGMIF.app = @"BBS";
	
	eGMIF.xmlArg1 = Bbs_string;							// Bbs_ID
	eGMIF.xmlArg2 = parent_string;						// Doc_ID  -  응답이 달릴 게시물 ID
	eGMIF.xmlArg3 = self.textView.text;				// Comment  -  댓글 내용
		
	[eGMIF doGenRequestXML:@"BBS0007"];
	
	
	[self.navigationController popViewControllerAnimated:YES];
	
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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