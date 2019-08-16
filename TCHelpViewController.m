#import "TCHelpViewController.h"
#import <SafariServices/SafariServices.h>
#import "ICLanguageTool.h"
@interface TCHelpViewController ()<UIActionSheetDelegate>
@end
@implementation TCHelpViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    self.title = LocalString(@"Help");
    UIImageView * logoV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"about"]];
    logoV.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.21);
    logoV.bounds = CGRectMake(0, 0, 120, 120);
    logoV.layer.cornerRadius = 25;
    logoV.layer.masksToBounds = YES;
    [self.view addSubview:logoV];
    UILabel * name = [[UILabel alloc]init];
    name.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.33);
    name.bounds = CGRectMake(0, 0, 200, 80);
    name.text = LocalString(@"Life Course");
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:name];
    UILabel * thank = [[UILabel alloc]init];
    thank.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.45);
    thank.bounds = CGRectMake(0, 0,280, 80);
    thank.numberOfLines=0;
    thank.text = LocalString(@"Sincerely thank you for using the Life Course");
    thank.textAlignment = NSTextAlignmentCenter;
    thank.font = [UIFont systemFontOfSize:21];
    [self.view addSubview:thank];
    UILabel * user = [[UILabel alloc]init];
    user.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.55);
    user.bounds = CGRectMake(0, 0,280, 80);
    user.numberOfLines = 0;
    user.text = LocalString(@"If you have any questions or suggestions during the use, welcome feedback");
    user.textAlignment = NSTextAlignmentCenter;
    user.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:user];
    UILabel * rights = [[UILabel alloc]init];
    rights.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.98);
    rights.bounds = CGRectMake(0, 0, 250, 80);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    rights.text = [NSString stringWithFormat:@"©%@ Life Course @copy All rights reserved", yearString];
    rights.textAlignment = NSTextAlignmentCenter;
    rights.textColor = TCCoror(147, 147, 147);
    rights.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:rights];
}
-(void)goWeb
{
    UIActionSheet * sheets = [[UIActionSheet alloc]initWithTitle:LocalString(@"Select the page you want to visit") delegate:self cancelButtonTitle:LocalString(@"cancel") destructiveButtonTitle:nil otherButtonTitles:nil];
    sheets.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheets showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self openWebView:@"https://weibo.com/iHTCapp"];
    }
    else if(buttonIndex == 1)
    {
        [self openWebView:@"https://ihtcboy.com"];
    }
}
- (void)openWebView:(NSString *)url
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (@available(iOS 9.0, *)) {
            SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[[NSURL alloc] initWithString:url]];
            if (@available(iOS 10.0, *)) {
                sf.preferredBarTintColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
                sf.preferredControlTintColor = [UIColor whiteColor];
            }
            if (@available(iOS 11.0, *)) {
                sf.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
            }
            [self presentViewController:sf animated:YES completion:nil];
        }
        else {
            NSURL * urlstr = [NSURL URLWithString:url];
            [[UIApplication sharedApplication] openURL:urlstr];
        }
    });
}
@end
