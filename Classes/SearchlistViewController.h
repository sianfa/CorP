//
//  SearchlistViewController.h
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 27..
//  Copyright 2010 cordial. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeNode;
@class XMLParser;
@class eGateMobileIF;

@interface SearchlistViewController : UIViewController {

	eGateMobileIF *eGMIF;
	TreeNode *root;
	TreeNode *treeSelected;
	
	UITableView *myTableView;
	NSString *idString;
	NSString *passString;
	NSString *dataString;
	NSString *View_ID;
	NSData *returnData;
	
	
}

@property (nonatomic, retain) eGateMobileIF *eGMIF;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) TreeNode *root;
@property (nonatomic, retain) TreeNode *treeSelected;
@property (nonatomic, retain) NSString *dataString;
@property (nonatomic, retain) NSData *returnData;
@property (nonatomic, retain) NSString *View_ID;;

@end
