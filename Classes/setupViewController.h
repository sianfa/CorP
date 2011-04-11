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

@interface setupViewController : UIViewController {
	TreeNode *root;
	TreeNode *treeselected;
	IBOutlet UITextField *idField;
	IBOutlet UITextField *passField;
	IBOutlet UITextField *serverField;
	NSString *idString;
	NSString *passString;

	UISwitch *swc;
	UILabel *tilt;
	
	eGateMobileIF *eGMIF;
}
@property (nonatomic, retain) IBOutlet UILabel *tilt;
@property (nonatomic, retain) IBOutlet UISwitch *swc;
@property (nonatomic, retain) TreeNode *root;
@property (nonatomic, retain) TreeNode *treeselected;
@property (nonatomic, retain) eGateMobileIF *eGMIF;


- (IBAction)switchChanged:(id)sender;


@end
