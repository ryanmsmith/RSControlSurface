//
//  RSViewController.h
//  ControlSurface
//
//  Created by Ryan Smith on 5/5/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSControlSurface.h"
#import "RSGauge.h"

@class RSControlSurface;

@interface RSViewController : UIViewController <RSControlSurfaceDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleLabel2;
@property (nonatomic, strong) UILabel *titleLabel3;
@property (nonatomic, strong) RSGauge *gauge;
@property (nonatomic, strong) RSGauge *gauge2;
@property (nonatomic, strong) RSGauge *gauge3;

@end
