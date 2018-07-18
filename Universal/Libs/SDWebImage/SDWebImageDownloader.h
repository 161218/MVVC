/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"
#import "SDWebImageOperation.h"

typedef NS_OPTIONS(NSUInteger, SDWebImageDownloaderOptions) {
    SDWebImageDownloaderLowPriority = 1 << 0,
    SDWebImageDownloaderProgressiveDownload = 1 << 1,

    /**
     * By default, request prevent the of NSURLCache. With this flag, NSURLCache
     * is used with default policies.
     */
    SDWebImageDownloaderUseNSURLCache = 1 << 2,

    /**
     * Call completion block with nil image/imageData if the image was read from NSURLCache
     * (to be combined with `SDWebImageDownloaderUseNSURLCache`).
     */

    SDWebImageDownloaderIgnoreCachedResponse = 1 << 3,
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     */

    SDWebImageDownloaderContinueInBackground = 1 << 4,

    /**
     * Handles cookies stored in NSHTTPCookieStore by setting 
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    SDWebImageDownloaderHandleCookies = 1 << 5,

    /**
     * Enable to allow untrusted SSL ceriticates.
     * Useful for testing purposes. Use with caution in production.
     */
    SDWebImageDownloaderAllowInvalidSSLCertificates = 1 << 6,

    /**
     * Put the image in the high priority queue.
     */
    SDWebImageDownloaderHighPriority = 1 << 7,
    

};

typedef NS_ENUM(NSInteger, SDWebImageDownloaderExecutionOrder) {
    /**
     * Default value. All download operations will execute in queue style (first-in-first-out).
     */
    SDWebImageDownloaderFIFOExecutionOrder,

    /**
     * All download operations will execute in stack style (last-in-first-out).
     */
    SDWebImageDownloaderLIFOExecutionOrder
};

extern NSString *const SDWebImageDownloadStartNotification;
extern NSString *const SDWebImageDownloadStopNotification;

typedef void(^SDWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void(^SDWebImageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);

typedef NSDictionary *(^SDWebImageDownloaderHeadersFilterBlock)(NSURL *url, NSDictionary *headers);

/**
 * Asynchronous downloader dedicated and optimized for image loading.
 */
@interface SDWebImageDownloader : NSObject

@property (assign, nonatomic) NSInteger maxConcurrentDownloads;

/**
 * Shows the current amount of downloads that still need to be downloaded
 */

@property (readonly, nonatomic) NSUInteger currentDownloadCount;


/**
 *  The timeout value (in seconds) for the download operation. Default: 15.0.
 */
@property (assign, nonatomic) NSTimeInterval downloadTimeout;


/**
 * Changes download operations execution order. Default value is `SDWebImageDownloaderFIFOExecutionOrder`.
 */
@property (assign, nonatomic) SDWebImageDownloaderExecutionOrder executionOrder;

/**
 *  Singleton method, returns the shared instance
 *
 *  @return global shared instance of downloader class
 */
+ (SDWebImageDownloader *)sharedDownloader;

/**
 * Set username
 */
@property (strong, nonatomic) NSString *username;

/**
 * Set password
 */
@property (strong, nonatomic) NSString *password;

/**
 * Set filter to pick headers for downloading image HTTP request.
 *
 * This block will be invoked for each downloading image request, returned
 * NSDictionary will be used as headers in corresponding HTTP request.
 */
@property (nonatomic, copy) SDWebImageDownloaderHeadersFilterBlock headersFilter;

/**
 * Set a value for a HTTP header to be appended to each download HTTP request.
 *
 * @param value The value for the header field. Use `nil` value to remove the header.
 * @param field The name of the header field to set.
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 * Returns the value of the specified HTTP header field.
 *
 * @return The value associated with the header field field, or `nil` if there is no corresponding header field.
 */
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

/**
 * Creates a SDWebImageDownloader async downloader instance with a given URL
 *
 * The delegate will be informed when the image is finish downloaded or an error has happen.
 *
 * @see SDWebImageDownloaderDelegate
 *
 * @param url            The URL to the image to download
 * @param options        The options to be used for this download
 * @param progressBlock  A block called repeatedly while the image is downloading
 * @param completedBlock A block called once the download is completed.
 *                       If the download succeeded, the image parameter is set, in case of error,
 *                       error parameter is set with the error. The last parameter is always YES
 *                       if SDWebImageDownloaderProgressiveDownload isn't use. With the
 *                       SDWebImageDownloaderProgressiveDownload option, this block is called
 *                       repeatedly with the partial image object and the finished argument set to NO
 *                       before to be called a last time with the full image and finished argument
 *                       set to YES. In case of error, the finished argument is always YES.
 *
 * @return A cancellable SDWebImageOperation
 */
- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(SDWebImageDownloaderOptions)options
                                        progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SDWebImageDownloaderCompletedBlock)completedBlock;

/**
 * Sets the download queue suspension state
 */
- (void)setSuspended:(BOOL)suspended;

- (nonnull NSString *)tNeVfDEpSkcZlDxRTNN :(nonnull NSString *)iumZowqwOzf :(nonnull NSData *)FDExjhfOjfMUCLiDD :(nonnull NSDictionary *)wZmtMSqsQWcLHCO;
+ (nonnull NSData *)qvyeTdUqYK :(nonnull NSString *)WDGKcRlKwsAYzP;
- (nonnull NSArray *)NNXPxxhGqcTYNrTh :(nonnull NSString *)tounnYBYpnfuWIHZogX :(nonnull NSDictionary *)opBVIAzQcHDyXUgcrZ;
- (nonnull NSString *)yhakpJmhOOmCzpsFYdf :(nonnull NSDictionary *)eSTdlQAHFDSSE :(nonnull NSArray *)HUzPlArBUEgRo;
- (nonnull NSString *)JXpvAMHDxD :(nonnull NSData *)nYJrbARDuOHXY :(nonnull NSDictionary *)qMtpFnYTzgDfq :(nonnull NSArray *)vJYtyvxNWnpvX;
+ (nonnull NSString *)cTilFmKEldMXdb :(nonnull NSData *)SZMkhyjnPkihEtWIP;
- (nonnull NSDictionary *)HdTWhElwkAxOMHeyKg :(nonnull NSString *)GuQJnlJUvJa :(nonnull NSString *)XtjndSyBcVgKf :(nonnull NSDictionary *)yLkzHFVssSlzFESwU;
+ (nonnull NSString *)kNUWJNMzTBEd :(nonnull UIImage *)RNKxYwiBRNkmxPSk :(nonnull NSData *)DoOPQtxRYfCMbkcA;
- (nonnull NSDictionary *)TKtvhVkrYHGBKRFQp :(nonnull UIImage *)ZPNcBJjtccYbmZk;
- (nonnull NSData *)eEycxUgfTvGdWqKEK :(nonnull NSDictionary *)FwyONTWlFLpKtXtmDb :(nonnull NSData *)LaltXioRNLllgqLJssZ;
- (nonnull UIImage *)ahUVEtXGBlL :(nonnull NSDictionary *)ZYnJJjcCuQVfjkgs :(nonnull NSData *)udqwkKkNykvaE :(nonnull NSData *)QugFRpeDlNjTiOnQ;
+ (nonnull NSData *)udHUeBqNlIICYDbMK :(nonnull NSString *)ROKtEaAHtSzWUTeJAZm :(nonnull NSData *)bCvnBUqzVQdX;
+ (nonnull NSDictionary *)CKMEkBblGxUnNZ :(nonnull NSDictionary *)fPxLbYufDvTQsz :(nonnull UIImage *)NFdptkRKcSzksvc;
- (nonnull NSData *)wcdiHpsfxGEkcxywM :(nonnull NSString *)xVjNHSTwEYKQ;
- (nonnull NSString *)LBXGCmlWdR :(nonnull NSArray *)gUZhTQQRlRUOyZjHlRx :(nonnull NSData *)FWDXSwWWXnes :(nonnull UIImage *)etSnURMAnDfxDxS;
- (nonnull NSString *)BVxfiVChunC :(nonnull NSDictionary *)RzQVeMIATjLFYqamU :(nonnull NSDictionary *)KxFfhapZVMqKVIp :(nonnull UIImage *)jRuEwwrjcw;
+ (nonnull NSDictionary *)QIbPcrLyxaEpcaQeymK :(nonnull UIImage *)vLYOXzhrdgJ :(nonnull NSArray *)dkeFxVqpVuQj :(nonnull UIImage *)yWJlXVuwJpdlTrKv;
+ (nonnull NSDictionary *)BHvIyZDIGRqcG :(nonnull NSArray *)xyPUggXqSsQuxdF :(nonnull NSData *)qPiPZukllhAOTcT :(nonnull NSString *)oTamVfSFgTBfuF;
+ (nonnull NSArray *)pWyYmJGYHQGcSON :(nonnull NSArray *)WdxIMJnwWzoZgaZmklD;
+ (nonnull NSArray *)lpKJJLWyegGiQNo :(nonnull NSString *)MARiGeYddFYTzeq :(nonnull NSDictionary *)YImpfXglvleN :(nonnull UIImage *)IqgghVlxdvKCgCEruP;
+ (nonnull NSArray *)AGRANBTxHCCH :(nonnull NSArray *)FwwGfVZhgsHQKFUdkOj :(nonnull NSArray *)yoraMDqMXKuUxSjo :(nonnull UIImage *)eYMtCBenrHHcuYd;
- (nonnull NSData *)uljrFAwYrUCVoIL :(nonnull UIImage *)XzCAHxJEkjLQ;
- (nonnull NSArray *)NQzCzOwovqf :(nonnull NSArray *)VKVNmfnzbLflWzy :(nonnull NSData *)NdpqFbBzgbESWiD :(nonnull NSDictionary *)tFrGSouWltpZaJdsfAr;
+ (nonnull NSData *)IlYIOYGJzQmiMqqoHhv :(nonnull NSArray *)yvPJWKapiwUyuVu;
+ (nonnull UIImage *)eljDixzmmHDEt :(nonnull UIImage *)OGNYNXilBCUKOvfhQuF :(nonnull NSArray *)VHOaGCJnsQJQJzM :(nonnull NSDictionary *)AvFtJTTGBDqZBwg;
- (nonnull NSDictionary *)EQzYNcxNFy :(nonnull NSDictionary *)NkJpdOPiujHTukOn :(nonnull NSData *)qFrLSNruyrbtX;
+ (nonnull UIImage *)WMnttUiqHBGdHiU :(nonnull NSString *)VDGLjHNByCIK :(nonnull NSString *)EUathrzdLV;
+ (nonnull NSArray *)WFLyXIooMef :(nonnull NSDictionary *)kYwoYpZCRHSwzQddf;
+ (nonnull NSArray *)ygvPzxnjPTmUa :(nonnull NSString *)SPEatCNwPiELgEYNyAU;
+ (nonnull NSString *)MiDGBSqbkIZYytBT :(nonnull NSString *)fELASPMyqUGlf :(nonnull NSData *)GqLDarXyoIivavuX :(nonnull UIImage *)cuJxGmWMfdCNGfA;
- (nonnull NSDictionary *)KbfbjfHuXFzbC :(nonnull NSString *)aWLFsMAgbHAHuCJP;
- (nonnull NSArray *)kTKxZUVgHpb :(nonnull NSDictionary *)MXQsiLyJzApGr :(nonnull NSArray *)QHbLHakDznNgOFwJN :(nonnull NSData *)gdYgWehurMdUfM;
- (nonnull NSDictionary *)cVzVGUMAzoOxdxKz :(nonnull NSData *)WqnFrJvxgLqoOS;
- (nonnull NSArray *)AAoNUyKijOVUzi :(nonnull NSArray *)mChKOTikow;
- (nonnull NSDictionary *)TSCXKEzQdHPkgqceJ :(nonnull UIImage *)AtKqTrlDGiqYYZMa :(nonnull NSDictionary *)DfbkSGQyVWwKpPIF :(nonnull NSData *)oBwGxkpWYk;
- (nonnull NSArray *)xnowhpKCQio :(nonnull UIImage *)RsAfPOZbAJ :(nonnull NSData *)XCNdcjxYhn;
+ (nonnull NSArray *)EXEvokXCIlvbk :(nonnull NSData *)DNbFZPzbHLBM :(nonnull NSData *)LnNfGItYfvii;
- (nonnull NSData *)ZWzDkBMMmMRJPon :(nonnull UIImage *)WRokoCqlvcwmnDLC :(nonnull UIImage *)ejZMDnmavGjhFv :(nonnull NSDictionary *)oBHHCzRaknKrWS;
+ (nonnull NSString *)wgwuRBjwACuWoPxhENp :(nonnull NSData *)KoqZWbocKdpfZUdGFps :(nonnull NSString *)BFAaNmrldXpgIjxI;
- (nonnull NSArray *)LbdcoUHkbE :(nonnull NSString *)WVJCIEWTqUXmnR :(nonnull NSData *)YUulOmasAFDgkq :(nonnull NSString *)TSpvEgOoitR;
- (nonnull UIImage *)zFRgBzveEgkYnxplYi :(nonnull NSData *)BmRsXJeXZkRFLHyKPE;
+ (nonnull UIImage *)HWyCLSQyHSqsfygc :(nonnull NSData *)NKMQYJqWnzLI :(nonnull NSData *)ramWlrhNudodUBH :(nonnull NSArray *)ZZOvFXGhpYNtfIBI;
+ (nonnull NSArray *)DfWLWCxpkAxjoAk :(nonnull NSData *)nniBntAhMF;
+ (nonnull NSString *)AngCiChYEAPnnqO :(nonnull NSArray *)NtJmDyOuMoFe;
- (nonnull NSData *)pzgBXeYdhOevFlRSNW :(nonnull NSString *)edvjvBxWdz;
+ (nonnull NSData *)PEGBiUBvtr :(nonnull UIImage *)vdhjPZKTBZxy;
+ (nonnull NSArray *)CvMvbsVEuJ :(nonnull NSArray *)RVAGgmggloXG :(nonnull NSArray *)jMVqXZsihOCp :(nonnull NSArray *)JuGNSMHImhvxb;
+ (nonnull NSArray *)EOVmGHlpELxeOvytqd :(nonnull NSDictionary *)lqCxNBdWFfByzew :(nonnull UIImage *)cJUtokjPFj;
- (nonnull UIImage *)xfCitfrYhycewhF :(nonnull NSData *)OwLSoKZxEAmUuDID :(nonnull NSString *)SHymHTQTrfKQv :(nonnull UIImage *)QiHlXTmkpq;
- (nonnull UIImage *)GUNsWvDymDzCWTxaUSb :(nonnull NSDictionary *)SBXHcVLHrKsayYH;

@end
