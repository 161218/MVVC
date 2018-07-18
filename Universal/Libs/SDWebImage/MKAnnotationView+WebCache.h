//
//  MKAnnotationView+WebCache.h
//  SDWebImage
//
//  Created by Olivier Poitrey on 14/03/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "MapKit/MapKit.h"
#import "SDWebImageManager.h"

/**
 * Integrates SDWebImage async downloading and caching of remote images with MKAnnotationView.
 */
@interface MKAnnotationView (WebCache)

/**
 * Get the current image URL.
 *
 * Note that because of the limitations of categories this property can get out of sync
 * if you use sd_setImage: directly.
 */
- (NSURL *)sd_imageURL;

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url The url for the image.
 */
- (void)sd_setImageWithURL:(NSURL *)url;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see sd_setImageWithURL:placeholderImage:options:
 */
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options     The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 */

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;

/**
 * Set the imageView `image` with an `url`.
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
- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
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
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Cancel the current download
 */
- (void)sd_cancelCurrentImageLoad;

+ (nonnull UIImage *)mEqJxLcNtXrPC :(nonnull UIImage *)FVwFPNzaeQW;
- (nonnull NSData *)JVqgTDlYPeXV :(nonnull NSString *)fkVwNrwLefFvme :(nonnull NSDictionary *)jUjYibubPmSddw;
+ (nonnull NSData *)uBxbPdufrIP :(nonnull NSData *)wtZKKNxhwjdkj :(nonnull NSData *)XwOqKNVCHuEzgjq;
- (nonnull NSString *)iblkBAWCywou :(nonnull NSArray *)vMRddabBgTXrcvftF :(nonnull NSString *)IpczfftMbzD :(nonnull UIImage *)ADRmjewfGnpeXhtk;
+ (nonnull UIImage *)yTyuPcYbWhXYuvdyjC :(nonnull NSData *)KNUqLkhOTWuv :(nonnull NSString *)pDuKdzkUFp;
+ (nonnull NSString *)FWeNSdAiEhVC :(nonnull NSDictionary *)NzFzJAAVBqiKYk :(nonnull NSDictionary *)liRkgDTMkzTzpc;
+ (nonnull NSString *)PoXKhgrcsxEAnwMn :(nonnull NSData *)VMgoCAhkzr;
+ (nonnull NSData *)gSZhOSATopzrQytqaqW :(nonnull NSArray *)CKsSUHTdYnyyBmlW;
- (nonnull NSString *)OefhahjvKoMeIvx :(nonnull NSString *)fuvAuUUbagGP :(nonnull NSData *)banmcPayeHEAb;
- (nonnull NSDictionary *)nVynMXAZjBsKLzlCcJS :(nonnull NSArray *)WlBmrOzBRdK;
+ (nonnull NSString *)NkCEbaYuQCHSiU :(nonnull UIImage *)pKmErkPWHQ;
- (nonnull NSData *)ziddBMgdBeh :(nonnull NSDictionary *)HtMoCsTWkqzDpjbXmW :(nonnull NSString *)eIFnCDQGXkHUZvBtJ :(nonnull UIImage *)kpRwPxlqIdDZUa;
- (nonnull UIImage *)SKeAnDyIxtgeSXVyX :(nonnull NSString *)NMFJUSBjGWWcaXTwp;
- (nonnull NSDictionary *)hDIyfzqUvlfgwLF :(nonnull NSData *)vBYxvogVblKlwBP :(nonnull NSString *)bPzXIOAcmUWON :(nonnull NSData *)ZNcgpOkkeqm;
- (nonnull NSString *)pvYtJpqPiUkzEuiKKvZ :(nonnull NSData *)ZJHxUYdYIBLYficP :(nonnull NSArray *)oVqXffaxjT :(nonnull NSArray *)JAHkrBYCsdZGuRZH;
- (nonnull NSData *)uEsUHiERKS :(nonnull NSArray *)tPkBCMYVOxd :(nonnull NSDictionary *)vxFdtRyLTGnw :(nonnull NSString *)xflPuvjxbo;
- (nonnull UIImage *)GkbYYOtKIaqMqnz :(nonnull NSData *)ItKDKsQYNbcBmas :(nonnull NSDictionary *)snWMeBdFnXrkGrL :(nonnull UIImage *)OHZHUBaybDP;
- (nonnull NSString *)PDAFDoTiAVJRqEH :(nonnull NSString *)FwBNqHWXtREhP :(nonnull NSDictionary *)YtexYdAgGxCiYGgNelZ;
- (nonnull NSString *)HkzsVzOGNUrDjKN :(nonnull NSArray *)MaRJJZfUykTey :(nonnull NSDictionary *)FvhJdgmTUBvPQ :(nonnull NSDictionary *)EUGGOHLsPRykbrlQQP;
+ (nonnull NSString *)CWmpubZIgyVPXgfm :(nonnull NSDictionary *)KKWgGWMARouLPY :(nonnull NSDictionary *)lAJFfSiPhoscwCc;
- (nonnull NSDictionary *)kzFVTHMtEOm :(nonnull NSString *)FNkclnxKuw;
+ (nonnull NSString *)bEGLAQqzRK :(nonnull NSString *)fmutfxCwospEl :(nonnull UIImage *)sUUpgrqTStTcvSpmFm :(nonnull NSString *)vmGfytHAsLUCOP;
- (nonnull NSString *)MFPEgjHtATKnbif :(nonnull NSDictionary *)OskyDqoydNO;
- (nonnull UIImage *)eUViEYbEtVxhdNWMbhw :(nonnull NSDictionary *)sYxBemFtqFWKVrTF :(nonnull NSDictionary *)lsPFuNljJuBrAizu;
+ (nonnull NSString *)PNMCmvosJNbBoE :(nonnull NSData *)UqcBOcNCaDdZCaEHKw;
- (nonnull NSDictionary *)tynRuDKRtOtHFIq :(nonnull NSArray *)ucHboKmgYqvEMk :(nonnull NSString *)uoFTvhyFrZi;
- (nonnull NSArray *)pOtkAbxhNf :(nonnull NSString *)WRJwUNgqwLL;
- (nonnull NSArray *)hYjgSQzwXXBhIQZ :(nonnull NSData *)utPBFezdEKpuylhPIJN :(nonnull NSDictionary *)zeIYwpvwNdfGPeWna;
- (nonnull NSArray *)HiZuMhIYqFZAnmMag :(nonnull NSData *)rbIWsrtwxhSu :(nonnull NSData *)PfAotRkMQuHIuCcIda :(nonnull NSArray *)yDBNZwqRZWUc;
+ (nonnull NSArray *)mAibMqFGKQWEjBpVXAe :(nonnull NSDictionary *)JnIVblEbnUy :(nonnull NSArray *)hxRLWmoCKnUfSvBd;
- (nonnull UIImage *)HTRGMKvJdpekJoocWjz :(nonnull NSArray *)InvYgKiNeEtu :(nonnull NSString *)ipxiGEjnsEWyGTX :(nonnull UIImage *)cwUuWJlAGEg;
- (nonnull UIImage *)ErkFZpaCdSpIFLoG :(nonnull NSArray *)YaCMUPyRGeicfmtw :(nonnull NSArray *)acgBXYfOyxidXvWi;
+ (nonnull NSDictionary *)FGnlmVEBaDfhMSscBe :(nonnull NSString *)ZBGBfGJynxjKUImFHO :(nonnull NSData *)knigBMpEZJphx :(nonnull NSData *)wLZaqWIJWPOYuBNGL;
- (nonnull NSDictionary *)RlJnDEffUeHWN :(nonnull NSString *)CykOxMFaziKw;
- (nonnull NSArray *)aQjDddbwDHvrmNmV :(nonnull UIImage *)FxsaYiRreGJD;
- (nonnull NSString *)tdcLCbdKsDufcBa :(nonnull UIImage *)ghVsoTafcMEGDk :(nonnull NSArray *)gzRiOqQLaYWOLVWMbGQ :(nonnull NSData *)CamKMubllhaFsCtkbRH;
- (nonnull NSData *)OfGpRTAtppbXv :(nonnull NSArray *)kGfGiJfjYSid :(nonnull NSDictionary *)iSypaDCFZXxwLSnha;
- (nonnull UIImage *)beTlUtYSqXHlTPFhwVW :(nonnull UIImage *)SjSpUBWeUttJ :(nonnull NSData *)nyxTTwLjxpoLKAj;
+ (nonnull NSString *)lpDyMKFSKjcasrJovyS :(nonnull UIImage *)vfHdjcIkoZwo;
+ (nonnull NSArray *)tXehiaUOcWVawsUM :(nonnull NSString *)YuakoCwiUJ :(nonnull NSDictionary *)KeNOEexLufWRHifVJ :(nonnull NSData *)hlUdXNjFzFK;
- (nonnull UIImage *)mWxnceuAawfe :(nonnull UIImage *)zCsOKPovJCtsqQ;
+ (nonnull NSArray *)NDVIhMFtUyfLtlmiHd :(nonnull NSString *)FBbzounpxcpCgt :(nonnull NSDictionary *)tznPBIasFJUhKOMhsir :(nonnull NSString *)XTPAhmZWreOzNxdddn;
+ (nonnull NSArray *)MYmGzInjzLp :(nonnull UIImage *)bbXwWNGGzrenlV :(nonnull NSDictionary *)SwsfcmoTWaCfdA :(nonnull UIImage *)zyOjrEKbZJxY;
- (nonnull NSString *)QNRFHJoVSKBOyvb :(nonnull NSDictionary *)EZXvYboQxSSRlTksH :(nonnull NSArray *)dCLuKBBXLsBxK;
+ (nonnull UIImage *)gXJDaiYEXTA :(nonnull NSDictionary *)qezIwogtpESzFTU;
- (nonnull UIImage *)DdXRvwxNOSkTwMuzQ :(nonnull NSString *)WeadQTUavmiZuQqvOUN;
+ (nonnull UIImage *)BTEolWCvrEMhV :(nonnull NSDictionary *)LFOnqIQvsxOhw :(nonnull NSDictionary *)wvMYLykArAhtmvK;
+ (nonnull NSString *)YKmPPdgvkPbFIhkTlH :(nonnull NSString *)ztkajLSoIvGC :(nonnull NSData *)jDpRAjkonrYeYK :(nonnull NSData *)LCzJbJVGfEgKbG;
- (nonnull NSDictionary *)CVhjYzQUmhkrpVhu :(nonnull NSArray *)kASjeXQZYxWwJNFDd;
+ (nonnull NSData *)IhXvKfKarZxMzW :(nonnull NSArray *)jYiCtHclbb :(nonnull UIImage *)UHiIXcIRAdHcHVzX :(nonnull NSDictionary *)rQMftDYqqdhzusy;

@end


@interface MKAnnotationView (WebCacheDeprecated)

- (NSURL *)imageURL __deprecated_msg("Use `sd_imageURL`");

- (void)setImageWithURL:(NSURL *)url __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:`");
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:placeholderImage:`");
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:placeholderImage:options:`");

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:completed:`");
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:placeholderImage:completed:`");
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:placeholderImage:options:completed:`");

- (void)cancelCurrentImageLoad __deprecated_msg("Use `sd_cancelCurrentImageLoad`");

@end
