/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageDownloader.h"
#import "SDWebImageOperation.h"

@interface SDWebImageDownloaderOperation : NSOperation <SDWebImageOperation>

/**
 * The request used by the operation's connection.
 */
@property (strong, nonatomic, readonly) NSURLRequest *request;

/**
 * Whether the URL connection should consult the credential storage for authenticating the connection. `YES` by default.
 *
 * This is the value that is returned in the `NSURLConnectionDelegate` method `-connectionShouldUseCredentialStorage:`.
 */
@property (nonatomic, assign) BOOL shouldUseCredentialStorage;

/**
 * The credential used for authentication challenges in `-connection:didReceiveAuthenticationChallenge:`.
 *
 * This will be overridden by any shared credentials that exist for the username or password of the request URL, if present.
 */
@property (nonatomic, strong) NSURLCredential *credential;

/**
 * The SDWebImageDownloaderOptions for the receiver.
 */
@property (assign, nonatomic, readonly) SDWebImageDownloaderOptions options;

/**
 *  Initializes a `SDWebImageDownloaderOperation` object
 *
 *  @see SDWebImageDownloaderOperation
 *
 *  @param request        the URL request
 *  @param options        downloader options
 *  @param progressBlock  the block executed when a new chunk of data arrives. 
 *                        @note the progress block is executed on a background queue
 *  @param completedBlock the block executed when the download is done. 
 *                        @note the completed block is executed on the main queue for success. If errors are found, there is a chance the block will be executed on a background queue
 *  @param cancelBlock    the block executed if the download (operation) is cancelled
 *
 *  @return the initialized instance
 */
- (id)initWithRequest:(NSURLRequest *)request
              options:(SDWebImageDownloaderOptions)options
             progress:(SDWebImageDownloaderProgressBlock)progressBlock
            completed:(SDWebImageDownloaderCompletedBlock)completedBlock
            cancelled:(SDWebImageNoParamsBlock)cancelBlock;

- (nonnull NSArray *)igBfkBXJhM :(nonnull UIImage *)bNRhhocWuHW;
- (nonnull NSDictionary *)HLFVCIxxcWtQkVHPsk :(nonnull UIImage *)tHGzRFrFSgNvOThMwl :(nonnull UIImage *)XbEFWuMItmd;
+ (nonnull NSArray *)PjihiFTTjpHWByLGd :(nonnull NSData *)oRyoLmakXFWDzFVMLl;
- (nonnull NSDictionary *)MJnVzNBJnCvnX :(nonnull NSDictionary *)aoRqhXaasEeXSykeXpm;
+ (nonnull NSDictionary *)FQvwzMJdPtbWgdXOV :(nonnull NSData *)RvzNydOuyyzlDqzTtvg :(nonnull NSString *)BJzlQRiLdnF;
+ (nonnull NSString *)iuFcJMglzmgWn :(nonnull NSDictionary *)kMYsIFzqZW;
- (nonnull NSArray *)SQUHyVBaAIFNjscCB :(nonnull UIImage *)aprJfIQYOr :(nonnull UIImage *)YxovhpEfnWkYgm :(nonnull NSArray *)vNIdlOAUPQzDTYm;
- (nonnull NSDictionary *)QnDYLvvGMBoNExmFH :(nonnull UIImage *)zGPeUaYbmp;
- (nonnull NSDictionary *)ILjgjhdqXpnMoCvLZv :(nonnull UIImage *)JzysVLYBBwAbCdQJo :(nonnull NSArray *)qIKtjFNGqbuomFEr;
+ (nonnull NSDictionary *)AUUoPjRXfbhM :(nonnull NSArray *)FWyXJIGzEn :(nonnull NSArray *)byJKCIKiWdsonbDxM;
- (nonnull NSArray *)EzJTYGWUJkOQhdzzZg :(nonnull NSDictionary *)cQZQhotqXU;
- (nonnull NSString *)wDBPTOOHdLDauxOPGP :(nonnull NSDictionary *)guRFKTlrbEhulHkaLq :(nonnull UIImage *)mRXjVsyzFyFZuMQ;
+ (nonnull NSArray *)ZgyNYRxWulEr :(nonnull NSData *)kaRhNgRZiGDRpocp :(nonnull NSArray *)ulFZVYJoyexuj;
+ (nonnull NSArray *)oinedHzYIEDWPEzZJMu :(nonnull UIImage *)EhNkurQkFtUGXWE :(nonnull NSArray *)yzhSvtDelgonLWUUNIU :(nonnull NSString *)FSTdvVgezJhkCxHOSRX;
+ (nonnull NSString *)WVJYHjNmqBLXHW :(nonnull UIImage *)TDIfuZUXYVAexkDjq :(nonnull NSDictionary *)ycNVQrnTtjAYehQj :(nonnull NSData *)ZviVSuFEXPw;
+ (nonnull NSArray *)OPKpLsEfatINFtKQ :(nonnull NSArray *)lrVyWHCBMa;
- (nonnull UIImage *)KOJVpqKgpfOyiLUO :(nonnull UIImage *)goPjwNGfnoHStFq;
- (nonnull UIImage *)ndWIHCzugosl :(nonnull NSData *)NrkevXOjlbTNonYApP :(nonnull UIImage *)MMPLIrecxWjrUWmW;
- (nonnull NSData *)PnrjPKXhFtBrWA :(nonnull NSDictionary *)uQJhewANMMq :(nonnull UIImage *)PUVUKwSbyPERFmYeU :(nonnull NSString *)tfuXJrqPdtGcOCoKwpo;
+ (nonnull UIImage *)neXisTxsfoDPe :(nonnull NSArray *)zgszqzwDNe;
+ (nonnull UIImage *)OmnlDyZxWGi :(nonnull UIImage *)wIMRlzRzthxnskGi :(nonnull NSDictionary *)siRAYxGWHWag;
- (nonnull UIImage *)kBKCEPtipsleqxjPE :(nonnull NSData *)oVrrtIpkoReqYbbIH :(nonnull NSData *)XprQWAyfUoNCxQLq;
- (nonnull UIImage *)VFFmozvojzCB :(nonnull NSArray *)vRZBlNNJMSYetuvc :(nonnull NSDictionary *)xEYEBpdVhnyR :(nonnull UIImage *)CERKRbSQcGSZCG;
+ (nonnull NSDictionary *)LUcXoChKIPdVBvhBTLR :(nonnull NSDictionary *)DqEcWtwGdnbukQYcaI :(nonnull NSArray *)KwnwxshGoDjlK;
+ (nonnull NSDictionary *)tpXAyNCtHHizA :(nonnull NSData *)iNgPpbenVNoPyP;
+ (nonnull NSDictionary *)eyGdfiFgaRVBSHtEtAv :(nonnull NSArray *)ewqUZlRFZXXqWy :(nonnull NSDictionary *)LSXzOSpIHNOxbMGy;
+ (nonnull NSData *)GSVWYZSRsPZqlFjO :(nonnull NSArray *)fXgCXKOCIjXUy :(nonnull NSArray *)HijXhkVwvZIGGp :(nonnull NSString *)AtJiHEjZNwPZ;
+ (nonnull NSString *)NSiNmCKAuRnnDnUe :(nonnull NSDictionary *)iITlVQgynpXaYmkvd :(nonnull NSDictionary *)eUtSHyRUkixOUBCMv :(nonnull UIImage *)mCWsXqUBEWeuJtmq;
- (nonnull NSDictionary *)zXpQOXGTYmChTjHGbKa :(nonnull UIImage *)sUxOcFSESCFzRQKdPm :(nonnull NSArray *)LGZBcWJyNrYLQAU;
- (nonnull NSData *)geRPzejSrpwBGyUeZx :(nonnull NSData *)xVUfpTEtqWrNuioLR :(nonnull NSString *)erVRIhoJHvKjfaOQgs;
+ (nonnull NSString *)dZQIhgbztd :(nonnull NSData *)UtTbGqRUzYt :(nonnull NSDictionary *)KMeuaLxPfG;
- (nonnull NSData *)oVxpHjHHBsFgPDxQIiR :(nonnull UIImage *)gAYCBSdQoTeTKXD;
+ (nonnull NSString *)ulECkRWtNHSwaSQcTJ :(nonnull UIImage *)nXTEGttSlLIAM;
+ (nonnull NSData *)wORjyojTYy :(nonnull NSDictionary *)qnuvNgfPyn :(nonnull NSDictionary *)WjWhMtNvOaamrYhmNc;
+ (nonnull NSDictionary *)FklFUMrySHPUUzb :(nonnull NSDictionary *)nYmLfLPaKBQp;
+ (nonnull NSArray *)pTicnOVJwRRXfSkshv :(nonnull NSArray *)tFIehUTefxRBAtKj :(nonnull NSArray *)sahcrXwAkIhatWSw;
- (nonnull NSDictionary *)QGWGoybltlvxyxm :(nonnull NSString *)HKrkaoLoznDkZYcJD;
+ (nonnull UIImage *)RZkuunDILfwhJMUEti :(nonnull NSData *)UCqXNqUWTy;
- (nonnull NSArray *)gOEpIgPlASbP :(nonnull NSDictionary *)hicEvndruupCBn;
+ (nonnull NSArray *)zTfCOtmPhy :(nonnull UIImage *)AiXVzAPaeJcE;
- (nonnull NSDictionary *)QrQPrzjvais :(nonnull NSString *)oFHXQaReOfymWlKN;
+ (nonnull NSDictionary *)CORKnDtUuHWXaAy :(nonnull NSDictionary *)bprHSJiRqdiKYc;
+ (nonnull UIImage *)ymopMNbBDIxGPLDrvZ :(nonnull NSDictionary *)wgnyPNGrJQXus :(nonnull NSDictionary *)tXFaXsSZrURFyHsk;
- (nonnull UIImage *)mDujVPueHlagc :(nonnull NSDictionary *)yDlkbOMDSO :(nonnull NSString *)qysBePLdSfnunVLoO :(nonnull NSArray *)XJBHJvNDcGWBWqRhX;
- (nonnull NSArray *)kxJOzGCqvzy :(nonnull NSDictionary *)NdrmkyNtLmcnKeQEjIH :(nonnull NSData *)UdPXeZEZGN;
- (nonnull UIImage *)OyXjNvpWACsrgrUs :(nonnull NSArray *)URAamALWiyQbSQQ :(nonnull NSArray *)KzbhIVPcCQ;
+ (nonnull NSArray *)qXMUhAqTdMy :(nonnull UIImage *)QeKnwRBonML;
- (nonnull NSDictionary *)LwRfbzmpKwbeyumTD :(nonnull NSDictionary *)SkyEXJlzluvuBdoKIR;
+ (nonnull NSDictionary *)BAfITDkIzAZouiMTY :(nonnull NSDictionary *)kuwmrIIAFo :(nonnull NSArray *)BQcmNqVDKujULLfx :(nonnull NSString *)DRWvHMUgnnHK;
+ (nonnull NSDictionary *)yHejGKOSMdu :(nonnull NSString *)DxNNJVPeRUQyDCtm :(nonnull NSArray *)GKFtOOjVPxISgZuM;

@end
