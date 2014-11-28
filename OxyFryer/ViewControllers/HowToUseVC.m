//
//  HowToUseVC.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/24/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "HowToUseVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PlayerControllerVC.h"
#define TAG_Player 6373
@interface HowToUseVC ()
{
    MPMoviePlayerViewController  *player;
    UIScrollView *mainScrollView;
}

@end

@implementation HowToUseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SharedFunction sharedInstance] setTitleViewForNavigationItem:self.navigationItem];
    UIView *vw = [[UIView alloc] init];
    [self.view addSubview:vw];
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, View_Height.height)];
    [mainScrollView setContentSize:CGSizeMake(screenSize.width, MAX(455, View_Height.height))];
    [self.view addSubview:mainScrollView];
    
    UIImageView *imgVw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shutterstock_116764726.jpg"]];
    [imgVw setUserInteractionEnabled:YES];
    [imgVw setFrame:CGRectMake(0, 0, screenSize.width, mainScrollView.contentSize.height-240-20)];
    [mainScrollView addSubview:imgVw];
    
    UIButton *playVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playVideoBtn setFrame:CGRectMake(screenSize.width/2-21.5, imgVw.frame.size.height/2-22.5f, 43, 45)];
    [playVideoBtn addTarget:self action:@selector(playVideoBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [playVideoBtn setBackgroundImage:[UIImage imageNamed:IMG_PLAY_VIDEO_BTN] forState:UIControlStateNormal];
    [playVideoBtn setBackgroundColor:[UIColor clearColor]];
    [imgVw addSubview:playVideoBtn];
    
    UILabel *rpNameLbl = [[SharedFunction sharedInstance] getLabelWithFrame:CGRectMake(0, CGRectGetMaxY(imgVw.frame)-65, screenSize.width, 38) title:LocStr(@"Steps To Use") textcolor:[UIColor whiteColor] font:[UIFont fontWithName:Waltograph size:34]];
    [rpNameLbl setTextAlignment:NSTextAlignmentCenter];
    [imgVw addSubview:rpNameLbl];
    
    UIView *openTrayView = [self getViewWithFrame:CGRectMake(0, mainScrollView.contentSize.height-240-20, screenSize.width/2, 120) title:LocStr(@"Open Fry Tray") imageview:IMG_open_fry_tray];
    [mainScrollView addSubview:openTrayView];
    
    UIView *loadFoodVw = [self getViewWithFrame:CGRectMake(screenSize.width/2, openTrayView.frame.origin.y, openTrayView.frame.size.width, openTrayView.frame.size.height) title:@"Load Food" imageview:IMG_load_food];
    [mainScrollView addSubview:loadFoodVw];
    
    UIView *setTimeView = [self getViewWithFrame:CGRectMake(0, CGRectGetMaxY(openTrayView.frame), screenSize.width/2, 120) title:LocStr(@"Set time and\ntemperature") imageview:IMG_SET_TIME];
    [mainScrollView addSubview:setTimeView];
    
    UIView *letairView = [self getViewWithFrame:CGRectMake(screenSize.width/2, setTimeView.frame.origin.y, openTrayView.frame.size.width, openTrayView.frame.size.height) title:@"Let the air\ndo the cooking" imageview:IMG_air_do_cooking];
    [mainScrollView addSubview:letairView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width/2, CGRectGetMinY(openTrayView.frame)+25, 1, 200)];
    [lineView setBackgroundColor:[UIColor colorWithRed:211/255.f green:213/255.f blue:212/255.f alpha:1.f]];
    [mainScrollView addSubview:lineView];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(openTrayView.frame), screenSize.width-40, 1)];
    [lineView2 setBackgroundColor:[UIColor colorWithRed:211/255.f green:213/255.f blue:212/255.f alpha:1.f]];
    [mainScrollView addSubview:lineView2];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      [self.tabBarController.tabBar setNeedsDisplay];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Methods
-(UIView *)getViewWithFrame:(CGRect)frame title:(NSString *)title imageview:(NSString *)imgVw
{
    UIView *openTrayView = [[UIView alloc] initWithFrame:frame];
    [openTrayView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imgVw1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgVw]];
    [imgVw1  setFrame: CGRectMake(screenSize.width/4-26.5f, 20, 53, 53)];
    [openTrayView addSubview:imgVw1];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width/4-45, CGRectGetMaxY(imgVw1.frame)+12, 90, 28)];
    [lbl setNumberOfLines:0];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:title];
    [lbl setFont:[UIFont fontWithName:MyriadPro_Light size:14]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setTextColor:Gray_Color];
    [openTrayView addSubview:lbl];
    
    return openTrayView;
    
}
//- (BOOL)shouldAutorotate 
//{
//    return NO;
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationLandscapeLeft;
//}
-(void)playVideoBtnTapped:(id)sender
{
   PlayerControllerVC *player1 = [[PlayerControllerVC alloc] initWithContentURL:[[NSBundle mainBundle] URLForResource:@"Demo" withExtension:@"mp4"]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:player.moviePlayer];
    [player1.moviePlayer prepareToPlay];
    player1.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    player1.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    player1.moviePlayer.shouldAutoplay = YES;
    player1.hidesBottomBarWhenPushed=YES;
    [player1.moviePlayer.view setTag:TAG_Player];
   // [player1.view setFrame:CGRectMake(0, 64, screenSize.width, View_Height.height)];
    player1.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
    [self.navigationController pushViewController:player1 animated:NO];
 //    [[APP_DELEGATE window] addSubview:player.view];
}
-(void)moviePlayBackDidFinish:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    id view = [[APP_DELEGATE window] viewWithTag:TAG_Player];
    [view removeFromSuperview];
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
