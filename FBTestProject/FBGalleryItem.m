//
//  FBGalleryItem.m
//  FBTestProject
//
//  Created by BRABUS on 12/26/16.
//  Copyright © 2016 Anthony Zhdanov. All rights reserved.
//

#import "FBGalleryItem.h"

@implementation FBGalleryItem

- (instancetype)initWithName:(NSString *)sectionName arrayOfImageNames:(NSArray *)array {
    self = [super init];
    if (self)
    {
        self.sectionName = sectionName;
        self.arrayOfImages = array;
    }
    return self;
}

@end
