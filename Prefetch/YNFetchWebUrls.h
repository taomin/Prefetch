//
//  YNFetchWebUrls.h
//  Prefetch
//
//  Created by Taomin Chang on 7/13/15.
//  Copyright (c) 2015 Taomin Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNFetchWebUrls : NSObject
+ (NSMutableURLRequest *)getURLRequest:(NSString *)url;
+ (NSCachedURLResponse *)loadURLDataFromCache:(NSString *)url;
+ (void)prefetchDataForURL:(NSString *)url;
+ (void)purgeCache;
@end
