//
//  ListViewController.h
//  IconTest
//
//  Created by hyuk kwon on 10. 5. 18..
//  Copyright 2010 cordial. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListViewController : UITableViewController {

	NSMutableArray *menuList;
}

@property (nonatomic, retain) NSMutableArray *menuList;
@end
