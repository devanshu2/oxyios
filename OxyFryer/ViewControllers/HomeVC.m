//
//  HomeVC.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/17/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//
#import "UIImage+ResizeMagick.h"
#import "HomeVC.h"
#import "RecipeListingBL.h"
#import "iCarousel.h"
#import "RecipeListing.h"
#import "CategoryTabbar.h"
#import "RecipeDetailVC.h"
#import "ModelRecipeDetail.h"
#import "UIImageView+AFNetworking.h"
#import "SearchVC.h"

typedef enum {
    HomeFromOther,
    HomeFromDetail
} HomeFrom;
@interface HomeVC () <iCarouselDataSource, iCarouselDelegate, CategoryTabBarDelegate>
{
    UIImageView *largeImgVw;
    NSMutableArray *dataArray;
    NSMutableArray *allDataArray;
    iCarousel *recipeCarousel;
    UILabel *rpNameLbl;
    UILabel *catLbl;
    UILabel *prepLbl;
    CategoryTabbar *catTabBar;
    HomeFrom homeFrom;
    
    //Arvind
    
    UIView *bgView;
    UIImageView *bgImageView;
}
@end

@implementation HomeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    allDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [[SharedFunction sharedInstance] setTitleViewForNavigationItem:self.navigationItem];
    
    [[SharedFunction sharedInstance] getRightButtonForHeaderWithFrame:CGRectMake(0, 0, 18.5, 18.5) target:self backgroundImageNormal:[UIImage imageNamed:IMG_Search_Icon] hoverImage:[UIImage imageNamed:IMG_Search_Icon]];

    
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
   
    
    largeImgVw = [[UIImageView alloc] initWithFrame:CGRectMake(5, 64+38+2, screenSize.width-10, screenSize.height-64-38-2-185-50)];
    //[largeImgVw setContentMode:UIViewContentModeScaleAspectFit];
    [largeImgVw setUserInteractionEnabled:YES];
    [self.view addSubview:largeImgVw];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, screenSize.height-185-50-3, screenSize.width-10, 185)];
    [view setClipsToBounds:YES];
    [self.view addSubview:view];
    
    recipeCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 185)];
    [recipeCarousel setDelegate:self];
    [recipeCarousel setDataSource:self];
    [recipeCarousel setClipsToBounds:YES];
    [recipeCarousel setType:iCarouselTypeWheel];
    [view addSubview:recipeCarousel];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, largeImgVw.frame.size.width, largeImgVw.frame.size.height)];
    [shadowView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.2]];
    [largeImgVw addSubview:shadowView];
    
    rpNameLbl = [[SharedFunction sharedInstance] getLabelWithFrame:CGRectMake(0, largeImgVw.frame.size.height-120, screenSize.width, 38) title:@"" textcolor:[UIColor whiteColor] font:[UIFont fontWithName:Waltograph size:34]];
    [rpNameLbl setTextAlignment:NSTextAlignmentCenter];
    [largeImgVw addSubview:rpNameLbl];
    
    catLbl = [[SharedFunction sharedInstance] getLabelWithFrame:CGRectMake(0, CGRectGetMaxY(rpNameLbl.frame)+7, screenSize.width, 18) title:@"" textcolor:[UIColor whiteColor] font:[UIFont fontWithName:MyriadPro_Regular size:18]];
    [catLbl setTextAlignment:NSTextAlignmentCenter];
    [largeImgVw addSubview:catLbl];
    
    prepLbl = [[SharedFunction sharedInstance] getLabelWithFrame:CGRectMake(0, CGRectGetMaxY(catLbl.frame)+4, screenSize.width, 18) title:@"" textcolor:[UIColor whiteColor] font:[UIFont fontWithName:MyriadPro_Regular size:18]];
    [prepLbl setTextAlignment:NSTextAlignmentCenter];
    [largeImgVw addSubview:prepLbl];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToRecipeDetail)];
    [shadowView addGestureRecognizer:tapGes];
    
    [self configerTopImageView];
	// Do any additional setup after loading the view.
  
}

//Arvind
-(void)configerTopImageView
{
    bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    bgImageView = [[UIImageView alloc]init];
    bgImageView.image= [UIImage imageNamed:@"Default.png"];
    bgImageView.frame = CGRectMake(0, 0, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame));
    [bgView addSubview:bgImageView];
    
    [[APP_DELEGATE window] addSubview:bgView];
}

-(void)removeTopView
{
    if(bgView)
    {
        [bgView removeFromSuperview];
        bgImageView = nil;
        bgView = nil;
    }
}
//Arvind

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    if(homeFrom==HomeFromOther)
    {
    catTabBar = [[CategoryTabbar alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, 35)];
    [catTabBar setDelegate:self];
    [self.view addSubview:catTabBar];
    [allDataArray setArray:[[RecipeListingBL sharedInstance] fetchRecipeListingData]];
    [dataArray setArray:allDataArray];
    [recipeCarousel reloadData];
    [self getRecipeListing];
    }
    else
        homeFrom = HomeFromOther;
}
//- (BOOL)shouldAutorotate 
//{
//    return YES;
//}
//
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}

-(void)getRecipeListing
{
   
  
    
    
    [APP_DELEGATE ShowProcessingView];
     [[AFAPIClient sharedClient] getPath:URL_getRecipeListing parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
         [self removeTopView];
        [APP_DELEGATE HideProcessingView];
        NSDictionary *dict = (NSDictionary *)responseObject;
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            if(HAS_DATA(dict, KEY_ErrorCode) && ![[dict objectForKey:KEY_ErrorCode] boolValue])
            {
                if(HAS_DATA(dict, KEY_Data) && [[dict objectForKey:KEY_Data] isKindOfClass:[NSArray class]])
                {
                    [[RecipeListingBL sharedInstance] saveRecipeListing:[dict objectForKey:KEY_Data]];
                    [allDataArray setArray:[[RecipeListingBL sharedInstance] fetchRecipeListingData]];
                    [dataArray setArray:allDataArray];
                    [recipeCarousel reloadData];
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
         if(allDataArray.count)
             [catTabBar tapAllButton];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [APP_DELEGATE HideProcessingView];
        [self removeTopView];
        [[SharedFunction sharedInstance] showAlertViewWithMeg:[error localizedDescription]];
        if(allDataArray.count)
            [catTabBar tapAllButton];
    }];

}

-(void)rightBtnTapped:(id)sender
{
    SearchVC *searchVCObj = [[SearchVC alloc] initWithNibName:@"SearchVC" bundle:nil];
    [searchVCObj setRecipeListingArr:allDataArray];
    [self.navigationController pushViewController:searchVCObj animated:YES];
}

#pragma mark - iCarousal delegate methods
-(void)goToRecipeDetail
{
    if(dataArray.count)
    {
        RecipeDetailVC *recipeDetailVC = [[RecipeDetailVC alloc] initWithNibName:@"RecipeDetailVC" bundle:nil];
        RecipeListing *recipeModel = [dataArray objectAtIndex:recipeCarousel.currentItemIndex];
        ModelRecipeDetail *model = [[ModelRecipeDetail alloc] init];
        [model setRp_quantity:recipeModel.rp_quantity];
        [model setRp_id:recipeModel.recipe_id];
        [model setRp_max_cook_time:recipeModel.rp_max_cook_time];
        [model setRp_category:recipeModel.recipe_category];
        [model setRp_image_url:recipeModel.recipe_img_url];
        [model setRp_name:recipeModel.recipe_title];
        [model setRp_type:recipeModel.recipe_type];
        [model setRp_max_preparation_time:recipeModel.rp_max_preparation_time];
        [model setRp_youtube_url:recipeModel.recipe_youtube_url];
        [model setRp_temperature:recipeModel.rp_teperature];
        [recipeDetailVC setRecipeModel:model];
        homeFrom = HomeFromDetail;
        [self.navigationController pushViewController:recipeDetailVC animated:YES];
    }
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //generate 100 item views
    //normally we'd use a backing array
    //as shown in the basic iOS example
    //but for this example we haven't bothered
    return [dataArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
        //load new item view instance from nib 
        //control events are bound to view controller in nib file
        //note that it is only safe to use the reusingView if we return the same nib for each
        //item view, if different items have different contents, ignore the reusingView value
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135, 185)];
        [view setContentMode:UIViewContentModeScaleAspectFit];
        [view setClipsToBounds:YES];
        
    }
    RecipeListing *recipeModel = [dataArray objectAtIndex:index];
    UIImageView *imgView = (UIImageView *)view;
    
    [imgView setImageWithURL:[NSURL URLWithString:recipeModel.recipe_img_url] placeholderImage:[UIImage imageNamed:IMG_DEFAULT_RECIPE] str:[NSString stringWithFormat:@"%fx%f#", view.frame.size.width,view.frame.size.height]];
    
    return view;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if(dataArray.count)
    {
        RecipeListing *recipeModel = [dataArray objectAtIndex:carousel.currentItemIndex];
            NSString *str = [NSString stringWithFormat:@"%fx%f#", largeImgVw.frame.size.width,largeImgVw.frame.size.height];
        [largeImgVw setImageWithURL:[NSURL URLWithString:recipeModel.recipe_img_url] placeholderImage:[UIImage imageNamed:IMG_DEFAULT_RECIPE] str:str];
        
        [rpNameLbl setText:recipeModel.recipe_title];
        
          NSArray *catArr = [[NSDictionary dictionaryWithContentsOfFile:STATIC_DATA_PLIST] objectForKey:@"Categories"];
        NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSDictionary *dict = (NSDictionary *)evaluatedObject;
            return ([[dict objectForKey:@"Cat_Id"] integerValue]==[recipeModel.recipe_category integerValue] && [[dict objectForKey:@"Type"] integerValue]==[recipeModel.recipe_type integerValue]);
        }];
        NSDictionary *dict = [[catArr filteredArrayUsingPredicate:pred] lastObject];
        if(dict)
            [catLbl setText:[dict objectForKey:@"Title"]];
        
        
        [prepLbl setText:[NSString stringWithFormat:@"%@ %@-%@ minutes",LocStr(@"Preparation Time :"), recipeModel.rp_min_preparation_time, recipeModel.rp_max_preparation_time]];
        
        UIView *view = carousel.currentItemView;
        [view.layer setBorderWidth:2];
        [view.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    else
    {
        [rpNameLbl setText:@""];
        [catLbl setText:@""];
        [prepLbl setText:@""];
        [largeImgVw setImage:[UIImage imageNamed:@""]];
    }
}

-(void)carouselDidScroll:(iCarousel *)carousel
{
    for (UIView *vw  in [carousel visibleItemViews]) {
        [vw.layer setBorderColor:[UIColor clearColor].CGColor];
    }
}

#pragma mark -CategoryTabbar delegate methods
-(void)categoryButtonTapped:(NSDictionary *)catDict
{
      NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
          RecipeListing *listModel = (RecipeListing *)evaluatedObject;
          BOOL filter = YES;
         if([[catDict objectForKey:@"Cat_Id"] integerValue]!=0 && [listModel.recipe_category integerValue]
            !=[[catDict objectForKey:@"Cat_Id"] integerValue])
             filter = NO;
          
          if([[catDict objectForKey:@"Type"] integerValue]!=0 && [listModel.recipe_type integerValue]
             !=[[catDict objectForKey:@"Type"] integerValue])
              filter = NO;
          
          return filter;
             
      }];
    [dataArray setArray:[allDataArray filteredArrayUsingPredicate:pred]];
    [recipeCarousel reloadData];
}

@end
