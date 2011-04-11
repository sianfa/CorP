//
//  searchViewController.m
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 10..
//  Copyright 2010 cordial. All rights reserved.
//

#import "searchViewController.h"
//#import "DetailViewController.h"
#import "BbsSearchListViewController.h"
#import "eGateMobileIF.h"

@implementation searchViewController
@synthesize doublePicker, textField;
@synthesize fillingTypes;
@synthesize breadTypes;
@synthesize View_ID;
@synthesize Stype, Sterm,Skeyword;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidLoad {
	NSLog(@"검색시작");
	[super viewDidLoad];
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
									initWithTitle:@"검색"
									style:UIBarButtonItemStyleBordered
									target:self
									action:@selector(find)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
	
    NSArray *breadArray = [[NSArray alloc] initWithObjects:@"전체", 
                           @"제목", @"본문", @"제목+본문", @"작성자", nil];
    self.breadTypes = breadArray;
    [breadArray release];
    
    NSArray *fillingArray = [[NSArray alloc] initWithObjects: 
                             @"1주", @"1개월", @"2개월", 
                             @"3개월", @"6개월", @"전체", nil];
    self.fillingTypes = fillingArray;
    [fillingArray release];
}
-(void)find {
	
	self.Skeyword = [textField text];
	
	
	BbsSearchListViewController *bbsListViewController = [[[BbsSearchListViewController alloc]
													 initWithNibName:@"BbsSearchListViewController" 
													 bundle:nil] autorelease];
	
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	eGMIF.app = @"BBS";
	
	eGMIF.xmlArg1 = self.View_ID;			// BBS ID
	eGMIF.xmlArg2 = self.Stype;				// Search_Type
	eGMIF.xmlArg3 = self.Sterm;				// Search_Term ID
	eGMIF.xmlArg4 = self.Skeyword;		// Search_Keyword
	eGMIF.xmlArg5 = @"1";						// Req_Page 요청페이지
	eGMIF.xmlArg6 = @"9";						// ItemPerPage 페이지당 문서 개수 
	
    NSData *returnData = [eGMIF doGenRequestXML:@"BBS0004"];
	
	bbsListViewController.returnData = returnData;
	bbsListViewController.Bbs_string = self.View_ID;
	//bbsListViewController.refreshed = @"search";
	
	[[self navigationController] pushViewController:bbsListViewController animated:YES];
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.doublePicker = nil;
    self.breadTypes = nil;
    self.fillingTypes = nil;
	self.Sterm = nil;
	self.Stype = nil;
	self.Skeyword = nil;
	self.View_ID = nil;
    [super viewDidUnload];
}

- (void)dealloc {
	[textField release];
	[Sterm release];
	[Stype release];
	[Skeyword release];
	[View_ID release];
    [doublePicker release];
    [breadTypes release];
    [fillingTypes release];
	
    [super dealloc];
}
#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView  
numberOfRowsInComponent:(NSInteger)component
{
    if (component == kBreadComponent)
        return [self.breadTypes count];
    
    return [self.fillingTypes count];
}
#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component
{
    if (component == kBreadComponent){
		//NSLog([self.breadTypes objectAtIndex:row]);
		return [self.breadTypes objectAtIndex:row];
	}
        
    
    return [self.fillingTypes objectAtIndex:row];
//	NSLog(@"%@, %@",[self.breadTypes objectAtIndex:row], [self.breadTypes objectAtIndex:row]);
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	
	self.Stype = [NSString stringWithFormat:@"%d", [pickerView selectedRowInComponent:0]+1]; 
	self.Sterm = [NSString stringWithFormat:@"%d", [pickerView selectedRowInComponent:1]+1];

}
@end

