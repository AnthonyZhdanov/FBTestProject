//
//  ViewController.m
//  FBTestProject
//
//  Created by BRABUS on 12/25/16.
//  Copyright © 2016 Anthony Zhdanov. All rights reserved.
//

#import "FBTableViewController.h"
#import "SectionNamesTableViewCell.h"
#import "AddNewSectionViewController.h"
#import "FBGalleryItem.h"
#import "FBCollectionViewController.h"
#import "WebServices.h"

NSString *const ksectionsPlistName = @"sections";
@interface FBTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *sectionsArray;
@property (nonatomic, assign) NSInteger chosenCellIndex;
@property (weak, nonatomic) IBOutlet UITableView *tableViewGallery;
@property (strong, nonatomic) WebServices *webServices;
@property (weak, nonatomic) IBOutlet UIImageView *hideEverythingImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *firstStartActivityIndicator;

@end

@implementation FBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Activity indicator while downloading data from database first time
    [self.firstStartActivityIndicator setHidesWhenStopped:YES];
    [self.firstStartActivityIndicator startAnimating];
    self.webServices = [WebServices new];
    //Loading database and then starting to create objects with names of groupes and images(URLs)
    [self.webServices loadFirebaseDatabaseWithCompletionBlock:^(NSArray *array) {
        [self createFBGalleryItems:array];
    }];
}
// Generation of segues to another viewControllers
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addNewSection"])
    {
        AddNewSectionViewController *addNewSection = segue.destinationViewController;
        // block to catch needed changes on that controller (alternative to delegate)
        addNewSection.dissmissBlock = ^(NSDictionary *sectionsList)
        {
            // Updating data to show changes on main view
            FBGalleryItem *section = [[FBGalleryItem alloc]initWithName:sectionsList[@"name"]arrayOfImageNames:sectionsList[@"images"]];
            NSMutableArray *mutableArrayWithSections = [self.sectionsArray mutableCopy];
            [mutableArrayWithSections addObject:section];
            self.sectionsArray = [mutableArrayWithSections copy];
            [self.tableViewGallery reloadData];
            //start of updating database in firebase
            NSString *index = [NSString stringWithFormat:@"%i", ((int)self.sectionsArray.count - 1)];
            NSString *newNameOfGroup = [[self.sectionsArray lastObject] sectionName];
            [self.webServices addNewGroupFirebaseDatabase:newNameOfGroup indexForNewGroup:index];
        };
    }
    else if ([segue.identifier isEqualToString:@"showPhotosInGroupe"])
    {
        FBCollectionViewController *collectionViewGallery = segue.destinationViewController;
        // index is needed to update correct folder in database and storage with photos
        int index = (int)self.chosenCellIndex;
        FBGalleryItem *section = self.sectionsArray[index];
        collectionViewGallery.indexOfGroupe = index;
        collectionViewGallery.groupName = section.sectionName;
        collectionViewGallery.groupImages = section.arrayOfImages;
        // same block as abowe but here we update all data from internet if some changes were made
        collectionViewGallery.dissmissBlock = ^(NSArray *updatedArrayOfImages)
        {
            [self.webServices loadFirebaseDatabaseWithCompletionBlock:^(NSArray *array) {
                [self createFBGalleryItems:array];
            }];
        };
    }
}
#pragma mark - Private
- (void)createFBGalleryItems:(NSArray *)array {
    NSMutableArray *mutableArrayWithSections = [NSMutableArray new];
    for (NSDictionary *sectionsList in array)
    {
        FBGalleryItem *section = [[FBGalleryItem alloc]initWithName:sectionsList[@"name"]arrayOfImageNames:sectionsList[@"images"]];
        [mutableArrayWithSections addObject:section];
        self.sectionsArray = [mutableArrayWithSections copy];
    }
    [self.tableViewGallery reloadData];
    [self.firstStartActivityIndicator stopAnimating];
    // It could be launch screen that hides after data downloaded
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hideEverythingImageView.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const kCellIdentifier = @"sectionNames";
    SectionNamesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    cell.sectionNamesGalleryTheme.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.downloadingActivityIndicator setHidesWhenStopped:YES];
    FBGalleryItem *section = self.sectionsArray[indexPath.row];
    cell.sectionNamesLabel.text = section.sectionName;
    // if we got some data in array of image of URLs:
    if (section.arrayOfImages) {
        // Show activity indicator while image downloading from storage
        [cell.downloadingActivityIndicator startAnimating];
        NSString *pathToImage = section.arrayOfImages[0]; // Show first image from gallery as miniature
        [cell.sectionNamesGalleryTheme sd_setImageWithURL:[NSURL URLWithString:pathToImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell.downloadingActivityIndicator stopAnimating];
        }];
        // Alternative that needs method to cache images
//        [self.webServices loadDataByPath:pathToImage withCompletionBlock:^(NSData *data, NSError *error) {
//            if (error) {
//                NSLog(@"%@", error);
//            }
//            else {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    cell.sectionNamesGalleryTheme.image = [UIImage imageWithData:data];
//                    [cell.downloadingActivityIndicator stopAnimating];
//                });
//            }
//        }];
    }
    // if there is no array of images URLs:
    else {
        cell.sectionNamesGalleryTheme.image = [UIImage imageNamed:@"noImage"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.chosenCellIndex = (indexPath.row);
    // Start segue with index of cell clicked
    [self performSegueWithIdentifier:@"showPhotosInGroupe" sender:self];
    // Deselect chosen section
    [self.tableViewGallery deselectRowAtIndexPath:[self.tableViewGallery indexPathForSelectedRow] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Calculation number of rows in our tableView
    return (tableView.frame.size.height / 10);
}

@end
