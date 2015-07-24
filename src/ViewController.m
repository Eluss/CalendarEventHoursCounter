#import "ViewController.h"
#import "Calendar.h"
#import "ALView+PureLayout.h"
#import <EventKit/EventKit.h>

@interface ViewController ()

@end

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
    UIFont *standardFont = [UIFont fontWithName:@"Helvetica" size:20];
    UIFont *hugeFont = [UIFont fontWithName:@"Helvetica" size:60];
    _calendar = [Calendar new];
    _availableCalendars = [_calendar availableCalendars];

    _startDatePicker = [UIDatePicker new];
    _startDatePicker.datePickerMode = UIDatePickerModeDate;

    _endDatePicker = [UIDatePicker new];
    _endDatePicker.datePickerMode = UIDatePickerModeDate;

    _calendarPickerView = [UIPickerView new];
    _calendarPickerView.dataSource = self;
    _calendarPickerView.delegate = self;

    _startDateTextField = [UITextField new];
    _startDateTextField.font = standardFont;
    [self.view addSubview:_startDateTextField];
    _startDateTextField.placeholder = @"starts...";
    _startDateTextField.inputView = _startDatePicker;
    _startDateTextField.inputAccessoryView = [self toolbarForStartDate];

    _endDateTextField = [UITextField new];
    _endDateTextField.font = standardFont;
    [self.view addSubview:_endDateTextField];
    _endDateTextField.placeholder = @"ends....";
    _endDateTextField.inputView = _endDatePicker;
    _endDateTextField.inputAccessoryView = [self toolbarForEndDate];

    _calendarTextField = [UITextField new];
    _calendarTextField.font = standardFont;
    [self.view addSubview:_calendarTextField];
    _calendarTextField.placeholder = @"calendar...";
    _calendarTextField.inputView = _calendarPickerView;
    _calendarTextField.inputAccessoryView = [self toolbarForCalendars];

    UIButton *countButton = [UIButton new];
    [self.view addSubview:countButton];
    [countButton setTitle:@"Count" forState:UIControlStateNormal];
    [countButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [countButton addTarget:self action:@selector(countTime) forControlEvents:UIControlEventTouchUpInside];

    _resultLabel = [UILabel new];
    [self.view addSubview:_resultLabel];
    _resultLabel.font = hugeFont;
    _resultLabel.text = @"0:0";

    UILabel *calendarNameLabel = [UILabel new];
    calendarNameLabel.font = standardFont;
    [self.view addSubview:calendarNameLabel];
    calendarNameLabel.text = @"Calendar name:";

    UILabel *startDateLabel = [UILabel new];
    startDateLabel.font = standardFont;
    [self.view addSubview:startDateLabel];
    startDateLabel.text = @"Start date:";

    UILabel *endDateLabel = [UILabel new];
    endDateLabel.font = standardFont;
    [self.view addSubview:endDateLabel];
    endDateLabel.text = @"End date:";


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


}




- (UIToolbar *)toolbarForStartDate {
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self action:@selector(didSelectStartDate)];

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

- (UIToolbar *)toolbarForEndDate {
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self action:@selector(didSelectEndDate)];

    [myToolbar setItems:@[doneButton] animated:NO];
    return myToolbar;
}

- (void)didSelectEndDate {
    [_endDateTextField resignFirstResponder];
    NSDate *pickedDate = _endDatePicker.date;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy/MM/dd";
    _endDateTextField.text = [formatter stringFromDate:pickedDate];
}

- (UIToolbar *)toolbarForCalendars {
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self action:@selector(didSelectCalendar)];

    [myToolbar setItems:@[doneButton] animated:NO];
    return myToolbar;
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

    _resultLabel.text = [NSString stringWithFormat:@"%d:%d", hours, minutes];
}


@end