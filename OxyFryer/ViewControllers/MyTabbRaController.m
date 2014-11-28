//
//  MyTabbRaController.m
//  OxyFryer
//
//  Created by Richa Goyal on 10/1/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "MyTabbRaController.h"
#import "PlayerControllerVC.h"
#import "HowToUseVC.h"
@interface MyTabbRaController ()

@end

@implementation MyTabbRaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //  UINavigationController *nav = (UINavigationController *)[self selectedViewController];
     if([APP_DELEGATE isMoviePlayerOpened]) {
        
        // Playing Video: Anything but 'Portrait (Upside down)' is OK
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else{
        // NOT Playing Video: Only 'Portrait' is OK
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}


// Autorotation (iOS >= 6.0)

- (BOOL) shouldAutorotate
{
    return YES;
}


-(NSUInteger)supportedInterfaceOrientations
{
    NSUInteger orientations = UIInterfaceOrientationMaskPortrait;
    
   // UINavigationController *nav = (UINavigationController *)[self selectedViewController];
    //    if([[nav topViewController] isKindOfClass:[PlayerControllerVC class]])
    //        return UIInterfaceOrientationLandscapeLeft;
    //    else
    //        return UIInterfaceOrientationPortrait;
    
    
   if([APP_DELEGATE isMoviePlayerOpened]) {
        
        // Playing Video, additionally allow both landscape orientations:
       orientations = UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
//        orientations |= UIInterfaceOrientationMaskLandscapeLeft;
//        orientations |= UIInterfaceOrientationMaskLandscapeRight;
       
    }
    
    return orientations;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
