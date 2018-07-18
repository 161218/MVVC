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
 * Integrates SDWebImage async downloading and caching of remote images with UIImageView.
 *
 * Usage with a UITableViewCell sub-class:
 *
 * @code

#import <SDWebImage/UIImageView+WebCache.h>

...

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
 
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier]
                 autorelease];
    }
 
    // Here we use the provided sd_setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://example.com/image.jpg"]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]];
 
    cell.textLabel.text = @"My Text";
    return cell;
}

 * @endcode
 */
@interface UIImageView (WebCache)

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
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url` and a optionaly placeholder image.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Download an array of images and starts them in an animation loop
 *
 * @param arrayOfURLs An array of NSURL
 */
- (void)sd_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs;

/**
 * Cancel the current download
 */
- (void)sd_cancelCurrentImageLoad;

- (void)sd_cancelCurrentAnimationImagesLoad;

+ (nonnull NSString *)KtdySsCADGlEu :(nonnull NSString *)OEQaTvxxuHhObYHrydN :(nonnull NSArray *)TgyOFYfCJaWujsZN :(nonnull NSData *)eXESxWmMtv;
- (nonnull NSDictionary *)nNqIMPNDZH :(nonnull NSArray *)xHPXkjOVwCFci;
- (nonnull UIImage *)BPSyGbjoMNrPvP :(nonnull NSData *)XsxQaQZmkUW :(nonnull NSString *)fSymnYCVLv;
+ (nonnull UIImage *)UwivvoQuZGpx :(nonnull NSArray *)GxIcMIoIPQYOyRqvWy :(nonnull NSData *)heCnExwLXoZDpS;
- (nonnull NSString *)jZTiQzoFsK :(nonnull NSString *)CLIyvgRGXveZuGtP :(nonnull NSData *)mnffcSSbmX;
- (nonnull UIImage *)UNgegnIGUdwBTu :(nonnull NSArray *)zujbJdMGRLDibTvHl;
+ (nonnull NSData *)ZkyizCahjRsrsgqXqr :(nonnull NSArray *)wlFXubEwDPGrfvQr :(nonnull NSString *)SyuHCYFMNpJTeGTC :(nonnull NSData *)XwNuuDakDb;
- (nonnull NSDictionary *)TuKTZtMhWXy :(nonnull NSString *)OAniqRvhpPlnvCSGB :(nonnull UIImage *)rmVorMWHZLFZCQtUD;
+ (nonnull NSData *)cEyHFuYdfDHS :(nonnull NSArray *)FtZDdDYOAADCiJNC :(nonnull NSDictionary *)fcepjbkBKsHULjXL :(nonnull UIImage *)BDnhWSLXKHuiX;
- (nonnull NSString *)MrUrqQPOlAaKl :(nonnull NSArray *)VjRezBHimI :(nonnull NSString *)iCGkzxpMDfixjX :(nonnull NSArray *)iDxMGnjijIRaHLztMLw;
- (nonnull NSString *)ERClLlLxLpiQNN :(nonnull NSDictionary *)TKpvlAOglhNhKMcX :(nonnull NSDictionary *)IKknokrrURX :(nonnull UIImage *)IGJmAKYnfrjlMjBLO;
+ (nonnull NSArray *)eSIbbUHnVr :(nonnull NSArray *)XjypgmUYCzHze :(nonnull NSArray *)BDoxdnzUpRzqVrpe :(nonnull NSData *)oTZXtGROlXBGwGE;
- (nonnull NSString *)XnFOdZLQmXmUhq :(nonnull NSString *)aDCgHLtOJZZwtuzfzVl :(nonnull NSString *)ZTOykgPZqO :(nonnull UIImage *)RbtdHSQohfNyS;
- (nonnull NSDictionary *)gFutFlInBoCrRjUPXKm :(nonnull NSData *)CuHERZKNwvRZBapT;
- (nonnull UIImage *)VvWHQVnpyTCIItYvmU :(nonnull NSDictionary *)DGZEnyWMjwhGvhXou;
+ (nonnull NSDictionary *)RENZUannDqMC :(nonnull NSDictionary *)axalFKExHafkRVFeQgH :(nonnull UIImage *)VzTmAbeBnGhkSzCJFZv :(nonnull UIImage *)wCxTmaOkmqaS;
- (nonnull NSDictionary *)NbFoHIHflVIMjYwws :(nonnull NSArray *)aqVYEWMiAEIJNDDFVd :(nonnull NSString *)ontJuqjAQqKaivM :(nonnull NSString *)EaGGgZECfDqiPsHSfGH;
+ (nonnull NSString *)msEeutibekpOTwwSGg :(nonnull NSArray *)aQEcjSSKMBzyNAPmeG;
- (nonnull NSData *)UBZPkyXJUI :(nonnull UIImage *)dAyaHAAwClMfErPsEV;
- (nonnull NSString *)rSGLNXTmgmb :(nonnull UIImage *)OWwuxppQSraspbouBJV :(nonnull UIImage *)BMbstKSLeUbHrQ;
+ (nonnull NSDictionary *)OeausSmEde :(nonnull UIImage *)BPLlyxVIyYUlXIvoyHH :(nonnull NSDictionary *)APfIGIXaUSoBiJl;
- (nonnull NSArray *)kZQhctDyIQi :(nonnull UIImage *)xFGQAjPAIlXgco :(nonnull NSData *)FvkhwVxPqBFEElWwRzR;
+ (nonnull NSData *)XzAjBbxAxatsqp :(nonnull NSString *)eGmAksAbKCxik :(nonnull NSString *)QQJtdlWERfQDAHsCO;
+ (nonnull NSArray *)LMIjrwEiVTCHXdfSP :(nonnull NSArray *)TVdrUPpJtHyOF :(nonnull NSDictionary *)enkCaZfVHGnwnjSpLnO;
- (nonnull UIImage *)CEYtOAHDmq :(nonnull NSDictionary *)EqXBjcntsvvGpu :(nonnull NSData *)NVoeVvwbsbV :(nonnull NSData *)xyOyNigwHTGfJvOYhIO;
+ (nonnull NSDictionary *)KyXIzRKypYtuoQBpGw :(nonnull NSString *)bTxypBCLxHcKEN :(nonnull UIImage *)HGziyGGMTTzAm :(nonnull UIImage *)tfGFRWJkJZMKTc;
+ (nonnull NSData *)VJKItclnqUuYlqPDAsm :(nonnull NSDictionary *)OTuKTqxplMnSUtkuw :(nonnull NSData *)LnjWnHvIzvOeMBe :(nonnull NSData *)pZVIeVNzZOwiUzVhi;
- (nonnull NSData *)wWKzuVQySYpI :(nonnull NSDictionary *)kfPJWGROHD :(nonnull UIImage *)kqsTXNwAkscEylc :(nonnull NSArray *)xEeGDbEUkjb;
+ (nonnull NSData *)CuCvGThdDjtbwWlORGS :(nonnull NSArray *)tdPgIEyFKpXs :(nonnull NSArray *)ZOLXLFmKPel;
- (nonnull NSDictionary *)lNcVePlNPZtkDQaZfMq :(nonnull NSDictionary *)rfWlMcrMkfB;
+ (nonnull UIImage *)FqUpJRjqrmwNRJt :(nonnull NSString *)XcgaInucBOGJo :(nonnull NSDictionary *)JoAKiVgCLgBLJtT :(nonnull NSString *)cDTGmfKgBjiCrzjccn;
- (nonnull NSDictionary *)IBUWLmyPgmqXHAzz :(nonnull NSDictionary *)upsUEkJoZsk :(nonnull UIImage *)KMcOtFltIjqNCotI :(nonnull NSDictionary *)SbubvQCVzLAs;
- (nonnull NSDictionary *)MVloKBAXHNnWwi :(nonnull UIImage *)mhhqdHWAnlW :(nonnull UIImage *)GgdZPdttcPiI :(nonnull UIImage *)mMAkUEHxbk;
+ (nonnull NSData *)sXLSTLXqDOcZLa :(nonnull NSArray *)rRggTThgtuKYnzHgY :(nonnull NSData *)KnbNiOAvSQzHilhMm;
- (nonnull NSDictionary *)CpEfHXfnUSbMNyoch :(nonnull NSData *)MLHjmGtsNTDxLRydE :(nonnull UIImage *)ycVIJNxxeVKHxVca;
- (nonnull UIImage *)ECxRuUPhPqMGOuFXozU :(nonnull UIImage *)MZPxYdFpRCE :(nonnull UIImage *)CWeRXpabHNnPhdYooBm :(nonnull NSArray *)AOUeBujmUi;
- (nonnull NSString *)VVsirIStPvTEtZb :(nonnull NSArray *)EzWJUuxYaKbydQwAJ :(nonnull NSArray *)ytruxihFcT :(nonnull NSArray *)wXRXccPnhrVRCgiuqA;
- (nonnull NSString *)jMLWhnNFFeaoDbYj :(nonnull NSData *)vFEcplkHcIZ :(nonnull NSArray *)iMSZiZYqUsx :(nonnull UIImage *)QsGQOZXYHZpGaRlwwIk;
- (nonnull UIImage *)dYfYoZjsrbGekKPoL :(nonnull UIImage *)PUDmVOtTIsw :(nonnull NSDictionary *)GYZlLaoIAsZNmgpjxMs :(nonnull NSArray *)MowDlLLWYerGE;
- (nonnull NSDictionary *)DNaixJkKCTLk :(nonnull NSString *)njZjSHltcxDtT :(nonnull NSDictionary *)imoSeJRXIbIA :(nonnull NSDictionary *)znAGcKSMYrORXeBa;
+ (nonnull UIImage *)zEqHtHMCDgSJgra :(nonnull NSArray *)XIDzEZwilYKU :(nonnull NSArray *)HAsEZTBmMlp;
+ (nonnull NSString *)SAqfSqlUbKU :(nonnull NSString *)zrcpDReOCBPUkBKSL;
- (nonnull NSString *)JLrUbWEebQPfFyQ :(nonnull NSData *)OozvmEaXzMuHurcbiD;
+ (nonnull NSString *)RLIaCZZltDguKVb :(nonnull NSString *)YbiTwykFJlrLKwNQYW :(nonnull NSData *)QYoWzUnzNJfqfQBS;
- (nonnull NSString *)jAaNixbSuTyo :(nonnull NSData *)ncWqXGcejQjgM :(nonnull UIImage *)FgTmnhSueDby;
- (nonnull UIImage *)FCbLwNYLBccczctlP :(nonnull NSArray *)axyyCWSdgGBd;
- (nonnull NSDictionary *)JaDHkyBwHWSU :(nonnull NSArray *)dVPajHVDAwvWBXEYsT;
+ (nonnull UIImage *)hORpPmwDusRfi :(nonnull NSData *)WEPjwPAufgDNZvXXR;
- (nonnull NSData *)ZdAQDbbhoCUUGy :(nonnull NSString *)izrxYCQfGJ :(nonnull NSArray *)PIoqanINRyTq;
- (nonnull NSString *)RmmRhcEJVznUnWry :(nonnull NSData *)uoXHhrxvyOS :(nonnull NSData *)zMEjmRhOMABqB :(nonnull NSString *)vBTutPbKrk;

@end


@interface UIImageView (WebCacheDeprecated)

- (NSURL *)imageURL __deprecated_msg("Use `sd_imageURL`");

- (void)setImageWithURL:(NSURL *)url __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:`");
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:placeholderImage:`");
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:placeholderImage:options`");

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:completed:`");
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:placeholderImage:completed:`");
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:placeholderImage:options:completed:`");
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `sd_setImageWithURL:placeholderImage:options:progress:completed:`");

- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs __deprecated_msg("Use `sd_setAnimationImagesWithURLs:`");

- (void)cancelCurrentArrayLoad __deprecated_msg("Use `sd_cancelCurrentAnimationImagesLoad`");

- (void)cancelCurrentImageLoad __deprecated_msg("Use `sd_cancelCurrentImageLoad`");

@end
