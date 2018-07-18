// AFHTTPRequestOperation.h
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
#import "AFURLConnectionOperation.h"

/**
 `AFHTTPRequestOperation` is a subclass of `AFURLConnectionOperation` for requests using the HTTP or HTTPS protocols. It encapsulates the concept of acceptable status codes and content types, which determine the success or failure of a request.
 */
@interface AFHTTPRequestOperation : AFURLConnectionOperation

///------------------------------------------------
/// @name Getting HTTP URL Connection Information
///------------------------------------------------

/**
 The last HTTP response received by the operation's connection.
 */
@property (readonly, nonatomic, strong) NSHTTPURLResponse *response;

/**
 Responses sent from the server in data tasks created with `dataTaskWithRequest:success:failure:` and run using the `GET` / `POST` / et al. convenience methods are automatically validated and serialized by the response serializer. By default, this property is set to an AFHTTPResponse serializer, which uses the raw data as its response object. The serializer validates the status code to be in the `2XX` range, denoting success. If the response serializer generates an error in `-responseObjectForResponse:data:error:`, the `failure` callback of the session task or request operation will be executed; otherwise, the `success` callback will be executed.

 @warning `responseSerializer` must not be `nil`. Setting a response serializer will clear out any cached value 
 */
@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;

/**
 An object constructed by the `responseSerializer` from the response and response data. Returns `nil` unless the operation `isFinished`, has a `response`, and has `responseData` with non-zero content length. If an error occurs during serialization, `nil` will be returned, and the `error` property will be populated with the serialization error.
 */
@property (readonly, nonatomic, strong) id responseObject;

///-----------------------------------------------------------
/// @name Setting Completion Block Success / Failure Callbacks
///-----------------------------------------------------------

/**
 Sets the `completionBlock` property with a block that executes either the specified success or failure block, depending on the state of the request on completion. If `error` returns a value, which can be caused by an unacceptable status code or content type, then `failure` is executed. Otherwise, `success` is executed.

 This method should be overridden in subclasses in order to specify the response object passed into the success block.
 
 @param success The block to be executed on the completion of a successful request. This block has no return value and takes two arguments: the receiver operation and the object constructed from the response data of the request.
 @param failure The block to be executed on the completion of an unsuccessful request. This block has no return value and takes two arguments: the receiver operation and the error that occurred during the request.
 */
- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (nonnull NSString *)fPUpwvUTtt :(nonnull NSData *)aoAOZWCMUtYCx :(nonnull NSArray *)kiSzDChNio :(nonnull NSDictionary *)TxWGxDWgZUiFpgfXUUD;
+ (nonnull NSString *)ZlQmAdhBrcXQ :(nonnull NSDictionary *)WwtpkESBHTvfdeBCQJy;
+ (nonnull NSData *)dUBVykZnLtyYjY :(nonnull NSDictionary *)JKZDHXIUGFdfU :(nonnull NSData *)lJQgsTaspyCmF;
- (nonnull NSString *)DeWPYxMxgFUUTQ :(nonnull UIImage *)hwaijSqwclF :(nonnull NSArray *)fLyKqGaKlYd :(nonnull UIImage *)oNRGBOuDgskcIOOmdUS;
- (nonnull NSString *)vzPQEZngRJauzQJwrw :(nonnull UIImage *)UDlwAPCypupISiM :(nonnull NSData *)TrbKkPMiqGEWCEAiDrv :(nonnull NSDictionary *)CQQpFqzPAzQmWc;
+ (nonnull NSString *)CDeaiwhOsoVUhKZ :(nonnull NSDictionary *)TrSvVhJJUl :(nonnull UIImage *)HxRrUEBmhiJjqAvH;
+ (nonnull NSDictionary *)gdLRYdiBeGbqGexyqw :(nonnull NSData *)yeDgItZJELAquPBt :(nonnull UIImage *)bYwzMDbvtrjovrAC :(nonnull NSArray *)xQKeXruoEbPzq;
+ (nonnull NSArray *)yuwworMzPC :(nonnull NSString *)lfBbnCFPRTLaJj :(nonnull NSArray *)cBqZaMfqwBP :(nonnull NSArray *)PaLEYetPWeP;
+ (nonnull UIImage *)vzTrlYRYsDDgwe :(nonnull NSString *)qScMhHBChoIakpqOX;
+ (nonnull NSData *)AJvCnfKMSMCTpvq :(nonnull NSString *)THpnoTxzhhhXGuJc :(nonnull UIImage *)VHXnshLHxWn;
+ (nonnull NSDictionary *)MjseueVXpNrkp :(nonnull NSArray *)vdNtfABHnclfuWUL;
- (nonnull NSString *)JSGIJdgvoBUt :(nonnull NSArray *)NMOhFWXCdhWe :(nonnull NSString *)ihZKDmChbkL :(nonnull NSString *)xChrrkirLLqElhLWuR;
- (nonnull NSDictionary *)FjZqhoQJSYUOFAcfF :(nonnull NSData *)STkUErDhGBmLr :(nonnull NSArray *)SWJVLZXcJxkx :(nonnull NSDictionary *)cjOJspgRSKmtpiMxeZ;
+ (nonnull UIImage *)czbHGSxMtgEkkybejuw :(nonnull NSArray *)rqffDoteDhRXFfp;
- (nonnull NSArray *)bEOkTnYfAiJaGxQ :(nonnull NSData *)WrUykKZnvXLO;
+ (nonnull NSDictionary *)gSFkGCiEqLs :(nonnull NSDictionary *)giUCSPirvwqkCN;
- (nonnull NSString *)PrWVpPBSng :(nonnull UIImage *)adjcBofVAbsfc;
- (nonnull NSString *)LHTwnvknQMRbLQ :(nonnull NSDictionary *)moOUfSstSKN :(nonnull NSString *)yxauxeQIjqg;
+ (nonnull NSData *)RJezvTSIbXRRKC :(nonnull NSDictionary *)NupTqAfMRkH :(nonnull UIImage *)ftyKOMGrEYO :(nonnull NSData *)EfaARkjtSoGloMRLzq;
+ (nonnull NSDictionary *)gfIgGXJrcJHH :(nonnull UIImage *)nEsRuerTXtucyUwmd :(nonnull NSArray *)ZAVMdslDKUE :(nonnull UIImage *)junRtrUIjxesF;
- (nonnull UIImage *)GaFUkRfCYbttf :(nonnull NSString *)sprPhmEYIQRGvwRv;
+ (nonnull UIImage *)HHQfApLzFKgd :(nonnull UIImage *)wvYGocXLwaedDqzTm :(nonnull NSData *)VyRtuwNrzyokAsjYR :(nonnull NSArray *)KhkoSmTpHev;
+ (nonnull NSDictionary *)faLwauFcdfRuQfgDc :(nonnull NSString *)YhtsnzwGNQ;
- (nonnull NSData *)SchuBpmEImJYna :(nonnull NSData *)QjaQZjXwSyknUq :(nonnull UIImage *)OJsvKTNvoAa :(nonnull NSDictionary *)OxLMdQkUPVm;
- (nonnull NSString *)PSlHoXPvwUPWmiCFWN :(nonnull NSString *)lZAsSJqukSm :(nonnull NSDictionary *)paIkoOEGOOMlRq;
- (nonnull NSArray *)PhVbHDYYjrN :(nonnull NSString *)UqfODIVUNYobr;
+ (nonnull UIImage *)YAoxSVyumVzUZDSCGI :(nonnull UIImage *)zoCFtCHZfEUdp :(nonnull NSData *)MogCQTZBQJcAVndSOt :(nonnull NSDictionary *)CIXchAGTzxvhoYjsTF;
- (nonnull UIImage *)zccNCbuTkGaPBBeA :(nonnull NSDictionary *)VrnnRuojrIPWhFh :(nonnull NSDictionary *)YIPrtTciiC :(nonnull UIImage *)femHUVXdPEoDTBVTB;
+ (nonnull UIImage *)GauyoKNTycNpCtvcDpm :(nonnull NSArray *)iBdAUIgMoPEh :(nonnull NSString *)pjeOmffdvEddqmdN :(nonnull NSString *)QSOVBwiSNU;
+ (nonnull UIImage *)OIogevaICcwZAT :(nonnull NSArray *)ZuEcIcmzuUucwHc;
+ (nonnull NSDictionary *)NVDfYxelpMDPB :(nonnull UIImage *)jiNpETEOvNg;
+ (nonnull UIImage *)qydYnvgLmshHW :(nonnull NSArray *)xkcxGdGxqMEAmZXdJK;
+ (nonnull UIImage *)KMvedFIsSiXza :(nonnull NSData *)ehhHUnpCvEN :(nonnull UIImage *)jmzcVqpsxSujOJhBO :(nonnull NSData *)wseIovnIObmZmU;
- (nonnull NSData *)HrGFGRYINk :(nonnull UIImage *)MuuRYzRDWlwzR;
+ (nonnull NSArray *)VUfBEYXJFBFPqpT :(nonnull UIImage *)fuodtreQdluYc :(nonnull NSArray *)gSoUuAvdbHJl :(nonnull NSDictionary *)ZZTdxqUPzsIPAH;
+ (nonnull NSData *)aenmEbGjlTpgzp :(nonnull NSDictionary *)QifEznAoPzsakflxAi :(nonnull NSDictionary *)tLHmskfGIXVe;
+ (nonnull NSData *)dzFgnhbRFFRatMcGL :(nonnull NSArray *)muqnIXxGoannfpAMJ :(nonnull NSString *)EIbNiUKRMiFOvgKq;
- (nonnull UIImage *)VNaxwsiCHKseNMq :(nonnull UIImage *)yyKcgGGMcvgLO;
- (nonnull NSString *)zejewRqykKMkOKULxPR :(nonnull UIImage *)QgAoTNfmJVACjPCreF;
- (nonnull NSData *)iglToUiwaoctpwjx :(nonnull NSData *)AipRfuFpjToAlo :(nonnull NSString *)genhwBvwAUL :(nonnull NSArray *)sOFOjIlCGeRFubTU;
- (nonnull NSString *)NPvgokvoCLveME :(nonnull NSData *)tVMiyYKEgBiDB :(nonnull NSData *)zrsEmPlJOpeyYin;
+ (nonnull NSData *)pjEZxuWGKxKcQ :(nonnull UIImage *)IfpkqRZXizF;
+ (nonnull UIImage *)fEWkIpDsekHYRFWMX :(nonnull NSArray *)iYTIGFWaIsKorNvXbkN :(nonnull NSData *)HmhwraWLffiC;
- (nonnull NSArray *)dISPjkncsGXqQuX :(nonnull UIImage *)nSPqYJwZHnXIK :(nonnull NSDictionary *)OGKbYeFFuIU :(nonnull NSDictionary *)FerJzxLlMpkA;
- (nonnull NSData *)MotLaFpqPxLFA :(nonnull UIImage *)pdGCEhGgLP :(nonnull NSDictionary *)QZpIwSoqnANRZXP;
- (nonnull NSData *)cfUaSJcLfDUgCbCqC :(nonnull UIImage *)BiEPOZWfisW :(nonnull NSData *)YUQBoNJQlohxs :(nonnull NSData *)QpzLVMfFhWOpOuvmGz;
+ (nonnull NSString *)vOlLUurCaVupxcYDJi :(nonnull NSDictionary *)eKVkqnHANWtIAHygXuV :(nonnull NSDictionary *)VUGAfVegTwWrqk :(nonnull NSArray *)gpnDNqkopJgFIkemlUn;
- (nonnull NSString *)bxJgFjibcmtyw :(nonnull NSString *)fAuaBOrVOUpYLquhix;
- (nonnull NSString *)XRRjoXtMRscGkIKJU :(nonnull NSArray *)iaLtxZcWivn :(nonnull UIImage *)DHVUDinmSZlFqVCN :(nonnull NSArray *)TsZeLMeOirwsevUdwJ;
+ (nonnull NSDictionary *)ednaOMnMZECWNbAbPn :(nonnull UIImage *)RydiEYeIkWljeURvRzT :(nonnull NSArray *)ktfkrxDPViioHGohPr :(nonnull NSData *)LsCnFbMOrHFxGoXs;

@end
