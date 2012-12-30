//
//  HBPlayedInfoPopOver.m
//  Hackberry
//
//  Created by Haidong Tang on 12/30/12.
//  Copyright (c) 2012 Lingyong Wang. All rights reserved.
//

#import "HBPlayedInfoPopOver.h"
#import <QuartzCore/QuartzCore.h>

@implementation HBPlayedInfoPopOver

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setTitle:@"AAA Played BBB" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.cornerRadius = 10;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.2;
    }
    return self;
}

- (void) popOutAndPopIn
{
    CGRect boundMin = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 0, 0);
    CGRect boundMax = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 150, 50);
    self.bounds = boundMin;
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut;
    [UIView animateWithDuration:0.3 delay:0.0 options:options animations:^{
        self.bounds = boundMax;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1.0 options:options animations:^{
            self.bounds = boundMin;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
