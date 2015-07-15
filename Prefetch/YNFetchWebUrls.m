//
//  YNFetchWebUrls.m
//  Prefetch
//
//  Created by Taomin Chang on 7/13/15.
//  Copyright (c) 2015 Taomin Chang. All rights reserved.
//

#import "YNFetchWebUrls.h"

@implementation YNFetchWebUrls

+ (NSMutableURLRequest *)getURLRequest:(NSString *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    return request;

}

+ (NSCachedURLResponse*)loadURLDataFromCache:(NSString *)url {
    NSURLCache *cache = [NSURLCache sharedURLCache];
    
    //preload url right now, see if this helps loading
    NSMutableURLRequest *request = [YNFetchWebUrls getURLRequest:url];
    [request setValue:@"Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; IEMobile/10.0; ARM; Touch; NOKIA; Lumia 520)" forHTTPHeaderField:@"User-Agent"];
    
    return [cache cachedResponseForRequest:request];

};


+ (void)prefetchDataForURL:(NSString *)url {
    
    NSURLCache *cache = [NSURLCache sharedURLCache];

    NSCachedURLResponse *cachedResp = [YNFetchWebUrls loadURLDataFromCache:url];
    
    if (cachedResp == nil) {
        NSLog(@"Loading remote resource and see if we can cache it");
        
        NSMutableURLRequest *request = [YNFetchWebUrls getURLRequest:url];

        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:nil];
        if (connection)
        {
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                NSHTTPURLResponse *URLResponse = (NSHTTPURLResponse *)response;
                NSString *cacheControlHeader = [URLResponse allHeaderFields][@"Cache-Control"];
                
                NSLog(@"Response headers: %@",[URLResponse allHeaderFields]);
                
                NSCachedURLResponse *cachedResp = nil;
                
                if (connectionError == nil) {
                    
                    if (cacheControlHeader == nil || ![cacheControlHeader containsString:@"no-cache"]) {
                        // response is cacheable
                        cachedResp = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowedInMemoryOnly];
                        [cache storeCachedResponse:cachedResp forRequest:request];
                    } else {
                        // fallback: use RNCacheURLProtocol
                        [request setValue:@"1" forHTTPHeaderField:@"X-RNPrefetch"];
                        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:nil];
                    }
                }
                
            }];
            
        }
    }
}

+(void)purgeCache{
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
}

@end
