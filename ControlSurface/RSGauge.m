//
//  RSGauge.m
//  ControlSurface
//
//  Created by Ryan Smith on 5/12/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import "RSGauge.h"

@interface RSGauge ()

@property (nonatomic, strong) UIImageView *gaugeLevelView;

@end

@implementation RSGauge

@synthesize min = _min;
@synthesize max = _max;
@synthesize currentValue = _currentValue;

@synthesize gaugeLevelView = _gaugeLevelView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self setContentMode:UIViewContentModeScaleAspectFit];
        
        UIImage *gaugeBack = [UIImage imageNamed:@"GaugeBack.png"];
        UIImage *gaugeFront = [UIImage imageNamed:@"GaugeFront.png"];
        UIImage *gaugeLevel = [UIImage imageNamed:@"GaugeLevel.png"];
        
        UIImageView *gaugeBackView = [[UIImageView alloc] initWithImage:gaugeBack];
        UIImageView *gaugeFrontView = [[UIImageView alloc] initWithImage:gaugeFront];
        self.gaugeLevelView = [[UIImageView alloc] initWithImage:gaugeLevel];
        
        CGRect subViewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        gaugeBackView.frame = subViewFrame;
        gaugeFrontView.frame = subViewFrame;
        self.gaugeLevelView.frame = subViewFrame;
        
        gaugeBackView.backgroundColor = [UIColor clearColor];
        gaugeFrontView.backgroundColor = [UIColor clearColor];
        self.gaugeLevelView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:gaugeBackView];
        [self addSubview:self.gaugeLevelView];
        [self addSubview:gaugeFrontView];
    }
    return self;
}

- (void)setGaugeLevel:(float)value
{
    self.currentValue = value;
    
    float rotation = M_PI * (value - self.min)/(self.max - self.min);
    
    [self.gaugeLevelView setTransform:CGAffineTransformMakeRotation(rotation)];
}

@end
