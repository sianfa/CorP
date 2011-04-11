//
//  webViewController.h
//  BBS
//
//  Created by 권혁 on 10. 5. 7..
//  Copyright 2010 코디얼. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface webViewController : UIViewController {

	NSString *htmFile;
	IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *htmFile;
@end
