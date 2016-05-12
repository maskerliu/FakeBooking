//
//  MAPI.m
//  FakeReservation
//
//  Created by yixin.jiang on 5/11/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import "MAPI.h"

static NSString * const DP_MAPI_HTTP_MOTHED_GET  = @"GET";
static NSString * const DP_MAPI_HTTP_MOTHED_POST = @"POST";


@implementation MAPI


- (void)dp_getFromURL:(NSString *)URLString
           parameters:(NSDictionary *)parameterDictionary
      completionBlock:(DPMapiRequestCompletionBlock)completionBlock
{
    [self dp_requestToURL:URLString
                paramters:parameterDictionary
                   mothed:DP_MAPI_HTTP_MOTHED_GET
          completionBlock:^(NVObject *object, NSError *error) {
              completionBlock(object, error);
          }];
}

- (void)dp_postToURL:(NSString *)URLString
          parameters:(NSDictionary *)parameterDictionary
     completionBlock:(DPMapiRequestCompletionBlock)completionBlock
{
    [self dp_requestToURL:URLString
                paramters:parameterDictionary
                   mothed:DP_MAPI_HTTP_MOTHED_POST
          completionBlock:^(NVObject *object, NSError *error) {
              completionBlock(object, error);
          }];
}

- (void)dp_requestToURL:(NSString *)URLString
              paramters:(NSDictionary *)parameterDictionary
                 mothed:(NSString *)mothed
        completionBlock:(DPMapiRequestCompletionBlock)completionBlock
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    [defaultConfigObject setHTTPAdditionalHeaders:@{
                                                    @"network-type": @"wifi",
                                                    @"accept": @"*/*",
                                                    @"pragma-appid": @"351091731",
                                                    @"pragma-dpid": @"-3431032955368336516",
                                                    @"pragma-device": @"76b378ae4c48d0ff4da1bee1a4e0f2ff272d9368",
                                                    @"pragma-apptype": @"com.dianping.dpscope",
                                                    @"accept-encoding": @"gzip, deflate",
                                                    @"pragma-os": @"MApi 1.1 (dpscope 8.1.0 appstore; iPhone 9.2 x86_64; a0d0)",
                                                    @"user-agent": @"MApi 1.1 (dpscope 8.1.0 appstore; iPhone 9.2 x86_64; a0d0)",
                                                    }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject];
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

    
    
    [urlRequest setHTTPMethod:mothed];
    
    if (parameterDictionary) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterDictionary options:0 error:&error];
        
        if (error) {
            if (completionBlock) {
                completionBlock(nil, error);
            }
            return;
        }
        
        if (jsonData) {
            if ([mothed isEqualToString:DP_MAPI_HTTP_MOTHED_POST]) {
                [urlRequest setHTTPBody:dp_dianpingDataFromParameters(parameterDictionary)];
            }
            else if ([mothed isEqualToString:DP_MAPI_HTTP_MOTHED_GET]) {
                NSURLComponents *components = [NSURLComponents componentsWithString:URLString];
                
                NSMutableArray *queryItems = [NSMutableArray array];
                for (NSString *key in parameterDictionary) {
                    [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:parameterDictionary[key]]];
                }
                components.queryItems = queryItems;
                urlRequest.URL = components.URL;
            }
        }
    }
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                if (error || data == nil) {
                                                    if (completionBlock) {
                                                        completionBlock(nil, error);
                                                    }
                                                }
                                                else {
                                                    if (completionBlock) {
                                                        completionBlock([NVObject objectWithData:[data dp_decodeMobileData]], nil);
                                                    }
                                                }
                                            }];
    
    [task resume];
}

static NSData *dp_dianpingDataFromParameters(NSDictionary *parameters)
{
    NSMutableString *buffer = [[NSMutableString alloc] init];
    for(NSString *key in parameters.allKeys) {
        if(buffer.length > 0) {
            [buffer appendString:@"&"];
        }
        [buffer appendString:key];
        [buffer appendString:@"="];
        [buffer appendString:dp_percentEscapedQueryStringPairMemberFromString(parameters[key])];
    }
    NSData *data = [buffer dataUsingEncoding:NSUTF8StringEncoding];
    return [data dp_encodeMobileData];
}

static NSString *dp_percentEscapedQueryStringPairMemberFromString(NSString *string)
{
    static NSString *const kAFCharactersToBeEscaped = @":/?&=;+!@#$()',*";
    static NSString *const kAFCharactersToLeaveUnescaped = @"[].";
    
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes (kCFAllocatorDefault,
                                                                                 (__bridge CFStringRef)string,
                                                                                 (__bridge CFStringRef)kAFCharactersToLeaveUnescaped,
                                                                                 (__bridge CFStringRef)kAFCharactersToBeEscaped,
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

@end
