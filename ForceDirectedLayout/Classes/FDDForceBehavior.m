//
//  FDDForceBehavior.m
//  ForceDirectedLayout
//
//  Created by Jiro Nagashima on 2/23/14.
//  Copyright (c) 2014 Jiro Nagashima. All rights reserved.
//

#import "FDDForceBehavior.h"

@interface FDDForceBehavior ()

@property (nonatomic, copy, readwrite) NSMutableArray *items;

@end

@implementation FDDForceBehavior

#pragma mark - Lifecycle

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        _items = [items mutableCopy];
        
        [self addChildBehaviorsToEachItems];
    }
    return self;
}

#pragma mark - Public

- (void)addItem:(id<UIDynamicItem>)item
{
    for (id<UIDynamicItem> otherItem in self.items) {
        [self addPushBehaviorsToItem:item otherItem:otherItem];
        [self addAttachmentBehaviorToItem:item otherItem:otherItem];
    }
    
    [self.items addObject:item];
}

#pragma mark - Private

- (void)addChildBehaviorsToEachItems
{
    for (NSInteger i = 0; i < [self.items count]; i++) {
        id<UIDynamicItem> item = self.items[i];

        for (NSInteger j = (i + 1); j < [self.items count]; j++) {
            id<UIDynamicItem> otherItem = self.items[j];
            
            [self addPushBehaviorsToItem:item otherItem:otherItem];
            [self addAttachmentBehaviorToItem:item otherItem:otherItem];
        }
    }
}

- (void)addPushBehaviorsToItem:(id<UIDynamicItem>)item otherItem:(id<UIDynamicItem>)otherItem
{
    UIPushBehavior *pushBehavior;
    
    CGPoint translation = CGPointMake(item.center.x - otherItem.center.x, item.center.y - otherItem.center.y);
    CGFloat tx = translation.x / 100.0f;
    CGFloat ty = translation.y / 100.0f;
    
    CGFloat distance = hypotf(tx, ty);
    CGFloat magnitude = - 400 / powf(distance, 2);
    CGVector pushDirection = CGVectorMake(tx, ty);
    
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[item] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.magnitude = magnitude;
    pushBehavior.pushDirection = pushDirection;
    [self addChildBehavior:pushBehavior];
    
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[otherItem] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.magnitude = -magnitude;
    pushBehavior.pushDirection = pushDirection;
    [self addChildBehavior:pushBehavior];
}

- (void)addAttachmentBehaviorToItem:(id<UIDynamicItem>)item otherItem:(id<UIDynamicItem>)otherItem
{
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToItem:otherItem];
    attachmentBehavior.length = 80.0f;
    attachmentBehavior.damping = 0.85f;
    attachmentBehavior.frequency = 0.3f;
    [self addChildBehavior:attachmentBehavior];
}

@end
