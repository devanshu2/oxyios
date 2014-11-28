//
//  SendQueryVC.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/24/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "SendQueryVC.h"
#import "CustomCellQuey1.h"
#import "TPKeyboardAvoidingTableView.h"
#import "CustomCellQuery2.h"
#import "NSObject+SBJSON.h"
#define TAG_TXTFLD_NAME 1001
#define TAG_TXTFLD_EMAILADDRESS 1002
#define TAG_TXTFLD_CONTACTNUMBER 1003
#define TAG_TXTVW_MESSAGE 1004

@interface SendQueryVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    TPKeyboardAvoidingTableView *tblVw;
    NSMutableDictionary *dataDict;
    NSString *errorMessage;
}

@end

@implementation SendQueryVC
@synthesize needsBackButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    if(needsBackButton)
     [[SharedFunction sharedInstance] getLeftButtonForHeadertarget:self];
    [[SharedFunction sharedInstance] setTitleViewForNavigationItem:self.navigationItem];
    dataDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, 40)];
    [lineView setBackgroundColor:GREEN_COLOR];
    [self.view addSubview:lineView];
    UILabel *submitQueryLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, screenSize.width, 40)];
    [submitQueryLbl setTextColor:[UIColor whiteColor]];
    [submitQueryLbl setBackgroundColor:[UIColor clearColor]];
    [submitQueryLbl setText:LocStr(@"Submit Your Query")];
    [submitQueryLbl setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
    [self.view addSubview:submitQueryLbl];
    
   
    
    tblVw = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 64+40, screenSize.width, View_Height.height-40) style:UITableViewStylePlain];
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
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
        return 135;
    return 58;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    static NSString *cellIdentifier2 = @"cellIdentifier2";
    
    switch (indexPath.row) {
        case 1:
        case 2:
        case 3:
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
            
        case 0:
        {
            CustomCellQuery2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if(cell==nil)
            {
                cell = [[CustomCellQuery2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.txtVw setDelegate:self];
            }
            [self createInputAccessoryView:cell.txtVw];
            [cell.titleLbl setText:LocStr(@"Message")];
            [cell.txtVw setTag:TAG_TXTVW_MESSAGE];
            if(HAS_DATA(dataDict, KEY_Message))
                [cell.txtVw setText:[dataDict objectForKey:KEY_Message]];
            else
                [cell.txtVw setText:@""];
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
    switch (indexPath.row) {
        case 1:
            [cell.titleLbl setText:LocStr(@"Name")];
            [cell.txtFld setTag:TAG_TXTFLD_NAME];
            [cell.txtFld setKeyboardType:UIKeyboardTypeDefault];
            if(HAS_DATA(dataDict, KEY_Name))
                [cell.txtFld setText:[dataDict objectForKey:KEY_Name]];
            break;
            
        case 2:
            [cell.titleLbl setText:LocStr(@"Email Address")];
            [cell.txtFld setTag:TAG_TXTFLD_EMAILADDRESS];
            [cell.txtFld setKeyboardType:UIKeyboardTypeEmailAddress];
            if(HAS_DATA(dataDict, KEY_EmailAddress))
                [cell.txtFld setText:[dataDict objectForKey:KEY_EmailAddress]];
            break;
            
        case 3:
            [cell.titleLbl setText:LocStr(@"Contact Number")];
            [cell.txtFld setTag:TAG_TXTFLD_CONTACTNUMBER];
            [cell.txtFld setKeyboardType:UIKeyboardTypePhonePad];
            if(HAS_DATA(dataDict, KEY_ContactNumber))
                [cell.txtFld setText:[dataDict objectForKey:KEY_ContactNumber]];
            break;
            
        default:
            break;
    }
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


-(UIView *)getFooterView
{
    UIView *footerVw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 65)];
    [footerVw setBackgroundColor:[UIColor clearColor]];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(screenSize.width/2-71, 15, 142, 35)];
    [sendButton setTitle:LocStr(@"Send") forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
    [sendButton.layer setBorderWidth:0.5];
    [sendButton.layer setBorderColor:GREEN_COLOR.CGColor];
    [footerVw addSubview:sendButton];
    
    return footerVw;
}

-(void)doneTyping:(id )sender
{
    [self.view resignFirstResonder];
  //  UITextView *txtVw = (UITextView *)[tblVw viewWithTag:TAG_TXTVW_MESSAGE];
   // [dataDict setValue:[txtVw.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:KEY_Message];
   // [txtVw resignFirstResponder];
}
-(void)leftBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendButtonTapped:(id)sender
{
   
     UITextView *txtVw = (UITextView *)[tblVw viewWithTag:TAG_TXTVW_MESSAGE];
    if(txtVw && [txtVw isFirstResponder])
        [self doneTyping:txtVw];
     [self.view resignFirstResonder];
    if([self validate])
    {
        [APP_DELEGATE ShowProcessingView];
        NSMutableDictionary *reqDict = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[dataDict objectForKey:KEY_Name], [dataDict objectForKey:KEY_EmailAddress], [dataDict objectForKey:KEY_Message], nil] forKeys:[NSArray arrayWithObjects:KEY_Name, KEY_EmailAddress, KEY_Message, nil]];
        if(HAS_DATA(dataDict, KEY_ContactNumber))
            [reqDict setObject:[dataDict objectForKey:KEY_ContactNumber] forKey:KEY_ContactNumber];
        [self parseText];
        
        [[AFAPIClient sharedClient] postPath:URL_sendFaqEmail parameters:reqDict success:^(AFHTTPRequestOperation *operation, id responseObject){
            [APP_DELEGATE HideProcessingView];
            NSDictionary *dict = (NSDictionary *)responseObject;
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                if(HAS_DATA(dict, KEY_ErrorCode) && ![[dict objectForKey:KEY_ErrorCode] boolValue])
                {
                        [dataDict removeAllObjects];
                        [tblVw reloadData];
                        [[SharedFunction sharedInstance] showAlertViewWithMeg:LocStr(@"Your Message Has Been Posted Successfully")];
                    
                    
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

-(void)parseText {
   NSString *appendedArticleText = @"";
    NSString *articleText = [dataDict objectForKey:KEY_Message];
    NSString *temp = nil;
    NSScanner *theScanner = [NSScanner scannerWithString:articleText];
    int count = 0;
    
    while (![theScanner isAtEnd]) {
        count = count +1;
        NSString *htmlTag = [NSString stringWithFormat:@"<p class=\"pt\"data-seq=\"%d\">",count];
        [theScanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&temp];
        
        NSString *taggedArticleText = [htmlTag stringByAppendingString:temp];
        NSString *formattedText = [taggedArticleText stringByAppendingString:@"</p>"];
        appendedArticleText = [appendedArticleText stringByAppendingString:formattedText];
    }
    
    NSLog(@"%@",appendedArticleText);
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [[UIView alloc] initWithFrame:CGRectZero];
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 65;
//}

#pragma mark - UITextFieldDelegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    switch (textField.tag) {
        case TAG_TXTFLD_NAME:
            [dataDict setValue:str forKey:KEY_Name];
            break;
        case TAG_TXTFLD_EMAILADDRESS:
            [dataDict setValue:str forKey:KEY_EmailAddress];
            break;
        case TAG_TXTFLD_CONTACTNUMBER:
            [dataDict setValue:str forKey:KEY_ContactNumber];
            break;
        
            
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
            if([str length]>20)
                return NO;
            break;
        case TAG_TXTFLD_EMAILADDRESS:
            if([str length]>50)
                return NO;
            break;
        case TAG_TXTFLD_CONTACTNUMBER:
            if([str length]>10)
                return NO;
            break;
        default:
            break;
    }
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
     NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if([str length]>200)
        return NO;
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [dataDict setValue:[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:KEY_Message];
}

#pragma mark -Validation methods

-(BOOL)validate
{
     if (![self isValidMessage])
    {
        [self showAlertView];
        return NO;
    }
    else if(![self isValidName])
    {
        [self showAlertView];
        return NO;
    }
    else if(![self isValidEmailAddress])
    {
        [self showAlertView];
        return NO;
    }
    
    else if(![self isValidMobileNo])
    {
        [self showAlertView];
        return NO;
    }
   
    else{}
    return YES;
}
-(void)showAlertView
{
        [[SharedFunction sharedInstance] showAlertViewWithMeg:errorMessage];
}
-(BOOL)isValidName
{
    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_Name]))
    {
        errorMessage = @"Please Enter Your Name";
        return NO;
    }
    return YES;
}


-(BOOL)isValidEmailAddress
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]{2,24}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_EmailAddress]))
    {
        errorMessage = @"Please Enter Your Email Address";
        return NO;
    }
    if(![emailTest evaluateWithObject:[dataDict objectForKey:KEY_EmailAddress]])
    {
        errorMessage = LocStr(@"Please Enter Valid Email Address");
        return NO;
    }
    return YES;
}

-(BOOL)isValidMobileNo
{
    if(NSSTRING_HAS_DATA([dataDict objectForKey:KEY_ContactNumber]))
    {
        NSString *mobNoRegex=@"^\\d{10,10}$";
        NSPredicate *mobNoTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobNoRegex];
        BOOL isValidPhnNo=[mobNoTest evaluateWithObject:[dataDict objectForKey:KEY_ContactNumber]];
        if((!isValidPhnNo))
        {
            errorMessage = LocStr(@"Please Enter Valid Contact Number");
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
    
}
-(BOOL)isValidMessage
{
    if(!NSSTRING_HAS_DATA([dataDict objectForKey:KEY_Message]))
    {
        errorMessage = @"Please Enter Message";
        return NO;
    }
    return YES;
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
