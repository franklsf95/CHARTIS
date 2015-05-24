//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <AFNetworking/AFNetworking.h>
#import "Models.h"

@interface AFHTTPSessionManager (Additions)

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end
