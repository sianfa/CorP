//
//  RootViewController.h
//  IconTest
//
//  Created by 권혁 on 10. 5. 4..
//  Copyright 코디얼 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeNode;
@class XMLParser;
@class BbsViewController;
@class SubsidiaryViewController;
@class eGateMobileIF;
@class ListViewController;

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	BbsViewController *bbsViewController;			// 게시판
	SubsidiaryViewController *findViewController;	//공지사항 바로가기
	ListViewController *listViewController;
	eGateMobileIF *eGMIF;							//XML 송신 
	TreeNode *root;									//트리 루트
	TreeNode *treeSelected;							//선택된 트리
	
	IBOutlet UITableView *myTableView;				//바로가기 테이블
	NSString *wCount;								//결재 카운트
	NSData *returnData;								//수신 데이터
	
	
	NSString *pimsID, *pimsPW;
}
@property (nonatomic, retain) ListViewController *listViewController;
@property (nonatomic, retain) SubsidiaryViewController *findViewController;
@property (nonatomic, retain) BbsViewController *bbsViewController;

@property (nonatomic, retain) eGateMobileIF *eGMIF;
@property (nonatomic, retain) TreeNode *root;
@property (nonatomic, retain) TreeNode *treeSelected;

@property (nonatomic, retain) IBOutlet UITableView *myTableView;

@property (nonatomic, retain) NSData *returnData;

@property (nonatomic, retain) NSString *pimsID;
@property (nonatomic, retain) NSString *pimsPW;

-(IBAction) approval;								//결재 아이콘
-(IBAction) bbs;									//게시판 아이콘
-(IBAction) find;									//사람찾기 아이콘
-(IBAction) setup;									//환경설정 아이콘
-(IBAction) mail;									//메일 아이콘
-(IBAction) calendar;								//일정 아이콘
-(IBAction) address;								//주소록 아이콘

@end
