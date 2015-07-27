#import "ViewController.h"
#import "Calendar.h"
#import "ALView+PureLayout.h"
#import <EventKit/EventKit.h>


#define SMALL_FONT_SIZE 20
#define HUGE_FONT_SIZE 60

@implementation ViewController {
    NSArray *_availableCalendars;
    UILabel *_resultLabel;
    UITextField *_startDateTextField;
    UIDatePicker *_startDatePicker;
    UIDatePicker *_endDatePicker;
    UIPickerView *_calendarPickerView;
    UITextField *_endDateTextField;
    UITextField *_calendarTextField;
    Calendar *_calendar;
    UILabel *_maxHoursLabel;
}


- (void)loadView {
    [super loadView];
    [self setupView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _availableCalendars.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    EKCalendar *calendar = _availableCalendars[row];
    return calendar.title;
}

- (void)setupView {
    UIFont *standardFont = [UIFont fontWithName:@"Helvetica" size:SMALL_FONT_SIZE];
    UIFont *hugeFont = [UIFont fontWithName:@"Helvetica" size:HUGE_FONT_SIZE];
    _calendar = [Calendar new];
    _availableCalendars = [_calendar availableCalendars];

    _startDatePicker = [UIDatePicker new];
    _startDatePicker.datePickerMode = UIDatePickerModeDate;

    _endDatePicker = [UIDatePicker new];
    _endDatePicker.datePickerMode = UIDatePickerModeDate;

    _calendarPickerView = [UIPickerView new];
    _calendarPickerView.dataSource = self;
    _calendarPickerView.delegate = self;

    _startDateTextField = [self createTextField:_startDatePicker placeholder:@"starts..." toolbar:[self toolbarForStartDate]];
    [self.view addSubview:_startDateTextField];

    _endDateTextField = [self createTextField:_endDatePicker placeholder:@"ends..." toolbar:[self toolbarForEndDate]];
    [self.view addSubview:_endDateTextField];

    _calendarTextField = [self createTextField:_calendarPickerView placeholder:@"calendar..." toolbar:[self toolbarForCalendars]];
    [self.view addSubview:_calendarTextField];

    UIButton *countButton = [self createCountButton];
    [self.view addSubview:countButton];

    _resultLabel = [self createLabelWithFont:hugeFont text:@"0:00"];
    [self.view addSubview:_resultLabel];

    _maxHoursLabel = [self createLabelWithFont:hugeFont text:@"0:00"];
    [self.view addSubview:_maxHoursLabel];

    UILabel *calendarNameLabel = [self createLabelWithFont:standardFont text:@"Calendar name:"];
    [self.view addSubview:calendarNameLabel];

    UILabel *startDateLabel = [self createLabelWithFont:standardFont text:@"Start date:"];
    [self.view addSubview:startDateLabel];

    UILabel *endDateLabel = [self createLabelWithFont:standardFont text:@"End date:"];
    [self.view addSubview:endDateLabel];

    [calendarNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [calendarNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];

    [_calendarTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:calendarNameLabel withOffset:15];
    [_calendarTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];

    [startDateLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [startDateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_calendarTextField withOffset:25];

    [_startDateTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:startDateLabel withOffset:15];
    [_startDateTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_calendarTextField withOffset:25];

    [endDateLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [endDateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_startDateTextField withOffset:25];

    [_endDateTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:endDateLabel withOffset:15];
    [_endDateTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_startDateTextField withOffset:25];

    [countButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_endDateTextField withOffset:25];
    [countButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [countButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [countButton autoSetDimension:ALDimensionHeight toSize:50];
    countButton.backgroundColor = [UIColor colorWithRed:0.28 green:0.83 blue:0.60 alpha:1.0];

    [_resultLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_resultLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:countButton withOffset:25];

    [_maxHoursLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_maxHoursLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_resultLabel withOffset:25];

    UILabel *eventHoursLabel = [self createLabelWithFont:standardFont text:@"Event:"];
    [self.view addSubview:eventHoursLabel];
    UILabel *maxLabel = [self createLabelWithFont:standardFont text:@"Max:"];
    [self.view addSubview:maxLabel];

    [eventHoursLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [eventHoursLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_resultLabel];

    [maxLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [maxLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_maxHoursLabel];
}

- (UILabel *)createLabelWithFont:(UIFont *)font text:(NSString *)text {
    UILabel *label = [UILabel new];
    label.font = font;
    label.text = text;
    return label;
}

- (UIButton *)createCountButton {
    UIButton *countButton = [UIButton new];
    [countButton setTitle:@"Count" forState:UIControlStateNormal];
    [countButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [countButton addTarget:self action:@selector(countTime) forControlEvents:UIControlEventTouchUpInside];
    return countButton;
}

- (UITextField *)createTextField:(UIPickerView *)picker placeholder:(NSString *)placeholder toolbar:(UIToolbar *)toolbar {
    UIFont *standardFont = [UIFont fontWithName:@"Helvetica" size:SMALL_FONT_SIZE];
    UITextField *textField = [UITextField new];
    textField.font = standardFont;
    textField.placeholder = placeholder;
    textField.inputView = picker;
    textField.inputAccessoryView = toolbar;
    return textField;
}


- (UIToolbar *)toolbarForStartDate {
    return [self createToolbarWithButtonSelector:@selector(didSelectStartDate)];
}

- (UIToolbar *)toolbarForEndDate {
    return [self createToolbarWithButtonSelector:@selector(didSelectEndDate)];

}

- (UIToolbar *)toolbarForCalendars {
    return [self createToolbarWithButtonSelector:@selector(didSelectCalendar)];
}

- (UIToolbar *)createToolbarWithButtonSelector:(SEL)selector {
    CGFloat width = [UIApplication sharedApplication].delegate.window.frame.size.width;
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self action:selector];
    [myToolbar setItems:@[doneButton] animated:NO];
    return myToolbar;
}

- (void)didSelectStartDate {
    [_startDateTextField resignFirstResponder];
    NSDate *pickedDate = _startDatePicker.date;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy/MM/dd";
    _startDateTextField.text = [formatter stringFromDate:pickedDate];
}

- (void)didSelectEndDate {
    [_endDateTextField resignFirstResponder];
    NSDate *pickedDate = _endDatePicker.date;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy/MM/dd";
    _endDateTextField.text = [formatter stringFromDate:pickedDate];
}

- (void)didSelectCalendar {
    [_calendarTextField resignFirstResponder];
    EKCalendar *calendar = _availableCalendars[(NSUInteger) [_calendarPickerView selectedRowInComponent:0]];

    _calendarTextField.text = calendar.title;
}

- (void)countTime {
    EKCalendar *calendarName = _availableCalendars[(NSUInteger) [_calendarPickerView selectedRowInComponent:0]];
    NSDate *startDate = _startDatePicker.date;
    NSDate *endDate = _endDatePicker.date;

    NSTimeInterval timeInterval = [_calendar durationOfEventsInCalendar:calendarName fromDate:startDate toDate:endDate];

    NSInteger hours = (NSInteger) (timeInterval / 3600);
    NSInteger minutes = (NSInteger) ((timeInterval - hours * 3600) / 60);

    if (minutes < 10) {
        _resultLabel.text = [NSString stringWithFormat:@"%d:0%d", hours, minutes];

    } else {
        _resultLabel.text = [NSString stringWithFormat:@"%d:%d", hours, minutes];
    }

    NSInteger workingDays = [_calendar workingDaysBetweenStartDate:startDate andEndDate:endDate];

    _maxHoursLabel.text = [NSString stringWithFormat:@"%d:00", workingDays * 8];
}


@end