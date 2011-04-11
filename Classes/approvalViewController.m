//
//  approvalViewController.m
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 10..
//  Copyright 2010 cordial. All rights reserved.
//

#import "approvalViewController.h"
#import "eGateMobileIF.h"


@implementation approvalViewController
@synthesize textView,titl,app,approvalText;
@synthesize View_ID, Doc_ID;
@synthesize eGMIF;


- (void)setupTextView
{
	self.textView = [[[UITextView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 196.0)] autorelease];
	self.textView.textColor = [UIColor blackColor];
	self.textView.font = [UIFont fontWithName:@"Arial" size:18];
	self.textView.delegate = self;
	self.textView.backgroundColor = [UIColor whiteColor];
	
	self.textView.text = @"";
	self.textView.returnKeyType = UIReturnKeyDefault;
	self.textView.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
	self.textView.scrollEnabled = YES;
	
	// this will cause automatic vertical resize when the table is resized
	self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	
	[self.textView becomeFirstResponder];
	[self.view addSubview: self.textView];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	
	[self setupTextView];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.textView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
		//NSLog(app);
	[self.titl setText:app];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
}
- (void)viewWillDisappear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO];
}
-(IBAction)cancel{
	[self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)approval {
	approvalText = self.textView.text;
	NSString *code;
	if ([app isEqualToString:@"승인"]) {
		code = @"approval";
	}
	else {
		code = @"return";
	}

	eGMIF = [eGateMobileIF sharedInstance];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	eGMIF.app  = @"APRV";
	eGMIF.xmlArg1 = Doc_ID;
	eGMIF.xmlArg2 = code;
	eGMIF.xmlArg3 = approvalText;
	
	[eGMIF doGenRequestXML:@"APRV0007"];
	

	
	if ([app isEqualToString:@"승인"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"결재가 승인되었습니다." message:nil
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"결재가 반려되었습니다." message:nil
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		[self.navigationController popViewControllerAnimated:YES];
	}

	
}


- (void)dealloc {
	[textView release];
    [super dealloc];
}


@end
