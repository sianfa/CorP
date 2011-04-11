//
//  UserViewController.m
//  Posco
//
//  Created by Hojun Park on 10. 3. 30..
//  Copyright 2010 Decsers Co, Ltd. All rights reserved.
//

#import "UserViewController.h"


@implementation UserViewController

/*
 
 NSString *nameString;
 NSString *titleString;
 NSString *organString;
 NSString *companyString;
 NSString *emailString;
 NSString *phoneString;
 NSString *homeString;
 
 UILabel *name;
 UILabel *organization;
 UILabel *company;
 
 UIButton *email;
 UIButton *phone;
 UIButton *sms;
 UIButton *homePhone;
 UIButton *officePhone;
 
 */

@synthesize name, organization, company, email, phone, sms, homePhone, officePhone, faxNumber;
@synthesize nameString, titleString, organString, companyString, emailString, phoneString, homeString, officeString, faxString;



- (IBAction) callOfficePhone: (id) sender {
	NSURL *mail = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.officeString]];
	[[ UIApplication sharedApplication ] openURL:mail];
}

- (IBAction) callHomePhone: (id) sender {
	NSURL *mail = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.homeString]];
	[[ UIApplication sharedApplication ] openURL:mail];
}

- (IBAction) sendSMS: (id) sender {
	NSURL *mail = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", self.phoneString]];
				   [[ UIApplication sharedApplication ] openURL:mail];
}
				   
- (IBAction) callHandPhone: (id) sender {
	NSURL *mail = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phoneString]];
				   [[ UIApplication sharedApplication ] openURL:mail];
				   
}
				   
- (IBAction) sendEmail: (id) sender {
	NSURL *mail = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", self.emailString]];
	[[ UIApplication sharedApplication ] openURL:mail];
	
}
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
	
	self.name.text = [NSString stringWithFormat:@"%@ %@", self.nameString, self.titleString];
	self.company.text = self.companyString;
	self.organization.text = self.organString;
	
	//// set the label to the current time
	//[self.view.window labelNamed:@"my label"].text = [[NSDate date] description];
	// 태그는 인터페이스빌더에서 세팅함. 확장태그임.
	//[self.view.window labelWithTag:LABEL_TAG].text = [[NSDate date] description];

	
	//self.email.titleLabel.text = [NSString stringWithFormat:@"%@", self.emailString];
	[self.officePhone setTitle:[NSString stringWithFormat:@" 회사전화 : %@", self.officeString] forState: UIControlStateNormal];
	[self.phone setTitle:[NSString stringWithFormat:@" 휴대전화 : %@", self.phoneString] forState: UIControlStateNormal];
	[self.homePhone setTitle:[NSString stringWithFormat:@" 자택전화 : %@", self.homeString] forState: UIControlStateNormal];
	[self.faxNumber setTitle:[NSString stringWithFormat:@"   F A X   : %@", self.faxString] forState: UIControlStateNormal];
	[self.email setTitle:[NSString stringWithFormat:@"   메   일   : %@", self.emailString] forState: UIControlStateNormal];
	
	[self.sms setTitle:[NSString stringWithFormat:@"   S M S   : %@", self.phoneString] forState: UIControlStateNormal];

	
	// create a custom navigation bar button and set it to always say "Back"
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"뒤로";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	//UIImageView *iv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PoscoLogo.png"]] autorelease];
	//UIBarButtonItem *bbi = [[[UIBarButtonItem alloc] initWithCustomView:iv] autorelease ];
	
	//self.navigationItem.rightBarButtonItem = bbi;
	self.navigationItem.title = @"사람찾기";
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
	
	
	[self.nameString release];
	
	[self.titleString release];
	
	[self.organString release];
	[self.companyString release];
	[self.emailString release];
	[self.phone release];
	
	
	[self.phoneString release];
	
	[self.officeString release];
	[self.name release];
	[self.organization release];
	[self.company release];
	[self.email release];
	
	[self.sms release];
	[self.homePhone release];
	[self.officePhone release];
	 
	
    [super dealloc];
}


@end
