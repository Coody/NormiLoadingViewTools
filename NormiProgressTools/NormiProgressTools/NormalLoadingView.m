//
//  NormalLoadingView.m
//  NormiProgressTools
//
//  Created by Coody on 2016/7/29.
//

#import "NormalLoadingView.h"

#define D_Loading_View_Width (200)

@interface NormalLoadingView()
@property (nonatomic , strong) UIActivityIndicatorView *loadingView;
@end

@implementation NormalLoadingView

-(nonnull instancetype)init{
    self = [super init];
    if ( self ) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_loadingView setFrame:CGRectMake(0, 
                                          0,
                                          D_Loading_View_Width,
                                          D_Loading_View_Width)];
        _loadingView.center = self.center;
        [self addSubview:_loadingView];
    }
    return self;
}

-(void)runAction{
    [_loadingView startAnimating];
}

-(void)stopAction{
    [_loadingView stopAnimating];
}

@end
