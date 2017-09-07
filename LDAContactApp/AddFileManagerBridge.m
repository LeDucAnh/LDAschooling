//
//  AddFileManagerBridge.m
//  LDAContactApp
//
//  Created by Mac on 6/3/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

#import "RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(AddFileManager, NSObject)

RCT_EXTERN_METHOD(dismissPresentedViewController)

RCT_EXTERN_METHOD(didCompleUploadFileWithFileURL:(nonnull NSString *)url)




@end
