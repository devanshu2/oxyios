//
//  SharedFunction.m
//
//  Created by Richa Goyal on 16/05/13.


#import "SharedFunction.h"


@implementation SharedFunction
static SharedFunction* _sharedInstance = nil;

-(UILabel *)getLabelWithFrame:(CGRect)frame title:(NSString *)title textcolor:(UIColor *)titleColor font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setText:title];
    [label setTextColor:titleColor];
    [label setFont:font];
    //[label setShadowColor:SHADOW_COLOR];
    // [label setShadowOffset:CGSizeMake(0.5, 0.5)];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setBackgroundColor:[UIColor clearColor]];
    return label;
}

-(void)showAlertViewWithMeg:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:str delegate:nil cancelButtonTitle:LocStr(@"OK") otherButtonTitles:nil, nil];
    [alert show];

}



-(NSData*) getArchievedDataFromDic:(NSDictionary*)dic
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    return data;
}

-(NSDictionary*) getDicFromArchievedData:(NSData*)data
{
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dic;
}


-(void)showServerErrorAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:LocStr(@"SERVER_ERROR") delegate:nil cancelButtonTitle:LocStr(@"OK") otherButtonTitles:nil, nil];
    [alert show];
}

-(void)setTitleViewForNavigationItem:(UINavigationItem *)navItem
{
    UIView *titleVw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 133, 44)];
    
    UIImageView *imgVw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_logo]];
    [imgVw setFrame:CGRectMake(27, 9.5f, 78.5, 25)];
    [titleVw addSubview:imgVw];
    [titleVw setBackgroundColor:[UIColor clearColor]];
    [navItem setTitleView:titleVw];
}

-(void)getLeftButtonForHeadertarget:(id)target
{
    UIViewController *targetVC = (UIViewController*)target;
    // to be changed when navigation bar height change
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,31, 44)];
    [bgView setBackgroundColor:[UIColor clearColor]];
    UIButton* leftBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    leftBtn.frame = CGRectMake(0, 0, 31, 44);
    [leftBtn setImage:[UIImage imageNamed:IMG_back_icon] forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    [bgView addSubview:leftBtn];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 27-10.5)];
    [leftBtn addTarget:target action:@selector(leftBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    
    targetVC.navigationItem.leftBarButtonItem = anotherButton;
}
-(void)getLeftButtonForHeaderWithFrame:(CGRect)frame target:(id)target backgroundImageNormal:(UIImage *)backgroundImage hoverImage:(UIImage *)hoverImage
{
    UIViewController *targetVC = (UIViewController*)target;
    // to be changed when navigation bar height change
    UIButton* leftBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    leftBtn.frame = CGRectMake(0, 0, frame.size.width+20, 44);
    [leftBtn setImage:backgroundImage forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    [leftBtn setImage:hoverImage forState:UIControlStateHighlighted];
    //    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 35-frame.size.width)];
    [leftBtn addTarget:target action:@selector(leftBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    targetVC.navigationItem.leftBarButtonItem = anotherButton;
}

-(void)getRightButtonForHeaderWithFrame:(CGRect)frame target:(id)target backgroundImageNormal:(UIImage *)backgroundImage hoverImage:(UIImage *)hoverImage
{
    UIViewController *targetVC = (UIViewController*)target;
    
    
    UIButton* rightBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    rightBtn.frame = CGRectMake(0, 0, frame.size.width+10, 44);
    [rightBtn setImage:backgroundImage forState:UIControlStateNormal];
    [rightBtn setImage:hoverImage forState:UIControlStateHighlighted];
    [rightBtn addTarget:target action:@selector(rightBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    targetVC.navigationItem.rightBarButtonItem = anotherButton;
}



#pragma mark ---- singleton object methods ----
// See "Creating a Singleton Instance" in the Cocoa Fundamentals Guide for more info

+ (SharedFunction *)sharedInstance {
    @synchronized(self) {
        if (_sharedInstance == nil) {
			_sharedInstance =  [[SharedFunction alloc] init]; // assignment not done here
        }
    }
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}



//- (id)retain {
//    return self;
//}

//- (unsigned)retainCount {
//    return UINT_MAX;  // denotes an object that cannot be released
//}

//- (oneway void)release {
//    //do nothing
//}

//- (id)autorelease {
//    return self;
//}

@end
