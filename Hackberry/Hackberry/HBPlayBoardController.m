//
//  HBPlayBoardController.m
//  Hackberry
//
//  Created by Haidong Tang on 12/26/12.
//  Copyright (c) 2012 Lingyong Wang. All rights reserved.
//

#import "HBPlayBoardController.h"
#import <QuartzCore/QuartzCore.h>

@interface HBPlayBoardController ()

@end

@implementation HBPlayBoardController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect submitFrame = CGRectMake(240,6,70,40);
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:submitFrame];
    [submitBtn setBackgroundColor:[UIColor blueColor]];
    [submitBtn setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    
    submitBtn.layer.cornerRadius = 10; 
    submitBtn.clipsToBounds = YES;
    
    CGRect clearFrame = CGRectMake(20,6,60,30);
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:clearFrame];
    [clearBtn setBackgroundColor:[UIColor grayColor]];
    [clearBtn setTitle:@"clear" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
	
    matrix = [[NSMutableArray alloc] init];
    selectedTiles = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            CGRect frame = [self getFrameForMatrixIdx:i*5+j];
            HBTile *tile = [[HBTile alloc] initWithFrameAndPosition:frame rowNum:i colNum:j];
            if((i*5+j)%2 == 1)
            {
                tile.backgroundColor = [UIColor darkGrayColor];
            }
            else
            {
                tile.backgroundColor = [UIColor grayColor];
            }
            
            [tile addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
            tile.delegate = self;
            [tile setTitle:@"A" forState:UIControlStateNormal];
            [self.view addSubview:tile];
            [matrix addObject:tile];
        }
    }
    
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8000/api/1/requestNewGame/"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *object = [parser objectWithString:responseString error:nil];
    NSString *letters = [object valueForKey:@"letters"];
    
    for (int i = 0; i < matrix.count; i++) {
        HBTile *tile = [matrix objectAtIndex:i];
        NSString *letter = [NSString stringWithFormat:@"%C", [letters characterAtIndex:i]];
        [tile setTitle:[letter capitalizedString] forState:UIControlStateNormal];

    }
}

- (CGRect)getFrameForMatrixIdx: (NSUInteger) idx
{
    int i = idx/5;
    int j = idx - i*5;
    CGFloat tileWidth = self.view.frame.size.width/5;
    CGFloat outerHeight = self.view.frame.size.height;
    CGRect frame = CGRectMake(tileWidth*i, tileWidth*j + outerHeight/3, tileWidth, tileWidth);
    return frame;
}


- (CGRect)getFrameForSelectedIdx: (NSUInteger) idx
{
    CGFloat outerWidth = self.view.frame.size.width;
    CGFloat outerHeight = self.view.frame.size.height;
    NSUInteger count = selectedTiles.count;
    double tileWidth = 40;
    if ((double)outerWidth*0.95/tileWidth < count)
    {
        tileWidth = (double)outerWidth*0.95/count;
    }
    
    return CGRectMake(outerWidth/2 + (idx - ((double)count)/2) * tileWidth, outerHeight*1/7.5, tileWidth,70);
}

- (CGRect)getShrinkedFrame: (CGRect) frame
{
    CGFloat outerWidth = self.view.frame.size.width;
    NSUInteger count = selectedTiles.count + 1;
    double tileWidth = 40;
    if ((double)outerWidth*0.95/tileWidth < count)
    {
        tileWidth = (double)outerWidth*0.95/count;
    }
    return CGRectMake(frame.origin.x,frame.origin.y, tileWidth,70);
}


- (void) adjustSelectedTilesPositions{
    for (NSUInteger i = 0; i < selectedTiles.count; i++) {
        HBTile *tile = [selectedTiles objectAtIndex:i];
        UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.4 delay:0.0 options:options animations:^{
            tile.frame = [self getFrameForSelectedIdx:i];
        } completion:^(BOOL finished) {
            tile.layer.masksToBounds = YES;
        }];
    }
}

- (void) returnTiles:(NSMutableArray*)returningTiles{
    for (NSUInteger i = 0; i < returningTiles.count; i++) {
        HBTile *tile = [returningTiles objectAtIndex:i];
        NSUInteger idx = [matrix indexOfObject:tile];
        UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.4 delay:0.0 options:options animations:^{
            tile.frame = [self getFrameForMatrixIdx:idx];
        } completion:^(BOOL finished) {
            tile.layer.masksToBounds = YES;
        }];

    }
}

- (CGRect)requestOriginalFrame:(HBTile *)requestor
{
    NSUInteger idx = [matrix indexOfObject:requestor];
    int i = idx/5;
    int j = idx - i*5;
    CGFloat tileWidth = self.view.frame.size.width/5;
    CGFloat outerHeight = self.view.frame.size.height;
    CGRect frame = CGRectMake(tileWidth*i, tileWidth*j + outerHeight/3, tileWidth, tileWidth);
    return frame;
    
}

- (void) tileReleased: (HBTile *)tile
{
    if (tile.isInSelectedZone){
        [selectedTiles addObject:tile];
        [self adjustSelectedTilesPositions];
        
    }
    else{
        NSUInteger idx = [matrix indexOfObject:tile];
        UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.4 delay:0.0 options:options animations:^{
            tile.frame = [self getFrameForMatrixIdx:idx];
        } completion:^(BOOL finished) {
            tile.layer.masksToBounds = YES;
        }];
    }
}

- (void) tileTapped: (HBTile *)tile
{
    if ([selectedTiles containsObject:tile]) {
        [selectedTiles removeObject:tile];
        
        NSMutableArray *returningTiles = [[NSMutableArray alloc] init];
        [returningTiles addObject:tile];
        [self returnTiles:returningTiles];
        NSLog(@"removed");
        
    }
    else{
        [selectedTiles addObject:tile];
        NSLog(@"added");
    }
    [self adjustSelectedTilesPositions];
}

- (void) tileMoved: (HBTile *)tile
{
    CGFloat outerHeight = self.view.frame.size.height;
    if (tile.frame.origin.y < outerHeight*1.5/7.5)
    {
        UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^{
            tile.frame = [self getShrinkedFrame:tile.frame];
        } completion:nil];
        tile.isInSelectedZone = true;
    }
    else
    {
        tile.isInSelectedZone = false;
    }
}

- (void) tileRequestBringToFront: (HBTile *)tile
{
    [self.view bringSubviewToFront:tile];
}


- (void)submit:(UIButton *)sender
{
    NSString *selectedWord = @"";
    for (NSUInteger i = 0; i < selectedTiles.count; i++) {
        
        HBTile *tile = [selectedTiles objectAtIndex:i];
        selectedWord = [selectedWord stringByAppendingString:[[tile titleLabel] text]];
    }
    NSLog(selectedWord);
}


- (void)clear:(UIButton *)sender
{
    [self returnTiles:selectedTiles];
    [selectedTiles removeAllObjects];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
