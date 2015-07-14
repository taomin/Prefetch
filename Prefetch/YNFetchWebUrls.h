//
//  YNFetchWebUrls.h
//  Prefetch
//
//  Created by Taomin Chang on 7/13/15.
//  Copyright (c) 2015 Taomin Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNFetchWebUrls : NSObject

+ (void)fetchDataForURL:(NSString *)url completion:(void(^)(NSCachedURLResponse* cachedResp))completion;

@end
