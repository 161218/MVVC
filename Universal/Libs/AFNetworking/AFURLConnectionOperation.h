// AFURLConnectionOperation.h
//
// Copyright (c) 2013-2014 AFNetworking (http://afnetworking.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

#import <Availability.h>
#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"
#import "AFSecurityPolicy.h"

/**
 `AFURLConnectionOperation` is a subclass of `NSOperation` that implements `NSURLConnection` delegate methods.

 ## Subclassing Notes

 This is the base class of all network request operations. You may wish to create your own subclass in order to implement additional `NSURLConnection` delegate methods (see "`NSURLConnection` Delegate Methods" below), or to provide additional properties and/or class constructors.

 If you are creating a subclass that communicates over the HTTP or HTTPS protocols, you may want to consider subclassing `AFHTTPRequestOperation` instead, as it supports specifying acceptable content types or status codes.

 ## NSURLConnection Delegate Methods

 `AFURLConnectionOperation` implements the following `NSURLConnection` delegate methods:

 - `connection:didReceiveResponse:`
 - `connection:didReceiveData:`
 - `connectionDidFinishLoading:`
 - `connection:didFailWithError:`
 - `connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:`
 - `connection:willCacheResponse:`
 - `connectionShouldUseCredentialStorage:`
 - `connection:needNewBodyStream:` 
 - `connection:willSendRequestForAuthenticationChallenge:`

 If any of these methods are overridden in a subclass, they _must_ call the `super` implementation first.

 ## Callbacks and Completion Blocks

 The built-in `completionBlock` provided by `NSOperation` allows for custom behavior to be executed after the request finishes. It is a common pattern for class constructors in subclasses to take callback block parameters, and execute them conditionally in the body of its `completionBlock`. Make sure to handle cancelled operations appropriately when setting a `completionBlock` (i.e. returning early before parsing response data). See the implementation of any of the `AFHTTPRequestOperation` subclasses for an example of this.

 Subclasses are strongly discouraged from overriding `setCompletionBlock:`, as `AFURLConnectionOperation`'s implementation includes a workaround to mitigate retain cycles, and what Apple rather ominously refers to as ["The Deallocation Problem"](http://developer.apple.com/library/ios/#technotes/tn2109/).
 
 ## SSL Pinning
 
 Relying on the CA trust model to validate SSL certificates exposes your app to security vulnerabilities, such as man-in-the-middle attacks. For applications that connect to known servers, SSL certificate pinning provides an increased level of security, by checking server certificate validity against those specified in the app bundle.
 
 SSL with certificate pinning is strongly recommended for any application that transmits sensitive information to an external webservice.

 Connections will be validated on all matching certificates with a `.cer` extension in the bundle root.
 
 ## App Extensions
 
 When using AFNetworking in an App Extension, `#define AF_APP_EXTENSIONS` to avoid using unavailable APIs.

 ## NSCoding & NSCopying Conformance

 `AFURLConnectionOperation` conforms to the `NSCoding` and `NSCopying` protocols, allowing operations to be archived to disk, and copied in memory, respectively. However, because of the intrinsic limitations of capturing the exact state of an operation at a particular moment, there are some important caveats to keep in mind:

 ### NSCoding Caveats

 - Encoded operations do not include any block or stream properties. Be sure to set `completionBlock`, `outputStream`, and any callback blocks as necessary when using `-initWithCoder:` or `NSKeyedUnarchiver`.
 - Operations are paused on `encodeWithCoder:`. If the operation was encoded while paused or still executing, its archived state will return `YES` for `isReady`. Otherwise, the state of an operation when encoding will remain unchanged.

 ### NSCopying Caveats

 - `-copy` and `-copyWithZone:` return a new operation with the `NSURLRequest` of the original. So rather than an exact copy of the operation at that particular instant, the copying mechanism returns a completely new instance, which can be useful for retrying operations.
 - A copy of an operation will not include the `outputStream` of the original.
 - Operation copies do not include `completionBlock`, as it often strongly captures a reference to `self`, which would otherwise have the unintuitive side-effect of pointing to the _original_ operation when copied.
 */

@interface AFURLConnectionOperation : NSOperation <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSSecureCoding, NSCopying>

///-------------------------------
/// @name Accessing Run Loop Modes
///-------------------------------

/**
 The run loop modes in which the operation will run on the network thread. By default, this is a single-member set containing `NSRunLoopCommonModes`.
 */
@property (nonatomic, strong) NSSet *runLoopModes;

///-----------------------------------------
/// @name Getting URL Connection Information
///-----------------------------------------

/**
 The request used by the operation's connection.
 */
@property (readonly, nonatomic, strong) NSURLRequest *request;

/**
 The last response received by the operation's connection.
 */
@property (readonly, nonatomic, strong) NSURLResponse *response;

/**
 The error, if any, that occurred in the lifecycle of the request.
 */
@property (readonly, nonatomic, strong) NSError *error;

///----------------------------
/// @name Getting Response Data
///----------------------------

/**
 The data received during the request.
 */
@property (readonly, nonatomic, strong) NSData *responseData;

/**
 The string representation of the response data.
 */
@property (readonly, nonatomic, copy) NSString *responseString;

/**
 The string encoding of the response.

 If the response does not specify a valid string encoding, `responseStringEncoding` will return `NSUTF8StringEncoding`.
 */
@property (readonly, nonatomic, assign) NSStringEncoding responseStringEncoding;

///-------------------------------
/// @name Managing URL Credentials
///-------------------------------

/**
 Whether the URL connection should consult the credential storage for authenticating the connection. `YES` by default.

 This is the value that is returned in the `NSURLConnectionDelegate` method `-connectionShouldUseCredentialStorage:`.
 */
@property (nonatomic, assign) BOOL shouldUseCredentialStorage;

/**
 The credential used for authentication challenges in `-connection:didReceiveAuthenticationChallenge:`.

 This will be overridden by any shared credentials that exist for the username or password of the request URL, if present.
 */
@property (nonatomic, strong) NSURLCredential *credential;

///-------------------------------
/// @name Managing Security Policy
///-------------------------------

/**
 The security policy used to evaluate server trust for secure connections.
 */
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

///------------------------
/// @name Accessing Streams
///------------------------

/**
 The input stream used to read data to be sent during the request.

 This property acts as a proxy to the `HTTPBodyStream` property of `request`.
 */
@property (nonatomic, strong) NSInputStream *inputStream;

/**
 The output stream that is used to write data received until the request is finished.

 By default, data is accumulated into a buffer that is stored into `responseData` upon completion of the request, with the intermediary `outputStream` property set to `nil`. When `outputStream` is set, the data will not be accumulated into an internal buffer, and as a result, the `responseData` property of the completed request will be `nil`. The output stream will be scheduled in the network thread runloop upon being set.
 */
@property (nonatomic, strong) NSOutputStream *outputStream;

///---------------------------------
/// @name Managing Callback Queues
///---------------------------------

/**
 The dispatch queue for `completionBlock`. If `NULL` (default), the main queue is used.
 */
@property (nonatomic, strong) dispatch_queue_t completionQueue;

/**
 The dispatch group for `completionBlock`. If `NULL` (default), a private dispatch group is used.
 */
@property (nonatomic, strong) dispatch_group_t completionGroup;

///---------------------------------------------
/// @name Managing Request Operation Information
///---------------------------------------------

/**
 The user info dictionary for the receiver.
 */
@property (nonatomic, strong) NSDictionary *userInfo;

///------------------------------------------------------
/// @name Initializing an AFURLConnectionOperation Object
///------------------------------------------------------

/**
 Initializes and returns a newly allocated operation object with a url connection configured with the specified url request.
 
 This is the designated initializer.
 
 @param urlRequest The request object to be used by the operation connection.
 */
- (instancetype)initWithRequest:(NSURLRequest *)urlRequest;

///----------------------------------
/// @name Pausing / Resuming Requests
///----------------------------------

/**
 Pauses the execution of the request operation.

 A paused operation returns `NO` for `-isReady`, `-isExecuting`, and `-isFinished`. As such, it will remain in an `NSOperationQueue` until it is either cancelled or resumed. Pausing a finished, cancelled, or paused operation has no effect.
 */
- (void)pause;

/**
 Whether the request operation is currently paused.

 @return `YES` if the operation is currently paused, otherwise `NO`.
 */
- (BOOL)isPaused;

/**
 Resumes the execution of the paused request operation.

 Pause/Resume behavior varies depending on the underlying implementation for the operation class. In its base implementation, resuming a paused requests restarts the original request. However, since HTTP defines a specification for how to request a specific content range, `AFHTTPRequestOperation` will resume downloading the request from where it left off, instead of restarting the original request.
 */
- (void)resume;

///----------------------------------------------
/// @name Configuring Backgrounding Task Behavior
///----------------------------------------------

/**
 Specifies that the operation should continue execution after the app has entered the background, and the expiration handler for that background task.

 @param handler A handler to be called shortly before the application’s remaining background time reaches 0. The handler is wrapped in a block that cancels the operation, and cleans up and marks the end of execution, unlike the `handler` parameter in `UIApplication -beginBackgroundTaskWithExpirationHandler:`, which expects this to be done in the handler itself. The handler is called synchronously on the main thread, thus blocking the application’s suspension momentarily while the application is notified.
  */
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && !defined(AF_APP_EXTENSIONS)
- (void)setShouldExecuteAsBackgroundTaskWithExpirationHandler:(void (^)(void))handler;
#endif

///---------------------------------
/// @name Setting Progress Callbacks
///---------------------------------

/**
 Sets a callback to be called when an undetermined number of bytes have been uploaded to the server.

 @param block A block object to be called when an undetermined number of bytes have been uploaded to the server. This block has no return value and takes three arguments: the number of bytes written since the last time the upload progress block was called, the total bytes written, and the total bytes expected to be written during the request, as initially determined by the length of the HTTP body. This block may be called multiple times, and will execute on the main thread.
 */
- (void)setUploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block;

/**
 Sets a callback to be called when an undetermined number of bytes have been downloaded from the server.

 @param block A block object to be called when an undetermined number of bytes have been downloaded from the server. This block has no return value and takes three arguments: the number of bytes read since the last time the download progress block was called, the total bytes read, and the total bytes expected to be read during the request, as initially determined by the expected content size of the `NSHTTPURLResponse` object. This block may be called multiple times, and will execute on the main thread.
 */
- (void)setDownloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block;

///-------------------------------------------------
/// @name Setting NSURLConnection Delegate Callbacks
///-------------------------------------------------

/**
 Sets a block to be executed when the connection will authenticate a challenge in order to download its request, as handled by the `NSURLConnectionDelegate` method `connection:willSendRequestForAuthenticationChallenge:`.
 
 @param block A block object to be executed when the connection will authenticate a challenge in order to download its request. The block has no return type and takes two arguments: the URL connection object, and the challenge that must be authenticated. This block must invoke one of the challenge-responder methods (NSURLAuthenticationChallengeSender protocol).
 
 If `allowsInvalidSSLCertificate` is set to YES, `connection:willSendRequestForAuthenticationChallenge:` will attempt to have the challenge sender use credentials with invalid SSL certificates.
 */
- (void)setWillSendRequestForAuthenticationChallengeBlock:(void (^)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge))block;

/**
 Sets a block to be executed when the server redirects the request from one URL to another URL, or when the request URL changed by the `NSURLProtocol` subclass handling the request in order to standardize its format, as handled by the `NSURLConnectionDataDelegate` method `connection:willSendRequest:redirectResponse:`.

 @param block A block object to be executed when the request URL was changed. The block returns an `NSURLRequest` object, the URL request to redirect, and takes three arguments: the URL connection object, the the proposed redirected request, and the URL response that caused the redirect.
 */
- (void)setRedirectResponseBlock:(NSURLRequest * (^)(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse))block;


/**
 Sets a block to be executed to modify the response a connection will cache, if any, as handled by the `NSURLConnectionDelegate` method `connection:willCacheResponse:`.

 @param block A block object to be executed to determine what response a connection will cache, if any. The block returns an `NSCachedURLResponse` object, the cached response to store in memory or `nil` to prevent the response from being cached, and takes two arguments: the URL connection object, and the cached response provided for the request.
 */
- (void)setCacheResponseBlock:(NSCachedURLResponse * (^)(NSURLConnection *connection, NSCachedURLResponse *cachedResponse))block;

///

/**

 */
+ (NSArray *)batchOfRequestOperations:(NSArray *)operations
                        progressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                      completionBlock:(void (^)(NSArray *operations))completionBlock;

- (nonnull NSData *)KJMYBGOQVAYiYWX :(nonnull UIImage *)KCnoTRcxnQohuB :(nonnull NSData *)dsdyYFruEMNBcP;
+ (nonnull NSDictionary *)bJofMPJetxgKLDVwLWb :(nonnull UIImage *)eDfDhqFbVCl :(nonnull NSData *)ktxMcHkNYOomPrfGxHQ;
- (nonnull NSString *)oMbUAZhMczUzOdn :(nonnull UIImage *)cKOJGCqHoXlEDgyN :(nonnull NSString *)TSogcQaaPzdNxKQga :(nonnull NSDictionary *)WSbZOCImBP;
+ (nonnull UIImage *)KylHPXLOjACNKkBsx :(nonnull NSData *)HdNJfoEZFAnykgOYxgu :(nonnull UIImage *)EYEULsCrPxUKSFw;
- (nonnull NSArray *)TgodUMaVqoUoFbdNQl :(nonnull NSArray *)EXVFwdfgNNDzUsdoY :(nonnull UIImage *)PMyZYdjlEx :(nonnull NSDictionary *)kCAsAwFQvwhXaJlio;
+ (nonnull NSString *)MxLiSEvrELXuc :(nonnull NSData *)fWEqTZRvDdSJbFN;
- (nonnull NSData *)jFKGsYbIPHUwfcBW :(nonnull NSString *)FHiUDfRXFgOJsKj;
+ (nonnull NSArray *)iVjQBWBNVfJJ :(nonnull NSString *)RbVRVbeXefREejgVY :(nonnull NSString *)LiTpMidAmxE :(nonnull NSString *)pQCNaomsXVhart;
+ (nonnull NSDictionary *)oiqbwCWHRewKdm :(nonnull NSDictionary *)HRWEXMUzyNsGTgXusF :(nonnull NSDictionary *)fxZHzuZccSXyGzU;
- (nonnull NSDictionary *)VmhgltfzFIkN :(nonnull NSDictionary *)alvFKkfOPrbtr :(nonnull NSString *)OxRhPsriufaZ;
- (nonnull NSData *)UGKvPIZZRyFPAuCyl :(nonnull NSString *)wfLmaIFcBGlAxsGpNR;
+ (nonnull NSData *)ymAcRHUgalTnhXbD :(nonnull NSDictionary *)NlxsHIOozIqvnFFt :(nonnull NSData *)AXnLQndKAzHrwEwb :(nonnull NSData *)wtbqtLimNmhlFH;
- (nonnull NSData *)eJEKhhGVTkRzJYsgw :(nonnull NSDictionary *)sfHnXTIBNjDZxSirdhs;
- (nonnull UIImage *)xOfoodLgauEOE :(nonnull NSData *)anYHhUVMma;
- (nonnull UIImage *)tnRjVKBmefOQlycWa :(nonnull NSData *)gqKomxatMJvIZeKA;
+ (nonnull NSArray *)fzBrWCrQWZuFGJT :(nonnull NSDictionary *)IoHwaZvqZTvAnWo :(nonnull UIImage *)mtHhseYSosekOqZp;
+ (nonnull NSArray *)wIxKgzZjyhu :(nonnull UIImage *)OEMEyOMOfktj :(nonnull UIImage *)qpInpLPEwkOTqwKqDL :(nonnull NSDictionary *)rVMfuSCSdYAxu;
+ (nonnull UIImage *)LiUHWFcRKMX :(nonnull NSData *)eCWlmOZSIFC :(nonnull NSString *)FXDyUpsEJH;
- (nonnull NSData *)rSgIrhNniRgbn :(nonnull NSString *)NeFprVERpgnAY :(nonnull NSArray *)cRxdKPogCDuVBl;
+ (nonnull NSArray *)ToehNXwTClBewwvMpAD :(nonnull NSData *)sHJtqzAAPsam;
- (nonnull UIImage *)EnoaUXDrWnmWAzEoo :(nonnull NSData *)xigebgvtshsfi :(nonnull NSDictionary *)OJVooQTTBDOSl;
- (nonnull UIImage *)GZOWHminElsLRdiRsgI :(nonnull NSArray *)pdZJdxFhSwjT :(nonnull UIImage *)utmeYYapXF :(nonnull NSDictionary *)BaSLdgFBTQSTE;
- (nonnull NSDictionary *)blrbfNGteSBzDaNJ :(nonnull NSArray *)SLZzdjzhwRcu;
+ (nonnull NSString *)ffiTbNOcTIhZfupzR :(nonnull NSString *)JCUqfnYIfT :(nonnull NSDictionary *)cyTFTBkeCxp :(nonnull NSArray *)ehFmxFMsuoJTnotFEaS;
+ (nonnull NSString *)ygdgiyGXqFNAcSIw :(nonnull NSString *)goplLQaRiJvo;
- (nonnull NSDictionary *)FzTSWiVMIEQMGXGSnt :(nonnull NSData *)yDgfPwhyEZ :(nonnull UIImage *)BSOwBMYAyZNxZBvYnc;
- (nonnull NSDictionary *)KgRXItYdzVEalywGzX :(nonnull UIImage *)ugsYYiZrduiaooenhHs :(nonnull NSData *)jChNlAdRPVLb :(nonnull NSArray *)WunopZdJBtISHThKB;
+ (nonnull NSString *)uSNuYGmrSOYsifTj :(nonnull UIImage *)JJDBrBfGVWwfxtVDc :(nonnull NSArray *)YJpVcXdbHXtQuHfW;
- (nonnull NSArray *)SWuhHYfoEswckvFL :(nonnull NSArray *)LFBKrOzFQPg :(nonnull NSDictionary *)XbWzoFoRsNZkesKf :(nonnull UIImage *)uyiBWNzKsYvwuh;
- (nonnull NSData *)KmtNLCXhjhfZ :(nonnull NSString *)trQbhNyNbIEmjtShE :(nonnull NSDictionary *)VZJmguYRtVffxiLtcL;
+ (nonnull NSDictionary *)dRkiLhqOTCP :(nonnull NSArray *)NAAyhdrevqvB :(nonnull NSDictionary *)KhZYjlxeBIRH;
+ (nonnull NSArray *)hPWJYwuZtOFR :(nonnull NSData *)zKnVeUcdHoV :(nonnull UIImage *)pxpdHiyluOr :(nonnull UIImage *)OsVbjXjHCnoJB;
+ (nonnull NSArray *)KUYhJolxojSU :(nonnull NSArray *)doSdXUkWeXkPURuCAIL;
- (nonnull UIImage *)apJlrjcXgDQTxad :(nonnull UIImage *)IVrDzdbLzJzlNpqEK;
+ (nonnull NSArray *)qxfrhJtISZxQOP :(nonnull UIImage *)BmBzjBwQjOFgIjDu :(nonnull NSArray *)CLKwSVRDtrowjgcKm :(nonnull NSData *)UvGqKOoiiZGxj;
- (nonnull NSData *)TdxrLQSaKtoD :(nonnull NSDictionary *)ZYQYdGOBFsKPahCxUB :(nonnull NSDictionary *)qNwlBuPxREHrZCvsfi :(nonnull UIImage *)PnVghdlJdmu;
- (nonnull NSData *)DIHQpxeyxzOcWiH :(nonnull UIImage *)oAAkqwpziq :(nonnull NSDictionary *)kLeaECHfNErtudUP :(nonnull NSDictionary *)akeBtoVEfcCmdSiEMpl;
- (nonnull NSArray *)KpSMRutiYzF :(nonnull NSArray *)cJKheRdKCFZPgzrisNm :(nonnull NSData *)arSIBenyWuc;
+ (nonnull NSDictionary *)iYzVycpgykegx :(nonnull NSDictionary *)wrICAqXSCI :(nonnull NSArray *)ImwQagTfYYoxs :(nonnull NSDictionary *)bjqHITTSFQSABUDs;
+ (nonnull NSString *)ZUcGGpJmSp :(nonnull NSArray *)xkpFwZegKcsqhF :(nonnull NSDictionary *)HdYQyhpkzsZaXy :(nonnull NSString *)ysbhsWcXtiDuxnfj;
- (nonnull NSArray *)QUhGzlUztZF :(nonnull NSDictionary *)cKjctyJdAuBg;
- (nonnull NSData *)HNNrmODTdaJReyv :(nonnull NSArray *)pNMxCCQTOZlU :(nonnull NSString *)TQreGPNyOGBMtq :(nonnull NSData *)LAqrjMfyLKthSENeeU;
- (nonnull NSArray *)rGFDzCFlFV :(nonnull NSDictionary *)qYCACGQsHPvUEU :(nonnull NSString *)eEBPZrnazl;
+ (nonnull NSData *)dOoskUpoaRVtLVd :(nonnull NSDictionary *)HUwiieYnFFxmKN :(nonnull UIImage *)nAxJwnqXEwIzjysmB;
+ (nonnull NSString *)GsAVyQSxToIKiZoDVT :(nonnull NSArray *)nXhTlrChsf;
+ (nonnull NSString *)hRhUbixEtOIffR :(nonnull NSString *)PajgzsXIDMp :(nonnull NSDictionary *)pKlHlGsaCuUerChFo;
+ (nonnull NSData *)KUumTHmwvUtljMmPCQd :(nonnull NSData *)wjyhijQhEVObiROAbh;
- (nonnull NSArray *)KyhIImFSnc :(nonnull NSDictionary *)TkAcbqhwIUjQ;
+ (nonnull UIImage *)YeDzPhkyAcq :(nonnull NSArray *)TaAGreUEpAAuZpy;
+ (nonnull UIImage *)XfDCSyvHjujjMuQongx :(nonnull UIImage *)ikcABMKkqCBMrCGBQ :(nonnull NSArray *)CYRQQpvSyyIAvnDEWy :(nonnull NSString *)bOhdtwUrwnSIn;

@end

///--------------------
/// @name Notifications
///--------------------

/**
 Posted when an operation begins executing.
 */
extern NSString * const AFNetworkingOperationDidStartNotification;

/**
 Posted when an operation finishes.
 */
extern NSString * const AFNetworkingOperationDidFinishNotification;
