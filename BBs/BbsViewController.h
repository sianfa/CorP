//
//  BbsViewController.h
//  Bbs
//
//  Created by Hyeonu on 10. 5. 10..
//  Copyright CORDIAL 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeNode;
@class XMLParser;
@class eGateMobileIF;

@interface BbsViewController : UITableViewController {
	NSMutableArray *menuList;
	
	
	TreeNode *root;				//트리 루트
	TreeNode *treeselected;		//선택된 트리
	NSString *sendViewID;
	eGateMobileIF *eGMIF;
}
@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) TreeNode *root;
@property (nonatomic, retain) TreeNode *treeselected;
@property (nonatomic, retain) eGateMobileIF *eGMIF;

@end

