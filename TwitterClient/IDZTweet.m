//
//  IDZTweet.m
//  TwitterClient
//
//  Created by Anthony Powles on 25/01/14.
//  Copyright (c) 2014 Anthony Powles. All rights reserved.
//

#import "IDZTweet.h"
#import "IDZTwitterClient.h"

@interface IDZTweet ()

@property (strong, nonatomic) NSDictionary *rawTweet;
@property (strong, nonatomic, readwrite) NSString *text;
@property (strong, nonatomic, readwrite) NSDate *createdAt;

@end

@implementation IDZTweet

#pragma mark - Class Methods

+ (IDZTweet *)tweetFromJSON:(NSDictionary *)data
{
	return [[IDZTweet alloc] initFromJSON:data];
}

+ (void)fetchLast:(int)limit withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success andFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
	[[[IDZTwitterClient instance] networkManager] GET:@"1.1/statuses/home_timeline.json"
										   parameters:@{@"count": @(limit)}
											  success:success
											  failure:failure];
}

+ (void)fetchNext:(int)limit until:(NSString *)maxId withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success andFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
	[[[IDZTwitterClient instance] networkManager] GET:@"1.1/statuses/home_timeline.json"
										   parameters:@{@"count": @(limit),
														@"max_id": maxId}
											  success:success
											  failure:failure];
}


#pragma mark - Instance Methods

- (IDZTweet *)initFromJSON:(NSDictionary *)data
{
	self = [super init];
	if (self) {
		NSLog(@"new tweet with: %@", data);

		self.rawTweet = data;
		self.author = [IDZUser userFromJSON:data[@"user"]];
		self.text = self.rawTweet[@"text"];
		
		// see http://www.unicode.org/reports/tr35/tr35-25.html#Date_Format_Patterns
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
		self.createdAt = [formatter dateFromString:self.rawTweet[@"created_at"]];
	}
	
	return self;
}

- (NSString *)tweetId
{
	return self.rawTweet[@"id_str"];
}

- (NSString *)elapsedCreatedAt
{
	return @"";
}

@end
