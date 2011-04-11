//
//  FindViewController.h
//  
//
//  Created by 정환 on 10. 5. 10..
//  Copyright 2010 Decsers Co, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeNode;
@class XMLParser;

@interface FindViewController : UITableViewController <UIActionSheetDelegate> {
	
	TreeNode *root;
	TreeNode *treeselected;
	NSString *queryString;
	NSString *companyString;
	NSString *companyName;
	
	NSData *returnData;
	UISearchBar *searchBar;
	
	NSInteger isNone;
}

@property (nonatomic, retain)	TreeNode *root;
@property (nonatomic, retain)	TreeNode *treeselected;
@property (nonatomic, retain)	NSString *queryString;
@property (nonatomic, retain)	NSString *companyString;
@property (nonatomic, retain)	NSString *companyName;
@property (nonatomic, retain)	NSData *returnData;

@property (retain) UISearchBar *searchBar;

@end
