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

@synthesize wasInSelectedZone;
@synthesize priorPoint;
@synthesize originalFrame;
@synthesize delegate;

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
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 0.5;         
    }
    
    return self;
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    self.layer.shadowRadius = 5;
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
        [self.delegate tileRequestUpdateWasInSelectedZone:self];
        priorPoint = point;
        self.layer.shadowRadius = 5;
        [self.delegate tileRequestBringToFront: self];
        //self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/12);
        [self setNeedsDisplay];
        [self.delegate tileAboutToMove:self];
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

- (void) shakeIt
{
    [self.delegate tileRequestBringToFront:self];
    double startRotationValue = [[[self.layer presentationLayer] valueForKeyPath:@"transform.rotation"] doubleValue];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 1;
    int steps = 100;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps];
    double value = 0;
    float e = 2.71;
    for (int t = 0; t < steps; t++) {
        value = startRotationValue + 1.0/500*(120 * pow(e, -0.03*t) * sin(0.17*t));
        [values addObject:[NSNumber numberWithFloat:value]];
    }
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
    
    
    self.layer.shadowRadius = 0;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"shadowRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 1;
    values = [NSMutableArray arrayWithCapacity:steps];
    for (int t = 0; t < steps; t++) {
        if (t < 50) {
            value = t*1.0/10;
        }
        else{
            value = (steps-t)*1.0/10;
        }
        
        [values addObject:[NSNumber numberWithFloat:value]];
    }
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
    
    
    
    
    /*
     CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
     double startRotationValue = [[[tile.layer presentationLayer] valueForKeyPath:@"transform.rotation.z"] doubleValue];
     rotation.fromValue = [NSNumber numberWithDouble:startRotationValue];
     rotation.toValue = [NSNumber numberWithDouble:startRotationValue+0.4];
     rotation.duration = 0.4;
     [tile.layer addAnimation:rotation forKey:@"rotating"];
     */
    
    /*
     CGPoint center = tile.center;
     CGPoint newCenter = CGPointMake(center.x+10, center.y+10);
     
     UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut;
     [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^{
     tile.center = newCenter;
     } completion:^(BOOL finished) {
     [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^{
     tile.center = center;
     } completion:nil];
     }];*/

    
}

@end
