//
//  FDDForceDirectedLayout.m
//  ForceDirectedLayout
//
//  Created by Jiro Nagashima on 2/23/14.
//  Copyright (c) 2014 Jiro Nagashima. All rights reserved.
//

#import "FDDForceDirectedLayout.h"
#import "FDDForceBehavior.h"

@interface FDDForceDirectedLayout ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) FDDForceBehavior *forceBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, assign, getter = isPanning) BOOL panning;

@end

@implementation FDDForceDirectedLayout

#pragma mark - SubclassingHooks

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if (self.animator) {
        return [self.animator itemsInRect:rect];
    }
    else {
        return [self allAttributes];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.animator) {
        return [self.animator layoutAttributesForCellAtIndexPath:indexPath];
    }
    else {
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
}

- (CGSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}

#pragma mark - UpdateSupportHooks

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    if (self.animator) {
        for (UICollectionViewUpdateItem *updateItem in updateItems) {
            if (updateItem.updateAction == UICollectionUpdateActionInsert) {
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:updateItem.indexPathAfterUpdate];
                [self.forceBehavior addItem:attributes];
            }
        }
    }
}

#pragma mark - Public

- (void)startPanItemAtIndexPath:(NSIndexPath *)indexPath atPoint:(CGPoint)point
{
    if (!self.animator) {
        self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.animator.delegate = self;
        
        NSArray *allAttributes = [self allAttributes];
        self.forceBehavior = [[FDDForceBehavior alloc] initWithItems:allAttributes];
        [self.animator addBehavior:self.forceBehavior];
    }
    
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:attributes attachedToAnchor:point];
    [self.animator addBehavior:self.attachmentBehavior];
    
    self.panning = YES;
}

- (void)updatePanPoint:(CGPoint)point
{
    self.attachmentBehavior.anchorPoint = point;
}

- (void)endPan
{
    [self.animator removeBehavior:self.attachmentBehavior];
    self.attachmentBehavior = nil;
    
    self.panning = NO;
}

#pragma mark - Private

- (NSArray *)allAttributes
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.size = CGSizeMake(44, 44);
            attributes.center = CGPointMake(self.collectionView.center.x, self.collectionView.center.y + indexPath.row * 60);
            [allAttributes addObject:attributes];
        }
    }
    return allAttributes;
}

#pragma mark - UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    if (![self isPanning]) {
        self.animator = nil;
        self.forceBehavior = nil;
    }
}

@end
