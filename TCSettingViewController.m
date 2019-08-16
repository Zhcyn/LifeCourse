#import "TCSettingViewController.h"
#import "ICLanguageTool.h"
#import "DHDeviceUtil.h"
#import "GesturePasswordController.h"
@interface TCSettingViewController ()
@property(nonatomic,strong)GesturePasswordController *gesture;
@end
@implementation TCSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=LocalString(@"Setting");
    self.view.backgroundColor=[DHDeviceUtil colorWithHexString:@"eeeeee"];
    [self initUI];
}
-(void)initUI
{
    CGFloat buttonY = 15;
    CGFloat kRowHeight=50;
    CGFloat leftMargin = 15;
    UIView *contentView=[[UIView alloc] initWithFrame:CGRectMake(0,TopBarHeight+buttonY, SCREEN_WIDTH,kRowHeight)];
    contentView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:contentView];
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kRowHeight)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(changeLanguge) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 0, SCREEN_WIDTH-100, kRowHeight)];
        titleLb.text = LocalString(@"Language");
        titleLb.textColor = [UIColor blackColor];
        titleLb.font = [UIFont systemFontOfSize:16];
        titleLb.textAlignment=NSTextAlignmentLeft;
        [btn addSubview:titleLb];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40,14, 22, 22)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = [UIImage imageNamed:@"arrow_right_icon"];
        [btn addSubview:imgView];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,1)];
        line.backgroundColor = [DHDeviceUtil colorWithHexString:@"eeeeee"];
        [btn addSubview:line];
    }
    buttonY=buttonY+kRowHeight;
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,buttonY, SCREEN_WIDTH, kRowHeight)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(gestureReSet) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 0, SCREEN_WIDTH-100, kRowHeight)];
        titleLb.text = LocalString(@"Reset Gesture Password");
        titleLb.textColor = [UIColor blackColor];
        titleLb.font = [UIFont systemFontOfSize:16];
        titleLb.textAlignment=NSTextAlignmentLeft;
        [btn addSubview:titleLb];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40,14, 22, 22)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = [UIImage imageNamed:@"arrow_right_icon"];
        [btn addSubview:imgView];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,1)];
        line.backgroundColor = [DHDeviceUtil colorWithHexString:@"eeeeee"];
        [btn addSubview:line];
    }
    buttonY=buttonY+kRowHeight;
    CGRect frame=contentView.frame;
    frame.size.height=buttonY-15;
    contentView.frame=frame;
}
-(void)changeLanguge
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:LocalString(@"ChangeLanguage") message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cannelAction = [UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *en = [UIAlertAction actionWithTitle:LocalString(@"EN") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ICLanguageTool sharedInstance] setNewLanguage:EN];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RDNotificationLanguageChanged" object:nil];
    }];
    UIAlertAction *china = [UIAlertAction actionWithTitle:LocalString(@"CNS") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ICLanguageTool sharedInstance] setNewLanguage:CNS];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RDNotificationLanguageChanged" object:nil];
    }];
    [alert addAction:cannelAction];
    [alert addAction:china];
    [alert addAction:en];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)gestureReSet
{
    GesturePasswordController *gesture=[[GesturePasswordController alloc] init];
    [gesture reset:NO];
    gesture.changeFinish = ^(BOOL change) {
    };
    [self presentViewController:gesture animated:YES completion:nil];
}
@end
