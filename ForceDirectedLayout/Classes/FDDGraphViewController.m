//
//  FDDGraphViewController.m
//  ForceDirectedLayout
//
//  Created by Jiro Nagashima on 2/23/14.
//  Copyright (c) 2014 Jiro Nagashima. All rights reserved.
//

#import "FDDGraphViewController.h"
#import "FDDForceDirectedLayout.h"
#import "FDDGraphViewNode.h"

@interface FDDGraphViewController ()

@property (nonatomic, strong) IBOutlet UIPanGestureRecognizer *pangestureRecognizer;

@end

@implementation FDDGraphViewController

#pragma mark - IBActions

- (IBAction)panAction:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint location = [panGestureRecognizer locationInView:self.collectionView];
    FDDForceDirectedLayout *forceDirectedLayout = (FDDForceDirectedLayout *)self.collectionViewLayout;
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
            [forceDirectedLayout startPanItemAtIndexPath:indexPath atPoint:location];
            break;
        }
            
        case UIGestureRecognizerStateChanged:
            [forceDirectedLayout updatePanPoint:location];
            break;
            
        case UIGestureRecognizerStateEnded:
            [forceDirectedLayout endPan];
            
        default:
            break;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FDDGraphViewNode *node = [collectionView dequeueReusableCellWithReuseIdentifier:@"Node" forIndexPath:indexPath];
    return node;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.pangestureRecognizer) {
        CGPoint location = [gestureRecognizer locationInView:self.collectionView];
        return ([self.collectionView indexPathForItemAtPoint:location] != nil);
    }
    
    return YES;
}

@end
