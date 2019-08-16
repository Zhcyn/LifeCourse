#import "TCAddDiaryViewController.h"
#import "TCDatePickerView.h"
#import "TCDiary.h"
#import "MBProgressHUD+MJ.h"
#import "DHDeviceUtil.h"
#import "ICLanguageTool.h"
@interface TCAddDiaryViewController ()<UITextFieldDelegate,UITextViewDelegate, TCDatePickerViewDelegate,UIScrollViewDelegate>
@property (nonatomic, weak) UITextField * titleField;
@property (nonatomic, weak) UITextView * detailView;
@property (nonatomic, weak) UILabel * dateLabel;
@property (nonatomic, strong) TCDatePickerView * pickerView;
@property (nonatomic, strong) TCDiary * diaryNote;
@property (nonatomic, weak) UITextField * weatherField;
@property (nonatomic, weak) UITextField * moodField;
@property (nonatomic, copy) NSString * originalDate;
@end
@implementation TCAddDiaryViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self topColor];
    [self titleFileds];
    [self detailViews];
    [self backBtn];
    [self saveBtn];
    [self showdateLabel];
    [self showWeather];
    [self showMood];
    self.pickerView = [TCDatePickerView initWithPicker:self.view.frame];
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
}
-(TCDiary *)diaryNote
{
    if (_diaryNote == nil)
    {
        _diaryNote = [[TCDiary alloc]init];
    }
    return _diaryNote;
}
-(void)topColor
{
    CGFloat top = TopBarHeight;
    UIView * topColor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, top)];
    topColor.backgroundColor  = TCBgColor;
    [self.view addSubview:topColor];
}
-(void)titleFileds
{
    CGFloat top = StatueBarHeight+20;
    UITextField * titleField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 125, 44)];
    titleField.center = CGPointMake(self.view.frame.size.width /2+10,top);
    titleField.font = [UIFont boldSystemFontOfSize:16];
    titleField.placeholder = LocalString(@"Diary title");
    titleField.textAlignment = NSTextAlignmentCenter;
    titleField.clearButtonMode =UITextFieldViewModeWhileEditing;
    [titleField becomeFirstResponder];
    self.titleField = titleField;
    [self.view addSubview:titleField];
}
-(void)detailViews
{
    CGFloat top = 120 + (MACRO_IS_IPHONE_X ? 14 : 0);
    UITextView * detailView =[[UITextView alloc]initWithFrame:CGRectMake(10, top, self.view.frame.size.width - 20, self.view.frame.size.height - 120)];
    detailView.font = [UIFont systemFontOfSize:18];
    detailView.layer.masksToBounds = YES;
    detailView.alwaysBounceVertical = YES;
    detailView.text = @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
    self.detailView = detailView;
    self.detailView.delegate = self;
    [self.view addSubview:detailView];
}
-(void)showdateLabel
{
   CGFloat top = 95 +  (MACRO_IS_IPHONE_X ? 14 : 0);
    UILabel * dateLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, top, 120, 15)];
    dateLabel.text = [TCDatePickerView getNowDateFormat:@"MMdd HH:mm"];
    dateLabel.font = [UIFont systemFontOfSize:16];
    self.dateLabel = dateLabel;
    [self.view addSubview:dateLabel];
    UIButton * touchLabel = [[UIButton alloc]initWithFrame:CGRectMake(0, top -5, 130, 20)];
    [touchLabel addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
    self.diaryNote.time = [TCDatePickerView getNowDateFormat:@"yyyyMMdd HH:mm"];
    [self.view addSubview:touchLabel];
}
-(void)showPicker
{
    self.originalDate = self.dateLabel.text;
    [self.pickerView popDatePickerView];
    [self.pickerView resetToZero];
    [self.view endEditing:YES];
}
-(void)showWeather
{
    CGFloat top = 93 + (MACRO_IS_IPHONE_X ? 14 : 0);
    UITextField * weatherField = [[UITextField alloc]initWithFrame:CGRectMake(130, top, (self.view.frame.size.width -135)/ 2, 20)];
    weatherField.font = [UIFont systemFontOfSize:16];
    weatherField.placeholder = LocalString(@"weather");
    weatherField.textAlignment = NSTextAlignmentCenter;
    weatherField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.weatherField = weatherField;
    [self.view addSubview:weatherField];
}
-(void)showMood
{
    CGFloat top = 93 + (MACRO_IS_IPHONE_X ? 14 : 0);
    UITextField * moodField = [[UITextField alloc]initWithFrame:CGRectMake( 135 +(self.view.frame.size.width -135)/ 2, top, (self.view.frame.size.width -135)/ 2, 20)];
    moodField.font = [UIFont systemFontOfSize:16];
    moodField.placeholder = LocalString(@"mood");
    moodField.textAlignment = NSTextAlignmentCenter;
    moodField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.moodField = moodField;
    [self.view addSubview:moodField];
}
-(void)backBtn
{
     CGFloat top = StatueBarHeight+10;
    UIButton * backBn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backBn  setFrame:CGRectMake(5, top, 60, 30)];
    [backBn setTitle:LocalString(@"cancel") forState:UIControlStateNormal];
    backBn.tintColor = [UIColor whiteColor];
    backBn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [backBn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBn];
}
-(void)saveBtn
{
     CGFloat top = StatueBarHeight+10;
    UIButton * saveBn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveBn  setFrame:CGRectMake(self.view.frame.size.width - 65 , top, 60, 30)];
    [saveBn setTitle:LocalString(@"save") forState:UIControlStateNormal];
    saveBn.tintColor = [UIColor whiteColor];
    saveBn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [saveBn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBn];
}
-(void)back:(id)sender
{
    [self.view endEditing:YES];
    self.diaryNote = nil;
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
-(void)save:(id)sender
{
    if ([self.titleField.text length] == 0)
    {
        [MBProgressHUD showError:LocalString(@"The title can not be blank")];
        return ;
    }
    [self.pickerView hiddenDatePickerView];
    [self.view endEditing:YES];
    self.diaryNote.title = self.titleField.text;
    self.diaryNote.content = self.detailView.text;
    self.diaryNote.weather = self.weatherField.text;
    self.diaryNote.mood = self.moodField.text;
    [self.diaryNote insertNote:self.diaryNote];
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
-(void)didCancelSelectDate
{
    self.dateLabel.text = self.originalDate;
}
-(void)didSaveDate
{
    self.dateLabel.text = [self.pickerView getNowDatePicker:@"MMdd HH:mm"];
    self.diaryNote.time = [self.pickerView getNowDatePicker:@"yyyyMMdd HH:mm"];
}
-(void)didDateChangeTo
{
    self.dateLabel.text = [self.pickerView getNowDatePicker:@"MMdd HH:mm"];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.pickerView hiddenDatePickerView];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self.pickerView hiddenDatePickerView];
}
@end
