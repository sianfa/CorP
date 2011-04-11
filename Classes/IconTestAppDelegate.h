//
//  IconTestAppDelegate.h
//  IconTest
//
//  Created by 권혁 on 10. 5. 4..
//  Copyright 코디얼 2010. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface IconTestAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

