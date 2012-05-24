//
//  RSGauge.h
//  ControlSurface
//
//  Created by Ryan Smith on 5/12/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSGauge : UIView

@property (readwrite, assign) float min;
@property (readwrite, assign) float max;
@property (readwrite, assign) float currentValue;

- (void)setGaugeLevel:(float)value;

@end
