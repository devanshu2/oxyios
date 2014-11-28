//
//  UploadRecipeVC.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/29/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "UploadRecipeVC.h"
#import "TPKeyboardAvoidingTableView.h"
#import "CustomCellQuey1.h"
#import "CustomCellUploadRecipe.h"
#import "CustomCellQuery2.h"
#import "UIImage+Resize.h"
#define TAG_GreenLineView 3778
#define TAG_TXTFLD_NAME 1001
#define TAG_TXTFLD_QUANTITY 1002
#define TAG_TXTFLD_COOKINGTIME_MIN 1003
#define TAG_TXTFLD_COOKINGTIME_MAX 1004
#define TAG_TXTFLD_PREPTIME 1005
#define TAG_TXTFLD_CATEGORY 1006
#define TAG_TXTFLD_TEMP 1007
#define TAG_TXTFLD_IMAGE 10022
#define TAG_TXTFLD_YTURL 1008
#define TAG_PICKER_VIEW 1252
#define TAG_TXTVW_INGRIDIENT 2220
#define TAG_TXTVW_HOWTOCOOK 2221
#define TAG_TXTFLD_FULLNAME 3000
#define TAG_TXTFLD_EMAILADDRESS 3001
#define TAG_TXTFLD_ContactNumber 3002
#define TAG_NEXT_BTN 3357
typedef enum
{
    UploadStateDish,
    UploadStateSteps,
    UploadStateMore
    
}UploadState;

@interface UploadRecipeVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIButton *dishBtn;
    UIButton *cookingStepsBtn;
    UIButton *moreBtn;
    TPKeyboardAvoidingTableView *tblVw;
    UploadState uploadState;
    NSMutableDictionary *dataDict;
    NSMutableArray *catArr ;
    NSString *error_str;
    NSString *imagepath;
}
@end

@implementation UploadRecipeVC
@synthesize isLeftBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    imagepath = @"";
    catArr = [NSMutableArray arrayWithArray:[[NSDictionary dictionaryWithContentsOfFile:STATIC_DATA_PLIST] objectForKey:@"Categories"]];
    NSDictionary *dict2;
    for (NSDictionary *dict in catArr) {
        if([[dict objectForKey:@"Cat_Id"] integerValue]==0)
          dict2=  dict;
    }
    if(dict2)
        [catArr removeObject:dict2];

    dataDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [[SharedFunction sharedInstance] setTitleViewForNavigationItem:self.navigationItem];
    if(isLeftBtn)
     [[SharedFunction sharedInstance] getLeftButtonForHeadertarget:self];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, 40)];
    [lineView setBackgroundColor:GREEN_COLOR];
    [self.view addSubview:lineView];
    UILabel *submitQueryLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, screenSize.width, 40)];
    [submitQueryLbl setTextColor:[UIColor whiteColor]];
    [submitQueryLbl setBackgroundColor:[UIColor clearColor]];
    [submitQueryLbl setText:LocStr(@"Upload Your Recipe")];
    [submitQueryLbl setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
    [self.view addSubview:submitQueryLbl];
    
    [self getTopSegmentView];
    
    tblVw = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 64+40+40, screenSize.width, View_Height.height-40-40) style:UITableViewStylePlain];
    [tblVw setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblVw setTableFooterView:[self getFooterView]];
    [tblVw setDataSource:self];
    [tblVw setDelegate:self];
    [self.view addSubview:tblVw];

    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UItableview delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (uploadState) {
        case UploadStateDish:
            return 8;
            break;
        
        case UploadStateSteps:
            return 2;
            break;
            
        case UploadStateMore:
            return 3;
            break;
            
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (uploadState) {
        case UploadStateDish:
        {
            if(indexPath.row==7)
                return 58+18;
            else
                return 58;
        }
            
            break;
            
        case UploadStateSteps:
            return 135;
            break;
            
        case UploadStateMore:
            return 58;
            break;
            
        default:
            break;
    }
    return 0;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (uploadState) {
        case UploadStateDish:
            cell = [self createDishCellForTableView:tableView cellForRowAtIndexPath:indexPath];
            break;
        case UploadStateSteps:
             cell = [self createStepsCellForTableView:tableView cellForRowAtIndexPath:indexPath];
            break;
        case UploadStateMore:
            cell = [self createMoreCellForTableView:tableView cellForRowAtIndexPath:indexPath];
            break;
            
        default:
            break;
    }
    return cell;
}

-(UITableViewCell *)createDishCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    static NSString *cellIdentifier2 = @"cellIdentifier2";
    static NSString *cellIdentifier3 = @"cellIdentifier3";
    
    switch (indexPath.row) {
        case 0:
        case 2:
        case 3:
        case 4:
        case 5:
        case 7:
        {
            CustomCellQuey1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(cell==nil)
            {
                cell = [[CustomCellQuey1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.txtFld setDelegate:self];
                [cell.txtFld setReturnKeyType:UIReturnKeyNext];
            }
            [self configureCell:cell ForRowAtIndexPath:indexPath];
            
            return cell;
        }
        case 1:
        {
            CustomCellUploadRecipe *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if(cell==nil)
            {
                cell = [[CustomCellUploadRecipe alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                 [cell.txtFld1 setDelegate:self];
                [cell.txtFld2 setDelegate:self];
            }
            [self configureDishCell2:cell ForRowAtIndexPath:indexPath];
            
            return cell;

        }
           
        case 6:
        {
            CustomCellUploadRecipe *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            if(cell==nil)
            {
                cell = [[CustomCellUploadRecipe alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.txtFld1 setDelegate:self];
                [cell.txtFld2 setDelegate:self];
                [cell.txtFld1 setFrame:CGRectMake(cell.txtFld1.frame.origin.x, cell.txtFld1.frame.origin.y, (screenSize.width-45)-85, cell.txtFld1.frame.size.height)];
                [cell.txtFld2 setHidden:YES];
                
                UIButton *browseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [browseBtn setBackgroundImage:[UIImage imageNamed:IMG_BROWSE_BTN] forState:UIControlStateNormal];
                [browseBtn setFrame:CGRectMake(CGRectGetMaxX(cell.txtFld1.frame)+15, cell.txtFld1.frame.origin.y, 85, cell.txtFld1.frame.size.height)];
                [browseBtn addTarget:self action:@selector(browseBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:browseBtn];
                
                [cell.titleLbl setText:LocStr(@"Image")];
                [cell.txtFld1 setTag:TAG_TXTFLD_IMAGE];
                [cell.txtFld1 setUserInteractionEnabled:NO];
              
                
            }
            if(NSSTRING_HAS_DATA(imagepath))
                [cell.txtFld1 setText:imagepath];
            else
                [cell.txtFld1 setText:@""];
            return cell;
        }

            
        default:
            break;
    }
    return nil;

}
-(void )configureCell:(CustomCellQuey1 *)cell ForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell.txtFld setText:@""];
    [cell.txtFld setReturnKeyType:UIReturnKeyNext];
    [cell.txtFld setUserInteractionEnabled:YES];
    [cell.txtFld setPlaceholder:@""];
    [cell.txtFld setInputView:nil];
    switch (indexPath.row) {
        case 0:
            [cell.titleLbl setText:LocStr(@"Name")];
            [cell.txtFld setTag:TAG_TXTFLD_NAME];
           [cell.txtFld setKeyboardType:UIKeyboardTypeDefault];
            if(HAS_DATA(dataDict, KEY_UP_dishName))
                [cell.txtFld setText:[dataDict objectForKey:KEY_UP_dishName]];
            break;
            
        case 4:
        {
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:LocStr(@"Quantity (Optional)")];
            
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MyriadPro_Regular size:14.0f] range:NSMakeRange(0, 8)];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MyriadPro_Light size:12.0f] range:NSMakeRange(9, [attString length]-9)];
            
            [attString addAttribute:NSForegroundColorAttributeName value:Dark_Gray_Color range:NSMakeRange(0, 8)];
            [attString addAttribute:NSForegroundColorAttributeName value:Gray_Color range:NSMakeRange(9, [attString length]-9)];
            
            [cell.titleLbl setAttributedText:attString];

            [cell.txtFld setTag:TAG_TXTFLD_QUANTITY];
            [cell.txtFld setKeyboardType:UIKeyboardTypeNumberPad];
            if(HAS_DATA(dataDict, KEY_UP_quantity))
                [cell.txtFld setText:[dataDict objectForKey:KEY_UP_quantity]];
        }
            break;
            
        case 2:
        {
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:LocStr(@"Preparation Time (in Minutes)")];
            
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MyriadPro_Regular size:14.0f] range:NSMakeRange(0, 16)];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MyriadPro_Light size:12.0f] range:NSMakeRange(16, [attString length]-16)];
            
            [attString addAttribute:NSForegroundColorAttributeName value:Dark_Gray_Color range:NSMakeRange(0, 8)];
            [attString addAttribute:NSForegroundColorAttributeName value:Gray_Color range:NSMakeRange(9, [attString length]-9)];
            
            [cell.titleLbl setAttributedText:attString];
            
            [cell.txtFld setTag:TAG_TXTFLD_PREPTIME];
            [cell.txtFld setKeyboardType:UIKeyboardTypeNumberPad];
            if(HAS_DATA(dataDict, KEY_UP_maxPrepTime))
                [cell.txtFld setText:[dataDict objectForKey:KEY_UP_maxPrepTime]];
        }
            break;
        case 3:
        {
            [cell.titleLbl setText:LocStr(@"Category")];
            [cell.txtFld setTag:TAG_TXTFLD_CATEGORY];
            if(HAS_DATA(dataDict, KEY_UP_category) && HAS_DATA(dataDict, KEY_UP_type))
            {
                NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    NSDictionary *dict = (NSDictionary *)evaluatedObject;
                    return ([[dict objectForKey:@"Cat_Id"] integerValue] == [[dataDict objectForKey:KEY_UP_category] integerValue] && [[dict objectForKey:@"Type"] integerValue] == [[dataDict objectForKey:KEY_UP_type] integerValue]);
                }];
                NSDictionary *dict = [[catArr filteredArrayUsingPredicate:pred] lastObject];
                if (dict) {
                    [cell.txtFld setText:[dict objectForKey:@"Title"]];
                }
                
            }
            [cell.txtFld setInputView:[self getPickerViewForCAtegory]];
        }
            break;
        
        case 5:
        {
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:LocStr(@"Temperature (in Celsius)")];
            
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MyriadPro_Regular size:14.0f] range:NSMakeRange(0, 11)];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MyriadPro_Light size:12.0f] range:NSMakeRange(11, [attString length]-11)];
            
            [attString addAttribute:NSForegroundColorAttributeName value:Dark_Gray_Color range:NSMakeRange(0,11)];
            [attString addAttribute:NSForegroundColorAttributeName value:Gray_Color range:NSMakeRange(11, [attString length]-11)];
            
            [cell.titleLbl setAttributedText:attString];
            [cell.txtFld setTag:TAG_TXTFLD_TEMP];
            [cell.txtFld setKeyboardType:UIKeyboardTypeDefault];
            if(HAS_DATA(dataDict, KEY_UP_temprature))
                [cell.txtFld setText:[dataDict objectForKey:KEY_UP_temprature]];
        }
            break;
            
        case 7:
        {
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:LocStr(@"Video Youtube URL (Optional)\n(http://www.youtube.com/embed/...)")];
            
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MyriadPro_Regular size:14.0f] range:NSMakeRange(0, 17)];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MyriadPro_Light size:12.0f] range:NSMakeRange(17, [attString length]-17)];
            
            [attString addAttribute:NSForegroundColorAttributeName value:Dark_Gray_Color range:NSMakeRange(0, 17)];
            [attString addAttribute:NSForegroundColorAttributeName value:Gray_Color range:NSMakeRange(17, [attString length]-17)];
            
            [cell.titleLbl setAttributedText:attString];
            [cell.txtFld setTag:TAG_TXTFLD_YTURL];
            [cell.txtFld setKeyboardType:UIKeyboardTypeDefault];
            if(HAS_DATA(dataDict, KEY_UP_youtubeVideo))
                [cell.txtFld setText:[dataDict objectForKey:KEY_UP_youtubeVideo]];
        }
            break;
            
        default:
            break;
    }
}
-(UIView *)getPickerViewForCAtegory
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 42, 0, 0)];
    [pickerView setTag:TAG_PICKER_VIEW];
    pickerView.delegate=self;
    pickerView.dataSource=self;
    
    [pickerView setShowsSelectionIndicator:YES];
    
    UIView *PickerBGView = [[UIView alloc] initWithFrame:CGRectMake(0, screenSize.height-(pickerView.frame.size.height+39), screenSize.width, pickerView.frame.size.height+42)];
    PickerBGView.backgroundColor=[UIColor colorWithRed:245/255.f green:241/255.f blue:242/255.f alpha:1.f];
    [PickerBGView addSubview:pickerView];
    
    UIView *bgVw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 42)];
    [bgVw setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [PickerBGView addSubview:bgVw];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(20.0, 6, 87, 30)];
    [doneButton setTitle:LocStr(@"Done") forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:16]];
    [doneButton setBackgroundColor:[UIColor whiteColor]];
    [doneButton.layer setCornerRadius:8];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(pickerDoneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bgVw addSubview:doneButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(205, 6, 87, 30)];
    [cancelButton setTitle:LocStr(@"Cancel") forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:16   ]];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    [cancelButton.layer setCornerRadius:8];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(pickerCancelBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bgVw addSubview:cancelButton];
    return PickerBGView;
    
    
}


-(void )configureDishCell2:(CustomCellUploadRecipe *)cell ForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell.txtFld1 setText:@""];
    [cell.txtFld2 setText:@""];
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:LocStr(@"Cooking Time (in Minutes)")];

        [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MyriadPro_Regular size:14.0f] range:NSMakeRange(0, 12)];
        [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MyriadPro_Light size:12.0f] range:NSMakeRange(12, [attString length]-12)];

        [attString addAttribute:NSForegroundColorAttributeName value:Dark_Gray_Color range:NSMakeRange(0, 12)];
        [attString addAttribute:NSForegroundColorAttributeName value:Gray_Color range:NSMakeRange(12, [attString length]-12)];

        [cell.titleLbl setAttributedText:attString];
        [cell.txtFld1 setPlaceholder:LocStr(@"Minimum")];
        [cell.txtFld1 setTag:TAG_TXTFLD_COOKINGTIME_MIN];
        [cell.txtFld1 setKeyboardType:UIKeyboardTypeNumberPad];
        if(HAS_DATA(dataDict, KEY_UP_minCookTime))
        [cell.txtFld1 setText:[dataDict objectForKey:KEY_UP_minCookTime]];

        [cell.txtFld2 setTag:TAG_TXTFLD_COOKINGTIME_MAX];
        [cell.txtFld2 setPlaceholder:@"Maximum"];
        [cell.txtFld2 setKeyboardType:UIKeyboardTypeNumberPad];
        if(HAS_DATA(dataDict, KEY_UP_maxCookTime))
        [cell.txtFld2 setText:[dataDict objectForKey:KEY_UP_maxCookTime]];

  }



-(UITableViewCell *)createStepsCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier4";
    
    CustomCellQuery2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell = [[CustomCellQuery2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.txtVw setDelegate:self];
        [self createInputAccessoryView:cell.txtVw];
    }
    [cell.txtVw setText:@""];
    switch (indexPath.row) {
        case 0:
            [cell.titleLbl setText:LocStr(@"Ingredients")];
            [cell.txtVw setTag:TAG_TXTVW_INGRIDIENT];
            if(HAS_DATA(dataDict, KEY_UP_ingredients))
                [cell.txtVw setText:[dataDict objectForKey:KEY_UP_ingredients]];
            break;
            
        case 1:
            [cell.titleLbl setText:LocStr(@"How To Cook")];
            [cell.txtVw setTag:TAG_TXTVW_HOWTOCOOK];
            if(HAS_DATA(dataDict, KEY_UP_howToUse))
                [cell.txtVw setText:[dataDict objectForKey:KEY_UP_howToUse]];
            break;
            
        default:
            break;
    }
    
    return cell;

}

-(UITableViewCell *)createMoreCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier7";
    
     CustomCellQuey1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell = [[CustomCellQuey1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.txtFld setDelegate:self];
        [cell.txtFld setReturnKeyType:UIReturnKeyNext];
    }
    [cell.txtFld setText:@""];
    switch (indexPath.row) {
        case 0:
            [cell.titleLbl setText:LocStr(@"Name")];
            [cell.txtFld setTag:TAG_TXTFLD_FULLNAME];
            [cell.txtFld setKeyboardType:UIKeyboardTypeDefault];
            if(HAS_DATA(dataDict, KEY_UP_fullName))
                [cell.txtFld setText:[dataDict objectForKey:KEY_UP_fullName]];
            break;
            
        case 1:
            [cell.titleLbl setText:LocStr(@"Email Address")];
            [cell.txtFld setTag:TAG_TXTFLD_EMAILADDRESS];
            [cell.txtFld setKeyboardType:UIKeyboardTypeEmailAddress];
            if(HAS_DATA(dataDict, KEY_UP_email))
                [cell.txtFld setText:[dataDict objectForKey:KEY_UP_email]];
            break;
            
        case 2:
        {
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:LocStr(@"Contact Number (Optional)")];
            
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MyriadPro_Regular size:14.0f] range:NSMakeRange(0, 14)];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MyriadPro_Light size:12.0f] range:NSMakeRange(14, [attString length]-14)];
            
            [attString addAttribute:NSForegroundColorAttributeName value:Dark_Gray_Color range:NSMakeRange(0,14)];
            [attString addAttribute:NSForegroundColorAttributeName value:Gray_Color range:NSMakeRange(14, [attString length]-14)];
            
            [cell.titleLbl setAttributedText:attString];
            [cell.txtFld setTag:TAG_TXTFLD_ContactNumber];
            [cell.txtFld setKeyboardType:UIKeyboardTypePhonePad];
            if(HAS_DATA(dataDict, KEY_UP_number))
                [cell.txtFld setText:[dataDict objectForKey:KEY_UP_number]];
        }
            break;
            
        default:
            break;
    }

    
    return cell;

}

-(void)createInputAccessoryView:(UITextView *)txtView
{
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 44)];
    keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTyping:)];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:  flexSpace, doneButton, nil] animated:NO];
    [txtView setInputAccessoryView:keyboardToolbar];
    
}
-(void)doneTyping:(id)sender
{
    [self.view resignFirstResonder];
}

#pragma mark -UITextViewDelegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if([str length]>500)
        return NO;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    switch (textView.tag) {
        case TAG_TXTVW_INGRIDIENT:
            [dataDict setValue:[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:KEY_UP_ingredients];
            break;
        case TAG_TXTVW_HOWTOCOOK:
             [dataDict setValue:[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:KEY_UP_howToUse];
            
        default:
            break;
    }
    
    
}


#pragma mark - UITextFieldDelegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    switch (textField.tag) {
        case TAG_TXTFLD_NAME:
            [dataDict setValue:str forKey:KEY_UP_dishName];
            break;
        case TAG_TXTFLD_QUANTITY:
            [dataDict setValue:str forKey:KEY_UP_quantity];
            break;
        case TAG_TXTFLD_COOKINGTIME_MIN:
            [dataDict setValue:str forKey:KEY_UP_minCookTime];
            break;
        case TAG_TXTFLD_COOKINGTIME_MAX:
            [dataDict setValue:str forKey:KEY_UP_maxCookTime];
            break;
        case TAG_TXTFLD_PREPTIME:
            [dataDict setValue:str forKey:KEY_UP_maxPrepTime];
            break;
        case TAG_TXTFLD_CATEGORY:
        {
            
        }
            break;
        case TAG_TXTFLD_TEMP:
            [dataDict setObject:str forKey:KEY_UP_temprature];
            break;
        case TAG_TXTFLD_IMAGE:
        {
            
        }
            break;
            
        case TAG_TXTFLD_YTURL:
            [dataDict setObject:str forKey:KEY_UP_youtubeVideo];
            break;
        case TAG_TXTFLD_FULLNAME:
            [dataDict setObject:str forKey:KEY_UP_fullName];
            break;
        case TAG_TXTFLD_EMAILADDRESS:
            [dataDict setObject:str forKey:KEY_UP_email];
            break;
        case TAG_TXTFLD_ContactNumber:
            [dataDict setObject:str forKey:KEY_UP_number];
            
        default:
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    UITextField *next = (UITextField *)[tblVw viewWithTag:textField.tag+1];
    if(next)
        [next becomeFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        case TAG_TXTFLD_NAME:
            if([str length]>40)
                return NO;
            break;
        case TAG_TXTFLD_QUANTITY:
            if([str length]>5)
                return NO;
            break;
        case TAG_TXTFLD_COOKINGTIME_MIN:
            if([str length]>5)
                return NO;
            break;
        case TAG_TXTFLD_COOKINGTIME_MAX:
            if([str length]>5)
                return NO;
            break;

        case TAG_TXTFLD_PREPTIME:
            if([str length]>5)
                return NO;
            break;

        case TAG_TXTFLD_TEMP:
            if([str length]>5)
                return NO;
            break;

        case TAG_TXTFLD_YTURL:
            if([str length]>100)
                return NO;
            break;

        case TAG_TXTFLD_FULLNAME:
            if([str length]>40)
                return NO;
            break;

        case TAG_TXTFLD_EMAILADDRESS:
            if([str length]>100)
                return NO;
            break;

        case TAG_TXTFLD_ContactNumber:
            if([str length]>10)
                return NO;
            break;

        default:
            break;
    }
    return YES;
}



#pragma mark - UIPickerView delegate methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return catArr.count;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
                NSDictionary *selecteDict = (NSDictionary *)[catArr objectAtIndex:(row)];
            NSString *str = [selecteDict objectForKey:@"Title"];
            return str;
}



#pragma mark - Methods
-(UIView *)getFooterView
{
    UIView *footerVw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 65)];
    [footerVw setBackgroundColor:[UIColor clearColor]];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(screenSize.width/2-71, 15, 142, 35)];
    [sendButton setTitle:LocStr(@"Next") forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(nextBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTag:TAG_NEXT_BTN];
    [sendButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
    [sendButton.layer setBorderWidth:0.5];
    [sendButton.layer setBorderColor:GREEN_COLOR.CGColor];
    [footerVw addSubview:sendButton];
    
    return footerVw;
}

-(void)leftBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getTopSegmentView
{
    dishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dishBtn setTitle:LocStr(@"Dish") forState:UIControlStateNormal];
    [dishBtn setTitleColor:Dark_Gray_Color forState:UIControlStateNormal];
    [dishBtn setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    [dishBtn setFrame:CGRectMake(0, 64+40, screenSize.width/3, 40)];
    [dishBtn.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
    [dishBtn addTarget:self action:@selector(dishBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [dishBtn setSelected:YES];
    [self.view addSubview:dishBtn];
    CGSize greenViewSize = [dishBtn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:dishBtn.titleLabel.font, nil] forKeys:[NSArray arrayWithObjects:NSFontAttributeName, nil]]];
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(dishBtn.frame.size.width/2-(greenViewSize.width+8)/2, dishBtn.frame.size.height-4, greenViewSize.width+8, 3)];
    [greenView setBackgroundColor:GREEN_COLOR];
    [greenView setTag:TAG_GreenLineView];
    [greenView setHidden:NO];
    [dishBtn addSubview:greenView];
    
    cookingStepsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cookingStepsBtn setTitle:LocStr(@"Cooking Steps") forState:UIControlStateNormal];
    [cookingStepsBtn setTitleColor:Dark_Gray_Color forState:UIControlStateNormal];
    [cookingStepsBtn setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    [cookingStepsBtn addTarget:self action:@selector(cookingStepsBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cookingStepsBtn.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
    [cookingStepsBtn setFrame:CGRectMake(CGRectGetMaxX(dishBtn.frame), 64+40, screenSize.width/3, 40)];
    [self.view addSubview:cookingStepsBtn];
    CGSize greenViewSize2 = [cookingStepsBtn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cookingStepsBtn.titleLabel.font, nil] forKeys:[NSArray arrayWithObjects:NSFontAttributeName, nil]]];
    UIView *greenView2 = [[UIView alloc] initWithFrame:CGRectMake(cookingStepsBtn.frame.size.width/2-(greenViewSize2.width+8)/2, cookingStepsBtn.frame.size.height-4, greenViewSize2.width+8, 3)];
    [greenView2 setBackgroundColor:GREEN_COLOR];
    [greenView2 setHidden:YES];
    [greenView2 setTag:TAG_GreenLineView];
    [cookingStepsBtn addSubview:greenView2];
    
    
    moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setTitle:LocStr(@"More") forState:UIControlStateNormal];
    [moreBtn setTitleColor:Dark_Gray_Color forState:UIControlStateNormal];
    [moreBtn setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    [moreBtn addTarget:self action:@selector(moreBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
    [moreBtn setFrame:CGRectMake(CGRectGetMaxX(cookingStepsBtn.frame), 64+40, screenSize.width/3, 40)];
    [self.view addSubview:moreBtn];
    
    CGSize greenViewSize3 = [moreBtn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:moreBtn.titleLabel.font, nil] forKeys:[NSArray arrayWithObjects:NSFontAttributeName, nil]]];
    UIView *greenView3 = [[UIView alloc] initWithFrame:CGRectMake(moreBtn.frame.size.width/2-(greenViewSize3.width+8)/2, moreBtn.frame.size.height-4, greenViewSize3.width+8, 3)];
    [greenView3 setBackgroundColor:GREEN_COLOR];
    [greenView3 setHidden:YES];
    [greenView3 setTag:TAG_GreenLineView];
    [moreBtn addSubview:greenView3];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+39+40, screenSize.width, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:204/255.f green:222/255.f blue:199.f alpha:1.f]];
    [self.view addSubview:lineView];
}

-(void)dishBtnTapped:(id)sender
{
    [dishBtn setSelected:YES];
    [cookingStepsBtn setSelected:NO];
    [moreBtn setSelected:NO];
    UIView *grenView1 = [dishBtn viewWithTag:TAG_GreenLineView];
    UIView *greenView2 = [cookingStepsBtn viewWithTag:TAG_GreenLineView];
    UIView *greenView3 = [moreBtn viewWithTag:TAG_GreenLineView];
    
    [grenView1 setHidden:NO];
    [greenView2 setHidden:YES];
    [greenView3 setHidden:YES];
    UIButton *btn = (UIButton *)[[tblVw tableFooterView] viewWithTag:TAG_NEXT_BTN];
    [btn setTitle:LocStr(@"Next") forState:UIControlStateNormal];
    [self.view resignFirstResonder];
    uploadState = UploadStateDish;
    [tblVw reloadData];
}

-(void)cookingStepsBtnTapped:(id)sender
{
  
    
    [self.view resignFirstResonder];
    if([self validateDish])
    {
        uploadState = UploadStateSteps;
        [dishBtn setSelected:NO];
        [cookingStepsBtn setSelected:YES];
        [moreBtn setSelected:NO];
        UIView *grenView1 = [dishBtn viewWithTag:TAG_GreenLineView];
        UIView *greenView2 = [cookingStepsBtn viewWithTag:TAG_GreenLineView];
        UIView *greenView3 = [moreBtn viewWithTag:TAG_GreenLineView];
        
        [grenView1 setHidden:YES];
        [greenView2 setHidden:NO];
        [greenView3 setHidden:YES];
        UIButton *btn = (UIButton *)[[tblVw tableFooterView] viewWithTag:TAG_NEXT_BTN];
        [btn setTitle:LocStr(@"Next") forState:UIControlStateNormal];
        [tblVw reloadData];
    }
    else
        [self showAlert];
}

-(void)moreBtnTapped:(id)sender
{
       [self.view resignFirstResonder];
    if([self validateDish])
    {
        if(![self validateCookingSteps])
        {
            [self showAlert];
            [self cookingStepsBtnTapped:nil];
            return;
        }
        [dishBtn setSelected:NO];
        [cookingStepsBtn setSelected:NO];
        [moreBtn setSelected:YES];
        UIView *grenView1 = [dishBtn viewWithTag:TAG_GreenLineView];
        UIView *greenView2 = [cookingStepsBtn viewWithTag:TAG_GreenLineView];
        UIView *greenView3 = [moreBtn viewWithTag:TAG_GreenLineView];
        
        [grenView1 setHidden:YES];
        [greenView2 setHidden:YES];
        [greenView3 setHidden:NO];
        
        UIButton *btn = (UIButton *)[[tblVw tableFooterView] viewWithTag:TAG_NEXT_BTN];
        [btn setTitle:LocStr(@"Submit") forState:UIControlStateNormal];
        uploadState = UploadStateMore;
        [tblVw reloadData];
    }
    else
        [self showAlert];
}
-(void)nextBtnTapped:(id)sender
{
    switch (uploadState) {
        case UploadStateDish:
                [self cookingStepsBtnTapped:nil];
            break;
            
        case UploadStateSteps:
                [self moreBtnTapped:nil];
            break;
            
        case UploadStateMore:
        {
            [self.view resignFirstResonder];
            if([self validateMore])
            {
                [APP_DELEGATE ShowProcessingView];
                
                [[AFAPIClient sharedClient] postPath:URL_UploadRecipe parameters:dataDict success:^(AFHTTPRequestOperation *operation, id responseObject){
                    [APP_DELEGATE HideProcessingView];
                    NSDictionary *dict = (NSDictionary *)responseObject;
                    if([responseObject isKindOfClass:[NSDictionary class]])
                    {
                        if(HAS_DATA(dict, KEY_ErrorCode) && ![[dict objectForKey:KEY_ErrorCode] boolValue])
                        {
                            [dataDict removeAllObjects];
                            imagepath = @"";
                            [self dishBtnTapped:nil];
                            [[SharedFunction sharedInstance] showAlertViewWithMeg:LocStr(@"Thank you for submitting your recipe. Your recipe will be going through admin moderation process.")];
                            
                            
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
            else
                [self showAlert];

        }
            break;
            
        default:
            break;
    }

}

-(void)pickerDoneButtonTapped:(id)sender
{
    UIView *view = [[sender superview] superview];
    UIPickerView *picker = (UIPickerView *)[view viewWithTag:TAG_PICKER_VIEW];
    NSInteger selectedRow = [picker selectedRowInComponent:0];
    NSMutableDictionary *MyDict = (NSMutableDictionary *)[catArr objectAtIndex:selectedRow];
    
    [dataDict setObject:[MyDict objectForKey:@"Cat_Id"] forKey:KEY_UP_category];
    [dataDict setObject:[MyDict objectForKey:@"Type"] forKey:KEY_UP_type];
        
        
    [tblVw reloadData];
    [self.view resignFirstResonder];
}

-(void)pickerCancelBtnTapped:(id)sender
{
    [self.view resignFirstResonder];
}

-(void)browseBtnTapped:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
  //  imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:imagePicker animated:YES completion:^{
        
    }];

}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate Methods



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(image.size.width>1600)
    {
        CGFloat aspectFactor = image.size.width/1600;
        image = [image resizedImage:CGSizeMake(image.size.width/aspectFactor, image.size.height/aspectFactor) interpolationQuality:kCGInterpolationDefault];
    }
    NSData* imageData = UIImageJPEGRepresentation( image, 1.0);
    NSString *base64String = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [dataDict setObject:base64String forKey:KEY_UP_image];
    imagepath = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
    //NSString* filePath = [[DOC_DIR stringByAppendingPathComponent:@"Self"] stringByAppendingString:@"Self.png"];
    
    //[imageData writeToFile:FILE_PATH atomically:YES];
    
    //[self performSelectorOnMainThread:@selector(refreshView:) withObject:image waitUntilDone:NO];
    [picker  dismissViewControllerAnimated:YES completion:^{
    }];
    [tblVw reloadData];
    //[profileTableView reloadData];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker  dismissViewControllerAnimated:YES completion:^{
    }];
    
}


#pragma mark - validation methods
-(BOOL)validateDish
{
    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_dishName]))
    {
        error_str = LocStr(@"Please Enter Dish Name");
        return false;
    }
    
     if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_maxPrepTime]))
    {
        error_str = LocStr(@"Please Enter Preparation Time");
        return false;
    }
    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_maxPrepTime]))
    {
        error_str = LocStr(@"Please Enter Preparation Time");
        return false;
    }
    if(!HAS_DATA(dataDict, KEY_UP_category))
    {
        error_str = LocStr(@"Please Select Category");
        return false;
    }
    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_minCookTime]))
    {
        error_str = LocStr(@"Please Enter Minimum Cooking Time");
        return false;
    }
    
    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_maxCookTime]))
    {
        error_str = LocStr(@"Please Enter Maximum Cooking Time");
        return false;
    }
    if([[dataDict objectForKey:KEY_UP_minCookTime] floatValue]>[[dataDict objectForKey:KEY_UP_maxCookTime] integerValue])
    {
        error_str = LocStr(@"Minimum Cooking Time should Be Lesser than Maximum Cooking Time");
        return false;
    }

    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_temprature]))
    {
        error_str = LocStr(@"Please Select Temperature");
        return false;
    }
    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_image]))
    {
        error_str = LocStr(@"Please Select Recipe Image");
        return false;
    }
    if(NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_youtubeVideo]))
    {
        NSString *emailRegex = @"http://www.youtube.com/embed/[a-zA-Z0-9_-]{3,}$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[cd] %@", emailRegex];
        
        if(![emailTest evaluateWithObject:[dataDict objectForKey:KEY_UP_youtubeVideo]])
        {
            error_str = LocStr(@"Please Enter Valid Youtube URL");
            return NO;
        }


    }
    
    return TRUE;
}

-(BOOL)validateCookingSteps
{
    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_ingredients]))
    {
        error_str = LocStr(@"Please Enter Ingredients");
        return false;
    }
    
    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_howToUse]))
    {
        error_str = LocStr(@"Please Enter Steps To Cook");
        return false;
    }
    return TRUE;
}

-(BOOL)validateMore
{
    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_fullName]))
    {
        error_str = @"Please Enter Your Name";
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]{2,24}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_email]))
    {
        error_str = @"Please Enter Your Email Address";
        return NO;
    }
    if(![emailTest evaluateWithObject:[dataDict objectForKey:KEY_UP_email]])
    {
        error_str = LocStr(@"Please Enter Valid Email Address");
        return NO;
    }
    if(NSSTRING_HAS_DATA([dataDict objectForKey:KEY_UP_number]))
    {
        NSString *mobNoRegex=@"^\\d{10,10}$";
        NSPredicate *mobNoTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobNoRegex];
        BOOL isValidPhnNo=[mobNoTest evaluateWithObject:[dataDict objectForKey:KEY_UP_number]];
        if((!isValidPhnNo))
        {
            error_str = LocStr(@"Please Enter Valid Contact Number");
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

-(void)showAlert
{
    [[SharedFunction sharedInstance] showAlertViewWithMeg:error_str];
}
@end
