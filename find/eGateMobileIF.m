//
//  eGateMobileIF.m
//  find
//
//  Created by 정환 on 10. 5. 17..
//  Copyright 2010 코디얼. All rights reserved.
//

#import "eGateMobileIF.h"
#import "XMLParsers.h"

@implementation eGateMobileIF

@synthesize returnData;
@synthesize xmlArg1;
@synthesize xmlArg2;
@synthesize xmlArg3;
@synthesize xmlArg4;
@synthesize xmlArg5;
@synthesize xmlArg6;
@synthesize xmlArg7;
@synthesize smsURL;
@synthesize app;


static eGateMobileIF *sharedInstance = nil;

// Use just one parser instance at any time
+(eGateMobileIF *) sharedInstance 
{
    if(!sharedInstance) {
		sharedInstance = [[self alloc] init];
    }	
    return sharedInstance;
}


//doGenRequestXML
- (NSData	*) doGenRequestXML:(NSString *)msgID {
	
	smsURL = [NSMutableString stringWithCapacity:1024];
	
	[smsURL appendFormat:[NSString stringWithFormat:@"http://%@/egateplugin.nsf/BlackBerryXMLServiceForm?OpenForm&Seq=1&Charset=utf-8",[[NSUserDefaults standardUserDefaults] objectForKey:@"server"]]];
	
	
	NSMutableString *tempRequestXML = [NSMutableString stringWithCapacity:2048];
	
	[tempRequestXML appendFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
	[tempRequestXML appendFormat:@"<root>"];
	[tempRequestXML appendFormat:@"<dataset id=\"Header\">"];
	[tempRequestXML appendFormat:@"<colinfo id=\"Application_ID\" type=\"STRING\"/>"];
	[tempRequestXML appendFormat:@"<colinfo id=\"Proto_Version\" type=\"STRING\"/>"];
	[tempRequestXML appendFormat:@"<colinfo id=\"MessageID\" type=\"STRING\"/>"];
	[tempRequestXML appendFormat:@"<colinfo id=\"Id\" type=\"STRING\"/>"];
	[tempRequestXML appendFormat:@"<colinfo id=\"Password\" type=\"STRING\"/>"];
	[tempRequestXML appendFormat:@"<colinfo id=\"Status\" type=\"STRING\"/>"];
	[tempRequestXML appendFormat:@"<record>"];
	[tempRequestXML appendFormat:@"<Application_ID><![CDATA[0000]]></Application_ID>"];
	[tempRequestXML appendFormat:@"<Proto_Version><![CDATA[001.000]]></Proto_Version>"];
	[tempRequestXML appendFormat:@"<MessageID><![CDATA[%@]]></MessageID>",msgID];
	[tempRequestXML appendFormat:[NSString stringWithFormat:@"<Id><![CDATA[%@]]></Id>", [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]]];
	[tempRequestXML appendFormat:[NSString stringWithFormat:@"<Password><![CDATA[%@]]></Password>", [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]]];
	[tempRequestXML appendFormat:@"<Status><![CDATA[ 0 ]]></Status>"];
	[tempRequestXML appendFormat:@"</record>"];
	[tempRequestXML appendFormat:@"</dataset>"];
	
	NSLog(@"메세지 아이디 : %@",msgID);
	//RequestBody 꾸미기
	[self genSourceXML:msgID doingTempRequestXML:tempRequestXML];
	
	[tempRequestXML appendFormat:@"</root>"];
	NSLog(@"Request = %@ \n", tempRequestXML);
	
	NSMutableString *escaped = [tempRequestXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];	
	[escaped replaceOccurrencesOfString:@"." withString:@"%2E" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];	
	[escaped replaceOccurrencesOfString:@"-" withString:@"%2D" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];	
	[escaped replaceOccurrencesOfString:@"_" withString:@"%5F" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];	
	[escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"!" withString:@"%21" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];
	
	
	//RequestTail 꾸미기
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
	
	NSString *post = [NSString stringWithFormat:@"__Click=0&Request_Content=%@&%%25%%25PostCharset=UTF-8&app=%@",escaped,app];
	
	
	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
	
	[request setURL:[NSURL URLWithString:smsURL]];
	
	[request setHTTPMethod:@"POST"];
	
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	
	[request setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
	
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	[request setHTTPBody:postData];
	
	
	//최종적으로 escaped는 NSData형태의 returnData로 가야한다.
	
	//	returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}






- (NSMutableString *) genSourceXML:(NSString *)msgID doingTempRequestXML:(NSMutableString*)xmlStr{
	
	if (msgID == @"FIND0001"){
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"DeptName\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"DeptCode\" type=\"STRING\"/>"];		
		[xmlStr appendFormat:@"<colinfo id=\"OrgCode\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"PrevDeptCode\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<DeptName><![CDATA[%@]]></DeptName>",xmlArg1];
		[xmlStr appendFormat:@"<DeptCode><![CDATA[%@]]></DeptCode>",xmlArg2];
		[xmlStr appendFormat:@"<OrgCode><![CDATA[%@]]></OrgCode>",xmlArg3];
		[xmlStr appendFormat:@"<PrevDeptCode><![CDATA[%@]]></PrevDeptCode>",xmlArg4];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
		
	} 
	else if(msgID == @"FIND0002"){
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];		
		[xmlStr appendFormat:@"<colinfo id=\"CompanyCode\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"KeyWord\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<CompanyCode><![CDATA[%@]]></CompanyCode>",xmlArg1];
		[xmlStr appendFormat:@"<KeyWord><![CDATA[%@]]></KeyWord>",xmlArg2];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}else if (msgID == @"A0000021") {
		
	}else if (msgID == @"APRV0001") {
		
	}
	
	else if (msgID == @"APRV0003") {
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"View_ID\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"Req_Page\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"ItemPerPage\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<View_ID><![CDATA[%@]]></View_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Req_Page><![CDATA[1]]></Req_Page>"];
		[xmlStr appendFormat:@"<ItemPerPage><![CDATA[50]]></ItemPerPage>"];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}
	else if (msgID == @"APRV0004") {
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"View_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Doc_ID\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<View_ID><![CDATA[%@]]></View_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Doc_ID><![CDATA[%@]]></Doc_ID>",xmlArg2];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}
	
	
	else if(msgID == @"APRV0005") {
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"View_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Doc_ID\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"Attached_File_Name\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<View_ID><![CDATA[%@]]></View_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Doc_ID><![CDATA[%@]]></Doc_ID>",xmlArg2];
		[xmlStr appendFormat:@"<Attached_File_Name><![CDATA[%@]]></Attached_File_Name>",xmlArg3];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
		
	}
	else if (msgID == @"APRV0006") {
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"View_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Search_Type\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Search_Term\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Search_Keyword\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Req_Page\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"ItemPerPage\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<View_ID><![CDATA[%@]]></View_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Search_Type><![CDATA[%@]]></Search_Type>",xmlArg2];
		[xmlStr appendFormat:@"<Search_Term><![CDATA[%@]]></Search_Term>",xmlArg3];
		[xmlStr appendFormat:@"<Search_Keyword><![CDATA[%@]]></Search_Keyword>",xmlArg4];
		[xmlStr appendFormat:@"<Req_Page><![CDATA[1]]></Req_Page>"];
		[xmlStr appendFormat:@"<ItemPerPage><![CDATA[50]]></ItemPerPage>"];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
		
	}
	else if (msgID == @"APRV0007") {
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"View_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Doc_ID\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"Action_Code\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"Comment\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<View_ID><![CDATA[eGPAprvWait]]></View_ID>"];
		[xmlStr appendFormat:@"<Doc_ID><![CDATA[%@]]></Doc_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Action_Code><![CDATA[%@]]></Action_Code>",xmlArg2];
		[xmlStr appendFormat:@"<Comment><![CDATA[%@]]></Comment>",xmlArg3];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}
	else if (msgID == @"APRV0008") {
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"View_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Doc_ID\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"Req_Page\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"ItemPerPage\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<View_ID><![CDATA[%@]]></View_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Doc_ID><![CDATA[%@]]></Doc_ID>",xmlArg2];
		[xmlStr appendFormat:@"<Req_Page><![CDATA[1]]></Req_Page>"];
		[xmlStr appendFormat:@"<ItemPerPage><![CDATA[50]]></ItemPerPage>"];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}
	else if (msgID == @"BBS0001") {
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"Bbs_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Doc_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Display_Type\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<Req_Page><![CDATA[%@]]></Req_Page>",xmlArg1];
		[xmlStr appendFormat:@"<ItemPerPage><![CDATA[%@]]></ItemPerPage>",xmlArg2];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}
	else if (msgID == @"BBS0002") {
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"Bbs_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Doc_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Display_Type\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<Bbs_ID><![CDATA[%@]]></Bbs_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Req_Page><![CDATA[%@]]></Req_Page>",xmlArg2];
		[xmlStr appendFormat:@"<ItemPerPage><![CDATA[%@]]></ItemPerPage>",xmlArg3];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}
	else if (msgID == @"BBS0003") {
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"Bbs_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Doc_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Display_Type\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<Bbs_ID><![CDATA[%@]]></Bbs_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Doc_ID><![CDATA[%@]]></Doc_ID>",xmlArg2];
		[xmlStr appendFormat:@"<Display_Type><![CDATA[%@]]></Display_Type>",xmlArg3];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}
	else if(msgID == @"BBS0004"){
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"Bbs_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Search_Type\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Search_Term\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Search_Keyword\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Req_Page\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"ItemPerPage\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<Bbs_ID><![CDATA[%@]]></Bbs_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Search_Type><![CDATA[%@]]></Search_Type>",xmlArg2];
		[xmlStr appendFormat:@"<Search_Term><![CDATA[%@]]></Search_Term>",xmlArg3];
		[xmlStr appendFormat:@"<Search_Keyword><![CDATA[%@]]></Search_Keyword>",xmlArg4];
		[xmlStr appendFormat:@"<Req_Page><![CDATA[%@]]></Req_Page>",xmlArg5];
		[xmlStr appendFormat:@"<ItemPerPage><![CDATA[%@]]></ItemPerPage>",xmlArg6];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];		
	}
	else if (msgID == @"BBS0005") {
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"Bbs_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Parent_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Doc_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Subject\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Bbs_Category\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"EndDate\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Body\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Attached_File_Count\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<Bbs_ID><![CDATA[%@]]></Bbs_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Parent_ID><![CDATA[%@]]></Parent_ID>",xmlArg2];
		[xmlStr appendFormat:@"<Doc_ID><![CDATA[%@]]></Doc_ID>",xmlArg3];
		[xmlStr appendFormat:@"<Subject><![CDATA[%@]]></Subject>",xmlArg4];
		[xmlStr appendFormat:@"<Bbs_Category><![CDATA[%@]]></Bbs_Category>",xmlArg5];
		[xmlStr appendFormat:@"<EndDate><![CDATA[%@]]></EndDate>",xmlArg6];
		[xmlStr appendFormat:@"<Body><![CDATA[%@]]></Body>",xmlArg7];
		[xmlStr appendFormat:@"<Attached_File_Count><![CDATA[0]]></Attached_File_Count>"];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}	
	else if(msgID == @"BBS0006"){		
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];		
		[xmlStr appendFormat:@"<colinfo id=\"Bbs_ID\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"Parent_ID\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"Req_Page\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"ItemPerPage\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<Bbs_ID><![CDATA[%@]]></Bbs_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Parent_ID><![CDATA[%@]]></Parent_ID>",xmlArg2];
		[xmlStr appendFormat:@"<Req_Page><![CDATA[%@]]></Req_Page>",xmlArg3];
		[xmlStr appendFormat:@"<ItemPerPage><![CDATA[%@]]></ItemPerPage>",xmlArg4];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}	
	else if(msgID == @"BBS0007"){
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"Bbs_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Doc_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Comment\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<Bbs_ID><![CDATA[%@]]></Bbs_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Doc_ID><![CDATA[%@]]></Doc_ID>",xmlArg2];
		[xmlStr appendFormat:@"<Comment><![CDATA[%@]]></Comment>",xmlArg3];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}
	else if(msgID == @"BBS0008"){		
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];		
		[xmlStr appendFormat:@"<colinfo id=\"Bbs_ID\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"Parent_ID\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"Req_Page\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"ItemPerPage\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<Bbs_ID><![CDATA[%@]]></Bbs_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Parent_ID><![CDATA[%@]]></Parent_ID>",xmlArg2];
		[xmlStr appendFormat:@"<Req_Page><![CDATA[%@]]></Req_Page>",xmlArg3];
		[xmlStr appendFormat:@"<ItemPerPage><![CDATA[%@]]></ItemPerPage>",xmlArg4];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}
	else if(msgID == @"BBS0009"){		
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];		
		[xmlStr appendFormat:@"<colinfo id=\"Bbs_ID\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<colinfo id=\"Doc_ID_Count\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<Bbs_ID><![CDATA[%@]]></Bbs_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Doc_ID_Count><![CDATA[%@]]></Doc_ID_Count>",xmlArg2];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
		
		[xmlStr appendFormat:@"<dataset id=\"Body1\">"];		
		[xmlStr appendFormat:@"<colinfo id=\"Doc_ID\" type=\"STRING\"/>"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<Doc_ID><![CDATA[%@]]></Doc_ID>",xmlArg3];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];	
	}
	else if(msgID == @"BBS0011"){		
		[xmlStr appendFormat:@"<dataset id=\"Body0\">"];
		[xmlStr appendFormat:@"<colinfo id=\"Bbs_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Doc_ID\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<colinfo id=\"Attached_File_Name\" type=\"STRING\" />"];
		[xmlStr appendFormat:@"<record>"];
		[xmlStr appendFormat:@"<Bbs_ID><![CDATA[%@]]></Bbs_ID>",xmlArg1];
		[xmlStr appendFormat:@"<Doc_ID><![CDATA[%@]]></Doc_ID>",xmlArg2];
		[xmlStr appendFormat:@"<Attached_File_Name><![CDATA[%@]]></Attached_File_Name>",xmlArg3];
		[xmlStr appendFormat:@"</record>"];
		[xmlStr appendFormat:@"</dataset>"];
	}
	
	return xmlStr;
}










- (NSData	*) genLoginXML {
	smsURL = [NSMutableString stringWithCapacity:1024];
	
	[smsURL appendFormat:[NSString stringWithFormat:@"http://%@/egateplugin.nsf/BlackBerryXMLServiceForm?OpenForm&Seq=1&Charset=utf-8",[[NSUserDefaults standardUserDefaults] objectForKey:@"server"]]];
	NSMutableString *tempRequestXML = [NSMutableString stringWithCapacity:2048];
	
	[tempRequestXML appendFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
	[tempRequestXML appendFormat:@"<root>"];
	[tempRequestXML appendFormat:@"<dataset id=\"Header\">"];
	[tempRequestXML appendFormat:@"<colinfo id=\"Application_ID\" type=\"STRING\"/>"];
	[tempRequestXML appendFormat:@"<colinfo id=\"Proto_Version\" type=\"STRING\"/>"];
	[tempRequestXML appendFormat:@"<colinfo id=\"MessageID\" type=\"STRING\"/>"];
	[tempRequestXML appendFormat:@"<colinfo id=\"Id\" type=\"STRING\"/>"];
	[tempRequestXML appendFormat:@"<colinfo id=\"Password\" type=\"STRING\"/>"];
	[tempRequestXML appendFormat:@"<colinfo id=\"Status\" type=\"STRING\"/>"];
	[tempRequestXML appendFormat:@"<record>"];
	[tempRequestXML appendFormat:@"<Application_ID><![CDATA[0000]]></Application_ID>"];
	[tempRequestXML appendFormat:@"<Proto_Version><![CDATA[001.000]]></Proto_Version>"];
	[tempRequestXML appendFormat:@"<MessageID><![CDATA[A0000021]]></MessageID>"];
	[tempRequestXML appendFormat:@"<Id><![CDATA[%@]]></Id>",[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
	[tempRequestXML appendFormat:@"<Password><![CDATA[%@]]></Password>",[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
	[tempRequestXML appendFormat:@"<Status><![CDATA[ 0 ]]></Status>"];
	[tempRequestXML appendFormat:@"</record>"];
	[tempRequestXML appendFormat:@"</dataset>"];
	
	
	[tempRequestXML appendFormat:@"</root>"];
	NSLog(@"Request = %@ \n", tempRequestXML);
	
	NSMutableString *escaped = [tempRequestXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];	
	[escaped replaceOccurrencesOfString:@"." withString:@"%2E" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];	
	[escaped replaceOccurrencesOfString:@"-" withString:@"%2D" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];	
	[escaped replaceOccurrencesOfString:@"_" withString:@"%5F" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];	
	[escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"!" withString:@"%21" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range: NSMakeRange(0, [escaped length])];
	
	
	//RequestTail 꾸미기
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
	
	NSString *post = [NSString stringWithFormat:@"__Click=0&Request_Content=%@&%%25%%25PostCharset=UTF-8&app=Common",escaped];
	
	
	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
	
	[request setURL:[NSURL URLWithString:smsURL]];
	
	[request setHTTPMethod:@"POST"];
	
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	
	[request setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
	
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	[request setHTTPBody:postData];
	
	
	NSError *error = nil;

	return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];

}

@end









