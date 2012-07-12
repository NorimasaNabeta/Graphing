//
//  GraphView.m
//  Graphing
//
//  Created by 式正 鍋田 on 12/07/12.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//
#import <CoreGraphics/CoreGraphics.h>

#import "GraphView.h"
#import "AxesDrawer.h"
@implementation GraphView
@synthesize scale=_scale;
//@synthesize basePoint=_basePoint;

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
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
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
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

/*
- (CGPoint) basePoint
{
    if(! _basePoint){
        _basePoint = CGPointMake(0, 0);
    }
    return _basePoint;
}
- (void) setBasePoint:(CGPoint)basePoint
{
    if((basePoint.x != _basePoint.x) && (basePoint.y != basePoint.y)){
        _basePoint=basePoint;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }    
}
*/
- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        //self.basePoint = CGPointMake((self.basePoint.x-translation.x / 2),
        //                             (self.basePoint.y -translation.y/2));

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
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
