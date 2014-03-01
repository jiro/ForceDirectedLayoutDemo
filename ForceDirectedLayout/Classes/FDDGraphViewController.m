//
//  FDDGraphViewController.m
//  ForceDirectedLayout
//
//  Created by Jiro Nagashima on 2/23/14.
//  Copyright (c) 2014 Jiro Nagashima. All rights reserved.
//

#import "FDDGraphViewController.h"
#import "FDDLinksView.h"
#import "FDDGraphViewLayout.h"
#import "FDDNodeCell.h"

@interface FDDGraphViewController ()

@property (nonatomic, strong) IBOutlet UIPanGestureRecognizer *pangestureRecognizer;

@property (nonatomic, strong) FDDLinksView *linksView;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation FDDGraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.linksView = [FDDLinksView new];
    self.linksView.backgroundColor = [UIColor clearColor];
    [self.collectionView addSubview:self.linksView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.linksView.frame = self.collectionView.bounds;
    [self.collectionView sendSubviewToBack:self.linksView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLinks:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.displayLink invalidate];
}

#pragma mark - IBActions

- (IBAction)panAction:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint location = [panGestureRecognizer locationInView:self.collectionView];
    FDDGraphViewLayout *forceDirectedLayout = (FDDGraphViewLayout *)self.collectionViewLayout;
    
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

#pragma mark - Private

- (void)updateLinks:(id)sender
{
    self.linksView.attributes = [(FDDGraphViewLayout *)self.collectionViewLayout forcedItems];
    [self.linksView setNeedsDisplay];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FDDNodeCell *nodeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NodeCell" forIndexPath:indexPath];
    return nodeCell;
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
