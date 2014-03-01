//
//  FDDGraphViewNode.m
//  ForceDirectedLayout
//
//  Created by Jiro Nagashima on 2/23/14.
//  Copyright (c) 2014 Jiro Nagashima. All rights reserved.
//

#import "FDDNodeCell.h"

@implementation FDDNodeCell

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.layer.cornerRadius = layoutAttributes.size.width / 2;
}

@end
