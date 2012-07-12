//
//  GraphingViewController.m
//  Graphing
//
//  Created by 式正 鍋田 on 12/07/12.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "GraphingViewController.h"

@interface GraphingViewController ()

@end

@implementation GraphingViewController
@synthesize graphView=_graphView;


-(void) setGraphView:(GraphView *)graphView
{
    _graphView=graphView;
    // enable pinch gestures for scaling
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    // enable pan gestures for moving graph
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]]; 

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
