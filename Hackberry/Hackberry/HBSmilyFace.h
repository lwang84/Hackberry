//
//  FaceView.h
//  Happiness
//
//  Created by CS193p Instructor on 10/5/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBSmilyFace;

@protocol SmilyFaceDelegate
- (void)requestHighlightTiles:(NSArray*)tiles fromSmilyFace:(HBSmilyFace *)face;
@end

@interface HBSmilyFace : UIView {
}
- (id)initWithFrame:(CGRect)frame Color: (UIColor *)color FadedColor: (UIColor *)colorF;

@property (retain) UIColor* faceColor;
@property (retain) UIColor* regularColor;
@property (retain) UIColor* fadedColor;
@property (assign) id <SmilyFaceDelegate> delegate;


@end
