//
//  HBTile.h
//  Hackberry
//
//  Created by Lingyong Wang on 11/20/12.
//  Copyright (c) 2012 Lingyong Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBTile;
@protocol HBTileDelegate
- (void) tileRequestBringToFront: (HBTile *)tile;
- (void) tileReleased: (HBTile *)tile;
- (void) tileAboutToMove: (HBTile *)tile;
- (void) tileMoved: (HBTile *)tile;
- (void) tileTapped: (HBTile *)tile;
- (void) tileRequestUpdateWasInSelectedZone: (HBTile *)tile;

@end

@interface HBTile : UIButton{
    CGPoint priorPoint;
    id<HBTileDelegate> delegate;
    CGRect originalFrame;

}
- (id)initWithFrameAndPosition:(CGRect)frame rowNum:(int)row colNum:(int)col;
@property CGPoint priorPoint;
@property CGRect originalFrame;
@property (assign) id <HBTileDelegate> delegate;
@property Boolean wasInSelectedZone;


@end
