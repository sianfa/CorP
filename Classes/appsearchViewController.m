//
//  searchViewController.m
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 10..
//  Copyright 2010 cordial. All rights reserved.
//

#import "appsearchViewController.h"
#import "SearchlistViewController.h"
#import "eGateMobileIF.h"


@implementation appsearchViewController
@synthesize doublePicker, textField;
@synthesize fillingTypes;
@synthesize breadTypes;
@synthesize View_ID;
@synthesize Stype, Sterm,Skeyword;
@synthesize eGMIF;


- (void)viewDidLoad {
	[super viewDidLoad];
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
									initWithTitle:@"검색"
									style:UIBarButtonItemStyleBordered
									target:self
									action:@selector(find)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
	self.title = @"검색";
    NSArray *breadArray = [[NSArray alloc] initWithObjects:@"전체", 
                           @"제목", @"본문", @"제목 & 본문", @"기안자", nil];
    self.breadTypes = breadArray;
    [breadArray release];
    
    NSArray *fillingArray = [[NSArray alloc] initWithObjects: 
                             @"1주일", @"1개월", @"2개월", 
                             @"3개월", @"6개월", @"전체", nil];
    self.fillingTypes = fillingArray;
    [fillingArray release];
}
-(void)find {
//	NSLog(self.View_ID);
//	NSLog(self.Sterm);
//	NSLog(self.Stype);
	self.Skeyword = [textField text];
	
	SearchlistViewController *detailViewController = [[SearchlistViewController alloc] initWithNibName:@"SearchlistViewController" bundle:nil];
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	eGMIF.app  = @"APRV";
	eGMIF.xmlArg1 = self.View_ID;
	eGMIF.xmlArg2 = self.Stype;
	eGMIF.xmlArg3 = self.Sterm;
	eGMIF.xmlArg4 = self.Skeyword;
	
	NSData *returnData = [eGMIF doGenRequestXML:@"APRV0006"];
	
	detailViewController.returnData = returnData;
	detailViewController.View_ID = View_ID;
	detailViewController.title = @"검색 결과";
	detailViewController.dataString = @"search";
	
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
	
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
		return [self.breadTypes objectAtIndex:row];
	}
        
    return [self.fillingTypes objectAtIndex:row];

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	
	self.Stype = [NSString stringWithFormat:@"%d",[pickerView selectedRowInComponent:0]+1]; 
	self.Sterm = [NSString stringWithFormat:@"%d",[pickerView selectedRowInComponent:1]+1];
}

@end

