//
//  CategoryTabbar.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/25/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "CategoryTabbar.h"

@implementation CategoryTabbar
@synthesize categorySelected, delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
      
        [self createTabBar:frame];
        // Initialization code
    }
    return self;
}

-(void)createTabBar:(CGRect)frame
{
    NSMutableArray *catArr = [NSMutableArray array];
    for (NSDictionary *dict in [[NSDictionary dictionaryWithContentsOfFile:STATIC_DATA_PLIST] objectForKey:@"Categories"]) {
        [catArr addObject:[dict objectForKey:@"Title"]];
    }
    
    scrollVw = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [scrollVw setDelegate:self];
    [scrollVw setUserInteractionEnabled:YES];
    [scrollVw setShowsHorizontalScrollIndicator:NO];
    [scrollVw setContentSize:CGSizeMake(320, frame.size.height)];
    [self addSubview:scrollVw];
    CGFloat xorigin = 0;
    
    
    for (NSString *catStr in catArr) {
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize size = [catStr sizeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIFont fontWithName:MyriadPro_Light size:14], nil] forKeys:[NSArray arrayWithObjects:NSFontAttributeName, nil]]];
        [btn setTag:[catArr indexOfObject:catStr]];
        [btn.titleLabel setFont:[UIFont fontWithName:MyriadPro_Light size:14]];
        [btn addTarget:self action:@selector(categoryBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        if([catArr indexOfObject:catStr]==0)
        {
            UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (screenSize.width-size.width-30)/2, frame.size.height)];
            [vw setBackgroundColor:[UIColor clearColor]];
            [scrollVw addSubview:vw];
            xorigin=xorigin+vw.frame.size.width;
        }
        
        [btn setFrame:CGRectMake(xorigin, 0, size.width+30, frame.size.height)];
        [btn setTitle:catStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [scrollVw addSubview:btn];
        if([catStr isEqualToString:@"All"])
            selectedBtn=btn;
        xorigin =xorigin+ btn.frame.size.width;
        
        if([catArr indexOfObject:catStr]==catArr.count-1)
        {
            UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(xorigin, 0, (screenSize.width-size.width-30)/2, frame.size.height)];
            [vw setBackgroundColor:[UIColor clearColor]];
            [scrollVw addSubview:vw];
            xorigin=xorigin+vw.frame.size.width;
        }
    }
    
    
   [scrollVw setContentSize:CGSizeMake(xorigin, frame.size.height)];
}

-(void)categoryBtnTapped:(UIButton *)sender
{
    [selectedBtn.titleLabel setFont:[UIFont fontWithName:MyriadPro_Light size:14]];
    selectedBtn = sender;
    [sender.titleLabel setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
    [scrollVw setContentOffset:CGPointMake((CGRectGetMaxX(sender.frame)-(screenSize.width/2))-(sender.frame.size.width/2), 0) animated:YES];
    NSArray *catArr = [[NSDictionary dictionaryWithContentsOfFile:STATIC_DATA_PLIST] objectForKey:@"Categories"];
    if([self.delegate respondsToSelector:@selector(categoryButtonTapped:)])
        [delegate categoryButtonTapped:[catArr objectAtIndex:sender.tag]];
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextMoveToPoint   (ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, (rect.size.width/2)-6, CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, (rect.size.width/2), CGRectGetMaxY(rect)-6);
    CGContextAddLineToPoint(ctx, (rect.size.width/2)+6, CGRectGetMaxY(rect));
    CGContextAddLineToPoint   (ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));

    CGContextAddLineToPoint  (ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint  (ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, GREEN_COLOR.CGColor);
    CGContextFillPath(ctx);
}

#pragma mark -UIScroolviewdelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewStooped:scrollView];
    
}


-(void)scrollViewStooped:(UIScrollView *)scrollView
{
    NSPredicate *pred =[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        UIButton *btn = (UIButton *)evaluatedObject;
        return (btn.frame.origin.x<(scrollView.contentOffset.x+(screenSize.width/2)) && CGRectGetMaxX(btn.frame)>(scrollView.contentOffset.x+(screenSize.width/2)));
    }];
    UIButton *btn = [[[scrollView subviews] filteredArrayUsingPredicate:pred] lastObject];
    if(btn && [btn isKindOfClass:[UIButton class]])
        [self categoryBtnTapped:btn];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"width = %f, height = %f",screenSize.width, screenSize.height);
    if(!decelerate)
    [self scrollViewStooped:scrollView];
}
-(void)tapAllButton
{
    for (UIButton *allBtn in [scrollVw subviews]) {
        if([allBtn isKindOfClass:[UIButton class]] && [allBtn.titleLabel.text caseInsensitiveCompare:@"All"]==NSOrderedSame)
        {
            [self categoryBtnTapped:allBtn];
        }
    }
}
@end
