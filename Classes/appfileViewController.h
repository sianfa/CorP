//
//  fileViewController.h
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 17..
//  Copyright 2010 cordial. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeNode;
@class XMLParser;
@class eGateMobileIF;

@interface appfileViewController : UIViewController {
	
	eGateMobileIF *eGMIF;
	TreeNode *root;
	TreeNode *treeselected;

	IBOutlet UIWebView *myWebView;
	NSString *View_ID;
	NSString *Doc_ID;
	NSString *Attached;

}
@property (nonatomic, retain) eGateMobileIF *eGMIF;
@property (nonatomic, retain) IBOutlet UIWebView *myWebView;
@property (nonatomic, retain) NSString *View_ID;
@property (nonatomic, retain) NSString *Doc_ID;
@property (nonatomic, retain) NSString *Attached;
@property (nonatomic, retain) TreeNode *root;
@property (nonatomic, retain) TreeNode *treeselected;
@end
