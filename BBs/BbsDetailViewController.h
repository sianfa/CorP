//
//  BbsDetailViewController.h
//  Bbs
//
//  Created by Hyeonu on 10. 5. 10..
//  Copyright 2010 CORDIAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeNode;
@class XMLParser;
@class eGateMobileIF;

@interface BbsDetailViewController : UIViewController <UIActionSheetDelegate> {
	
	
	TreeNode *root;				//트리 루트
	TreeNode *treeselected;		//선택된 트리
	
	NSData *returnData;
	UITableView *tableView;
	
	NSString *nameString;		// 이름
	NSString *titleString;		// 게시글 제목
	NSString *dateString;		// 조직이름
	NSString *contextString;	// 회사코드
	NSString *parent_string;
	NSString *Bbs_string;
	NSString *files;
	NSString *Doc_ID;
	NSString *mtitle;
	NSString *status;
	
	UILabel *name;
	UILabel *date;
	UILabel *title;
	UILabel *rCount;
	UILabel *cCount;
	UILabel *attach;
	
	eGateMobileIF *eGMIF;
	
	
	IBOutlet UIWebView *webView;
}
@property (nonatomic, retain)	TreeNode *root;
@property (nonatomic, retain)	TreeNode *treeselected;
@property (nonatomic, retain)	NSData *returnData;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *rCount;
@property (nonatomic, retain) IBOutlet UILabel *cCount;
@property (nonatomic, retain) IBOutlet UILabel *attach;

@property (nonatomic, retain) NSString *nameString;
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) NSString *contextString;
@property (nonatomic, retain) NSString *parent_string;
@property (nonatomic, retain) NSString *Bbs_string;
@property (nonatomic, retain) NSString *Doc_ID;
@property (nonatomic, retain) NSString *mtitle;
@property (nonatomic, retain) NSString *status;

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) eGateMobileIF *eGMIF;

- (IBAction)actionPressed;
//- (IBAction)compose;
- (IBAction)search;
- (IBAction)resList;
- (IBAction)repList;
- (IBAction)trash;
- (IBAction)download;

@end