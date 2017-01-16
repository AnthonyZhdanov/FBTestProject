//
//  GalleryCollectionViewCell.h
//  FBTestProject
//
//  Created by BRABUS on 1/6/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *galleryElementImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *downloadingActivityIndicator;

@end
