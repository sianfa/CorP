//
//  editViewController.h
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 11..
//  Copyright 2010 cordial. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeNode;
@class XMLParser;

@interface editViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	UITableView *myTableView;
	
	TreeNode *root;
	TreeNode *treeSelected;
	
	NSData *returnData;
	
	NSString *View_ID;
	NSString *Doc_ID;

}

@property (nonatomic, retain) TreeNode *root;
@property (nonatomic, retain) TreeNode *treeSelected;
@property (nonatomic, retain) NSData *returnData;
@property (nonatomic, retain) NSString *View_ID;
@property (nonatomic, retain) NSString *Doc_ID;
@end
