//
//  HBPlayBoardController.h
//  Hackberry
//
//  Created by Haidong Tang on 12/26/12.
//  Copyright (c) 2012 Lingyong Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBTile.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@class HBPlayBoardController;
@protocol HBPlayerBoardDataDelegate
@end


@interface HBPlayBoardController : UIViewController<ASIHTTPRequestDelegate, HBTileDelegate>

@property (retain) NSMutableArray *matrix;
@property (retain) NSMutableArray *upperZoneTiles;
@property HBTile *placeHolderTile;
@end
