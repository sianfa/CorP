//
//  eGateMobileIF.h
//  find
//
//  Created by 권혁 on 10. 5. 17..
//  Copyright 2010 코디얼. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMLParsers;


@interface eGateMobileIF : NSObject {
	
	NSData *returnData;
	
	NSString *xmlArg1, *xmlArg2, *xmlArg3, *xmlArg4, *xmlArg5, *xmlArg6, *xmlArg7;
	
	NSString *app;
	NSMutableString *smsURL;
	
	
	
}

@property(nonatomic, retain) NSData *returnData;
@property(nonatomic, retain) NSString *xmlArg1;
@property(nonatomic, retain) NSString *xmlArg2;
@property(nonatomic, retain) NSString *xmlArg3;
@property(nonatomic, retain) NSString *xmlArg4;
@property(nonatomic, retain) NSString *xmlArg5;
@property(nonatomic, retain) NSString *xmlArg6;
@property(nonatomic, retain) NSString *xmlArg7;
@property(nonatomic, retain) NSMutableString *smsURL;
@property(nonatomic, retain) NSString *app;

+(eGateMobileIF *) sharedInstance;
- (NSMutableString *) genRequestXML:(NSString *)msgID  applicationID:(NSString *)appID ;
- (NSMutableString *) genSourceXML:(NSString *)msgID doingTempRequestXML:(NSMutableString*)xmlStr;
- (NSData	*) doGenRequestXML:(NSString *)msgID ;
- (NSData	*) genLoginXML ;
@end
