//
//  BLBaseRequest.m
//  BLNetwork
//
//  Created by apple on 2017/7/7.
//  Copyright © 2017年 BroadLink. All rights reserved.
//

#import "BLBaseRequest.h"
#import "BLNetworkAgent.h"
#import "BLNetworkPrivate.h"

NSString *const BLRequestValidationErrorDomain = @"com.broadlink.request.validation";

@interface BLBaseRequest ()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) id responseJSONObject;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite) NSString *responseString;
@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, strong) NSDictionary *cacheFileNameDictionary;

@end

@implementation BLBaseRequest

- (instancetype)init {
    if (self = [super init]) {
        [self propertyInit];
    }
    return self;
}

- (void)propertyInit {
    self.requestTimeoutInterval = 60;
    self.requestMethod = BLRequestMethodGET;
    self.requestUrl = @"";
    self.baseUrl = @"";
    self.cdnUrl = @"";
    self.requestSerializerType = BLRequestSerializerTypeHTTP;
    self.allowsCellularAccess = YES;
    self.responseSerializerType = BLResponseSerializerTypeHTTP;
    self.useCDN = NO;
}

#pragma mark - Request and Response Information

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    return self.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.response.allHeaderFields;
}

- (NSURLRequest *)currentRequest {
    return self.requestTask.currentRequest;
}

- (NSURLRequest *)originalRequest {
    return self.requestTask.originalRequest;
}

- (BOOL)isCancelled {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateRunning;
}

#pragma mark - Request Configuration

- (void)setCompletionBlockWithSuccess:(BLRequestCompletionBlock)success
                              failure:(BLRequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (void)addAccessory:(id<BLRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}

#pragma mark - Request Action

- (void)start {
    [self toggleAccessoriesWillStartCallBack];
    [[BLNetworkAgent sharedAgent] addRequest:self];
}

- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[BLNetworkAgent sharedAgent] cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}

- (void)startWithCompletionBlockWithSuccess:(BLRequestCompletionBlock)success
                                    failure:(BLRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

#pragma mark - Request arguments




#pragma mark - Subclass Override

- (void)requestCompletePreprocessor {
}

- (void)requestCompleteFilter {
}

- (void)requestFailedPreprocessor {
}

- (void)requestFailedFilter {
    
}

- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return _cacheFileNameArguments;
}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    return (statusCode >= 200 && statusCode <= 299);
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ URL: %@ } { method: %@ } { arguments: %@ }", NSStringFromClass([self class]), self, self.currentRequest.URL, self.currentRequest.HTTPMethod, self.requestArgument];
}

@end
