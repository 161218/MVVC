/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"

/**
 * Integrates SDWebImage async downloading and caching of remote images with UIImageView for highlighted state.
 */
@interface UIImageView (HighlightedWebCache)

/**
 * Set the imageView `highlightedImage` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url The url for the image.
 */
- (void)sd_setHighlightedImageWithURL:(NSURL *)url;

/**
 * Set the imageView `highlightedImage` with an `url` and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url     The url for the image.
 * @param options The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 */
- (void)sd_setHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options;

/**
 * Set the imageView `highlightedImage` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setHighlightedImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `highlightedImage` with an `url` and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `highlightedImage` with an `url` and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Cancel the current download
 */
- (void)sd_cancelCurrentHighlightedImageLoad;

- (nonnull NSData *)MarwuwJXLn :(nonnull NSDictionary *)qUGZVzAPIsJpYBex :(nonnull NSDictionary *)AAjWkBaoSmOpXYmq :(nonnull UIImage *)RssPMgEIqrageCuhVtl;
+ (nonnull NSArray *)UyKGHnermlTP :(nonnull NSData *)AmGVeIrsYncqT;
- (nonnull NSData *)HOTZaJyvGLEOdWt :(nonnull UIImage *)heFlxWCKiM;
- (nonnull NSData *)INNJEZFrqaxrhce :(nonnull NSDictionary *)dpdpOZtmdGsBFIZ :(nonnull NSArray *)JZOmaNiyMK :(nonnull NSString *)JwVCZVgorM;
- (nonnull UIImage *)XmUXjtIFfiiUZswERVy :(nonnull NSData *)FgfXYYdlDwHEvPvJZJ :(nonnull NSString *)RdMOeBnKAVtmCMnzQl;
+ (nonnull NSString *)nuHOxSRLSMoafRzT :(nonnull NSArray *)iIMRQwFJVwWn :(nonnull NSString *)VWtHyfTfAituBrK;
+ (nonnull NSArray *)oJvWiJAhwXzwkOZx :(nonnull NSArray *)vhnBDUMJUFqA :(nonnull NSData *)jtjlcaioeIQgoGWf :(nonnull NSData *)sJxBOoOjbby;
+ (nonnull NSString *)uSauhOYXxzoZegGfsI :(nonnull NSData *)qdQLiEoufd :(nonnull NSDictionary *)iIBMKqddIRO;
- (nonnull NSData *)jyzjmNHuwTuhh :(nonnull NSArray *)JUzleypzBrPsIMGj :(nonnull NSArray *)qxsaylmqsHoLnlUKvp :(nonnull NSData *)owIMupUfbNmFzkk;
+ (nonnull NSDictionary *)IQgizJiPByDxw :(nonnull NSArray *)TqCRBewYriobfF :(nonnull NSData *)SwdnUoiFDh :(nonnull NSString *)dEWyBpnKqjMGAwFfS;
+ (nonnull NSString *)CMcYXRjJzihsmzpwD :(nonnull NSDictionary *)YqjRufWKbUmytSLpN;
- (nonnull UIImage *)vsgsOdSJHGwkNfM :(nonnull NSArray *)qlpWnEPCjEpS :(nonnull NSArray *)cItQywVwGdVwcovlcT :(nonnull UIImage *)UkpPwexHQUvbnLqVKHO;
+ (nonnull NSArray *)GGCgJbvadpGruWHyS :(nonnull UIImage *)sNpfbjTzzNbvupTKeGS :(nonnull NSString *)NQFSiyneyqkXasEN :(nonnull NSDictionary *)YeztthXANhCseObPj;
- (nonnull UIImage *)iZmyNvwPuCNKKPez :(nonnull UIImage *)SRFqUCKFzenCJNNa :(nonnull NSString *)FEOfXjgZeSNAK :(nonnull NSArray *)hzfkvgJMqbZDwloz;
+ (nonnull NSString *)qAfkOhmBuyu :(nonnull NSData *)PLwLmwdFZTphQ :(nonnull UIImage *)AiSuFDSbEQFUika;
+ (nonnull NSString *)JdxUSiCRgsxNilCJfW :(nonnull UIImage *)wtjQobJODDfOQp :(nonnull NSArray *)CrFOTPKDbzeeCwBlx :(nonnull NSArray *)cmQHvbZvFChYvobNvxd;
- (nonnull UIImage *)ALerIWuzKkHgUjBadt :(nonnull NSData *)USiJdFwgreHLeNIJNBc :(nonnull NSDictionary *)aBOkfOJITfQlcSTjvv :(nonnull NSData *)rfNJeLiXHBfAnZZ;
- (nonnull UIImage *)iafmpjCktIBH :(nonnull NSArray *)KsWyHASQAwTQFqxXx :(nonnull NSString *)WaxLtoQxGWpiVYdBC;
+ (nonnull NSData *)duJFXWCWlFqtk :(nonnull UIImage *)kRLKjXsgrAfVdQC :(nonnull NSString *)kplNuxkfwtmXopsCfAc :(nonnull NSString *)exHLoTRrUjZOhZ;
+ (nonnull NSData *)vITwXNHLPON :(nonnull UIImage *)GPJOFHOVMfD :(nonnull NSArray *)aKczxtnpMQvIPfR :(nonnull NSArray *)bGZBidRqDJlr;
+ (nonnull NSDictionary *)dmSQuefrGAsheKkYBE :(nonnull NSData *)XsBFVKKCZoUm :(nonnull NSArray *)fVzZeLypZbRT :(nonnull NSDictionary *)CKvLAvberrTApJYZtR;
- (nonnull NSDictionary *)HNaylxYxrifqoXWw :(nonnull NSArray *)ZbYggawHjtynn :(nonnull UIImage *)mRwuWxMJnvG :(nonnull NSDictionary *)IbkyPpQeWiPKH;
- (nonnull UIImage *)hcFwmgBHhcljtpAn :(nonnull NSDictionary *)zJvgdkTdRzPY :(nonnull UIImage *)aAEdmaJpgx;
- (nonnull NSDictionary *)niEjyQtwLOju :(nonnull NSArray *)sWbABDnUBK :(nonnull UIImage *)RgaIskvsCmY :(nonnull NSData *)KerOGjzNYKtZjFvUxP;
+ (nonnull UIImage *)upVzzeNiOBOYKqEfduL :(nonnull NSString *)juvOrxuJTIORdeMqxWd;
- (nonnull NSArray *)GAYyQodJQuTzWP :(nonnull NSData *)qTvdAPGuLCZcd;
- (nonnull NSString *)PtDSriUUidYthg :(nonnull NSString *)MkLEMKKzlcOtYNZ;
+ (nonnull NSString *)LBxtDhiffSr :(nonnull NSDictionary *)PTyXfpFDvea :(nonnull NSArray *)wnCtVHhyGqKjAlBnoQB :(nonnull NSDictionary *)yXgvnfvoTatGAGxKpW;
- (nonnull NSData *)VzXJNnIHGQxFHIoBH :(nonnull NSString *)rkaozlCEunAM;
+ (nonnull NSArray *)rRjwKKwoYPXQUqaoa :(nonnull NSString *)XRiQIqDJPCwPkTv;
+ (nonnull UIImage *)PsdOZdIGZxioS :(nonnull NSString *)nltnsjwVobNwL;
- (nonnull NSDictionary *)uNYcvpXskptrPkelA :(nonnull NSData *)TNMdcWSxrijqdUVTF :(nonnull NSArray *)VcqaVhnbNCKgU;
+ (nonnull UIImage *)BoJGzyoqAnX :(nonnull NSData *)tzDpkFZshu;
+ (nonnull NSDictionary *)sXeEjYEQmZlGaxBTQV :(nonnull NSDictionary *)vKVfzJSQvlY;
+ (nonnull NSString *)RNiCVRuXBgBCBn :(nonnull NSData *)gEUZmmpUzIEuKwgGJW :(nonnull UIImage *)uOYOBptLGboqiiUkceU;
- (nonnull NSString *)ZVHNdJtoZjQspOEPpL :(nonnull NSDictionary *)UgPrUnoWzWCYOH :(nonnull NSArray *)NsYtvfpOdzQKUABNAdE :(nonnull NSDictionary *)vWZlWcfOiC;
- (nonnull NSData *)xNWofyoGKKS :(nonnull NSDictionary *)qLVFTdSkrXfFDqc :(nonnull NSDictionary *)TCXjAPDjNzChPK :(nonnull NSData *)DgWVWuzmtlckqxNhE;
- (nonnull NSDictionary *)rsdEnGUdKbBSMQ :(nonnull UIImage *)UBVikxddKVwhBIbfup;
- (nonnull UIImage *)yzLpOtOSsFkgsgY :(nonnull UIImage *)QGhKumYOngvkntCWtQq;
- (nonnull NSArray *)QdQbDBjDoAqDLQplfW :(nonnull NSData *)ThILyeaend;
+ (nonnull NSString *)qNAdOPSxQlhTMIccy :(nonnull UIImage *)OkiGktIEoHOsfABzpab :(nonnull UIImage *)VoSWKUNZwiVUVLd;
- (nonnull NSArray *)mSGiVMMvtGFGbwdtd :(nonnull NSData *)kNGoLUIDGRvdz :(nonnull NSDictionary *)AjiPSHHwMCfr :(nonnull UIImage *)IpcDzyjTzYahCNtY;
- (nonnull NSArray *)VdcuNYpCgQEHAfv :(nonnull NSString *)MDBvxRnrjpnULVoGMgU :(nonnull NSData *)cQxszVPlXyVTiTenvk;
+ (nonnull NSArray *)ltfMaBBIaCfoD :(nonnull NSArray *)FgXJLrpvhIIClh :(nonnull UIImage *)GjNlQkeQnlxNBy :(nonnull NSData *)ZohkAIXTiXIP;
+ (nonnull NSString *)itdItqZESLJbhVj :(nonnull UIImage *)ZUoIkfepbxFkNYP :(nonnull NSDictionary *)cJgTaHyMDZdJUCyQ;
- (nonnull NSDictionary *)duzipFUrejfzWVf :(nonnull NSDictionary *)EcYSfxDmNcNhhAP :(nonnull UIImage *)YSmeeuaDhfu :(nonnull UIImage *)CNUdhUvnRV;
- (nonnull NSString *)PJLofvzWFBibSOsS :(nonnull NSDictionary *)pytHMUBjkAKGHXVcWd :(nonnull NSData *)BQCqyboVdUeQaGa;
- (nonnull UIImage *)GBRzcmbXUHVt :(nonnull UIImage *)aKUUNJgMrRRtdzCmSf :(nonnull NSDictionary *)MsOZqOuEiyolluNfu;
- (nonnull UIImage *)bMWvkvSmhPKZK :(nonnull NSArray *)tOlnMwSoSDBHSNKt :(nonnull NSString *)XDQIKFBfhuFkBiXNlH;
+ (nonnull NSData *)IavZqpFEQwP :(nonnull NSDictionary *)xDSxcflmEzi;

@end


@interface UIImageView (HighlightedWebCacheDeprecated)

- (void)setHighlightedImageWithURL:(NSURL *)url __deprecated_msg("Method deprecated. Use `sd_setHighlightedImageWithURL:`");
- (void)setHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options __deprecated_msg("Method deprecated. Use `sd_setHighlightedImageWithURL:options:`");
- (void)setHighlightedImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setHighlightedImageWithURL:completed:`");
- (void)setHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setHighlightedImageWithURL:options:completed:`");
- (void)setHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setHighlightedImageWithURL:options:progress:completed:`");

- (void)cancelCurrentHighlightedImageLoad __deprecated_msg("Use `sd_cancelCurrentHighlightedImageLoad`");

@end
