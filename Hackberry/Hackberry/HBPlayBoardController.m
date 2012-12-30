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

@synthesize placeHolderTile;
@synthesize isSmilyFacesDown;
@synthesize blueSmilyFace;
@synthesize redSmilyFace;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void) setIsSmilyFacesDown:(Boolean)value
{
    if (isSmilyFacesDown != value) {
        isSmilyFacesDown = value;
        if(isSmilyFacesDown)
        {
            CGPoint center = CGPointMake(110, 80);
            UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut;
            [UIView animateWithDuration:0.3 delay:0.0 options:options animations:^{
                self.blueSmilyFace.center = center;
            } completion:nil];
            
            center = CGPointMake(210, 80);
            [UIView animateWithDuration:0.3 delay:0.0 options:options animations:^{
                self.redSmilyFace.center = center;
            } completion:nil];
        }
        else
        {
            CGPoint center = CGPointMake(110, -40);
            UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut;
            [UIView animateWithDuration:0.3 delay:0.0 options:options animations:^{
                self.blueSmilyFace.center = center;
            } completion:nil];
            
            center = CGPointMake(210, -40);
            [UIView animateWithDuration:0.3 delay:0.0 options:options animations:^{
                self.redSmilyFace.center = center;
            } completion:nil];
        }

    }
}

- (void)requestHighlightTiles:(NSArray*)tiles fromSmilyFace:(HBSmilyFace *)face
{
    for (int i = 0; i < tiles.count; i++) {
        NSNumber *idx  = [tiles objectAtIndex:i];
        HBTile *tile = [self.matrix objectAtIndex:[idx intValue]];
        [tile shakeIt];
    }
    CGRect popOverFrame;
    if (face == self.blueSmilyFace) {
        popOverFrame = CGRectMake(120,90,0,0);
    }
    else{
        popOverFrame = CGRectMake(200,90,0,0);
    }
    HBPlayedInfoPopOver* info = [[HBPlayedInfoPopOver alloc] initWithFrame:popOverFrame];
    [self.view addSubview:info];
    [info popOutAndPopIn];
}

- (void)initializeSmilyFaces
{
    self.isSmilyFacesDown = YES;
    CGRect blueSmilyFrame = CGRectMake(70,40,80,80);
    self.blueSmilyFace = [[HBSmilyFace alloc] initWithFrame:blueSmilyFrame
                                                      Color:[UIColor colorWithRed:0.0/255 green:166.0/255 blue:248.0/255 alpha:1]
                                                 FadedColor:[UIColor colorWithRed:0.0/255 green:85.0/255 blue:126.0/255 alpha:1]];
    self.blueSmilyFace.backgroundColor = [UIColor clearColor];
    self.blueSmilyFace.delegate = self;
    [self.view addSubview:self.blueSmilyFace];
    
    CGRect redSmilyFrame = CGRectMake(170,40,80,80);
    self.redSmilyFace = [[HBSmilyFace alloc] initWithFrame:redSmilyFrame
                                                     Color:[UIColor colorWithRed:255.0/255 green:68.0/255 blue:59.0/255 alpha:1]
                                                FadedColor:[UIColor colorWithRed:133.0/255 green:36.0/255 blue:31.0/255 alpha:1]];
    self.redSmilyFace.backgroundColor = [UIColor clearColor];
    self.redSmilyFace.delegate = self;
    [self.view addSubview:self.redSmilyFace];
}

- (void)initializeUpperLowerZones
{
    self.matrix = [[NSMutableArray alloc] init];
    self.upperZoneTiles = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            CGRect frame = [self getFrameForMatrixIdx:i*5+j];
            HBTile *tile = [[HBTile alloc] initWithFrameAndPosition:frame rowNum:i colNum:j];
            
            [tile addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
            tile.delegate = self;
            [tile setTitle:@"A" forState:UIControlStateNormal];
            [self.view addSubview:tile];
            [self.matrix addObject:tile];
        }
    }
}

- (void)initializeFuntionalButtons
{
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    placeHolderTile = [[HBTile alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:240.0/256 green:239.0/256 blue:236.0/256 alpha:1];

    [self requestNewGame:1];
}

- (void)requestNewGame:(int)playerId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:8000/api/%d/requestNewGame/", playerId]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [self initializeFuntionalButtons];
    [self initializeUpperLowerZones];
    [self initializeSmilyFaces];
    
    NSString *responseString = [request responseString];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *object = [parser objectWithString:responseString error:nil];
    NSString *letters = [object valueForKey:@"letters"];
    NSString *colorStatus = [object valueForKey:@"colorStatus"];
    
    for (int i = 0; i < self.matrix.count; i++) {
        HBTile *tile = [self.matrix objectAtIndex:i];
        NSString *letter = [[NSString stringWithFormat:@"%C", [letters characterAtIndex:i]] capitalizedString];
        [tile setTitle:letter forState:UIControlStateNormal];
        [tile setTitleColor:[UIColor colorWithRed:50.0/255 green:30.0/255 blue:28.0/255 alpha:1]
                   forState:UIControlStateNormal];
        tile.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:30.0];
        tile.backgroundColor = [self manufactorColorFromString:[NSString stringWithFormat:@"%C",[colorStatus characterAtIndex:i]]
                                                      forIndex:i];
    }
}

- (UIColor *) manufactorColorFromString:(NSString *) strColor forIndex: (int) idx
{
    if ([strColor isEqualToString:@"1"]) {
        return [UIColor colorWithRed:0.0/255 green:164.0/255 blue:248.0/255 alpha:1];
    }
    else if ([strColor isEqualToString:@"4"]) {
        return [UIColor colorWithRed:255.0/255 green:63.0/255 blue:56.0/255 alpha:1];
    }
    else if ([strColor isEqualToString:@"3"]){
        return [UIColor colorWithRed:251.0/255 green:152.0/255 blue:143.0/255 alpha:1];
    }
    else if ([strColor isEqualToString:@"2"]) {
        return [UIColor colorWithRed:114.0/255 green:201.0/255 blue:241.0/255 alpha:1];
    }
    else{
        if (idx%2 == 1) {
            return [UIColor colorWithRed:230.0/255 green:229.0/255 blue:226.0/255 alpha:1];
        }
        else{
            return [UIColor colorWithRed:232.0/255 green:231.0/255 blue:228.0/255 alpha:1];
        }
    }
}

- (CGRect)getFrameForMatrixIdx: (NSUInteger) idx
{
    int i = idx/5;
    int j = idx - i*5;
    CGFloat tileWidth = self.view.frame.size.width/5;
    CGFloat outerHeight = self.view.frame.size.height;
    CGRect frame = CGRectMake(tileWidth*j, tileWidth*i + outerHeight/3, tileWidth, tileWidth);
    return frame;
}


- (CGRect)getFrameForSelectedIdx: (NSUInteger) idx
{
    CGFloat outerWidth = self.view.frame.size.width;
    CGFloat outerHeight = self.view.frame.size.height;
    NSUInteger count = self.upperZoneTiles.count;
    double tileWidth = 40;
    if ((double)outerWidth*0.95/tileWidth < count)
    {
        tileWidth = (double)outerWidth*0.95/count;
    }
    
    return CGRectMake(outerWidth/2 + (idx - ((double)count)/2) * tileWidth, outerHeight*1/7.5, tileWidth,70);
}

- (int) calculateIdxToBeAdded: (HBTile *)tile
{
    if ([self.upperZoneTiles containsObject:tile]){
        return -1;
    }
    else{
        CGFloat outerWidth = self.view.frame.size.width;
        NSUInteger count = self.upperZoneTiles.count;
        double tileWidth = 40;
        if ((double)outerWidth*0.95/tileWidth < count)
        {
            tileWidth = (double)outerWidth*0.95/count;
        }
        //when the tile is on the most left, the idx is count, weired
        int idx = (tile.center.x - outerWidth/2)/tileWidth+(double)count/2 + 0.5;
        if (idx > self.upperZoneTiles.count) {
            idx = self.upperZoneTiles.count;
        }
        if (idx < 0)
        {
            idx = 0;
        }
        return idx;
    }
}

- (CGRect)getShrinkedFrame: (CGRect) frame
{
    CGFloat outerWidth = self.view.frame.size.width;
    NSUInteger count = self.upperZoneTiles.count + 1;
    double tileWidth = 40;
    if ((double)outerWidth*0.95/tileWidth < count)
    {
        tileWidth = (double)outerWidth*0.95/count;
    }
    return CGRectMake(frame.origin.x,frame.origin.y, tileWidth,70);
}

- (CGRect)getOriginalSizeFrame: (CGRect) frame
{
    CGFloat tileWidth = self.view.frame.size.width/5;
    return CGRectMake(frame.origin.x,frame.origin.y, tileWidth,tileWidth);
}

- (void) returnTiles:(NSMutableArray*)returningTiles{
    for (NSUInteger i = 0; i < returningTiles.count; i++) {
        HBTile *tile = [returningTiles objectAtIndex:i];
        [self.view bringSubviewToFront:tile];
        NSUInteger idx = [self.matrix indexOfObject:tile];
        UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.4 delay:0.0 options:options animations:^{
            tile.frame = [self getFrameForMatrixIdx:idx];
        } completion:^(BOOL finished) {
            tile.layer.shadowRadius = 0;
        }];
        
    }
}

- (CGRect)requestFrameInMatrix:(HBTile *)requestor
{
    NSUInteger idx = [self.matrix indexOfObject:requestor];
    int i = idx/5;
    int j = idx - i*5;
    CGFloat tileWidth = self.view.frame.size.width/5;
    CGFloat outerHeight = self.view.frame.size.height;
    CGRect frame = CGRectMake(tileWidth*i, tileWidth*j + outerHeight/3, tileWidth, tileWidth);
    return frame;
}

- (void) removeEmptySpotInSelectedZone{
    [self.upperZoneTiles removeObject:placeHolderTile];
}

- (void) tileTapped: (HBTile *)tile
{
    if ([self.upperZoneTiles containsObject:tile]){
        [self.upperZoneTiles removeObject:tile];
        NSMutableArray *returningTiles = [[NSMutableArray alloc] init];
        [returningTiles addObject:tile];
        [self returnTiles:returningTiles];
        if (self.upperZoneTiles.count == 0)
        {
            self.isSmilyFacesDown = YES;
        }
        else
        {
            self.isSmilyFacesDown = NO;
        }
    }
    else{
        [self.upperZoneTiles addObject:tile];
        self.isSmilyFacesDown = NO;
    }
    [self adjustUpperZonePositions];
    
    
}

- (void) tileAboutToMove: (HBTile *)tile
{
    [self.upperZoneTiles removeObject:tile];
}

- (void) tileMoved: (HBTile *)tile
{
    if([self isInSelectedZone:tile]){
        [self makeRoomForTile:tile];
    }
    else{
        [self.upperZoneTiles removeObject:self.placeHolderTile];
    }
    [self adjustTileSize:tile];
    [self adjustUpperZonePositions];
}

- (void) tileReleased: (HBTile *)tile
{
    [self.upperZoneTiles removeObject:self.placeHolderTile];
    if ([self isInSelectedZone:tile]){
        [self.upperZoneTiles insertObject:tile atIndex:[self  calculateIdxToBeAdded:tile]];
        [self adjustUpperZonePositions];
    }
    else{
        NSMutableArray *returningTiles = [[NSMutableArray alloc] init];
        [returningTiles addObject:tile];
        [self returnTiles:returningTiles];
    }
}

- (void) makeRoomForTile: (HBTile *)tile
{
    [self.upperZoneTiles removeObject:placeHolderTile];
    int idx = [self calculateIdxToBeAdded:tile];
    [self.upperZoneTiles insertObject:placeHolderTile atIndex:idx];

}

- (Boolean) isInSelectedZone:(HBTile *)tile{
    CGFloat outerHeight = self.view.frame.size.height;
    if (tile.frame.origin.y < outerHeight*1.5/7.5) {
        return true;
    }
    else{
        return false;
    }
}

- (void) adjustTileSize: (HBTile *)tile
{
    if ([self isInSelectedZone:tile])
    {
        UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^{
            tile.frame = [self getShrinkedFrame:tile.frame];
        } completion:nil];
        
    }
    else
    {
        UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^{
            tile.frame = [self getOriginalSizeFrame:tile.frame];
        } completion:nil];
        
    }
    
    if (self.upperZoneTiles.count == 0 && ![self isInSelectedZone:tile])
    {
        self.isSmilyFacesDown = YES;
    }
    else
    {
        self.isSmilyFacesDown = NO;
    }
    
}

- (void) adjustUpperZonePositions{
    for (NSUInteger i = 0; i < self.upperZoneTiles.count; i++) {
        HBTile *tile = [self.upperZoneTiles objectAtIndex:i];
        if (tile == placeHolderTile) {
            continue;
        }
        UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.4 delay:0.0 options:options animations:^{
            tile.frame = [self getFrameForSelectedIdx:i];
        } completion:^(BOOL finished) {
            tile.layer.shadowRadius = 0;
        }];
    }
}

- (void) tileRequestBringToFront: (HBTile *)tile
{
    [self.view bringSubviewToFront:tile];
}

- (void) tileRequestUpdateWasInSelectedZone: (HBTile *)tile;
{
    if([self isInSelectedZone:tile])
    {
        tile.wasInSelectedZone = true;
    }
    else
    {
        tile.wasInSelectedZone = false;
    }
}


- (void)submit:(UIButton *)sender
{
    [self.upperZoneTiles removeObject:self.placeHolderTile];
    NSString *selectedWord = @"";
    for (NSUInteger i = 0; i < self.upperZoneTiles.count; i++) {
        HBTile *tile = [self.upperZoneTiles objectAtIndex:i];        
        selectedWord = [selectedWord stringByAppendingString:[[tile titleLabel] text]];
    }
    NSLog(selectedWord);
}


- (void)clear:(UIButton *)sender
{
    [self returnTiles:self.upperZoneTiles];
    [self.upperZoneTiles removeAllObjects];
    self.isSmilyFacesDown = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
