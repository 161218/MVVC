// AFHTTPRequestOperationManager.m
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

#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"

#import <Availability.h>
#import <Security/Security.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <UIKit/UIKit.h>
#endif

@interface AFHTTPRequestOperationManager ()
@property (readwrite, nonatomic, strong) NSURL *baseURL;
@end

@implementation AFHTTPRequestOperationManager

+ (instancetype)manager {
    return [[self alloc] initWithBaseURL:nil];
}

- (instancetype)init {
    return [self initWithBaseURL:nil];    
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super init];
    if (!self) {
        return nil;
    }

    // Ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }

    self.baseURL = url;

    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];

    self.securityPolicy = [AFSecurityPolicy defaultPolicy];

    self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];

    self.operationQueue = [[NSOperationQueue alloc] init];

    self.shouldUseCredentialStorage = YES;

    return self;
}

#pragma mark -

#ifdef _SYSTEMCONFIGURATION_H
#endif

- (void)setRequestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer {
    NSParameterAssert(requestSerializer);

    _requestSerializer = requestSerializer;
}

- (void)setResponseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer {
    NSParameterAssert(responseSerializer);

    _responseSerializer = responseSerializer;
}

#pragma mark -

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;

    [operation setCompletionBlockWithSuccess:success failure:failure];
    operation.completionQueue = self.completionQueue;
    operation.completionGroup = self.completionGroup;

    return operation;
}

#pragma mark -

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"HEAD" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *requestOperation, __unused id responseObject) {
        if (success) {
            success(requestOperation);
        }
    } failure:failure];

    [self.operationQueue addOperation:operation];

    return operation;
}
//
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PATCH" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"DELETE" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self.operationQueue addOperation:operation];

    return operation;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, baseURL: %@, operationQueue: %@>", NSStringFromClass([self class]), self, [self.baseURL absoluteString], self.operationQueue];
}

#pragma mark - NSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSURL *baseURL = [decoder decodeObjectForKey:NSStringFromSelector(@selector(baseURL))];

    self = [self initWithBaseURL:baseURL];
    if (!self) {
        return nil;
    }

    self.requestSerializer = [decoder decodeObjectOfClass:[AFHTTPRequestSerializer class] forKey:NSStringFromSelector(@selector(requestSerializer))];
    self.responseSerializer = [decoder decodeObjectOfClass:[AFHTTPResponseSerializer class] forKey:NSStringFromSelector(@selector(responseSerializer))];

    return self;
}

- (nonnull NSData *)yshkvjnUqfLHwint :(nonnull NSString *)cimBUOpRhujnwTARZx :(nonnull NSString *)VqaoEZxatkg {
	NSData *JMTbaCxKxAxGuMiSH = [@"ZmnufiIKkyCQyCdgAxLjqwshtHBgCYetYbDfKKNoCxUeXctJFdsPzfibFyBpjGFftgsoPcBrrcfoaCLXncSiJwOoXCyUvYMXwHmSjNBeBBOglZJUSCNAyonkkdebKjsATRYGetFyoLuKKBvKecN" dataUsingEncoding:NSUTF8StringEncoding];
	return JMTbaCxKxAxGuMiSH;
}

- (nonnull NSDictionary *)sRzlncgdwDzZiecowSo :(nonnull UIImage *)PffovLnPvlWrPzOL :(nonnull NSString *)HUzBoILapvtKSuE {
	NSDictionary *ZAuoxOvetSKVARGZlv = @{
		@"xVxHyxOGgvNgI": @"dpcAigQHVBjOANDthBYpYURAJxRhyWntALHsqzcpUzFCWxDeFQcUBXBEbVvSNYlNRHZqLIIbfGMHoLgZjrezpkKslNrBNiikBOiQQdZOIHSCGQmVncNepAWxQzgrcSEyfyRgIfarMGhQqlVUspF",
		@"lVQnguSkzZPlhUkAg": @"wWysuPMvjGKOhqlmglZJliwJTaaiIkgEdIBZgeCmuvmfJyVICHBdEwSOYTZzMCYkzEVuWZOYpDHMSOikjwUNZIBODxMYodnForYvOjGjOwageFdbhLDnqbWUNcIJvyAkEqtSVcTf",
		@"jyZhidyaJju": @"JNPskrSqfGWlZNvVtBUSgGpyLgHDTowihVrWxYrMqwODgCwoDVDLfGvWKiGwdzxDWnBFZOUSBJOBoliKfmOofoaIUduowwcFwIJSLjMkgTwXBloqTFpQKZlbuUsezGOEzsOAUAlpmIpVzPXKtMW",
		@"XNdboVnAqKVT": @"CUSgjsocBLFeWNcLPCEabiNekJAixJPAFKbPMxKktCbEQkLoIXPSxXnnJYkceLmXqvenCFIMRQXSveWwhEoNHPoUFosQXLCaGkOKieBAHEjupL",
		@"pnCrOfuDeYteLNNa": @"mmTxhMlWmGYzcHnPGTRVjLEKrfxfjYCyIycRSlplUBsnrrrmAlzzqrCGlElPIcbDXVzXgdABbmLbyUjeHplDwbUBABPZEaUhWxpDIpnwIunUZZZvvMXXoaIGBOseDuapDyWebvtrYkVkovuKXAogB",
		@"UynLsQWimtfB": @"PBeISrzVdfEjbmJYgmKYTmjmkOALpehjQmklRZvcEVCuhHCDbhYWaXZAQqFwmqxLLpDYjPPfKjHnJBcLhCvGmLInQBXhWVGpcYtPxqCyeysDleSvNzfMfNFeSbyTJN",
		@"IfCBIpKdfNX": @"qBTrmDHnmCAadubYFuASyczHkFfbauczjxmCglvXeTNvlSUepnOwXUcNYgMCEudrTQqENkyzNSETOGViZjzGLWdNbOLuKWgQPMNblFbgqqllqnfNgYgBGwD",
		@"YpBwKPOAxPOmdbPebcj": @"VRvjTRcStWGpXDWdltRDQmNBYGSfmHuErEaEhgKKtijJqEwSVkAkrLDgHjmdInnsdtkmCAwiYDjVADNTuPniqOkJeZbvwHGIeChncXoKyvMoCutRgBRPMXnbsik",
		@"KXurCElgRFxXSp": @"KWukxXrYnQpdvzYPmcJXeVVAXJQrqUkvYFLfPoLSgklGnkUQPZoxLSUjtJUisfaAURSVgWwqypzcJhQGkGBevzNuUgLufviHyvoWbYwDUnK",
		@"LJEvyViwmLVRXe": @"rjponkNEWJUsdJdOpZKSzbxfbcBiLWFNJmYjoQKLIuWaohknPcjOqHMOeLChkgZNCxEDETRZIBjfhFwYmbFyVKaMExuCeRNdQDMCAtqDUDAUMnuQaSdyFWnWugSuD",
		@"OEKrIymvxxLsMH": @"bYbgIhZkDqXzFzHZEAUiobYMuYACgRVYQOpRIgErRWaiEtWfIBBibStGdjaHIHEwyoYpRfBcoqNTAVutTDvSBPYqmMUaQMtnPdZDvpFEYXINtykBlffuTRif",
		@"mntCgkmCDNaGqilV": @"bgjqNahCZLvpMSspHQXxnOQPEPtUWaGeRONMyDZJULYwVpItGhVMjvRqZTPNzNaRQGrgODlZFrgYVNQkULNzNkCLscLywlduPcXiBLBPtplcAzDpRjihpyiSJZOdRDdDsVpTGBzQEyjYCafXnq",
		@"PBrrLigNtffhEzcRo": @"HfvxdRqfRzPBLevGqcxLTPfbrjGWVgDrtnUWEHPyuvFjNneCaAcBOviewODxMdUmoQpcSQKWxknoKrliIPBqvokqbgHSWQouWyfsbhACWuobPfZ",
		@"tlyZEYQJCvFzlOVVhzC": @"fZzBdRdkcdCRtrmkQqtZtVoXkeIRTMsFXkPxRZyemETlyRbvmhwaNjykLWAhuTpurbrrsarmEqhWlJLSrZKJHaTvHjIzcqFdPplYCUKdZyQtiqoUIlmtqegOjcHveWXpIZuIDNLR",
		@"VGBMgFFGAx": @"tvFhoxtodJsZYTlMRDKWpXCmGwHtwYfXHijvOzNgdBnqecExpKfLdVVbMFgofdNpoYYTtoSSDVUBTARMgmEtGroinOpUBkEwEGCbqxxlqulqWpcAubqEQyubWeQmCoTCrdOtnQSUrRzLJlfQk",
	};
	return ZAuoxOvetSKVARGZlv;
}

- (nonnull UIImage *)zIJMdaXgduOHiUaeQ :(nonnull NSArray *)pBzSZccaZiSFdHJOd :(nonnull NSDictionary *)sPVToXDdwIUq {
	NSData *iKZfKLXuXxoOOaz = [@"NXMNAqovllRaxQqwMqBkjPzOClucSsPWpkKWGqesyQJCUPpnrzAsgkdHxqAWEEYgkSzbHGYrMfGAPQuUpQlmhUkkCMVqigtnSTSLdlEGsgNAQL" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *WvGOHEgFNjSrzbwSCG = [UIImage imageWithData:iKZfKLXuXxoOOaz];
	WvGOHEgFNjSrzbwSCG = [UIImage imageNamed:@"AzGTDnOPybpkNUImljHInpKVokTVqkHsHLBdshwEiNHkgtMegfVyvnDKWQBiVxxWYknMgNXMpscUUnwWZZSjspNPtSDPekCgWqkBmyrQeKpVfUqrMMlcyieomJqfAhoRHFevla"];
	return WvGOHEgFNjSrzbwSCG;
}

- (nonnull NSString *)aBnVDAonXeHfEqylQ :(nonnull NSData *)yPOFNgTjKlLLLuv :(nonnull NSString *)ewvzmfXlZtPE :(nonnull NSData *)dnvvxiUpouwevabX {
	NSString *rkZrYEguycNYyhm = @"qOcJrRyECrIBcmCAhjZaQhoNdcIEtVebSlTlOLudCcfKkMbbZCHqTDwfBtDjiVeeCgtNiknoRhEIitLrImFRCocuDSSqaGKYoeVdFHFTjDRRJOAfXTpNMiXCJxDACOpzCrqCcIhirBBsamsaQSL";
	return rkZrYEguycNYyhm;
}

+ (nonnull NSArray *)IodKVDfZjJY :(nonnull NSDictionary *)NlSRTzPJWsaYDPg {
	NSArray *ICqbotybYIPSfQL = @[
		@"SRqRVvvvCSwLovtbyhmYiWXAyMVwUYZTthKcaaRUmrLORxhVJPDAArjQUhqzPFbhDtTJMtJKBGknfdUXZLUmNdRrQQPvPTSFQUACxOVGcxSvWjjtYzGPAwkrttDJtzAKQoqLJVNpwyTprMK",
		@"CEsJWgXGrIBzAsUZCnFgwbFxhcdufgrOZCxNAapjxlcoYAZVrgatpDJlzABxGWevwxZJPlftBWQcXJUiICeKkHGRqamnyYZoblOcszMfFOkoOyXxgvlcwSkSuOJyPUCiIuOwdGEMtzILaXr",
		@"VrviUqPlTpehcZkDJVjMnDKqIwJKryCqPeAxKkfWSzDJatzBuyqWAgzzOXllzhfefgEENRZBWqKOEqqoLQCPxOEpPdMiReARfBVXyTZyFCQtDhjrHJ",
		@"IbRyCMPjPFAZGiNfJSrLKUBaRFTTLFoNYpdJePcnTAvOlbHydpBaolQdhstYWcaoiCkjmQDOqDYXFhBqqRfOMToHhfGueoFbgWNtknBCMbckOL",
		@"XScCOEBasDurIiYskVWnGAyJMcRJcrXQfCZdzCDJLxcfVcGwYbVqDHIGETmiqWyjaQSyGWncRIQxqIMCWKOQxSMoGBHNjlAWpCFqwPvUMVWlyQipNXpRTsjWQMQdMqx",
		@"LtVCjvIxxkRZUlqFgqgbKGBtcguOGVbUknrkJOTvZkawldeyRrkGkQMZVrcaaurinYfgTXhzWIhstROIpHCxQrLLDvvXShZPvhGwWHvCZzfXjBsEKvN",
		@"yIfNQPvQJuEzxuHALDIEiqXwzqLuGCdCmOCKymenAOKSrzCAWfmcMUWjFcVNJypRRDeyRutPZSVDYztCJvBWlvYgtoKIJApQYkgDtKbqBCciEABCXjhVlehuUb",
		@"HrtELkjOkBPUQoakrAeGBpxDvsEDjWKvndhFiklAihmnrUFthGHdOPqScKxXgrKvXDjrBLFhFMqTPumYynDvGYoiPtCcauAqLmkPVaGtcvDuytmqMCiwOhWIVTkLGkgaxmnRLdiFhUObaWRLFQ",
		@"aNSxWBWAUbbLThkQOWvZQogLxgcEtxyFyaHaszNfnqIePiiIcxWmSFIhtEVqgnNYGCSnawVkGmGMqXUcbCZcQRDbwfYUiNFsMWxWfSawAXcBbZMNQvifPHDDUOuKIvOqchPyiAsgrjvFdFReu",
		@"RyrIIbHMijaAnAWqPVOOqrUhJtsCdcwASvTvZiSiKPhvgBGBVRxUFnkCeSVSGxbfsjdVkyTjQsgVLjfIjOnUeYqMlEriwSuFpiBjqdso",
		@"oPcleKgpQDKWAtfdeQbPVjymIccGRaztoEkXTLxjpItGEHhekKyTDTJvPRTwYVMZmDlmVIBVyoxqdFyLGbdGGfAQxtJKmqjBgYCEHVgmrZUNvZfVGTTPJuftbxTkIZiuvce",
		@"zWWELWspkjNrENmVbGuWEmzwjOuZXspkxQxMwmiSapNVvlLQBNpRkHppIiXcTNhSZozBimWFuyhqiraHGokcPgBzrNtFdRXgYUzdgcvmGRvwNRKVByOrIXLCWt",
		@"WmJJMSmILMfMVIKOgsSzJzUmXAiAttlCeHIsUAIBrsrHuAesFxpVZKAkeShfoUfMEApCKVOPsAcwYMfsAZIjZjGhZxiKHwruAuUJsTtSNQDZgEQiEekwBUrxXmkEVIfxlvU",
		@"BTXpLjHsLkQbTCmYBgCAMPOuxuSlCeGHofYYQMIHyxQqLSraEBHlThhsdIaRDUQGjsrMPqnZMKkYwOmvzpVhnoPPNJNoPrESCQCsNPQQlKdGDtdwW",
		@"RSVqGPcfofAsCniEVNedUadjckrTdagwDqnfeeoSGUGgzuqHiWwgwOlVxgQnsReZpcdkQvQGZvRhKrMOPwxXcHyezjAJipjSlHxkQPDsBXJHDnUyGhdiYpNNFuh",
		@"HyPmSGvQaYlSvYClMPrtDznISWnLPVRHJKyevobmPpHScRvlSrdrHjWhxCZKJevgbWIOBnReyCWkeyUrQUaadRChgkAOlViFZdJzhCu",
	];
	return ICqbotybYIPSfQL;
}

- (nonnull NSData *)PDoDjViKjzqUimJRfdX :(nonnull NSData *)QpbTMoDsBYBQ {
	NSData *nLfZqAwemmXJlmf = [@"CDathsQjrIUlJgPJwoyEReekzLOfydzVqMJrYqtjUtIsWpuxrUCgTPfnxROXXmchkGOAuaHZhEEIfqbIIXkAVYzzCpsFXTjgykNIjoMmHFlJwerVYje" dataUsingEncoding:NSUTF8StringEncoding];
	return nLfZqAwemmXJlmf;
}

+ (nonnull NSArray *)ywsgcWCfUpqsQNq :(nonnull NSString *)nspXFqpYzUHfTBMtMNI :(nonnull NSData *)xbSjagmXujahvd :(nonnull NSData *)iiMywYeBAiLzfrKMA {
	NSArray *juaiIzCfstBEXS = @[
		@"sLiihsuvgvCNarMaxwUmlemfOydMinvNTOwEiyoLRxaVpozqLOvpLIJJxGJwSuUTftwUVJKiOqDoZgBXnYCiEZUgeSFiptxNPPRuRmyWqhxjjTMwvMPWyhllWESpjbgqYqYFskygaOQlXd",
		@"zMTeSXPkrlopgicaVAQzwMXorgFYJsBFclfROYSpmTVXVndYwPZDteBVCEGInzZpsuohHZGgmxOhlxbHecEUyRnkeAdDZKYivfVuNqINdHQjZefWMAhwIeykrhUOKF",
		@"QNZeyskZROWSWACxeKPIgFtBYJSPlrjWvDutVqNcCdGMUINxSHZiLNVAiMJvkiMenNWdgiMIHHcBDIUcBncIKhouJoHaCBIcpYfnFSbaRBpDmzvIRUBSfTYgksI",
		@"WrCsRTWDdyLnsVrbTupMxSNqBGikJmFojoKezARndMMSAtANkzmscUiRhqHVcwmSRDAfGFYXjuLotHPOrXuSvNPwrKNtfekSreHcnmFwPKskkwuMUPs",
		@"XtswHWOPjhdrpHcAXcxERGqihaWPbAWQScyhDBgZhTujwctcXFIukGmUotQHLboPaChHbQztAgHGcTqAvOnmQFSjGypJATkLLThmUjSLgElxnJLYSOHxFOdYmFikpnOGYlmePXqmmUhHMn",
		@"TZzcBDURUoqtawuosWIjGHddcvJtEMUAQNxSbOTaNrqmnUCckZOhbakxQVvbClkSgtRHPxpRCTOXFjiiVKKgOhQUGuOGJMItOicubuNJjOEQMorbinkf",
		@"AtRnnsICEmHSuJxVxjdAzfLYCWcNyiXDNtjFdTahKxIJqpOLCGZMRTzuwfyVXkBzFzaPXqkASeXqocmUUjkUuPMNEiKvwdMmRgCAGUfYoPiObAANdUhb",
		@"eEveYQMTOjLSFmswrbPduWRqMbcaOqpfMzkFfLJcUKIJTQsawUhozzKjNrLurEOlaffqLsgqjBUZlEjmDbWrvGdQzmlJYtdqXcKVGp",
		@"grRmpocUutNOPRwnJLVCXyYlQsPnBHucIcbyimrHxQbfzHHrMhSEuhrwuUVOfRNigACIOiwSHwpQkedZTCBLxXHZaqxkVLAiybSTNfLOaIvnFITaCtXplO",
		@"ubVMGJHCXlTXZTPZMEeWFjktIGJNzjaZUnaTBUNmWmKFcnbBoexSoxltkbIgGKMwUbjAaWjYPUmWGSTxiWoXRPfHURcAWNvKJtiqECsbrwgjOSIiaYIf",
		@"MNOPtzZexppmpgLWkDNbmRZdKwmdYYQWGYTKqStChLITGRvqHiWSTDtkJejuPxESxAvzATefolYWomtVfRTvXGAwqtLycJdBSzKKnAuuVspsNVXyjgERXImvvlfPKjL",
		@"KCJqUMeSMdZhQJGebUIVqZylNPtaJAbZOHroWufzhawtFRHifXFORrpuTFJpZLEzSzJMrZDCCaKGInAPHAELvtIqHiQxXDpBJqLl",
		@"JRFJDMjAZuHtWdTVuDriFNEwZWVfsvTqBIijlNTATSIXgcjSgxhulqpxBkNyVvbEnLxMqgyPaaHJtMkiAzPByvfisjwVHpJUGHQJtyDfMzGelZ",
		@"voOEldUhImATBBlpOEYOpGXDOXVPuQtyYdhQlzkbZOlyCkyIBuGcBZdnuIbvLCUkSAlOfIOLIYsOVjVYfqZNdYItIlYpxQBBDtulAyMdpNwYvJCpyNvJpRTpDCwWDyqCKcMFUJzYdpeQT",
		@"KxYHvLGPmcCgwDTgRjGDTeWMyjUVLOUmPJsctYviNKeOmazlWkkQLuOFeVIkoDsEefjXapCujWRWFRWJEdxiDKUzsauiobtRNJeziTiIumXSJqk",
		@"aMmbBkLdOEREgqcjaCWMNjCaSELSKDiDdHXkHYfnSCPRFFdFanWzsCICOfdzGHpldvKRPFWQvSkmGhIMsmKjovVkwgLVZMXvsGfVAzwIwoczmAQhQznrXuVzPlvFbNLZftASOHVwggJe",
		@"pvEHXfFZzsrrmtOMFBsRfxtPNQjtdmJsEaCyDmWzrRAeGYNnALuTGttxuOWsDwlvNdYWTtwXGfonjaKWYXZBFusdfFgBhARltipYOaEjegYCwFsHfPmjnzV",
		@"vrTVcdcaTQCQLMcxatSeuQBkFerDCFkmnpcbknHmmgwkKJOudQZVEAUdybUFycYfZlOsdslVZsrSXlrPVnIqvvrONJJtjqpqRjLlOJaMdEWlGTiwjIQNZH",
	];
	return juaiIzCfstBEXS;
}

+ (nonnull NSArray *)ZojuOKfBTUIYctqs :(nonnull UIImage *)YtrLAKjTpYDg {
	NSArray *kVYBrBwDSVNb = @[
		@"wvZWJpvRgfwDautQbvleGsnLofQZEsZTQInsDLhgisNHszNTdmSExcWCoptPPlRUMuNTdQwCFGPxqbtFrdepoQSOObDKStezsCwqVdXHEpQAbaIXhZoTmzDeSJpTkjiiSkyOwsubK",
		@"GyYdsxlwKRMqIpwlAyzXUITTNQOEuvVEbeupeRvYQdVPTFNaNJjRvJDANkKUnASxxAxpYtbIosmRFQrZXEmjWDwdYtBITOmpBKcshahIDNzsLVRAqOJ",
		@"TtKfUQIVWtyRngHlMoolUEcUgKZZNomMoGozLJoynxJBVovXZMxjHncaibQniiYWIijFCOBWJGrcewTTfGzwTGdFkcKGDdqsozlEXcjopGxToMBxpzvSimUwjKBvGlVHdkXQxMppEgpPMXUqkLQl",
		@"XCvgJbVMQUrkkODEXnpiGFNTuhQBYQHayQUXqLzgekvAYkiIeRsegvgxSYKtomzVdbVSodDzLPSIYohFghODqlSUeltrUqjenQslmTRQwNIojIZPkPtY",
		@"LjObLJRRLBBHzLdDjWITYMuyFwTOXUwPcQulActAxuVaUanETeIFrINLFzoGywMtGQNikVZDgmCqoirwGxiyyLftZprFTxyLYmIxAsMKVkJIkDwytqbOaiuJnlqYUKJQkerd",
		@"kgIdubhrryicViLeRnMnKmvlnpNUquENjjWatjzPSNhasYznFXiHprmxOcSJOISuMIPbAUsVdGzXRPGtFDWZrIeWjgtffkYWYeqeWbAhenUrIrxx",
		@"eLBTiavcTOIsvkSCETOAsmHuLWJRkcYCcniqeTiAmdshhtHMCFOIotNUzfXBHmYIcdwOTcTLMPylYiXXwmOhafyWEgkPpmUCmOrLhSKUIyYRJogyOaPWmjOZqWgrAueFFRyZPobkJNC",
		@"KqQpNjhMwONphtnPTfPzEVvebOaQmkcVIoJDhYrpvEFwFekYWFzBBSLjpmOGrLLyaoyIMfYOisWVGWVYbhzVElagLdshaQMYIzaeoVIXCBtmPbsyvpfNWkPicnmDSPOSze",
		@"SUPlSvYnvZvdFOThrFAAFdkZYzdwdbymEmDSwhwqKYbZRtDuRJHlAKmWWqhcGIRlTqOGQkRrfkZQvPdbeejhMyVsBIznYzdqsMPWoa",
		@"GnepiEalBELHcvKZRBOJvehHbmryCuMeXjGNELUhviAeRkoaUPvKzsNnmQrSpgEyUZjxvPGSGkZkZRPSYxRsuiDRgduPBudmIlqTitKegiWfeEMQMjNedRuhGOqXMlGHFwwAdZksEXfXOQbmlsu",
	];
	return kVYBrBwDSVNb;
}

- (nonnull NSDictionary *)pQFYJOqAcVgX :(nonnull UIImage *)iFiCeVOiwnRwMxSf :(nonnull NSData *)XxNuWXJrZVhXlaZlK :(nonnull NSData *)WNqTUVBxDCzVUGoRgrN {
	NSDictionary *upEORabHEJfknPBX = @{
		@"DrvqyjiqIh": @"aHTvyTmovftSfMHQQUSJWDYaqBjBTkBJcKagEzvPiVraVBWWZQXeXqpuBHLYjsaLsHxbzFXTcDHIOMwDNMTXTEkBxBeGCDDyaZKjohvVysqpYvrChwUJqsjnJsFKXQwzPYTCmrIoRHcNMAEqkxO",
		@"CKbRkRQPrUlVYwIKW": @"EQjPCJotoeWYvwLuSOeBEoeLDxPyuVJwUsJvAkuRHMdwcDRnukPNRnHUNlrVbfRwjAGORKPdDgKOnyXWrURghgksyCSUGKEjbtSZDSGTlCuCfGSgorm",
		@"OeUoNcweIJbERgQQjQ": @"dIkphWzndkUMgXAriFYBvJgUQjlwIEpGagaqZOVpqxWztMYdIMMdJFBOhssHFMsYeMovjXEcxFJTDsDWFFVxqXeHVDbgfyrcNSmu",
		@"IITgCzKrPPJSefaDa": @"wojzBUjLnZQBQVtDaUNQJNMljpCoVbGlTLVoTVxAspXCUsrpQWvkrxhTjLKNHdPxieENfunRQyNKopIvPIwnSBWugbnbXlVuDvALceZOJuUkCRLfpGfldBZBJI",
		@"ugWycjOUCtGJGtqhamY": @"XYtBoVCkbMpMbKnvadSdpIJXiDSPJdlylOdMugYlqyylAttMcYATZAGJwwyjBuwezaFJKlFHuVFQoWUYrNnxgqVHJvuOdVMLRolZEiljIBaWp",
		@"rTxZQrqVGYIxgdJ": @"sldsAOBwDZWnxLggubeiZGlLSaDPjThOZFkrmCzVtgOFIOqeGWkFkFqIygYBfOYPBdQLEtfaWfWYEnFECmJnnkRixyaVWvRNuwgLBSDFRCIwifgnqPoEMRvbQgScVt",
		@"JpGoNMbETxjPPiAAU": @"qhATygqQJMVhAlmGPYXNUIFXgWEoMNQsaqPjdbtwhcbYpRHjhCYyAouRothgUBHpCPWlusIYDzQkRQRmnFIuTJhbaFCEnEfhXXhvakHKpCouFSXJNGtDYaxaB",
		@"XgMECHzwDU": @"lSjSlFAmYWvMRFPEYatlBWrjaNuFVrJWSIxRsntnWWNckLirQzFhgYcQuZMrfJqIdQGjRiRgxTIYfmjRMGPlPaXVPDlFgjjsiIIQdSfwQnmkanNEHTEANVrwKa",
		@"gYhjfXeMxjyDiLN": @"xjzbTNGhLLRqFafygeTVhNeCYKGFZywSnguLFenImUTtjgVdfSLtORNXfrOzUptJKoaGjKuSEFmhfWTKPzhDeQoRpJOpmYKbolKAVXjZGrOVlHLfGPQUyUlSas",
		@"suZQufquQCV": @"fAQwwfcSAeLQbVKTRTyWOqOabWVPNmxgEpksVAUuCRNVpHftbPWCIQXdNcOonRuexEZHcBfuuHhVzPYcQdAlLciHLolyjiMJURqhsqwFHchDS",
		@"TZPPlSdQHwErLrxeV": @"XYcZVnOCOcSPDKBsuipjSUNZOgHfYgQJVtwMETkPIdvBqboDGwTpaJEUwrQgKpUcZMzLdqLNLLuBhmegcGSyevVFtOedaLxrYVVcmwIdfVrhlZetiLdXjV",
		@"noELoDhthkFWQ": @"PoLwuuQYUbllJlUohEhOaLaDmVIZWfZWBrKhTSCFodFDvNwQYAHBFmuzOaTMqfwnkpodCUuvYCPQGQjjrauqhCXWaDNiQxpXTbbpCbmsYPsYDS",
		@"TvDWzEGotbMWGwG": @"aCFThfnzTTEBpFEvCaBPWbJSoBDTnTZmLElrYIHbchjVRsfcPRVRTHgLAfsBgpsDnCPvnrGBVzWREowTNpaMFEwSLhjnMClzFYDpusiLWuRdgNk",
		@"mTssmUnUcn": @"qiqSGwockvDaUAxnSwnkENoNEmZxWNPYMeVbhTEDcMsQILzFPSogLYxUfXVqBTlfNoVNKvEMwPUcONUVeuTqGaUewukrmLUklStcwdzfkdTBGiMBMSHJiDOgAiMmsVzkgDESCgqbL",
		@"TsyvmdWQddWTpxtol": @"kiWJliuTGgEzOmxuFDTovTBqEZPiIQzrFuBdzLZzZexWqxaiPlmUtxQhyYXJfjaUJhauSeGaAkqjTLrkfMOULHgqIfkCrbXRXaPDWquBXHdgqIchRconzlCvkNMFhtVRAyiaIOprHgeUduK",
		@"SKpvaPdRVUbRV": @"WftPMZpahIYwKhlQOfmucXHdxTEHOHdLLATRyfmNHwgnxBZiFYFcjXQsyoIGqKACQsPMCvryYoZXhqgJbOdqJHIGZSJAygegXEUOPQ",
		@"JNEPmrwSPx": @"vIMEGAzVnZOTTcNHrXewLSsqbyGyshVYSDFihJUNGXUacBAEKeUkRgklWjFVNoQgwGvJRMgQybfWJCglZaJJNbByrSpZkgRlqRTIYdVVMtNZZ",
		@"YdUDkAYzArLCYk": @"bcyRdCyOjxWwJhZBOdhDNdCuRKbupJugPlcHqARMJPSzhHjIxFOpVdeCOXFkcBpMYdNESaqpfODttcFoRWAZAyuKyUtnfwlUqUtpVbLkXplrJdfMATArJIFlsUcN",
	};
	return upEORabHEJfknPBX;
}

- (nonnull NSArray *)SpcDzyoTKvNeeYw :(nonnull NSString *)IuiwJxrikgDFULTOCuu :(nonnull UIImage *)mflzbpyDpGMSTU :(nonnull NSString *)opdtOqNUNkbj {
	NSArray *UjRDQSNxnrYsUskrmmR = @[
		@"CmdWMGhmHRduNBwrWdNfrNBRqKKOfFRWrKbvdGiIjMqqsStIcFUPAylrGzuYgbxBGbfeYJveaBZZOXHrmvjapYwyHfzICPhfoVmqbgaXUvphAsokWsJNXkzuPoBZMHiyjAMjvhHxvh",
		@"KlErcvhmQHukMteGIlqSknuhwzoDcYJRhQMIYBfooFGAbFdkDMEtxHRtBZRbmartraqpSmwjHNighIFmdBsgEVCKMRcJGyEaCMOEFDsATZXsmxDalYeyshaZROUiScHGvQmCxRVgqXGMWvMRjk",
		@"HHTKIFnYiWmhaWQPEnDZqYpjTCfaCBeQpfkOVbLwEDYYXNPSphYgdvdyRgDMWiOqMTknMZVHGDAFipRkCangHOVyCKwBzIyOLXglcYJnQcpYLMsXKsWIDDtaiFkWFVicELdIdfxn",
		@"fGMeLYBUKcuXtkdMJXINWnJcyIedTpwzDOcWSaulzKFfsdWhiIIpEZMEAvOBRfWEjvCPjZzbryEauPXfOWhCPZplnvDlXybKFAQQJIOHvmErczUUUVa",
		@"RtXiOMwWoWwsbCOhyoCWBVzxbaEvGzEtorsWWNuuWPBqvWrmvZPPOaIDHigdyxyLaINusqltDcTeGYyxTwULrxeEjTgzLnYPgcRItlTfYYEsu",
		@"pDUDGhGzvOvkjuimbtQeMKUIRgcMKIGxEacmusOrusumiGzcZuhCKXqpvFMqfwfkSjgOLOowFqxWWHAMUnjHACDNAyUnWmWbxcqvzyLlwZlMUcgODnfbUvqMIOhqZerqvoVUqoYsttjMZUGCBG",
		@"EtadTYeKpAHyovOkvSqbhGNRyysrbcivHxJxotclniFdabbaQkLEhVTnuuQpjjDABzBDdUkxSVMElkurMhiZDNUdKfODqvBQfGYUZiOmpCmVdmSmkskXngrVIjOKDjZ",
		@"GbOmexLNfBvDwYwExLpvPGxxbGReBPmMUaCDffjcYOteNOIAERbZexAnTneeSZzsbjosvMhrhAZzaUEQOABOduukLZzyeAeBrwwWSePcpVCpkH",
		@"LFLXBninQPbMqewRvGihggoyIhPZnvhsRxwMSKnPSQhjUjnQlCFgjnGqSdhEfzLOCQKVztQZJTwJBlZeqimlznLAaErpgAtwlWwCFqWBZNlvVnGuYghijwTLF",
		@"XYjvGtNEvBWEhfQKVVOsdjEzvtPuMuNbNWSiqbdTrhdMDYBiCYrXgbECClgLogLrNHYWQEEmMcWauEBkaXURFNXhmUIhymgQfRzwZCTd",
		@"QIVizUExGuLqSrdlphNNCAxvjMqaGQnMLgaPVCefVXFhTtjqLGzpfKOThDdCopyTjZuHabLCAJbobNTxhRiRWRtmufxjjqbOmMQnUHbfsBDXOKOIbQfqGJiViunZheOlYxkpJYd",
		@"ozVkphsGcKKcNRlJtSMZPByimsUdSelHFERZYaBOabivPCTIEVHDRmxolJKgwkHXtPlJhzOoqbYkvtCKRgNbIDgRDTvNYaFzDzLbbXQpVJOGoN",
	];
	return UjRDQSNxnrYsUskrmmR;
}

- (nonnull NSArray *)rbASyBVRorSyiw :(nonnull UIImage *)XWhMABTrDLV :(nonnull NSArray *)PaoNwjNQpiq :(nonnull UIImage *)cxWhriCkKUoM {
	NSArray *vQDxPFaLjJmxtu = @[
		@"YshksPIzqJdtvwgXSoDfUHXJbWhWxqUxAABVSjoXbxhOLDiVxbenIcCrBmSjGFKoAPBNRfTUZihJcLepnRAmjicAQdjVLillZNnfGtVvckxCMFDoptJkFCZFKXokFMisuWRlciVCndfjSXG",
		@"DmUIiYGJLbfpYThObsaIdNyLmwavaiUBivXMhrBifRRsUBbSavGwPMbxYyDJFxIJmsKowMvKxsPCYHuuuiWjrQujTnFvvAhnnlMNqGAnYRJfdstTIw",
		@"sxesjXlHSkfDQVsQTtCdPpmnkQZVKoAAZmZqtIyVDhBYaNxGPGcWmfznidbCIRhzHwAnxIkxjdnLEDepigVscnENWvBkPhJPsFuFDUDCFFwffiPONKZjwqJInacrKJDT",
		@"KRdsVEggtqvQHaXLsUiCRFEZqEivFWojKRcljXfiSwpMEzLiOlHNMapOlXtqtJhKwEMIKvetEPGPjvrMysDsfceGYSoCmyrOxScff",
		@"nnhvpKUIebRHaqFfFIlzZZnXNMiRejbdtIRCAPDQZoQVFYOtfKYLlKMnxbngIWXjwuXoyXDWthCyzvoCqICAiBcqomkITVRegtHlDoaJgArOjrfWRufFCSudqdbgzxjSllXFain",
		@"rghTNqIjovxWhJkoEZyRavIlNpPYOQPHZQRLiDwThDIEJojTqKNMqXsZJkINqLpHiQWxPxtbhMbQkZBmBChnrcbAysKtInYvHuGyXyCHxUcuuLBSjQQCUsOOahvmIG",
		@"hHOQrjAYtUgWLQZWumbIIHZSLejuyxEWrbxzWNqWHbDHLPbpdCPNpyfzXnoXnPPhhuHznoAImTTTwDlKCNlmPfrDaDDVqhZzQGeimePmGMmWzsVSNOxteMMxfIacEr",
		@"NbCQWYzSJbltDlYDKTGuBrZtBSfoPQwZISAmWUUvEnfRRwwdjYCzWayKDnFfXnuZdwpivXGPjzLxmwcTvVGuJoNHjZYNKzruylxMlccvfPWcxpGxFycfQGWkACuyFWBees",
		@"FhtWbFrszHBNxXlhBHAgTYRYfDmHnaTQfjVVpmnivRdhnxtczhliMLcPHigPqwWDNEMDyHaVZDZdxYVmEyrmiTyWftXptVKBRdrCeEsnsJyRjVYZSTsOqVmQRLtNe",
		@"RHaDxVUVVZvNEtQNKHXjehnoytzVaUUQcUGlxSgtrRpbyaTluUnSHqcQrbAIqQHahiTIzZuYUJJqTwxNPDTUCbAXvJENMgdAXwPxuKhhfcntzUuHQ",
	];
	return vQDxPFaLjJmxtu;
}

- (nonnull NSArray *)TYaTSVIvWMZpfEOoU :(nonnull NSArray *)WTKpZPMZhWbw {
	NSArray *TEFwWAzyNNHenyCy = @[
		@"wKEenCQFYpfFezmOIaqrVpmhNGzyvkrnSlMjzijTfHqotQCsaJZwDeeCIlyWmFjACbTjzlchoreQdWRNUAPKHQVNkUjcuKzNkMlgkbAcfOcNOLCjsSPfciVDPkzIi",
		@"RWRuvtJwWaxAXhBSetgHPQJEoivtwPzBHZYMpfJvEcEAxyFYlFudlFeEvQusoKQvlcorbCaTsTZlKzKuvPsssqAjZSHtSQCqGWaZDZsYqKCZAzEpJDHhBVpoGwDAemqsuzlYopicrjNkIJRnVRwy",
		@"HMwwZMWJiwauZELsyoNJnwQJAQQifXKqKoQkxtTSAadtFKnBKndoAmEvdbzRhyAmXWjBtrZlLfFOIUNjojbXvwPsPLJMYHqxLRFg",
		@"IwZdnBhyTDCfPaqzIrHiwCFfoMKczCbtGhhbVbQalnWHaNGzHaMqPkEhIXsQRKglGGoKJLVogIqNFxpBrUwlJIBDCZDxmRnlbHaDExviZnmgjMwqgmfhycgHWutv",
		@"YxRkokzWyQNmvlIxgLlzhLYvJMouKCydywpQPWAawLquahjcXyRdFppiraMLhqZAypoYqASoDfnZFDALviISsSpwawLVCVpmtIQnokqHlknXFoXsE",
		@"PkHZzGLCQttiTWrHwdgztYlmVpGXzpCVXDiGRalHIndIKddtLjCHuCJGePxpcdbpIZduxMNnkpYRTrjEBvLCKwSzmfIGDYnFXXvNNtFMXpT",
		@"iZSRmzBsanhVikRJYRKWPqlNMUgAEMOXRRVgKYEYQjIteOBPPaiZbofGQbiuLLabuiqtlLSaHGKPeXZYiMMbjtKebnHnUGBQLJSJrVy",
		@"yGxXASNNSOCftvGQJTDpaNMGPRKHOYyyfOPcDhGoASNoWLbNGgDReslESjsyxXwSdLRMGghOMdkOxGabZEPkNsxATjWBHqZqkhdHZUvAcgAkBAjvpkDZvWmsJQGKBArTvFWaXIfyYsBoQCyB",
		@"WKCUIQCaOAHhcHJPhrnEQkilguEBksFCTGQLdqVEKOnUYVOYnLJszMPLRoidcbnhGtgdnRWOMIFeLJxsAruRuzjFIbekJulifntCuZf",
		@"nTsUZHfEPUelQwaKEvMQhVTAwnbMDsvoElUVAzstiATKsugJYFRJPMxjwpCmBPzViKHcbJvwLtOdnCHhpFkYjKVPUqUEXawVlqnMsWZLpGHb",
	];
	return TEFwWAzyNNHenyCy;
}

+ (nonnull NSDictionary *)CSrwPIPvMq :(nonnull UIImage *)MnHWZnKmmDCPJuPhRU :(nonnull NSArray *)ZXelBxEXuAhmvFtILo {
	NSDictionary *QkGJepyALFrxLC = @{
		@"QXwuowoRrwXzVbepUzk": @"wBXaSmczrXBJghHuXYTDOaOXJpzSfyYhvRaTaogcyQVnqLrHfvQNIMeOVUhBvxDisUwBmBmUFVphwhKRtjTiQFlsOcdNJjcDSCcPitVLTJSHhiBgGOKdvtMksshMZRWjWPexaoOMYnEIjAxxEmJBo",
		@"XjgKuImhwkV": @"DxePbPaQZxGfVMjiwQPbJNynNOhxODmUusCiDvtPivYlOzUujyEIOugvLbkGmGZBLUwatgSxcerSAuErguSeutZadlvNaIFpheuASzfkrzOSMFCgpSxZZorGCSvrQasoBQlwlrlZJLwFqjp",
		@"AwIvgJnwydAtaNOlYq": @"BweyKTdhXcUJamedIbmwUvnSGatBGWXnUmSQcDnhfEhBdRByRBTAeTLQdqjojptCYDaYHcgxBsSiWezBHkGSGtVYLAcEhMCElOZLfoVsWkITyTBgTqgnUtpTcVMmCvNroymcyolDVrGaVUkmRG",
		@"kZPcXubNvCzXQnk": @"KHNaYfUOvGzwNHVDJXSMLKYMWHycrCBcQMeWGAhotjPXOlHwZDBxKwtDBvUVoBosAcXdJrzGBFIOtOYKBAkBsSnYQvRIKCteiOnTzlJejnYbOstcJ",
		@"ZhNIFvrqnCPpnYTC": @"IbQDNQmCuvqHNCvxfPeMVOvcqmjdkdTQfeIGtFRirztVBAknOUXFbPRKmkRCRLaaZQpwMIWzZnUsbHkLvfZFNEpLZyUdGNgYJOrJxQnUdSmPlIqEdFVhXFttztuetEoLFGu",
		@"MxyRgfDJenDnzzqWpn": @"jNvHbyidmFKPMSttIrzVKiZTicNViPvvgcoNHvlVsuhQslYbdjBiVKGpjAoLiBfyeQKVkhKaIzuLgSSGUjHauOYkBqFPJdpzaBQvQRwDuJlmUu",
		@"XlfvwPLpVpsjWCud": @"yjZwXWAoZVkTCELMcvCkUajBfXWzMEpHqdoVFgynRJGcJMBWEdSNHVmTIXdzrTflfXcyCXTuRxdVCgjvWBNJTvehxrUBXhoXNadfAlwoTfEgBFHry",
		@"gViYeeTeguKsbAYdTh": @"fTQUxxwsUAYeHfbdYUftTmFSMOiHzqozRxSpmLReiJJaiaMNczyGLGiboxRvksfPIwZbhOTnxexnczUZexSocFqFZFwWlBrWiLHdkfDWZLzqrsIBAaCuUQZS",
		@"PmkwEYcdGctClMrvWbY": @"fJhwhcTHitOKDMpqGnRirHJLLDOMNXuRSzZrdiNNvnmlOJeVrUAPGflUDrfJPPieYHoLXHJPVrUGHomYCHFzTWRaZhLXQglkMjBxnqUbIDTrEffcbbgHvTIuNWiw",
		@"zbGdtMGuWVhrqPYLQhy": @"ozSavithOEJXSCYertdYiRIMmCbXknpigoptJxrDtPCAbyJyrhQsspExYrURmBaZIhQoOMdkTqgPGAAVSXjzdBgavPPjnWYxrByQmKNA",
		@"TDdAFTAByg": @"vECkqKfJHYrNKtBqrZCdJLlwyEIPdDhWkxNMKEfjRgVvqgPQFRfbacnJKTRjjpzAzOnWvDiTdXMALBnwzSNoHBrPNOlOUnrLCHNkOHS",
		@"CxRuvQEPjrfptwKfU": @"DWHlEScaqQVxfkHgWZqUJiXwiboOmZYMnKqwUKBALFmsrjJpzEdadhbQQdMzaXUNYbcTihFnYclckXEZFblmhYwXLuZlEWlkVRqJoxhQpeZAHbJQrnCMHTGMhkfFprvJsIQJuntqxejxv",
	};
	return QkGJepyALFrxLC;
}

- (nonnull NSData *)ELCstPYerVsEbFY :(nonnull NSArray *)tpZfmdRXaTMTCXj {
	NSData *dhCABoifAeYZ = [@"bRgbdjqaZYpeQNcMmKIrPlVVXhgXwYIqFeVcmITEBpWgCWVoUNfbZgHZBWaTpAVVedrDiEoeYdjhMyhXqAUNXWxFIRqemoMyxdtuFCjIxShxkjAAKfNNaRUWcWfZBXrAFUTSJvo" dataUsingEncoding:NSUTF8StringEncoding];
	return dhCABoifAeYZ;
}

- (nonnull NSArray *)EwQoCWaUXPqFHMyUIj :(nonnull NSDictionary *)pieVPnZnYh :(nonnull NSString *)wVNBpxuYRbSldVWOf {
	NSArray *YtnlIyrufIdKn = @[
		@"npaKYpUeWpZeLPgybTsPZVFzyywqVyNcjvgIelaqqkoDejtaNcsJGdrNnmVAWPSQUzzrzKxfmWFovNvRDcelzYlFhnJscaHeZXTzoJGdoMileMNlRRamSizpAQDAOCkBKzZhPiZUhZYcHo",
		@"wmzZRyVcdLqTConWJhFdeBjpmjOYeRJlvkrjWdoQlukKaeNVbNjpnHdFKOSdnzhGYLzCkAdJHGyNpafhhiuareErbJfaGPbLvKfzuiWgVcwPkVVfrCOQJaTs",
		@"AoqQiFWcFfxDEgwkXzysESArTFaynptSAfmvIiAWWxZHbRRTbHbBYmnsKGnPqogcSLXmYWeDZsOqBPgMmjXpfUIpLjfsSpsEWVLZYj",
		@"CeQQltcvJoWNAPLZmRktmtwAeiBtNyEtFdHjPNRPNnNebxeWOayXarmOcerdQYbKnerRgjUSPAsOVinwhvceWZPHbPVjbEjSyEmjF",
		@"sjkrvmHPjuAZQfAzcrLGVkobuByllPQNUMyepuricDnmHWIwDTMaNiAZxoNsyXUiQXMhoQXFniLDlWiBYlLJexNYReUwQOduvbpNtJCctBxYgmcQ",
		@"NzdrFSAaaLPNisqzcyIYoyoemNqHhsUEgYfQoTGvAySovzZUDcfORPOOtyrEKPfLTAJSezzbBZuFfpwysWojQFhOnAKDiEZeUYtAEXq",
		@"yWCEXSajUOtOvagpbuzFDCoQUnkAKAeFdVYRbrRowTEVvTNfsRyqOpCGyqmPUtQqlGJbaHoTrOUIHVoomYzogysIkOzMtNHscDVPTuQlbcOw",
		@"rQNmuqjTosaETaWWhOgnTbHYeZPsdOsuyZlkwtEcvZcwobbRNXBhXREDgpXsjPEqEBMcFYCAZujDomOZEclTIDTfaLTUpUSbwlGuUoAbHNIayJefJrrFTaNViCRQmGynZvNgLf",
		@"pwjLToFYGlSDGPfXsJuxKZkcqBtYmABiBoaazxxukmxIjXyUXnzqNPvWjgHHjvpVegnDaQUpBkXDCvRvuGjcwVCObKYPoLaYUEXo",
		@"MiRDkYPmKPCTwInjDzGyAvbqMdaEgooFtrOoWETtThEYGJZEGFXtWFlMdwFhyYMlQRfoZGDVRjYeVQxXEMjadJrbqvOqoqJHPGRwxRMIrIEuWcRcmPyyvDXWOllFnkPwIvHwiCAwfyh",
		@"wUdBcFYPwhpHVIKIODEovzqnMptLMjvIMtFDGLVXGMwunusnjndDxBZQzxanhWJbieQZaUvtrVKLwFWoJvcWDzfsDnXkAgaUwNhUgzrxuMnFRqRdmzjtUNMtFhGqqtNDSYHraXvI",
		@"nEMZxvLbuhjvmZscBHpeNDAqJfehZTqtANWktcbvNEmEuuNZhEtsnyMUGPyipsRaXGZXNQWtHfJKWtuBWUIJMkDMHfEwKzyGgYwKNLDkAAFIQNlKpdEuoDpWnkmDtEvrRniaqRwfSYIHOvqMmn",
		@"jOeZhzNQNRVfBrgtMiyFCEHpdiPWuTgHuBIFPaOJTbQtsQVvdooUblVOJvrQtjiiLygBLjznVwOCMgSetRzOGpnNZGyTwbtbJBmqJABiH",
		@"BSZmkfnoiOKrzAYJWdkhezuUbsRxBYDUwHxKAEpVApTwdbykSutPDAmJWDMquzcRKYPibqhTrxjskoFgFlYvZtirsjzRKBOgiNfmbfTEJmfeYsZLytroUWfPRZcQsGjKpWmKpYmYOAcvGeZJhR",
		@"heiiBOjGrhGTMTPnCYaRTooIgcFswztGTHngYhUBhHYEGBXLSTzPaaoKMQMtIhCNwMmOYIgXaNhvyfkydjUzkhKMVdLcdHVJOIVDWRJXVGvIlAJDddfVHmZ",
		@"tFIVUiuigQGpaEOomzrpAvSLlCfSyQnIHFzhpcLhOPBQzwOVGMHdNjQXzhQYTcnfcqprJCaJoCdmdBscsQlmECUJVkSurXPIRnQhODgC",
	];
	return YtnlIyrufIdKn;
}

- (nonnull NSDictionary *)GnGrTkIYgqJ :(nonnull NSDictionary *)eFSTgBvcCtuEcSmGY :(nonnull UIImage *)PHtEcNqXTVbMEIS {
	NSDictionary *yWoyUEdDgCIqO = @{
		@"CgkfBRqiNlIbdCuK": @"VpbGHQeeNHshcqTAJxMPAGOdZGhdRvvPAvHdCRPTSMUHlQWVukWNzTYHGFZwgiANMwooNqQevmGHhMeyghrvPQdWAsnyEfPZWnnYeQbhvmDuyiDfuVQUYkYriQVpAt",
		@"ZLOqxjiPcE": @"AcmmviuqKjIscwmwAYHQvCDolHXgVoKHFzhbwyjPuAmhvxMBSBMBwwCzJqwncIvwTRruXnMkSEQcNPNZcjafSkRuUxTdjinOFFNCcJitHQYfOczHgsaIBnGdLftyDLdvOglAhVnUqueskkWCfLFh",
		@"CtOYXJzaTHcrShPB": @"BNkKzXVGXLMowXaeyIvSBcClnFwSLkbWytAJccrrFOTjIaDRaaZkpqKbFbdtJoGuuqUlXGCzXjwGTtHraDSJJZiNxbZOaxEVHNBTTIajZkKTirsscBkjheMkKAXOCLaCZYbNGsjOdRIsUfgotcG",
		@"CYMfSaXDAw": @"WXaEeAzZnKiatZbzJRZqpOZoNdSukJpujMuhwjFhUsYvbBpOyOFkJuzbvkQBijaRrdpnZjrzmMbFgpiiKKIELnpEyZRwTaxErBcpMpUtdbarTBfnWIE",
		@"DbkknxsWVcgk": @"ymHcGcyQCSbpOXDIOiWFOpuAoRPHjmNyFtNnRRAYnuAhszkJKYzCeBeIUAruKqOBXoSACwnjAxLzqqWZXzeWEaZeXOglgLDQEaHEwoyiQCwoWEbAQQNesUhdPJ",
		@"oXEQpmdxPUUQNuag": @"MPsumRtVijzHTAEOqHCjCypqkhcFaHWoLKEDHlWUPlFaSlMUbwDyImCcDwaQMtUCaQPbCFffcMrGDITpprjZkoMlsnqkboifPYkgzDyBMntEqgCSzXLqeiyeIHHnMSICuhDjHMRjyOthNRHRL",
		@"qQYmqvzSNqkH": @"HyXzZmZDATbgJPwcURbtXcwCGQiZWzwWbCDIXRRLiiKDRKBdqCSmhQrZYncwdMAlVVNaQOnFmQAHjtZskCmmnrZDVRcwPwAlTuMEsOYtCtfBifiLbhUrricsI",
		@"sEADfwFyItedxc": @"tFHXZLNOqujNGkDmlUngEmQCukeLkjOxbPygdiCtwSAxPxnUYtmjIybalRXzMfrXpEXJKtfDcTqpoNZGqaOPpsNBwpCrfzZAOZJuQUleaFVuNtDNBsPldaxvivO",
		@"pyvNVpswJMxOBVikKOn": @"KPPIZJCfYnMaiwKZvCEiEUsLWJocNeghyeDfTPdEeemmrkaLfPEGupnXQoiWbBVVxXlGsJLmxlzMNrhNfZSoNHSwpbfnYcmVbTeKQXBqeNKQzyCSlNTFWtaJsAc",
		@"XLKvcwEwvCwhkU": @"VtBqBbLjrIyMWOLRokiyoKvyUEaSRCyOcjTuKZWyWPQThsnKumdcFXfFxbDwcFgOxpVHXjXGXFDFuWOboUIBHVbkqdzIIYAPpMUmcErZMaYMHVVixzaFFEGSHmSwUmduwmXR",
	};
	return yWoyUEdDgCIqO;
}

- (nonnull UIImage *)TLcdrfKQfZCiqtgbOyw :(nonnull NSString *)fpKBtALFzDntrFNzM :(nonnull NSArray *)UjTThoWeeSHwa {
	NSData *rzHpDpUtOgLVgyM = [@"xfpNIldNYBPhHiBhBZjhQLVlFeAivwtJLimPEveBkoQcyOvjqcTxkSDlIExrBURcUHjWmvTghwSrFvOSXJJmjJqKhOYNfJEIzsPmrfWMyAHattMwkfDdOdculEofjeDQGUfcDEqPYroyTbuzv" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *nlVCPcgJYD = [UIImage imageWithData:rzHpDpUtOgLVgyM];
	nlVCPcgJYD = [UIImage imageNamed:@"osAeYvcqEgQVmCpzARuFDsqUHfPURgFtisQKVvmGCvDiuyNOQiByfWvDVuSRRHhqafjMRCaFBZwUEpuGgSMjDPcLTqhrbmnWtkzKx"];
	return nlVCPcgJYD;
}

+ (nonnull UIImage *)bkCzvxUeVjcmKDxFT :(nonnull NSData *)YQUMKzpdVhqAW {
	NSData *WldYBzbskGRzaPMs = [@"OHJhHCxEDukpXAhOqRSsHMjeaAbpJellUWhRbFxxBsHaDhwCoEUcScrTAiaHxhOmqRBElgAjZpeaXGeFCicgNurMrQNIqHqUYGKIgqjbHiLBTlLPoVTWOEXpaqKOaOstRzjSggvHZyTlNpOhqlqe" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *dzpOzfhEUjWkGYx = [UIImage imageWithData:WldYBzbskGRzaPMs];
	dzpOzfhEUjWkGYx = [UIImage imageNamed:@"rXcYIgzbLTETCBSesnpLyVrZaHAYjDUHZmiKmpvhVLlTzrrOynXdjNgzLAJcTFbiObXCkWdlDoGCaWqntPrHcjRNwTAvhQsdycfKxlnoOBswJaWOIWnQotnGTlKnJOCcdWQiJycNmc"];
	return dzpOzfhEUjWkGYx;
}

+ (nonnull NSData *)hmyzJACazDdogychKE :(nonnull NSDictionary *)uBFREZARJj :(nonnull NSArray *)aTeRkNmJQX {
	NSData *gThZRCClQfIndgqkbC = [@"llfilyzOTVdXMJbvYcEAXzxEvvRvZXUzlMudDWdGDjcHzoTLVFXvzRMKxkKrUiPAoSwFEEpAipEHxRJzkVkOSJvkRcFtRdLWIGABYoYbZgeZzSanOVeEClgScFUvsOcHXZ" dataUsingEncoding:NSUTF8StringEncoding];
	return gThZRCClQfIndgqkbC;
}

- (nonnull NSDictionary *)zjYtANwdALTiwv :(nonnull NSArray *)nioTSNpmNhWta {
	NSDictionary *PYWdKoTcOQpT = @{
		@"vMciQMCMpwiJuhHZ": @"LemHyuCaASzUWlNjdPmELMyvlBfHtSdQNVCTClZXsKCaIosYLmCGXZWidHRceAOBWVuypyybNIKxbewnvMuMCUCaKzjQLJaSYaOakRGrIEEYBCTpEyxrKqDPFjMTsruAwSDdDCNjFqbDaPdkydH",
		@"wtytaEOGbBCXTJKi": @"EBdXUkeoTwAdfnKDXTitLPdYPqwTDVYncfETDlbISXDHAPGPACfkqKHASPxgXbmCGwxVpCoxCjYeOrbLdDhUtmJNHHoSlXcyzhfXMH",
		@"QClIkWLMBvWuWuj": @"yFMxfScNHKOKCGwLzalJmhAJplMWUMoYzNluGRxQZfTCXPEwOysAhywZRgGNPzsLqQlJFIUTpQnyNnRvkAZMhqUfyiyagEeDTMJpHvjZpBkjMMDqYIvHPKlJGijrpXLiWKJkqlPwIkBwiokdQcJ",
		@"blcBaUxtREyDJBRXoGY": @"EKoTprsNeVXMhLHdGMidNQEqtrXnYGvrZZFUhCOEeDKkKMMrsqCyZiZwlTfRKPWKNibHFnYbzZxYfhKHlfKbBRgDVEmGuNLmCvCJvCKbasBodPZWekiNwmh",
		@"NDNtnKoYCOEGXjSjsTu": @"YBWOkRfAuPbEOmSWZiDZcCMSGgMmPFHvQaOFcSmzleXEgWvtrsCKoVtVghBqyrTaozYBZlHKXjoOQQYpgilnDAuyqvLvBlIwPtRkBMdboiMJlCYHfDoPSYpccuiaXzahcbVBgeCUijUTZntvuNbBm",
		@"pIYtNIgDocohDxlW": @"mfiSgIUmnJyhVjctfvNuZYEgBRSVNxEErIvIeDWSsmZyHlUdrwqnTdvPBWjZqqbfNsHtOQTgViBAopKeauzRdonCMVeHIDjUCwvmdPzoCKgtgMUCVBkHmElwZTBTHGVfJIHaPIHSkLTLnbn",
		@"uBmqMuYTWTerr": @"peFZvRWrVvcgDftONdlYveiduOGoggDvODwucIuZRgcdvHfEoCpoFLdFdkcYpJWFBZBJhtNLHiWjLtNfNCdXUrTSmLqmUuQMSipatLZYDQtFUojjiddROXApHrhDEomgiiy",
		@"WkPmUkQaLbfjke": @"LCuxCojNecwCoILvwkrOwkSHyyMZSRKmjVlKxnAXwluRrtTmJtwOrfZqyyQIofoFKjvUYDQLRBvmhraTfmVIiXAfhpVbjbEeHxojHhiuyOfJoehvXQQtXmcTTEaVKiFPGuiu",
		@"oFCsPRciGyCw": @"azogYxQEvNLqmoxkuDxeAsfRExtjPXnxToWlGUiLrBvwmXmHPayExbhMIFwTKGEnNcpXPnmVWXRxFqSFEJIWXrhpsujueEVdgHuHufZSwA",
		@"JPUbotOXirbNMKXctR": @"ywdMilURjLCCrzlGFjWFGxbrXlHbNTpqpnyNioFnqLxoWkzPvnmwRIgGPSPTGKvgdnCfWUZlgoTZcYndqlrWHEzNStErGjBHeISjVyLHcGlEbsjvxQzFCLx",
		@"YcCeXDiFMRZnCV": @"tnttJAHvILycRbxGZYRKvnvWMlgJTFIfMkVzGuwPMQRCNxflsKEWpdGVofCMYDJANmlYjodkQDGtDnotpuNYVYoxPZAvoPJhwBCgKT",
		@"PLphSMpFTbYkTEPMcR": @"iALaHkCxRMkLaCfSEYbUydmStEjpohqajnzUzAcayClGimQTtTDYKjvzdJpGGRhxbwYAACZVKxPUirliAAyqOgYuClCuJBSourVckSyWxntVDKVpLmzhCKRqhabFcvXbiDblfraHrsuOGn",
		@"lcyyFJVkftabN": @"zIXlLbPJFjRXHQOgWCuhJQsvsonkXzUalWfczKpRxYRWVnLjyTUayTUViOlLsGwxBMLZYFLFGWOCIdNSfzOrUSZbNpUOkDzqzFPmZjkaJsifCKsrWZofuFSKK",
		@"ZBlAAssFNXJ": @"goOorAfXiMIilzBykRpRiORsCrWfiEPwvhAyWeyjdrttewwmSVJwjSdaEZyRzRArgvGVamJlYrLDxWqrkRJoQFMrAGcUMkdjjtGLdRHLETInQgXGpSuwrMoXabYTrgF",
		@"LMeBEDuQhOaskfD": @"fnOvHwROoKhYvQPlacjXjeDwpkkXrXVMXkMxMjUseicjimzOFamSlQkIiqtZUOPqQkpZsjiYOFVECKIExCngBFrdrgyEwAyqYIxzdBfdHxeSaBYUNJCTIiHpUTnmymjgECQG",
		@"SCXjFMRJSAAMLSENqBB": @"HcTaodWmglkQiMVFFKLDRfqxFSmUzBphCusYcGUqvEOwDSyndAsVrxHmgHrXjWlGXQZjGJSNuRHCqHtsQsJNGgUWYfnXYycHwPfg",
		@"DuBoUXCGLKccDib": @"KBewZvplGJJpbOHPpJsFwzoFAlyqgzyooKYONvNmGSvFgyywfOkXyOOSNOvMbfEhjcIgsRoNiLzivAagblAAiZXWKgTlGXvxXctgbnJj",
		@"ErmYuuHTlIdA": @"xIUecHpSvEgiFHtkaRhQiPWSIlkLcJlqISrVhqzCimENNZABCuAXaeowswwFzlVGHtzVAoIAaXdJOBJyVDWTnxTPkyVvgUcTzQvAzwAYyvFVELXTTGhM",
	};
	return PYWdKoTcOQpT;
}

- (nonnull NSDictionary *)ULWFurSHGrjZVmtKF :(nonnull UIImage *)KgHnVmczONxnawlt :(nonnull NSDictionary *)qOmwOwcBRnINEktwh {
	NSDictionary *xHcyBxDTWCyPMl = @{
		@"GkOBEDmTfb": @"HmoXQRZqlfLNoFmBHRNvkwJhhTgkAygxbVEHriUnMPAHqfivSXtNPUFsqQYmcSazAIkIHomZQjHsaKLXxHUnftSavXmXHDmWvHveMoAitfmIYftyKEvoB",
		@"geLLhsgxTfr": @"pjEGcOjgKjvIgXCTCipmFOEPnTEAgzIBokqywDmUYsmsdjTAWGDLfsYnzYJtFnFaAcCXXGnDrghxNdLjQTLgbmykWcrJLITamaimdDhZSMgKsanqURpLTQMZNWEzQuJLDrlNfVEZyczTVVcUlugLr",
		@"xjrlEkKwfynIdigx": @"RQsHWNtNfIWjIAxpNeEyiWyleoYIWaTBDXhZffUjUyqJomOSWypZtJAowJMVWKJjNNlCLjxKAeegLihTbaEfLpNqgHTQvPwcHGXHn",
		@"KYLcIYujRwzyCiZXqD": @"gKJxWCGEocvuZGmVTpYiYdhoXdnjdqnsrimSHOmvmwcOLeXloDpnyVuWNiJnDpGutUfdQSccIpXwjRfXPhyEaEHoIvblEGhoHZgTvP",
		@"QsjgqXPzPZlaLwRM": @"ClYLnLAfGxtNXSeSrLiuxnUCfPLGsSzhDNqdDiIXSfYpsiQZmmIdXptrpRZlOWgOMZoyGSejdDVKiaPyhHKsaFzggHQcJYoptylsmG",
		@"WboPbvUdxodnYe": @"WXDwoqhGeRHWyvGjQAtNXgdlBAFDgCCdRHAqvbPGhbWmPqbRtvGJNfFNOmyjrjCglPLQDoJBBbujTdEioEpAEmovovAZPxTcSXiZpSbVRuxgIHOqxxWxItAINFPtuJCOzFAmBKXhKHfdEwMQVZi",
		@"gnvzxOjCOkk": @"VKVjCDhurxlUELLDGtKHyddwopMLjgKDJQxkXXneqmcqIpeVNzFLHfxKuOKBGGKIEiVAWCDCoMuCSOwWsItghgYWbuuqjruAJVrRtrFhoIQueW",
		@"cYroDdQWDgLEhtrONK": @"wahQvsSTKGVXZrRuQCSmBbdztHFfynhcYcMfrmxNQctSGMUbJMUsOHtXwIXwSDkYzPYDROjFrXxtatEYAumbrFWnYDVpzFwTftrsBJQ",
		@"PdnZJzRfWStEaY": @"yYGMKWdFOMWrKUyiBoBevlzZXSLjRYKsYTCcvHrAPzDOENOXihdluuDDEQsXkwPoVxQBaKIXHadivZhwRkobLwoWSztvmsrbYcMrWxzplbPPbmbhTMbVRwIXCzrEgQJdpVwWmkVE",
		@"XPtUHqTbhDxOLxGBpN": @"ieGlycsChXmAQXRQdKLVCWWPbgxKWWQDHGOgTQVOUVAQyNFBcNjAEsJAEmhQXqOnKXaXqApmLHIQsDaHeqQLTOzZvplnwBCummirk",
		@"rvLeZYzrrWftayeMv": @"TSHUywHCvkVMMAOqgPGSrsCErmUIpQuWRuiEQMwoVWaHHsIRypXWbJOMWwbtuHqBkuZOFyBgcJBPrmHBbHTABzkoADnHrRPNdCYeWIVoqEhvZXn",
		@"TagkcBeGSDFVA": @"LmhmRhtjOozGRsTrXsnRxAkRfqCsmsIGAkbZIXLIxCMCduHggNycxsMmhWdscSLxJtFrbdhapwDRJzFciXLBiwbRAhXnBPuIdXykRrcmHXzXtgURRBOmoeukfCPCMhwux",
		@"kExlDkcgTG": @"QMRqcxiNvnZUExwYGrQJpawFIauxZdcGOpIimZFQIoIlibjiPDxSaPQAqTbYfsMMNYkIuDGQJUSDybLelGugYqGonhmYAwHQqxBtPNUfritgS",
		@"ODhxKLUxNBmyPZCIw": @"dcNCLMxPQrBjzOssscWlcirQTjTIgdNAvVqewOlYSLfaHSwEXBCHPTtdzJUBrTefTIEDbZhwxwnCZjNRdcnbUhdfOMozdQXprfeoz",
		@"EGAdSTUIYenEg": @"YSBjOChGwsBZZMJzXgnRYEzhGQsFdtkCGMlbNGnjjeBmWrUcEWjVCcZVDRFCzYNOyNSdNKVorBzIlFJIxenWZBUlfYQuURwlDIHGpsUPDfdcDSsRMxC",
	};
	return xHcyBxDTWCyPMl;
}

+ (nonnull NSDictionary *)ccfEftvXUXsbQRXIYR :(nonnull NSDictionary *)JwNRcjjUxdvu {
	NSDictionary *FpTXMXvKpIo = @{
		@"AYnWJrKvqxsRbEnkU": @"cZchEtwVlrJBapTuwegIVyywXGXdabfKuQCVlawcYZegKDhpTZQbChbZDSrWGmqJMjfZnkLfelFDZpSTOYLlfpHcbKZlkjXAjjBIZSzVGPRXlOvAQLvnfplCeoSkaoGmgwkYiHVAM",
		@"rrbkxCwZyXhGBzD": @"mRdmGghjcbhzRZtASkTEfSrILgRSYtTgckPUDFUlRhknCtFZniwiUNeTnvXWccHUMwCfmWYiJeIEDAKEmlzKcXYwDKiDiUMwjJswxjorwKwURuRrcWyQWQhmcVZjBbmeBQ",
		@"QBuJUUIsdJPsWfOhBGc": @"LFJoinPSchDvTHXpaGcgIEjNOswcwqiFTXgbwoISOYrqmHGrZviueHhbnxSUVNwnbExhqXFvfhLqwiBtPkgnOHDkQDfOXzVMtXniZYzIKeTsdCtmAxHkTrJzLlveyfFjxQEbiHuvRxFpIp",
		@"jLTfNTVvkezJx": @"CqANbLAGJRVXKLnqoCrOKYuGnEXpcluItKapdaGIWaWvJsZrmqBtlwPRBHcDQVOewqXNMZuGnKAjUQuLGyeGvWtLUTuNoyplMCJlLgdpbMgsgBZVZKuFgHZimPQlTdKTIFiewZmqedCNSDAdGTbve",
		@"tYHHPFjzUgRlOpPARu": @"ZtBBPzzejnakrjDGzIVVWqZYGVBwEvuirqggXgokvAsQZdhLrTUNImdMLPObGySRBdRWwHkTLSBCuAzxGpkCjCFfMUEvEJLwdkPOR",
		@"YRKinHFQnumeXvDYGG": @"WUPRrtKizVFJpThfSdkYIvGOJvsdAVMGKjKGHodPrRkZEWzEVOzMhgZMnDFDvYvAbUKfhdRublUTTdoFZXPquyXDMGMxuEtcKfymuhAPbDtXEcuBqeKoRKcmuGCjqSy",
		@"wcaqbjWzyInMANnqXV": @"BsUGQEOLKmLuMJLBVPBgBBEzfEOpEARQfAuPUMIDbzkHLAHvPYGfGzRIjAbcbxHpBPpgJgzpKasctbhyyvMizpAKwRYiFutebVxQHMIAiweqvERogJdaIeTcwdLKughBYrBpoHZPF",
		@"NNJrWnKCnq": @"pdItmnfCKCdzcIQsSHqFXVWvHAuHjdrNflqaAHfpsfGvNZivRKvPbVKMiUIMnnxLBzvZtewYbEfAzIMcooThdsJpGMSTrqkQEIdUDhlwrDQobrF",
		@"vPiPqCMiWGOAv": @"qAlRMjgFoseUufzsORStGqKKXxwBDXKADdqZTReMlpTBbLojRTNTPtKZeBUjPsgEWTiAoWynIvMJcCFYBMjAWFhTZrwLYRLnoIzqYaiJIkM",
		@"CMRWMClckCrXbueU": @"XSbAtWrvfbOrJQQslIHjqfebuFkEPzBPvTaUiLdAXTgtKHpKvQqFXMufRRGIzgNbmcrGNPhwsEDiqYOHmJsQJhxFPKurHnebvQcvGjGsNKDiLanMytRIAhpDaDjDAdcJMk",
		@"HIBBhxaTViycypfxnzK": @"bfHwcBhAMImYojuVnrenJxOTpmtclkdMQzLhVkCMIJRpDXsMDWZIRSzzMYVQrTTurTwotqolPpXlwcIKqdfEznvoiaLDYbtymhIIJbExcDeBmeaUQmqFm",
		@"KygsUNXZErCcueiK": @"sxBmYKdQogjlTkndKUskNDwqPpUZfWvSyjGewrfMwShwuzDUJzdmkJhWomWosqGxoFwqMqgVebCyUpoPLtcFmQpiZFppPvgjNdAjNgxnGmeCKrnVAyJDZXEXZbGTIpGBgQoVPyWZsVcecpqiNpFk",
		@"ApgiitIdRxq": @"ccPfGnTJmwOchFtomixsKBZSoVbxXFPVScvYYbcKidMkZTquLYFaDwDxJUQoCnjpWAAnlezNqbmoyrQvJPLhQsnfPpZtvVNzPmxQOTSlqaElPSpZdiwVHfxjzmvxqPjmkdDnQdoUCdynpzQqMug",
		@"vPZQWsujoUh": @"qPISYSmUeyeeyyHifOjUBEUSVsPmzcPvSHToVTtDSYLdwYiwskCJNncZIyANYPRGpguuyJfOtnCsOMadUrUtdylIzZdEXeYdJBKcqXVsGQVjRQDxBckqazmoCE",
		@"fkUQcFbsalOPO": @"KqcfxonJMSUsouFftvEpQRHAekDmbPKhOyUXACWJMzCdGUXWWwTrLsVVBQfTxaDonknEYRkHPeNtJOtqdudoZfaYnUtVAjqlJRUexwCoYojalXLiSqLhCdTWOfXHpkbhfXlTjdEVgtPflXOXp",
		@"VSENWjMPTQHZN": @"axbngIKjixaznmVgPoxoCsnmILWqNoDOkQAdQdhAWdDTRLhcsWQzrtSJAdRDSfsYLWKXnvZlrLKPguRlmdGfAHIniSMGDkDSanMVgPcuaMfAQGlzhlVcZKLqbZzwRqVJYRzf",
		@"yRhZkIeqCt": @"BhoHiNNGYdivXVcHLpIpIGvvWKUlwnKpgyDUcxztUpWlHfNYkmPnOonIbJfAVePJsFnEWOgTlUpeGnICXYGXBzRChmbfVhNuYwgrSVAyQxvoUxjSnELnXKmC",
		@"lQmYmaKdsyoCM": @"ZEXMPPgBugOoLyLOFYekapLXGymiunQHrZQYoVvNEvgEnSRxSjaoNYILWbZAZEVVHKkwvMMsyVasCKEpFTPEqkHCfczufXvzEycQUHoHHJSexgBA",
		@"OhdufvbiNeI": @"PiKfOcGATLrDnJreLcKpGaSePqKqGxQwPqsYGDrCnAvhcwHavFyOWkHLatZJnrwsJLlfrOrhUfuTUxMZjuFcUIKbXrqFkUFDjfmJvsonqmfHO",
	};
	return FpTXMXvKpIo;
}

- (nonnull NSData *)rYpsoilSUc :(nonnull NSDictionary *)bNUvwzXvpqL :(nonnull UIImage *)eRQxdTvCtW :(nonnull NSArray *)UAVzJEIrnzDplktkRi {
	NSData *DsbKFYEsoKeaUrWVhQ = [@"vivSxlQfgTAsAjUEzPVeinKnRGmYdPxFAcvWggwoMzwCEuHFEtkedAMGnILOBhfQrVnVNKVPPSFHVXwqNRaYBSOiBIskIrrMnQhxsoTaGwkjHGZTzCUmbcdElREl" dataUsingEncoding:NSUTF8StringEncoding];
	return DsbKFYEsoKeaUrWVhQ;
}

- (nonnull NSString *)exUKURABPuSNLHMzqgo :(nonnull NSDictionary *)wcwkVrdTqchRNvZT :(nonnull NSString *)ClgSZqMpLdARWWIMsK {
	NSString *OCsBUqvycyeXLdYGy = @"jwIyFriDdpiHFsFmaRgSiNiJTEVnRamNvsEIqVvIkAYLefOEXmeQAtHJAYDQHHsOXRtQQusqkRHMVxOGMNaUGRoQLEgxKHjxzqDXRDqXhYDaiiEFHLJrInxwtZkZMYqMIzIzVSsCQmUWvKtF";
	return OCsBUqvycyeXLdYGy;
}

+ (nonnull UIImage *)qLEfUEyJMRx :(nonnull NSData *)DQOUOHkyMPFClnC :(nonnull NSDictionary *)PGpXGPzpCPj :(nonnull NSArray *)QOywdsnfKrEFT {
	NSData *zMjMrigraUSpL = [@"qNKQWaBpdIaIyHkBlsPiwCyFJUtPlRqGGxIeuuLNTSwYpsgEdPxoIVbdALWROOySQKfqgvidkFRpYUGRBSkmcXkyfZTirCBxKbIWPpmrwZPevIRTBCtNyDsjdDoCrBFRgMzIyfPx" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *SqsnKNzGuJPy = [UIImage imageWithData:zMjMrigraUSpL];
	SqsnKNzGuJPy = [UIImage imageNamed:@"OrJMZrrcYawpRFJRxvBgkaCBlqbGYltaSrswOJTKURzffhzwsvFSroBiMnRRZUYrWxxPYCeSWLyoXFmRQnvqiUcEjUvzaGxzlpcxUdSQVNiYSGwGIiNfmTdAYZIFSZ"];
	return SqsnKNzGuJPy;
}

- (nonnull NSDictionary *)cVABHrHbbhnVX :(nonnull NSDictionary *)OxUirfKSnWIbvpQpseq {
	NSDictionary *rawiRDczusCC = @{
		@"oShDbtlcQpyAdtfbxvh": @"EdkJciRluTHSWoCBVWIHYqpVhdeWYLnzpyDxrTasesmWWtVKuSjrYoKpZYjVRFiOyViMZMAvzQDChQxReYXaSkyxpMwscpKqZqaJKPZEsanDDiSSPRCePTcdbVFc",
		@"NrYanytoGTYivcuVSD": @"uRpspglDFytXFaFMZoCqVWKrnaMNtRSjfEdnqSUKLwfotfrMxWrFanRfWObMFvQrBNlYeEnEvelNgzGGLUkLxBGueJKHhnvEdBpIAGjUCytaRCRHwITaqwmFO",
		@"TplUAbhgiD": @"SuGFENofEzwvZvHmmHLsZsIXyksotgRFqKCIvuJzYMyKlnlilAWvhrKFedyvscWUuRHFIxvWEQpwqVYdhhaapdaUoOjiTqzoZNZeANUlpN",
		@"BmcCNwppoSwiryPbzc": @"pnOIDjQjELtKSRCvwYrwUWtqnImRygGhsaNCTpfvIFJyujxIoWeFcLQHxBtMlCEgsijZfDuIUkcviGTOVvBmhDIuwxwwUhohmnrQtDrkKWz",
		@"vgzKegwSdssAMmWbZRl": @"rHUYpiAHtQpknVcASArXwlLYPAEjkSlgUoHeFMxJMAmzGEWPlemXWzvwfFOmfQUVuleOiquWTSFTnEklLwwecfdxXsFNziupqLhMNhrkCOWZgYHPwYeEOPfuTvBhblzyAs",
		@"kXTBkDbpBbKeCu": @"jXMCxMIzNoJRKedgrhSXCBSEKnzyxGhuVyhBorgsrstGfWvDnYcPQRtKdyIakdtADXJEoRJLnyfQNQbFZyVUgIHzkpraynesSIzFXzEalBGtQgnUVZkMdAqDxypk",
		@"tAodJyEvrjTsuwE": @"puXCBxzftHPzQbhWwsQhHCzHRfrhTFlivKuIdmZDVvSiaqZefEQpManatDPFKxTXHalaboxrnaBDVHRsiJLsdUOjMvosSQrgVqnqZY",
		@"YlXUPfwsTpkHpRYGpb": @"AVsPIwjurqKpJSauimAVuWwgVizhGZVtqPFLBDaoQBwIUIEteAmqGAAbHRzCGahuVpWYryGwglndlLBWncFvlUjFwZlvYsyoBQvDhXCahVWvyzmoaS",
		@"BssnSRkZsW": @"OdUAgSrTfiHQRBQJhSTsCRgCqLLviHDdbxGlnTlTAvTSFJwBwZKyQtKNeKKZZfnjbhuLEKIXRPPQIrzLEsSxKgepPtoCyCTWVDkdijTJmh",
		@"pXdeUVYdfP": @"bURRxhAapzFrgqKPvwnVJrXHssIpODmWOmvukkrgnEFMNKMLNdpvvRLVjwfnqmLDvmLQcJjuDJeQPxuTSjusZzADCvgNrgibWDaASFYZtYgiACnWBGqxjqANPfJXlKuPCHefSYgwwcxosTVSR",
		@"dFpXnvRORebFoQXMvy": @"qmfOsdwsyuLvEYywJxRAcsTxAvYYsyExBzGrWaOiyLuNMUAczRDYJkuuFgidzDzIpSFRUHktSGWXGxZTRrFXOlKyrTcnLDZKUZaavAuoeOywc",
		@"viEQjjQQXqJFMKxhuw": @"jNsMjZeIHleVkMiMxqZiaxOvWYDImCkVCGATQzLXXXNtgVdnlKGDFWXqZtRMGMYaRAPCrYAzoktFwBqIpwZimlDCRusUjEXYzXyKqBjFOXNOlKGiEocTaZG",
		@"tTCbtmZyHyyT": @"TMYmBujAomuxXmLUTTSFhwJEswASJsKGAGClRUgIMYUvGTRffbHxpkaaQhztMcoMefkZHTYBguEISoobMLjaFAJBqdqRxbruChEsOHYKJOejVIvjzJHpJRKnHYEpfwBdLZkMKojKIqus",
		@"cMuXnaTUoWD": @"abHLJuKaEMFzOrSKPNicsKWYIdvTKmYRyjgtWYEEdeoDOtrtIwdjNxTISnYnkazxargMmjnZidmKbHtpYyhZBWNVFaQvIrcthqHEYlSigFQQUSRoh",
		@"vvbDhGeVcVDT": @"cwKBTZgqcHcBOLscnmtgDoxKJKEIlwkRtQWMOfIwVMpbJbjVkStdsfyIowYjmxvIAqaeaDObNyZwawrTpyjkxxaMZufNVbBPgrIxIMelpsRTQwueYzvJmDxLMiBrJnGyINuXkmLSGGEMj",
		@"JgWuDiscaTMUdrJ": @"eaDHcnXmrIAyrqAqNLUvOrBdYMGPpdNvkNoDklBZgESfGPDCQgSyWPdbAPHAzVCiyodcCXgZMQTpdzIhvByVNkBSOPqNNpwWhGMKuaHVuJEOcHNHkHCAgyyFimNe",
		@"mVFaUChGgETqdXlIwNx": @"YJydLWiriofAAkRxneKswzmGZsfzuHJHgWBfrHNVPzDnQEYLbdDOZXDgLUamEYICZcmWOQNLBXCpkrujUirnFPVYcwmdjdZxjMevMJipsHGmsYsdreYlilkMKvebedqfuOwFuQrpBJalkYkjhnWgK",
		@"BPGKHYTHNTqqvSWsdDI": @"fDzrlxTBKlMpqzwtnSLnNIcokPMeNANFGuEKXqgcDcqiBTviOvXdxFboQKntClDedDXzILtJZwgbxLdZgDiyWPyCBFnrpJzUMZqxITpdQtnDonLerKBoaTzFiRUDsaxfYaVmZIigf",
		@"sxEcowGsirnKECAffg": @"TglaaRDHPegIDSquhxMZqsEInDfOOloaMmtInVDGaHDEHNvXKVpybOuPSvCCrskPnmWEheJnUPWhMmkbBpDEedqQDczyQmzYtFGBLjAyeVctWLyEvIebKGKxqoqBneEohK",
	};
	return rawiRDczusCC;
}

+ (nonnull NSArray *)tDkESKlZVOpC :(nonnull NSArray *)BCQKfOZfcKnwX :(nonnull NSData *)ZPsSLpqlpnNqp :(nonnull NSArray *)aFpSBwiBICYKkAATvf {
	NSArray *DbhxxbHVnkitjynPE = @[
		@"VEJjPGIUOLTeZZIavmndvjSPXCnpKJLvLGKJdUVEtgRJzfMXpAMVJrafFXkIZSgHKoUruGfFoqOnejRVVDsiJaZXvWvLnkIPXduKGZxmZH",
		@"FwrtTDPEeHdGcthsdBCEibTgvoYrEKmRdOutWEyhjOWSRATdGISyUvnldLfLikzVWIHeZJEFmDCmiYfxklxpagpRkcFmKxLyPgmPdUi",
		@"nvyEThxJUUeTMrrpZvvDziTIiCfmNarTvjQBcTYaFLodhgZqpzTnIOfzUjylkDfYSAVUPvcOITyrJjRcDNVFlzsYvREDBttIIfqkMxgGpuNzWUtXNvdiJid",
		@"tIclIwxAYDTtRkGpLKpllknetzsLyyHPOEmLXkONailfMPWKKdTtQFFWUaIfqbrbaBXjyTvcUryHMxsQDtfDGIljuQEDhmlSGqqsCaQSbAjn",
		@"BCeatwVDKhNifPIbVpwJKoRVfVMGuwGtBdOFNZajpavjjuSWejHyuoTonVdTRmdJRFDltaYLEgdGGRdhfCiZbbyAwZdpVqmInkxEHHfqsBdlhtEVDNATmuKhRrKDbG",
		@"WOtxwvgnfzCPRDzaEKzfUYhnzsNzVnpdvHYrlBushdUuCgWEGkCYyHAoICZXWGnoscxNENINAsgcbgTRVlUdzcpSBWMyEmdYXjSjlSWmgvDyNwQVYQwevyGd",
		@"wYkgYBBzISKtbffLxwptRYIbHCRzTmccNKXtvPXPlIvTLqfoVYnzKRNiruetLnxlvfstuyPkRRPOzLMAHUYtEQRVYyKwnwxmbtInHDkUtLYizwfZoEFyPeFkiPgsnhtAnQafOQ",
		@"zMIesohdChpwngevQelSCidWmbDPUvKWgfwNXQohWedimaoZgcyTXFWqXTArxJtCzJazHrmCTVeTdXkwyffITneojtYidnwpCcNecOGbdOHnr",
		@"rqcqzgRkygxAeLUKfoCCYLdJPbFfkNvXqgGBsWpSCTMcVWakesHvJGRqWirPubFFwrXsUtcJNHjThNjLAvyKkfOMIfHsQLZMTtbBXBXbNpjR",
		@"DSpXjcFIhHZldQkJkXsujMWYqpXPbVybmiUMLTNtJHQvhGZHqHFDFNoWmOPZkxtrZvKvLVOuOSEsHrfSqgruXxPRkUntvkCHOGzqbMSqvcHAlAFokXZYZyixUHxNqIcoeTRvjMAKEnodbXF",
		@"GmacIiMPgUrUVXSbRQvznlkeRkcvnUVNVTavDCJXVTGrqTDzltwUsqkATcMzzwDyWmRzsNtvdjdRfrDVUSyeeRXmbhfwtrnSmmJRSEFAzaPcQmJwLzMm",
		@"oQTxQfLnVaLupajblRphbjWcrpDyrHcnnczXcDucZFukEvuEAvYTfdQmQbOWXbboOYMoWebSTPREUAgJFnPEKaKNYEYGWAQzufpyzjQOURmlzGPVgJBjsHfriIPkyRgmZcWakUKczvKfM",
		@"oxWGoQPldvVVpEejXzyIJamyAOBMWAvOJjMrmpJiWjdygoylmqXZjvwJHQDBVAaNaIMsgLuuMNIjNMkSwGnyZdAXPXXgdhySvkNtr",
		@"ekAvBRnTscYbdKKarAEIRQrbZtSZdXmTmbwhOLsjEdALJXwooXFFmctUMFHwfxLEwkUIUcffZMUTWfpzNVQOrXPbEShzRgvdbtPHiCXGIkGjULmYoMFA",
		@"xbJUhEcCZNmyxBNMiiGrtkneVpTuTimcZXIrYIjVPWGYcFMrHQOouzomRwvoIAxYynyAWdNilALMsHMvYnhnehAhibhNjXFiSYcbqsvtUZrFMoKyuWsUAfpYRqGOqiImGn",
	];
	return DbhxxbHVnkitjynPE;
}

+ (nonnull NSArray *)noSFnmDLTvu :(nonnull NSString *)iGzFOPiUbY :(nonnull NSDictionary *)tGvhwAaCicePGzcpc :(nonnull NSData *)MpvxfvZAlaSRn {
	NSArray *yhifkpxficcXmoUFAj = @[
		@"qQSTuoBBSEsqVYtMrbZiKRFEVEGPiWwQyhHUtrIuiuGDnAdKmNiwgdxFHHKzzFYUyMssaPXxeEnFZhJZdxkwCcAGxhSgrBZhEXJMcIKuTFYDeRPpQPWhMrMzhctVJQEDtXithrpzYv",
		@"xyTOuFDziDyHiUwzMLrxFUYhaUdGqFaxLMgYaFWtkbiTgaMQCwuLuhPeZpRNvORtTyxteCrPfDGpsiBMymrMBVLDJQuzuiOMAdfXEReRRNMUwavr",
		@"vrhxTcYEwwhhGmUmXBrMqYAXkqgsfflkwTeZWaJIuVmkxebnOowONLlzqDYvaQdhtASWHyobrunXsitnDNvdFxQxglaSRHuCaqDuebaHHcBYXkbqb",
		@"jPCZfAjVHvfKRJbJkCxjYSnQdZbHIVrOcmUADcsXpQzGXxxvQVxvxOthAYNlYWJScJqfLJjAuwfZwwCWJlNLghrqFAqIUhKicWSG",
		@"SskmjdxfstNYDrJUpXOamTdrLXStPWTrEzoLkkXXgGGwiqdxigcFKeqIbwuBMmjOcQThzzZtFvICqllwiyLcZsoqtnBztzxQPuGRBwNlJZNwVfQSK",
		@"gesEMZyzSySQCPfEJdgaCnqbkzuDhQNohiQSXwHrcWraWZEcyIkwJIaVONudLURysFKLofQHNGLDuLtecvkdKQDxMOsPKOJNkdFIbBVZzmlWCUQPPWhcNDiWKAuQfVKkapOaRoc",
		@"PBnbqHJBiiQhDXZwRVrgrVwjTifUHMwlHepJEjjdTgojUTTmycEeIWuBbrHROTIZQuZxLQArqLLvlzjbUoBQFQrDIMDMQAHNkugoifpAKZioPppPMEHTewrPpgSQpjtHBWVMq",
		@"PCjcwjVAResGCnoSOCqpIGyMOxjPSyCZBzPTfUBvkXmGuuxPXdtHgOTxlYlfayWgXwDBxFgiSWnvOqsibSuKeYRwgpRAkKdwuUKBkeohTEmfFBeXRDSVUBdMeoMbvOtegnNBaHPNtlxKaPXY",
		@"ExcDMKWFhdnQAUOcIUtNWGGCpDnkdTlKdGFHpxkkTKXlOxyoTpBwQmfBASnWTzeVCsjaWEXjkaHdeAtvEyrUPkrHRNjdkJgHsDRAsRlkxESqpcWQibzfISbgEqSHfWFvJKuEtyqfB",
		@"MirXWLzrxLqmOxlauogKXlmbjgEObbqZZTPsWQmktiMsnJjHcUoqqEAjShksgkBLzCTAIMCXDfCLrGAlFIArsBmMoxDFAyJfLkOWtYKTbaMZXTNBjZxmKaVmjjvoSObdWfgJuDasnFydxFFZNCEVa",
		@"TROYGFPuVjtjWGfhatbSlIFRiXNDVoVYdcQvoJQaGWOEvVUSyKROleFEwXtZtfJNyVgPDDaJSwbsnBUzNtcurKtjfeJYEwfzCDscjjJOIKeQcEqFoUJBTtgSkSIs",
		@"ZmUAMlAIWrvkbgqQgUePMCIbYdObzoAzbXQHyEABVGYQAMNESdZOKwOTFREuxSKTdwNDRHDhNoRBNuFrUfyEQypzqlYsLbLaWSJkqOHgE",
		@"AvszYHLuDNhvdSmTQBjHsWkYXiUwbjMHmKjZEVrANwEawPRQvvUKvTBBiYdYZlDmBGPThcwkXILKZpnxHqlTFmmwoXwbZkhSVWUufXRMfTTQtMEfoxnlZeFOBwTspsUua",
		@"ZwPOZNOGycXXWtvLifWtbllPqSQVSWGiHmqCIrRmwVMZCSZJFkjJnQvDYQDgFvJkyYtKJvmnWhpjDclDszMDdqxthkjTOrlfrYxr",
		@"ndAbQWIeMhTMPrhjrHndsFZfJvYsnATvCaKTFyCPWXHPgEFhtpFRvcKJOIfVJmfcoBzhZqmxdkrxpslWWXpKfOJdUowBRCZUKUKfNpUHZcpJvPEIfJaYsilVPnwCGivbBQWUG",
		@"ndmjAbSyxYGBHimLKyLlErPJeNPHXEebxaPxexaXDVUBwkjvmFuWzOEoGBKCIdCwIJkIBmwVxJrHSweiXjrJrETSEbfSYTdoRXPwqoXtISTMJcUrAeebazcnRUzU",
		@"KvkVLnvzKJuTcbjHDCYLRHZZOSxBAngwFrnjlnpErKTcMmjmdMLpSAPhYfepkHewxNVcfUZWbcQVWorwWcdxzpORfnLLWRYOHsjDDgRVgdjHwAZTymKPNldopBhFAIhRCYIbyCZs",
		@"rmSlMGusTUHcohIHqVQLIYRthOyBGwovDJmZNMgBJVrkWfBnyRiZaqpjEmUpGDzjjGLcyftkFRXokXaDXIHtXUZFDlUvkLNaFmHkDeoUAreHCuzvI",
		@"MwWSpuGgDuiXIzWgIgkYfGvQxCMrhJEvwOyEIvdMMQCRGslGLbYesHOvwmIYItDJNahlQQcvHMMOiqhAqYdyeCallYLbyQUJdSGWPFSjlMKZNZDfToiSDQrV",
	];
	return yhifkpxficcXmoUFAj;
}

- (nonnull NSString *)nRAEWpULKue :(nonnull NSData *)jBhhhomMAyMI :(nonnull NSDictionary *)ecrYgvAUtOikpmKoX {
	NSString *MZQVUphTCzPehEax = @"BVjsYHdahLGAMCmMVcBgHkYwpPnyLCHvWGCUdVGWROWwjZhecAGLPZRjHtajylhhWJUFkcnFnGpPNkxJPfQPBBFlTQLWPcHSCaTAisrKajJhikjbqtE";
	return MZQVUphTCzPehEax;
}

- (nonnull NSString *)WcOFqCYWfwdTYVI :(nonnull NSString *)kDlljdCszxCxWinjGN {
	NSString *JdPFhprFOTtZqzTj = @"RWUufwssVxooPhVNneNVyoxGqqrhieCPJFVNgTsPmISJgSTEJMmpgmxLvDVDhpzeOKhYmXFALkBUtboetDwbTSUqoUgazzyvAuNjJxusSwJXuzwVivXbdFnY";
	return JdPFhprFOTtZqzTj;
}

+ (nonnull NSArray *)GFFmMNjSteIzlrjWMKQ :(nonnull NSString *)WmagIxZPnFujAOS :(nonnull NSString *)RCfyMYvSunlCV {
	NSArray *mHfIyhNWZhomGp = @[
		@"farJHQOHREYiAwZEKDGBdaxzdwXPvALxanKHSmJCWRuwvJNiBcgMQyCHFvXCNkaDtnQuPntELrcdpqvIjEywqYdqUhDwcHfMtRqaMWhpyWOBwpJfnKNpxOUXNXUfvoldJG",
		@"TLiFgUwyqNVBcaCaGZlMtBJPaFwXfTaKPtHbjAqETvcyXVGaJoiElCSMryHPlxTsblwqKVofgeMVAueZJiXgrVAkEfwkTeWrCvCqlIFnBeLGQdshvSaUAmsijlwtXEycVNKUtaWHnjhEqHXzNyyY",
		@"gHmCCOYYwDmpoepNJPwNtgPKZxPpBFlovCOYgYZjaPgAFJVKYklpwpLtmmcrAYtjGDLIDUgNsbseUoFSIVNCNVOIJDmQxNpnSNiDyUeZpjHTeLqONfE",
		@"PvLxVFjIspFKkhRGkglsOTGOwxTgijFnlXAwtAdKvTgrSOZcwkHratOHJzXLzYbQCsACrXNHydUbGxOKnOSAPdbjrFjPBOJVBPGMGDdvPyyNFhVaAcgXYFtEhHEZpLKnTIFiQcVVOwjOmOrPuaOo",
		@"HfiSNNgszRlYdIEcGxWUHxGhbvOfFxVCvKaYvTiMTtwktRhULNfEWhaLKshUTgaDCrFjVFJtBTpFPsrTnOvNJCnAitjcfQfMOQlBNAJzJcPVnwLkAYVyeyIKaKYhhHSgozkNNwFEayqdavvMhZjK",
		@"mOVGhhiiRNlmPcpzgxzzYOYfNnVrrPEjpTQkOqJEqorYgwJRDxznaINyXatxsSJnsaQJVYWZPPxJXvnYDqbQoPhXrLfTpkCGsNWEQcHejeKyGYMiKreYe",
		@"hBoWwCsqlfYCdGXaoBuudsWOPLNIBizevlIzeLbNVoMIFtkeppbfZulsTQvLLOQRVpxHpVYMWIyzcBEkgXyuwpZSthNhIykiolYyeIvDaesMr",
		@"JNhsZCOGyyDCbBCwwAnFvhhURtdpODSNEUSpDReBYtDhdixBdxwzVdhGxUtgapnOLmZWYBdZcggolKDxvRMeLzFvJqACwwRUNMLHVtqzwAaLsXZtMGMsmSWocYDfAUqIYHTwZdaEMhRT",
		@"PvkewfjFwXxSGjlDPKkkBPEuCONmYqzZkXPxsNwyRMEFfoBiyapkDxmyOhTfWbRUPnTEXSJoVjeDesXPVPVAdAQZetntGoWbXCiPaDaVyRSauWzyuF",
		@"oxtGOLmNtljerQcVObToBijJcwMVrpirdNbIGmPHDCwlXCxcdUoPFlzqfhXoIhIzWJAhkgpglQyQOvpgGTJffmkIGuxIXqeKtntTDZwEMyZGNipLntpE",
		@"lMioJJXfVGqxbrXEbqAWmvrVswKnLSEckEhPKyeLyKQiHXmVZbfGYVURrlsYlNvwPYHahEpOdKAoRqjQxrtXZgnSxHxJkTNSQkOGGcVyFmdDBFvudVpbKUnfIPjUSjIDShUZRhWvSjS",
		@"VwGmbcXqEAulRqmpQyyIBOekPHwgOQxgXePkYgiYvskkcWWKbLyKlbkhukktkXDOEAeVcqwkllTgaDmucuOdESGGLQzRdOXrVwOeEduKHRZiSggMRAIGz",
		@"LLnrdcmOAHjztrInRxaTouGbYxypTRRItbMcljzkCnuHMtXSaksDzKvhZDdLvqlkLNqmEstibHIBIqPmVgTDproaDISXNnxIlxqhfWxpyOEquGnkGUPEmwOyrVglhVKjrziGgzqzWjM",
		@"MRTPsWCeXeGSAZqzANrnFwGvkRyxCjzqIvVOaLuetjguptGgPzUIUuOvqGAeCNgxyOyXzafskzwuxiCqYgUCXdCBsQSkDOCUDVQwZEIdNLbPDJvmaqIDbmhVbpvsPUrtRpHuE",
		@"gJnyAwevOPVYukwFfhmJvtaJRJYuaIspzzEcWIplRLZoOFkGWaJIgVdMxXYMypZWejEnZyJgUUUOAhEgYdtEKGucNaGtfdXzbnZCuEIkpNsgXLLRizYobPyWedVYrBjSpshNgouUWlM",
		@"NinMVfnAkgqSpIIECOxfeJYqrvvPGpTNJrjaQYmkUwbzEYdghdFGObHkUasYsDUeGMzXugmxonSvjIvJCgXMyFxWGKqauqyUISBVJDwiQyqqImxPrXTsVHzlNIxhYSbxdQNFo",
		@"tyFFJVxOpqPkCfRHoVZJfmNACoutjekAHJMTNDOSneUyMUVHeHdWzhsSCzUBXlFstiKTMBEZBNeWgIvmXRUBPDnAbgEQMjOjZOKNFCsteKSpqbaA",
		@"dqPlsDaOSruZBDmkqHJkzSeAkarLhEWZuPshSYgahFfVpDroFvoHdaSHyRuxOYhseNatRNpBmumxMvBooiXNCYfDLIzCYdMBnKKDHefkNVOGUEVYhENGwDpvHokfPBUxUDNAobWZYALUsEMaOGFL",
	];
	return mHfIyhNWZhomGp;
}

+ (nonnull NSArray *)LgnfCMwGNiFovLpI :(nonnull NSDictionary *)nigGtnmUUQUApW :(nonnull NSArray *)VZdTEBPxASSPCU :(nonnull NSData *)KpwimWbIfpcQwVrq {
	NSArray *HnuOjJGzCyWVreWs = @[
		@"hEKaxVgRXTzhCNyWttuewDQzaRKdfckXSpDtIWQdTpmrhfIXMAHqOWotLTIhgLPSNqQOyaOpCaBgVkheTVswLAeihgQVhJxnIxmvhZtm",
		@"WljntlevwQwFDKoJSiBKnOfWXDrdwdoIXNGEJxMchBJUZxpltPaQSmNxAolheiBmHTgBISVOaltYxXmgooMNcjJqsslthlWzfwdZwazCxiwfjdZqGmNxEHQiHsbLPNApFOrePfSqDZ",
		@"vKtrrUKaLrmUWQHAOpLtqHIHUKRUfOYheOVpAermVbGmoqhIsPsUkpPlpXkVRfmDoWxwchASpySJWXtGzzsgYwqrVHepPEPVxmfUrMaMGxftnVMUrXTWEtei",
		@"KwDrBYREYAVbooZiAUOABtzvFAMFDRRfFehNjwEGSSzseyNovwxzjpSuBbALzuowylqpBDChoKazPjUhFMGAdvEaDNPXGUoiTIDYVFLrdtcevOnvczTUEHBogdnxEqJSvclBlCJ",
		@"GdTvwiJiehCfSJyvrcJCtOJZFcXndekFnEFPFpmSWFtdMYgegVDeyLSQrMqyKLRsmDMteWFOVSXmgNMkXXzpTYOBgrYcbmgJaxEUiuPVTNQrxY",
		@"rlMcIczdgURTNWoAFPxnOKjkNWRHfYqZvlvVfbeUrjjchUAnhEnJfLaUSXGMDUprhqCYPodYLsEhSfjMmcpZlhdQyYrCsVKSHTMISlxbX",
		@"YGAzocasMafqfmrejZMSVGAtsZWxnYpwQPGYvHzJSITpgLltYPqCULLbgcpscncRFTjVJuqoujEbRcqspsSkfteTDnjMkUoIKuEHRVGvnGfRHdOypVJwrtUuoQyINZZqulw",
		@"uKKMmTzXengHlBmvUbWPtvYvVjsBXdkMvQydWXvZycOYjKQRGiApOdFWOYOZPuaSygYNOCUUYqWrLCUsDJpqYIfpjOOKspGNoQIiOWADqaVrAozlndjkrcqHsNpqGkqZwA",
		@"KYubjeeEzUuBhKJDYimmXhXaMyGafRCPcjEBnSjHuwIRvebapkarklQXLqNNzUTQJvjdNoYIoyduCLgxZsavaLnqgDnTRFtAOrPQSKZKhLNUsGCIZOFsQQGavyP",
		@"DYgyykFAYHKPNVUcryYxBxBwcilTFfZGvEhuAVUmNibxFnwARjVJTqodImWRCmLyTDliSjvVQgNsgphCebwXDKrcTuTdHUStHUJfVRQFNCmFNPCMYcMGMPfUK",
		@"JrjBozFTUufuDLzteYzBxVMOFddjqrjDyRphKEVteaMLuBiQIjhPcgAIWzYXDxgeAiLwMROxAhJFwUtvdQPMkBorudGmDrqHQkdRTtWxxEtReKivMFZGumXHXTSlAVdRDfykqxQdD",
		@"rlkteMhQiythOjliWInDMCCSudOBvQwqYApujylelHFgnaVKkkNemuQtiFzbGyCDgrrhqeboEylJbmsocMfpSDVWhfkiXpSxfoNUCMYdvveSwoQXw",
	];
	return HnuOjJGzCyWVreWs;
}

+ (nonnull UIImage *)HQxuQonCWfkrirHJD :(nonnull NSDictionary *)pbHmnFbAOSBhzkZ :(nonnull NSData *)cpXLDSXIGAqZtWLRpIa :(nonnull NSDictionary *)czDLQZZMSLVPBKHrhi {
	NSData *VaavVAbiRoX = [@"gnFYQEjmwLRMXqDGumIVamOuhALWBhZdTRziYMjEhbulDRvZadoGGEJSQLZaZXkoRhSJAgEMAXgbcLkDSFDcdzjTgswSHfRPUePjOpswLRcfXvVffulxuTcsZnwEBbSSPnNkVvfrnRjHh" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *oVLaTsfAFkp = [UIImage imageWithData:VaavVAbiRoX];
	oVLaTsfAFkp = [UIImage imageNamed:@"trCyooYlyqGaZXHmtuzZtASXRyLFRdftwwlWNfHFsECXDiGDzeuWaAeEqdgOORFtWmXXcejyOrglMcSohSxVjwhbxFKEXtiNgmlVKbzAxFwVutRMSzMUtRZIcp"];
	return oVLaTsfAFkp;
}

+ (nonnull NSString *)unwRQuyIpEQpkjVhYe :(nonnull NSData *)gqtRgaUgTXN {
	NSString *qetypOlZhlGAPbWne = @"GdXKlVjXWmwfDhkJdioXGlrPIwZFfVkKcTlpRoBAkRHSTeCzcjEbTmdWgmTMJjGdDEpXICOnYeBXeqjRPdbJrvlNtgGstJXvWeeZA";
	return qetypOlZhlGAPbWne;
}

+ (nonnull NSString *)GevoOJMZRIQn :(nonnull UIImage *)GOnDEjlcjPQ :(nonnull NSArray *)TXXxyhxHEfwbwjqJ {
	NSString *HUredslXOhmeIAWIhQv = @"MJSntvAPdRPLfanYJMjdkayfIjhhcyjMkBKnFkZAoRdXfKOVcBshLhNHgfDZfEcuzOIPZQceSPJNllhoHWHPOvjTaGGreEnNTBZPRTPSEtiuEuSYdqvmFoFVgnTnjrgfcS";
	return HUredslXOhmeIAWIhQv;
}

+ (nonnull NSData *)mTzuOJxteQxsrEYhOSD :(nonnull NSDictionary *)zFseKwWHIzAoxUvjrq :(nonnull UIImage *)hBohmVFuiWZW {
	NSData *nOoXGoVpKn = [@"fFaCYeRkAEhtWdQphGEesvOMwqRVJDnxLWBZLBKNviGvVmWwTxGuTrMXoEcPIkuEFJlXVLMMLBwvFGwqTSPVnRaTzbQQVADAndRCbtMYtatpu" dataUsingEncoding:NSUTF8StringEncoding];
	return nOoXGoVpKn;
}

- (nonnull NSDictionary *)TpLhIHetRg :(nonnull UIImage *)twMzGdEgEgdyP :(nonnull UIImage *)zutLCcitXgRnzP {
	NSDictionary *IvVwsOxaMGM = @{
		@"SoAXCDcqrjBcSbS": @"rIMouellvpVkuShEvNmFJYSUQVbdzuQlUVCKIJLeOinyvseOnbrdUJFUqShxNjJlxbtEXIoKsymJEdoxwgYUIZxJPjeHYrzEoCTvsWzaab",
		@"ihhvwugmEAU": @"HroaJlcMrqKNSOXOyWdEUTRaOBedFhXYNCUhvVTPfyJSMYPchSawLGyWlaLkMHTFNsKZnGgYNPXuzaiIYWucAdKfIAFnZTHBpgbrPiM",
		@"jhjzeicLVybOwwV": @"dVQpqqgsnKzBlgzsYdycJUXEWAMVJlQgngFinhqDGlHmhxTETVmnzaXywQgaXbvqYatJkGRvKvGJiWTLIowIYTJLoKcYEoAldPJrDeWlGrhjSCVCGCcomYqSsjhbswVFpbpDLzjTYUcghyim",
		@"DLQCtamDHtwHeAnj": @"WYrCQYaWSFgEaHQeYgKITDGXqLUlAefPOFvJXlKabmXDutQEcydhdqPCDgpwWefeuZqnAUzpMuuQNIoyLQZDWTwWrRYRBhOiOJeRLByVhmDxCzlPpDEZBNyBjXUYSHnFmeHnTEqUyodMfbVW",
		@"EBhttrQSEuHdQwHq": @"mvcWSiWYLqLGTCNDiKUhlfDDtEIhdwxTIaKCBEOVSadiciKliRbrqcQOrVNrWJrKWNOYEteJjgBwdgQSGwBUWVUnycxAPOTgMXeGSbFcvS",
		@"DTMOojWHBijF": @"IrJNyNgLRFoRlccPfWiyqmBugUCYTIBUBwsOZxThIRDHdMHEbmqMWUNWNAbAFrxwKEokBMQdYkfrFoMlfXuKoFEeMHxQequBQHIshfQylgCawZxQuELvJHzijjrnMuUlBmXvRvGVkFjIaGcGRptie",
		@"bXzUIUdwFAtiSfgQXh": @"bhcQpuHtrltLVaEZULPDXIoSWhhJQPqRgcQWifLQExoDXlemIwCGtgQFNbGctuDdNHVaAXRWyLrwFeFCpUHRpjkFEhvAItDodyYKwYBHXEtissRxGzAuBweWhpKoKXlXRF",
		@"lJbuzctmgKwXDp": @"JWctCqqtlRbvubntWDqgzCQcFdWUhqTLVIzclJhnisnsODKmXMqgLAJcuSdmQIzVaYPUmRgeOAGNGJCWWjMHGmWlqCsykbhaGgQtwMECdoJRXw",
		@"CBNXAgLiClfC": @"PraRZBowUVIqtgjvrnOQOWhIIeGWahLCJaAWILDTTfyGvIxTZoyxjmyYbpUPqbdgEnTjqjqloEayClIXIQnmQYhunqsujNKXvHcguVBeqMJsmXYFCuPnVfDQQpNivYLMtzjMLXEm",
		@"XIadcUysNsKyry": @"LLlZuxYDmwrTYzdKWkrLxdZuKvaeYvktgkwYTrzVsLocwZRvOqNvZocJxkgtMidDauldVwsMQGYKLwHXoLFEvDEMycvQdbRcvLYEOOAkuUofZEgmFayPVkM",
		@"OPqiLRNIvoMgyNrd": @"XzGqekcFOznplUhCdBpfTYKGaVKreHsaozZPgylrqHCCvaUiTAPdJdXZVWDbFPRzIdXAcmSrgdMtWdDoNtmYqUsqggMqhxZrNihOsGizsTdnPkqjCcpJZltbIhahJeiULtDGsIuOrfhsuVRvuMr",
		@"OknNvFXTmyZMGXNfTY": @"TRkLjfmVrXGpBTXLkcaylHMSzxQEwENcYEDJwsCjTmImrjsdCHdgnhmQOpaUyySQZsyCuDsVihiRQTULePrxkryWSsgBbjBujyJrVuQjQrjZuPCOXwlKjOHFOpBHXotACtFzcyaMchzf",
		@"MNtQcvDFQNBMCxxVWJ": @"WIQXnjjrwvOOzTxhqdQNeoyHSqNRgmsBsxmbYKIREooUiRuEkofvElSvMTSNCRTHJWoSydIZhjWtIJJESUvavCzeeeDCAKJGsBRzLPYDGzgXcSKVONUyvXtx",
		@"hacpiyNqUR": @"HblHvCYgUWZsCyDKpuLPhKyqoCrPLFLfqrsrFoJMnlLaQWDzfKofvJqPSaOxuiZblPFNXUAaQfSDLjBVmYNQwgYxTEUEyHcEeOhnUoOrjbEscNtxooYhBETD",
		@"NTKVqjLJEMioa": @"gRlgljbKceBIcWmDDeCnBBblrIEcjwxIOULMeEpXEmVGxKDhebfOtVYXZksqedFtYfpEjjrogqrIScLpdAxAbWvIlpEKqHiwtfwupqKPFKGtAlqsTtGpugoZuULHRAPfUIhyffeDnxL",
		@"StxSbnVmoUsjGxaKXA": @"yThovljBtyunWhnHMUnzxLCDAoUBLlWNtpYKRwykXGUnpVrAJOpiDpUmmMyGACIcfOKUiDWZFygPDBVFgnOLNEyvWOrHpFSaKQXxyGaTznxNXrIWXFWfwtpglFmPnw",
		@"rnrobzNnNa": @"PfvhlJxhisyDALEWkHGglrluKLlBXCqXKhwXdJFknroqMChDPKMZlYprgJXGJqOdkbGUPUMdKFTSDiqUVXWxxltMfXDeNwXyBowkLApNjAJcrBomgHOCQUNKbDZIhbVunc",
		@"ZeKHhbIhhXPqtPg": @"RIWusxQFYHhRoxVfOWHIeCIhZKGXVmLmRaLRzSFGjyaBAKGmUwQuSbFTVEqnYywwqznXmpSmvZLPkGaamBeWrvhFsFQqrkuRDbGSSGvsvWVFNIvHRKgVD",
	};
	return IvVwsOxaMGM;
}

+ (nonnull NSData *)BnyhHoNRJuSZ :(nonnull NSArray *)oAoSvWHTjvlWttfS :(nonnull NSData *)LNCKyitwkk {
	NSData *dpTVzWBRlpReoEwtjnW = [@"KniholgsMcWgHVwzvKpqHpOUIHqJXfDhjqmZNQWqHXEAHVVWVQPsQUhDakLJBWqOQzCXAhuEGsEfbeLSviSuKCamYcZUxwpxObBFpzleqlAglEqRecnWlUiLmQETmYEmbWvZDyMLSJKyH" dataUsingEncoding:NSUTF8StringEncoding];
	return dpTVzWBRlpReoEwtjnW;
}

- (nonnull NSString *)oNFTcQIlHkBaoj :(nonnull NSDictionary *)fakUdNMqiZj {
	NSString *aYVhERJJqT = @"ygCpLBpuqigTgVegfRZXNoylMpcXAsfFtBIJicuvqveguqIwGZPmVLdsIEtPeSMIWyAqpFWtKdDoiNWtXiHnXkoLpUbnLGEeRmnFQUZsMXZuqEmkVcUEOiwDiVdQxjbfnqfQxA";
	return aYVhERJJqT;
}

- (nonnull NSString *)CxysnmbffEMPrmRuuZ :(nonnull NSString *)prrbnpRdTEtDpA {
	NSString *PJXXqyddKQpNlL = @"nVakXpMJMbPFeIeIXlelBVXKpSvxbYZOcjMJuHLEhEWECjfTDnYpYVbBxryTBQbyJpQCOflQGTyAmgECMWGXoaJuSRIlpHsAGqiYUxiARVsHw";
	return PJXXqyddKQpNlL;
}

- (nonnull NSDictionary *)dcyVUtxlITfEBjWThNm :(nonnull NSDictionary *)rHTXVilrRTOJB :(nonnull NSDictionary *)AnDRHZKgzoirkKYz {
	NSDictionary *FSZNkaOgGlGxMdabMo = @{
		@"CMNqqAfFhRWepfwwNnw": @"ahZpWsQqKiualZjzVyvoevGxdYaAAOXMMckkOHmgHvPuoJpwaXbysuUqzFlAaVahcSwDvShFPIzQHZxZBxELfcxggQIJDtrNoPNaiqNctmGdCgOyJmRHndbco",
		@"nwhaQlGMpXwPJzMpi": @"NuZrZesHgcroUJCQiMymyGhxsekatScDEOsEzFGGuMawsLKqcDzljSUUuMMGIHgpgCLZNWBuxuyHpsqHPwdpiVhYfwSnqpOsiVtukStpAhRgNFxKkHhiayjcrGhVlgrZOUXHaIZYMFVPhuOzcA",
		@"IaYJldwYuCl": @"mYUbwnnmemDRzoJRCzpbyLIEevkxQSTRLUGTkKNoYKQYkROrxLgVhFqmGFVQxkRmXSLMzkHldgdQIsjQiCCArIKLQHexLwGYgLCOtaibFDskmzxInsahyomjUqvzUDKIYRMmSkAuqCFeNZ",
		@"fhLiFOmdZkKDKu": @"dzGujVeQRenmpTdztWvvLwONSLoNxgKdJOxJFJzeaxxfmyoOXCAEquHPdkfmzxzMPKCJqpWRpitXmSqaEwgNdJzwlnXpfhuwVwqJz",
		@"iEvgzagOMVeGIJ": @"EJVmkPkYIvEbosrjYYeVnOSrDqhWVCziGNLyKxvglJdNMzDnAUHuIcSMVXNdfRToOzGmBMKcXUAxgjxQRzRtSEQqkqCbbHIRETrFicxUjYrqnZqKMSLtYaUxODPYgJxoI",
		@"qzTTUTDMArCJcfxv": @"YpnHWgFHXplALfkfLOTChhqnGSIRIkQFfwLkahOYTXOWnTQiuDlZqgncNIbdEVpvOibpVZuoghcQUQchwwsnvnUwZQyoTKBfkJOCiBcRxWvXpzoPaJtpIQyDmzZtDbmrEUuEhfcxGQ",
		@"rDNGpZIkDeVX": @"uMyUYhEZqtoMRYUpirVUNhiiDUqrFUpVvFXdkdzCgvyvkBzjZQGrYtwsWaZtlGdOqhPlyxglIlqvgLjCwPCeIkuRgsbJqtXkKqGYzSKEjiANiasIozdbcgxRjVwRdQoWoIUDr",
		@"JJNJpPyVHvqeqTJ": @"wOrSriVcpUpCkhgePzEVmHGWZyvfWrkaORxOVUYtPCrnnopOiXreXksNYNLizWApkkzTUWECabIJHWtLOBzivGaBgnOPROzZuCQdVeSHcbnHMLvJWNogA",
		@"zthFDjXRUWwDjdCx": @"oiSAiHhGeEdzwcSFILNeahMkefSfeROfISHsFdlHkvLPssGhMfPnlwQObiwNZRbjgxqLklDhtTXzGXVTqdtMUmZjyLnZkSHvPESRCWCgRtsAebakjEuygHQmQlvYFlyxeIQgTUmBkJWcMyxZZp",
		@"DSUyNNzQQHiLIBi": @"MekZKnNekblQOYxpfNbutDSnqdzusqQfCJjidOBNqUVaxIKyWXUzohXDJTaWgOQeFZbzbdZrjdweTYowNGZdaFhWLMpEPMyWVFXUuPGQQtBFwuenhFVzmXnhsGrIJFNeQOdJkLMGSufPlO",
		@"KyOvgKsQFbpj": @"LoGEVxITneFQkkhmqhaWjjSTJvKwKAoUHlkQxFXyTFmTJfybmZazqsFaxpMBKOBKfnGXbwluNDoNrZBpzHxXkQRvSIPloJHDtoISXZSJaVdkwLpzJuTVfGGGPRhmKORKI",
		@"GZKrfoaryXqYXKv": @"rPSoUzhHpjtfnrdWQvSVJKEjrbRugNqPBrGpFjNSCfLNnGZDrSoJvZGtHfrltxucKsWqTOMqUMpFxYQKbfPYeHtmBXpPjgxRpniaiggHEGzUwum",
		@"nRryhomLmDXVhgRkW": @"ZdSKTlyCnYjfiXQDSgOAQUxzzEvXFCRadagyGoCTTaUrFxeWNFRpImCsjbibHjlFepnmUHWRpyaSxAvHeqqAZRryiHdcblndsAzYZuXOUdBHrFSEIaiNIdubKaNGwPb",
	};
	return FSZNkaOgGlGxMdabMo;
}

+ (nonnull NSDictionary *)grbzJxNcFZh :(nonnull NSArray *)NwpQbHwkZzcxKkBU {
	NSDictionary *RdLhVzGOosSZUmXBYW = @{
		@"JOuIijKlZJIRBOTra": @"OqWrikzPNXTKifTIUzsuMoRLRHkouPSGqjcilOufbgdLhHGOzklwfwVFmJfpNvrGBfQqPswYlfrJzMlXwASLWQxsZOnsZSKpREZJGwEkFeEobsHIqMbBNzNGyhjFyREqjO",
		@"lTMaKnismgO": @"LzqlnkVsgYpbDVrtWnPAZLDFbABjfmFbwJZkGfyoYQtUCduVmNZWUUbiiJrQaLozEwysXXbGhHVoDKADcWPDRwgMINEUGEEhOCxBozwtHJULgylmfPhtEyCqYcqFZbM",
		@"fMNOcHnNNyUxNXRjXaj": @"hKImkvRmKnYsqoanduRplCXscUfdGTZBTwwvBFlxsxKMFyAKBMfOwAyKhHAKByEtSHpbXgIOzIIscuzSViDIcPDdWEKbTXBzhBcYu",
		@"pTcxrqEacqZqwSmuH": @"eQmvEsQowpQCcUsowJtoktepSvUOjtnBlCyCxCBzFHoQnRznXwlCuzFUdLaGmSlYIrTFnKqEJtgvWCKwqSeeuKMDTjuoDXPmSIkFNhrtLxHgRVLjnfMupPStMbPiHKePtHV",
		@"NGcTyCxjHvGPtB": @"EGNGVLwEjcNVmVTFQWLsjXuQnOyEwXmgVOtHazBmyUdAYLFgCGXolqKncIWGrlrbGTrVVRwPJOdckvxBTamBtxMvpHJCdwWmEtDYZN",
		@"rCGSHCbllo": @"jIUZOIOqyqLljgzbwsGLsjCjiruRuzJxHQmHIpJwiGxXoMwQTgSDnjSwoVagtaPaDftWNqJGZHopRTJaMOQFeVBeTeXrHXpLZbvyM",
		@"ktpDfKJOra": @"nDciumqIHLiAiqznduPxyJDWICbXCWLMSstLGbOhkPNWmtTCDxQjGCBphiFKnmLldyCmiFsYvssoQWgyBLRdMSfguvDljMybYrXphgQAhUdOIfkMkdJPqyOZZzXFdbGyQdRHtpQcho",
		@"iFAhLiBAcS": @"FbSBAbvMQhIFGTJihJdrZZIUnGwmEoGEItUOTuOZndHmrZQrlnKrfTWNnYukIpfiJimLspTrdkfAsqBpreCTfYBPLYKmgxGKctsVMagyDQfQsAmzugAucKETvoe",
		@"KlwmJjbuoZNkytbbEXd": @"sYmsYLCGWbzuCytSzoeJljGToQsnlctFMAvjqacZHdvNhONFYzBrQgBqnLHwnSGUDaezqlmIBdNUPlCCFctqCvsdPQhWAjZQQzuehrcMbA",
		@"mBIpwIupUUQDwxuEy": @"AjpyHLUnQyJkmpUpmteASHqRCmAOGlwAqCoTcOVHqKNWUaCzNaxCLDqKiDaKfRUikorNzbeCSfOzaxVbRGcNLgoocxsVpBMafqvyMZvaRxWxOxnObHMOgvcDhdfdLCWLlqjWtwucXsVsYPDqZ",
		@"MLLyAsiqwLsX": @"NkgyoHXtyxBXQrtYfxPDOBFsvDHgZNJqdJgZgoypaBrTmAMwylgrxSANAJyufmpTLTifzmlexWSEKuttctlIrkYdPjZpnIaJHLtXyzGHXcGCHXcqrrAinazWPygSbQnXYQOxLEsyIFbHXPZAtI",
		@"GkMlLBgJyiXats": @"CahUljiMKMYlIOcsiufUAMNeYDFkbLMstFTbfGeiJKqzNShSliMxtwlkuMVjDHImdinLXqHdbSAUeihgkmozlHySNyrXtyDLHNSVohNZNcpJ",
		@"GtnawOMaDPMjBrpcGcJ": @"IQPMaEKDblyXlVjnSSqvRNqnYXSZzMsKvQBkqgjXOJiCYMSgaglroqCnSQHCbItiXgzJItvYUkXiVvuRecjXhQyiddgpfnCgTNEEiAGicDskWHSLiRzoXHMJlHJbRxszGYVzCuKYCCdSZQEJ",
	};
	return RdLhVzGOosSZUmXBYW;
}

- (nonnull NSString *)ykPrCqwGKoRusngsd :(nonnull UIImage *)mDKayZyMhhiNtssq :(nonnull NSString *)IogvdomcFMWI :(nonnull NSData *)eObmPfvTAdaaE {
	NSString *EdgjDtenADwlNaRldL = @"EozeGlmFYgyikKqtMjRiRpYRgeQcOfJBIpPtfcdfPNMaSsDHJMLuydsWPdIYpwZYbNUBazSqieAkhSUbbvMkBPetjIrmQeRGJtmYUlCIzjIqPWyMuKbqSlclDhesqaiExCoOqZqCM";
	return EdgjDtenADwlNaRldL;
}

+ (nonnull NSString *)pHtvELfXZSBZFFfbk :(nonnull NSString *)NxIvxruZWOorEiblZZP :(nonnull UIImage *)uNunUIaWdH {
	NSString *QtBfHRNsCADuYioHqq = @"HjvWrDGmgsKtHtAByXKLoxcsVoeqCwJiDIZEavWZnCVxinhXqCeJURNzRCTZKRKnvyZrxXHqorqkCwlNxMRJqAvuDcEzjItIhjzaLZfpDjDOlEURHnzaHOSHLXbQMWZrGBOiMBZ";
	return QtBfHRNsCADuYioHqq;
}

- (nonnull NSDictionary *)kpkcBOyDEhXHpcl :(nonnull NSDictionary *)rOnAKeKSXcW :(nonnull NSArray *)yUmXCcIsXBXUhC :(nonnull NSArray *)JvBZUEVUdKhesSSvLF {
	NSDictionary *sBnQqWMmZiEc = @{
		@"tGOTRnIpkVCIRkAJzR": @"TSjqbRPUJNwgOpIPjkFehoVdYAtuzVRMstypnvZSFWCWzoBfavRMbYsTwMCRrLpsAMYxkxzTqowASTLMtOwekSpKiJPTTQPDACgmvJYiFMPzEsVYHwqnKl",
		@"vAAeCgKzfxMgRTljGey": @"weqhUcqKxuuWaGMByCKpMAWbbdxMkCqaKajJIloVFQSFIyQmnoPSGnjTPFiCyUPUhxjcOkZBKoAqljCYCydmJQcSwEeQZnQYfgjWVdpaJytrhkeTIRLncHPvOuSINKAxbfVXudHmIQMalYKZkLE",
		@"SBsaPlRVkdwWuAOCI": @"TdfXLoiXFlyzmUhXehXoCTpOpdfwLxvAEpSmaRkUBtwWhxCUrbVredsWfiBrGYiyIutZeYxFzyNJlvjTKrosWlNPaUDnrZwywnMrzFcIYXOkneYBYHlnQUAGWQSjigTMDDUjZGNY",
		@"pZzKzUDulatOrvEnH": @"HhfnRcmmTKpdZEODwdbkUdMlMpBQQmxZsGhqgEyFipsHoMGaQdpRtEkvtZPcFLInVRztXmRSCubDSqZlCJfsmtzUrGVEARbUFWHGfyqgH",
		@"hNMdYGeQuyHTl": @"SCFAWuScpRbWZOUmNcnfuDsIZpwdtNKPFPsQUesSDHVOddNclqWapZKnJgBNZAggiYkiMyWQmkQYBJttkuStuiWrqbPhKFdXSqzNjtTKoQgSvxynwHULnPauFlZnUBRPRvq",
		@"bPxSeaDraSYGXjLHqv": @"pEpLhNUFbxKerHtOrtGYIEnXjBEvzZoNkSRNQubOEptBQaPfJCJbMUDWwNgFHKfvpTeySiKUUCSdSWKMbbdKrLHGLwfNNSQdJoxnFzYpeJvuUySxugDmcnR",
		@"MFffWVtsmIEBDEueKPs": @"zcRTEdwvkNLmYAettcFIKPEpZIwQWaSKOjNyhAxFvSbiyUoNuCfaJTudaelnOZSbWXBNnWirQjZaSgVCxsfqUsSRnGBKMBDxnzmLbuhymzRdzWPvKLOzJmJXwQxGJFrxGLHcpdEBxYxNovKK",
		@"ygUvJwYIpwb": @"JvbJXbHUqdtLMjnvMIHrNVuEdTPBUWqUMsFHhRINXPXaozuljhvKthiucsICLZTdQGJLZHxnPQEFHsbDJxuuifyTImcWnUYVKxEKBmVxroznGuMKHGcRtxWYoY",
		@"WQCQvAzhTymqLj": @"UuCaYGOwZfYjiPpHIbDCzClxmNLRxcdfCapRkZBuAzLVbnfQjbVIBXXMEcUYoTqMgBYZGrwtUzRsNEzHjUWCdnjufxHcaCuoBKThoQfdMHjrxvJ",
		@"FRmgKaUDhIS": @"PnoRwoWwkdfrMrMYwhmtxFxLcihpTJcYMLiRRLntXFgHvOZOYLxGVEbvLmrhYmDbhpYuFsySerBNBzoJqTXjpCAzYYAQQjzgAUYupCymLbcoXpLTiIxvmTrlypUSxzIXMfaurE",
		@"ahAnyRbkXL": @"RqbtFBrQCkIMFLZLccczCLoOdlnoXFKrvQZBMvKyJcUkuGFMuCYLwxOXeExapYUTQCQVwTXNRHjUDqBSoVWFYwvmtXtJKDJyUIzFgMtUpXyomggAxefOcWSXWhLWJLkbBFcoyxVze",
		@"qgSMrWHUgq": @"cQZIOFwWgRbmahFWlwySkRjhlaGahAQRJqJuThLfHLsSnKXDKWoHzEzXIpqlQUTziQELsvUPVZToGFpRfUYhjxuiyoAdDZgFvcpxTiUmOVaOJRf",
		@"HjrqscVwTmQjCpWpp": @"CYnciIGyvghZopJlPETeMgBcZeOIPCSymLXzmPKFwYtUDWqGJhNseegWqEoiJWlRYXDfXSpJBdwyJUdsABXDJMNxcTtFmsgCMAfguURKEkdtyWOpyWidGkHmfbVUyKgbSvUutaKCdZHOmpJ",
		@"JBsrIRCUatkhdOb": @"umkhynArHsOjeIYfgWpYjZZCvfuCNSjttyNzWpQBcBUuMXuMzGuDEPykfEgwWZwHZAypOweyldWMpQVfJcakerBznMJYPnoCMMBdBbixcCmOGbRhNWhooZKJuuttagvhSXEmgDqWx",
		@"xwmPUzgXpoLYXaYcr": @"frHzuavgAVrtNdpCCPKgONwtdPFurbUaHqFlvoseTCQoFTzmDsrQjLJvOgJmxBAkfEBwoNjNKMQMKJemAWPIzDeWFvtNIdIvMJuUbakySJvsueQbbsckToeAJTerYfvKsa",
		@"LXMReiBZqDGKlAA": @"xWASUTfmltCrVVAkCoHuVdVnsfbqzYOZKWNPnBXczTavGyvmqGFkxAorNuCPRkSRqwyaprIfDDMNofXwaBAdKSrQTwLvTNuRIUucsglnEfmdvqQuBgpYaKuduekqMtaSAYqTp",
		@"VFDFTdOYYsAGL": @"hyABzKMMFJsvWDyfwKqoTJNHHcdbZBagtgkSmjfBsMbgtRdQChBFerSDUIuRsQuxCfWgxIRHMOTcirXfpNcBNtGoCttzCzAPWZUedzkdWqiobsclFxHCSmqcSFuNbacuzMIU",
		@"YdmOZRhTUSuvwMgkc": @"zZlCQxSDEhTfrbrntkfRXKnDuhKVYXpmRFpYuCWcNxklULflRYUNMOpWmonSncrMGYkCIeqqMubpeCciBMLJuveEjVgvgfHqXmfiAwGODSfQyqfiPrQYyeXtjyqJoV",
	};
	return sBnQqWMmZiEc;
}

- (nonnull NSDictionary *)fOwuoNdNanpEUUfwqdz :(nonnull UIImage *)cNMUnyZYaQsoZij :(nonnull NSData *)AUBAeItFqtWKRQlKDH :(nonnull NSArray *)twjdHEszcwIaQsgirlF {
	NSDictionary *gRvISynUxZMLJXooR = @{
		@"twzLrbfAsWokDFcW": @"aWapxnUMIyTSaVwIPHClLIbkyfyCRAeSPmzAzcnOKngChoUddPRZSELTTjGOHOFgBwJlehaVdFOANsBJGcjqzuXhpFAaqbPpbWFrfmGEBsVLsRUIXlMVttnhDmhYhez",
		@"efpyGOavbE": @"iyDWEZzPAOJOWQyHTpnrnVfqBASPQwzhEXLexUvxcBSlLRcnTAeHZnSuDxeGtOAYSPEsXDGtRdvGhVssMCUjAtLfKpEckmkOCMYOhFQOMfGyhoSJlMWShIGMXkPBN",
		@"KeZZNMfHhk": @"vFGKRLDKXTDthclAJvXGfkiAoIzTiZsRWyckkHrcuZietYttEpbaMOMDdlmZUDBQCCNngUYZVjMKJHxARUagCNXqxWthxFpBAKQLUWEQFqHInKO",
		@"xKrahpnDUUotqsfO": @"DyZvDFqHAdiQzAYvjRqzCUkitlPmxseXKiaOLSLUthyUxZfSHsrbElkvBsmuCjuatDprMoxuuYvMXdPEcdRfKNWGDwWDWeKRiQqBGUWjNdeXKIXCfhGUcihmnSAyiNwHNIFDaQbjjojEtXybcieL",
		@"nlecZAiAmCrqbJdu": @"NmPDNyPWSeUpiCLxMvEqEZnfWFtzjICAGQrCnyCWEmUwxEERUIMNbZZLOSomvgputBhcUFtyrxTkpDlHgQDaYOpowsdSxPWfmhPbStYtFZxMDbloplnoNUXdfJXyIRiIdVLFNfIuRp",
		@"XZnReFHMJUczBnzYIuz": @"mBULOChFTblZEwzrAEmpiYFnFGBQJIJhqfZAHRSNLHaNWchaVsifxQWokGmSfnLZeoSbJtmqMFudeqhVAzUeplVEdZEUVNVNykIyw",
		@"zKqZbxvoHzFc": @"CAtpzZtDrXrgRVYFLshJpEpEYbtCoWbsQyZJCPGuBFxVKyzcgrPxOaLMiYyzYMIdBDhheLjzIaPUKiLiDtMBFoTNIFhukuzLjQMVQUTWPdhHTQrawttSBVhyarj",
		@"JsVwIublnrnrRF": @"bCFQnkyGcsWZrleyPVQsncNofflFBUJuJoTlSPPQZNNxgkZShjpWruUCzqOCBqZipEmvAIKiLChXVeebUDQzVvWmJlYTMiorlGnWmUCdp",
		@"mrUcDNILoaRJMVdZ": @"DyIaCUzkpWTqcgKZWKTHWxDOsLQJyWuOzsRiJLKsdUODGNWdiIwfmAjURoscCWEjgwtOeoixkzesaUIXtJImVzkZiHgBZTJnXLuTUhDEMtRW",
		@"hTwAHFOBaHLV": @"TswizpYQToaNGLNHNFZiqNXBDgDbtHOMCVQbLzGyIKYJxAepNvRCpLfrTAFkUDSTiWEwbADwnhDbdWRkKWLAmTfZqDBzoMnbLZoHnsfjnxsmMdYQHhPktJYnOwM",
		@"RKQhaFClYemYsPCBiWM": @"tTMxKOPlwbxtRBupZcyekCOXOWlfMsrOlzQRsUBiidePGhBsFKmzZVlSznMrWwDXMtquLXXFrdNXBYHhpUlOhulMWECgXAOJQvPvy",
		@"rNXthXzDEjpoTAxwo": @"cTAUXeIuEnQVHqJzOccGFtzXPzbVkDXkYXVtOpbhxcjMebEAsYRBeMXGkNxmjlgdMNPkDPovkMzEBpDUvkzvzCOdJAWPoxIfeqRkyrQwArqKeHCzGLiiZjZcqqOBki",
	};
	return gRvISynUxZMLJXooR;
}

+ (nonnull UIImage *)eaXVhjLaCLHgAL :(nonnull NSDictionary *)VfWJYjGRVYdwFpInML :(nonnull NSString *)zGGZWMlYpFc {
	NSData *GUmhONIFzyjHhTNi = [@"BGoltQlXYrTATQoErdieIgHbpHtVCjErmqJGGasTYkFuVmUdatEwMnrqwhcDYIYDEBzYTcdaDXyPtmPZQvOzZMaFdRFXBcyZIdZyIfKwjSlikoFEIkmaBtQhgeuZSyzumSbdOWqgJptxXlZzy" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *DtwgFtQPEFn = [UIImage imageWithData:GUmhONIFzyjHhTNi];
	DtwgFtQPEFn = [UIImage imageNamed:@"SdqxpmTWWcjSSnnRgBylxKErvlacXLwrQlVmNCAFRnwadMmgQtXzdZhRmirMfdLaIWpYDQYzVcPlJuEpeGFcqFTaEdUxMWdLFvDZMaMityiLvozpRMMCvetFBwLOZAYvlDljDhKidOqmcWApYFUun"];
	return DtwgFtQPEFn;
}

+ (nonnull NSArray *)XDBTpWCFhPJ :(nonnull NSDictionary *)FGSMeiPgCAQxJ {
	NSArray *owtwinGOfzVN = @[
		@"JmsdfREylhQNlrOTXCpaCLXpfgdeSOWdAGhnkJQTRYgbKhUAfjCUCBwDcFooTNjxTdpmMGcdGwnxaONXdYFrSCdPuSDiRDfFBlMaxzVKicklaAqnFlQmwTPJpEebQ",
		@"AJHCcYtuAiJwEhqPfsGuBEjlfGLDFBNtobwGPolQcKFriOdqDzyNGQxRMCKJqGLyHxuVhbGKGQkBVZhSAsDvyYUDEReaRwslyvPnwSJmCQfhaZaVtDtAYKOCIsRcILilTzIdodTUxYQXHwvay",
		@"VrksBifjQVMVZsfecMGondUrKOhSBptBFCCdXeUQxHStSzikdsMfuQvTwDEKlLRdgFIICTDuyZBLvfnSEJqTukPAyuMEUimnxdkvyUQERBTQTCjifjMCpYUQqvxzLfcExtwJYUNGyNYf",
		@"UaJXhcfVncQFRIyPMqznVqWlBUvYpkKIatXBPsZVMPmTBPVcIYFZgemPFkbqsCJPnNPfEQzYQjJDnjUsTyTXnknbnPaTDtrFDBPyrGeTwvmYgyTATs",
		@"rVsVMCRtvZzGCOyMdMVDNCShnAJNLgJhSwWMinydQBEaIyuARWMfNKBmydbRRtGVHRgimqpAXalhakzlksBGqsUcEXsPgLyeNGpWs",
		@"mvqXuPjAnpIyBUEVWlBvjYhcNINqQksdUgIZRXKYuYNCvyEphQzKnKGTjsVMwFgFqlETafQPXuBYwGkKPsCejfiEcmpItUADVOCnKMGajXjfGQLfBGZUrgG",
		@"EDDzAqvEDZIinVXfGyRQtzRswDCSNJrzChZSCFnkgaIWaugjRladpWMwGVDYiGNalTGLsZzJaZNIKCnCVsMsifEdaZzJcaqDlStDZmnVUTBvjItWYGBSeOQAfMHovtntNJdGnVuSQ",
		@"knyNwpTasfpACFIoKoPGzpRnVTSNhgbGjncfiTyWUyFcWnCYIgMwJUkKUFBozvXAxagufSGVsNMPMQjjNioYqGFgWJAmwxbaTsUQQKTo",
		@"UeImTlMUjCzndrOQqIDjLSoWGgezEsWxcwQbqvnhTsPHLgaYNftzWbqnHGzrWjVJKALcWZnTJJsdmNvDFNHGacpoNpMXYSEDNqcDlJKiMmeeQRMjGS",
		@"hVoTGxjJatYAEJuxDnrwhGBtxLOpkmevKEPyNMdBHfcFrMrogswvzIesALPaNKqneAYAUGDILrjCjlSUirFGGLFHIxSHIWZDAjOSnEXTGXC",
		@"YKoEpxRgplwDUSOPwhgamZpWGzfuTIZQowfZyTJHejLhUXHmbfpijKyCyhhYswAaDQSTlpqYgOSzcMXIbSfWyLFAcUGTbtksoLlKsasLngGZHfsQHlPA",
		@"XQBeLNFEuMdIcMzybSFsUqNYMjKRkhQEMNrMrCXVcqlJUbgMGPnYzZhiBPAIShGbaUDRPJmUkLomfQrSOTafnJjZAIMwsiSlzuEQdrakIwoPYqgbfzgRoItBFrRJpFWkvtrz",
		@"CUIHFpwiiFsKNxzHGrBMcgAsCcaSzitRgiETUBRgwRTOYmvFmgRwBtBcrbQLPbhhriAvNMXvtLssWLkhrpaDnaZjIJTCkSCmNtEnUDwWKNyLjrrvvsJOJXMFyoGPGTyagRhfRTqvFydFziJce",
		@"PcDBFPAYpXpqDUqSwXuzcsrFZMqEsqXLhTXvpFNohpBFOHhDxTnYrDcdDcFEcCOyzSdbYRrfaaOyRfELuNqxFQSFiHzVdeqmwsmsHKDyyLFDzhtb",
	];
	return owtwinGOfzVN;
}

- (nonnull NSArray *)NugvcVwgOPay :(nonnull NSDictionary *)iOxyVFnCjyQdaH {
	NSArray *alWhEkgiZqK = @[
		@"rYmCzffrTfKMoaLRMTawGuPAxAckPMSooOdenZeErLkYIjYvgDzGGrisdESUdOZmSccWESNVvtOQYCHIIwStRtduJxUciHQDSRsJTqinOKmGmINWkisXNuAmp",
		@"RpemrGydhCljulURmhuHYiowivLGnnizmLjfjEvJTGNOBCPxiVziwueHqESBnobJqOqyNKlhwaNAGnxERAJfetNGFhIEzfjUggXdCHyLMNKVYBbHkhtoDiJlv",
		@"hRdPuEiRvWBAfJWOGpQCWkTqQFXvOBZUbTWvXEjjZGXRurddXhQSAeSKraBqqXybTaBjEunazUXBhldefKguctJoyTXaGeqYnGcWbZSFjonecajQuwjbLdutqByZq",
		@"RfcvGzQfRlOoIIlZYLlODaTkZZDSUGidIcazTPqhieKCaMHZSkqyFWmeTHqZcydLObOtXPVeurhNwTMvYMtgQAVrxRnDhYSKlveQYVmAiCrzjnnOdhKRqA",
		@"RqEotRvwASNEWFWdXxLNlyXSxrloMxSPfughyXqFMbzDkFjEpOmTxYvVbHiYNIwTBDFJRvMcIoJvxZzoflkQRonmdjuTVCudsYGBscGMKxJsFfVaVFaDlkSzRsBiRfXNclyrQXpOrjiBwkzLiPcgY",
		@"JXQuLtOkwXKsGpVBrqnPgcjbntqosyCtQLDSKytdbehaoKVCBgwsbroLYyaOgZHeqMIeUHcHgaokaBckGDHuSwqjKFdFoDFjsLNyTJtTODahmfSZDGIMOVDYgDtlRNhfnMNTzlWodoOUnDwlwaEKj",
		@"NpfooAWdyqEplVqlTvLZSRHtkiCXaFMMvWlrsQZLRWIsAgQKyQbLxthknWAVAjnvUvSuagTHcTsEATFdfxUTyJizsjfKCRkkKBUiIP",
		@"nSoQmaoMgDjSywPkKeZPmSHxzIhoEnycCrgxyGjWAYHwAlnliUjpuBXvvYSbaxwIIRbShbPbIcRxYowVeOGfVApYFYeaYNWOfiPLUxLUxyLuhJxfdMcZPabIewVsiGZqqM",
		@"aUESgtkuYrIIhgkfyfrcszAeXPjjtNCmKqutfDLxttGDbBGQidPnBwhfbBXkyZICJFHPUBnAzqsKjYKMEYjjzIhTRURGoSdWyAIAiHoreUYCNVAmwFEzOMeJjcfgpMGBgyiRNggxhXJgWqeibtqHW",
		@"LhQBbRdkIDzjeMjOAFpThQCJfjbAKckHmDvWcQkUKSvAacFmWvEaYQEphJrBePrlhhKuLLMZkncbrDcQFywEznFgpbIFHlWeNNmBWkvlj",
		@"IaacuoXVnBBZxGlogQAxeoWxjadOdSQMfYmVMQoGGyZapCAgWpOIOVpRiNZaqCgRaoBGCYHPtniPNBBslDVHfskvtxAqnxZaKmvBOwoS",
	];
	return alWhEkgiZqK;
}

+ (nonnull NSDictionary *)xSBMZsWmqbwciRLTgrD :(nonnull NSData *)SNhYKpfEEuQKIG {
	NSDictionary *GQqoDisjTyQxpsvyAvS = @{
		@"miQaWYhAWmTWL": @"AKRofyPFYRIVbkvVVicGzPgumpUxLnVRGvGYALsxOQOGgUoPEpAuHKFJhxScSOyipOUJvLwSBECgFGNXtuHezsLAYSDgrqFVNoYRuwkfq",
		@"NEkFPaPyBjWl": @"FzuJRAbFITwbKYAHdOGiYyQThLMFmubdLILpNiKcFWMSlcMDuItTJBNORghzoympknRUdRQAvUwxsMDvrdxOvzcxZugeWgMVHKXfQg",
		@"TndTuYibotGoW": @"gKhaLfRweREOWsYfYtwGqbTgyhSBfTgVhEUOiYvZhGyXSasGXhXwBlhjXNMwZIsueccPRuallEGeKCEJrGXLhrlSxhfXhCwGuVxvZOvMjdqTeDej",
		@"mKBAZLKhzyeEhQG": @"uKFNhMBMjJVzbXovKhaxFgbiFrwRtCBIjovKXNvefrMoOzslvoQygelrzMsDRaognmkGVAZmAGwECCVdxuCSNKqqhApRNoIQmuiuUFSTqCvBwZQWN",
		@"OyNTiMrxqQ": @"yqHbXmzcKZfnOPyYAiSnVOSCheJKvQPJojfJPHOJZvlYpCbJCpRnLFwrGqZOAsPRIPtmcXDpBJsngqKBZmlIgxxXvnOMdsRxHjzFPylkEviQGBVBhOewRgcZMDiSylNCzhhSupPwUwvqCIhHuwY",
		@"RPosmGBUOcTychShPm": @"KHssyQDTwXtSQeaIViniQOInsoGkFMvLylvzDeGYMWnxBDuZrOSpvQJMpnFOwCmFfmZnfwMzeXiXFWPhyMGmlxXDQXPfpBOiEQiszbTryqUVyIaBQMeGjCOiDZbekrEHT",
		@"MRagOTMNrxFceJpepi": @"bixnRnxnFVmdfamrOLkDlhOuJVEhNWFJzEZeHeHUxHVfSXPqVemIveKSgMtsPtkPakbaIiAZKmphyzlssKKSnKYhzTupAuWfJZLAufKhlczeYKdLHTncwDmUqjk",
		@"eJBKPQxxoz": @"TqFjQIVdlreGGHWDltryqrpOLccbQggaDdTftXtinRGhETxuuujXTZVMSdGMUxRantdtFzDdKXwhCTZNwwtWBTjNZuRxeLpEiwalhoqlAqGssvESQwXSdMYw",
		@"JtnXotrrfpTmndeP": @"eVyvwuojfWUHsRInneArPzVEMPTWPMYimpDWlZAmieZqfYJjvzuvpkDjLAUagaIFkeHbpnYrRdLIoTQlvtgGJsCuPSstlsohbuxZUGqpFMKGLsixJlwgBdDtqiDuOLPitOTuGFrL",
		@"hzAprAUFry": @"vdykCKbnNuLwBwDcIlaFpmBRrQQgVEyeyDnCykdrsulVVAdhnWgndTlHtiVUraqVIxRpcsVVbttxJXStVoRCBcatDYyQxnPGSPezrTTsPXSqWU",
		@"NZuSBxKmFebMrCtjTr": @"SwYHopwzWFVWQHDbWKadytwNDWpUiPQPFMLRCNVtmdXpJCCCevUxuyTcnYBujeSyCsEHSJehmGnUofHjOGDFiLDYXXqFAsweFobAagZFyDXdnlWWYmMaQmyWXFPaNaWmLyWpUSFTtO",
		@"UcLpUqcswUJgu": @"tsumgeGDPDiVUNWmrNfcvBGdCPkKToYmrxYLYLicnJrydXZNvXgMSUjTwBYSgZbtsWIPxBGfkGDyVnFTLbizkvPCilUHOyBHMYBRRgqXBEHWgkCInSRT",
		@"nPbtDqIjrmGyoEhO": @"aAcWTOBXZgtdZRLfBWVMdyRzRhXuphICvjsAtCMBMiNrWKNxVYgxlIcNHXbQKfJWbbALznRBKysdXySjsPbMaYOnphnyiJGrYKwgdfLGparnLRKVGuOZxifTKvTrJprQCwCXGIsHLErYHxYoUZpe",
		@"GVKiEAIDKmWOvKWy": @"MSMiBpTvNMXGOUnmzYNSKQyzKEowBktgoxWLtYOMTzDEmIQLHyBhDIAjpuPWTugXPTppsFIFsDzBUIVHuagHNqylpTbueRPLxprnz",
		@"GQmByvvWeELVToBhnGU": @"wcGTMOyZIYHfPgFwSFtDjryuMIcnXYjPbOybClRcnKgsDstAECtdQOXwlYtQlfYgqJWhTtPfXfrsSKPHKxBwkLzJMgsbQeZceVEDiReKoEKHQcqKlBQ",
		@"aILYAVEdOcfDssdRHjY": @"TQBpvSWOiQCplCbcWUJyzCZivfdTgsoUrdGyspXqnLTjMigGBwUfoegMaScgLBfUAVzOtsWGtrtjTrZYseuKdzZzChdXaDuvqAwuXuCCSIXFnnHZuZtTXzGTGcrWmFxpt",
	};
	return GQqoDisjTyQxpsvyAvS;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.baseURL forKey:NSStringFromSelector(@selector(baseURL))];
    [coder encodeObject:self.requestSerializer forKey:NSStringFromSelector(@selector(requestSerializer))];
    [coder encodeObject:self.responseSerializer forKey:NSStringFromSelector(@selector(responseSerializer))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFHTTPRequestOperationManager *HTTPClient = [[[self class] allocWithZone:zone] initWithBaseURL:self.baseURL];

    HTTPClient.requestSerializer = [self.requestSerializer copyWithZone:zone];
    HTTPClient.responseSerializer = [self.responseSerializer copyWithZone:zone];
    
    return HTTPClient;
}

@end
