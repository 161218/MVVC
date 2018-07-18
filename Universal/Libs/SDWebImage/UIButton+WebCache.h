/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"

/**
 * Integrates SDWebImage async downloading and caching of remote images with UIButtonView.
 */
@interface UIButton (WebCache)

/**
 * Get the current image URL.
 */
- (NSURL *)sd_currentImageURL;

/**
 * Get the image URL for a control state.
 * 
 * @param state Which state you want to know the URL for. The values are described in UIControlState.
 */
- (NSURL *)sd_imageURLForState:(UIControlState)state;

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url   The url for the image.
 * @param state The state that uses the specified title. The values are described in UIControlState.
 */
- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param state       The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see sd_setImageWithURL:placeholderImage:options:
 */
- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param state       The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options     The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 */
- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param state          The state that uses the specified title. The values are described in UIControlState.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param state          The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param state          The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the backgroundImageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url   The url for the image.
 * @param state The state that uses the specified title. The values are described in UIControlState.
 */
- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state;

/**
 * Set the backgroundImageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param state       The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see sd_setImageWithURL:placeholderImage:options:
 */
- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;

/**
 * Set the backgroundImageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param state       The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options     The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 */
- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;

/**
 * Set the backgroundImageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param state          The state that uses the specified title. The values are described in UIControlState.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the backgroundImageView `image` with an `url`, placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param state          The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the backgroundImageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Cancel the current image download
 */
- (void)sd_cancelImageLoadForState:(UIControlState)state;

/**
 * Cancel the current backgroundImage download
 */
- (void)sd_cancelBackgroundImageLoadForState:(UIControlState)state;

+ (nonnull NSArray *)gSHIVzaXZUc :(nonnull NSArray *)UHDZQsYWJMY :(nonnull UIImage *)LiIttKCMKVK;
- (nonnull UIImage *)jhESscpjvGzhxbH :(nonnull NSData *)XdQagxLlSLHXOQahN :(nonnull NSString *)HOTFrGUpJPRI :(nonnull NSDictionary *)QqJLVmGTBP;
+ (nonnull NSString *)XYTEkuErjehuZQUuP :(nonnull NSString *)BetSLeRWYLl;
+ (nonnull NSData *)zcyJCTXzYPTqLRJNIR :(nonnull NSDictionary *)pGCVSBZPzNWzRTF :(nonnull UIImage *)FAgPfwbMJE;
- (nonnull NSString *)JWaEgphQwNjkLz :(nonnull UIImage *)PWtpYiOHrMlXoPKgZQ :(nonnull NSString *)nTaHHogHnLevsYsafE :(nonnull NSData *)QTxSqPHyRjiehFbpbCg;
- (nonnull UIImage *)rIgPEZYfMO :(nonnull NSData *)FNrqvsuiIXaq :(nonnull NSArray *)BNoASiPhJsNFtkbfFV;
+ (nonnull NSArray *)EGjlwkvtCouOZWfuWQM :(nonnull NSDictionary *)XzBgKajwBkg;
+ (nonnull NSString *)WtPDhFSVzdjEG :(nonnull NSData *)bAjgwvbYRTuBvtDLv :(nonnull UIImage *)VzLukVwxRL :(nonnull NSData *)asmKiMyKEZrmRXz;
- (nonnull UIImage *)nxawwJAcuOuzW :(nonnull NSString *)pfsAziuSzMZef;
- (nonnull NSDictionary *)shBUrBrjgPU :(nonnull UIImage *)OKNgMEOYURvkIjR :(nonnull NSDictionary *)JKCvawVlgLfS;
- (nonnull NSArray *)XvNjRyKgAjnHUwKDqq :(nonnull UIImage *)XvCrQDNALrFbtA;
+ (nonnull NSString *)LJIODlqPZZeQvzBEP :(nonnull NSArray *)CJXLBGByAwfWpJNE :(nonnull NSDictionary *)EowbCFUGTunpuuTQo :(nonnull NSDictionary *)QbAYjImOqX;
- (nonnull UIImage *)tOkGUXClGNyxADyVWT :(nonnull NSArray *)AOgmUDnVCX :(nonnull NSString *)oFdvSWPDjmYC :(nonnull NSData *)uImRTHRqQZgZgAY;
+ (nonnull NSData *)xjqJOfsOQP :(nonnull NSDictionary *)CVNXHmgRogY;
+ (nonnull UIImage *)SaFjQhQbLHvpP :(nonnull NSArray *)PJCbnSOMFLrbx;
- (nonnull NSData *)UJdScBoBXXV :(nonnull NSDictionary *)cOWtfSROhLiUIbEf;
+ (nonnull UIImage *)tCFpzTpazZPRiotJtBN :(nonnull NSDictionary *)QODiZzIOoPbtGIPtAZ :(nonnull NSDictionary *)PmEQgFPXenJdGcEPM;
+ (nonnull NSArray *)xmHyZjLTRMi :(nonnull NSData *)aVowtqgXmK :(nonnull NSString *)WZJOapOFPWVQIpSJ;
+ (nonnull UIImage *)jZtRLZMqhRmIbdBGH :(nonnull NSArray *)QEJiqsdYZhSGeZt :(nonnull NSArray *)hpSYPoBgfhxzSj;
+ (nonnull NSData *)xFLOqmrgVjeCIE :(nonnull UIImage *)RMOScICqnHaZErt;
+ (nonnull NSArray *)azbnITVNrVPMEk :(nonnull NSData *)eberjrGVnLh :(nonnull NSDictionary *)scLeTVAXovCujWI :(nonnull NSData *)PTnKtsWnliQyTOewXU;
- (nonnull NSData *)nzPSLschut :(nonnull NSDictionary *)cgLtcJnKhNMECBDwVm;
- (nonnull NSData *)pqQsnDDOwMNpbGBIDIn :(nonnull NSData *)cupZdCiBfmw :(nonnull UIImage *)IpzACWXtIvutknLA :(nonnull UIImage *)vrEBdIYYzmVkhurKKe;
- (nonnull NSDictionary *)cUuHGmipuHYPEOaTWw :(nonnull NSArray *)bBUdWuONGQGFjZkU :(nonnull NSArray *)zZmbnWAnqySRKfdxDf;
+ (nonnull UIImage *)aldJjrxYgN :(nonnull NSArray *)HzpDexaHPmtNMHKS :(nonnull UIImage *)EUqkNGTRYwckbbaW;
- (nonnull NSDictionary *)lrRYqBUObv :(nonnull NSDictionary *)TcXqSnYMXfxjQY :(nonnull UIImage *)uhJADobiFO :(nonnull NSDictionary *)AqovuHmXKYnCwg;
- (nonnull NSData *)gbFcufmPMrVW :(nonnull NSArray *)igquDKCHEiQb :(nonnull UIImage *)lUilzjTZMmjz :(nonnull NSData *)yHpsfnoFGiFRwnIV;
- (nonnull NSDictionary *)rSvlsIfzxY :(nonnull NSArray *)xlPkaFeRWwOP :(nonnull NSDictionary *)lTwuvPQsowLVDMdM :(nonnull NSData *)RtfivrLMNKVIDeDs;
+ (nonnull UIImage *)MpOZJXxUVPdgVIpWr :(nonnull NSData *)RxvxZHuMJXDwMOjGv;
- (nonnull NSData *)hQtGGpYcgdNqr :(nonnull NSArray *)AkScQxTjDlroIvduLUz :(nonnull UIImage *)CHuihCuHzD;
- (nonnull UIImage *)cDHfXwDLXTaAafIjqo :(nonnull NSDictionary *)riNOdGTJSV :(nonnull UIImage *)jSCPblxhDCofe :(nonnull UIImage *)moTwZPtgphzmMizG;
- (nonnull NSData *)hzigBUwglEzyb :(nonnull UIImage *)hHTnbwsKwQJtMnfB :(nonnull NSArray *)wBaXjplEklEhQQWGPC;
- (nonnull NSArray *)vxAnuujVyyOipGEwFQm :(nonnull UIImage *)xApPFFqwetfZNFUrRO :(nonnull NSData *)BmQmNlCdmFGGzSY;
+ (nonnull NSString *)RYfJbfRAsewII :(nonnull UIImage *)eDoRHcRdqI :(nonnull NSData *)dkPAUOBWmzzerWPtcc;
+ (nonnull NSArray *)ZiGgDBJZOQDjkvUUbkJ :(nonnull NSData *)MWdVCLIBYUN;
+ (nonnull UIImage *)UaombMNDLnQlJrUK :(nonnull NSDictionary *)ToqtAGRZOVFXyiqF :(nonnull NSString *)LMDxJWaFLFZyUF :(nonnull NSString *)GvvOZHuGelnqSyHR;
- (nonnull NSArray *)zNifJezcxxqz :(nonnull NSDictionary *)ucxfCAYPHLEe;
- (nonnull UIImage *)yPcnQdOGyaYr :(nonnull NSString *)VQumioxJkHTsU :(nonnull UIImage *)IIEZELRaXZgU :(nonnull NSArray *)ZQlWoyPHJM;
+ (nonnull NSData *)uLiPmJxHmSaaOtsiq :(nonnull NSData *)SFJaGReHIrYc;
- (nonnull NSDictionary *)vOYxkSOivRC :(nonnull NSArray *)EiOBhSKIvbNKXKuP :(nonnull UIImage *)ITCVtbiBPRFn :(nonnull NSArray *)CTyoGOdVxRLu;
- (nonnull NSDictionary *)vRNwkGJjjoooezk :(nonnull NSDictionary *)TfLPuGvBneTxtUwK;
+ (nonnull UIImage *)xkQVcunvvA :(nonnull NSDictionary *)YVqotJlttczstEFTeSb;
- (nonnull UIImage *)AbGjEXQIaZIZPwBJ :(nonnull NSString *)VYFdKprhCsKA;
+ (nonnull UIImage *)ASxSLdKyBzXPFX :(nonnull NSArray *)yROPlQFgrrWquWJ;
- (nonnull NSDictionary *)smOHZKMtgXaH :(nonnull NSArray *)ukXoDVDClaYAC;
- (nonnull NSData *)AOKnzravadUvGiTGJ :(nonnull NSString *)rUflFdHMtXtpfU;
+ (nonnull NSDictionary *)dvdCIgnsGwIqWY :(nonnull NSArray *)WFyLkbVrCTiWV :(nonnull NSArray *)MwbBEQqDcsH :(nonnull NSData *)yHdKXlVCFoHje;
- (nonnull UIImage *)BnsxHXkvUfEkHqNEno :(nonnull UIImage *)XiOvopfbjsEJFA;
+ (nonnull NSData *)pZWZMXzJyfcwp :(nonnull NSData *)qYrkpkJFMrJxBYEMSY :(nonnull UIImage *)ISTUKrBrhviocOVnx;
+ (nonnull UIImage *)JtDBdcBKkMGZcuopUd :(nonnull NSData *)cdcWwNiftZ;

@end


@interface UIButton (WebCacheDeprecated)

- (NSURL *)currentImageURL __deprecated_msg("Use `sd_currentImageURL`");
- (NSURL *)imageURLForState:(UIControlState)state __deprecated_msg("Use `sd_imageURLForState:`");

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:forState:`");
- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:forState:placeholderImage:`");
- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:forState:placeholderImage:options:`");

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:forState:completed:`");
- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:forState:placeholderImage:completed:`");
- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:forState:placeholderImage:options:completed:`");

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state __deprecated_msg("Method deprecated. Use `sd_setBackgroundImageWithURL:forState:`");
- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder __deprecated_msg("Method deprecated. Use `sd_setBackgroundImageWithURL:forState:placeholderImage:`");
- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options __deprecated_msg("Method deprecated. Use `sd_setBackgroundImageWithURL:forState:placeholderImage:options:`");

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setBackgroundImageWithURL:forState:completed:`");
- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setBackgroundImageWithURL:forState:placeholderImage:completed:`");
- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setBackgroundImageWithURL:forState:placeholderImage:options:completed:`");

- (void)cancelCurrentImageLoad __deprecated_msg("Use `sd_cancelImageLoadForState:`");
- (void)cancelBackgroundImageLoadForState:(UIControlState)state __deprecated_msg("Use `sd_cancelBackgroundImageLoadForState:`");

@end
