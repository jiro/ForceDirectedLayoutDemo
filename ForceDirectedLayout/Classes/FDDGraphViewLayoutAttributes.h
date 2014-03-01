//
//  FDDGraphViewLayoutAttributes.h
//  ForceDirectedLayout
//
//  Created by Jiro Nagashima on 3/1/14.
//  Copyright (c) 2014 Jiro Nagashima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDDGraphViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, copy, readonly) NSMutableArray *connectedAttributes;

- (void)addConnectedAttributes:(FDDGraphViewLayoutAttributes *)attributes;
- (void)removeConnectedAttributes:(FDDGraphViewLayoutAttributes *)attributes;

@end
