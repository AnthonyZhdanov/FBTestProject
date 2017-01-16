//
//  AddNewSectionViewController.m
//  FBTestProject
//
//  Created by BRABUS on 12/26/16.
//  Copyright © 2016 Anthony Zhdanov. All rights reserved.
//

#import "AddNewSectionViewController.h"

NSString *const kSectionsListNameKey = @"name";

@interface AddNewSectionViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *enterNameOfSectionTextField;
@property (weak, nonatomic) IBOutlet UIButton *buttonToAddSection;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end

@implementation AddNewSectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonToAddSection.hidden = YES;
    self.enterNameOfSectionTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Simple chech of entered data
    if (self.enterNameOfSectionTextField.text.length == 0 && self.enterNameOfSectionTextField.text.length < 1) {
        self.buttonToAddSection.hidden = YES;
    }
    else {
        self.enterNameOfSectionTextField.userInteractionEnabled = NO;
        self.buttonToAddSection.hidden = NO;
    }
    return YES;
}

- (IBAction)saveChanges:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Make entered text Capitalized
    NSDictionary *sectionsList = @{kSectionsListNameKey : [self.enterNameOfSectionTextField.text capitalizedString]};
    if (self.dissmissBlock)
    {
        self.dissmissBlock(sectionsList);
    }
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
