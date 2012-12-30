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
#import "HBSmilyFace.h"
#import "HBPlayedInfoPopOver.h"

@class HBPlayBoardController;
@protocol HBPlayerBoardDataDelegate
@end


@interface HBPlayBoardController : UIViewController<ASIHTTPRequestDelegate, HBTileDelegate, SmilyFaceDelegate>

@property (retain) NSMutableArray *matrix;
@property (retain) NSMutableArray *upperZoneTiles;
@property HBTile *placeHolderTile;
@property HBSmilyFace *blueSmilyFace;
@property HBSmilyFace *redSmilyFace;
@property Boolean isSmilyFacesDown;
@end
