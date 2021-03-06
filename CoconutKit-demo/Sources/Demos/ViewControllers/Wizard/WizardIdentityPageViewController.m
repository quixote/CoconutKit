//
//  WizardIdentityPageViewController.m
//  CoconutKit-demo
//
//  Created by Samuel Défago on 2/28/11.
//  Copyright 2011 Hortis. All rights reserved.
//

#import "WizardIdentityPageViewController.h"

#import "Person.h"

@interface WizardIdentityPageViewController ()

@property (nonatomic, retain) Person *person;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (UILabel *)errorLabelForTextField:(UITextField *)textField;

@end

@implementation WizardIdentityPageViewController

#pragma mark Object creation and destruction

- (id)init
{
    if ((self = [super initWithNibName:[self className] bundle:nil])) {
        // Only one person in the DB. If does not exist yet, create it
        Person *person = [[Person allObjects] firstObject];
        if (! person) {
            person = [Person insert];
        }
        self.person = person;
    }
    return self;
}

- (void)dealloc
{
    self.person = nil;
    self.dateFormatter = nil;
    
    [super dealloc];
}

- (void)releaseViews
{
    [super releaseViews];
    
    self.firstNameTextField = nil;
    self.firstNameErrorLabel = nil;
    self.lastNameTextField = nil;
    self.lastNameErrorLabel = nil;
    self.emailTextField = nil;
    self.emailErrorLabel = nil;
    self.birthdateLabel = nil;
    self.birthdateTextField = nil;
    self.birthdateErrorLabel = nil;
    self.nbrChildrenTextField = nil;
    self.nbrChildrenErrorLabel = nil;
}

#pragma mark Accessors and mutators

@synthesize person = m_person;

- (void)setPerson:(Person *)person
{
    if (m_person == person) {
        return;
    }
    
    [m_person release];
    m_person = [person retain];
    
    [self reloadData];
}

@synthesize firstNameTextField = m_firstNameTextField;

@synthesize firstNameErrorLabel = m_firstNameErrorLabel;

@synthesize lastNameTextField = m_lastNameTextField;

@synthesize lastNameErrorLabel = m_lastNameErrorLabel;

@synthesize emailTextField = m_emailTextField;

@synthesize emailErrorLabel = m_emailErrorLabel;

@synthesize birthdateLabel = m_birthdateLabel;

@synthesize birthdateTextField = m_birthdateTextField;

@synthesize birthdateErrorLabel = m_birthdateErrorLabel;

@synthesize nbrChildrenTextField = m_nbrChildrenTextField;

@synthesize nbrChildrenErrorLabel = m_nbrChildrenErrorLabel;

@synthesize dateFormatter = m_dateFormatter;

#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.birthdateTextField.delegate = self;
    self.nbrChildrenTextField.delegate = self;
    
    [self reloadData];
}

#pragma mark HLSReloadable protocol implementation

- (void)reloadData
{    
    static NSNumberFormatter *s_numberFormatter = nil;
    if (! s_numberFormatter) {
        s_numberFormatter = [[NSNumberFormatter alloc] init];
        [s_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [s_numberFormatter setAllowsFloats:NO];
    }
    
    [self.firstNameTextField bindToManagedObject:self.person
                                       fieldName:@"firstName" 
                                       formatter:nil
                              validationDelegate:self];
    [self.lastNameTextField bindToManagedObject:self.person
                                      fieldName:@"lastName"
                                      formatter:nil 
                             validationDelegate:self];
    [self.emailTextField bindToManagedObject:self.person
                                   fieldName:@"email" 
                                   formatter:nil 
                          validationDelegate:self];
    [self.emailTextField setCheckingOnChange:YES];
    [self.birthdateTextField bindToManagedObject:self.person
                                       fieldName:@"birthdate"
                                       formatter:self.dateFormatter 
                              validationDelegate:self];
    [self.birthdateTextField setCheckingOnChange:YES];
    [self.nbrChildrenTextField bindToManagedObject:self.person 
                                         fieldName:@"nbrChildren"
                                         formatter:s_numberFormatter 
                                validationDelegate:self];
    [self.nbrChildrenTextField setCheckingOnChange:YES];
    
    // Perform an initial complete validation
    [self checkTextFields];
}

#pragma mark HLSValidable protocol implementation

- (BOOL)validate
{
    return [self checkTextFields];
}

#pragma mark UITextFieldDelegate protocol implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstNameTextField) {
        [self.lastNameTextField becomeFirstResponder];
    }
    else if (textField == self.lastNameTextField) {
        [self.emailTextField becomeFirstResponder];
    }
    else if (textField == self.emailTextField) {
        [self.birthdateTextField becomeFirstResponder];
    }
    else if (textField == self.birthdateTextField) {
        [self.nbrChildrenTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark HLSTextFieldValidationDelegate protocol implementation

- (void)textFieldDidFailFormatting:(UITextField *)textField
{
    textField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
    
    UILabel *errorLabel = [self errorLabelForTextField:textField];
    errorLabel.text = NSLocalizedString(@"Formatting error", @"Formatting error");
}

- (void)textFieldDidPassValidation:(UITextField *)textField
{
    textField.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5f];
    
    UILabel *errorLabel = [self errorLabelForTextField:textField];
    errorLabel.text = nil;
}

- (void)textField:(UITextField *)textField didFailValidationWithError:(NSError *)error
{
    textField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
    
    UILabel *errorLabel = [self errorLabelForTextField:textField];
    errorLabel.text = [error localizedDescription];
}

#pragma mark Retrieving the error label associated with a text field

- (UILabel *)errorLabelForTextField:(UITextField *)textField
{
    if (textField == self.firstNameTextField) {
        return self.firstNameErrorLabel;
    }
    else if (textField == self.lastNameTextField) {
        return self.lastNameErrorLabel;
    }
    else if (textField == self.emailTextField) {
        return self.emailErrorLabel;
    }
    else if (textField == self.birthdateTextField) {
        return self.birthdateErrorLabel;
    }
    else if (textField == self.nbrChildrenTextField) {
        return self.nbrChildrenErrorLabel;
    }
    else {
        HLSLoggerError(@"Unknown text field");
        return nil;
    }
}

#pragma mark Localization

- (void)localize
{
    [super localize];
    
    self.birthdateLabel.text = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"Birthdate", @"Birthdate"), NSLocalizedString(@"yyyy/MM/dd", @"yyyy/MM/dd")];
    
    // The date formatter is also localized!
    // TODO: Does not work yet. Try to switch languages!
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [self.dateFormatter setDateFormat:NSLocalizedString(@"yyyy/MM/dd", @"yyyy/MM/dd")];
    
    // Trigger a new validation to get localized error messages if any
    [self checkTextFields];
}

#pragma mark Event callbacks

- (IBAction)resetModel:(id)sender
{
    // Reset the model programmatically. This shows that the text fields are updated accordingly
    self.person.firstName = nil;
    self.person.lastName = nil;
    self.person.firstName = nil;
    self.person.lastName = nil;
    self.person.email = nil;
    self.person.birthdate = nil;
    self.person.nbrChildrenValue = 0;
}

- (IBAction)resetTextFields:(id)sender
{
    // Reset text fields programmatically. This shows that the model is updated accordingly
    self.firstNameTextField.text = nil;
    self.lastNameTextField.text = nil;
    self.emailTextField.text = nil;
    self.birthdateTextField.text = nil;
    self.nbrChildrenTextField.text = @"0";
}

@end
