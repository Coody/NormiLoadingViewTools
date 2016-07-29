# NormiLoadingViewTools
![建立者](https://img.shields.io/badge/建立者-Coody-orange.svg)
![License](https://img.shields.io/dub/l/vibe-d.svg)

NormiLoadingTool is a class that you can easily change your custom loading view or manage different loading view.

# How To Use

* Add keyWindow in method `application:didFinishLaunchingWithOption:` in ` AppDelegate.m`

example:
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor grayColor];
  [self.window makeKeyWindow];
  ViewController *test = [[ViewController alloc] init];
  self.window.rootViewController = test;
  [self.window makeKeyAndVisible];
  return YES;
}
```

* Create your custom loading view, and inherit `NormiLoadingTool_View` , follow protocol `NormiLoadingTool_Policy`.

example:
```
#import "NormiLoadingTool.h"

@interface NormalLoadingView : NormiLoadingTool_View < NormiLoadingTool_Policy >
@end
```

* Implement `init` and `runAction` , `stopAction` methods.

example:
```
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
```

* Initial loading view objects and use it

Initial example:
```
// NormalLoadingView is your custom loading view class.
[[NormiLoadingTool sharedInstance] setLoadingViewClass:[NormalLoadingView class]];
```

Using loading view example:
```
// show loading
[[NormiLoadingTool sharedInstance] showloadingWithText:@"Loading, please wait..."];

// close loading
[[NormiLoadingTool sharedInstance] closeloading];

// change Loading text
[[NormiLoadingTool sharedInstance] setText:@"get ready...."];

// change loading text font
[[NormiLoadingTool sharedInstance] setTextFont:[UIFont systemFontOfSize:30.0f]];

```

Enjoy it!

# License
- 此 License 屬於 MIT ，請自由取用。

