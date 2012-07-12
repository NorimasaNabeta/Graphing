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
@property (nonatomic) CGFloat offsetx;
@property (nonatomic) CGFloat offsety;
@property (nonatomic) CGFloat midPointx;
@property (nonatomic) CGFloat midPointy;


// pinch for scaling
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
// pan for moving graph
- (void)pan:(UIPanGestureRecognizer *)gesture;

@end
