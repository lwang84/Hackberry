//
//  ViewController.m
//  Hackberry
//
//  Created by Lingyong Wang on 11/2/12.
//  Copyright (c) 2012 Lingyong Wang. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect frame = CGRectMake(90, 200, 200, 60);
    UIButton *someAddButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    someAddButton.backgroundColor = [UIColor clearColor];
    [someAddButton setTitle:@"动态添加一个按钮!" forState:UIControlStateNormal];
    someAddButton.frame = frame;
    //[someAddButton addTarget:self action:@selector(someButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:someAddButton];
    
//    HBTile *tile = [[HBTile alloc] initWithFrame:frame];
//    tile.backgroundColor = [UIColor blackColor];
//    [tile setTitle:@"added button" forState:UIControlStateNormal];
//    [tile addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:tile];
    
    
    CGFloat outerHeight = self.view.frame.size.height;
    CGFloat outerWidth = self.view.frame.size.width;

    CGRect topbarFrame = CGRectMake(0, outerHeight/7.5, outerWidth, outerHeight/7.5);
//    HBSelectionBar *topbar = [[HBSelectionBar alloc] initWithFrame:topbarFrame];
//    topbar.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:topbar];
//    
//    CGRect matrixFrame = CGRectMake(0, outerHeight/3, outerWidth, outerHeight*2/3);
//    HBWordsMatrix *matrix = [[HBWordsMatrix alloc] initWithFrame:matrixFrame];
//    matrix.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:matrix];
//    [matrix addTiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) test {
    NSLog(@"taped");
}

- (IBAction)requestNewGame:(id)sender {
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
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
}

@end
