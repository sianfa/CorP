//
//  DetailViewController.h
//  IconTest
//
//  Created by 권혁 on 10. 5. 4..
//  Copyright 2010 코디얼. All rights reserved.
//

#import <UIKit/UIKit.h>
					

@class TreeNode;
@class XMLParser;
@class appsearchViewController;
@class eGateMobileIF;

@interface DetailViewController : UIViewController {
	
	eGateMobileIF *eGMIF;
	
	UITableView *myTableView;
	appsearchViewController *SearchViewController;
	TreeNode *root;
	TreeNode *treeSelected;

	NSData *returnData;
	NSString *View_ID;
	
}
@property (nonatomic, retain) eGateMobileIF *eGMIF;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;

@property (nonatomic, retain) appsearchViewController *SearchViewController;
@property (nonatomic, retain) TreeNode *root;
@property (nonatomic, retain) TreeNode *treeSelected;
@property (nonatomic, retain) NSData *returnData;
@property (nonatomic, retain) NSString *View_ID;;

-(IBAction)search;
-(IBAction)refresh;


@end
