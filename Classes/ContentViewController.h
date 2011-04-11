//
//  ContentViewController.h
//  IconTest
//
//  Created by 권혁 on 10. 5. 6..
//  Copyright 2010 코디얼. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeNode;
@class XMLParser;
@class editViewController;
@class eGateMobileIF;


@interface ContentViewController : UIViewController <UIActionSheetDelegate> {

	eGateMobileIF *eGMIF;
	editViewController *EditViewController;
	
	TreeNode *root;
	TreeNode *treeselected;
	
	NSData *returnData;
	
	NSString *htmlFile;
	
	NSString *nameString;
	NSString *lineString;
	NSString *downString;
	NSString *dateString;
	NSString *temp;



	UILabel *name;
	UILabel *date;
	UILabel *down;
	UILabel *line;
	
	NSString *View_ID;
	NSString *Doc_ID;
	NSString *app;
	
	IBOutlet UIWebView *webView;
	
	UIBarButtonItem *appButton;

}
@property (nonatomic, retain) eGateMobileIF *eGMIF;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *appButton;

@property (nonatomic, retain) editViewController *EditViewController;

@property (nonatomic, retain) TreeNode *root;
@property (nonatomic, retain) TreeNode *treeselected;

@property (nonatomic, retain) NSString *htmlFile;

@property (nonatomic, retain) NSData *returnData;

@property (nonatomic, retain) NSString *nameString;
@property (nonatomic, retain) NSString *lineString;
@property (nonatomic, retain) NSString *downString;
@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) NSString *temp;



@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *down;
@property (nonatomic, retain) IBOutlet UILabel *line;

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, retain) NSString *View_ID;
@property (nonatomic, retain) NSString *Doc_ID;



//-(IBAction)approval;
-(IBAction)full;
-(IBAction)approvalline;
-(IBAction)filelist;
@end
