//
//  GraphView.h
//  Graphing
//
//  Created by 式正 鍋田 on 12/07/12.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
//@property (nonatomic) CGPoint basePoint;
@property (nonatomic) CGFloat offsetx;
@property (nonatomic) CGFloat offsety;


// pinch for scaling
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
// pan for moving graph
- (void)pan:(UIPanGestureRecognizer *)gesture;

@end
