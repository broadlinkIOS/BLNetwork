//
//  BLNetworkConfig.h
//  BLNetwork
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 BroadLink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BLBaseRequest;
@class AFSecurityPolicy;

///  BLUrlFilterProtocol can be used to append common parameters to requests before sending them.
@protocol BLUrlFilterProtocol <NSObject>
///  Preprocess request URL before actually sending them.
///
///  @param originUrl request's origin URL, which is returned by `requestUrl`
///  @param request   request itself
///
///  @return A new url which will be used as a new `requestUrl`
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(BLBaseRequest *)request;
@end

///  BLCacheDirPathFilterProtocol can be used to append common path components when caching response results
@protocol BLCacheDirPathFilterProtocol <NSObject>
///  Preprocess cache path before actually saving them.
///
///  @param originPath original base cache path, which is generated in `BLRequest` class.
///  @param request    request itself
///
///  @return A new path which will be used as base path when caching.
- (NSString *)filterCacheDirPath:(NSString *)originPath withRequest:(BLBaseRequest *)request;
@end

///  BLNetworkConfig stored global network-related configurations, which will be used in `BLNetworkAgent`
///  to form and filter requests, as well as caching response.
@interface BLNetworkConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Return a shared config object.
+ (BLNetworkConfig *)sharedConfig;

@property (nonatomic, strong) NSString *baseUrl;
///  Request CDN URL. Default is empty string.
@property (nonatomic, strong) NSString *cdnUrl;
///  URL filters. See also `BLUrlFilterProtocol`.
@property (nonatomic, strong, readonly) NSArray<id<BLUrlFilterProtocol>> *urlFilters;
///  Cache path filters. See also `BLCacheDirPathFilterProtocol`.
@property (nonatomic, strong, readonly) NSArray<id<BLCacheDirPathFilterProtocol>> *cacheDirPathFilters;
///  Security policy will be used by AFNetworking. See also `AFSecurityPolicy`.
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;
///  Whether to log debug info. Default is NO;
@property (nonatomic) BOOL debugLogEnabled;
///  SessionConfiguration will be used to initialize AFHTTPSessionManager. Default is nil.
@property (nonatomic, strong) NSURLSessionConfiguration* sessionConfiguration;

///  Add a new URL filter.
- (void)addUrlFilter:(id<BLUrlFilterProtocol>)filter;
///  Remove all URL filters.
- (void)clearUrlFilter;
///  Add a new cache path filter
- (void)addCacheDirPathFilter:(id<BLCacheDirPathFilterProtocol>)filter;
///  Clear all cache path filters.
- (void)clearCacheDirPathFilter;

@end

NS_ASSUME_NONNULL_END
