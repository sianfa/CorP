//
//  loginViewController.m
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 19..
//  Copyright 2010 cordial. All rights reserved.
//

#import "loginViewController.h"
#import "XMLParser.h"
#import "TreeNode.h"
#import "eGateMobileIF.h"


@implementation loginViewController

@synthesize root, treeselected,tilt, eGMIF;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
- (void)viewWillAppear:(BOOL)animated {
	[self.tilt setText:@"환영합니다."];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
}
- (void)viewWillDisappear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"on"] isEqualToString:@"0"]) {
//		[[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"on"];
//		NSLog(@"로그인정보저장안함");
//	}
	[idField  setKeyboardType:UIKeyboardTypeAlphabet];
	[passField  setKeyboardType:UIKeyboardTypeAlphabet];
	self.title = @"로그인";
    [super viewDidLoad];
	//idField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
	//passField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
	[idField becomeFirstResponder];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

	
}

	
-(IBAction)login {
	NSUserDefaults *stringDefault = [NSUserDefaults standardUserDefaults];
	
	
	if (idField.text.length == nil || passField.text.length == nil  ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"다시 입력하세요" message:nil
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	else {
		[stringDefault setObject:idField.text forKey:@"id"];
		[stringDefault setObject:passField.text forKey:@"password"];
		eGMIF = [eGateMobileIF sharedInstance];
		
		NSData *returnData = [eGMIF genLoginXML];
		
		self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
		TreeNode *child = [[self.root children] objectAtIndex:1];
		if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"on"] isEqualToString:@"0"]) {
			[stringDefault setObject:@"1" forKey:@"on"];
		}
		if ([[[[child children] objectAtIndex:0] leafvalue] isEqualToString:@"0"]) {
			
			
			[self.navigationController popViewControllerAnimated:YES];
			NSLog(@"로긴상공");
		} 
		else {
			[stringDefault removeObjectForKey:@"id"];
			[stringDefault removeObjectForKey:@"password"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"다시 입력하세요" message:nil
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			
			
		}
	}


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
