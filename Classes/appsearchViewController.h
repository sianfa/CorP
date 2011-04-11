//
//  searchViewController.h
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 10..
//  Copyright 2010 cordial. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eGateMobileIF;

#define kFillingComponent 1
#define kBreadComponent 0


@interface appsearchViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	eGateMobileIF *eGMIF;
	UIPickerView *doublePicker;
	NSArray *fillingTypes;
	NSArray *breadTypes;
	NSString *View_ID;
	NSString *Stype;
	NSString *Sterm;
	NSString *Skeyword;
	

	UITextField *textField;
	
	
}
@property (nonatomic, retain) eGateMobileIF *eGMIF;
@property(nonatomic, retain) IBOutlet UIPickerView *doublePicker;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property(nonatomic, retain) NSArray *fillingTypes;
@property(nonatomic, retain) NSArray *breadTypes;
@property (nonatomic, retain) NSString *View_ID;
@property (nonatomic, retain) NSString *Stype;
@property (nonatomic, retain) NSString *Sterm;
@property (nonatomic, retain) NSString *Skeyword;


@end
