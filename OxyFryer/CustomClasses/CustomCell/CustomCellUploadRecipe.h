//
//  CustomCellUploadRecipe.h
//  OxyFryer
//
//  Created by Richa Goyal on 10/10/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellUploadRecipe : UITableViewCell
{
    UILabel *titleLbl;
    UITextField *txtFld1;
    UITextField *txtFld2;
}
@property(nonatomic, strong)UILabel *titleLbl;
@property(nonatomic, strong)UITextField *txtFld1;
@property(nonatomic, strong)UITextField *txtFld2;
@end
