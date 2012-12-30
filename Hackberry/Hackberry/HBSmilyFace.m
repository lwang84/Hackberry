//
//  FaceView.m
//  Happiness
//
//  Created by CS193p Instructor on 10/5/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "HBSmilyFace.h"
#import <QuartzCore/QuartzCore.h>

@implementation HBSmilyFace
@synthesize faceColor;
@synthesize regularColor;
@synthesize fadedColor;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame Color: (UIColor *)color FadedColor: (UIColor *)colorF{
    if ((self = [super initWithFrame:frame])) {
        UILongPressGestureRecognizer *longpressgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpress:)];
        longpressgr.minimumPressDuration = 0;
        [self addGestureRecognizer:longpressgr];
        self.faceColor = color;
        self.regularColor = color;
        self.fadedColor = colorF;
    }
    return self;
}
- (void) setFaceColor:(UIColor *)color
{
    faceColor = color;
    [self setNeedsDisplay];
}

- (void)longpress:(UILongPressGestureRecognizer *)gesture
{
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        self.faceColor = self.fadedColor;
    }
    else
    {
        
        self.faceColor = self.regularColor;
        NSMutableArray *played = [NSMutableArray array];
        [played addObject:[NSNumber numberWithInteger:1]];
        [played addObject:[NSNumber numberWithInteger:2]];
        [played addObject:[NSNumber numberWithInteger:3]];
        [self.delegate requestHighlightTiles:[NSArray arrayWithArray:played] fromSmilyFace:self];
    }
    
    [self setNeedsDisplay];
}


- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
	UIGraphicsPushContext(context);
	CGContextBeginPath(context);
	CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
	CGContextStrokePath(context);
	UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
	CGPoint midPoint;
	midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
	midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
	
	CGFloat size = self.bounds.size.width / 2;
	if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height / 2;
	size *= 0.90;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 5.0);
	[self.faceColor setStroke];
	
	[self drawCircleAtPoint:midPoint withRadius:size inContext:context];
	
#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_RADIUS 0.10
	
	CGPoint eyePoint;
	eyePoint.x = midPoint.x - size * EYE_H;
	eyePoint.y = midPoint.y - size * EYE_V;
	[self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
	eyePoint.x += size * EYE_H * 2;
	[self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
	
#define MOUTH_H 0.45
#define MOUTH_V 0.4
#define MOUTH_SMILE 0.25
	
	CGPoint mouthStart;
	mouthStart.x = midPoint.x - MOUTH_H * size;
	mouthStart.y = midPoint.y + MOUTH_V * size;
	CGPoint mouthEnd = mouthStart;
	mouthEnd.x += MOUTH_H * size * 2;
	CGPoint mouthCP1 = mouthStart;
	mouthCP1.x += MOUTH_H * size * 2/3;
	CGPoint mouthCP2 = mouthEnd;
	mouthCP2.x -= MOUTH_H * size * 2/3;
	
	// use delegate here to get smile

	//float smile = [self.delegate smileForFaceView:self];
    float smile = 1.0;
	if (smile < -1.0) smile = -1.0;
	if (smile > 1.0) smile = 1.0;
	CGFloat smileOffset = MOUTH_SMILE * size * smile;
	mouthCP1.y += smileOffset;
	mouthCP2.y += smileOffset;
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
	CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
	CGContextStrokePath(context);
}

@end
