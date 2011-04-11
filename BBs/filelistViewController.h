//
//  filelistViewController.h
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 17..
//  Copyright 2010 cordial. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface filelistViewController : UITableViewController {

	NSString *temp;
	NSArray *filelist;
	NSString *View_ID;
	NSString *Doc_ID;
}
@property (nonatomic, retain) NSString *temp;
@property (nonatomic, retain) NSArray *filelist;
@property (nonatomic, retain) NSString *View_ID;
@property (nonatomic, retain) NSString *Doc_ID;
@end
