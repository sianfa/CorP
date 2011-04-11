//
//  BbsListViewController.h
//  Bbs
//
//  Created by Hyeonu on 10. 5. 10..
//  Copyright 2010 CORDIAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeNode;
@class XMLParser;
@class searchViewController;


@interface BbsListViewController : UIViewController  {
	
	UITableView *myTableView;
	searchViewController *SearchViewController;
	TreeNode *root;				//트리 루트
	TreeNode *treeselected;		//선택된 트리
	NSString *Bbs_string;		//돌아온 데이터(?)
	NSString *refreshed;
	
	NSData *returnData;
	eGateMobileIF *eGMIF;
	
}
@property (nonatomic, retain) searchViewController *SearchViewController;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain)	TreeNode *root;
@property (nonatomic, retain)	TreeNode *treeselected;
@property (nonatomic, retain)	NSString *Bbs_string;
@property (nonatomic, retain) NSString *refreshed;


@property (nonatomic, retain)	NSData *returnData;
@property (nonatomic, retain) eGateMobileIF *eGMIF;

- (IBAction)compose;
- (IBAction)search;
- (IBAction)refresh;

@end