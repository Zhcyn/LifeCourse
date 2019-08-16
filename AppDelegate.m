#import "AppDelegate.h"
#import "MainViewController.h"
#import "ICLanguageTool.h"
#import "GesturePasswordController.h"
@interface AppDelegate ()
@property(nonatomic,strong)MainViewController *mainVC;
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [ICLanguageTool sharedInstance];
    self.window.rootViewController = self.mainVC;
    [self.window makeKeyAndVisible];
    [self setUpFixiOS11]; 
    [self registNotification];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
}
- (void)applicationWillTerminate:(UIApplication *)application {
}
-(MainViewController *)mainVC
{
    if(!_mainVC)
    {
        _mainVC=[[MainViewController alloc] init];
    }
    return _mainVC;
}
#pragma mark - FixiOS11
- (void)setUpFixiOS11
{
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
}
#pragma mark - Notification
-(void)registNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"RDNotificationLanguageChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gestureFinishNotification:) name:GesturePasswordFinishNotification object:nil];
}
-(void)gestureFinishNotification:(NSNotification *)notifi
{
    self.window.rootViewController = self.mainVC;
}
-(void)changeLanguage
{
    if(_mainVC)
    {
        [_mainVC.view removeFromSuperview];
        _mainVC=nil;
    }
    self.window.rootViewController = self.mainVC;
}
@end
