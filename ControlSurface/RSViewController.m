//
//  RSViewController.m
//  ControlSurface
//
//  Created by Ryan Smith on 5/5/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

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
@synthesize gauge = _gauge;
@synthesize gauge2 = _gauge2;
@synthesize gauge3 = _gauge3;

- (id)init
{
    if ((self = [super initWithNibName:nil bundle:nil]))
    {
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
        
        
        RSControlSurface *controlSurface = [[RSControlSurface alloc] initWithTitle:@"Winds" initialValue:0 minValue:-300 maxValue:300 stepValue:10 minInterval:1 withNumberOfDecimals:0 andUnits:@"kts"];
        
        [controlSurface setFrame:CGRectMake(0, 4, self.view.frame.size.width, 100)];
        [controlSurface setTag:1];
        [controlSurface setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [controlSurface setDelegate:self];
        [self.controlAreaView addSubview:controlSurface];
        
        RSControlSurface *controlSurface2 = [[RSControlSurface alloc] initWithTitle:@"Weight" initialValue:35000 minValue:10000 maxValue:50000 stepValue:1000 minInterval:100 withNumberOfDecimals:0 andUnits:nil];
        
        [controlSurface2 setFrame:CGRectMake(0, 108, self.view.frame.size.width, 100)];
        [controlSurface2 setTag:2];
        [controlSurface2 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [controlSurface2 setDelegate:self];
        [self.controlAreaView addSubview:controlSurface2];
        
        RSControlSurface *controlSurface3 = [[RSControlSurface alloc] initWithTitle:@"Yaw" initialValue:0 minValue:-45 maxValue:45 stepValue:1 minInterval:0.1 withNumberOfDecimals:1 andUnits:nil];
        
        [controlSurface3 setFrame:CGRectMake(0, 212, self.view.frame.size.width, 100)];
        [controlSurface3 setTag:3];
        [controlSurface3 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [controlSurface3 setDelegate:self];
        [self.controlAreaView addSubview:controlSurface3];
        
        UIImage *stripe = [UIImage imageNamed:@"alStripe.png"];
        
        UIImageView *stripeView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 8)];    
        UIImageView *stripeView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 104, self.view.frame.size.width, 8)];
        UIImageView *stripeView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 208, self.view.frame.size.width, 8)];
        UIImageView *stripeView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 312, self.view.frame.size.width, 8)];
        
        [stripeView1 setImage:stripe];
        [stripeView2 setImage:stripe];
        [stripeView3 setImage:stripe];
        [stripeView4 setImage:stripe];
        
        [stripeView1 setContentMode:UIViewContentModeTop];
        [stripeView2 setContentMode:UIViewContentModeTop];
        [stripeView3 setContentMode:UIViewContentModeTop];
        [stripeView4 setContentMode:UIViewContentModeTop];
        
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
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (displayView.frame.size.width-40)/3, 20)];
        [self.label setFont:[UIFont systemFontOfSize:16]];
        [self.label setTextColor:[UIColor whiteColor]];
        [self.label setTextAlignment:UITextAlignmentCenter];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
        [self.label setText:controlSurface.valueText];
        [displayView addSubview:self.label];
        [self.label setCenter:CGPointMake(displayView.frame.size.width/6, 40)];    
        [[self.label layer] setShadowColor:[[UIColor whiteColor] CGColor]];
        [[self.label layer] setShadowOffset:CGSizeMake(0, 0)];
        [[self.label layer] setShadowRadius:3];
        [[self.label layer] setShadowOpacity:0.5];
        
        self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (displayView.frame.size.width-40)/3, 20)];
        [self.label2 setFont:[UIFont systemFontOfSize:16]];
        [self.label2 setTextColor:[UIColor whiteColor]];
        [self.label2 setTextAlignment:UITextAlignmentCenter];
        [self.label2 setBackgroundColor:[UIColor clearColor]];
        [self.label2 setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth];
        [self.label2 setText:controlSurface2.valueText];
        [displayView addSubview:self.label2];    
        [self.label2 setCenter:CGPointMake(3*displayView.frame.size.width/6, 40)];   
        [[self.label2 layer] setShadowColor:[[UIColor whiteColor] CGColor]];
        [[self.label2 layer] setShadowOffset:CGSizeMake(0, 0)];
        [[self.label2 layer] setShadowRadius:3];
        [[self.label2 layer] setShadowOpacity:0.5];
        
        self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (displayView.frame.size.width-40)/3, 20)];
        [self.label3 setFont:[UIFont systemFontOfSize:16]];
        [self.label3 setTextColor:[UIColor whiteColor]];
        [self.label3 setTextAlignment:UITextAlignmentCenter];
        [self.label3 setBackgroundColor:[UIColor clearColor]];
        [self.label3 setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth];
        [self.label3 setText:controlSurface3.valueText];
        [displayView addSubview:self.label3];
        [self.label3 setCenter:CGPointMake(5*displayView.frame.size.width/6, 40)];   
        [[self.label3 layer] setShadowColor:[[UIColor whiteColor] CGColor]];
        [[self.label3 layer] setShadowOffset:CGSizeMake(0, 0)];
        [[self.label3 layer] setShadowRadius:3];
        [[self.label3 layer] setShadowOpacity:0.5];
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (displayView.frame.size.width-40)/3, 10)];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setTextAlignment:UITextAlignmentCenter];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
        [self.titleLabel setText:controlSurface.titleText];
        [displayView addSubview:self.titleLabel];
        [self.titleLabel setCenter:CGPointMake(displayView.frame.size.width/6, 20)];
        
        self.titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (displayView.frame.size.width-40)/3, 10)];
        [self.titleLabel2 setFont:[UIFont boldSystemFontOfSize:10]];
        [self.titleLabel2 setTextColor:[UIColor whiteColor]];
        [self.titleLabel2 setTextAlignment:UITextAlignmentCenter];
        [self.titleLabel2 setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel2 setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth];
        [self.titleLabel2 setText:controlSurface2.titleText];
        [displayView addSubview:self.titleLabel2];    
        [self.titleLabel2 setCenter:CGPointMake(3*displayView.frame.size.width/6, 20)];
        
        self.titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (displayView.frame.size.width-40)/3, 10)];
        [self.titleLabel3 setFont:[UIFont boldSystemFontOfSize:10]];
        [self.titleLabel3 setTextColor:[UIColor whiteColor]];
        [self.titleLabel3 setTextAlignment:UITextAlignmentCenter];
        [self.titleLabel3 setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel3 setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth];
        [self.titleLabel3 setText:controlSurface3.titleText];
        [displayView addSubview:self.titleLabel3];
        [self.titleLabel3 setCenter:CGPointMake(5*displayView.frame.size.width/6, 20)];
        
        float gaugeDiameter = self.view.frame.size.width/4; 
        
        BOOL includeGauges = NO;
        
        includeGauges = YES; // <- comment out this line to exclude gauge displays
        
        if (includeGauges)
        {
            self.gauge = [[RSGauge alloc] initWithFrame:CGRectMake(0, 0, gaugeDiameter, gaugeDiameter)];
            [self.gauge setCenter:CGPointMake(self.view.frame.size.width/6, self.view.frame.size.height-gaugeDiameter/2)];
            [self.gauge setMin:controlSurface.min];
            [self.gauge setMax:controlSurface.max];
            [self.gauge setCurrentValue:controlSurface.value];
            [self.view addSubview:self.gauge]; 
            [self.gauge setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            
            self.gauge2 = [[RSGauge alloc] initWithFrame:CGRectMake(0, 0, gaugeDiameter, gaugeDiameter)];
            [self.gauge2 setCenter:CGPointMake(3*self.view.frame.size.width/6, self.view.frame.size.height-gaugeDiameter/2)];
            [self.gauge2 setMin:controlSurface2.min];
            [self.gauge2 setMax:controlSurface2.max];
            [self.gauge2 setCurrentValue:controlSurface2.value];
            [self.view addSubview:self.gauge2];
            [self.gauge2 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            
            self.gauge3 = [[RSGauge alloc] initWithFrame:CGRectMake(0, 0, gaugeDiameter, gaugeDiameter)];
            [self.gauge3 setCenter:CGPointMake(5*self.view.frame.size.width/6, self.view.frame.size.height-gaugeDiameter/2)];
            [self.gauge3 setMin:controlSurface3.min];
            [self.gauge3 setMax:controlSurface3.max];
            [self.gauge3 setCurrentValue:controlSurface3.value];
            [self.view addSubview:self.gauge3];
            [self.gauge3 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
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
    NSString *valueText = [controlSurface valueText];
    NSString *titleText = [controlSurface titleText];
    switch (controlSurface.tag) {
        case 1:
            [self.label setText:valueText];
            [self.titleLabel setText:titleText];
            if (self.gauge)
            {
                [self.gauge setGaugeLevel:[value floatValue]];
            }
            break;
        case 2:
            [self.label2 setText:valueText];
            [self.titleLabel2 setText:titleText];
            if (self.gauge2)
            {
                [self.gauge2 setGaugeLevel:[value floatValue]];
            }
            break;
        case 3:
            [self.label3 setText:valueText];
            [self.titleLabel3 setText:titleText];
            if (self.gauge3)
            {
                [self.gauge3 setGaugeLevel:[value floatValue]];
            }
            break;
        default:
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}

@end
