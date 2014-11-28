//
//  AppDelegate.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/17/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"
#import "HowToUseVC.h"
#import "FAQsVC.h"
#import "SendQueryVC.h"
#import "MyTabbRaController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RecipeDetailVC.h"
#import "RecipeDetailBL.h"
#import "ModelRecipeDetail.h"
#import "UploadRecipeVC.h"
#import "UIApplication+UIApplication_pvt.h"

#define TAG_ProcessingAlertView 4040
@implementation AppDelegate
@synthesize isMoviePlayerOpened;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     pushDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.isMoviePlayerOpened = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
     [[AFAPIClient sharedClient] setDefaultHeader:api_token value:dummy_api_token];
    
    //navController = [[UINavigationController alloc] initWithRootViewController:[self makeTabBarController]];
  //  [navController.navigationBar setShadowImage:[UIImage new]];

    [self.window setRootViewController:[self makeTabBarController]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    if([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey])
        [self manageLaunchWithRemoteNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userinfo#=%@",userInfo);
    
    if (application.applicationState == UIApplicationStateActive )
        [self manageRemoteNotification:userInfo];
     else
        [self manageLaunchWithRemoteNotification:userInfo];
}

-(void)manageLaunchWithRemoteNotification:(NSDictionary*)userInfo
{
      NSInteger apnsType = [[[userInfo objectForKey:KEY_aps] objectForKey:KEY_apnsType] integerValue];
    
    
    switch (apnsType) {
        case 1:
        {
         [self redirectToRecipeDetail:[[userInfo objectForKey:KEY_aps] objectForKey:KEY_result]];
        }
            break;
        case 2:
            
        default:
            break;
    }
    
    
}

-(void)manageRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userinfo=%@",userInfo);
    
       NSInteger apnsType = [[[userInfo objectForKey:KEY_aps] objectForKey:KEY_apnsType] integerValue];
    
    
    
    switch (apnsType) {
        case 2:// dealShare
        {
          UIAlertView  *alertView2=[[UIAlertView alloc]initWithTitle:APP_NAME message:[[userInfo objectForKey:KEY_aps] objectForKey:KEY_alert] delegate:nil cancelButtonTitle:LocStr(@"OK") otherButtonTitles:nil, nil];
            [alertView2 show];

        }
            break;
        case 1:// coupon expiry
        {
            if(alertView)
                [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
            
            alertView=[[UIAlertView alloc]initWithTitle:APP_NAME message:[[userInfo objectForKey:KEY_aps] objectForKey:KEY_alert] delegate:self cancelButtonTitle:LocStr(@"Cancel") otherButtonTitles:LocStr(@"View"), nil];
            alertView.tag = apnsType;
            [pushDict setDictionary:[userInfo objectForKey:KEY_aps]];
            [alertView show];
        }
            break;
            
        default:
            break;
    }
    
    
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    
    NSString *deviceTokenID = [self parseDeviceToken:[devToken description]];
    
    DLog(@" DEVICES TOKEN IS ----> %@",deviceTokenID);
    
    NSDictionary *requestDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:deviceTokenID, @"ios", [[UIDevice currentDevice] systemVersion],[[UIDevice currentDevice] model], [[UIApplication sharedApplication] getUUID], nil] forKeys:[NSArray arrayWithObjects:KEY_deviceToken, KEY_platform, KEY_osVersion, KEY_deviceModel, KEY_deviceTagstrip, nil]];
    
    [[AFAPIClient sharedClient] postPath:URL_registration parameters:requestDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *errText = [NSString stringWithFormat:@"APN Error:%@",err];
    DLog(@"Error in registration. Error: %@", errText);
}


#pragma matk - Methods
- (NSString*)parseDeviceToken:(NSString*)tokenStr {
    return [[[tokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""]
             stringByReplacingOccurrencesOfString:@">" withString:@""]
            stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(MyTabbRaController *)makeTabBarController
{
    NSMutableArray *tabBarControllerArray = [NSMutableArray array];
    
    HomeVC *homeVCObj = [[HomeVC alloc] init];
    UINavigationController *homeVCNavController = [[UINavigationController alloc] initWithRootViewController:homeVCObj];
    [homeVCObj setTitle:LocStr(@"Recipes")];
    [tabBarControllerArray addObject:homeVCNavController];
    
    
    UploadRecipeVC *sendQueryVC = [[UploadRecipeVC alloc] initWithNibName:@"UploadRecipeVC" bundle:nil];
    [sendQueryVC setTitle:LocStr(@"Upload Recipe")];
    UINavigationController *upLoadRecipeNavController = [[UINavigationController alloc] initWithRootViewController:sendQueryVC];
    [tabBarControllerArray addObject:upLoadRecipeNavController];
    
    
    HowToUseVC *howtoUseVCObj = [[HowToUseVC alloc] initWithNibName:@"HowToUseVC" bundle:nil];
    [howtoUseVCObj setTitle:LocStr(@"How to Use")];
    UINavigationController *howtoUseVCNavController = [[UINavigationController alloc] initWithRootViewController:howtoUseVCObj];
    [tabBarControllerArray addObject:howtoUseVCNavController];
    
    
    FAQsVC *faqVC = [[FAQsVC alloc] initWithNibName:@"FAQsVC" bundle:nil];
    [faqVC setTitle:LocStr(@"FAQs")];
    UINavigationController *faqNavController = [[UINavigationController alloc] initWithRootViewController:faqVC];
    [tabBarControllerArray addObject:faqNavController];
    

    
    
    
    
    
    
    tabBarController = [[MyTabbRaController alloc] init];
    [tabBarController setViewControllers:tabBarControllerArray animated:YES];
    
    UITabBar *tabBar = tabBarController.tabBar;
    [tabBar setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [tabBar setSelectedImageTintColor:GREEN_COLOR];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width)/4, 5, 0.7, 39)];
    [view setBackgroundColor:[UIColor colorWithRed:211/255.f green:213/255.f blue:212/255.f alpha:1.f]];
    [tabBar addSubview:view];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width)/2, 5, 0.7, 39)];
    [view2 setBackgroundColor:[UIColor colorWithRed:211/255.f green:213/255.f blue:212/255.f alpha:1.f]];
    [tabBar addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(3*(screenSize.width)/4, 5, 0.7, 39)];
    [view3 setBackgroundColor:[UIColor colorWithRed:211/255.f green:213/255.f blue:212/255.f alpha:1.f]];
    [tabBar addSubview:view3];
    
    UIView *sepVw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 0.5)];
    [sepVw setBackgroundColor:[UIColor colorWithRed:211/255.f green:213/255.f blue:212/255.f alpha:1.f]];
    [tabBar addSubview:sepVw];
    
    UITabBarItem *tabItem1 = [tabBar.items objectAtIndex:0];
    [tabItem1 setImage:[UIImage imageNamed:IMG_recipes_unselected]];
    
    
    UITabBarItem *tabItem2 = [tabBar.items objectAtIndex:1];
     [tabItem2 setImage:[UIImage imageNamed:IMG_UploadREcipe_Unselected]];
    
    UITabBarItem *tabItem3 = [tabBar.items objectAtIndex:2];
    [tabItem3 setImage:[UIImage imageNamed:IMG_how_to_use_unselected]];

   
    
    UITabBarItem *tabItem4 = [tabBar.items objectAtIndex:3];
    [tabItem4 setImage:[UIImage imageNamed:IMG_faq_unselected]];
    //[tabItem4 setImage:[UIImage imageNamed:IMG_UploadREcipe_Unselected]];
    

    
    [tabBarController setSelectedIndex:0];
    
    return tabBarController;
    
}

-(void)alertView:(UIAlertView *)alertView1 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex!=alertView1.cancelButtonIndex)
    {
        switch (alertView1.tag) {
            case 1: //app launch
            {
              [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PUSHNOTIF object:nil];
              [self redirectToRecipeDetail:[pushDict objectForKey:KEY_result]];
                
            }
                break;
            case 2: //recipeDetail
            {
               
                
            }
                break;
                
            default:
                break;
        }
    }
}


-(void)redirectToRecipeDetail:(NSDictionary *)resultDict
{
    if(HAS_DATA(resultDict, KEY_ID))
    {
        NSDictionary *requestDict = [NSDictionary dictionaryWithObject:[resultDict objectForKey:KEY_ID] forKey:KEY_recipeID];
        
        
        
        [APP_DELEGATE ShowProcessingView];
        [[AFAPIClient sharedClient] getPath:URL_getRecipeDetail parameters:requestDict success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            [APP_DELEGATE HideProcessingView];
            NSDictionary *dict = (NSDictionary *)responseObject;
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                if(HAS_DATA(dict, KEY_ErrorCode) && ![[dict objectForKey:KEY_ErrorCode] boolValue])
                {
                    if(HAS_DATA(dict, KEY_Data) && [[dict objectForKey:KEY_Data] isKindOfClass:[NSDictionary class]])
                    {
                        RecipeDetailVC *recipeDetailVCobj = [[RecipeDetailVC alloc] initWithNibName:@"RecipeDetailVC" bundle:nil];
                        [recipeDetailVCobj setRecipeModel:[[RecipeDetailBL sharedInstance] getRecipeDetailModel:[dict objectForKey:KEY_Data] modelRecipeDetail:[[ModelRecipeDetail alloc] init]]];
                        [recipeDetailVCobj setIsFromPush:YES];
                       UINavigationController *nav = [[tabBarController viewControllers] objectAtIndex:0];
                        [nav popToRootViewControllerAnimated:NO];
                        [nav pushViewController:recipeDetailVCobj animated:YES];
                        [tabBarController setSelectedIndex:0];
                    }
                    
                    
                }
                else if(HAS_DATA(dict, KEY_ErrorCode) && [[dict objectForKey:KEY_ErrorCode] boolValue] && HAS_DATA(dict, KEY_ErrorMessage))
                    [[SharedFunction sharedInstance] showAlertViewWithMeg:[dict objectForKey:KEY_ErrorMessage]];
                else
                    [[SharedFunction sharedInstance] showAlertViewWithMeg:LocStr(@"Some_Error")];
            }
            else
            {
                [[SharedFunction sharedInstance] showAlertViewWithMeg:LocStr(@"Server_Error")];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [APP_DELEGATE HideProcessingView];
            [[SharedFunction sharedInstance] showAlertViewWithMeg:[error localizedDescription]];
        }];
    
    }
}


#pragma mark -Methods

-(void)ShowProcessingView
{
    UIView *processingAlertView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, screenSize.height)];
    [processingAlertView setTag:TAG_ProcessingAlertView];
    UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center=processingAlertView.center;
    [indicator startAnimating];
    [processingAlertView addSubview:indicator];
    [processingAlertView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    
    [self.window addSubview:processingAlertView];
    //    [self.window makeKeyAndVisible];
    [self.window bringSubviewToFront:processingAlertView];
}

-(void)HideProcessingView
{
    UIView *processsingView = [self.window viewWithTag:TAG_ProcessingAlertView];
    [processsingView removeFromSuperview];
}

@end
