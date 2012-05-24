//
//  RSLabel.h
//  ControlSurface
//
//  Created by Ryan Smith on 5/10/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RSLabel : UILabel

@property (readwrite, assign) UIEdgeInsets padding;

- (id)initWithFrame:(CGRect)frame andPadding:(UIEdgeInsets)padding;
- (void)setFrame:(CGRect)frame withPadding:(UIEdgeInsets)padding;

@end
