//
//  RSControlSurface.h
//  ControlSurface
//
//  Created by Ryan Smith on 5/5/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "RSLabel.h"

typedef enum
{
    kControlSurfaceStyleLabelsSplitAtMiddle = 0,
    kControlSurfaceStyleLabelsSplitAtTop,
    kControlSurfaceStyleLabelsSplitAtBottom,
    kControlSurfaceStyleLabelsCenteredAtMiddle
} kControlSurfaceStyle;

@class RSLabel;

@protocol RSControlSurfaceDelegate;

@interface RSControlSurface : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<RSControlSurfaceDelegate> delegate;
@property (nonatomic, strong) RSLabel *titleLabel;
@property (nonatomic, strong) RSLabel *valueLabel;
@property (nonatomic, strong) NSString *titleText;
@property (readwrite, assign) float value;
@property (readwrite, assign) float padding;
@property (readwrite, assign) float min;
@property (readwrite, assign) float max;
@property (readwrite, assign) float minInterval;
@property (readwrite, assign) float maxInterval;
@property (readwrite, assign) int numDecimals;
@property (readwrite, assign) float sensitivity;
@property (nonatomic, strong) NSString *units;
@property (readwrite, assign) kControlSurfaceStyle style;

@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIView *downView;

- (id)initWithTitle:(NSString *)title initialValue:(float)initialValue minValue:(float)minValue maxValue:(float)maxValue stepValue:(float)stepValue minInterval:(float)minInterval withNumberOfDecimals:(int)decimals andUnits:(NSString *)units;

- (void)setCurrentValue:(float)val;
- (void)setTitle:(NSString *)title;
- (NSString *)valueText;

@end

@protocol RSControlSurfaceDelegate <NSObject>

- (void)controlSurface:(RSControlSurface *)controlSurface didChangeValue:(NSNumber *)value;

@end
