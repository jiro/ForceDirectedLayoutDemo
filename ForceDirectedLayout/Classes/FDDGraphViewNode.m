//
//  FDDGraphViewNode.m
//  ForceDirectedLayout
//
//  Created by Jiro Nagashima on 2/23/14.
//  Copyright (c) 2014 Jiro Nagashima. All rights reserved.
//

#import "FDDGraphViewNode.h"

@implementation FDDGraphViewNode

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = 22.0f;
    }
    return self;
}

@end
