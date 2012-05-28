//
//  RSControlSurface.h
//
//  Created by Ryan Smith on 5/5/12.
//
//  Copyright (c) 2012, Ryan Smith
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met: 
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer. 
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution. 
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those
//  of the authors and should not be interpreted as representing official policies, 
//  either expressed or implied, of the FreeBSD Project.

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
