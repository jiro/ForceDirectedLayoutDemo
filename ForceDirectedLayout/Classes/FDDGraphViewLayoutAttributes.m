//
//  FDDGraphViewLayoutAttributes.m
//  ForceDirectedLayout
//
//  Created by Jiro Nagashima on 3/1/14.
//  Copyright (c) 2014 Jiro Nagashima. All rights reserved.
//

#import "FDDGraphViewLayoutAttributes.h"

@interface FDDGraphViewLayoutAttributes ()

@property (nonatomic, copy, readwrite) NSMutableArray *connectedAttributes;

@end

@implementation FDDGraphViewLayoutAttributes

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.size = CGSizeMake(44.0f, 44.0f);
        
        _connectedAttributes = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public

- (void)addConnectedAttributes:(FDDGraphViewLayoutAttributes *)attributes
{
    [self.connectedAttributes addObject:attributes];
    
    NSInteger s1 = arc4random_uniform(2) ? -1 : 1;
    NSInteger s2 = arc4random_uniform(2) ? -1 : 1;
    
    // Generate a random number (0.5 to 1.5)
    srand48(time(0));
    CGFloat r1 = drand48() + 0.5;
    CGFloat r2 = drand48() + 0.5;
    
    self.frame = CGRectOffset(attributes.frame, s1*r1, s2*r2);
}

- (void)removeConnectedAttributes:(FDDGraphViewLayoutAttributes *)attributes
{
    [self.connectedAttributes removeObject:attributes];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    FDDGraphViewLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes->_connectedAttributes = _connectedAttributes;
    return attributes;
}

@end
