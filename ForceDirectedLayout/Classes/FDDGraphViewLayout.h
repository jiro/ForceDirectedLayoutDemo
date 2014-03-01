//
//  FDDForceDirectedLayout.h
//  ForceDirectedLayout
//
//  Created by Jiro Nagashima on 2/23/14.
//  Copyright (c) 2014 Jiro Nagashima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDDGraphViewLayout : UICollectionViewLayout

- (NSArray *)forcedItems;

- (void)startPanItemAtIndexPath:(NSIndexPath *)indexPath atPoint:(CGPoint)point;
- (void)updatePanPoint:(CGPoint)point;
- (void)endPan;

@end
