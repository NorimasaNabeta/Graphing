//
//  GraphView.h
//  Graphing
//
//  Created by Norimasa Nabeta on 12/07/12.
//  Copyright (c) 2012 Norimasa Nabeta. All rights reserved.
//

// Graphing
// git@github.com:NorimasaNabeta/Graphing.git
//
// https://github.com/NorimasaNabeta/Graphing.git
//
#import <UIKit/UIKit.h>

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;

//
// http://stackoverflow.com/questions/2971842/cgrect-var-as-property-value
// CGRect is a struct, not an NSObject.
//
@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,assign) CGRect rectGraph;

// pinch for scaling
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
// pan for moving graph
- (void)pan:(UIPanGestureRecognizer *)gesture;
// tap(Triple-tap) for moving the origin of the graph
- (void)pan:(UIPanGestureRecognizer *)gesture;


@end
