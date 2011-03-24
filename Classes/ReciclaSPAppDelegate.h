//
//  ReciclaSPAppDelegate.h
//  ReciclaSP
//
//  Created by Luiz Aguiar.
//  Copyright 2011 Betterbrains Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReciclaSPAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	// create the tabBar
	IBOutlet UITabBarController *tabBar;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

