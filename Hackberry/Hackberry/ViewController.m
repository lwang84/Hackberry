//
//  ViewController.m
//  Hackberry
//
//  Created by Lingyong Wang on 11/2/12.
//  Copyright (c) 2012 Lingyong Wang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

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
    
    HBTile *tile = [[HBTile alloc] initWithFrame:frame];
    tile.backgroundColor = [UIColor blackColor];
    [tile setTitle:@"added button" forState:UIControlStateNormal];
    [tile addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tile];
    
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
