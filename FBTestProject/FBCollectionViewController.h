//
//  CollectionViewController.h
//  FBTestProject
//
//  Created by BRABUS on 1/6/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBGalleryItem.h"

typedef void (^DissmissCollectionViewControllerBlockBlock)(NSArray *updatedArrayOfImages);

@interface FBCollectionViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSArray *groupImages;
@property (strong, nonatomic) NSString *groupName;
@property int indexOfGroupe;

@property (copy, nonatomic) DissmissCollectionViewControllerBlockBlock dissmissBlock;

@end
