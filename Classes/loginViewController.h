//
//  loginViewController.h
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 19..
//  Copyright 2010 cordial. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeNode;
@class XMLParser;
@class eGateMobileIF;

@interface loginViewController : UIViewController {
	eGateMobileIF *eGMIF;
	TreeNode *root;
	TreeNode *treeselected;
	IBOutlet UITextField *idField;
	IBOutlet UITextField *passField;
	UILabel *tilt;
}
@property (nonatomic, retain) eGateMobileIF *eGMIF;
@property (nonatomic, retain) IBOutlet UILabel *tilt;
@property (nonatomic, retain) TreeNode *root;
@property (nonatomic, retain) TreeNode *treeselected;
//@property (nonatomic, retain) IBOutlet UITextField *idField;
//@property (nonatomic, retain) IBOutlet UITextField *passField;


-(IBAction)login;

@end
