//
//  SectionNamesTableViewCell.h
//  FBTestProject
//
//  Created by BRABUS on 12/26/16.
//  Copyright © 2016 Anthony Zhdanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionNamesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sectionNamesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sectionNamesGalleryTheme;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *downloadingActivityIndicator;

@end
