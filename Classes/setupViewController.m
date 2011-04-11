//
//  loginViewController.m
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 19..
//  Copyright 2010 cordial. All rights reserved.
//

#import "setupViewController.h"
#import "XMLParser.h"
#import "TreeNode.h"
#import "eGateMobileIF.h"

@implementation setupViewController

@synthesize root, treeselected,swc, tilt;
@synthesize eGMIF;

- (void)viewWillAppear:(BOOL)animated {
	[self.tilt setText:@"환경설정"];
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
									initWithTitle:@"확인"
									style:UIBarButtonItemStyleBordered
									target:self
									action:@selector(login)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[self.navigationItem setHidesBackButton:YES];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"on"] isEqualToString:@"2"]) {
		NSLog(@"스위치 온 상태");
		[swc setOn:1];
		idField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
		passField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
	}
	else {
		NSLog(@"스위치 오프 상태");
		[swc setOn:0];
	}

	[idField becomeFirstResponder];
	[idField setKeyboardType:UIKeyboardTypeAlphabet];
	[passField setKeyboardType:UIKeyboardTypeAlphabet];
	self.title = @"환경설정";
    [super viewDidLoad];
	
	serverField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
	
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
}
- (IBAction)switchChanged:(id)sender{
	NSUserDefaults *stringDefault = [NSUserDefaults standardUserDefaults];
	UISwitch *whichSwitch = (UISwitch *)sender;
	
    if (whichSwitch.isOn == 1) {
		NSLog(@"스위치온");
		[stringDefault setObject:idString forKey:@"id"];
		[stringDefault setObject:passString forKey:@"password"];
		[stringDefault setObject:@"2" forKey:@"on"];
	} 
	else if (whichSwitch.isOn == 0){
		NSLog(@"스위치오프");
		[stringDefault setObject:@"1" forKey:@"on"];
	}

}
	
-(void)login {
	NSUserDefaults *stringDefault = [NSUserDefaults standardUserDefaults];
		
	if (idField.text.length == 0 || passField.text.length == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ID 또는 Password를 입력하세요" message:nil
													   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
		[alert show];	
		[alert release];

	} else {
		NSLog(@"what???????? %@",serverField.text);
		NSLog(@"what???????? %@",idField.text);
		NSLog(@"what???????? %@",passField.text);
		[stringDefault setObject:@"out" forKey:@"connect"];
		eGMIF = [eGateMobileIF sharedInstance];
		[stringDefault setObject:serverField.text forKey:@"server"];
		[stringDefault setObject:idField.text forKey:@"id"];
		[stringDefault setObject:passField.text forKey:@"password"];

		NSData *returnData = [eGMIF genLoginXML];
		NSString *oh = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
			//NSLog(oh);
		if (oh.length == 0) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"다시 입력하세요" message:nil
														   delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
			[alert show];	
			[alert release];
		}
		

		self.root = [[XMLParser sharedInstance] parseXMLFromData:returnData];
		TreeNode *child = [[self.root children] objectAtIndex:1];
		
		if ([[[[child children] objectAtIndex:0] leafvalue] isEqualToString:@"0"]) {

			NSUserDefaults *stringDefault = [NSUserDefaults standardUserDefaults];
			if (swc.isOn == 1) {
				
				NSLog(@"자동저장하고 로그인");
				[stringDefault setObject:@"2" forKey:@"on"];
			}
			else {
				
				NSLog(@"자동저장안하고 로그인");
				
				[stringDefault setObject:@"1" forKey:@"on"];
				
			}
			[stringDefault setObject:serverField.text forKey:@"reserver"];
			[stringDefault setObject:@"ok" forKey:@"connect"];

			[self.navigationController popViewControllerAnimated:YES];
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
