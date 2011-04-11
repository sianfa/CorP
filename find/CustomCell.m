//
//  CustomCell.m
//  IconTest
//
//  Created by 권혁 on 10. 5. 25..
//  Copyright 2010 코디얼. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell

@synthesize nameLabel, deptLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
