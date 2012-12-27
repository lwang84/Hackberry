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

@interface HBPlayBoardController : UIViewController<ASIHTTPRequestDelegate, HBTileDelegate>
{
@private
    NSMutableArray *matrix;
    NSMutableArray *selectedTiles;
}
@property (retain) NSMutableArray *matrix;
@property (retain) NSMutableArray *selectedTiles;
@end
