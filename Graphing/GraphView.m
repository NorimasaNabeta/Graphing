//
//  GraphView.m
//  Graphing
//
//  Created by Norimasa Nabeta on 12/07/12.
//  Copyright (c) 2012 Norimasa Nabeta. All rights reserved.
//
#import "GraphView.h"
#import "AxesDrawer.h"
@implementation GraphView
@synthesize scale=_scale;
@synthesize origin=_origin;
@synthesize rectGraph=_rectGraph;

#define DEFAULT_SCALE 0.90

- (CGFloat) scale
{
    if (! _scale) {
        _scale=DEFAULT_SCALE;
    }
    return _scale;
}
- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw

        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setDouble:self.scale forKey:@"scale"];
        [ud synchronize];
    }
}

- (void) setOrigin:(CGPoint)origin
{
    if((_origin.x != origin.x) || (_origin.y != origin.y)){
        _origin=origin;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw        

        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *origin = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithDouble:self.origin.x], @"x", 
                                [NSNumber numberWithDouble:self.origin.y], @"y", 
                                nil ];
        [ud setObject:origin forKey:@"origin"];
        [ud synchronize];
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint tapPoint = [gesture locationInView:gesture.view];
        //NSLog(@"%g, %g", tapPoint.x, tapPoint.y);
        self.origin=tapPoint;
    }
}


- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        // NSLog(@"%g, %g", translation.x, translation.y);
        self.rectGraph= CGRectMake((self.rectGraph.origin.x+translation.x/2), (self.rectGraph.origin.y+translation.y/2),
                                   self.rectGraph.size.width, self.rectGraph.size.height);
        self.origin = CGPointMake((self.origin.x + translation.x/2), (self.origin.y + translation.y/2));
        
        // reset
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)setup
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    double scaleVal = [ud doubleForKey:@"scale"];
    if (scaleVal) {
        // NSLog(@"[scale] Set defauls value : %g", scaleVal);
        self.scale = scaleVal;
    }
    NSDictionary *dicOrigin = [ud objectForKey:@"origin"];
    if (dicOrigin) {
        self.origin = CGPointMake([[dicOrigin objectForKey:@"x"] doubleValue], [[dicOrigin objectForKey:@"y"] doubleValue]);
        // NSLog(@"[origin] Set defauls value : (%g,%g)", pnt.x, pnt.y);
    }
    else {
        //self.origin = CGPointZero;        
        self.origin = CGPointMake((self.bounds.origin.x + self.bounds.size.width/2),
                                  (self.bounds.origin.y + self.bounds.size.height/2));
    }   
    self.rectGraph = self.bounds;
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us
    }
    return self;
}

 - (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // BoundaryRect
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddRect(context, self.rectGraph);
    // CGContextFillPath(context);    
    CGContextStrokePath(context); 

    [AxesDrawer drawAxesInRect:self.rectGraph originAtPoint:self.origin scale:self.scale];

}


@end
