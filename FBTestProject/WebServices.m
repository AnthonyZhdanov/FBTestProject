//
//  WebServices.m
//  FBTestProject
//
//  Created by BRABUS on 1/14/17.
//  Copyright © 2017 Anthony Zhdanov. All rights reserved.
//
#import "WebServices.h"

@implementation WebServices

// All web services in one place
- (void)loadFirebaseDatabaseWithCompletionBlock:(void(^)(NSArray *array))completionBlock {
    self.ref = [[FIRDatabase database] reference];
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *arrayWithSections = [NSMutableArray new];
        arrayWithSections = snapshot.value;
        completionBlock(arrayWithSections);
    }];
}

- (void)loadDataByPath:(NSString *)path withCompletionBlock:(void(^)(NSData *data, NSError *error))completionBlock {
    NSURL *url = [NSURL URLWithString:path];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url
                                             completionHandler:^(NSData * _Nullable data,
                                                                 NSURLResponse * _Nullable response,
                                                                 NSError * _Nullable error) {
                                                 completionBlock(data, error);
                                             }];
    [dataTask resume];
}

- (void)uploadDataToFirebaseStorage:(UIImage *)image folderName:(NSString *)groupe withcompletionBlock:(void(^)(FIRStorageMetadata *metadata, NSError *error))completionBlock {
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    // metadata with type of our data
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    metadata.contentType = @"image/jpeg";
    
    NSData *uplodData = [NSData new];
    uplodData = UIImageJPEGRepresentation(image, 1);
    // Reference to destination where file will be placed
    NSString *folder = groupe;
    NSString *fileName = [[NSUUID UUID] UUIDString];
    NSString *path = [NSString stringWithFormat:@"%@/%@", folder, fileName];
    FIRStorageReference *folderRef = [storageRef child:path];
    
    // Upload the file to the folderRef
    FIRStorageUploadTask *uploadTask = [folderRef putData:uplodData
                                                 metadata:metadata
                                               completion:^(FIRStorageMetadata *metadata,
                                                            NSError *error) {
                                                   
                                                   
                                                   completionBlock(metadata, error);
                                               }];
    [uploadTask resume];
}

- (void)addNewGroupFirebaseDatabase:(NSString *)nameOfGroup indexForNewGroup:(NSString *)index {
    self.ref = [[FIRDatabase database] reference];
    [[self.ref child:index] setValue:@{@"name": nameOfGroup}];
}

- (void)addImagesInFirebaseDatabaseByIndex:(int)index arrayOfImagesURLs:(NSMutableArray *)arrayOfURLs {
    NSString *indexOfGroupe = [NSString stringWithFormat:@"%i", index];
    self.ref = [[FIRDatabase database] reference];
    [[[self.ref child:indexOfGroupe] child:@"images"] setValue:arrayOfURLs];
}

@end
