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

@synthesize offsetx=_offsetx;
@synthesize offsety=_offsety;
@synthesize midPointx=_midPointx;
@synthesize midPointy=_midPointy;

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
        self.midPointx=tapPoint.x;
        self.midPointy=tapPoint.y;
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
        self.offsetx -= -translation.x / 2;
        self.offsety -= -translation.y / 2;
        [self setNeedsDisplay];
        
        // reset
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
    self.midPointx = self.bounds.origin.x + self.bounds.size.width/2;
    self.midPointy = self.bounds.origin.y + self.bounds.size.height/2;
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
    CGPoint midPoint=CGPointMake(self.midPointx, self.midPointy);

    CGRect baseRect = self.bounds;
    baseRect.origin.x += self.offsetx;
    baseRect.origin.y += self.offsety;

    // BoundaryRect
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddRect(context, baseRect);
    // CGContextFillPath(context);    
    CGContextStrokePath(context); 
    
    [AxesDrawer drawAxesInRect:baseRect originAtPoint:midPoint scale:self.scale];

}


@end
