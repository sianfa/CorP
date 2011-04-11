/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

//
//  XMLParser.h
//  Created by Erica Sadun on 4/6/09.
//

#import <CoreFoundation/CoreFoundation.h>
#import "TreeNode.h"

@interface XMLParsers : NSObject
{
	NSMutableArray		*stack;
}

+ (XMLParsers *) sharedInstance;
- (TreeNode *) parseXMLFromURL: (NSURL *) url;
- (TreeNode *) parseXMLFromData: (NSData*) data;
@end

