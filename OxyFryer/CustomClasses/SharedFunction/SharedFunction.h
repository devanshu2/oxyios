//
//  SharedFunction.h
//
//  Created by Richa Goyal on 16/05/13.
//

#import <Foundation/Foundation.h>

@interface SharedFunction : NSObject

+ (SharedFunction *)sharedInstance ;

-(void)showServerErrorAlertView;
-(void)showAlertViewWithMeg:(NSString *)str;
-(NSData*) getArchievedDataFromDic:(NSDictionary*)dic;
-(NSDictionary*) getDicFromArchievedData:(NSData*)data;
-(UILabel *)getLabelWithFrame:(CGRect)frame title:(NSString *)title textcolor:(UIColor *)titleColor font:(UIFont *)font;
;
-(void)setTitleViewForNavigationItem:(UINavigationItem *)navItem;
-(void)getLeftButtonForHeadertarget:(id)target;
-(void)getRightButtonForHeaderWithFrame:(CGRect)frame target:(id)target backgroundImageNormal:(UIImage *)backgroundImage hoverImage:(UIImage *)hoverImage;
-(void)getLeftButtonForHeaderWithFrame:(CGRect)frame target:(id)target backgroundImageNormal:(UIImage *)backgroundImage hoverImage:(UIImage *)hoverImage;
@end
