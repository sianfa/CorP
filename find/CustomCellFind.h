//
//  CustomCellFind.h
//  IconTest
//
//  Created by 권혁 on 10. 5. 26..
//  Copyright 2010 코디얼. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCellFind : UITableViewCell {

	UILabel *nameLabel;
	UILabel *postLabel;
	UILabel *deptLabel;
	UILabel *handphoneLabel;
	
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *postLabel;
@property (nonatomic, retain) IBOutlet UILabel *deptLabel;
@property (nonatomic, retain) IBOutlet UILabel *handphoneLabel;

@end
