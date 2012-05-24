//
//  RSAppDelegate.h
//  ControlSurface
//
//  Created by Ryan Smith on 5/5/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSViewController;

@interface RSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RSViewController *viewController;

@end
