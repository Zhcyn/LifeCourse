#import "TCEditMemoViewController.h"
#import "TCDatePickerView.h"
#import "TCMemo.h"
#import "MBProgressHUD+MJ.h"
#import "TCYearPickerView.h"
#import "DHDeviceUtil.h"
#import "ICLanguageTool.h"
@interface TCEditMemoViewController ()<TCDatePickerViewDelegate,TCYearPickerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UIScrollViewDelegate>
@property (nonatomic, weak) UITextField * titleField;
@property (nonatomic, weak) UITextView  * detailView;
@property (nonatomic, weak) UITextField * memotypeF;
@property (nonatomic, weak) UILabel * yearL;
@property (nonatomic, weak) UILabel * timeL;
@property (nonatomic, weak) UIView * lineView;
@property (nonatomic, strong) TCMemo * editNote;
@property (nonatomic, strong) TCDatePickerView * pickerView;
@property (nonatomic, strong) TCYearPickerView * yearPickerV;
@property (nonatomic, strong) NSMutableArray * yearArray;
@end
@implementation TCEditMemoViewController
-(TCMemo *)editNote
{
    if (_editNote == nil)
    {
        _editNote = [[TCMemo alloc]init];
    }
    return _editNote;
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
        UITextView * detailView =[[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleField.frame) +5, self.view.frame.size.width - 20, self.view.frame.size.height - 110)];
        detailView.font = [UIFont systemFontOfSize:18];
        self.detailView = detailView;
        self.detailView.delegate = self;
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:LocalString(@"edit") style:UIBarButtonItemStylePlain target:self action:@selector(beginEdit:)];
        rightItem.tintColor = [UIColor whiteColor];
        [self.navigationItem setRightBarButtonItem:rightItem];
        [self showTime];
        self.timeL.hidden = YES;
        [self showYear];
        self.yearL.hidden = YES;
        [self showMemoType];
        self.memotypeF.hidden = YES;
        [self.view addSubview:titleField];
        [self.view addSubview:lienview];
        [self.view addSubview:detailView];
        self.pickerView = [TCDatePickerView initWithPicker:self.view.frame];
        self.pickerView.delegate = self;
        [self.view addSubview:self.pickerView];
        self.yearPickerV = [TCYearPickerView initWithPicker:self.view.frame];
        self.yearPickerV.delegate = self;
        [self.view addSubview:self.yearPickerV];
        self.yearPickerV.yearPickers.delegate = self;
        self.yearPickerV.yearPickers.dataSource = self;
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
            self.timeL.text = self.editNote.time;
            self.yearL.text = self.editNote.year;
            self.memotypeF.text = self.editNote.memotype;
            self.timeL.hidden = NO;
            self.yearL.hidden = NO;
            self.memotypeF.hidden = NO;
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
            self.timeL.hidden = YES;
            self.yearL.hidden = YES;
            self.memotypeF.hidden = YES;
               self.detailView.frame = CGRectMake(10, CGRectGetMaxY(self.titleField.frame) +5, self.view.frame.size.width - 20, self.view.frame.size.height - 110);
            [self.pickerView hiddenDatePickerView];
            [self.yearPickerV hiddenYearPickerView];
            [self.view endEditing:YES];
        } completion:^(BOOL finished)
         {
             self.titleField.enabled = NO;
             self.detailView.editable = NO;
             self.navigationItem.rightBarButtonItem.title = LocalString(@"edit");
             self.editNote.title = self.titleField.text;
             self.editNote.content = self.detailView.text;
             self.editNote.memotype = self.memotypeF.text;
             [self.editNote updataNote:self.editNote];
         }];
    }
}
-(void)showYear
{
    UILabel * yearL = [[UILabel  alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleField.frame) +3, 60, 15)];
    yearL.font = [UIFont systemFontOfSize:16];
    yearL.textAlignment = NSTextAlignmentCenter;
    self.yearL = yearL;
    [self.view addSubview:yearL];
    UIButton * touchYearL = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleField.frame) +3, 60, 15)];
    [touchYearL addTarget:self action:@selector(showYearPicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touchYearL];
}
-(void)showYearPicker
{
    [self.pickerView hiddenDatePickerView];
    [self.yearPickerV popYearPickerView];
    NSRange oldYear;
    oldYear.length = 2;
    oldYear.location = 2;
    [self.yearPickerV.yearPickers selectRow:[[self.editNote.year substringWithRange:oldYear] intValue] inComponent:0 animated:YES];
    [self.view endEditing:YES];
}
-(void)showTime
{
    UILabel * timeL =[[UILabel alloc]initWithFrame:CGRectMake(70, CGRectGetMaxY(self.titleField.frame) +3, 120, 15)];
    timeL.font = [UIFont systemFontOfSize:16];
    self.timeL = timeL;
    [self.view addSubview:timeL];
    UIButton * touchLabel = [[UIButton alloc]initWithFrame:CGRectMake(70, CGRectGetMaxY(self.titleField.frame) +3, 120, 15)];
    [touchLabel addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touchLabel];
}
-(void)showPicker
{
    [self.yearPickerV hiddenYearPickerView];
    [self.pickerView popDatePickerView];
    [self.pickerView popDatePickerView];
    [self.pickerView resetToZero];
    [self.view endEditing:YES];
}
-(void)showMemoType
{
   UITextField * memotypeF = [[UITextField alloc]initWithFrame:CGRectMake(190, CGRectGetMaxY(self.titleField.frame) +3, self.view.frame.size.width - 190, 20)];
    memotypeF.font = [UIFont systemFontOfSize:16];
    memotypeF.placeholder = LocalString(@"Memo type");
    memotypeF.textAlignment = NSTextAlignmentCenter;
    memotypeF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.memotypeF = memotypeF;
    [self.view addSubview:memotypeF];
}
-(void)didCancelSelectDate
{
    self.timeL.text = self.editNote.time;
}
-(void)didSaveDate
{
    self.editNote.time = self.timeL.text;
}
-(void)didDateChangeTo
{
    self.timeL.text = [self.pickerView getNowDatePicker:@"MMdd HH:mm"];
}
-(void)didCancelSelectYear
{
    self.yearL.text = self.editNote.year;
}
-(void)didSaveYear
{
    self.editNote.year = self.yearL.text;
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
