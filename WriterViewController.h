//
//  WriterViewController.h
//  Bbs
//
//  Created by Hyeonu on 10. 5. 11..
//  Copyright 2010 CORDIAL. All rights reserved.
//
#import <UIKit/UIKit.h>

@class eGateMobileIF; 


@interface WriterViewController : UIViewController {
	UITextField *subjectField;
	UITextView *textView;
	
	NSString *Bbs_string;
	NSString *parent_string;
	
	eGateMobileIF *eGMIF; 
}
@property (nonatomic, retain) IBOutlet UITextField *subjectField;

@property (nonatomic, retain) UITextView *textView;

@property (nonatomic, retain) NSString *Bbs_string;
@property (nonatomic, retain) NSString *parent_string;
@property (nonatomic, retain) eGateMobileIF *eGMIF;
@end