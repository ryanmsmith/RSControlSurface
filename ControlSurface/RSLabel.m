//
//  RSLabel.m
//  ControlSurface
//
//  Created by Ryan Smith on 5/10/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import "RSLabel.h"

@implementation RSLabel

@synthesize padding = _padding;

- (id)initWithFrame:(CGRect)frame andPadding:(UIEdgeInsets)padding
{
    self = [super initWithFrame:frame];
    if (self) {
        self.padding = padding;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andPadding:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)setFrame:(CGRect)frame withPadding:(UIEdgeInsets)padding
{
    [super setFrame:frame];
    self.padding = padding;
}

- (void)drawTextInRect:(CGRect)rect 
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.padding)];
}

@end
