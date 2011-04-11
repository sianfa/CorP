//
//  CustomCell.h
//  IconTest
//
//  Created by 권혁 on 10. 5. 25..
//  Copyright 2010 코디얼. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {
	UILabel *nameLabel;
	UILabel *deptLabel;

}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *deptLabel;

@end
