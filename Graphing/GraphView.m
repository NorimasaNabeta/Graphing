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

- (CGFloat) offsetx
{
    if (! _offsetx) {
        _offsetx=DEFAULT_SCALE;
    }
    return _offsetx;
}
- (void)setOffsetx:(CGFloat)offsetx
{
    if (offsetx != _offsetx) {
        _offsetx = offsetx;
        [self setNeedsDisplay];
    }
}
- (CGFloat) offsety
{
    if (! _offsety) {
        _offsety=DEFAULT_SCALE;
    }
    return _offsety;
}
- (void)setOffsety:(CGFloat)offsety
{
    if (offsety != _offsety) {
        _offsety = offsety;
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
        
        // reset
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)setup
{
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
    
    CGPoint midPoint; // center of our bounds in our coordinate system
    CGRect baseRect = self.bounds;
    baseRect.origin.x += self.offsetx;
    baseRect.origin.y += self.offsety;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddRect(context, baseRect);
    // CGContextFillPath(context);    
    CGContextStrokePath(context); 
    
    [AxesDrawer drawAxesInRect:baseRect originAtPoint:midPoint scale:self.scale];

}


@end
