//
//  SubsidiaryViewController.h
//  Posco
//
//  Created by Hojun Park on 10. 3. 26..
//  Copyright 2010 Decsers Co, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeNode;
@class XMLParsers;
@class eGateMobileIF;

@interface SubsidiaryViewController : UITableViewController <UIActionSheetDelegate, UISearchBarDelegate> {
	
	TreeNode *root;
	TreeNode *treeselected;
	NSString *queryString;
	NSString *companyString;
	NSString *companyName;
	NSString *groupCode;
	
	NSData *returnData;
	
	UISearchBar *searchBar;
	eGateMobileIF *eGMIF;
	
	
}
@property (nonatomic, retain)	TreeNode *root;
@property (nonatomic, retain)	TreeNode *treeselected;
@property (nonatomic, retain)	NSString *queryString;
@property (nonatomic, retain)	NSString *companyString;
@property (nonatomic, retain)	NSString *companyName;
@property (nonatomic, retain)	NSString *groupCode;

@property (nonatomic, retain)	NSData *returnData;
@property (nonatomic, retain)	eGateMobileIF *eGMIF;

@property (retain) UISearchBar *searchBar;
@end

