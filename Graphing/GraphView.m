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
@synthesize offOrigin=_offOrigin;
@synthesize midPoint=_midPoint;

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
    }
}


- (void)tap:(UITapGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint tapPoint = [gesture locationInView:gesture.view];
        //NSLog(@"%g, %g", tapPoint.x, tapPoint.y);
        self.midPoint=tapPoint;
        [self setNeedsDisplay];
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
        self.offOrigin = CGPointMake((self.offOrigin.x + translation.x/2), 
                                     (self.offOrigin.y + translation.y/2));
        [self setNeedsDisplay];
        
        // reset
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
    self.offOrigin=CGPointZero;
    self.midPoint = CGPointMake((self.bounds.origin.x + self.bounds.size.width/2),
                                (self.bounds.origin.y + self.bounds.size.height/2));
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
    CGRect baseRect = self.bounds;
    baseRect.origin.x += self.offOrigin.x;
    baseRect.origin.y += self.offOrigin.y;
    
    // BoundaryRect
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddRect(context, baseRect);
    // CGContextFillPath(context);    
    CGContextStrokePath(context); 
    
    //[AxesDrawer drawAxesInRect:baseRect originAtPoint:self.midPoint scale:self.scale];
    CGPoint cookedPoint = CGPointMake(self.midPoint.x + self.offOrigin.x, self.midPoint.y + self.offOrigin.y);
    [AxesDrawer drawAxesInRect:baseRect originAtPoint:cookedPoint scale:self.scale];

}


@end
