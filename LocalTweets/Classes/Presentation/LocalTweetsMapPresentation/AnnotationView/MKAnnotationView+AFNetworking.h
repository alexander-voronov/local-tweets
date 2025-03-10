//
//  MKAnnotationView+AFNetworking.h
//  LocalTweets
//
//  Created by Alexander Voronov on 26/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@protocol AFURLResponseSerialization;

@interface MKAnnotationView (AFNetworking)

+ (id <AFImageCache>)sharedImageCache;

/**
 Set the cache used for image loading.
 @param imageCache The image cache.
 */
+ (void)setSharedImageCache:(id <AFImageCache>)imageCache;

///------------------------------------
/// @name Accessing Response Serializer
///------------------------------------

/**
 The response serializer used to create an image representation from the server response and response data. By default, this is an instance of `AFImageResponseSerializer`.
 @discussion Subclasses of `AFImageResponseSerializer` could be used to perform post-processing, such as color correction, face detection, or other effects. See https://github.com/AFNetworking/AFCoreImageSerializer
 */
@property (nonatomic, strong) id <AFURLResponseSerialization> imageResponseSerializer;

///--------------------
/// @name Setting Image
///--------------------

/**
 Asynchronously downloads an image from the specified URL, and sets it once the request is finished. Any previous image request for the receiver will be cancelled.
 If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished.
 By default, URL requests have a `Accept` header field value of "image / *", a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set not handle cookies. To configure URL requests differently, use `setImageWithURLRequest:placeholderImage:success:failure:`
 @param url The URL used for the image request.
 */
- (void)setImageWithURL:(NSURL *)url;

/**
 Asynchronously downloads an image from the specified URL, and sets it once the request is finished. Any previous image request for the receiver will be cancelled.
 If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished.
 By default, URL requests have a `Accept` header field value of "image / *", a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set not handle cookies. To configure URL requests differently, use `setImageWithURLRequest:placeholderImage:success:failure:`
 @param url The URL used for the image request.
 @param placeholderImage The image to be set initially, until the image request finishes. If `nil`, the image view will not change its image until the image request finishes.
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

/**
 Asynchronously downloads an image from the specified URL request, and sets it once the request is finished. Any previous image request for the receiver will be cancelled.
 If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished.
 If a success block is specified, it is the responsibility of the block to set the image of the image view before returning. If no success block is specified, the default behavior of setting the image with `self.image = image` is applied.
 @param urlRequest The URL request used for the image request.
 @param placeholderImage The image to be set initially, until the image request finishes. If `nil`, the image view will not change its image until the image request finishes.
 @param success A block to be executed when the image request operation finishes successfully. This block has no return value and takes three arguments: the request sent from the client, the response received from the server, and the image created from the response data of request. If the image was returned from cache, the request and response parameters will be `nil`.
 @param failure A block object to be executed when the image request operation finishes unsuccessfully, or that finishes successfully. This block has no return value and takes three arguments: the request sent from the client, the response received from the server, and the error object describing the network or parsing error that occurred.
 */
- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

/**
 Cancels any executing image operation for the receiver, if one exists.
 */
- (void)cancelImageRequestOperation;

@end

//#pragma mark -
//
///**
// The `AFImageCache` protocol is adopted by an object used to cache images loaded by the AFNetworking category on `UIImageView`.
// */
//@protocol AFImageCache <NSObject>
//
///**
// Returns a cached image for the specififed request, if available.
// @param request The image request.
// @return The cached image.
// */
//- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
//
///**
// Caches a particular image for the specified request.
// @param image The image to cache.
// @param request The request to be used as a cache key.
// */
//- (void)cacheImage:(UIImage *)image forRequest:(NSURLRequest *)request;
//
//@end