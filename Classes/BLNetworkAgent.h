//
//  BLNetworkAgent.h
//  BLNetwork
//
//  Created by apple on 2017/7/7.
//  Copyright © 2017年 BroadLink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLBaseRequest;

@interface BLNetworkAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Get the shared agent.
+ (BLNetworkAgent *)sharedAgent;

///  Add request to session and start it.
- (void)addRequest:(BLBaseRequest *)request;

///  Cancel a request that was previously added.
- (void)cancelRequest:(BLBaseRequest *)request;

///  Cancel all requests that were previously added.
- (void)cancelAllRequests;

///  Return the constructed URL of request.
///
///  @param request The request to parse. Should not be nil.
///
///  @return The result URL.
- (NSString *)buildRequestUrl:(BLBaseRequest *)request;

@end
