//
//  NormiLoadingTool.m
//  NormiLoading
//
//  Created by Coody on 2016/6/13.
//  Copyright © 2016年 Coody. All rights reserved.
//

#import "NormiLoadingTool.h"


#pragma mark - Alloc Policy
@protocol App_Alloc_Policy <NSObject>
+ (instancetype)alloc;
@end

#pragma mark - Loading Class
@implementation NormiLoadingTool_View
-(instancetype)init{
    self = [super init];
    if ( self ) {
        
    }
    return self;
}

-(void)runAction{
    // override
    NSAssert( YES , @"請務必 override 此方法！！( Class name: %@ , Class Method: %@ )" , NSStringFromClass([self class]) , NSStringFromSelector(_cmd) );
}

-(void)stopAction{
    // override
    NSAssert( YES , @"請務必 override 此方法！！( Class name: %@ , Class Method: %@ )" , NSStringFromClass([self class]) , NSStringFromSelector(_cmd) );
}

@end


#pragma mark - Loading Tool
@interface NormiLoadingTool()
// 此 App 的 keyWindow
@property (nonatomic , strong) UIWindow *keyWindow;
// Loading View 相關
@property (nonatomic , strong) NSMutableDictionary *loadingViewDic;
@property (nonnull , nonatomic , strong) NSMutableString *recentLoadingViewKey;
// TextLabel 相關
@property (nullable , nonatomic , strong) UILabel *textLabel;
// 是否正在 loading
@property (nonatomic , assign) BOOL isLoading;
@end

@implementation NormiLoadingTool

+(instancetype)sharedInstance{
    static NormiLoadingTool *sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if ( sharedInstance == nil ) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

-(instancetype)init{
    self = [super init];
    if ( self ) {
        _grayAlphaView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        [_grayAlphaView setBackgroundColor:[UIColor blackColor]];
        [_grayAlphaView setAlpha:0.0f];
        
        _loadingViewDic = [[NSMutableDictionary alloc] init];
        _recentLoadingViewKey = [[NSMutableString alloc] initWithString:@""];
        _keyWindow = [UIApplication sharedApplication].keyWindow;
        _isLoading = NO;
        
        _textLabel = [[UILabel alloc] init];
        [_textLabel setTextAlignment:(NSTextAlignmentCenter)];
        [_textLabel setFont:D_NormiLoadingTool_TextFont];
        [_textLabel setTextColor:D_NormiLoadingTool_TextColor];
        [_textLabel setText:@""];
        
        // 加入監聽
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(continueLoading) 
                                                     name:UIApplicationWillEnterForegroundNotification 
                                                   object:nil];
    }
    return self;
}

-(void)dealloc{
    for ( NormiLoadingTool_View <NormiLoadingTool_Policy , App_Alloc_Policy> *unit in _loadingViewDic.allValues ) {
        [unit stopAction];
        [unit removeFromSuperview];
    }
    [_loadingViewDic removeAllObjects];
    _loadingViewDic = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIApplicationWillEnterForegroundNotification 
                                                  object:nil];
}

-(void)setLoadingViewClass:(nonnull Class <NormiLoadingTool_Policy , App_Alloc_Policy>)LoadingViewClass{
    
    BOOL isNeedCreateNew = NO;
    NormiLoadingTool_View *loadingView;
    if ( [_recentLoadingViewKey isEqualToString:@""] || _recentLoadingViewKey == nil ) {
        isNeedCreateNew = YES;
    }
    else{
        if ( [_recentLoadingViewKey isEqualToString:NSStringFromClass(LoadingViewClass)] ) {
            // 不用再取一次
        }
        else{
            // 先關掉舊的動畫效果
            [self closeloading];
            
            // 檢查字典是否已經存在此 Loading view ，有的話就更換 key 就好，沒有的話就產生新的
            NSString *checkKey = [_loadingViewDic objectForKey:NSStringFromClass(LoadingViewClass)];
            if ( checkKey == nil ) {
                isNeedCreateNew = YES;
            }
            else{
                [_recentLoadingViewKey setString:checkKey];
            }
        }
    }
    
    if ( isNeedCreateNew == YES ) {
        // 建立新的 Loading view
        [_recentLoadingViewKey setString:NSStringFromClass(LoadingViewClass)];
        loadingView = [[LoadingViewClass alloc] init];
        loadingView.center = _grayAlphaView.center;
        [_loadingViewDic setObject:loadingView forKey:_recentLoadingViewKey];
    }
    
    // 預先調整設定 Label 的位置
    if ( _textLabel ) {
        [self checkTextLabel];
    }
}

/**
 *  設定 LoadingView 的內部
 *
 *  @param tempPosition 放置 LoadingView 的位置（）
 */
-(void)setLoadingViewPosition:(CGPoint)tempPosition{
    NormiLoadingTool_View *loadingView = [_loadingViewDic objectForKey:_recentLoadingViewKey];
    [loadingView setFrame:CGRectMake(tempPosition.x, tempPosition.y, CGRectGetWidth(loadingView.frame), CGRectGetHeight(loadingView.frame))];
}

-(void)showloadingWithText:(nullable NSString *)tempText{
    
    _isLoading = YES;
    
    if ( tempText != nil ) {
        [self setText:tempText];
    }
    
    NormiLoadingTool_View *loadingView = [_loadingViewDic objectForKey:_recentLoadingViewKey];
    [_keyWindow addSubview:_grayAlphaView];
    [_grayAlphaView addSubview:loadingView];
    [loadingView runAction];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.grayAlphaView setAlpha:0.7f];
    }];
}

-(void)closeloading{
    NormiLoadingTool_View *loadingView = [_loadingViewDic objectForKey:_recentLoadingViewKey];
    [loadingView stopAction];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1f animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.grayAlphaView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [loadingView removeFromSuperview];
        [strongSelf.grayAlphaView removeFromSuperview];
        strongSelf.isLoading = NO;
    }];
}

-(void)continueLoading{
    NormiLoadingTool_View *loadingView = [_loadingViewDic objectForKey:_recentLoadingViewKey];
    [loadingView runAction];
}

-(void)setTextFont:(nonnull UIFont *)tempFont{
    [_textLabel setFont:tempFont];
    [self checkTextLabel];
}

-(void)setTextColor:(nonnull UIColor *)tempColor{
    [_textLabel setTextColor:tempColor];
    [self checkTextLabel];
}

-(void)setTextSize:(CGFloat)tempSize{
    
    if ( tempSize < 0 ) {
        tempSize = 0;
    }
    
    [_textLabel setFont:[UIFont fontWithName:_textLabel.font.fontName size:tempSize]];
    [self checkTextLabel];
}

-(void)setTextFont:(nonnull UIFont *)tempFont withTextColor:(nonnull UIColor *)tempColor{
    [_textLabel setFont:tempFont];
    [_textLabel setTextColor:tempColor];
    [self checkTextLabel];
}

-(void)setText:(nonnull NSString *)tempText{
    [_textLabel setText:tempText];
    [self checkTextLabel];
}

#pragma mark - Private
-(void)checkTextLabel{
    NormiLoadingTool_View *loadingView = [_loadingViewDic objectForKey:_recentLoadingViewKey];
    CGSize newSize = [NormiLoadingTool getTextSizeWithWidth:CGRectGetWidth(_keyWindow.frame) 
                                                 withText:_textLabel.text 
                                                 withFont:_textLabel.font];
    [_textLabel setFrame:CGRectMake(0,
                                    CGRectGetMaxY(loadingView.frame) + D_NormiLoadingTool_MiddleMargin,
                                    CGRectGetWidth(_keyWindow.frame),
                                    newSize.height)];
    [_grayAlphaView addSubview:_textLabel];
}

+(CGSize)getTextSizeWithWidth:(float)tempWidth 
                     withText:(NSString *)tempText 
                     withFont:(UIFont *)tempFont
{
    return ([tempText boundingRectWithSize:CGSizeMake(tempWidth, CGFLOAT_MAX) 
                                   options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                attributes:@{NSFontAttributeName:tempFont} 
                                   context:nil].size);
}

@end
