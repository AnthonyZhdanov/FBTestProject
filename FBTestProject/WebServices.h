//
//  WebServices.h
//  FBTestProject
//
//  Created by BRABUS on 1/14/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@import FirebaseStorageUI;
@import FirebaseStorage;
@import FirebaseDatabase;

@interface WebServices : NSObject

- (void)loadFirebaseDatabaseWithCompletionBlock:(void(^)(NSArray *array))completionBlock;

- (void)loadDataByPath:(NSString *)path withCompletionBlock:(void(^)(NSData *data, NSError *error))completionBlock;

- (void)uploadDataToFirebaseStorage:(UIImage *)image folderName:(NSString *)groupe withcompletionBlock:(void(^)(FIRStorageMetadata *metadata, NSError *error))completionBlock;

- (void)addNewGroupFirebaseDatabase:(NSString *)nameOfGroup indexForNewGroup:(NSString *)index;

- (void)addImagesInFirebaseDatabaseByIndex:(int)index arrayOfImagesURLs:(NSMutableArray *)arrayOfURLs;

@end
