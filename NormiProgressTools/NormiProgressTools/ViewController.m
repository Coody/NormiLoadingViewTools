//
//  ViewController.h
//  NormiLoading
//
//  Created by Coody on 2016/7/29.
//

#import "ViewController.h"

#import "NormiLoadingTool.h"
#import "NormalLoadingView.h"

@implementation ViewController

-(instancetype)init{
    self = [super init];
    if ( self ) {
        [[NormiLoadingTool sharedInstance] setLoadingViewClass:[NormalLoadingView class]];
        
        [self performSelector:@selector(start) withObject:self afterDelay:2.0f];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)start{
    [[NormiLoadingTool sharedInstance] showloadingWithText:@"讀取中，請稍後！"];
//    [self performSelector:@selector(changeText:) withObject:@"更換字串！請確認！" afterDelay:5.0f];
//    [self performSelector:@selector(stop) withObject:self afterDelay:20.0f];
//    [self performSelector:@selector(changeText:) withObject:@"會當掉嗎？" afterDelay:30.0f];
    [self performSelector:@selector(showAlert) withObject:nil afterDelay:3.0f];
    
}

-(void)changeText:(NSString *)tempText{
    [[NormiLoadingTool sharedInstance] setTextFont:[UIFont systemFontOfSize:30.0f]];
    [[NormiLoadingTool sharedInstance] setText:tempText];
    NSLog(@"更換字串！");
}

-(void)stop{
    [[NormiLoadingTool sharedInstance] closeloading];
    [self performSelector:@selector(start) withObject:self afterDelay:2.0f];
}

-(void)showAlert{
    [[NormiLoadingTool sharedInstance] closeloading];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"測試！" 
                                                                   message:@"有問題！" 
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    __weak __typeof(self) weakSelf = self;
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" 
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              __strong __typeof(weakSelf) strongSelf = weakSelf;
                                                              [[NormiLoadingTool sharedInstance] showloadingWithText:@"讀取中，請稍後！"];
                                                              [strongSelf performSelector:@selector(showAlert) withObject:nil afterDelay:10.0f];
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
