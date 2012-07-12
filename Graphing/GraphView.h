//
//  GraphView.h
//  Graphing
//
//  Created by Norimasa Nabeta on 12/07/12.
//  Copyright (c) 2012 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGFloat offsetx;
@property (nonatomic) CGFloat offsety;


// pinch for scaling
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
// pan for moving graph
- (void)pan:(UIPanGestureRecognizer *)gesture;

@end
