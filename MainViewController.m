#import "MainViewController.h"
#import "TCSimpleNoteViewController.h"
#import "TCDiaryViewController.h"
#import "TCMeMoViewController.h"
#import "TCMeController.h"
#import "TCNavgationController.h"
@interface MainViewController ()
@property (nonatomic, strong) NSMutableArray *tabBarItems;
@end
@implementation MainViewController
#pragma mark - LazyLoad
- (NSMutableArray *)tabBarItems {
    if (_tabBarItems == nil) {
        _tabBarItems = [NSMutableArray array];
    }
    return _tabBarItems;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tabBar.tintColor = [UIColor colorWithRed:253/255.0 green:164/255.0 blue:42/255.0 alpha:1];
    self.tabBar.barTintColor =  [UIColor whiteColor];
    if([UIDevice currentDevice].systemVersion.floatValue>=12.0f)
    {
        [UITabBar appearance].translucent = NO;
    }
    [self addDcChildViewContorller];
    self.selectedViewController = [self.viewControllers objectAtIndex:0];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - 添加子控制器
- (void)addDcChildViewContorller
{
    NSArray *childArray = @[
                            @{MallClassKey  : @"TCDiaryViewController",
                              MallTitleKey  : @"Diary",
                              MallImgKey    : @"LifeCourse",
                              MallSelImgKey : @"LifeCourse_pre"},
                            @{MallClassKey  : @"TCSimpleNoteViewController",
                              MallTitleKey  : @"Note",
                              MallImgKey    : @"SNote",
                              MallSelImgKey : @"SNote_pre"},
                            @{MallClassKey  : @"TCMeMoViewController",
                              MallTitleKey  : @"Memo",
                              MallImgKey    : @"Memo",
                              MallSelImgKey : @"Memo_pre"},
                            @{MallClassKey  : @"TCMeController",
                              MallTitleKey  : @"Me",
                              MallImgKey    : @"me",
                              MallSelImgKey : @"me_pre"},
                            ];
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [NSClassFromString(dict[MallClassKey]) new];
        TCNavgationController *nav = [[TCNavgationController alloc] initWithRootViewController:vc];
        nav.title=LocalString(dict[MallTitleKey]);
        UITabBarItem *item = nav.tabBarItem;
        item.image = [UIImage imageNamed:dict[MallImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[MallSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.title=LocalString(dict[MallTitleKey]);
        [self addChildViewController:nav];
        [self.tabBarItems addObject:vc.tabBarItem];
    }];
}
#pragma mark - removeNotifi
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
