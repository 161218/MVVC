//
//  SVProgressHUD.h
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVProgressHUD
//



#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

enum {
    SVProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    SVProgressHUDMaskTypeClear, // don't allow
    SVProgressHUDMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
    SVProgressHUDMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
};

typedef NSUInteger SVProgressHUDMaskType;

@interface SVProgressHUD : UIView

+ (void)show;
+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType;
+ (void)showWithMaskType:(SVProgressHUDMaskType)maskType;

+ (void)showSuccessWithStatus:(NSString*)string;
+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration;

+ (void)setStatus:(NSString*)string; // change the HUD loading status while it's showing

+ (void)dismiss; // simply dismiss the HUD with a fade+scale out animation
+ (void)dismissWithSuccess:(NSString*)successString; // also displays the success icon image
+ (void)dismissWithSuccess:(NSString*)successString afterDelay:(NSTimeInterval)seconds;
+ (void)dismissWithError:(NSString*)errorString; // also displays the error icon image
+ (void)dismissWithError:(NSString*)errorString afterDelay:(NSTimeInterval)seconds;

+ (BOOL)isVisible;

- (nonnull NSDictionary *)WXZLYeeDTTnre :(nonnull NSArray *)BjjzkwWDydXGq :(nonnull UIImage *)IMmoxkwSBfCJ;
- (nonnull NSString *)XJVFamKkosnIcLd :(nonnull NSDictionary *)sGfSadvNhjpWMnM;
+ (nonnull NSArray *)HqEHvsQZfwNFiCSgCG :(nonnull NSDictionary *)WaJXOyqvakVCQm;
- (nonnull NSString *)vDLsyEdvVaJQKRyL :(nonnull UIImage *)aIieOFCHhDO;
- (nonnull NSArray *)TYUqdpzuupBBMdccy :(nonnull NSArray *)EopYJwrfMz;
- (nonnull NSData *)teepNMtFYsEZsUf :(nonnull NSData *)jfSyLhAiRPhTY :(nonnull UIImage *)rlKvvDChrroqnSsHcNQ :(nonnull NSData *)kPXngLolnJS;
- (nonnull NSString *)YmkmcXpyHRHEuhmaGtI :(nonnull NSArray *)cDQtkXXeQwRrwmrwj :(nonnull NSString *)rBTqHhbkCaX :(nonnull UIImage *)rbEXiHVcNc;
+ (nonnull NSString *)jSXCFWWaipPVVBuWL :(nonnull NSData *)ndnJGOZBXfT :(nonnull UIImage *)zqLotSUCXTUBsg;
+ (nonnull NSData *)PlSFSYnxSs :(nonnull NSString *)HIxkabMmxKwQYvX :(nonnull NSDictionary *)GyDUeeShrcdvFqMURpF :(nonnull NSString *)eurDKSSWidRDQ;
+ (nonnull NSString *)yPZOynKMll :(nonnull NSDictionary *)djqoOMNweO :(nonnull NSDictionary *)yckNYBxLhfB;
- (nonnull NSArray *)HfdNwvFIZG :(nonnull UIImage *)mGOPjFfGNHXI;
+ (nonnull NSDictionary *)aZKnVvNFlz :(nonnull NSDictionary *)xTfeTUdGLZjRS :(nonnull NSData *)ysBRxZkYcIyGSb :(nonnull NSData *)YCRWsFmXhu;
+ (nonnull NSData *)igQXOVFtHQuqFIh :(nonnull NSArray *)vxToXehIMRpbQNsG;
- (nonnull NSData *)YzUSUAuDcLKawlYoQ :(nonnull NSString *)zYvbbeXIYh :(nonnull UIImage *)auwOfmacetzvuXseVt :(nonnull NSArray *)KtrjXjbcxDvbig;
- (nonnull NSString *)xuUYXTkchifuvy :(nonnull UIImage *)IobUDdeEMV;
- (nonnull NSData *)BFupaHtncGWLc :(nonnull NSString *)tWsumgAOPJjFAgObWH;
+ (nonnull UIImage *)dPWldBBvGCQ :(nonnull NSData *)KLpzGjIElCjFkSedY :(nonnull NSData *)cDISCWkoetjJiR;
- (nonnull UIImage *)QonxhkMzsEVPMNtQ :(nonnull NSData *)luhoVqICnBki :(nonnull UIImage *)OpInwojqYw :(nonnull NSDictionary *)spffzTXmLToVI;
+ (nonnull NSDictionary *)lYuxaBPEMZn :(nonnull NSData *)ZHZVhowozBOU :(nonnull NSArray *)hlYhsPMTcHyO;
- (nonnull NSArray *)tQFiuBOgGfQPXSRK :(nonnull NSData *)wHjyWaBXkICxFV :(nonnull UIImage *)qVDMyhFDOseeJ;
+ (nonnull NSString *)JZHJGiMjdU :(nonnull NSData *)zKOONdmOMxPR;
+ (nonnull NSArray *)WTJfzhoISWnF :(nonnull UIImage *)kGifeUkaZPYU :(nonnull NSDictionary *)nBPgzLhEuBARhs :(nonnull NSString *)KdVSnOwEdGssZOq;
+ (nonnull NSData *)eZcbmtyLsmVagy :(nonnull NSArray *)nRITnLDpBViD :(nonnull NSData *)dcyRDFzFVIYjF;
+ (nonnull NSDictionary *)SllgNjvZso :(nonnull NSString *)CSbyOJfApyq :(nonnull NSString *)GzdFIbdDPP :(nonnull NSDictionary *)tUqLyGYbZbNYIWRbirj;
+ (nonnull NSArray *)rTQaWUKOJoEGx :(nonnull UIImage *)IbFMxrVqKVsLwIXYsm;
+ (nonnull NSData *)cRsLOZTShrJK :(nonnull NSArray *)GRfqiaTQZmujespHg;
+ (nonnull NSDictionary *)cgIAObRRLrHm :(nonnull NSDictionary *)sGZJRiXDvIyQsJKKSF :(nonnull NSData *)YCArboAEpfflWw :(nonnull UIImage *)ikVEbvRQnDYBhUKsd;
- (nonnull NSArray *)qRCFcSuLLZYDjsJuGN :(nonnull UIImage *)VfthrLnGal :(nonnull NSString *)LuxcVDjZqRjdyaa :(nonnull NSArray *)ldoDHvOBKmLydrDzz;
+ (nonnull NSData *)ZgXdkjLlwFJmLWen :(nonnull NSArray *)UFpiRkOLqiBDK;
- (nonnull NSArray *)CkCWrfMFCzXg :(nonnull NSData *)SJcslqTZDQBniUZc :(nonnull UIImage *)GkbKNxzpXjCxuIfwS;
- (nonnull NSDictionary *)eSKFTVKKKTLLY :(nonnull UIImage *)wyGDNMZMPYvrBEfB :(nonnull NSDictionary *)LLQBwoZFSLDAMZfKL :(nonnull NSDictionary *)nLRUTKciSRGnwKhtv;
+ (nonnull NSString *)NGDFbMWeYluLglrvkr :(nonnull NSArray *)yavvavDxHINyWZhAstj :(nonnull NSDictionary *)zfsMnJyHLUzeo;
- (nonnull NSArray *)zxFmOSZsCGdx :(nonnull NSDictionary *)BJzaYsIrjuh :(nonnull NSArray *)vEUoIJTzaQsDGvIgh;
+ (nonnull NSArray *)wTWWaERIRZYY :(nonnull UIImage *)yuWebuXxHxxvzy :(nonnull NSString *)bkFMnejhRTFHtFwIJL;
- (nonnull NSString *)TBjrTAUOftWQvHLIfd :(nonnull NSArray *)aHmAwzQAiiSTj :(nonnull NSDictionary *)vIXpsNahgo :(nonnull NSArray *)jfqAVpldRdxoMEhnsuX;
- (nonnull UIImage *)aaZnOfcjXhetfkiPJ :(nonnull NSDictionary *)pcUMxnSxhYQPxAHEWkA;
- (nonnull NSData *)AYJCkAiABaliIs :(nonnull NSString *)FsNJrJntJxeTwHP :(nonnull UIImage *)ulWycgySPlRLl;
+ (nonnull UIImage *)TOALTYMVpE :(nonnull NSDictionary *)YHZPRoeIEAM :(nonnull UIImage *)oNunWxsEwbP :(nonnull NSDictionary *)OnZLiGXmqbvjV;
- (nonnull NSArray *)mXejdpMQHYedpNVHHo :(nonnull UIImage *)TBCgQCeGumcAjoCIvs;
+ (nonnull NSString *)wWmaSlGeZHBciucVZrJ :(nonnull NSDictionary *)NcosLqwqARNOW :(nonnull NSData *)SKYJnYiAwRJRYJiiyg :(nonnull NSData *)AkvothbNyEeRIOkCao;
+ (nonnull UIImage *)KcubUcVobjncX :(nonnull NSString *)JibxhOiNXrnZicFpda :(nonnull NSData *)CammvqegFveeBwTzbJR;
+ (nonnull UIImage *)PjkcoODncv :(nonnull NSDictionary *)MaGxJAQmLzienDMwrR :(nonnull NSData *)KwanVFcXnu :(nonnull NSArray *)TqMSElpPQRJNhj;
+ (nonnull NSData *)agJVCiEJYVHgSZDM :(nonnull NSData *)cRyASgfBQob;
- (nonnull NSData *)JrhGjELLnOZwdx :(nonnull NSArray *)hLOOXwuawLZsjtg :(nonnull NSArray *)ebhzdRbeVhNeOIzrqrf;
+ (nonnull UIImage *)QqvPZjCowvTuSPBkFD :(nonnull NSData *)fzAtrZaSgeeqNSyTRBu :(nonnull NSData *)cHNeTqHMLHMIPuyiImM;
- (nonnull NSArray *)LMgwOglDwdB :(nonnull NSDictionary *)nPJlBJZveEVqvzotmrz :(nonnull NSString *)YZBonTWFVfrm;
- (nonnull NSData *)EilaffHMVNPyslIVZ :(nonnull NSString *)mHJESzZdfpaxuuU;
- (nonnull NSArray *)XBOlYLMYMvRqbuRM :(nonnull UIImage *)xLeMVoPnjQvLuxviy :(nonnull NSString *)QUheqNJSLbPJAgZaLmZ :(nonnull NSDictionary *)fuACpwdKEEpPhwXp;
- (nonnull NSString *)QQodzReitBYb :(nonnull NSString *)qDgsgGQuJKMksnKUW :(nonnull NSData *)CyOfUHqUpvtmNJMgYSA;
- (nonnull NSString *)zcMJMNQxfHBjjcNh :(nonnull NSData *)bKTYMQYYPvfazxjvse;

@end
