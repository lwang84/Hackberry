//
//  HBTile.m
//  Hackberry
//
//  Created by Lingyong Wang on 11/20/12.
//  Copyright (c) 2012 Lingyong Wang. All rights reserved.
//

#import "HBTile.h"
#import <QuartzCore/QuartzCore.h>

@implementation HBTile

@synthesize isInSelectedZone;

- (id)initWithFrameAndPosition:(CGRect)frame rowNum:(int)row colNum:(int)col
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        UILongPressGestureRecognizer *longpressgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpress:)];
        
        //currentPoint = [self center];
        [self addGestureRecognizer:tapgr];
        [self addGestureRecognizer:pangr];
        [self addGestureRecognizer:longpressgr];
        self.layer.masksToBounds = YES;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
         
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    self.layer.masksToBounds = NO;
    [self.delegate tileRequestBringToFront: self];
    [self.delegate tileTapped:self];
    [self setNeedsDisplay];

}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    
    [self moveTileToPoint:gesture];
}

- (void)longpress:(UILongPressGestureRecognizer *)gesture
{
    
    [self moveTileToPoint:gesture];
}

- (void) moveTileToPoint:(UIGestureRecognizer *) gesture
{
    CGPoint point = [gesture locationInView:self.superview];

    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        isInSelectedZone = false;
        priorPoint = point;
        self.layer.masksToBounds = NO;
        [self.delegate tileRequestBringToFront: self];
        //self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/12);
        [self setNeedsDisplay];


    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint center = self.center;
        center.x += point.x - priorPoint.x;
        center.y += point.y - priorPoint.y;
        self.center = center;
        priorPoint = point;
        [self.delegate tileMoved:self];
        
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        //self.transform = CGAffineTransformIdentity;
        [self.delegate tileReleased:self];
        [self setNeedsDisplay];

    }
}

@end
