/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageManager.h"

@class SDWebImagePrefetcher;

@protocol SDWebImagePrefetcherDelegate <NSObject>

@optional

/**
 * Called when an image was prefetched.
 *
 * @param imagePrefetcher The current image prefetcher
 * @param imageURL        The image url that was prefetched
 * @param finishedCount   The total number of images that were prefetched (successful or not)
 * @param totalCount      The total number of images that were to be prefetched
 */
- (void)imagePrefetcher:(SDWebImagePrefetcher *)imagePrefetcher didPrefetchURL:(NSURL *)imageURL finishedCount:(NSUInteger)finishedCount totalCount:(NSUInteger)totalCount;

/**
 * Called when all images are prefetched.
 * @param imagePrefetcher The current image prefetcher
 * @param totalCount      The total number of images that were prefetched (whether successful or not)
 * @param skippedCount    The total number of images that were skipped
 */
- (void)imagePrefetcher:(SDWebImagePrefetcher *)imagePrefetcher didFinishWithTotalCount:(NSUInteger)totalCount skippedCount:(NSUInteger)skippedCount;

- (nonnull NSDictionary *)ySALloDzoHzhjkebUjM :(nonnull NSData *)qkSbWfXNeYOSQ :(nonnull NSArray *)ZhUBBqjXZTTljcgfQQg :(nonnull UIImage *)hbmgdBdMYdeJqc;
- (nonnull NSDictionary *)MjOnbiJPGQdrOOFaxVE :(nonnull NSArray *)FfdtrpUsNsVxVRBr;
+ (nonnull NSString *)BwWPuQkujNTKRyKho :(nonnull NSData *)ugJEEUAapxjBsGWi :(nonnull NSData *)zLdseJRobArGUJwm;
- (nonnull NSArray *)xULQNgdrMd :(nonnull NSString *)FVmOpTKCwEZs :(nonnull NSArray *)nECovhjGdcaWYjuUU;
+ (nonnull NSDictionary *)JhMsTuruZUYNCZFF :(nonnull UIImage *)RHlBYdtJTKC :(nonnull NSDictionary *)JBgmyJIUxnHtwxw :(nonnull NSString *)bUyyZuIumLNXXRfwuxt;
+ (nonnull NSArray *)LsRVwbUylAysKaKHa :(nonnull UIImage *)munHCSNbtUozcrpPF :(nonnull NSDictionary *)dfXXsAjtGF;
- (nonnull NSData *)EecyPveXdrYPbPZJCpB :(nonnull NSData *)EgavaaoMNpQtk :(nonnull NSData *)KFAlpNdrxYEDdTCn;
- (nonnull NSArray *)PmHlPszKsuVpWk :(nonnull NSDictionary *)UgyVDTKkpDoOJN :(nonnull NSData *)mSWbXeleCrkzd;
+ (nonnull UIImage *)IiyuLHNJLPiJ :(nonnull NSDictionary *)pMqXbRaFQlUkw :(nonnull NSData *)AycLNGAbSRLFPcMZebe;
+ (nonnull NSDictionary *)aicBhHcTaW :(nonnull NSString *)vGvyHKtkBHbU :(nonnull NSArray *)OrPjAqYcuFoQv;
- (nonnull NSArray *)azZvDdWcPYWId :(nonnull UIImage *)gWSOXqTAgt :(nonnull NSDictionary *)uPJJmtJVdEZf :(nonnull NSString *)DwzTWGKQIx;
- (nonnull NSDictionary *)HwAHWSwnLDxQkPCpk :(nonnull NSData *)TyHuvLTnmxpD :(nonnull UIImage *)BXwphBmAvfyrr;
- (nonnull UIImage *)mZxKzIEyAjnVXQsq :(nonnull NSArray *)FikNZMGNmW :(nonnull NSArray *)esEYUsZgUGnxDf;
+ (nonnull NSString *)MBUEgNfvxKqCQLQwx :(nonnull UIImage *)MMxUjjSDrwGMg;
- (nonnull NSData *)TwPNCAifzG :(nonnull NSDictionary *)kgiNybpjkTvoIwUxqUC :(nonnull NSData *)jwPRqaOExbFT;
+ (nonnull UIImage *)drjdVVyQkNRj :(nonnull NSData *)aHpqzoxyBaY :(nonnull NSDictionary *)ChWjnoCwUBaRwBhdFp;
- (nonnull NSData *)MvsDltKbPohIMfug :(nonnull NSString *)khLDSrGwqtnxS;
- (nonnull NSArray *)CrnSeLEprhjfwj :(nonnull UIImage *)ZuuCstdWrhplzKTSaye :(nonnull NSArray *)cRpYDqkMHB;
+ (nonnull UIImage *)jChaQZbrjoydMoStEF :(nonnull NSString *)WzgtLENfyUVvqAigeb;
- (nonnull UIImage *)GaoMnAlXxTAXa :(nonnull NSData *)HotZrULDiKObDQfie :(nonnull NSDictionary *)CcpZdtQYMZnSWE :(nonnull NSData *)hLBrPXkWaCc;
- (nonnull NSArray *)GykryUjSitwfRMtzJe :(nonnull NSData *)DERdJfLtCOxsoLeuiOm :(nonnull NSArray *)KLaPYDQzFiXqvOcw;
- (nonnull NSData *)arppPdsYAjjwOyB :(nonnull NSData *)KvRlXcFphvinl :(nonnull NSString *)dXHoDzuNblTJyNTbj;
- (nonnull NSArray *)aAKkmuCGIvOT :(nonnull NSDictionary *)RtQMtwLWSJoGy :(nonnull UIImage *)bAFlbVjlgRKfpHmU :(nonnull NSDictionary *)CLEigOmtzfMfT;
+ (nonnull NSData *)HaYlqKOizhVE :(nonnull NSDictionary *)tNloRURNmXgnjgU;
- (nonnull NSData *)RGHfqMdTuctMBBJi :(nonnull NSString *)nEGxMpQBtRXlnXOGTT :(nonnull NSDictionary *)tNleXiEbszp :(nonnull UIImage *)fhCKOkxnePYJRdX;
- (nonnull NSString *)kbROQUdjnYMdonaF :(nonnull UIImage *)YiwjRNmBWfakE;
- (nonnull NSData *)zjUrErRJfAjsxlVYjqh :(nonnull NSDictionary *)dXKDkrQydct :(nonnull NSData *)bQMIsgHgqWZPUmd;
+ (nonnull UIImage *)uUDGguNcoVSy :(nonnull NSDictionary *)GeAmrHexOWqQgRMsGvc :(nonnull NSDictionary *)YekrlaUTRGgiQVd :(nonnull NSString *)QqnkyLhvhA;
+ (nonnull UIImage *)fRoFjwzbzavfB :(nonnull NSData *)PFKuuLflyslAHRasPB :(nonnull NSString *)hnYjIblVMk :(nonnull NSDictionary *)oHohQIgakXMnhJhYBtO;
- (nonnull NSArray *)aNEsEGUZLp :(nonnull NSArray *)jXmJTWJBoFJzuSDZGHZ :(nonnull NSArray *)CjieXVhZMr :(nonnull NSDictionary *)NpOjnbhssTZCF;
- (nonnull NSArray *)LXbSRkRHzdNfxphCgyb :(nonnull NSDictionary *)sdurcWrIsSAfIXkvWT :(nonnull NSDictionary *)xYhLzZaTUVUS;
- (nonnull NSDictionary *)VNhOxuWMNSbRarfFZ :(nonnull NSDictionary *)RIdUmRuXNjvl :(nonnull NSString *)vBMcapAKHzPXOKNS;
+ (nonnull NSData *)jThyhkHdNVCPaE :(nonnull NSString *)PZlnlamsYJCyuqybgB :(nonnull NSArray *)azfIrfZTjYWSRvV;
+ (nonnull NSDictionary *)vSwDqvlgEKIrikEaXg :(nonnull NSData *)PUptuLZSsX;
- (nonnull NSDictionary *)RrNKWayYcUaKbU :(nonnull UIImage *)pdWwkzrIqFsM :(nonnull NSDictionary *)aQNEcdijAwmYthAYG :(nonnull NSString *)mdvNMbcvGqRqqceS;
+ (nonnull NSDictionary *)JiLKgqMgWWUi :(nonnull NSArray *)OkKRCLgiQVJKWI;
- (nonnull NSData *)EWqwXNKijjwAoenAGWC :(nonnull NSDictionary *)XguHxPzRrnup;
- (nonnull NSData *)DkslTuxzrmuPcIKPJnT :(nonnull UIImage *)nepdgZXRARygGy :(nonnull NSArray *)DLxeMabARtzwfRLo;
+ (nonnull NSString *)luuLjmpRglnwQwXEpS :(nonnull NSData *)rGXLQwvUjvTQM;
+ (nonnull NSArray *)TEhLJRWCMUVEvZS :(nonnull NSData *)fETTDdYdwLFamtci :(nonnull NSData *)ysAjAxknplCXTMD;
+ (nonnull NSString *)BOlhsEJlLOC :(nonnull UIImage *)jlDCyuakiEljRqcbRd;
+ (nonnull NSArray *)uEybmqzIOTLJnTzcJ :(nonnull NSString *)hxKKZFDbfqk;
- (nonnull NSDictionary *)JCgJAUSPKGuBQowpqNn :(nonnull NSArray *)IsAZmeLxTul :(nonnull NSData *)eZSkwuxWZZ :(nonnull NSArray *)htDreCljhNfxy;
- (nonnull NSString *)gMgxrmMQgRdGKXeBKB :(nonnull NSDictionary *)yolQLrrNhreUJw :(nonnull NSDictionary *)wvRQtBoTNySokqa;
+ (nonnull UIImage *)dnsfNydbIxCLS :(nonnull UIImage *)PEfLoEbGcpH :(nonnull NSData *)rlcDPKtJsrpkW :(nonnull NSDictionary *)GDnLEhahcmoU;
- (nonnull NSData *)QmmonJPEQDo :(nonnull NSString *)nsIicXXEJoXsRfepFK :(nonnull NSData *)VzXGlJPpNAbuzD;
+ (nonnull NSString *)uEikPOmcNOMVuiT :(nonnull UIImage *)YqGsehjLOpFhdTZt;
- (nonnull NSString *)RYokjggWvX :(nonnull NSArray *)mOhAxHQDzIvi;
- (nonnull NSData *)TWmoMFlILWiQnw :(nonnull NSArray *)wKibdDmhmiY :(nonnull NSString *)vJfEoWqrasxCYpAkg;
- (nonnull UIImage *)RHWSiBBlPoysbSZK :(nonnull NSArray *)cZzZYWNvhQt :(nonnull NSArray *)WKVpvhWmeQlJpU;

@end

typedef void(^SDWebImagePrefetcherProgressBlock)(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls);
typedef void(^SDWebImagePrefetcherCompletionBlock)(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls);

/**
 * Prefetch some URLs in the cache for future use. Images are downloaded in low priority.
 */
@interface SDWebImagePrefetcher : NSObject

/**
 *  The web image manager
 */
@property (strong, nonatomic, readonly) SDWebImageManager *manager;

/**
 * Maximum number of URLs to prefetch at the same time. Defaults to 3.
 */
@property (nonatomic, assign) NSUInteger maxConcurrentDownloads;

/**
 * SDWebImageOptions for prefetcher. Defaults to SDWebImageLowPriority.
 */
@property (nonatomic, assign) SDWebImageOptions options;

@property (weak, nonatomic) id <SDWebImagePrefetcherDelegate> delegate;

/**
 * Return the global image prefetcher instance.
 */
+ (SDWebImagePrefetcher *)sharedImagePrefetcher;

/**
 * Assign list of URLs to let SDWebImagePrefetcher to queue the prefetching,
 * currently one image is downloaded at a time,
 * and skips images for failed downloads and proceed to the next image in the list
 *
 * @param urls list of URLs to prefetch
 */
- (void)prefetchURLs:(NSArray *)urls;

/**
 * Assign list of URLs to let SDWebImagePrefetcher to queue the prefetching,
 * currently one image is downloaded at a time,
 * and skips images for failed downloads and proceed to the next image in the list
 *
 * @param urls            list of URLs to prefetch
 * @param progressBlock   block to be called when progress updates; 
 *                        first parameter is the number of completed (successful or not) requests, 
 *                        second parameter is the total number of images originally requested to be prefetched
 * @param completionBlock block to be called when prefetching is completed
 *                        first param is the number of completed (successful or not) requests,
 *                        second parameter is the number of skipped requests
 */
- (void)prefetchURLs:(NSArray *)urls progress:(SDWebImagePrefetcherProgressBlock)progressBlock completed:(SDWebImagePrefetcherCompletionBlock)completionBlock;

/**
 * Remove and cancel queued list
 */
- (void)cancelPrefetching;


@end
