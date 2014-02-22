//
//  FDDForceBehavior.h
//  ForceDirectedLayout
//
//  Created by Jiro Nagashima on 2/23/14.
//  Copyright (c) 2014 Jiro Nagashima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDDForceBehavior : UIDynamicBehavior

- (instancetype)initWithItems:(NSArray *)items;
- (void)addItem:(id<UIDynamicItem>)item;

@property (nonatomic, copy, readonly) NSMutableArray *items;

@end
