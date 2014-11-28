//
//  SearchVC.m
//  OxyFryer
//
//  Created by Richa Goyal on 10/1/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "SearchVC.h"
#import "TPKeyboardAvoidingTableView.h"
#import "RecipeDetailVC.h"
#import "RecipeListing.h"
#import "ModelRecipeDetail.h"
@interface SearchVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITextField *searchTextFld;
    TPKeyboardAvoidingTableView *tableViw;
    NSMutableArray *filterdArr;
}
@end

@implementation SearchVC
@synthesize recipeListingArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *vw = [[UIView alloc] init];
    [self.view addSubview:vw];
    
    [[SharedFunction sharedInstance] setTitleViewForNavigationItem:self.navigationItem];
    [[SharedFunction sharedInstance] getLeftButtonForHeadertarget:self];
    filterdArr = [[NSMutableArray alloc] initWithArray:recipeListingArr];
    tableViw = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 64+36, screenSize.width, View_Height.height-36)];
    [self.view addSubview:[self getTableHeader]];
    [tableViw setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableViw setDelegate:self];
    [tableViw setDataSource:self];
    [self.view addSubview:tableViw];
   
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self registerForKeyboardNotifications];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableview delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filterdArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellIdentifier = @"cellIdentifier";
    RecipeListing *model = [filterdArr objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableViw dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.textLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:16]];
        [cell.textLabel setTextColor:Gray_Color];
    }
    [cell.textLabel setText:model.recipe_title];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        RecipeDetailVC *recipeDetailVC = [[RecipeDetailVC alloc] initWithNibName:@"RecipeDetailVC" bundle:nil];
        RecipeListing *recipeModel = [filterdArr objectAtIndex:indexPath.row];
        ModelRecipeDetail *model = [[ModelRecipeDetail alloc] init];
        [model setRp_quantity:recipeModel.rp_quantity];
        [model setRp_id:recipeModel.recipe_id];
        [model setRp_max_cook_time:recipeModel.rp_max_cook_time];
        [model setRp_category:recipeModel.recipe_category];
        [model setRp_image_url:recipeModel.recipe_img_url];
        [model setRp_name:recipeModel.recipe_title];
        [model setRp_type:recipeModel.recipe_type];
        [model setRp_youtube_url:recipeModel.recipe_youtube_url];
        [model setRp_temperature:recipeModel.rp_teperature];
        [recipeDetailVC setRecipeModel:model];
        [self.navigationController pushViewController:recipeDetailVC animated:YES];

}

-(UIView *)getTableHeader
{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, 36)];
    searchTextFld =  [[UITextField alloc] init];
    
    searchTextFld.frame = CGRectMake(0, 0, screenSize.width, 35);
    [searchTextFld setBackgroundColor:[UIColor clearColor]];
    [searchTextFld setDelegate:self];
    [searchTextFld setTextColor:Gray_Color];
    [searchTextFld setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
    [searchTextFld setPlaceholder:@"Search"];
    UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [crossBtn setImage:[UIImage imageNamed:IMG_ic_green_cross] forState:UIControlStateNormal];
    [crossBtn setFrame:CGRectMake(0, 0, 30, 25)];
    [crossBtn addTarget:self action:@selector(crossBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [searchTextFld setRightView:crossBtn];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    [searchTextFld setLeftView:leftView];
    [searchTextFld setLeftViewMode:UITextFieldViewModeAlways];
    
    [searchTextFld setRightViewMode:UITextFieldViewModeAlways];
    [view1 addSubview:searchTextFld];
    
    UIView *lineVw = [[UIView alloc] initWithFrame:CGRectMake(0, 35, screenSize.width, 1)];
    [lineVw setBackgroundColor:GREEN_COLOR];
    [view1 addSubview:lineVw];
    return view1;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 36;
//}


-(void)leftBtnTapped:(id)sender
{
   [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UITextFieldDelegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(NSSTRING_HAS_DATA([str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]))
    {
        NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            RecipeListing *model = (RecipeListing *)evaluatedObject;
            
            NSRange range = [model.recipe_title rangeOfString : str options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
            BOOL found =  range.location == NSNotFound ;
            return !found;
        }];
        [filterdArr setArray:[recipeListingArr filteredArrayUsingPredicate:pred]];
        [tableViw reloadData];
    }
    else
    {
        [filterdArr setArray:recipeListingArr];
        [tableViw reloadData];
    }
   return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
#pragma mark _methods
-(void)crossBtnTapped:(id)sender
{
    [filterdArr setArray:recipeListingArr];
    [searchTextFld setText:@""];
    [searchTextFld resignFirstResponder];
    [tableViw reloadData];
    
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activateUserkeyboardWillShow:)name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activateUserkeyboardWillHide:)name:UIKeyboardDidHideNotification object:nil];
}
#pragma mark - Keyboard notification methods
-(void)activateUserkeyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* userInfo = [aNotification userInfo];
    
    // get the size of the keyboard
    NSValue* boundsValue = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [boundsValue CGRectValue].size;
    
    
    
    
    
    [tableViw setFrame:CGRectMake(0, tableViw.frame.origin.y, tableViw.frame.size.width, screenSize.height-64-36-keyboardSize.height)];
    //[baseView setFrame:CGRectMake(0, -keyboardHeight+64, screenSize.width, screenSizeWithoutNavigation.height)];
    //    CGRect viewFrame = CGRectMake(0, 0, screenSize.width, screenSizeWithoutNavigation.height);
    //    viewFrame.size.height -= (keyboardHeight);
    
    
}

-(void)activateUserkeyboardWillHide:(NSNotification*)aNotification
{
    
    [tableViw setFrame:CGRectMake(0, tableViw.frame.origin.y, tableViw.frame.size.width, View_Height.height-36)];
    
    
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
