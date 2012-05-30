//
//  RSControlSurface.m
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

#import <QuartzCore/QuartzCore.h>

#import "RSControlSurface.h"

@interface RSControlSurface()

@property (nonatomic, strong) UITapGestureRecognizer *incrementingStepperTapRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *decrementingStepperTapRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *incrementingStepperLongPressRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *decrementingStepperLongPressRecognizer;
@property (nonatomic, strong) NSTimer *timer;
@property (readwrite, assign) float intermediateValue;
@property (readwrite, assign) float touchStartX;
@end



@implementation RSControlSurface

@synthesize delegate = _delegate;
@synthesize titleLabel = _titleLabel;
@synthesize valueLabel = _valueLabel;
@synthesize titleText = _titleText;
@synthesize value = _value;
@synthesize padding = _padding;
@synthesize min = _min;
@synthesize max = _max;
@synthesize minInterval = _minInterval;
@synthesize maxInterval = _maxInterval;
@synthesize numDecimals = _numDecimals;
@synthesize units = _units;
@synthesize incrementingStepperTapRecognizer = _incrementingStepperTapRecognizer;
@synthesize decrementingStepperTapRecognizer = _decrementingStepperTapRecognizer;
@synthesize incrementingStepperLongPressRecognizer = _incrementingStepperLongPressRecognizer;
@synthesize decrementingStepperLongPressRecognizer = _decrementingStepperLongPressRecognizer;
@synthesize timer = _timer;
@synthesize intermediateValue = _intermediateValue;
@synthesize incrementingStepperView = _incrementingStepperView;
@synthesize decrementingStepperView = _decrementingStepperView;
@synthesize touchStartX = _touchStartX;
@synthesize style = _style;

- (id)initWithTitle:(NSString *)title initialValue:(float)initialValue minValue:(float)minValue maxValue:(float)maxValue stepValue:(float)stepValue minInterval:(float)minInterval withDecimalPlaces:(int)decimals andUnits:(NSString *)units
{
    self = [super initWithFrame:CGRectMake(0, 0, 1000, 200)];
    if (self) {
        [self setPadding:10];
        [self setTitleText:title];
        [self setMin:minValue];
        [self setMax:maxValue];
        [self setMinInterval:minInterval];
        [self setMaxInterval:stepValue];
        [self setNumDecimals:decimals];
        [self setUnits:units ? units : @""];
        [self setBackgroundColor:[UIColor darkGrayColor]];
        [self setSurfaceImage:[UIImage imageNamed:@"surface.png"]];
        [self setupGestureRecognizer];
        [self setStepperViewMirrorableImage:[UIImage imageNamed:@"chevrons.png"]];
        [self setupLabels];
        [self setCurrentValue:initialValue];
        [self setUserInteractionEnabled:YES];
        [self setExclusiveTouch:NO];
        [self setClipsToBounds:YES];
        [self setIntermediateValue:self.value];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self setStyle:kControlSurfaceStyleLabelsSplitAtMiddle];
        self.touchStartX = 0;
    }
    return self;
}

- (void)setSurfaceImage:(UIImage *)surfaceImage
{
    UIImageView *surfaceView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [surfaceView setImage:surfaceImage];
    [surfaceView setContentMode:UIViewContentModeTop];
    [surfaceView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview:surfaceView];
}

- (void)setStepperViewMirrorableImage:(UIImage *)image
{
    CGContextRef imageCtx = CGBitmapContextCreate(NULL, image.size.width, image.size.height, 8, 0, CGColorSpaceCreateDeviceRGB(), (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextTranslateCTM(imageCtx, image.size.width, 0);
    CGContextScaleCTM(imageCtx, -1.0, 1.0);
    CGContextDrawImage(imageCtx, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    CGImageRef mirroredImageRef = CGBitmapContextCreateImage(imageCtx);
    CGContextRelease(imageCtx);
    UIImage *mirroredImage = [UIImage imageWithCGImage:mirroredImageRef];
    CGImageRelease(mirroredImageRef);
    
    [self setDecrementingStepperImage:mirroredImage];
    [self setIncrementingStepperImage:image];
}

- (void)setDecrementingStepperImage:(UIImage *)image
{
    UIImageView *decrementingStepperImageView = [[UIImageView alloc] initWithImage:image];
    [decrementingStepperImageView setContentMode:UIViewContentModeScaleAspectFit];
    [decrementingStepperImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [decrementingStepperImageView setFrame:CGRectMake(0, 0, self.decrementingStepperView.frame.size.width, self.decrementingStepperView.frame.size.height)];
    [self.decrementingStepperView addSubview:decrementingStepperImageView];
}

- (void)setIncrementingStepperImage:(UIImage *)image
{
    UIImageView *incrementingStepperImageView = [[UIImageView alloc] initWithImage:image];
    [incrementingStepperImageView setContentMode:UIViewContentModeScaleAspectFit];
    [incrementingStepperImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [incrementingStepperImageView setFrame:CGRectMake(0, 0, self.incrementingStepperView.frame.size.width, self.incrementingStepperView.frame.size.height)];
    [self.incrementingStepperView addSubview:incrementingStepperImageView];
}

- (void)setupLabels
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.titleLabel = [[RSLabel alloc] initWithFrame:frame andPadding:UIEdgeInsetsMake(self.padding, self.padding*3, self.padding, self.padding*3)];
    [self.titleLabel setText:self.titleText];
    [self.titleLabel setTextAlignment:UITextAlignmentLeft];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:self.frame.size.height/2]];
    [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    [self addSubview:self.titleLabel];
    
    self.valueLabel = [[RSLabel alloc] initWithFrame:frame andPadding:UIEdgeInsetsMake(self.padding, self.padding*3, self.padding, self.padding*3)];
    [self.valueLabel setTextAlignment:UITextAlignmentRight];
    [self.valueLabel setTextColor:[UIColor whiteColor]];
    [self.valueLabel setBackgroundColor:[UIColor clearColor]];
    [self.valueLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:self.frame.size.height/2]];
    [self.valueLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    [self addSubview:self.valueLabel];
    
    [self shadowLabels];
}

- (void)setupGestureRecognizer
{
    [self setMultipleTouchEnabled:NO];
    
    self.decrementingStepperTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFromRecognizer:)];
    
    self.incrementingStepperTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFromRecognizer:)];
    
    self.decrementingStepperLongPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFromRecognizer:)];
    self.incrementingStepperLongPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFromRecognizer:)];
    
    self.decrementingStepperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    [self.decrementingStepperView setBackgroundColor:[UIColor clearColor]];
    [self.decrementingStepperView addGestureRecognizer:self.decrementingStepperTapRecognizer];
    [self.decrementingStepperView addGestureRecognizer:self.decrementingStepperLongPressRecognizer];
    [self.decrementingStepperView setUserInteractionEnabled:YES];
    [self.decrementingStepperView setExclusiveTouch:YES];
    [self.decrementingStepperView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview:self.decrementingStepperView];
    
    self.incrementingStepperView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-self.frame.size.height, 0, self.frame.size.height, self.frame.size.height)];
    [self.incrementingStepperView setBackgroundColor:[UIColor clearColor]];
    [self.incrementingStepperView addGestureRecognizer:self.incrementingStepperTapRecognizer];
    [self.incrementingStepperView addGestureRecognizer:self.incrementingStepperLongPressRecognizer];
    [self.incrementingStepperView setUserInteractionEnabled:YES];
    [self.incrementingStepperView setExclusiveTouch:YES];
    [self.incrementingStepperView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview:self.incrementingStepperView];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self highlightLabels];
    self.touchStartX = [[touches anyObject] locationInView:self].x;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    float currentX = [[touches anyObject] locationInView:self].x;
    [self calculateChange:(currentX - self.touchStartX) withNumberOfTouchs:1];
    self.touchStartX = [[touches anyObject] locationInView:self].x;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    float currentX = [[touches anyObject] locationInView:self].x;
    [self calculateChange:(currentX - self.touchStartX) withNumberOfTouchs:1];
    self.touchStartX = [[touches anyObject] locationInView:self].x;
    [self shadowLabels];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event    
{
    float currentX = [[touches anyObject] locationInView:self].x;
    [self calculateChange:(currentX - self.touchStartX) withNumberOfTouchs:1];
    self.touchStartX = [[touches anyObject] locationInView:self].x;
    [self shadowLabels];
    
}


- (void)tapFromRecognizer:(id)sender
{
    UITapGestureRecognizer *tapper = (UITapGestureRecognizer *)sender;
    int direction = ([tapper isEqual:self.incrementingStepperTapRecognizer]) ? 1 : -1;
    switch (tapper.state) 
    {    
        case UIGestureRecognizerStateBegan:
            [self highlightLabels];
            break;
        case UIGestureRecognizerStateEnded:
            self.intermediateValue = 0;
            self.value += direction*self.maxInterval;
            [self setCurrentValue:self.value];
            [self shadowLabels];
            break;
        default:
            break;
    }
}

- (void)longPressFromRecognizer:(id)sender
{
    int direction = ([sender isEqual:self.incrementingStepperLongPressRecognizer]) ? 1 : -1;

    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:direction] forKey:@"direction"];
    UILongPressGestureRecognizer *recognizer = (UILongPressGestureRecognizer *)sender;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self highlightLabels];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(changeValueWithTimer:) userInfo:userInfo repeats:YES];
            break;
        case UIGestureRecognizerStateEnded:
            [self shadowLabels];
            [self.timer invalidate];
            break;
        default:
            break;
    }
    
}


- (void)changeValueWithTimer:(id)sender
{
    NSDictionary *userInfo = [self.timer userInfo];
    int direction = [[userInfo objectForKey:@"direction"] intValue];
    NSTimeInterval timeInterval = self.timer.timeInterval;
    timeInterval *= 0.9;
    
    [self highlightLabels];
    
    [self calculateChange:direction*20.0 withNumberOfTouchs:1];
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(changeValueWithTimer:) userInfo:userInfo repeats:YES];
}


- (void)calculateChange:(float)vel withNumberOfTouchs:(int)numberOfTouches
{
    float delta;
    float direction;
    float absVel;
    absVel = sqrtf(vel*vel);
    direction = (vel == 0) ? 1 : vel/absVel;
    delta = vel;

    if (sqrtf((self.intermediateValue + delta)*(self.intermediateValue+delta)) >= 20)
    {
        delta += self.intermediateValue;
        float newValue = self.value + direction * self.minInterval;
        
        if (newValue > self.max) 
        {
            self.value = self.max;
            self.intermediateValue = 0;
        }
        else if (newValue < self.min)
        {
            self.value = self.min;
            self.intermediateValue = 0;
        }
        else 
        {
            self.value = newValue;
            self.intermediateValue = 0;
        }
    }
    else
    {
        self.intermediateValue += delta;
        return;
    }
    
    [self setCurrentValue:self.value];
}


- (void)setTitle:(NSString *)title
{
    self.titleText = title;
    [self.titleLabel setText:title];
}


- (void)setCurrentValue:(float)val  
{
    if (self.value != val)
    {
        self.value = val;
    }
    NSString *labelText = @"";
    NSNumber *number = [NSNumber numberWithFloat:self.value];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:self.numDecimals];
    [formatter setMinimumFractionDigits:self.numDecimals];
    NSString *numberString = [formatter stringFromNumber:number];
    if (self.units != @"")
    {
        labelText = [NSString stringWithFormat:@"%@ %@", numberString, self.units];
    }
    else 
    {
        labelText = [NSString stringWithFormat:@"%@", numberString];
    }
    [self.valueLabel setText:labelText];
    [self.delegate controlSurface:self didChangeValue:number];
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.incrementingStepperView setFrame:CGRectMake(self.frame.size.width-self.frame.size.height, 0, self.frame.size.height, self.frame.size.height)];
    [self.decrementingStepperView setFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    self.padding = self.frame.size.height/10.0;
    
    [self layoutWithStyle:self.style];
}

- (void)layoutWithStyle:(kControlSurfaceStyle)style
{
    CGRect defaultFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    float defaultFontSize = (defaultFrame.size.height-self.padding*2.0)/2;
    UIFont *defaultFont = [UIFont fontWithName:@"HelveticaNeue" size:defaultFontSize];
    UIEdgeInsets defaultLabelInsetPadding = UIEdgeInsetsMake(self.padding, self.padding*3, self.padding, self.padding*3);
    [self.titleLabel setFont:defaultFont];
    [self.titleLabel setTextAlignment:UITextAlignmentLeft];
    [self.titleLabel setFrame:defaultFrame withPadding:defaultLabelInsetPadding];
    
    [self.valueLabel setFont:defaultFont];
    [self.valueLabel setTextAlignment:UITextAlignmentRight];
    [self.valueLabel setFrame:defaultFrame withPadding:defaultLabelInsetPadding];
    
    CGRect newFrame = defaultFrame;
    UIEdgeInsets newLabelInsetPadding = defaultLabelInsetPadding;
    
    switch (style) {
        case kControlSurfaceStyleLabelsSplitAtMiddle:
            
            break;
        case kControlSurfaceStyleLabelsSplitAtTop:
            newFrame.size.height = defaultFontSize+self.padding*2;
            [self.titleLabel setFrame:newFrame withPadding:defaultLabelInsetPadding];
            [self.valueLabel setFrame:newFrame withPadding:defaultLabelInsetPadding];
            break;
        case kControlSurfaceStyleLabelsSplitAtBottom:
            newFrame.size.height = defaultFontSize+self.padding*2;
            newFrame.origin.y = self.frame.size.height - newFrame.size.height;
            [self.titleLabel setFrame:newFrame withPadding:defaultLabelInsetPadding];
            [self.valueLabel setFrame:newFrame withPadding:defaultLabelInsetPadding];
            break;
        case kControlSurfaceStyleLabelsCenteredAtMiddle:
            newLabelInsetPadding.right = self.padding;
            newLabelInsetPadding.left = self.padding;
            
            newFrame.size.width *= 0.5;
            [self.titleLabel setFrame:newFrame withPadding:newLabelInsetPadding];
            [self.titleLabel setTextAlignment:UITextAlignmentRight];
            
            newFrame.origin.x = newFrame.size.width;
            [self.valueLabel setFrame:newFrame withPadding:newLabelInsetPadding];
            [self.valueLabel setTextAlignment:UITextAlignmentLeft];
            
            break;
        default:
            break;
    }

}

- (short)scale
{
    return self.numDecimals;
}

- (void)shadowLabels
{
    [[self.valueLabel layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[self.valueLabel layer] setShadowOffset:CGSizeMake(0, 1)];
    [[self.valueLabel layer] setShadowRadius:5];
    [[self.valueLabel layer] setShadowOpacity:1];
    
    [[self.titleLabel layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[self.titleLabel layer] setShadowOffset:CGSizeMake(0, 1)];
    [[self.titleLabel layer] setShadowRadius:5];
    [[self.titleLabel layer] setShadowOpacity:1];
}

- (void)highlightLabels
{
    [[self.valueLabel layer] setShadowColor:[[UIColor whiteColor] CGColor]];
    [[self.valueLabel layer] setShadowOffset:CGSizeMake(0, 0)];
    [[self.valueLabel layer] setShadowRadius:5];
    [[self.valueLabel layer] setShadowOpacity:1];
    
    [[self.titleLabel layer] setShadowColor:[[UIColor whiteColor] CGColor]];
    [[self.titleLabel layer] setShadowOffset:CGSizeMake(0, 0)];
    [[self.titleLabel layer] setShadowRadius:5];
    [[self.titleLabel layer] setShadowOpacity:1];
}

- (void)highlightView:(UIView *)view
{
    [[view layer] setShadowColor:[[UIColor whiteColor] CGColor]];
    [[view layer] setShadowOffset:CGSizeMake(0, 0)];
    [[view layer] setShadowRadius:5];
    [[view layer] setShadowOpacity:1];
}

- (NSString *)valueText
{
    NSString *labelText = @"";
    NSNumber *number = [NSNumber numberWithFloat:self.value];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:self.numDecimals];
    [formatter setMinimumFractionDigits:self.numDecimals];
    NSString *numberString = [formatter stringFromNumber:number];
    if (self.units != @"")
    {
        labelText = [NSString stringWithFormat:@"%@ %@", numberString, self.units];
    }
    else 
    {
        labelText = [NSString stringWithFormat:@"%@", numberString];
    }
    return labelText;
}
@end
