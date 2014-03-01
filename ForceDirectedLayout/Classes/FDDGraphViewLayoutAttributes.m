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
