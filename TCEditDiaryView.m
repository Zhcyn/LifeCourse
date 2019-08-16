#import "TCEditDiaryView.h"
#import "TCDiary.h"
#import "TCDatePickerView.h"
#import "MBProgressHUD+MJ.h"
#import "DHDeviceUtil.h"
#import "ICLanguageTool.h"
@interface TCEditDiaryView ()<TCDatePickerViewDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property (nonatomic, weak) UITextField * titleField;
@property (nonatomic, weak) UITextView * detailView;
@property (nonatomic, weak) UIView * lineView;
@property (nonatomic, strong) TCDiary * editNote;
@property (nonatomic, weak) UILabel * dateLabel;
@property (nonatomic, strong) TCDatePickerView * pickerView;
@property (nonatomic, weak) UITextField * weatherField;
@property (nonatomic, weak) UITextField * moodField;
@property (nonatomic, copy) NSString * originalDate;
@end
@implementation TCEditDiaryView
-(TCDiary *)editNote
{
    if (_editNote == nil)
    {
        _editNote = [[TCDiary alloc]init];
    }
    return _editNote;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGFloat top = 70 + (MACRO_IS_IPHONE_X ? 24 : 0);
        UITextField * titleField = [[UITextField alloc]initWithFrame:CGRectMake(10, top, self.view.frame.size.width - 20, 35)];
        titleField.font = [UIFont boldSystemFontOfSize:23];
        titleField.textAlignment = NSTextAlignmentCenter;
        titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.titleField = titleField;
        UIView *lienview=[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleField.frame)+4, self.view.frame.size.width - 20, 1)];
        lienview.backgroundColor=[DHDeviceUtil colorWithHexString:@"#eeeeee"];
        lienview.hidden=YES;
        self.lineView=lienview;
        UITextView * detailView = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleField.frame) +5, self.view.frame.size.width - 20, self.view.frame.size.height - (CGRectGetMaxY(titleField.frame) +5))];
        detailView.font = [UIFont systemFontOfSize:18];
        detailView.layer.masksToBounds = YES;
        detailView.alwaysBounceVertical = YES;
        self.detailView = detailView;
        self.detailView.delegate = self;
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:LocalString(@"edit") style:UIBarButtonItemStylePlain target:self action:@selector(beginEdit:)];
        rightItem.tintColor = [UIColor whiteColor];
        [self.navigationItem setRightBarButtonItem:rightItem];
        [self showdateLabel];
        self.dateLabel.hidden = YES;
        [self showWeather];
        self.weatherField.hidden = YES;
        [self showMood];
        self.moodField.hidden = YES;
        [self.view addSubview:titleField];
        [self.view addSubview:detailView];
        self.pickerView = [TCDatePickerView initWithPicker:self.view.frame];
        self.pickerView.delegate = self;
        [self.view addSubview:self.pickerView];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.editNote = [self.editNote queryOneNote:self.ids];
    self.titleField.text = self.editNote.title;
    self.detailView.text = self.editNote.content;
    self.titleField.enabled = NO;
    self.detailView.editable = NO;
}
-(void)beginEdit:(id)sender
{
    if ([[sender title] isEqualToString:LocalString(@"edit")])
    {
        [UIImageView animateWithDuration:0.3 animations:^{
            self.lineView.frame=CGRectMake(10, CGRectGetMaxY(self.titleField.frame) +30, self.view.frame.size.width - 20,1);
            self.lineView.hidden=NO;
            self.detailView.frame = CGRectMake(10, CGRectGetMaxY(self.titleField.frame) +31, self.view.frame.size.width - 20, self.view.frame.size.height - 135);
            self.dateLabel.text = [self.editNote.time substringFromIndex:5];
            self.weatherField.text = self.editNote.weather;
            self.moodField.text = self.editNote.mood;
            self.dateLabel.hidden = NO;
            self.weatherField.hidden = NO;
            self.moodField.hidden = NO;
        } completion:^(BOOL finished)
        {
            self.titleField.enabled = YES;
            self.detailView.editable = YES;
            [self.titleField becomeFirstResponder];
            self.navigationItem.rightBarButtonItem.title = LocalString(@"save");
        }];
    }
    else 
    {
        if ([self.titleField.text length] == 0)
        {
            [MBProgressHUD showError:LocalString(@"The title can not be blank")];
            return ;
        }
        [UIImageView animateWithDuration:0.3 animations:^{
            self.lineView.hidden=YES;
            self.dateLabel.hidden = YES;
            self.weatherField.hidden = YES;
            self.moodField.hidden = YES;
            self.detailView.frame = CGRectMake(10, CGRectGetMaxY(self.titleField.frame) +5, self.view.frame.size.width - 20, self.view.frame.size.height - 110);
            [self.pickerView hiddenDatePickerView];
            [self.view endEditing:YES];
        } completion:^(BOOL finished)
        {
            self.titleField.enabled = NO;
            self.detailView.editable = NO;
            self.navigationItem.rightBarButtonItem.title = LocalString(@"edit");
            self.editNote.title = self.titleField.text;
            self.editNote.content = self.detailView.text;
            self.editNote.weather = self.weatherField.text;
            self.editNote.mood = self.moodField.text;
            [self.editNote updataNote:self.editNote];
        }];
    }
}
-(void)showdateLabel
{
    UILabel * dateLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleField.frame) +5, 120, 15)];
    dateLabel.font = [UIFont systemFontOfSize:16];
    self.dateLabel = dateLabel;
    [self.view addSubview:dateLabel];
    UIButton * touchLabel = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleField.frame) +5, 120, 20)];
    [touchLabel addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
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
    UITextField * weatherField = [[UITextField alloc]initWithFrame:CGRectMake(130, CGRectGetMaxY(self.titleField.frame) +3,  (self.view.frame.size.width -135)/ 2, 20)];
    weatherField.font = [UIFont systemFontOfSize:16];
    weatherField.placeholder = LocalString(@"weather");
    weatherField.textAlignment = NSTextAlignmentCenter;
    weatherField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.weatherField = weatherField;
    [self.view addSubview:weatherField];
}
-(void)showMood
{
    UITextField * moodField = [[UITextField alloc]initWithFrame:CGRectMake( 135 +(self.view.frame.size.width -135)/ 2, CGRectGetMaxY(self.titleField.frame) +3, (self.view.frame.size.width -135)/ 2, 20)];
    moodField.font = [UIFont systemFontOfSize:16];
    moodField.placeholder = LocalString(@"mood");
    moodField.textAlignment = NSTextAlignmentCenter;
    moodField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.moodField = moodField;
    [self.view addSubview:moodField];
}
-(void)didCancelSelectDate
{
    self.dateLabel.text = self.originalDate;
}
-(void)didSaveDate
{
    self.dateLabel.text = [self.pickerView getNowDatePicker:@"MMdd HH:mm"];
    self.editNote.time = [self.pickerView getNowDatePicker:@"yyyyMMdd HH:mm"];
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
