//
//  RSGauge.m
//
//  Created by Ryan Smith on 5/12/12.
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
