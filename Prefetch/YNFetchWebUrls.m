//
//  YNFetchWebUrls.m
//  Prefetch
//
//  Created by Taomin Chang on 7/13/15.
//  Copyright (c) 2015 Taomin Chang. All rights reserved.
//

#import "YNFetchWebUrls.h"

@implementation YNFetchWebUrls

+ (void)fetchDataForURL:(NSString *)url completion:(void(^)(NSCachedURLResponse* cachedResp))completion {
    
    NSURLCache *cache = [NSURLCache sharedURLCache];
    
    //preload url right now, see if this helps loading
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    NSCachedURLResponse *cachedResp = [cache cachedResponseForRequest:request];
    
    if (cachedResp != nil) {
        if (completion) {
            NSLog(@"Loading from cache");
            completion(cachedResp);
        }
        return;
    } else {
        NSLog(@"Loading remote resource");
        
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:nil];
        if (connection)
        {
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                NSLog(@"Response headers: %@",[(NSHTTPURLResponse *)response allHeaderFields]);
                
                NSCachedURLResponse *cachedResp = nil;
                
                if (connectionError == nil) {
                    
                    cachedResp = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowedInMemoryOnly];
                    [cache storeCachedResponse:cachedResp forRequest:request];
                }
                
                if (completion) {
                    completion(cachedResp);                }
                
            }];
            
        } else {
            if (completion) {
                completion(nil);
            }
        }
    }
}

@end
