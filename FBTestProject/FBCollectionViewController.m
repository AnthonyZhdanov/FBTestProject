//
//  CollectionViewController.m
//  FBTestProject
//
//  Created by BRABUS on 1/6/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import "FBCollectionViewController.h"
#import "GalleryCollectionViewCell.h"
#import "FBGalleryItem.h"
#import "FBTableViewController.h"
#import "WebServices.h"

static const CGFloat kCollectionViewInset = 10;

@interface FBCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addNewImageButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewGallery;
@property (weak, nonatomic) UIImage *userImage;
@property (strong, nonatomic) WebServices *webServices;

@end

@implementation FBCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", self.groupImages);
    self.webServices = [WebServices new];
    self.navigationItem.title = self.groupName;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItems = 0;
    if (self.groupImages) {
        numberOfItems = self.groupImages.count;
    }
    else {
        // To show our "noImage" picture
        numberOfItems = 1;
    }
    return numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"images" forIndexPath:indexPath];

    [cell.downloadingActivityIndicator setHidesWhenStopped:YES];
    if (self.groupImages) {
        // Show indicator while image downloading
        [cell.downloadingActivityIndicator startAnimating];
        NSString *pathToImage = self.groupImages[indexPath.row];
        [cell.galleryElementImageView sd_setImageWithURL:[NSURL URLWithString:pathToImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell.downloadingActivityIndicator stopAnimating];
        }];
//        No need to to like below (as bonus SDWebImage caches images by itself)
//        [self.webServices loadDataByPath:pathToImage withCompletionBlock:^(NSData *data, NSError *error) {
//            if (error) {
//                NSLog(@"%@", error);
//            }
//            else {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    cell.galleryElementImageView.image = [UIImage imageWithData:data];
//                    [cell.downloadingActivityIndicator stopAnimating];
//                });
//            }
//        }];
    }
    else {
        cell.galleryElementImageView.image = [UIImage imageNamed:@"noImage"];
    }
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Calculation size of our item
    CGFloat itemWidth = ((collectionView.frame.size.width - (kCollectionViewInset * 3)) / 2);
    CGFloat itemHeight = ((collectionView.frame.size.height - (kCollectionViewInset * 3)) / 5);
    CGSize size = CGSizeMake(itemWidth, itemHeight);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kCollectionViewInset, kCollectionViewInset, kCollectionViewInset, kCollectionViewInset);
}

- (IBAction)addImageButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // Some settings for picker controller navigationBar
    picker.navigationBar.tintColor = [UIColor blackColor];
    picker.navigationBar.barStyle = UIBarStyleBlack;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo
                             :(NSDictionary<NSString *,id> *)info {
    UIImage *tempImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    // Resizing our image to optimal size
    UIImage *newImage = [self resizeImage:tempImage toSize:CGSizeMake((tempImage.size.width / 2), (tempImage.size.height / 2))];
    //uploading image througth webServices
    [self.webServices uploadDataToFirebaseStorage:newImage folderName:self.groupName withcompletionBlock:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            NSString *pathToGetImage = [NSString stringWithFormat: @"%@", metadata.downloadURL];
            NSMutableArray *updatedArrayOfImages = [NSMutableArray arrayWithArray:self.groupImages];
            [updatedArrayOfImages addObject:pathToGetImage];
            [self.webServices addImagesInFirebaseDatabaseByIndex:self.indexOfGroupe arrayOfImagesURLs:updatedArrayOfImages];
            [self reloadViewControllerWithNewData:updatedArrayOfImages];
            // When image was selected
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.dissmissBlock)
            {
                // tell to FBTableViewController that something have been changed
                self.dissmissBlock(updatedArrayOfImages);
            }
        }
    }];
}

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)reloadViewControllerWithNewData:(NSArray *)arrayOfimageURLs {
    self.groupImages = arrayOfimageURLs;
    [self.collectionViewGallery reloadData];
}

@end
