//
//  CustomCellFAQ.h
//  OxyFryer
//
//  Created by Richa Goyal on 9/26/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellFAQ : UITableViewCell
{
    UILabel *questionLbl;
    UILabel *answerLbl;
    UIButton *expandBtn;
}
@property(nonatomic, strong)UILabel *questionLbl;
@property(nonatomic, strong)UILabel *answerLbl;
@property(nonatomic, strong)UIButton *expandBtn;
@end
