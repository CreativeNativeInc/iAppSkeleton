//
//  mSearchViewController.m
//  iAppSkeleton
//
//  Created by Jon Smith on 8/21/15.
//  Copyright (c) 2017 Jon Smith. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 220.0

#import "mSearchViewController.h"
#import "SongListTableViewController.h"
#import "AppDelegate.h"

@interface mSearchViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *confirmSelectionButton;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *searchType;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) NSString *typeString;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) IBOutlet UILabel *searchTitleLabel;
@property (strong, nonatomic) IBOutlet UITextField *searchTitleTextField;

@end

@implementation mSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize Data
    _pickerData = @[@"Artist", @"Song Title", @"Album"];
    
    // Connect data
    self.searchTypePicker.dataSource = self;
    self.searchTypePicker.delegate = self;
    
    // Round button corners!
    _confirmSelectionButton.layer.cornerRadius = 4;
    _confirmSelectionButton.layer.masksToBounds = YES;
    
    //manually set initial a selection!
    [_searchTypePicker selectRow:0 inComponent:0 animated:YES];
    _typeString = @"Artist";
    _searchTitleLabel.text = @"Enter Artist Name";
    
    _searchTitleTextField.delegate = self;
    
    self.navigationItem.title = @"iAppSkeleton m Search";
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    [_searchTypePicker setTintColor:[UIColor whiteColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIPickerView Methods
// The number of columns of data
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickerData count];
}

// The data to return for the row and component (column) that's being passed in
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch(row)
    {
        case 0:
            _typeString = @"Artist";
            _searchTitleLabel.text = @"Enter Artist Name";
            break;
        case 1:
            _typeString = @"Song Title";
            _searchTitleLabel.text = @"Enter Song Title";
            break;
        case 2:
            _typeString = @"Album";
            _searchTitleLabel.text = @"Enter Album Name";
            break;

    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = _pickerData[row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

- (IBAction)searchButtonPressed:(id)sender
{
    _titleString = _searchTitleTextField.text;
    [self performSegueWithIdentifier:@"tomList" sender:self];
    [_searchTitleTextField resignFirstResponder];
}

#pragma mark - Hide keyboard/adjust view methods

// UITextFieldDelegate method that is called when the return key is pressed on the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Dismiss the keyboard
    [textField resignFirstResponder];
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self textFieldDidChange];
}


-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidChange
{
    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[SongListTableViewController class]])
    {
        SongListTableViewController *sltvc = (SongListTableViewController *)segue.destinationViewController;
        
        sltvc.passedTypeString = _typeString;
        sltvc.passedTitleString = _titleString;
    }
    
}


@end
