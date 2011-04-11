//
//  approvalViewController.h
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 10..
//  Copyright 2010 cordial. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eGateMobileIF;

@interface approvalViewController : UIViewController<UITextViewDelegate> {
	
	eGateMobileIF *eGMIF;
	
	UITextView *textView;
	NSString *View_ID;
	NSString *Doc_ID;
	NSString *approvalText;
	NSString *app;
	UILabel *titl;
}
@property (nonatomic, retain) eGateMobileIF *eGMIF;

@property (nonatomic, retain) NSString *app;
@property (nonatomic, retain) IBOutlet UILabel *titl;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) NSString *View_ID;
@property (nonatomic, retain) NSString *Doc_ID;
@property (nonatomic, retain) NSString *approvalText;
-(IBAction)approval;
-(IBAction)cancel;

@end
