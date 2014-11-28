//
//  RecipeDetailVC.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/27/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "RecipeDetailVC.h"
#import "ModelRecipeDetail.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RecipeDetailBL.h"
#import "UIImageView+AFNetworking.h"
#import "UploadRecipeVC.h"
#define TAG_YOUTUBE_WEBVIEW 3393
typedef enum
{
    SelectedTypeIngredients,
    SelectedTypeCook
}SelectedType;
@interface RecipeDetailVC () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
{
    CGFloat ingredientHeight;
    CGFloat howtoCookHeight;
    BOOL dataLoaded;
    UITableView *recipeDetTblVw;
    SelectedType selectedType;
    
    UIWebView *youTubeVdoView;
}

@end

@implementation RecipeDetailVC
@synthesize recipeModel, isFromPush;
- (void)viewDidLoad {
    [super viewDidLoad];
    
        // Add observer for "Done" button click

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotPushNotification) name:NOTI_PUSHNOTIF object:nil];
    // Do any additional setup after loading the view from its nib.
    [[SharedFunction sharedInstance] setTitleViewForNavigationItem:self.navigationItem];
    [[SharedFunction sharedInstance] getLeftButtonForHeadertarget:self];
    ingredientHeight=0;
    howtoCookHeight=0;
    
    UIView *vw = [[UIView alloc] init];
    [self.view addSubview:vw];
    
    recipeDetTblVw = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, View_Height.height) style:UITableViewStyleGrouped];
    [self setTableHeaderView];
    selectedType = SelectedTypeIngredients;
    [recipeDetTblVw setBackgroundColor:[UIColor clearColor]];
    [recipeDetTblVw setDelegate:self];
    [recipeDetTblVw setDataSource:self];
    [recipeDetTblVw setBackgroundView:nil];
    [recipeDetTblVw setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:recipeDetTblVw];
    
    if(!isFromPush)
      [self getRecipeDetailFromServer];
    else
        dataLoaded = YES;
}


-(void)gotPushNotification
{
    [youTubeVdoView loadHTMLString:nil baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationLandscapeLeft;
//}
#pragma mark -Methods

-(void)setTableHeaderView
{
    UIView *tableHeaderVw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 180+65)];
    [tableHeaderVw setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *recipeImgVw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 180)];
    [recipeImgVw setBackgroundColor:[UIColor clearColor]];
    [recipeImgVw setImageWithURL:[NSURL URLWithString:recipeModel.rp_image_url] placeholderImage:[UIImage imageNamed:IMG_DEFAULT_RECIPE] str:[NSString stringWithFormat:@"%fx%f#", recipeImgVw.frame.size.width,recipeImgVw.frame.size.height]];
    [recipeImgVw setUserInteractionEnabled:YES];
    [tableHeaderVw addSubview:recipeImgVw];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, recipeImgVw.frame.size.width, recipeImgVw.frame.size.height)];
    [shadowView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.2]];
    [recipeImgVw addSubview:shadowView];
    
    UIButton *playVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playVideoBtn setFrame:CGRectMake(screenSize.width/2-21.5, recipeImgVw.frame.size.height/2-22.5f, 43, 45)];
    [playVideoBtn setHidden:!(NSSTRING_HAS_DATA(recipeModel.rp_youtube_url))];
    [playVideoBtn addTarget:self action:@selector(playVideoBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [playVideoBtn setBackgroundImage:[UIImage imageNamed:IMG_PLAY_VIDEO_BTN] forState:UIControlStateNormal];
    [playVideoBtn setBackgroundColor:[UIColor clearColor]];
    [recipeImgVw addSubview:playVideoBtn];
    
    UILabel *rpNameLbl = [[SharedFunction sharedInstance] getLabelWithFrame:CGRectMake(0, CGRectGetMaxY(recipeImgVw.frame)-62, screenSize.width, 38) title:recipeModel.rp_name textcolor:[UIColor whiteColor] font:[UIFont fontWithName:Waltograph size:34]];
    [rpNameLbl setTextAlignment:NSTextAlignmentCenter];
    [tableHeaderVw addSubview:rpNameLbl];
    
   
    UIView *cookingtimeview = [self getViewWithFirstLabelText:@"Cooking Time" otherString:[NSString stringWithFormat:@"%@ Min", recipeModel.rp_max_cook_time] frame:CGRectMake(0, CGRectGetMaxY(recipeImgVw.frame), screenSize.width/3, 65)];
    [tableHeaderVw addSubview:cookingtimeview];
    
    
    UIView *temperatureView = [self getViewWithFirstLabelText:@"Temperature" otherString:recipeModel.rp_temperature frame:CGRectMake(CGRectGetMaxX(cookingtimeview.frame), CGRectGetMaxY(recipeImgVw.frame), screenSize.width/3, 65)];
    [tableHeaderVw addSubview:temperatureView];
    
    UIView *quantityView = [self getViewWithFirstLabelText:@"Prep. Time" otherString:[NSString stringWithFormat:@"%@ Min", recipeModel.rp_max_preparation_time] frame:CGRectMake(CGRectGetMaxX(temperatureView.frame), CGRectGetMaxY(recipeImgVw.frame), screenSize.width/3, 65)];
    [tableHeaderVw addSubview:quantityView];
    
    [recipeDetTblVw setTableHeaderView:tableHeaderVw];
    
    
    UIView *sepVw = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cookingtimeview.frame)-3, 12, 0.5,cookingtimeview.frame.size.height-24)];
    [sepVw setBackgroundColor:[UIColor colorWithRed:211/255.f green:213/255.f blue:212/255.f alpha:1.f]];
    [cookingtimeview addSubview:sepVw];
    
    UIView *sepVw2 = [[UIView alloc] initWithFrame:CGRectMake(3, 12, 0.5,cookingtimeview.frame.size.height-24)];
    [sepVw2 setBackgroundColor:[UIColor colorWithRed:211/255.f green:213/255.f blue:212/255.f alpha:1.f]];
    [quantityView addSubview:sepVw2];
}

-(void)playVideoBtnTapped:(id)sender
{

    youTubeVdoView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, View_Height.height)];
    [youTubeVdoView setBackgroundColor:[UIColor clearColor]];
    [youTubeVdoView setTag:TAG_YOUTUBE_WEBVIEW];
    youTubeVdoView.delegate = self;
    [self loadWebViewWithUrl:recipeModel.rp_youtube_url];
    youTubeVdoView.mediaPlaybackRequiresUserAction = NO;
    [self.view addSubview:youTubeVdoView];
    videoPlaying = YES;
}

- (void)loadWebViewWithUrl:(NSString *)urlString {
    
    NSString *youTubeURL1=[urlString stringByReplacingOccurrencesOfString:@"watch?" withString:@""];
    NSRange replaceRange = [youTubeURL1 rangeOfString:@"="];
    if (replaceRange.location != NSNotFound){
        youTubeURL1 = [youTubeURL1 stringByReplacingCharactersInRange:replaceRange withString:@"/"];
    }
    NSRange replaceRange2 = [youTubeURL1 rangeOfString:@"embed"];
    if(replaceRange2.location!=NSNotFound)
        youTubeURL1 = [youTubeURL1 stringByReplacingCharactersInRange:replaceRange2 withString:@"v"];
  //  youTubeURL = [youTubeURL stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
    
    NSMutableString *html = [[NSMutableString alloc] initWithCapacity:1];
    [html appendString:@"<html><head>"];
    [html appendString:@"<style type=\"text/css\">"];
    [html appendString:@"body {"];
    [html appendString:@"background-color: transparent;"];
    [html appendString:@"color: white;"];
    [html appendString:@"}"];
    [html appendString:@"</style>"];
    [html appendString:@"</head><body style=\"margin:0\">"];
    [html appendFormat:@"<embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\"", youTubeURL1];
    [html appendFormat:@"width=\"%0.0f\" height=\"%0.0f\"></embed>", youTubeVdoView.frame.size.width, youTubeVdoView.frame.size.height];
    [html appendString:@"</body></html>"];
    
    [youTubeVdoView loadHTMLString:html baseURL:nil];

}

-(UIView *)getViewWithFirstLabelText:(NSString *)str1 otherString:(NSString *)str2 frame:(CGRect)frame
{
    UIView *detailVw = [[UIView alloc] initWithFrame:frame];
    [detailVw setBackgroundColor:[UIColor colorWithRed:241/255.f green:243/255.f blue:242/255.f alpha:1.f]];
    
    UILabel *detLbl1 = [[SharedFunction sharedInstance] getLabelWithFrame:CGRectMake(0, 18, detailVw.frame.size.width, 14) title:str1 textcolor:Gray_Color font:[UIFont fontWithName:MyriadPro_Light size:14]];
    [detLbl1 setTextAlignment:NSTextAlignmentCenter];
    [detailVw addSubview:detLbl1];
    
    UILabel *detLbl2 = [[SharedFunction sharedInstance] getLabelWithFrame:CGRectMake(0, CGRectGetMaxY(detLbl1.frame)+10, detailVw.frame.size.width, 16) title:str2 textcolor:Dark_Gray_Color font:[UIFont fontWithName:MyriadPro_Regular size:16]];
    [detLbl2 setTextAlignment:NSTextAlignmentCenter];
    [detLbl2 setAdjustsFontSizeToFitWidth:YES];
    [detailVw addSubview:detLbl2];
    
    return detailVw;
    
}
-(void)getRecipeDetailFromServer
{
    
    NSDictionary *requestDict = [NSDictionary dictionaryWithObject:recipeModel.rp_id forKey:KEY_recipeID];

    
    
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
                    recipeModel = [[RecipeDetailBL sharedInstance] getRecipeDetailModel:[dict objectForKey:KEY_Data] modelRecipeDetail:recipeModel];
                     dataLoaded = YES;
                    [recipeDetTblVw reloadData];
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

-(void)ingredientsBtnTapped:(id)sender
{
    selectedType = SelectedTypeIngredients;
    [recipeDetTblVw reloadData];
    
}

-(void)howToCookBtnTapped:(id)sender
{
    selectedType = SelectedTypeCook;
    [recipeDetTblVw reloadData];
}

-(void)uploadRecipeBtnTapped:(id)sender
{
    [self.tabBarController setSelectedIndex:1];
//    UploadRecipeVC *uploadRecipeObj = [[UploadRecipeVC alloc] initWithNibName:@"UploadRecipeVC" bundle:nil];
//    [uploadRecipeObj setIsLeftBtn:YES];
//    [self.navigationController pushViewController:uploadRecipeObj animated:YES];
    
}

#pragma mark -UITableview delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(dataLoaded)
      return 1;
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (selectedType) {
        case SelectedTypeCook:
            return howtoCookHeight;
            break;
        case SelectedTypeIngredients:
            return ingredientHeight;
        default:
            break;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (selectedType) {
        case SelectedTypeIngredients:
        {
            NSString *cellIdentifier = @"cellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(cell==nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.3)];
                [webView setUserInteractionEnabled:NO];
                [webView setDelegate:self];
                [webView setTag:1001];
                webView.scrollView.scrollEnabled = NO;
                webView.scrollView.bounces = NO;
                [webView setBackgroundColor:[UIColor clearColor]];
                [cell addSubview:webView];
                [webView loadHTMLString:recipeModel.rp_ingredients baseURL:nil];
            }
            
            return cell;
        }
        break;
            
        case SelectedTypeCook:
        {
            NSString *cellIdentifier = @"cellIdentifier2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(cell==nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.3)];
                [webView setUserInteractionEnabled:NO];
                [webView setDelegate:self];
                [webView setTag:1001];
                webView.scrollView.scrollEnabled = NO;
                webView.scrollView.bounces = NO;
                [webView setBackgroundColor:[UIColor clearColor]];
                [cell addSubview:webView];
                [webView loadHTMLString:recipeModel.RpHowToCook baseURL:nil];
            }
           
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    
       return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 60)];
    
    UIView *buttonBgVw = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width/2-102), 15, 204, 30)];
    [buttonBgVw setBackgroundColor:[UIColor whiteColor]];
    [buttonBgVw.layer setBorderWidth:1];
    [buttonBgVw.layer setCornerRadius:7];
    [buttonBgVw setClipsToBounds:YES];
    [buttonBgVw.layer setBorderColor:GREEN_COLOR.CGColor];
    [headerView addSubview:buttonBgVw];
    
    
       UIButton *ingridientsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ingridientsBtn setTitle:LocStr(@"Ingredients") forState:UIControlStateNormal];
        [ingridientsBtn.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:16]];
        [ingridientsBtn addTarget:self action:@selector(ingredientsBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [ingridientsBtn setBackgroundColor:[UIColor whiteColor]];
        [ingridientsBtn setFrame:CGRectMake(0, 0, buttonBgVw.frame.size.width/2, buttonBgVw.frame.size.height)];
        [ingridientsBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        [ingridientsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [buttonBgVw addSubview:ingridientsBtn];
    
       UIButton  *howtoCookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [howtoCookBtn setTitle:LocStr(@"How to Cook") forState:UIControlStateNormal];
        [howtoCookBtn.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:16]];
        [howtoCookBtn addTarget:self action:@selector(howToCookBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [howtoCookBtn setBackgroundColor:[UIColor whiteColor]];
        [howtoCookBtn setFrame:CGRectMake(CGRectGetMaxX(ingridientsBtn.frame), 0, buttonBgVw.frame.size.width/2, buttonBgVw.frame.size.height)];
        [howtoCookBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
         [howtoCookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [buttonBgVw addSubview:howtoCookBtn];
    
    switch (selectedType) {
        case SelectedTypeIngredients:
            [ingridientsBtn setSelected:YES];
            [ingridientsBtn.titleLabel setFont:[UIFont fontWithName:MyriadPro_Semibold size:16]];
            [ingridientsBtn setBackgroundColor:GREEN_COLOR];
            break;
        case SelectedTypeCook:
            [howtoCookBtn setSelected:YES];
            [howtoCookBtn setBackgroundColor:GREEN_COLOR];
            [howtoCookBtn.titleLabel setFont:[UIFont fontWithName:MyriadPro_Bold size:16]];
            
        default:
            break;
    }
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
     return 170;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerVw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 170)];
    
    UILabel *frrlFreeLbl = [[SharedFunction sharedInstance] getLabelWithFrame:CGRectMake(0, 15, screenSize.width, 14) title:LocStr(@"Feel like yours is better than this? Share it with us") textcolor:Gray_Color font:[UIFont fontWithName:MyriadPro_Light size:14]];
    [frrlFreeLbl setTextAlignment:NSTextAlignmentCenter];
    [footerVw addSubview:frrlFreeLbl];
    
    UIButton *upLoadYourRecipeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upLoadYourRecipeBtn setTitle:LocStr(@"Upload Your Recipe") forState:UIControlStateNormal];
    [upLoadYourRecipeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [upLoadYourRecipeBtn.layer setBorderWidth:1];
    [upLoadYourRecipeBtn.layer setBorderColor:GREEN_COLOR.CGColor];
    [upLoadYourRecipeBtn addTarget:self action:@selector(uploadRecipeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [upLoadYourRecipeBtn setImage:[UIImage imageNamed:IMG_upload_recipe_icon] forState:UIControlStateNormal];
    [upLoadYourRecipeBtn.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:15]];
    [upLoadYourRecipeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
    [upLoadYourRecipeBtn setFrame:CGRectMake(screenSize.width/2-82, CGRectGetMaxY(frrlFreeLbl.frame)+15, 164, 35)];
    [footerVw addSubview:upLoadYourRecipeBtn];
    
    UILabel *tellFrndLbl = [[SharedFunction sharedInstance] getLabelWithFrame:CGRectMake(0, CGRectGetMaxY(upLoadYourRecipeBtn.frame)+13, screenSize.width, 14) title:LocStr(@"Tell your friend about this recipe") textcolor:Gray_Color font:[UIFont fontWithName:MyriadPro_Light size:14]];
    [tellFrndLbl setTextAlignment:NSTextAlignmentCenter];
    [footerVw addSubview:tellFrndLbl];
    
    UIButton *fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fbButton setBackgroundImage:[UIImage imageNamed:IMG_facebook] forState:UIControlStateNormal];
    [fbButton addTarget:self action:@selector(facebookBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [fbButton setFrame:CGRectMake((screenSize.width-50-117)/2, CGRectGetMaxY(tellFrndLbl.frame)+13, 39, 39)];
    [footerVw addSubview:fbButton];
    
    UIButton *twitterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:IMG_twitter] forState:UIControlStateNormal];
    [twitterBtn setFrame:CGRectMake(CGRectGetMaxX(fbButton.frame)+25, fbButton.frame.origin.y, 39, 39)];
    [twitterBtn addTarget:self action:@selector(twiterBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [footerVw addSubview:twitterBtn];
    
    UIButton *gPlusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gPlusBtn setBackgroundImage:[UIImage imageNamed:IMG_googleplus] forState:UIControlStateNormal];
    [gPlusBtn addTarget:self action:@selector(googlePlayBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [gPlusBtn setFrame:CGRectMake(CGRectGetMaxX(twitterBtn.frame)+25, fbButton.frame.origin.y, 39, 39)];
    [footerVw addSubview:gPlusBtn];
    
    return footerVw;
}

-(void)facebookBtnTapped:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/kenstarindia"]];
}

-(void)twiterBtnTapped:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/kenstarindia"]];
}

-(void)googlePlayBtnTapped:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://plus.google.com/u/0/107696443375900506990/posts"]];
}
#pragma mark - UIWebViewDelegate methods
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(webView.tag==TAG_YOUTUBE_WEBVIEW)
    {
        
        videoPlaying = YES;
    }
    else
    {
        CGSize size = [webView sizeThatFits:CGSizeZero];
        [webView setFrame:CGRectMake(0, 0, screenSize.width, size.height)];
        [webView setBackgroundColor:[UIColor clearColor]];
        switch (selectedType) {
                
            case SelectedTypeIngredients:
                ingredientHeight = size.height;
                break;
            case SelectedTypeCook:
                howtoCookHeight = size.height;
            default:
                break;
        }
        [recipeDetTblVw reloadData];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(webView.tag==TAG_YOUTUBE_WEBVIEW)
    {
        videoPlaying = NO;
        [[SharedFunction sharedInstance] showAlertViewWithMeg:LocStr(@"Some_Error")];
        [webView removeFromSuperview];
        
    }
}
-(void)leftBtnTapped:(id)sender
{
    if(videoPlaying)
    {
        videoPlaying=NO;
        [youTubeVdoView removeFromSuperview];
    }
    else
    [self.navigationController popViewControllerAnimated:YES];
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
