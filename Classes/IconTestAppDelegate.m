//
//  IconTestAppDelegate.m
//  IconTest
//
//  Created by 권혁 on 10. 5. 4..
//  Copyright 코디얼 2010. All rights reserved.
//

#import "IconTestAppDelegate.h"
#import "RootViewController.h"


@implementation IconTestAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"on"] isEqualToString:@"1"]) {
		[[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"on"];
		
	}
	
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

