//
//  RSViewController.m
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

#import "RSViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RSViewController ()
@property (nonatomic, strong) UIView *controlAreaView;
@end

@implementation RSViewController

@synthesize label = _label;
@synthesize label2 = _label2;
@synthesize label3 = _label3;
@synthesize titleLabel = _titleLabel;
@synthesize titleLabel2 = _titleLabel2;
@synthesize titleLabel3 = _titleLabel3;
@synthesize controlAreaView = _controlAreaView;
@synthesize valueLabels = _valueLabels;
@synthesize titleLabels = _titleLabels;
@synthesize controlSurfaces = _controlSurfaces;

- (id)init
{
    if ((self = [super initWithNibName:nil bundle:nil]))
    {
        self.controlSurfaces = [[NSMutableArray alloc] init];
        self.valueLabels = [[NSMutableArray alloc] init];
        self.titleLabels = [[NSMutableArray alloc] init];
        
        [self.view setBackgroundColor:[UIColor colorWithWhite:0.05 alpha:1]];
        [self.view setUserInteractionEnabled:YES];
        [self.view setExclusiveTouch:NO];
        
        
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        NSLog(@"bgView.y:%f", bgView.frame.origin.y);
        UIImage *bgImage = [UIImage imageNamed:@"leather.png"];
        [bgView setImage:bgImage];
        [bgView setContentMode:UIViewContentModeTop];
        [bgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.view addSubview:bgView];
        
        self.controlAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 320)];
        
        [self.controlAreaView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        [self.controlAreaView setAutoresizesSubviews:YES];
        [self.view addSubview:self.controlAreaView];
        
        
        RSControlSurface *controlSurface = [[RSControlSurface alloc] initWithTitle:@"Winds" initialValue:0 minValue:-300 maxValue:300 stepValue:10 minInterval:1 withDecimalPlaces:0 andUnits:@"kts"];
        
        [controlSurface setFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        [controlSurface setTag:1];
        [controlSurface setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [controlSurface setDelegate:self];
        [self.controlAreaView addSubview:controlSurface];
        
        RSControlSurface *controlSurface2 = [[RSControlSurface alloc] initWithTitle:@"Weight" initialValue:35000 minValue:10000 maxValue:50000 stepValue:1000 minInterval:100 withDecimalPlaces:0 andUnits:nil];
        
        [controlSurface2 setFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
        [controlSurface2 setTag:2];
        [controlSurface2 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [controlSurface2 setDelegate:self];
        [self.controlAreaView addSubview:controlSurface2];
        
        RSControlSurface *controlSurface3 = [[RSControlSurface alloc] initWithTitle:@"Yaw" initialValue:0 minValue:-45 maxValue:45 stepValue:1 minInterval:0.1 withDecimalPlaces:1 andUnits:nil];
        
        [controlSurface3 setFrame:CGRectMake(0, 200, self.view.frame.size.width, 100)];
        [controlSurface3 setTag:3];
        [controlSurface3 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [controlSurface3 setDelegate:self];
        [self.controlAreaView addSubview:controlSurface3];
        
        [self.controlSurfaces addObject:controlSurface];
        [self.controlSurfaces addObject:controlSurface2];
        [self.controlSurfaces addObject:controlSurface3];
        
        
        UIImage *stripe = [[UIImage imageNamed:@"alStripe.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        
        UIImageView *stripeView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -4, self.view.frame.size.width, 8)];    
        UIImageView *stripeView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 96, self.view.frame.size.width, 8)];
        UIImageView *stripeView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 196, self.view.frame.size.width, 8)];
        UIImageView *stripeView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 296, self.view.frame.size.width, 8)];
        
        [stripeView1 setImage:stripe];
        [stripeView2 setImage:stripe];
        [stripeView3 setImage:stripe];
        [stripeView4 setImage:stripe];
        
        [stripeView1 setContentMode:UIViewContentModeScaleToFill];
        [stripeView2 setContentMode:UIViewContentModeScaleToFill];
        [stripeView3 setContentMode:UIViewContentModeScaleToFill];
        [stripeView4 setContentMode:UIViewContentModeScaleToFill];
        
        [self.controlAreaView addSubview:stripeView1];
        [self.controlAreaView addSubview:stripeView2];
        [self.controlAreaView addSubview:stripeView3];
        [self.controlAreaView addSubview:stripeView4];
        
        [stripeView1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
        [stripeView2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [stripeView3 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [stripeView4 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        
        UIImage *displayImage = [[UIImage imageNamed:@"display.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 32, 0, 32)];
        
        UIImageView *displayView = [[UIImageView alloc] initWithImage:displayImage];
        [displayView setFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 64)];
        [self.view addSubview:displayView];
        [displayView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
        
        int maxLabels = [self.controlSurfaces count];
        
        for (int i=0; i<maxLabels; i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, displayView.frame.size.width/maxLabels, 20)];
            [label setFont:[UIFont systemFontOfSize:16]];
            [label setTextColor:[UIColor whiteColor]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
            [label setText:[[self.controlSurfaces objectAtIndex:i] valueText]];
            [label setCenter:CGPointMake((1+i*2)*displayView.frame.size.width/(2*maxLabels), 40)];    
            [[label layer] setShadowColor:[[UIColor whiteColor] CGColor]];
            [[label layer] setShadowOffset:CGSizeMake(0, 0)];
            [[label layer] setShadowRadius:3];
            [[label layer] setShadowOpacity:0.5];
            [displayView addSubview:label];
            [self.valueLabels addObject:label];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, displayView.frame.size.width/maxLabels, 10)];
            [titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
            [titleLabel setTextColor:[UIColor whiteColor]];
            [titleLabel setTextAlignment:UITextAlignmentCenter];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
            [titleLabel setText:[[self.controlSurfaces objectAtIndex:i] titleText]];
            [titleLabel setCenter:CGPointMake((1+i*2)*displayView.frame.size.width/(2*maxLabels), 20)];
            [displayView addSubview:titleLabel];
            [self.titleLabels addObject:titleLabel];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)controlSurface:(RSControlSurface *)controlSurface didChangeValue:(NSNumber *)value
{
    NSString *unitText = [controlSurface units];
    NSString *valueText = [NSString stringWithFormat:@"%@ %@", value, unitText];
    int index = [self.controlSurfaces indexOfObject:controlSurface];
    UILabel *label = [self.valueLabels objectAtIndex:index];
    [label setText:valueText];
    NSLog(@"controlSurface:%@ | label:%@ | value:%@ | valueText:%@", controlSurface, label, value, valueText);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}

@end
