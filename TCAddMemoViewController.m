#import "TCAddMemoViewController.h"
#import "TCDatePickerView.h"
#import "TCMemo.h"
#import "MBProgressHUD+MJ.h"
#import "TCYearPickerView.h"
#import "DHDeviceUtil.h"
#import "ICLanguageTool.h"
@interface TCAddMemoViewController ()<UITextFieldDelegate,TCDatePickerViewDelegate, TCYearPickerViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property (nonatomic, weak) UITextField * titleField;
@property (nonatomic, weak) UITextView * detailView;
@property (nonatomic, weak) UITextField * memotypeF;
@property (nonatomic, weak) UILabel * yearL;
@property (nonatomic, weak) UILabel * timeL;
@property (nonatomic, strong) TCDatePickerView * pickerView;
@property (nonatomic, strong) TCYearPickerView * yearPickerV;
@property (nonatomic, strong) TCMemo * memoNote;
@property (nonatomic, strong) NSMutableArray * yearArray;
@end
@implementation TCAddMemoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self topColor];
    [self titleFileds];
    [self detailViews];
    [self backBtn];
    [self saveBtn];
    [self showTime];
    [self showYear];
    [self showMemoType];
    self.pickerView = [TCDatePickerView initWithPicker:self.view.frame];
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
    self.yearPickerV = [TCYearPickerView initWithPicker:self.view.frame];
    self.yearPickerV.delegate = self;
    [self.view addSubview:self.yearPickerV];
    self.yearPickerV.yearPickers.delegate = self;
    self.yearPickerV.yearPickers.dataSource = self;
}
-(TCMemo *)memoNote
{
    if (_memoNote == nil)
    {
        _memoNote = [[TCMemo alloc]init];
    }
    return _memoNote;
}
-(NSMutableArray *)yearArray
{
    if (_yearArray == nil)
    {
        _yearArray = [NSMutableArray array];
        for (int j = 0; j < 100; j ++)
        {
            NSString * yearStr = [NSString stringWithFormat:@"2%03dY",j];
            [self.yearArray addObject:yearStr];
        }
    }
    return _yearArray;
}
-(void)topColor
{
     CGFloat top = TopBarHeight;
    UIView * topColor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, top)];
    topColor.backgroundColor  = TCBgColor;
    [self.view addSubview:topColor];
}
-(void)titleLabel
{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,StatueBarHeight, 100, 44)];
    titleLabel.center = CGPointMake(self.view.frame.size.width /2,StatueBarHeight);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = LocalString(@"Memo");
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
}
-(void)titleFileds
{
    CGFloat top = StatueBarHeight+20;
    UITextField * titleField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 125, 44)];
    titleField.center = CGPointMake(self.view.frame.size.width /2+10, top);
    titleField.font = [UIFont boldSystemFontOfSize:16];
    titleField.placeholder = LocalString(@"Memo title");
    titleField.textAlignment = NSTextAlignmentCenter;
    titleField.clearButtonMode =UITextFieldViewModeWhileEditing;
    [titleField becomeFirstResponder];
    self.titleField = titleField;
    [self.view addSubview:titleField];
}
-(void)detailViews
{
    CGFloat top = 120 + (MACRO_IS_IPHONE_X ? 14 : 0);
    UITextView * detailView =[[UITextView alloc]initWithFrame:CGRectMake(10, top, self.view.frame.size.width - 20, self.view.frame.size.height - top)];
    detailView.font = [UIFont systemFontOfSize:18];
    detailView.alwaysBounceVertical = YES;
    self.detailView = detailView;
    self.detailView.delegate = self;
    detailView.text = @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
    [self.view addSubview:detailView];
}
-(void)showYear
{
    CGFloat top = 93 + (MACRO_IS_IPHONE_X ? 14 : 0);
    UILabel * yearL = [[UILabel alloc]initWithFrame:CGRectMake(10, top, 60, 15)];
    yearL.font = [UIFont systemFontOfSize:16];
    yearL.textAlignment = NSTextAlignmentCenter;
    yearL.text = [TCDatePickerView getNowDateFormat:@"yyyy"];
    self.yearL = yearL;
    [self.view addSubview:yearL];
    self.memoNote.year = yearL.text;
    UIButton * touchYearL = [[UIButton alloc]initWithFrame:CGRectMake(10, top, 60, 15)];
    [touchYearL addTarget:self action:@selector(showYearPicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touchYearL];
}
-(void)showYearPicker
{
    [self.pickerView hiddenDatePickerView];
    [self.yearPickerV popYearPickerView];
    NSString * yearRow = [TCDatePickerView getNowDateFormat:@"yy"];
    [self.yearPickerV.yearPickers selectRow:[yearRow intValue] inComponent:0 animated:YES];
   [self.view endEditing:YES];
}
-(void)showTime
{
    CGFloat top = 93 + (MACRO_IS_IPHONE_X ? 14 : 0);
    UILabel * timeL =[[UILabel alloc]initWithFrame:CGRectMake(70, top, 120, 15)];
    timeL.text = [TCDatePickerView getNowDateFormat:@"MMdd HH:mm"];
    timeL.font = [UIFont systemFontOfSize:16];
    self.timeL = timeL;
    [self.view addSubview:timeL];
    self.memoNote.time = timeL.text;
    UIButton * touchLabel = [[UIButton alloc]initWithFrame:CGRectMake(70, top, 120, 15)];
    [touchLabel addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touchLabel];
}
-(void)showPicker
{
    [self.yearPickerV hiddenYearPickerView];
    [self.pickerView popDatePickerView];
    [self.pickerView resetToZero];
    [self.view endEditing:YES];
}
-(void)showMemoType
{
    CGFloat top = 93 + (MACRO_IS_IPHONE_X ? 14 : 0);
    UITextField * memotypeF = [[UITextField alloc]initWithFrame:CGRectMake(190, top, self.view.frame.size.width - 190, 20)];
    memotypeF.font = [UIFont systemFontOfSize:16];
    memotypeF.placeholder = LocalString(@"Memo type");
    memotypeF.textAlignment = NSTextAlignmentCenter;
    memotypeF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.memotypeF = memotypeF;
    [self.view addSubview:memotypeF];
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
    self.memoNote = nil;
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
    [self.yearPickerV hiddenYearPickerView];
    [self.view endEditing:YES];
    self.memoNote.title = self.titleField.text;
    self.memoNote.content = self.detailView.text;
    self.memoNote.memotype = self.memotypeF.text;
    [self.memoNote insertNote:self.memoNote];
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
-(void)didCancelSelectDate
{
    self.timeL.text = self.memoNote.time;
}
-(void)didSaveDate
{
    self.memoNote.time = self.timeL.text;
}
-(void)didDateChangeTo
{
    self.timeL.text = [self.pickerView getNowDatePicker:@"MMdd HH:mm"];
}
-(void)didCancelSelectYear
{
    self.yearL.text = self.memoNote.year;
}
-(void)didSaveYear
{
    self.memoNote.year = self.yearL.text;
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
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.yearArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.yearArray objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.yearL.text = [self.yearArray objectAtIndex:row];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self.pickerView hiddenDatePickerView];
    [self.yearPickerV hiddenYearPickerView];
}
@end
