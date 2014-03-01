//
//  FDDForceDirectedLayout.m
//  ForceDirectedLayout
//
//  Created by Jiro Nagashima on 2/23/14.
//  Copyright (c) 2014 Jiro Nagashima. All rights reserved.
//

#import "FDDGraphViewLayout.h"
#import "FDDGraphViewLayoutAttributes.h"
#import "FDDForceBehavior.h"

@interface FDDGraphViewLayout ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) FDDForceBehavior *forceBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;

@end

@implementation FDDGraphViewLayout

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSArray *allAttributes = [self allAttributes];
    for (FDDGraphViewLayoutAttributes *attributes in allAttributes) {
        attributes.center = self.collectionView.center;
    }
    
    self.forceBehavior = [[FDDForceBehavior alloc] initWithItems:allAttributes];
    [self.dynamicAnimator addBehavior:self.forceBehavior];
}

- (NSArray *)allAttributes
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            FDDGraphViewLayoutAttributes *attributes = [FDDGraphViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            [allAttributes addObject:attributes];
        }
    }
    return allAttributes;
}

#pragma mark - SubclassingHooks

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

- (CGSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}

#pragma mark - UpdateSupportHooks

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
    FDDGraphViewLayoutAttributes *selectedAttributes = (FDDGraphViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:selectedIndexPath];
    
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            FDDGraphViewLayoutAttributes *attributes = [FDDGraphViewLayoutAttributes layoutAttributesForCellWithIndexPath:updateItem.indexPathAfterUpdate];
            [attributes addConnectedAttributes:selectedAttributes];
            [self.forceBehavior addItem:attributes];
        }
    }
}

#pragma mark - Public

- (NSArray *)forcedItems
{
    return self.forceBehavior.items;
}

- (void)startPanItemAtIndexPath:(NSIndexPath *)indexPath atPoint:(CGPoint)point
{
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:attributes attachedToAnchor:point];
    [self.dynamicAnimator addBehavior:self.attachmentBehavior];
}

- (void)updatePanPoint:(CGPoint)point
{
    self.attachmentBehavior.anchorPoint = point;
}

- (void)endPan
{
    [self.dynamicAnimator removeBehavior:self.attachmentBehavior];
    self.attachmentBehavior = nil;
}

@end
