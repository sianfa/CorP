//
//  BbsRepViewController.h
//  Bbs
//
//  Created by Hyeonu on 10. 5. 10..
//  Copyright 2010 CORDIAL. All rights reserved.
//

#import <UIKit/UIKit.h>


@class eGateMobileIF;

@interface WriterBViewController : UIViewController {
	UITextField *subjectFieldB;
	UITextView *textView;
	
	NSString *Bbs_string;
	NSString *parent_string;
	
	eGateMobileIF *eGMIF;
}

@property (nonatomic, retain) IBOutlet UITextField *subjectFieldB;

@property (nonatomic, retain) UITextView *textView;

@property (nonatomic, retain) NSString *Bbs_string;
@property (nonatomic, retain) NSString *parent_string;
@property (nonatomic, retain) eGateMobileIF *eGMIF;

@end