//
//  FBGalleryItem.h
//  FBTestProject
//
//  Created by BRABUS on 12/26/16.
//  Copyright © 2016 Anthony Zhdanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FBGalleryItem : NSObject
@property (copy, readonly) NSString *sectionName;
@property (copy, readonly) NSArray *arrayOfImages;

- (instancetype)initWithName:(NSString *)sectionName arrayOfImageNames:(NSArray *)array;

@end
