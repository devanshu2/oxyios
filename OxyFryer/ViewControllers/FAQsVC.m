//
//  FAQsVC.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/24/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "FAQsVC.h"
#import "CustomCellFAQ.h"
#import "FAQBL.h"
#import "ModelFAQ.h"
#import "SendQueryVC.h"
#import "ReaderViewController.h"
#import "ReaderDocument.h"
#define TAG_GreenLineView 3777

@interface FAQsVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ReaderViewControllerDelegate>
{
    NSInteger selectedRow;
    UITableView *tableVw;
    NSMutableArray *alldataArray;
    NSMutableArray *filteredArr;
    UIButton *productBtn;
    UIButton *foodButton;
    UITextField* searchTextFld;
    
    
}

@end

@implementation FAQsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SharedFunction sharedInstance] setTitleViewForNavigationItem:self.navigationItem];
    [[SharedFunction sharedInstance] getLeftButtonForHeaderWithFrame:CGRectMake(0, 0, 16, 16) target:self backgroundImageNormal:[UIImage imageNamed:IMG_phone_icon] hoverImage:[UIImage imageNamed:IMG_phone_icon]];
    [self getRightBarButtons];
    // Do any additional setup after loading the view from its nib.
    selectedRow=-1;
    alldataArray = [[NSMutableArray alloc] initWithCapacity:0];
    filteredArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    UIView *vw = [[UIView alloc] init];
    [self.view addSubview:vw];
    tableVw = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, screenSize.width, View_Height.height-40) ];
  //  [tableVw setTableFooterView:[self getTableFooterView]];
    tableVw.tableFooterView.hidden = TRUE;
    [tableVw setDataSource:self];
    [tableVw setDelegate:self];
    [tableVw setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableVw];
    [self getTopSegmentView];
   
}
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationLandscapeLeft;
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self getDataForFAQ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableviewCell delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelFAQ *modelFAQ = [filteredArr objectAtIndex:indexPath.row];
    CGSize questionLblSize = CGSizeZero;
    CGSize answerLabelSize = CGSizeZero;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        CGRect questionlblRect = [modelFAQ.faq_question boundingRectWithSize:CGSizeMake(screenSize.width-30, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:MyriadPro_Regular size:14] forKey:NSFontAttributeName] context:nil];
        questionLblSize = questionlblRect.size;
        CGRect answerLblRect = [modelFAQ.faq_answer boundingRectWithSize:CGSizeMake(screenSize.width-30, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:MyriadPro_Regular size:14] forKey:NSFontAttributeName] context:nil];
        answerLabelSize = answerLblRect.size;
    }
//    else
//    {
//        questionLblSize = [modelFAQ.faq_question sizeWithFont:[UIFont fontWithName:MyriadPro_Regular size:10] constrainedToSize:CGSizeMake(screenSize.width-30, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//        answerLabelSize = [modelFAQ.faq_answer sizeWithFont:[UIFont fontWithName:MyriadPro_Regular size:10] constrainedToSize:CGSizeMake(screenSize.width-30, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//    }
    
    if(selectedRow==indexPath.row)
    return 10+questionLblSize.height+15+answerLabelSize.height+20;
    else
        return 10+questionLblSize.height+30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelFAQ *modelFAQ = [filteredArr objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"cellIdentifier";
    CustomCellFAQ *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell = [[CustomCellFAQ alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell.questionLbl setText:modelFAQ.faq_question];
    [cell.answerLbl setText:modelFAQ.faq_answer];
    [cell.expandBtn setTag:indexPath.row];
    [cell.expandBtn addTarget:self action:@selector(expandBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.answerLbl setHidden:!(indexPath.row==selectedRow)];
    if(indexPath.row==selectedRow)
    {
        [cell.questionLbl setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
        [cell.questionLbl setTextColor:GREEN_COLOR];
    }
    else
    {
        [cell.questionLbl setTextColor:Dark_Gray_Color];
        [cell.questionLbl setFont:[UIFont fontWithName:MyriadPro_Bold size:14]];
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 10)];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}



-(UIView *)getTableFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 35+15)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    UIButton *sendQueryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendQueryBtn setTitle:LocStr(@"Send Query") forState:UIControlStateNormal];
    [sendQueryBtn.layer setBorderWidth:1];
    [sendQueryBtn.layer setBorderColor:GREEN_COLOR.CGColor];
    [sendQueryBtn setFrame:CGRectMake(screenSize.width/2-72, 0, 144, 35)];
    [sendQueryBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [sendQueryBtn addTarget:self action:@selector(sendQueryBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [sendQueryBtn.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
    [footerView addSubview:sendQueryBtn];
    
    return footerView;
}

#pragma mark - Methods
-(void)rightBtnTapped:(id)sender
{
// //   [rightBtn setBackgroundColor:[UIColor clearColor]];
//    UIView *searchVw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
//    [searchVw setBackgroundColor:[UIColor clearColor]];
//    
//     searchTextFld =  [[UITextField alloc] init];
//
//    searchTextFld.frame = CGRectMake(0, 9.5, 150, 25);
//    [searchTextFld setBackgroundColor:[UIColor clearColor]];
//    [searchTextFld.layer setBorderWidth:1];
//    [searchTextFld.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [searchTextFld.layer setCornerRadius:8];
//    [searchTextFld setDelegate:self];
//    [searchVw addSubview:searchTextFld];
//    [searchTextFld setTextColor:Gray_Color];
//    [searchTextFld setFont:[UIFont fontWithName:MyriadPro_Regular size:12]];
//    
//    UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [crossBtn setImage:[UIImage imageNamed:IMG_ic_green_cross] forState:UIControlStateNormal];
//    [crossBtn setFrame:CGRectMake(0, 0, 20, 25)];
//    [crossBtn addTarget:self action:@selector(crossBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [searchTextFld setRightView:crossBtn];
//    
//    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
//    [searchTextFld setLeftView:leftView];
//    [searchTextFld setLeftViewMode:UITextFieldViewModeAlways];
//    
//    [searchTextFld setRightViewMode:UITextFieldViewModeAlways];
//    
//  //  [rightBtn setImage:backgroundImage forState:UIControlStateNormal];
//   // [rightBtn setImage:hoverImage forState:UIControlStateHighlighted];
//   // [rightBtn addTarget:target action:@selector(rightBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:searchVw];
//    self.navigationItem.rightBarButtonItem = anotherButton;
    
    NSString* fontPath = [DOC_DIR stringByAppendingString:@"/myPdfFile.pdf"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fontPath])
    {
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"UGB_ASTER OXY FRYER_WITH NEW TAG LINE" ofType:@"pdf"] toPath:fontPath error:nil];
    }

    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:fontPath password:nil];
    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    readerViewController.delegate = self;
    readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:readerViewController animated:YES completion:^{
        
    }];
}
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)crossBtnTapped:(id)sender
{
    [filteredArr setArray:alldataArray];
    [searchTextFld resignFirstResponder];
//    [[SharedFunction sharedInstance] getRightButtonForHeaderWithFrame:CGRectMake(0, 0, 18.5, 18.5) target:self backgroundImageNormal:[UIImage imageNamed:IMG_Search_Icon] hoverImage:[UIImage imageNamed:IMG_Search_Icon]];
    [tableVw reloadData];
        tableVw.tableFooterView.hidden = FALSE;

}

-(void)sendQueryBtnTapped:(id)sender
{
    SendQueryVC *sendQueryVCObj = [[SendQueryVC alloc] initWithNibName:@"SendQueryVC" bundle:nil];
    sendQueryVCObj.needsBackButton = YES;
    [self.navigationController pushViewController:sendQueryVCObj animated:YES];
}

-(void)expandBtnTapped:(UIButton *)sender
{
    if(sender.tag==selectedRow)
        selectedRow=-1;
    else
      selectedRow = sender.tag;
    [tableVw reloadData];
        tableVw.tableFooterView.hidden = FALSE;
}

-(void)getDataForFAQ
{
    [APP_DELEGATE ShowProcessingView];
    [[AFAPIClient sharedClient] getPath:URL_getFAQListing parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [APP_DELEGATE HideProcessingView];
        NSDictionary *dict = (NSDictionary *)responseObject;
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            if(HAS_DATA(dict, KEY_ErrorCode) && ![[dict objectForKey:KEY_ErrorCode] boolValue])
            {
                if(HAS_DATA(dict, KEY_Data) && [[dict objectForKey:KEY_Data] isKindOfClass:[NSArray class]])
                {
                    [alldataArray setArray:[[FAQBL sharedInstance] faqModelDataArray:[dict objectForKey:KEY_Data]]];
                    [self productButtonTapped:nil];
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

-(void)getTopSegmentView
{
    productBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [productBtn setTitle:LocStr(@"Product") forState:UIControlStateNormal];
    [productBtn setTitleColor:Dark_Gray_Color forState:UIControlStateNormal];
    [productBtn setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    [productBtn setFrame:CGRectMake(0, 64, screenSize.width/2, 40)];
    [productBtn.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
    [productBtn addTarget:self action:@selector(productButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:productBtn];
    
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(55, productBtn.frame.size.height-4, 50, 3)];
    [greenView setBackgroundColor:GREEN_COLOR];
    [greenView setTag:TAG_GreenLineView];
    [greenView setHidden:YES];
    [productBtn addSubview:greenView];
    
    foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [foodButton setTitle:LocStr(@"Food") forState:UIControlStateNormal];
    [foodButton setTitleColor:Dark_Gray_Color forState:UIControlStateNormal];
    [foodButton setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    [foodButton addTarget:self action:@selector(foodButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [foodButton.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
    [foodButton setFrame:CGRectMake(screenSize.width/2, 64, screenSize.width/2, 40)];
    [self.view addSubview:foodButton];

    UIView *greenView2 = [[UIView alloc] initWithFrame:CGRectMake(63, foodButton.frame.size.height-4, 34, 3)];
    [greenView2 setBackgroundColor:GREEN_COLOR];
    [greenView2 setTag:TAG_GreenLineView];
    [greenView2 setHidden:YES];
    [foodButton addSubview:greenView2];

    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+39, screenSize.width, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:204/255.f green:222/255.f blue:199.f alpha:1.f]];
    [self.view addSubview:lineView];
}

-(void)productButtonTapped:(id)sender
{
//     [[SharedFunction sharedInstance] getRightButtonForHeaderWithFrame:CGRectMake(0, 0, 18.5, 18.5) target:self backgroundImageNormal:[UIImage imageNamed:IMG_Search_Icon] hoverImage:[UIImage imageNamed:IMG_Search_Icon]];
    selectedRow =-1;
     [tableVw setContentOffset:CGPointMake(0, 0) animated:NO];
    [productBtn setSelected:YES];
    [foodButton setSelected:NO];
    UIView *grenView1 = [productBtn viewWithTag:TAG_GreenLineView];
    UIView *greenView2 = [foodButton viewWithTag:TAG_GreenLineView];
    [grenView1 setHidden:NO];
    [greenView2 setHidden:YES];
    NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        ModelFAQ *model = (ModelFAQ *)evaluatedObject;
        return ([model.faq_category integerValue]==2);
    }];
    
    [filteredArr setArray:[alldataArray filteredArrayUsingPredicate:pred]];
    [tableVw reloadData];
        tableVw.tableFooterView.hidden = FALSE;
    
}

-(void)foodButtonTapped:(id)sender
{
//     [[SharedFunction sharedInstance] getRightButtonForHeaderWithFrame:CGRectMake(0, 0, 18.5, 18.5) target:self backgroundImageNormal:[UIImage imageNamed:IMG_Search_Icon] hoverImage:[UIImage imageNamed:IMG_Search_Icon]];
    selectedRow =-1;
    [tableVw setContentOffset:CGPointMake(0, 0) animated:NO];
    [productBtn setSelected:NO];
    [foodButton setSelected:YES];
    UIView *grenView1 = [productBtn viewWithTag:TAG_GreenLineView];
    UIView *greenView2 = [foodButton viewWithTag:TAG_GreenLineView];
    [grenView1 setHidden:YES];
    [greenView2 setHidden:NO];
    NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        ModelFAQ *model = (ModelFAQ *)evaluatedObject;
        return ([model.faq_category integerValue]==3);
    }];
    [filteredArr setArray:[alldataArray filteredArrayUsingPredicate:pred]];
    [tableVw reloadData];
        tableVw.tableFooterView.hidden = FALSE;

}
-(void)leftBtnTapped:(id)sender
{
    NSString *phNo = @"01203832901";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
       UIAlertView *calert = [[UIAlertView alloc]initWithTitle:APP_NAME message:LocStr(@"Call facility is not available!!!")  delegate:nil cancelButtonTitle:LocStr(@"OK") otherButtonTitles:nil, nil];
        [calert show];
    }
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
            ModelFAQ *model = (ModelFAQ *)evaluatedObject;
            
            NSRange range = [model.faq_question rangeOfString : str options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
            NSRange range2 = [model.faq_answer rangeOfString:str options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
            BOOL found = ( range.location == NSNotFound && range2.location==NSNotFound);
            return !found;
        }];
        [filteredArr setArray:[alldataArray filteredArrayUsingPredicate:pred]];
        [tableVw reloadData];
            tableVw.tableFooterView.hidden = FALSE;
    }
    else
    {
        [filteredArr setArray:alldataArray];
        [tableVw reloadData];
            tableVw.tableFooterView.hidden = FALSE;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)getRightBarButtons
{
    // to be changed when navigation bar height change
    UIButton* sendQueryBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [sendQueryBtn setBackgroundColor:[UIColor clearColor]];
    sendQueryBtn.frame = CGRectMake(0, 0, 40, 44);
    [sendQueryBtn setImage:[UIImage imageNamed:@"send_query_unselected.png"] forState:UIControlStateNormal];
    [sendQueryBtn setImage:[UIImage imageNamed:@"send_query_unselected.png"] forState:UIControlStateHighlighted];
    [sendQueryBtn addTarget:self action:@selector(sendQueryBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:sendQueryBtn];
    
    
    // to be changed when navigation bar height change
    UIButton* readerBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [readerBtn setBackgroundColor:[UIColor clearColor]];
    readerBtn.frame = CGRectMake(0, 0, 40, 44);
    [readerBtn setImage:[UIImage imageNamed:IMG_user_manual] forState:UIControlStateNormal];
    [readerBtn setImage:[UIImage imageNamed:IMG_user_manual] forState:UIControlStateHighlighted];
    
    [readerBtn addTarget:self action:@selector(rightBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithCustomView:readerBtn];
    
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:anotherButton2, anotherButton, nil];

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
