//
//  ViewController.h
//  Hackberry
//
//  Created by Lingyong Wang on 11/2/12.
//  Copyright (c) 2012 Lingyong Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "HBTile.h"

@interface ViewController : UIViewController <ASIHTTPRequestDelegate>
- (IBAction)requestNewGame:(id)sender;

@end
