//
//  AddNewSectionViewController.h
//  FBTestProject
//
//  Created by BRABUS on 12/26/16.
//  Copyright © 2016 Anthony Zhdanov. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kSectionsListNameKey;

typedef void (^DissmissAddNewSectionViewControllerBlock)(NSDictionary *sectionsList);

@interface AddNewSectionViewController : UIViewController

@property (copy, nonatomic) DissmissAddNewSectionViewControllerBlock dissmissBlock;

@end
