#import "TCNavgationController.h"
@interface TCNavgationController ()
@end
@implementation TCNavgationController
#pragma mark - load初始化一次
+ (void)load
{
    [self setUpBase];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - 初始化
+ (void)setUpBase
{
    UINavigationBar * navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor colorWithRed:253/255.0 green:164/255.0 blue:42/255.0 alpha:1]];
    navBar.tintColor = [UIColor whiteColor];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:20]}];
    UIBarButtonItem * item = [UIBarButtonItem appearance];
    NSMutableDictionary * itemAttrys = [NSMutableDictionary dictionary];
    itemAttrys[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:itemAttrys forState:UIControlStateNormal];
}
@end
