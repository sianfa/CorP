//
//  UserViewController.h
//  Posco
//
//  Created by Hojun Park on 10. 3. 30..
//  Copyright 2010 Decsers Co, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserViewController : UIViewController {

	NSString *nameString;		// 이름
	NSString *titleString;		// 직급
	NSString *organString;		// 조직이름
	NSString *companyString;	// 회사코드
	NSString *emailString;		// 이메일
	NSString *phoneString;		// 핸드폰
	NSString *homeString;		// 집전화 집전화 없는경우 조직도에서 들어온 경우. 
	NSString *officeString;		// 사무실 
	NSString *faxString;
	
	UILabel *name;
	UILabel *organization;
	UILabel *company;
	
	UIButton *email;
	UIButton *phone;
	UIButton *sms;
	UIButton *homePhone;
	UIButton *officePhone;
	UIButton *faxNumber;
	
	
}

@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *organization;
@property (nonatomic, retain) IBOutlet UILabel *company;

@property (nonatomic, retain) IBOutlet UIButton *email;
@property (nonatomic, retain) IBOutlet UIButton *phone;
@property (nonatomic, retain) IBOutlet UIButton *sms;
@property (nonatomic, retain) IBOutlet UIButton *homePhone;
@property (nonatomic, retain) IBOutlet UIButton *officePhone;
@property (nonatomic, retain) IBOutlet UIButton *faxNumber;



@property (nonatomic, retain) NSString *nameString;
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) NSString *organString;
@property (nonatomic, retain) NSString *companyString;
@property (nonatomic, retain) NSString *emailString;
@property (nonatomic, retain) NSString *phoneString;
@property (nonatomic, retain) NSString *homeString;
@property (nonatomic, retain) NSString *officeString;
@property (nonatomic, retain) NSString *faxString;



- (IBAction) sendEmail: (id) sender;
- (IBAction) callHandPhone: (id) sender;
- (IBAction) sendSMS: (id) sender;
- (IBAction) callHomePhone: (id) sender;
- (IBAction) callOfficePhone: (id) sender;

@end
