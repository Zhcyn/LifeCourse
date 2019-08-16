#import "TCMeController.h"
#import <Foundation/Foundation.h>
#import "MBProgressHUD+MJ.h"
#import "TCAbutSNoteViewController.h"
#import "TCHelpViewController.h"
#import "TCUserItemsViewController.h"
#import <StoreKit/StoreKit.h>
#import <SafariServices/SafariServices.h>
#import "DHDeviceUtil.h"
#import "TCMeCell.h"
#import "TCSettingViewController.h"
@interface TCMeController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *imageHead;
@property (strong, nonatomic) UITextView *textView;
@property (strong,nonatomic) UIView *headView;
@property(strong,nonatomic) NSMutableArray *dataArray;
@end
 static NSString *cellIdentifier = @"TCMeCellID";
@implementation TCMeController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=LocalString(@"Me");
    [self initHeadView];
    [self initUItableView];
    _dataArray=[[NSMutableArray alloc] init];
    NSDictionary *dict=@{
                          @"img":@"share",
                          @"title":LocalString(@"Setting")
                          };
    NSDictionary *dict1=@{
                         @"img":@"help",
                         @"title":LocalString(@"help")
                         };
    NSDictionary *dict2=@{
                          @"img":@"messge",
                          @"title":LocalString(@"User notice")
                          };
    NSDictionary *dict3=@{
                          @"img":@"pencil",
                          @"title":LocalString(@"About LoveNote")
                          };
    [_dataArray addObject:dict1];
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)initUItableView
{
    UITableView *tableview=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.frame=CGRectMake(0,StatueBarHeight,SCREEN_WIDTH, self.view.frame.size.height-TabbarHeight);
    tableview.tableFooterView = [[UIView alloc] init];
    tableview.estimatedRowHeight = 0;
    tableview.estimatedSectionHeaderHeight = 0;
    tableview.estimatedSectionFooterHeight = 0;
    tableview.tableFooterView=[[UIView alloc] init];
    tableview.tableHeaderView=_headView;
    [self.view addSubview:tableview];
    self.tableView=tableview;
    [tableview registerClass:[TCMeCell class] forCellReuseIdentifier:cellIdentifier];
}
-(void)initHeadView
{
    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,250)];
    _headView=headView;
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-70, 20, 140,140)];
    imageView.layer.cornerRadius = 70.f;
    imageView.layer.masksToBounds = YES;
    [headView addSubview:imageView];
    _imageHead=imageView;
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100,165,200,15)];
    lb.font=[UIFont systemFontOfSize:10];
    lb.textAlignment=NSTextAlignmentCenter;
    lb.text=LocalString(@"Click Change HeadImg");
    [headView addSubview:lb];
    UIButton *btn=[[UIButton alloc] initWithFrame:imageView.frame];
    btn.backgroundColor=[UIColor clearColor];
    [headView addSubview:btn];
    [btn addTarget:self action:@selector(changeHeadImage) forControlEvents:UIControlEventTouchUpInside];
    UITextView *textview=[[UITextView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width,30)];
    textview.font=[UIFont systemFontOfSize:16];
    textview.backgroundColor=[UIColor whiteColor];
    textview.textAlignment=NSTextAlignmentCenter;
    [headView addSubview:textview];
    _textView=textview;
    UIButton *txtbtn=[[UIButton alloc] initWithFrame:textview.frame];
    txtbtn.backgroundColor=[UIColor clearColor];
    [headView addSubview:txtbtn];
    [txtbtn addTarget:self action:@selector(changeText) forControlEvents:UIControlEventTouchUpInside];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
    NSData *data=[NSData dataWithContentsOfFile:uniquePath];
    if (data)
    {
        UIImage * image = [UIImage imageWithData:data];
        _imageHead.image = image;
    }
    else
    {
        [_imageHead setImage:[DHDeviceUtil ellipseImage:[UIImage imageNamed:@"about"] withInset:0 withBorderWidth:5 withBorderColor:[DHDeviceUtil colorWithHexString:@"#eeeeee"]]];
    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"textView"])
    {
        _textView.text = [defaults valueForKey:@"textView"];
    }
    else
    {
        _textView.text = LocalString(@"Please click to enter the signature");
    }
}
#pragma mark - lazyLoad
-(NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray=[[NSMutableArray alloc] init];
    }
    return _dataArray;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TCMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.dict=self.dataArray[indexPath.row];
    return cell;
}
#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(0==indexPath.row)
    {
        TCHelpViewController * helpV = [[TCHelpViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:helpV animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if(1==indexPath.row)
    {
        TCUserItemsViewController * setting = [[TCUserItemsViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setting animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if(2==indexPath.row)
    {
    }else if(3==indexPath.row)
    {
        TCAbutSNoteViewController * about = [[TCAbutSNoteViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:about animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}
-(void)changeHeadImage
{
    UIActionSheet * sheets = [[UIActionSheet alloc]initWithTitle:LocalString(@"Choose how to change your avatar") delegate:self cancelButtonTitle:LocalString(@"cancel") destructiveButtonTitle:nil otherButtonTitles:LocalString(@"Take a photo"),LocalString(@"Choose from album"), nil];
    sheets.actionSheetStyle = UIActionSheetStyleAutomatic;
    sheets.delegate=self;
    sheets.tag = 1;
    [sheets showInView:self.view];
}
-(void)changeText
{
    UIAlertView * alter = [[UIAlertView alloc]initWithTitle:LocalString(@"edit") message:LocalString(@"Please enter your love") delegate:self cancelButtonTitle:LocalString(@"cancel") otherButtonTitles:LocalString(@"sure"),nil];
    alter.alertViewStyle = UIAlertViewStylePlainTextInput;
    alter.delegate=self;
    [alter textFieldAtIndex:0].text = self.textView.text;
    [alter textFieldAtIndex:0].clearButtonMode =UITextFieldViewModeWhileEditing;
    [alter show];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1 && buttonIndex == 0)
    {
        UIImagePickerController * camera = [[UIImagePickerController alloc]init];
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        camera.delegate = self;
        [self presentViewController:camera animated:YES completion:^{
        }];
    }
    else if(actionSheet.tag == 1 && buttonIndex == 1)
    {
        UIImagePickerController * photo = [[UIImagePickerController alloc]init];
        photo.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        photo.delegate = self;
        [self presentViewController:photo animated:YES completion:^{
        }];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
    }
    if (buttonIndex == 1)
    {
        self.textView.text = [alertView textFieldAtIndex:0].text;
        NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
        [defaults setValue:self.textView.text forKey:@"textView"];
        [defaults synchronize];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage * newImage = info[UIImagePickerControllerOriginalImage];
    [self.imageHead setImage:newImage];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
    [UIImagePNGRepresentation(newImage) writeToFile:uniquePath atomically:YES];
}
@end
