//
//  WriterViewController.h
//  Bbs
//
//  Created by Hyeonu on 10. 5. 11..
//  Copyright 2010 CORDIAL. All rights reserved.
//
#import <UIKit/UIKit.h>

@class TreeNode;
@class XMLParser;
@class eGateMobileIF;

@interface WriterMViewController : UIViewController {
	
	TreeNode *root;				//트리 루트
	TreeNode *treeselected;
	
	UITextField *subjectField;
	UITextView *textView;
	NSData *returnData;
	
	NSString *Bbs_string;
	NSString *parent_string;
	NSString *DocID;
	NSString *m_title;
	
	eGateMobileIF *eGMIF;
}
@property (nonatomic, retain)	TreeNode *root;
@property (nonatomic, retain)	TreeNode *treeselected;

@property (nonatomic, retain) IBOutlet UITextField *subjectField;

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) NSData *returnData;

@property (nonatomic, retain) NSString *Bbs_string;
@property (nonatomic, retain) NSString *parent_string;
@property (nonatomic, retain) NSString *DocID;
@property (nonatomic, retain) NSString *m_title;
@property (nonatomic, retain) eGateMobileIF *eGMIF;

@end