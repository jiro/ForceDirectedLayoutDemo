//
//  FDDLinksView.m
//  ForceDirectedLayout
//
//  Created by Jiro Nagashima on 3/1/14.
//  Copyright (c) 2014 Jiro Nagashima. All rights reserved.
//

#import "FDDLinksView.h"
#import "FDDGraphViewLayoutAttributes.h"

@implementation FDDLinksView

- (void)drawRect:(CGRect)rect
{
    for (FDDGraphViewLayoutAttributes *attributes in self.attributes) {
        for (FDDGraphViewLayoutAttributes *connectedAttributes in attributes.connectedAttributes) {
            UIBezierPath *bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint:[self convertPoint:attributes.center fromView:nil]];
            [bezierPath addLineToPoint:[self convertPoint:connectedAttributes.center fromView:nil]];
            [[UIColor lightGrayColor] setStroke];
            bezierPath.lineWidth = 1;
            [bezierPath stroke];
        }
    }
}

@end
