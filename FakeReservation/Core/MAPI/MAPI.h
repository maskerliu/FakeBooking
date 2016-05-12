//
//  MAPI.h
//  FakeReservation
//
//  Created by yixin.jiang on 5/11/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DPMapiRequestCompletionBlock)(NVObject *object, NSError *error);

@interface MAPI : NSObject

/**
 *  request from Dianping mobile backend via "GET" method
 *
 *  @param URLString           URLString the absolute path string
 *  @param parameterDictionary parameterDictionary the URL parameters
 *  @param completionBlock     finished callback called when the request is finished
 */
- (void)dp_getFromURL:(NSString *)URLString
           parameters:(NSDictionary *)parameterDictionary
      completionBlock:(DPMapiRequestCompletionBlock)completionBlock;

/**
 *  request to Dianping mobile backend via "POST" method
 *
 *  @param URLString           URLString the absolute path string
 *  @param parameterDictionary parameterDictionary the post body paramters
 *  @param completionBlock     finished callback called when the request is finished
 */
- (void)dp_postToURL:(NSString *)URLString
          parameters:(NSDictionary *)parameterDictionary
     completionBlock:(DPMapiRequestCompletionBlock)completionBlock;

@end
