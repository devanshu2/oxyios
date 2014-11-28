//
//  AppDelegate.h
//  OxyFryer
//
//  Created by Richa Goyal on 9/17/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyTabbRaController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>
{
    MyTabbRaController *tabBarController;
    NSMutableDictionary *pushDict;
    UIAlertView *alertView;
}

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isMoviePlayerOpened;
-(void)ShowProcessingView;
-(void)HideProcessingView;
@end
