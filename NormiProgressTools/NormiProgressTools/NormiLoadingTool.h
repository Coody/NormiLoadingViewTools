//
//  NormiLoadingTool.h
//  NormiLoading
//
//  Created by Coody on 2016/6/13.
//

#import <UIKit/UIKit.h>

// 預設的字體大小 、預設的字體、字體顏色（預設白色）
#define D_NormiLoadingTool_TextSize (16.0f)
#define D_NormiLoadingTool_TextFont [UIFont boldSystemFontOfSize:D_NormiLoadingTool_TextSize]
#define D_NormiLoadingTool_TextColor [UIColor whiteColor]
#define D_NormiLoadingTool_MiddleMargin (20.0f)

@protocol App_Alloc_Policy;


#pragma mark - Loading Policy
@protocol NormiLoadingTool_Policy <NSObject>
@required
-(void)runAction;
-(void)stopAction;
@end


#pragma mark - Loading Class
@interface NormiLoadingTool_View : UIView <NormiLoadingTool_Policy>
-(nonnull instancetype)init;
@end


#pragma mark - Loading Tool
@interface NormiLoadingTool : NSObject

@property (nonnull , nonatomic , strong) UIView *grayAlphaView;

+(nonnull instancetype)sharedInstance;

#pragma mark : 設定 LoadingView
-(void)setLoadingViewClass:(nonnull Class <NormiLoadingTool_Policy , App_Alloc_Policy>)LoadingViewClass;

/**
 *  設定 LoadingView 的內部
 *
 *  @param tempPosition 放置 LoadingView 的位置（）
 */
-(void)setLoadingViewPosition:(CGPoint)tempPosition;

-(void)showloadingWithText:(nullable NSString *)tempText withClass:(nonnull Class <NormiLoadingTool_Policy , App_Alloc_Policy>)LoadingViewClass;
-(void)showloadingWithText:(nullable NSString *)tempText;

-(void)closeloading;

-(NSString *)recentLoadingViewKey;

#pragma mark : 設定 Label 的屬性
-(void)setTextFont:(nonnull UIFont *)tempFont;

-(void)setTextColor:(nonnull UIColor *)tempColor;

-(void)setTextSize:(CGFloat)tempSize;

-(void)setTextFont:(nonnull UIFont *)tempFont withTextColor:(nonnull UIColor *)tempColor;

-(void)setText:(nonnull NSString *)tempText;

@end
