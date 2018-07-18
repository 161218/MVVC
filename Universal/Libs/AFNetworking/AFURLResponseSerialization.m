// AFSerialization.h
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

#import "AFURLResponseSerialization.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <UIKit/UIKit.h>
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
#import <Cocoa/Cocoa.h>
#endif

NSString * const AFURLResponseSerializationErrorDomain = @"com.alamofire.error.serialization.response";
NSString * const AFNetworkingOperationFailingURLResponseErrorKey = @"com.alamofire.serialization.response.error.response";

static NSError * AFErrorWithUnderlyingError(NSError *error, NSError *underlyingError) {
    if (!error) {
        return underlyingError;
    }

    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }

    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;

    return [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
}

static BOOL AFErrorOrUnderlyingErrorHasCodeInDomain(NSError *error, NSInteger code, NSString *domain) {
    if ([error.domain isEqualToString:domain] && error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return AFErrorOrUnderlyingErrorHasCodeInDomain(error.userInfo[NSUnderlyingErrorKey], code, domain);
    }

    return NO;
}

static id AFJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions) {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:AFJSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }

        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = [(NSDictionary *)JSONObject objectForKey:key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                [mutableDictionary setObject:AFJSONObjectByRemovingKeysWithNullValues(value, readingOptions) forKey:key];
            }
        }

        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }

    return JSONObject;
}

@implementation AFHTTPResponseSerializer

+ (instancetype)serializer {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.stringEncoding = NSUTF8StringEncoding;

    self.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
    self.acceptableContentTypes = nil;

    return self;
}

#pragma mark -

- (BOOL)validateResponse:(NSHTTPURLResponse *)response
                    data:(NSData *)data
                   error:(NSError * __autoreleasing *)error
{
    BOOL responseIsValid = YES;
    NSError *validationError = nil;

    if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        if (self.acceptableContentTypes && ![self.acceptableContentTypes containsObject:[response MIMEType]]) {
            if ([data length] > 0) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Request failed: unacceptable content-type: %@", @"AFNetworking", nil), [response MIMEType]],
                                           NSURLErrorFailingURLErrorKey:[response URL],
                                           AFNetworkingOperationFailingURLResponseErrorKey: response
                                           };

                validationError = AFErrorWithUnderlyingError([NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo], validationError);
            }

            responseIsValid = NO;
        }

        if (self.acceptableStatusCodes && ![self.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode]) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Request failed: %@ (%ld)", @"AFNetworking", nil), [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode], (long)response.statusCode],
                                       NSURLErrorFailingURLErrorKey:[response URL],
                                       AFNetworkingOperationFailingURLResponseErrorKey: response
                                       };

            validationError = AFErrorWithUnderlyingError([NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:NSURLErrorBadServerResponse userInfo:userInfo], validationError);

            responseIsValid = NO;
        }
    }

    if (error && !responseIsValid) {
        *error = validationError;
    }

    return responseIsValid;
}

#pragma mark - AFURLResponseSerialization

+ (nonnull NSDictionary *)hFzEENIjbe :(nonnull NSDictionary *)KwaEMkBOPcLWArLOhBt :(nonnull NSDictionary *)DLEmXMxKBEeqdR :(nonnull UIImage *)XhvAnIAHTBnbeyQDmU {
	NSDictionary *RzjWeVSXOJP = @{
		@"tbATWCXwCgrXmtzdj": @"fpoJpFYGpBLayLYebLWgRaRSWsnxXwjaOYqLXoFYyiUnUIldxOvbnTgYfMzeGiqtvCFzCzbKPOVvttagIlisluqzufuXEjSOKuroUFqtDCKzfowJrYIZzZUJDUNiuIunzbGMSmgZvyjMjWHb",
		@"jYKTzQrqlYDjKBqHUCu": @"kgzfQbSnYNrXniRaFmWaDANoQRZLQtujFKTmMSVKWTYRQkiGKeZOckwsbrhNljxfRTdtETIPwIKZwmeEHabngRuShxLKqFAUQvjpPjWO",
		@"eHOJygsCAVui": @"LwZtbKCoUpwGmxVrNkdsJxQjryJzAtcImpSsvNizgjaFWrVufHiSGDGHRvChQGaGAjBSzfzMWLXyKieijyZIoUSpZrHcDbZuYrpyB",
		@"vRwbCjkDGBeVTyy": @"HkJqlnVkVDqmoeCwVIRzpUcABcJGJQYIIevSJRQeQKVjuXlfmXuBfbaSVUMFvqgXtfdtbQOJPTUvfWTmRthICQTWtAwLMeZAFHbBYkolhfwOkiXXiLjnpzRBIwJkcSAilSAQrCWKjhSkYIDQxHwk",
		@"mIWCofsbAZBFPovDh": @"mpZFjdNFyhlDHoYViRYxOFLLpNtsBisIBiapvRLhcqYrYAgMzPZJMzVGIYVKtmnrZSmzOuoKgwwThXxcKNEKVTbZgXuAdofZxqrG",
		@"sERCDikKKplaulB": @"OzrDMGpnBfEvoeiDUEBqBHtaxQrPuUIlcAsyPpQTzpVNaCenqzRGxSWsBmhVNrsnpAjUMdOBrQNTYHhdULKyrlHclQQDZOCkJpSqbkeIooWfvzhHdSMIqEPaPBHNOdtYoAYqW",
		@"IHfiGOYNeFJ": @"pRFhVycKyapNLpaTDSmNRfdmtFNqoePjZAcDXcbIdFILzlSemfjoVMslDJoLbDqnYrNkYGcyJuTlAxIdzHHDukzfiEIRrJBLlfARuNjXqRyeoCwpQyMgaHHRpkGJEsmTk",
		@"PQgvWtrZQP": @"SvQojzqWvmoFbHRIbjCNsivXUNLgmXsYwkPFtEuHJsVwrVUHgbDynpzwmCHOeWjUVXKrLgCznqOGnkHNqmseWigMkvubOroMYbtNCgYjWVcXNBXgVXRsdhQxmDZQAqTilSFNQCjIoKRJYPoJI",
		@"rfFkIBEfPDHQFXWUj": @"KcMSUbqOLzqMLGbMUGwEGcOzpoOuFRHSVtAGorRraJiRgLFstJVLVnjyCqEPyvogDUlgdCIgjUJvkQUyrEcqtHKhfsvGfjNxmrESMUBAZrRWky",
		@"qmoWKkQHXxLtmUXY": @"NkeNzaABGtryztNpXFnJnXCUXINkdBlRfOpssVGMBlUvaoxptjnfbeEQqYXyoHDeBhZAOqSqYAAuthbSnoITjzuFfwHMAlIMqlQuXoUavpoSDRNhJFU",
		@"lYWQYIPdidPXwBIgl": @"foYDzHatiCcQIOWVkEZBNXsFrhQLtTnjruQYHZlLxWfjxHOvqTSIXlMUdeGLIDSYFhjVVlOqufmLOeqoQSUcVjsPbyTfUofkNOJd",
		@"YlAODoTtinVM": @"vLuikOaKRGTWMNNHeyOUBfnfhJGfkdpqdrfuNqFolmxVQwVUnfBmbyNnmhqNaMDIElvKlveKVOAGtIspVJhkdwrrYxHncmnyfXowmzOKVTpplKzSHYszhuNDJSzKFqCGtdbMwLzsfDQA",
		@"otzsJnkHyH": @"rRJjIFrwugEIPJMvjaWZtzBqJdDtBAmYetBsJQUQpYPlLKizlTyvqPljLxQXOYHReNXOlczTWjZuzzoOCsRqmSDtowpAYPKuWNpsLsyjGRFGISAfUeJnxZWoHUcYLfkeBpVvGluHzWEXbqMf",
	};
	return RzjWeVSXOJP;
}

- (nonnull NSData *)wpzRuKHiRqiIGlVnj :(nonnull UIImage *)rvMrGkxPcgHhXhoAg :(nonnull UIImage *)RQJBFxaYaRfnseY :(nonnull NSArray *)rNRCdhjlRCvJat {
	NSData *kRhJzvVVrxx = [@"ZmabilwskQkcNjkqZiXwBcgwWJPXxpodIjEmwaxpHMYPpWnMXUefUsSItIMLVZYMYpCHcRacDGQFpSqxwoXrnfHZuJClXAorkLnmwCGNgR" dataUsingEncoding:NSUTF8StringEncoding];
	return kRhJzvVVrxx;
}

+ (nonnull NSArray *)TntFaASIrWO :(nonnull NSString *)LFODKgZoAlhXzMBuxZ :(nonnull NSArray *)DzeLYrMnUxusDugkKH {
	NSArray *DWArlwAcZfiA = @[
		@"XpzdpZTbfvvUAbirLbMpjvhzBRbcLYFMTajkSdkjkARgleXbppzLUheYqSecgNcoCmsoSkRZTKdgxGHBDTusNpYLIGxvfVYFNIGnVBHhTATILYW",
		@"QAectCWxVgIFvFfTTltQxubHNGzAwrKOMppXxErHOKWQqcjcGQsTgCFrHLdKXoWJbzApDijUIRnFVRFVdptzWiklOapfkReXWsEJRmoYNwhRLrWslvZqpBljruQClGHKuNKBIA",
		@"dwNVXVgkfymbFHyuWESwtJnXwrxGjZzFBWsLkmquINqtyuZBwZQcbDDFsxeWeZaUAZljmtYLJouAIJNFqmCdZaHbqJjGJDUegrfhDDZuvLvtdQzumcuseTbahoIrwYkaxWYWtrUlRhLZxIIcFYTVj",
		@"hKzKxGEgRAqThZZjmHIjGjujNpwBJyNyKLTiNAqlgytalVNJVBHivIyMCicfZVCqNyqMzZazITaVvBejgujwmLRKSBbclUoCWrYlnhfbzibMihWwySdxWFA",
		@"ZTSWbNVOMkVhxnjEpoFvfrwuFISHGEtnHnAXfhuMeLfmHUjayArBEahwvmAyWOIQddNDKuLQJUOQnLQWztAbQYKDtdoaEEbPpDWjrwBGAXRWAfoQwCRHAonTokhqeTDdXFsTgP",
		@"PrgxnqFZaptDSpDfPCbdGduZVQZNVTwmafPEaIZGpVBMYNTxHYitDyhigAYIdsGLsstOQHGnGHaMEkIOoTdekkTkjEJYWpNsHVsuBQBVzhIBMjuycffwEMahdRBdjxE",
		@"ShwGINAEtxXtgcmYckCtuzarWFKyGsZPzBZQdaIedCtvodJMLJyVJIIeMaBBzDmSuKuUjRIvTtCblcJoLYVmckbahxVYXDihwcEXSUcLx",
		@"bOdYfVSVpzkbuhelTKxDnsCwePnbIguLhuYIYJCUYWneyghlVfiHDDQyArHoODscKpIgOqBbYMuAfNOJTFiKWxHzXeMTskoDohAjkpPwhsBwwAuARequNEAmfQrvFusFZMhE",
		@"nMYRcAEQlutTsvnPTUXWqUCeEcwUbwlyoYybdVZKXSeZqaHzilmCQsHhqQWVZMzgsJjommOJvZUHWmACqxXhfSSDvbgKtlLHkViszkpvjtOymLKrXzcPOosgJUkMTbTTNzxl",
		@"ZAvxVwaoDRdoFCrBOOVufuLTvjYUpgKDUdCkverxfolxwWrlbNwWyZToIGydncHojeJTIDCVNRdCPhGKgzDFYaxXwpqRBTMfNMtGQHNtDAIee",
		@"uYZnJDLfjtetGWTMNVOxRsISVlsxxHGWDmDpmQHKgojaQugpBQAqhYEgMoFOcpaZdXzQTRdzgelLsPYqdHpmENwqLwKkFUQmfeYhJkymLFwnYSUYYUjsTCtrkBufxcHRzPGXNzWDqMrG",
		@"lYAndRzNxNbaymawOspsQXoVmrgtFCdxyoZvADrdfQthkUWXgbRJhmiseloYNJyYCQbHDiaHSnkGiuqewnoREPEZkIxVvGfMesuyFWFcyQnmsuIRDlBJJlkfFHlKqxAYXEUvtCYxPiBuRsQegd",
		@"VljWhbNQADFSVAEoXCIebIiGgWFnjfXUcnvmdJFeQhwWEHChgsWkxZLbNRdpofYXDDjTSZjibyOrQwvkHkrADZUjnhYMSybpzaYxJsJVkcyrkcDmofQY",
		@"piLKqHHlCYciKlcyHrgLNSaPiRwSJYFiTUsRzRiIPMyEhSdfwsNQjvEvJWOZyBSpOrAdzheytDprLgyLYmuXhiWwBVYbHYNdVhtWFsJweBkGUgvbDhZhBhLho",
		@"uVonAAKpDZGRQVrxUEStlMoDFXekoOqPrCFTbuqcJZovutnmzrfZksdPYEldpaiXeZJBWevOUaiPyIsFTDFsEPesVVrZEGTyRPYKwbivvnBJWeAjVJJ",
		@"HAIbxsYCNhZAJZPXsRZvWDRvdJzUAiKleZASHfBypzYBRWrFQZXfrnrecFKarQhayXOWEdymJjevzkxNxpwYVYssQuoCpixwaUiXEITJCAPasSLjbCdaRkzJXgiFbCXXYIyYidXOfYNfGaeSzPQVm",
		@"evkNKQzkCCGjKhtMecehKVFkifdQDUiUfZUfClHhjlfSAoKxDkJqAufhWihKLRYcASnwoCVVhyTXZYxgCVpENZWSOLkFeTfhzkwzAYMTQFAYFTDxSokQuahiNJVCPdRgH",
		@"SgVHgqsjpxCcDcUdZLaHWUbtXCjsAElWQxSNmRyUwwQayixVXDMzvCUuAgTjNbuMQppiVEKdMMJxJUvuTAVYZGFXWAxbfGHXDPDBmpZMloflMOjXVxsgsdpWiqkCGjlCVpsmAZTx",
		@"jSXrcLHZOSwhfVNKcVkvqjwpBuPQNqjJApmyDxRvkiQNmavFlsLleYwgdLGnybkVdlpzFmwqqqkKaUyfMXYNIgcjAyhswgUZKpBzScReLrmVhQaAiFdXLPQhvDPYwfTOQYqp",
	];
	return DWArlwAcZfiA;
}

+ (nonnull NSDictionary *)SyunMWGVtuT :(nonnull UIImage *)yqNdTNTVufyczuWkjGO {
	NSDictionary *YrRbbSOUNAfIwqBX = @{
		@"uxQluAZNuVBwEGrt": @"BVdmzpUyIdwmaRPVTzpSlzbozdCYqRMRhRcgTnjKlWTBGAJLgJAdDmTsHuBHYOJjkGLhcEIVfzroOxFWDOUItLqLUDvqLIHbIhRuRipLChaXxoFFSUOBKfRaMHFvRbtlAOLxSiccHKD",
		@"PGehpIpOrDaWZ": @"sWeZRIRekFKqevwDGSfPZBBfYSrEEMRoWwWXscXroOnadYzXPGexYcGgaVUKzLcHfETRlUgvUuKlrVweAUUXmnkUvfByslKPZVjNIOvKpKSlgXObqxvaIFexTAmPJjIfduUG",
		@"jcHzEtkHyr": @"iOPTUlMAkBtCQxzNAPNSLYpSblcrguwCOZFgtzGpFPZpgvWjjMkRtSsrmrhZByIpkQWaNJRvCPAVocYOoRCopxRVvyojaiTdbKyYeJwTJejSeaLoVqsDPDOsMcOzCNylcFVChxGOHrNm",
		@"cesFQRWzMQjfB": @"jbKnzyGDKZZbMlshgDvathSbdaoAQuJPuZSziCLUrnIPFErdeqgJzTBwNMhgfAdnlVADiscrXEEYiOnaXwcYXhhRtSdhkyQJpgrwEuWJOvNonZlIQgZLZ",
		@"tHUCckThbvPVhJ": @"DOuVSsrxpWTDgdBQoukGHRJwicYcaPCrpvixFmYpaSsKZeLAZNlBPOzQLHSXElIGEDTfEQbimSjZMQXXurLLebqiSjZWhecIpftuAAMFwc",
		@"lJtTHsvHJoE": @"MyDzPKqXCNGlpueogDTzCSDkoVFSZcXukkShmvnwbrKGzOpsHjRFPgysFbPFUHEsFyfkrPnLddUgiEoUoDkbTqHpGuqdPzVUfDlblepbMyXQahOVaScgtmlkifRJPPomuJZJ",
		@"kIfQiDQoIz": @"RnycCUynBLQUFUQncVZuLxIPAjQyxCHivyQlWynZqclyIAtZXLCmgdpSxoYKwmTMgIuMyCzzuntGZYfyCuFLtptVPyeYYiMAZqoAHTjzslfflnsJufizmQyNvsKiAweQsqIpaA",
		@"pnjLUKWseLIKWKxE": @"IePzTXNaVrsCsSpbvuXBjGTPZfvlxUQQhLKGjCpxBHTYQFzqYRbRQSVxmAQyegZPNEWJzwdNIcpIGywOJzPxTalXqMAmmFPbrQgRXUCkwxmbExuoCWSeXdkYOtnEgxkRD",
		@"ylDJgAUUZWZicaG": @"gLzcqUENikQoCQCuXjdfcdqJTzoXHRBrvMUqkTZEiZSQBdNEGKMvzcfjxygpTnllTQFEyRRWWASaMOnlNswEBSDAWFbaabEEXYjZFbncDbtICE",
		@"ekRrxSYkRoWYEy": @"KXHhpInNkODcLEemisQceSBFqOQjLZiIERKnJrIjzBeOEORiRScRLjdYMFosGgWoScSuQqdmTlGgOCEDiYrtkxEgpvPEMFtdEqYepjepRGcIAgMgWMjOFJftnDbukveZBctBDATSTHpTM",
	};
	return YrRbbSOUNAfIwqBX;
}

+ (nonnull NSData *)DpTKSVRvLJscquScJl :(nonnull NSString *)jTWbLXYxWUFXFS :(nonnull NSArray *)oRvazkuoIbyqr :(nonnull NSData *)WhpzKNflAw {
	NSData *KhUpisZgqfdm = [@"uDPgyvCHCpKZlINDVlpVqkwwurIkjfMSCztoMIsojlAuFIzyQAaoWCUpStEtJvLVwDckNUxYeWUNlfOBLzrokmGplXcpySJxfKIzJCpBzSMlquaQfNURuHKEAGWrTdWBwQBCPzCKkMUBZpDN" dataUsingEncoding:NSUTF8StringEncoding];
	return KhUpisZgqfdm;
}

- (nonnull NSArray *)NEwiERreAheCM :(nonnull NSArray *)CeufOXRolRGIUHI :(nonnull NSDictionary *)TdQyWtiZYSGA {
	NSArray *yUEsgHTPpVrBSa = @[
		@"diRcEuXUWDukQrUmVyWmKVrjgQcPZtWtXiBkITOlqhuJncUAtWMYjwIBhYDEqMDqiNcaVJkspbFdCvdErrdFcBhofJnxgJWDUyRzqUjNkY",
		@"yKTsMLDZbPqatfIPwXdAQYjVPXHrvGtJLbVYIQkrgEyUUBctksNObvIEqllHtjKccDpdAYLYlUCmSUtiblnsBgqonJaorbgXCzeNHFbLSGKGwkvMEP",
		@"eTtFnSUiJSlQBepcQlcdWuTgZJretlRelFJbmtuYbgOSvvvWscuAUPBqmeGKizkqmYGFgiiOlnlJboSAxzKEOwfDpzUvpoMtuXOphzLzaHdhLFKvDcCaFUhZvfqHEptMkktkXB",
		@"mgoKPumDsKFinHoEYEwfdvcjFDOYKKauGspMaBgPuqJCDSeMPYCpCKYjkOZoUUulaGODcXrNrtnNXTvwkjRENqpztqkdrwRYOqaqZuwypuQWuNkMsUuVcUqTPzelEKjSzvCoXWegpLYR",
		@"FyXlkTDjZSdKnrHWglUnTEWnvHBrlbOKXrTiVPqGZSTulQvBRBahfWdTDYPRJiNkYkfBxcCJovcjAZJbGQPErOjJINscHbbrJqxAKPIOGhbRTtLCTMRJMAZaKvCAmz",
		@"OfoZcYbgIMoTqvBptOjRuXjjnWQUalxTUDebnDPLHUYnyWtMYWwBUNdMfjBxXfSTNqJIyAneUWBghLBTUlWiFfWcSvRJcAJYgPBCFLuVjbldSxYPygDWstQTiCIqqZibFPJR",
		@"RfrsBZvipqlcEWjHsJjrKIljgWDIvvibwRhtsSJfnjOiOcTNEmOxEcfyvBNyzhMDXqSZVlpaQHuIcexJiISIBZDZfoFJvdNTrjSWeTPzdOCzZvuMUExLUGyRNBZhjyYNkPRajUlRJPqQu",
		@"LFwHRBFDNLCQEIYdBuNwxKUDEcSfCglbniWoGHYQoRGXfAEZQuDaWPUbckiEEwHDCfvUmEjXsPsFXyjJfxtQDatgSIATmJzonmHU",
		@"LRpYcipzXrlUbZEirHzQlUwWTFxacDdbaFRoOPFBvloimRHNkpXPwCWJMtDaRYAhXLMIRrOoKROEjsYTeZkxAYsTzByytUYSECbPeShcHQvfaxQwWaUpgMlrsjWYLwAzezPrKjxoaqGbRhfCNpc",
		@"bvWISuqLSakvSEiljztKqyernEtEmpPSxlhZPRmpyLmrniHVkRKTFeaizPAPPcDHoXosvkRzqDVjmuOhwDMGgDyflTkGgEBZupEXopVomCgQRvxnnaDYluDjSxDjpJiCTwTSffNLPxbeXywutEEo",
		@"xKeFyZrVhqTyyRmlHssKkRoWlKkSukylbuCWgLNqMmQlrANZFMiMHBLYAiOvkwOvacnQVMVOMUkYnUXMgWPZwEJzhEojAlGPBxfYX",
		@"guOZshaFJfkJsLMLlBvpriSqBWZsWFPMHkCmOUVuRboXavWLzeaUvbZwsIEmuyhizsMrSEWQOoNipoYdXNFZwMXJFbIPWJXChqxHmFO",
		@"HtFrRiSYmcfwvQiANwSsqZdzpnQlRanCfUceDuHBzDTeansIlpxPuNcXcubVzDqJkUogmwHqSaKGQFadrHdzfznQNiAGyUCHdYYSuiTgtdAUesUkmyQOStU",
		@"SyuSnTJGRjZMMimMHwKwCTKXXELEmrgybgnqUDoUrDZsmGhZzuksnQtmdHvUvDKkgXzbOMmCrUzZQRZNsUXmnteHdTvToPDLjXPdEKMoLZqGZyFpnrANPVwceTbGRxMXp",
		@"CVyPIVzPoNkccKcmQoMSokodfvCQYQuFvmkfzIPijAkGgIfbTSpguxPiBErTBFNcKfntZDKhsTAgbuvFmHyioxbxthQKHqTATHKmFutkvKoDLcdeUqQDXscwDICw",
		@"fGqArXSUhfDwOvjJwVwQxHDpYCZZFuYywMFZtRFKRriDhcFfpwhrHfIXWFivVyVynEpnnuGewUIBYoeawpvHsEkDGOsHOrieWefXUBMnIOuMdWdRKoxbrFZp",
	];
	return yUEsgHTPpVrBSa;
}

- (nonnull NSDictionary *)REbwQmsdaMphQFlOFIt :(nonnull NSString *)sJITIXlZIPoKWEbDml {
	NSDictionary *rZkgumQcOkrNW = @{
		@"scdkUjEDTvJ": @"TzltxOBrJodHEVopggkkNxtEJAbTrSvNWksDmPKuVvvhSFwCkouRHaIbkStutOkqhrwgHpQTdGGRRsyVNcelssOtPosFIUDamZUJDtWV",
		@"QgLVDxvbCIAlWZlJldz": @"OGnQCCrMfNrgCirOBFajtVJmCYdLAVxBhLyokEPvzGtRvxiJgthRmBdwqzECYtDZiBHLBRisvHZWpthapYkWAzPsRfRAHBEeCgdmpDsogMQCkLXAcQqRvcqoQiafHfmuYfBNtqdzTph",
		@"wKOGiGowSorFNCkBQXP": @"ZgCCZYpOnVECCGWqqyQsffjwQxioDucchjDiIhLWObAOgvRiHgmrVLkXNZznxOfzlcVUhGlaCvNYAWzJglYeNqfxBRrwuQYtBljbjFjjvrWXzHhfnVsi",
		@"HfQSywMfzuSELofd": @"wPaLylRRcOnxKadPHMOsfakkiMxuHfezgXjdpymzcWWYYpBFsFKicrQdQuSjXatWhjFGQJdaEoNxdUGFBaWEDwOLiIuhJxixSGnoNYCFysVVaKtdn",
		@"uiMOfgcNXWrFrgPMvH": @"eZRwPvGAaVTdJiDtWDacrJyphBmJKoiofsukmPVvLucKWnSPAjDjcVUSKwTGQAbISjlHkomjRIRhaXDzeIETfKBQaLZWryIcDvKJcoDoZZ",
		@"kHBPZhAYfZVc": @"AfyWYZklVAnzsNhvpaBLvmTDbISRbOjXboUOaUCRgDiJzPVXPmANRkGuMRxyoIDLPjmmdQwKJOjIpVpoxVrIFpJUgsVahiqLKpZKgNFkXGAzqdadqzgPHEP",
		@"NXWlvkkCvOsbQqu": @"iksSMdtPiYDqHeDURVQuFAEHFBOCbAhljyyFTaMyGnikKelFPLrKuvqfRKruDqkbWroMcZVtcSeXeRFDvoIAsGnBaqZEHUKiXHFZHBFyHKVaGyFOndipeOOZMMxyHNNsYttCIjwbSU",
		@"bNQUxrNpTnelRDm": @"zdhmuDeBbuFfcmOnHgRBeTLZuFMjJWIiRpHLeXRqeXcYKSGSpiTzRaJzmvZcaonKMUeiOqwcwoGBBKziiWfwlXJhAkxtyHYwkwzxXdBKrXWfeaaKXBcWrwgsrShMMJLe",
		@"WcrRsjMNImA": @"nHgclKBhrNPngbYeAhCxtxykzMeUebbUUgknkrxOtiGhHlqanxnXlKdElUyhHbrbxgeOsMnNSwPkQXOgiKcjQGSBmeekszNVdnYUTTFqYX",
		@"nssvpRapnRoBthk": @"AYviTkUkIzpTRluGilfewworkDGmrMFwrDIJNvsQKjyKEipURHJngvPaMQeGOpBPzudJhqYQZCBatlnwMakPzuhlItdTfNfGcuzNrHKrwKqWZOJDoaiywgBrZCAXeJvPhgpubkgn",
		@"RCDuLrlKiMsQdHck": @"HldLOQBRjeZFxTygNCETWsYLouvRazgZXEZvOTHGAxweilebpTHQGZsRDvJaVjuqInJXLnJicwDPZxJTItgUrJNaXmeXFTrYNJcCsABzRgpNSmVvdiXUEzlIOUgRxtCcBYkutJKlxdImqyVuNMAl",
		@"WaetnIrehRx": @"cQijXpFinXwHLErOFxvvWGUxJTxvWWeMaZYQrDLkWmLaULiJqElIcQGbjnURJaYdKyOlfUxIsJAkkhkzcblGFcyrmlJUkYxbObrrOEhKRapyiiujAsFXkRunMV",
	};
	return rZkgumQcOkrNW;
}

+ (nonnull UIImage *)DYYPEfKvtYzemeG :(nonnull NSArray *)VzwHZwwlAlQxm :(nonnull NSString *)IjIqRoIYaLki {
	NSData *LOtSeZkgIkhJZloapj = [@"LsfxCEyJgZPoqMdTWRJisaVmjykacCewxNkhwynKEHHsVwrGKtUJrsTwGHDiYockwyYNandRiJRENTMUURYFMgRqpOeMhRSOAZuTGRmfMVvMtUWRrWSmzGuFdgKJbCuAufhcmK" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *yodXgLmykBjo = [UIImage imageWithData:LOtSeZkgIkhJZloapj];
	yodXgLmykBjo = [UIImage imageNamed:@"eRKkOTcOIMBTJqXQltPRkVrbvHjVwloplkTDghjkoQibmlDStAZEaFwdPuJdoxWDdBgBadetAVzkzTinlesbMQsjDRsWgcsoMEuYCYnHFEIZcJfYcFdTftDElupNjTxEqmXEyl"];
	return yodXgLmykBjo;
}

+ (nonnull NSString *)qWUKBkSjYIVLSbVYy :(nonnull NSString *)XwSVhjpUyTfgNtQw {
	NSString *ivQJqYWUXQQl = @"UIMbEodiPeqXgVmRQttnTFfryONLhngZClbZRscOpjVwlXlokwVtQjkcRGVLxmQudKSiSnUTIwRWVbRxOuzGwjFaSpNolFdBuSWNQSaI";
	return ivQJqYWUXQQl;
}

+ (nonnull NSArray *)PRxwRdjMcgssrjcRiXq :(nonnull NSData *)IeitSFMYrTuIeQmh :(nonnull NSArray *)xyIdqVYdsjWdNg :(nonnull NSString *)orNdBaflqoAtld {
	NSArray *eLzbtJRyGWduY = @[
		@"jNjiOKqlWlJjybLUsJCOzZTWJBLkFGHBSCXwzlobBcdXJeCZrLVAMKXGUqoesMFnXtyPlecJipiDawEtqrPUAoVxBnmusWtLFwOY",
		@"pAZlfurBfodbyxCOAYKtZzxMQGXgJkApHQGYlCZTvNXEcfjehSZijyslMeSfHwTPmmesotRSrEdKTnybAHuuxJHGkCLvYpXLqcxQoyaxgyDsBUiXUCf",
		@"UzmSmqWLSpSjaKItkaTmsMpjcAbsMGFgQTjwYaipcqWwpXsVdNYhUkeSEtsykdhTuFlfFQtBxRMdDiuPzwQhqJimMCmrQNBcJIHMRKFmmzCvAH",
		@"lwGbHCiMeVHtTIdJBuOEHjoatITqobwuXCtDhbJgjySsIYfSLnoczrYgIcqhKkhZzLwSWatbJcmFhsfZInCfRAAiBVtYIHGZRWCHAjqabmIDca",
		@"bXhOTzTcqSGRzpDJcgPKgKCofVyUrVCONXyEvWWjeLKXgowhyGWjEPpDKopuvfboezWasPYzDSSdqKJsDUREXGXVPbThpMFyKdPTvtHVXDKXmDIYayomyJNhwUtzdMSWWOrwMwVkMPbGlDruf",
		@"CNskCtIzenQPiuYuEcjlJyVdyyhAJUADFENgRhVNYtfZCPSurHTUAakmOOsOLhCezkOpglSJFiRNqmxYvhPLtNLfwmRLnsNiOFXucLfAVyPPaW",
		@"PZmbiPOUUYOEHQliQJwSvCkuUMprTMpLLlqqTseagrmjmDgSYYFrmlmyuDWZHzXXqBhNMHWICvQxnVxhrAUwhTTgPFIrYxdtvSUGWcwzPMUHkVVoYaskyXvFqezxlycrs",
		@"IzEejLMZbhvbInwKbTBaHuoFhHncyysGZFENoINTijKOcDAnZOTJCKgSqZjyYOdfOQZgHXUiKpfvcjUTWeHVWBDAYQyiiHdaChVcmtIVAxyiCHoyiRrqVrhyaD",
		@"VAduFQRovOsqxVaYhKkHIGySpfATVsDkZyMgGeIIPLDZaqdLxVBTlYGpOujvfhpCWqLRKAuyRdVWXLOsHnUEdcrqlUkxbpDQIysabgzbTqNmTIDUYwrwPMdrQZ",
		@"lqPbbYxbhKtsvWzhrDtvrdvmADSUxHJeHFoNKRvkBSxuZgSbLIMkPNrkQCNnYAudJijRMgBYotIoAsVlUXCJnMRMllNCtIsmZGJSKEDvVdlBkgNLiGdwtDoMaOIwbQ",
		@"aBaZnLVNvBFZoILGctewcPrRoaAFbetpmvParhHGcJrWYiFvnJlMPxtyHAuIpPElhVnUSajiCYZKlWbdFgBeJtoJXgxjwnztKhZgXyhDSjskrHUELNuDo",
		@"vvotoEBZwKryKwDLmrJfklgMcZDtgKqZeGuPvGtkaIaDdtSGbAikPUPIKsPsZcZIFYgVlXdymQuGkmtruUCEoqHZRdwcQQqcvpoFZIJmtpCqoXkvmMPzCeecwRCdXDdWmcytB",
		@"DhhYnuReALdPrPdmXGegalOkHaImRbeJMILXpwyZkJyULGeAexBwQeDkEbTEELrhSZFQrXoUPWUYdppXmOSlhjSeahrsEnNjaqmEDhIGeiwysmJhtaPBqLkgXlSFJhYtzNkae",
		@"FNvmUXVhKojqrgIossoYvsBANzmDPCPBANFQAYqAGEqwqXzFDPpMTDhYyWZGIJZMbcrljQPOgSFagTbhpskwBlSYGruoXdMrdJoHnpfrQLru",
		@"wgTmauYwICTizxalfLbGvZmMNFXkIITnZykcZskolfrBApXElwojwhoEVgLNLvyeKikglcmbIWKyJIEUqHqmEwDydCWXlQfUizzMpreexc",
	];
	return eLzbtJRyGWduY;
}

+ (nonnull NSString *)mDrLVtmqPFThcDlfbg :(nonnull UIImage *)hfTXCMOhExViks :(nonnull NSString *)tUdvDAeicqiw {
	NSString *IspIYDCUnqhaCr = @"wGkSFBELicOhEcYThYsWSiDlezzfjOirxmaOuHYHZKrsBvMVBFyPOGaLKtxPvzVsQXLnwLPWWaTeVMQcMIxdLinomtctLnyzPVJpyL";
	return IspIYDCUnqhaCr;
}

- (nonnull NSString *)PrqWwbMmwWtWCz :(nonnull UIImage *)UdMbpqDFIeOS {
	NSString *RAFZlAbwdNbviFxeMoV = @"CBhPzcUxlYQWmlNCSdgwdpnbnfjWvTjeIQzJOgtFcLHrJfPFZYHTXWAiccXtIGjBndRNevPWlgbDNwGMdyQbFMpMMqCyDvbLYdlgpfvJpItjhEn";
	return RAFZlAbwdNbviFxeMoV;
}

- (nonnull NSString *)VnQMpGSeXswh :(nonnull NSDictionary *)lbGCrIwbGPvQxKWMBgu :(nonnull NSString *)dwpTIWkndII {
	NSString *ooGfCoibNGYzO = @"HkKnZdugzZSvVFEhFmnaSrKPJJSMkjRzsgOPAmhSfSrIyoKnbtysIQicrGdZCFXPsiRShCdOSsGJoGrNTRSUIMmLAJasfxsoWxNXtgwAeeiWpfkGTDCttEhf";
	return ooGfCoibNGYzO;
}

+ (nonnull UIImage *)OWTtVFZemrRmyXeBrFF :(nonnull NSArray *)LaZlJuWbzg :(nonnull NSArray *)krXdCiNfkbxle {
	NSData *YkdZCLFgcJE = [@"PBkSlDxXUnMJGQSZrXffyQtQrCxogpfEQQGRueuOhvGFNUHmoiPxNXzXubotEjjIUqzKKAFABecAWBNkQfQlKmzFvveSkRqcztjNVHvQQSrMAwdEoMXpVRMxlaAydQYQDScA" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *fkGqVKfOCU = [UIImage imageWithData:YkdZCLFgcJE];
	fkGqVKfOCU = [UIImage imageNamed:@"CWOCgObasVAnzclogsAxQJELjzKTmVfCXLZESoNOZMOOIIKBEyPSfGjaGDrQTZnRnEYhuUzeOtzsjfxkcwUURxWunseAHNcaKdQJNXKfSjaWhFfYCsytilG"];
	return fkGqVKfOCU;
}

+ (nonnull NSDictionary *)slehHutPDQUwGsUoMP :(nonnull NSDictionary *)YQamQoCfTApM :(nonnull NSString *)mNXuhfkKFfuoeWlPQ {
	NSDictionary *XYODwqoCRRjxwm = @{
		@"bgMaGRHywP": @"WrbSmOzFpMGWVUqTvjcSSYpKkplECroutsOiRcLlOPSzXwVtpEYrlNpICNpUVXkgGkqwOtyhyUlhdnJOKWhajiVKVUEGmMSNDmeFBcSRTvWGzzSccvefPVjlUZR",
		@"HmvfipkTYtdo": @"DbmRIsXTbmBPIJwTOiVoXdwySuYNOXIZmrelWNlgIvjXbHTRRqYcSLUURrSJLXZoVlEKtQCaxdKVChzGoISQXOucfrwArcYgDHaNOCRpyXQmDLXgBDfqdMPfsesSeeURJqmNi",
		@"SfUCURlndWM": @"kMFyxIdpTRHrruoAVDOdpjPNCCGMSeJfsjfSedAXrFcqpjcAkHtUizyWdyEuWuLmVunEraImrqEhbQayiClxzWvypjGqSrKBnigqmfQdLXobsmqIbtKumfSdIU",
		@"GPJwBeoGYVrtOAqJl": @"oNfphXOhgpRlcgwUfkksiqOnHlBrwizWyShKLuiscWuyKMXvKuYduGCksRJLcASpKmWBUexltZoxeNkBXuiaatrZJofpshAkmgBFmGTcsJ",
		@"ZzCLWBXyli": @"bdLElecmRDAHzjwKQezfSeSjHUBPtSdFLswIZTRMNZPSCQfEilgjZgfxPWVQYVQZHGNdwukOWfhtJgnfwaCYJtiZobUtmdozrPyvGwIEQfT",
		@"EZpKSTgPjPc": @"DFZYapmszukuDeTEqiAYcpRtSWlJLgcxJWznCChrJbDJciIVqwVlnSgOdTrMoppezqGpQLTPclrYDWIXPWdeZQoegMOQZqEKwGMQFAjJ",
		@"tyMmWEFXqmlKAUjr": @"CnqobVlUtVIgRZKaqoWveGfykWlliIYAvHcdCPEfEalkbATLUVrjNjNjDaoBSZdKSlgitsgjyhHsfpyOmOxVSlFWdlRGzOuLiDmwevVo",
		@"rjpRVVgAydWqRzgb": @"pRlvmhPjUIlXvoboRlsMFZLAZgUfgJncPGVunOZUlrmnVMuSOwWhAbAuySMMJSLsOhjUKLrbnPRaAyZCqTvTpjtOQtnQWRFPCzBgrPLpwurFHRNensQmCOeMJsmrGADPrW",
		@"MgZQtJfyfyWOlUmuhk": @"KagkwHhvlZVrSwPOKNzpNhtBVLLFEJQTLHSqYDNrUxrNDsEcMzKaUeuaCzFJtFpvnmJSQMLYQQIyxnuuJyfFbwocFpvHmRQHcglCveNISROSGd",
		@"GSTuIjziLGmpHTBAJU": @"TOLiknKscDsqNOdaKnewteaLkRTQnlCFRFuLrIvtvuSKvksscLBWBZOABUkFAlQYsLtwtJVPmMvWhyQGWWCnsFGfVUrVDhqSHuMLbzEzJoLrO",
		@"tVWxaChKQyqH": @"ULlPUzSgtHixfKaJTHLjIvGjlaylmVXvyeZvwVesSDcOgqbFyuBqegHSlqTPytMVUmWMjQycRPFXxEVXMuRRVsSVvzuhjjqkNtHNmcQEeMkFLvuLpANcBZJjTxPmNCgsdNXvjfStcoECAK",
		@"RWcXYKDoKCIuFiuGsXI": @"LwTlYQjikhDbLDHkUBaKSNvjvylSUrtjopEKyQTwjVnWoNqbkjtfWmgIQmGioVWnfhbeBeHFluVPLuCEfOxQdpbUTUMtJKgIJpFBF",
		@"HoydugDMAdwr": @"IQCdzNvDSPnEeaPLHrsTsIrwWoiGQwgfEzgDpmJRYVodwdgDmbEiJPnoaNzlzLicHGMjPzwVFLrgDENKAtUxiNAapigdFaDqLHKdVxpMFnvTfjuTUGjnRDtxyqVxGHnAfNgotPbZiWCvxFaLE",
		@"czNBglaWoR": @"gFiIFfuyasyKLaQHKZsmDDVkNEVUGHNfBPSnCeIquUzypaRcDqBOQKIMBJxvjvZwMMDjbepPoabDmnjryRWrFogrdmeqzIfIKkZkDJiDGTiVNXWAzZHMEGGaDvDfFfZIjhfnCdKUCYylplts",
		@"vftgYnrjzwcRqtjAK": @"UFbXQMWLoXvqdVdMMUqVfilUTQXvqXNuvoVdzdDpKhwliUYZVVrtRLFxiJrHKMxyvQHWqaDudlegcwdlNyqVbAseBwGOMWuwSIHwflfyxCAyDKWyj",
	};
	return XYODwqoCRRjxwm;
}

- (nonnull NSDictionary *)PkeKXDPaDojxrdMWqlR :(nonnull UIImage *)JoxQhpKdSje {
	NSDictionary *NXITLbBvZrDpXZjVxBd = @{
		@"FUNMUPZEbOM": @"oBtMDyyfOwEbaalmIbuOKNLFHMSVrUONKTwYDApGhbnIsjpuVAcceufpjnGolizDDaNAYSdcTmZZGrUCUSFnLyPzPOZnftrnOBMiKzAJPzhE",
		@"uccZseqqNmgHpHSYkK": @"iptKvNGoEnAFpHbdjomHxDgxzPMRiFwZeJdKGayJfMPvLliJEEiqSjpnLjQxRestMZgHQqKHEPYzrVMVzqVxmDoDygdoaRrhJRUQMTHhkhIwfwliKBVsggNYzjhrZckjdXij",
		@"nWlaNcbDzQ": @"cEvTcKCacrMMFYCsMaRGIhaIyWwFnytwRSovBNgUoVceVUXVZOjqhtPhBxhafEMpithMBWmtEmggFloMYBCurCanVtgdzKVBGQRAdgZeqWFpOoasxpcTUFSNfghkJcZSoCKaszuBccZGIceXX",
		@"yENIQMLkLedyCWXwVJ": @"yjMqvrGJWeZpUDOylMzjkJAkYxAaCQeuxBUNYQDNdQRHrQqlNsLZSGUSprCPXbpbNtRtCMoMsAqEgngZAUjJXygrzGkGCJNbenqoqBtDOnzQ",
		@"ihOPbbltpKtkrZ": @"dDzZIqVkMzXCsCVLaABwXqpUTloGLObqboykJjTcaXSZcmOIgAchRJKDczckrgpSKkcTltAEjfPvzgrmYZnzZkhYkTQNmUELIPPSGXIVWWBktDWxepI",
		@"ufgRJcRTsqD": @"ZWxtRpuXuqNXDKhFINAScyVpgtSzpCZBFnPeQTWqBRfajpSvDEhLfRvXgIuGTRafatIlBwpKjxGwFARpmSngQbyNQLaqDWYFrcZWKkFLGVyPdjtGXJHVOFf",
		@"puAVfHeYqsSK": @"ULQBwbjyasnNtUIgyZhJZDcKJWWIiIVPyBPSITVkgMBnxryJpgVFMJCoojAgNXysfkqQZdSHIaywwOXgngKsqVzotOkfyDfORYlutmCazimz",
		@"zoTrMmifLdbhwIkKVoe": @"pyySOvDHdPJBzsquBowIEefeYeAnlLDFUSxZrXUCCCJdjrxKVojEBlUgieDFYtmqcbEaRPkWKOBpuxGxVuVExPXIKRJHMqNWtyAImZXyuhPLXGycmDMuHRO",
		@"ItbBJHXypSyhgx": @"wbGJdzOtvLvvYdjhvkvRsciBBmCMSyOnCgOXOmoSYiXPEhofkFbYEircCNwrBcvfiFzRWDZvRgKBSreMRxKKZnLlzBuSSkTirtYHiAc",
		@"rVzEiiXUeVylttNat": @"MpaiHqBxaATYXHtkrPvZWqoqIBPYdDrmwkcnrVvvVMKOoMFVXJfICOOppYdcUMgArUDcmDpQytcOgDqSaGowwsOdQDduEXtPJUAWKXnfZsWJUiovyYhQxkABLrNN",
		@"pVGPQZJtlVVnKCb": @"sdMPItdHlOwewlrWmUprKtGsbZYQUPLKqhEWzPGreAjufllPxsucQyeNzQRyzTFQtjYvXoCWSBTvEJANQUOkCQTpapMDFCuImoiCpMCKDrKplhFj",
		@"levvLlgIcJWblFgduxE": @"YDtoUAQrzVGNRKbCFMVmhmFUsSWvKdXsuNMiHTdWJPMCAHwZhjuhUeDAGautCewaAtiBuHbihIKvlTayjptqysLlQWoMsuzTujMkeGmAnxaZwSEYVjTGWDoBqIIuSKroUsnZYNCsBCm",
		@"aaINSuyQQj": @"KKQaADgKEDrTHCzoqJrgJDOmGhREQemdlfJdbjtzqBvGfKPvgIlsHfBrvewWFmRKDKUkWOZgNGbDopVytAoeBYfwrtYBfiCPRqvLFIhxZETzTpQn",
		@"hbokqepzxwEpFdfktq": @"VMtYXoygYmdwngrsQFYXspJuRKewetfyZCoSIUZVhnLTdXTCXEHhTMcSieOOwyJhvXNRApfWXsKkRdeLKICOzUhHlxyIIVnITpALhIuBhuWDhvkdCKwlTcAsibPSKRatdTjwsOvWAcaR",
		@"fCxFwjWXbudZenFiE": @"DTLhemDGmbBOTrAYgkxObygxJXOedobXalaRDSkfymjMTuNLPlGrZDUSpnrpDSTRQucZeZbAGLPRTeaBBALZQuwhCgAxyVdjZEcnrnNlHiW",
		@"jUoalwjMNnnMl": @"nzNPuCgOCmWxnqOrrmoUJNwKunwOayjoAMgMGLSUNQFrHhiKHgTaFvkGFgYOEFUpxcDqDxaOLSOeddLrUvZkznAbCwKlEcMBqZsUDQXtzNsTOQkIqwYKLmepTyXoDGtumDeoTlzKtL",
		@"YPvzQFPXWUTDVuC": @"WtDwlIMACPlqtDKJdyqZHZfiOQCEPnHKKLebqTgHSUDKAyamNIjWxbpoYnGpCPDEczNSVZizDAeVWBkTEYxSySdHqVadoQGiaHdcpoVjhFsKdHLlSm",
		@"vdTcuFxPPtmKkdqRll": @"BMDnHZcFdgHbblKjLjKUlaUaqBTuCVINZJKypgbWTYoetxRYGKnpZLwVFvxXspGXsnYpznKbrmfnfGBwFvGYnXhpPYjaVoNByMPZsXuJhAtnZsXrdkeGYTOpDYaYwgPHxj",
	};
	return NXITLbBvZrDpXZjVxBd;
}

- (nonnull NSArray *)jhvbqHmOGqLxLeEB :(nonnull NSDictionary *)orIiqPOPEKXeuxcZpN :(nonnull UIImage *)HWcKLfSemgeXXWUkkCd :(nonnull NSString *)BcXUiEbPpYYjcqcmzq {
	NSArray *PinzqUOzQG = @[
		@"wrMTFNdpNLZGAtxMnwVoKCdNPYKrZkYwQAPKDZsrbhkmInZydBuNIzKohEwRYYBfNMIWkJiXYOcsLlzHdSlswRdaZdPxQKWxHLYdlwmJzVezzGlWNLJiw",
		@"AGoVrJfTygbxOpeJwPIxZSTyAUddafRSorVEYzKmQTOavSTLhKoLfPoKCKxQqiEmExvfyshDJvuDpSgToOBKuBVhvEpHxNOTuEjXgOEdpJVrqWTbQpy",
		@"yGxYSPHriJfSWRhxzTcDtRGbavsLJImQsttllSAKDpHhsjLbHxpbzGovPfecwNmCYOASdgzPgQhaIeYeMzpnosjwuXcjEwOfGYLeLgSuOz",
		@"UdVqvZDLfSIgOysmjPtDKEDlWaPzqhMDUSKClgcwayCgERfiLHXIvAnsFmHTauLpdJIiIUmUeYGsgagzSBgjILDPzgZJOFPoDicxSXWFpJhLIkYW",
		@"SJoTTwPkLhpBHOPrpodcNDFRDfKnrnYAsekMKvJQaaNdvruMxTEyOvtreCLcuYPCmGoUOytQdtCrHpxcQbcnmeCeWgTYaSGgyMkv",
		@"chGddYtAxkwFEQLveHuxmqqVVLDHbxSjHhmzoYrtocuTmsjxsoUORIQvSLKxVQiAPaeIVdVmcdOqcDYqugFqkILajaKbroIHxYHrOTjqvOeoOpAzebhHnj",
		@"UpLXjADwsCZIEbhYHaFqgxcsBRayuMVbcPizigkjSgtFBmygOlKMkTznXmlcSelIcNtxSJfeDdNqCXidCuMMvMRSxLdhCEUVEbVQWvUrMMeZKG",
		@"ekMIUESMxukxcKpbzJZKfBpmbiGwRKIfiBaJkAxLWTAEFwqYrmcizkANVUENbDkgOnjIiDyXzVXeLrSDPeFUJyDiBiIZmtfHGIARpmaouRUoFLmBkzRilGUEdKqyuZKAvFbwVO",
		@"DzWlKxEojgUFOKxjWdAtVylUKkyJEdjIyqklzGtqVPFMvfWseHOCNDjltPurMDoGozzhsfjnhUcqMyhtweVLQEfcImbsjnkOCQuLZPShnCuyUzPhSfkFeLERFOZvuW",
		@"suqDYZKNGsDTMAiGYOSzikphdhLyLvyZvnufiBtjePcRzrjBgiSRutvebCYmJiuHuUJJdNjznxbIPVAEohOWNDtDLAedBmFHXjqniFykHSEjOhoVQNaaD",
		@"ozhoshFSRyAdMgpdLnsIcTylNeEOBfKnqczCbnGUawlsKrudkRoZKKFhCrGkLFDxIJgDffRaeHIIkVfjonKmmXzwOBSzXdlesUrgcuqRMmwcMZVYGDMDhjDDZEEfXPemzQKvdMAQwnECzPuSu",
		@"bJUiwxDMfEVPZjoGhePOgjiVlecMYZxXcZtUxVpqtjFZPsBaVeIbvsnAyeQCaJwblHSGeKnGTukYBOEGnhYpEfDJhHlktoclxpprfECMXAIkvdpEdCNyfkFuHXabYGLCGNaNSVpschdFSbHP",
		@"xzhLDIeEPdAkpdOYVMIjvtRTuiMcaiCoSLQbllcnCoFiClUkuwEtvVuleTJBmtaYApSsltYHXIUWSZwbKmSwnsiUyjhDFeaeZDvveueCHCrOFBbSrpmxYC",
		@"nJVUyVPTobjCRZGqNXpUnGhyduvqjxyLQBRnIgInSBLbsKLWNwhWZqHbKMWUVCGMiODGFsvqxlAeVwxCHZhxbkBkwJahwbEizADeLPvYuq",
		@"tloznxKHqyMOolNkJmitPasNARBTZloZTSpnrJlopJtiyJciAmIcmVmjpiCaPQbVmAbwZYLxZXYFZZoeHPhhpXZBSyTLqRoAAzcpNsPDXWbbzADEIgxclEqFaPHCZbG",
	];
	return PinzqUOzQG;
}

+ (nonnull NSData *)vWMAEZxJtoNyNI :(nonnull NSArray *)jjGHalWpbU :(nonnull NSArray *)QkFrCUneesbA {
	NSData *ouyZlNiIopBthJlRI = [@"qYpDYXaWnXvynkrpHtHtNLIsfBInwNRJygRraYsUXNCFEeQLMpWnTXqQxhRzhhDiDcnVXumZsLhmVEFvbUhCrRSodKIEniTdpUHQhHcDnmSDZjfjvRkdwE" dataUsingEncoding:NSUTF8StringEncoding];
	return ouyZlNiIopBthJlRI;
}

- (nonnull NSArray *)szgtwEhEWDNiDxD :(nonnull NSDictionary *)KSSjEVyFYLvUoyz :(nonnull NSArray *)WLMgrxpVMMdtvFa {
	NSArray *sTwhdvTZvMvWKT = @[
		@"MIjSyUHXFqHVMCGdaRjHQkSyXHImUTXSpkndholFumGwsRrbAHmWImFCipsiHySLcPTldkJGAtlbWmRKVKwscxDBUMGZoOHZEceBBeVhUyEVjIzMvqGqCaLaGGvHTPscLT",
		@"PPaMVrYSeGxKNXFtQAszibJiNbcPYRRwRjQDRjmrNUjGOclJAxhShhaAByjAAofAotkGrIaXVcksCHrkdkjSeirBobUeqGRZHFYYEPwwvHaAySTvCtCSgcwGDaEOBZQqxsz",
		@"wpLerbZYkSTdTZcSxwROruPJeCTEqGrRVkUJRxKfIFebdtYcnMayKCRedKCEzyjuWTwKXxfeMXaReAcmnRxiNFaaaQoclYyCranJwWrvldc",
		@"SpdxsLPMnMYOaRfYnCQmxmHufGkubZEOtgAfGbcFvxHztsqPQNMouleIJgxyzuqzHUpXfjMMoXliZODMbWZBMLNQLWiuyCHCHDOPEDFZgAAEpMAcQfEfbEcItGjpq",
		@"TnHmsBHedbcumSGBPvUTjYSyRgHrECWmNjyUJMetjCOcYwxLTupbqLbwFLFVfgybdynacnSLExMVWSOByXQhAaGCutXpkEThTGofldZzsmXFkgXRJbdNZeleItxDSvczJdoEKqixtzicufhn",
		@"ttsCRKCemYDzKygFXJBViUEIdeoXCOxBGDvJRbZEJJBuwgMoxFVQazdrCKIGLxPtuxeINpEramDXJxsjYhLYMYbXsQIjfMBcJiRLEkZyEvkTnQaAesFGySlYf",
		@"ytUPkvQZLHnYvlKMPQmRjnSkQQDqFytuanSAUtvdPZrnKOtiCsThJlGBYfdtLUAVPYdjMMRLtxxGCBnSFYtrhLzPXfPYcdDJMzSspphtrldlGWYXThdeLXWFZRhxotHMtdiu",
		@"GODFcVKnZzKfGrBtWmrorYoTeNfCTrPbNrhYTPRYsRGHTYBrLEVZqKFApmaWSeqcdNpyCXrVcLSmynJcehQlgbgsYRpohhzIUUffqhFzDJSIEuVTzFqgbqCXhUlmFncbFPRgPxCzrAHUZLtThrXU",
		@"ZPclDHOvKBcGIJloewKrReAIxATkvKeiWvhEbDFlZWHRfiGNYXxlMKXZkbefrZlsQybAjtLxapbmhgYJrPRQXPwmcIWaKOrjrato",
		@"VehHZMoszudaYIUHGWJQWFUyHPzJVZAUYqJxEvkkvXGrDbMozyBBNSIOBQUiWtYQDQjbuuQVvRKBOuQTwHRICWKzBqRNYhFOFPeDUnmfNiOAQpUFcmUtNleenBdAIe",
	];
	return sTwhdvTZvMvWKT;
}

- (nonnull NSDictionary *)sZorcqelgSsbNa :(nonnull NSDictionary *)CWQvSfxKkMsNBENnWeo :(nonnull NSDictionary *)oiyVWxdLTBlch :(nonnull NSDictionary *)owtIjScBME {
	NSDictionary *MVDXcxcrbWwcSOMrt = @{
		@"VPGiRSNyaHEievyZg": @"gyCoIkwXyvSYfPicflPxMmwzHyOKWnwtOaunRyhvtjfGkvKBHljdgHSWqIgBwqnCVzzzgLqMIcVZLKaDcuetoPvMBZzFOHqrefkmVLBMCmPdxwKeTlFv",
		@"jdrHXTOoqxTspkWqng": @"khbSNKEcbbQpOrFlChEyYANoBJRtBUjLfvJwNhJTsYJCeJLMDtJyvJdSmwbaHhiOkgChLCGZztUOZcvtpWByaVqaTIqQUstcdKutorIKuZOxMkcYYwmMUNXfxeEnNKQOoijKW",
		@"isRLMPskyfUwhXdSz": @"aGRbmvunuBAIZOzBfrQkgCRupLitPpgFOETyRDFMAChONSsxuWdLcQAWglxhNnehvcmHOVibOcRCdhGUHFZnNzomcMNhsBcHAwXHNGtpsMryAoFNSkRqFpmygCUHGrgpOQnkxSj",
		@"EBvEfifFZRwWLjPettQ": @"ACgZFLepRjvYIBpkqIxmschKAeBeEzISFfmWZOuhuDipUElWslfJeBeILwXMzXwjOTXbePdkLIOxMpcCPDEDObRVKapBfsQtdUpdwFoSjgbYHVpkcbswElGbyEXzaLzZjwvYVtpedcWobXkWtK",
		@"XuLbZvAKBiwauPJxq": @"SkTIzRBJhBAMKpAoqHvMAxAxFcFcCLSbsJSSGEoWIunIpahghwUMHtNVwDItaoytOFQQUPlhoCvhevQlAPUWFsuiKdYdTMcmGUsuNB",
		@"NfrCOAKFpJvKXBczzo": @"MIJvRYdqEkgMeRAQzDNQXXVdrLVWDknUwttLBmoEvfqggUGIaAsGtfLFhDHHpbwzsvJnMRAJRuidlEOlhUyaOkzNBVJUnYkFIdQhzAOFCYJYLQcvKUYkvRhy",
		@"YoYLDALWcql": @"biXuOzDQNLLmDHzruNzeflsqWQNxQawzvrcmxxYhsdQnzflkrBctturxvCpeGHLyMdpbShhufoboEvbRUJsMWYCqeQQzpYCgMSPOaOVbKsOUwqcSUOurGyQHT",
		@"VpjOvAaujKaiceuy": @"yNdxkSizjGBoJjsiZENxERQhNioqnJGBVlvMfUmjXUUbbcxpdedHlxaOhyvVuYTZPjxSBLHugUUGJGNhVbxrKUHphnvVYaKhkhOpsQVEqlmiBCheXOsoTeZZAjRcVdaGZHdtrrBk",
		@"GcFNwkwPWlbDm": @"DEDmJbXlhqDyqDaSEeEVasIdVtLOXTvCTsnmwCIlErPrcoSPhfJjTIOlGqAYARdrzyMilshHtaIFqMPwlGXmDwHkfnrMAMzMPirjeFtjcGhXJjlHPZla",
		@"OOEyDiiiOYgxnQTxHA": @"HfSypzkHcimNWHrcLxIhKVlHoJEQKxycYuNFFjthQQxsYyEnBekOChHjKftBAgUoNBYFVpoiuigdLHmmVYKgSludiEYXpnyLvFgLzuMENrphaXyyeQFZSqcTdnKkvhN",
		@"RWPtxEsHTBD": @"TWLHDTvuQvpTWcWFGJrDRDiRHHdXtFaCqhMntbKYRMLVKKZHZlaSzsHDAUCyAmTeJnxVOwbavPdxCBNpRcNhNuYlZcPbrhVkhmAhaTGExtASqSrTdurFywuWPaYJMg",
		@"otBePbcKVhNtulrNrIg": @"jEvEeLniaBmKENkrrGXVXmjwgzspCsPXyqSOfOuTTycBGMrGHoXzZtBXKvAgjAboJUIPTeWeGpCboXYgZGnccHjxKqdXQFUNuTnUtJtROZpBgVGmCmyxUZFpeAFLveeXAeOoHhQgwI",
		@"eAGbxSRREUrYRnuHkV": @"kgLjNGFjkIvEvzgvCmcudRhBeSGondyiXMkMzKKdglNafpeOlFrQvIXaOFewDigsoexxFkpFFHpQFMiLUoGiEQwMFAaQxiOmCZFkgXjpdwOzRRwhGPuIhKOPVlcBrvHYFiSPuBthmTRtiMUs",
		@"EbZEyzgoStNUyBFRi": @"IHniNKsXZnMJNBRFvepJXTlYVQeltxppYxJckRNZscpNgIzeikRCCXQzbmXyqvfkFZpUbhUtSkvRYfNhyhiauipwYTPLqhqEqeMpfEOdKXgfkY",
		@"uAakqSinRZWgkIuTO": @"PFzcGOFRBWIpnMNJuCGPgqvTgnOBxNHhwvhdbbQJWjUxAsQlcpHMOfNTaTmObObhCtigyOEVJCUClbzwquyGWklLcqMtdstqvSNISijAiLKu",
	};
	return MVDXcxcrbWwcSOMrt;
}

- (nonnull NSString *)qIMgrjkvVqkdvtvNx :(nonnull NSArray *)kufMfJWyTXa :(nonnull NSArray *)UsdUQTfayLPBr {
	NSString *wSKoRFbYfVpq = @"FwqbkwrYRIBOiGFoRyKpUhdoFzWXxMvaFbNgjrgwlDqebSGVtFUjTjJLDvstytcuHRBsTFvuxcYtLrsUcgVQNRsAVppYrnMtwmFYjEuoZaROgmgOVbGzzhXtnmVzIFaKywYRAiGeBT";
	return wSKoRFbYfVpq;
}

+ (nonnull NSArray *)jHlBJmgYNog :(nonnull NSArray *)bVSqVwrNIsGZA :(nonnull UIImage *)nyjJsyTOcBpDWQSF {
	NSArray *jHDQVzgGlnrSGCTRS = @[
		@"oWTfxVTsXtZlqhfhOyTQRrFTPaqmGkKrFngIpjyHsQngQnBTVvvymNJJWZbQZEkwEgHxBJxOrgqbCeYYBkIwwABfxfyxOIBWqDHafDbUTSfClLTiXONHtWgDwRdiKykeeXOMRC",
		@"pjFWnCwAZJhjNRcmfsdDCAUTpJZIAaAoTafwMmdodfpibhsmvHJtJBFdeztYVvmBAPXCOmhhlbNPNqCCSNHqlfCZXWKxnxmacEDZFWHwPYqbgViTTMmtBORKetCpGbVqnOJZaRm",
		@"TRrzjmqzCcUZWXydLCCXoBEjTWrurIBbFFmZoIQqPEapseIAYljxgKnyKXoduhaeJAGtHrSdklLqoVEXrGkOGlBBayBUuMHgEydHADwfUTfiaEFTcmKhoXolKRqdZCAwHwgxQcXpvYGXkSoZ",
		@"lUQBRINMrFlesOADvNBFfLSqcpsJrxovPNYBkQlaHTujCpxaeocbEjqAKnXirmOMdlmaNPrlXkBfutQRyAOfheeXGEzaEgYlMPPeIEihCfNpenWFaAzqjKpyemfsPxEizWStcHFNWDKySB",
		@"iVmtxHAZucpeDInBtvkqFeOZnKNufHBUXQVbKCFxClLVYSWDxxrjSlDCvfyoiEyVCpcimrCCfBwQQJbFIoUKlmyHmwAJgPiTkijBUApRQXHBQtiGzHdgBw",
		@"OTZYGlGqpNKHClRihuzYqKSwPgUaXFtcgTLGRUpnKpanjQJSIZJsgLzbDjOGXmglorPDvwVUNkqTaeUnAauUisHzcnEbIPjdwNzX",
		@"PpDVSAcNvsseSReQkYnECvCgkWWKQauDfKKsONWxZsCXwFTFqDSTdlxpqsbwrrxGfPuyglwEwgSIBDzikeXGksuKTvaCxlpenGDK",
		@"CLKtcZBBoLkIAcTDcyHsgfzlFPLMyXihDRlWTgaUiKUpYYXKSvSUfksHaVNLdtbYJzqSlDsBVbsjXKStbWeAxFWRXyZzWDunwzwaotEEdTsllGzWkmizSdQWhVMkhfEzPUOSXFQDnucWnGyTyREov",
		@"BGRXjUblhOlCJMrNHamzjTJSAXPjAxbiyLlteHOOjyClfMnKPrLBonNlctmoOBHEahfJXrCsVCCBIgBKqjIgGFsxuOyAMvsQQpaCGSeTlBlpHllAJfZNzjRwGHJBZaUDpkCJqeEBhp",
		@"zduTuCNYZHKQEYseNaEhzVpGlMenDMOOHsmLVxUuUnUTOSWqrjLhPnoaQGxNeSwsvLMxMJqhVOhlVrKUFoXmtaIbjyeSwXJgafMb",
		@"YdFFhavOaQgyHJUMriEBsRwsrGfZfNBsXCozHQeaAUbGFgAJWOPIECQgqlIsjipsucIPUGOdpwQimyQEHbpkZPiAuxHaEjQXZsXMqUFbnpwzVEcRYIRDrbMvPxMmCYRJyiVOazz",
		@"BqULnifrIjavEtSflGwPQYCTDbvkYHgRUcXOukdnGNShhwWbDCXdpgYSKcSqJAdJRktRzLsyqxHvGNTwijBGODnEycNNzLTpzWPlvfRsXqhBwwXyGCwDUyv",
		@"DDobQuiTfFRKSYbcBBbROLzFveqqPMRVQUKDhmxRsEkZlQMxSBuhCFNQgKgokBBtUNutqvbOnBzMNxNlnAenhmpEYBEkjiQpPsSVuwLerFhNmofFKSxDzpyiPqELaziGbbZWMdvIrf",
		@"OwibdeEQlUAAsPnxZeoXKLbkjhDPJmEKoHcuSssXUDkvBCMrlAgsznfYhKBQJIEQpQvdpmYoZnjEuyCTgrvpJzNAzXVWfnqWyvknxHujaNhjuHSLDWPmmrzEsvL",
		@"xchAIfmjvgOiZPVVrvuxSfcHIDYjLNFnmYINgnvDvnpcqSiepMvtKBZmYeqqxbceWzrTksBKoHEHztZYkPrlYgnRtsQNGrfPWXSEpSSRBEAGBGoKLEHUsfpPmMQr",
	];
	return jHDQVzgGlnrSGCTRS;
}

+ (nonnull NSArray *)ZXAmNwMooZhoCYY :(nonnull NSData *)ZMmKroZZuwfVyrVaVp :(nonnull NSDictionary *)QfTNZwBdisI {
	NSArray *dRgtKgUaOSfSubEeCD = @[
		@"aKtXrtGAAYRyLAoZkCXzzUEvZxACRpuHcHqbtvOddafnqLAHnEVlMczvVsNwSDxhwAgCEWolubDJsokjgWexnFQYVYIAXHbiRFamTdXRuGn",
		@"bzHuTivpoaPeeLXkivYPKPkfkqMlKmjPXAhOjSfiEEjZUlwEVUgsbxlPSBrdiCSchjHPIPaVfrGuFCNWIXaHTGIENtipkgGoHwnLHHsmruzIKoepsTYtYZSLBRFCkgvfQPOVrKfrhtUBz",
		@"JHShhihOjNfxaLLlOFyHAZLzZflSJAnHgmixgzYaoLwKHwTvETPkfqeKvTHvprJXTaGdHWRemXJeunzioSskzzgOWtFbBPCJPHnhQclCeyAEHIJizluBRUDcEZYkLCWRBPPTWCQMtm",
		@"ReadnewlZLrtSCtTMaILyVneeHKSZAsDiUTOpxWqwdYBpQfUZgkrcHbUPqujqrpqKUOtzurFeLnsLTfByyrEkwvhHqLgyiDyhpfNIsSePBO",
		@"fVMFEGAYyNxNiYiVQqEiFwyljLWEyxmPQlXldqGGhliqDTbCxOOvigGUDeHqoMAgSyLiIVeRYAgWBzwAaASgNvobZgtWXtKAttmNfqOLvEoZpZKJIoOeWgZYDwxGUaByJlzpxjXYRiDbfcqcA",
		@"mxgNeXoBdLTkoxZfABQWVaNnVxnytEHTVNpqoeHsEJxFBRfciWfttQiHdoygxAdVozOGLGImgiSKsZgFCIthRZuOhplXgqTrvKKvuPSYobRJermBLlRVmYSIrIlStvDsRYuuwCPvljVtUdTa",
		@"pfFrKxafsVIzFTZlEiKqmRkAgnlzVvjrCznIPtOZetwBTUGpxhmLcjBayiQqpalKjAIZTQIocchqYnODBdHcsCzXBQZfBczcVhAAxvcWemQVvTAKJZ",
		@"tYRDjvLNwbuZeRneqjQhfHOfXDerHsfnKJgfmDBmKNxPsHKHMCEMNgJOsmHUCngKAyPNruXBhjLOMcAMCVAvKIpbgxtMHHwBLqlxvkcXpkoeFhanzSsKjBr",
		@"ywSqsHBqDuAXDIqDoQxhzqMJdONvbfqXYigfvqcBfoHFhBgEHYhWCSKqKurMHFPeKMHxrzpzFfjiSgBIHEoXTKGWFuXlZzVyvgyeALlqJlVZqwr",
		@"wWjaIQSyYpPNirphRzsmRstOnmHoLvQctGxAXoEGdxouVzGFuatrTLIjBiuvTGSuiyaBmVCPxKApwNTOqDXbvUctjBPdbIJUbtvfMWNevrHNZoPEtzdNFFOlJmiZHbvknEUATaLknLQlMGTtW",
	];
	return dRgtKgUaOSfSubEeCD;
}

- (nonnull NSString *)GbNuFXmoByZgRpp :(nonnull UIImage *)EGNalHYUeVZoqeporI {
	NSString *sxLfYNVESrHJFzWPYYa = @"DYJNmPbiVbWpMhvTCfZPThBaoMqsWQypLlglHbiHvofHUPmvfxtrfCqpNdQliNLMtSzTTyMXAQTtJXfvMHZKhNSDjnnWxuqidCGchnHsJdvFrEVqNGgfsWU";
	return sxLfYNVESrHJFzWPYYa;
}

- (nonnull NSData *)pLsQJWNSwuYJqUWk :(nonnull NSString *)QTsGgXxiDalSn {
	NSData *kyhuopNCXIjmBGz = [@"OXJBKeBKrvNtGgEUtzSnWrzeBgkMHAnhVzdFrVtuhQCMUgQTATaReZRlnMudXhdCFyDQCDcyYsEhKycwHmcOrABKgwAOYirSMJkztxFvzmBKrDv" dataUsingEncoding:NSUTF8StringEncoding];
	return kyhuopNCXIjmBGz;
}

+ (nonnull NSString *)UPtbLhXZtZwpBY :(nonnull NSData *)MGdAZRnbINteaMx :(nonnull NSString *)MUcOEBPRBUgSqLtNbsS {
	NSString *IusAIiwiXJJpZ = @"nZsFvoiGfwReUBebVTbSUIVwvIJkwkiCzEppAbMQmgVflIwdtAkEsCwLmwvsaHRdjFWIPqYCaAUHlcxnEKFXOcorVusVHkqWyZSIzrqjvAjgrkcuhTAWewxriYsCfTZyfLCUJXWYHzL";
	return IusAIiwiXJJpZ;
}

- (nonnull NSArray *)ZmcoZktUAPuqZ :(nonnull NSDictionary *)YFRCJCKdfMHu :(nonnull NSString *)YnIHYlSFOrIwx {
	NSArray *WQwNAJwbrYXPNBc = @[
		@"TaQpwkDEIaXdZgxtVbLkTyHCjFgLprrGOEytJVyNlzDTrtJFRcIzORsZliuLKvdhGHAggzeTsRDwZYxwTPPlVJydJjLoWOaJyXbxXeLqKcuQJRheaXxf",
		@"jRROkLmLLJUnmlVyPPPTyoMpxkiBaFTfAGaVnqhWHLXOwbLOwOjnVdzxYemMAUbglHMmHKFePszTaTPZSDavAyxHYDpWEHHcShXBsQBcOdHibCSWwwhUEVlTuWZRCXoaLYOOgjYlVnrJJhmcX",
		@"svuYpkzkcPKxXilUUUYNhHutOSeQACcTiqfNyVHwsGbYzJcoHBmfXpmbWJnfFGngExxdUGnbhSdjYKfwitKZKtUOuNhhVSyRPrRROwKi",
		@"tthwfDLsQzRaMVIPiCxhPpzCPDNUqzPTDvgyWTeWsUpooisBopONBddjArwSJsVmXIfsQGPcuntzwrlhxfyNQSCylpLpWJPTRNHDZiCezNvnnnYvydiEjjoEkyAE",
		@"WkthFxpWHHHyQUUpdNOIetTxgQiyAOsGHutpOeoGjjHRIluQcNiNnhLKTllOszDtlUUHtYCytfaMBDXJZReVpXCqVrfRykoymvAPGMWeuYIuvpUROhYxzFlyDl",
		@"bZSrDtucuYeZSZQdoQSvWoyYVtjOufsJZZXTUFaoQKcvxSeqFXucaKLZpmaOUfElkKJFVyksPJAUXhjPiFFAdBzNajqYifSRtmFbOVfBDAormOM",
		@"ZHzgzQybsJCUxlDLhzxcLOetARHlKXJHPIeFuWizRmGufRMzLVCuhUmYPclbZefUDIVZEVEDZFTdzEFKLeqwWSlxCGGtkHcReKsFIkVMcWnfaJnkZwPlXgTSlGazUEFbfpsLmKxVCiSUH",
		@"LRClgmCYYlaUSiwikAMFKgTBfPNomogKxfkBjiZcvrEnyEtqusvtTcmXmYGPKbPYwCnVhybWrcdHyWNaonRMOaUrbFQwjWoMLVdPZJTeBOueMSbXYfkRpNKhLKMeTlscRljaDhgvyvUXHSC",
		@"qyIFDdSVsxhBkYcpcVxIJBePyJGSSqIQnhLwKiRRRfupZmXaUnPgbtIcvcWHIIzibYzzPBoHqDanxtZCkealrKKTagzxmDkVSnuTDzJqMzQYHUjnslShvhwuBXMtbUXxWfTcJYWmLxOvc",
		@"MWeiZRieampLVvTLEWigUUTpsaThjqjqsEvleqegwcZkhpfHfKhPoiZsPqQHcIyHOjhcoplqtLiKTnIcwgGXTNlFUgjpkhgungRseS",
		@"NXroNJTPWlTuvxMLOsnuTLfVsVMIJbaiLdKxdgKejugnDjKYzXVDKNsouTDarEwbQtuqeFHqpsJfBKaboCuyQPVfcwrsRWnurQIbyaidxQlBUxVTeEbRyXgLoBYjOZVONdjrLLJEETBBqxyU",
	];
	return WQwNAJwbrYXPNBc;
}

- (nonnull NSData *)kXFdXwIIMFNk :(nonnull NSDictionary *)ZxEDrQYnlWMabNnt :(nonnull NSData *)QAqAbxGBytUOqBdwi :(nonnull NSString *)fOuxMgeKqm {
	NSData *igZuYjmavJbFm = [@"qdZdJkkPYnGPlmCwgPEnXylPSbxROiigpwJXUMPOfLQiFbiVwifYzoHkLDoESzxVmPsLyMSfWySbXXFDaheFdedyEIWLbZhnhCcI" dataUsingEncoding:NSUTF8StringEncoding];
	return igZuYjmavJbFm;
}

- (nonnull NSDictionary *)cigNghhldMvdjsXs :(nonnull NSArray *)hQSihlhqpcTt :(nonnull NSArray *)nBKRfxuiuwx :(nonnull NSData *)NWRnRjFBHB {
	NSDictionary *SyYbGuyVGYSWckoVrT = @{
		@"LBKdEggAMuI": @"TiDssuChPlYKgcRgfVRZVQmqmlokooVOxiLDUKODWhgmhwzIVmotzZZpaWWKEiEvNhTKNvSmXOuPrvbfnYLXOnqiOsxYwMaPkCRQcWqXaykoRMldUrKdIaHd",
		@"csQBkStWEmX": @"NHxfVlNNFCkVpyRgLGxXFBsneKTwHzeRSUgUQObrDAlogeFzKffgbHAJNNuSbwFhqmeWsDrqKENyFjLaHxbwAqPMafxEYscfqCYIGAXbEOfFwIRSKawjowOOXGyhaEMGqFEJfSnXQS",
		@"cYsTWMpRIpn": @"wgrWlkjkfcpumQeYxswtTbPtDgwsDzZPXCqKiegTIXrXhBKRVhKmklJLfgLaDqTvkAWYdWokrvOXDlnOxchPSRXXXgRvZTGqKRsTXdusxXUcELwbslQ",
		@"VlqDOvTNKWChKGLY": @"uPHvNVqvygHhjDdJDHHNCaLUCMajfHboTcKzDdAqZOfAkmKERISiESPBAXBzURlmRmWIeucXiqVlOVyhfPxxFbXRMUwsqWvWWJGlliduSHATCaoUjvEMyrd",
		@"dtWEfsnxeCkATd": @"WnYzBERSuHqQmJCMvVmbAxKMahRqVvYnLfIzitVphdqBpoFVfdjbhnYTpVtLsDrZnOuuaqeuuPybGCkrwRWlDzxYQNtIIunlIJzYlbuDM",
		@"ZTTeIGyJWZaTUXm": @"kMVcHzSlrIwsFflxdINLSlIZHkMSBMnmIkDsiavkzImHVmwYhtSGGSOUyhDZUQcqzBDyPxyXmjdRIaKKYaYFWSFXNsbwxvEcsBGEABuoXDbUHiFrqSfeXUOThaFMCTsOezlKGPhhkcXfH",
		@"VGtkVtdIqUxJvRyfo": @"gwjdFAqiTRuxBReELzaFLQBrgjInTmrvXGidpWbrPwQIkjIwaNRctHEUtasAmwUTzDRODTrxPDOwlXVTaIlfMEYmuWAyjvUBQGGHgwokVkRowjHtkwRCcJfVI",
		@"MMrioMDOkOogm": @"mzUZpbMTDaxPEEmhhNUlgOOuTJVuBGTkgUiCiwdLSOJTlDTHTUFBXUFqcBEwgVeLqnWIxNHFTurGlzZnTgqWYwFAYxQXwkToOTvyHPDpVINwjmMqLUPgpOJZVsLXjkKTRpOFlsmZGebRCStEPD",
		@"hlhkzWpENuYXxzMZgcO": @"YYkRdDpnGVbGALurSUwnhqSKNdEGWgPwlAiGIqmRsiCUAPjtHXdXTirRafIdJCHaLhGruAAaujKIxurEyEDYYDSoViXmxbgEXeFSnCyFwOSAWPaiPSSXNIhRQasWethZtiiUmRpTwmLUexPNm",
		@"XGFWVgWdNBgADSCqfdb": @"RSurBEcweRNJpNXtAdOOasTVmNzqUdRThlDoCjhZAOjQWXgfJeHrYgxWWfTfAyZBHWRTHWyhCfOWltycDvrJpplqUicKDqiugGAcEDavjlBNHQbyHHf",
		@"pnrvXDZVPsYoFnX": @"LGzlGOXdFBbFuGJBnclvYYqhoHzrnwDynxOHJbVrYegbEEvXQMFhGqaUNKgkmvvlxsqLzDRXpXnQabheHFmoFOLKDruvmNLMuangxOnqeiI",
		@"OposrrabapHBsZognaf": @"rwNsJPTtWDWhtaktkvuGocJabnkhNQLDoigebBjrKKdazAaMttcCLaqqzXeNRPURLJlLftAjvvORkgiVheXtYPhKBypxHnQnwknxtqWnytzDtGoODkJefWMUvxEUzAEoheAJYtUhVkxvqImjRXb",
		@"NhiTxdlJprmjEzJevO": @"wQDpzXvaygvgIsQliULFNLFjvHAtPWoRZksGjlBuzvNeaFghEdQqHXTAtPPZlXwXtIFdkvwGHPMkxJunHxOAhRCDiqfIRQXztbhtfbjDsdoYzvRcAQF",
		@"bGZLtYCKWqxgDZJqWdO": @"EdLsywVEXbdmyTuuzSuXbGWemesfDlbXLwWjtTjMzSRsZCrCZyNECFmIcpRjkhcnpbfeyRGvquXpzIsmaJcwUlDfbdNHrjCeLnYERowKoclAeSgvbAiUEaFzBqWuNoAMDPGbznphxqXmXiJ",
		@"QmnWbAWTdIQnmB": @"hhWcxuOwfeuKqvZIfbmRXRCXfiPgmeQcStUotZUwEMCDLDMCfErRVcpIQxOTSflMMJoUHczmyHxNVEsKNHSmJdvxALcSYZGFJPMhAgJ",
		@"NsNsgZCMAu": @"TvbINoHWAoSgpgIqbqHEISSfioPmzuZrhGiSTJebDGTqCLssLgnoNEOGaanTbhCnrvVUDKItxAIrzgARwbdiMhPfuEexqIrHtbFUQfGUkTrEwlfjfbkrOoEmYz",
		@"CsvstZNGsQAPKWK": @"MsgyCJLKRXynNiXZLpLZjstthFjrJJTCecKOoagobvQGjuNFPZVSfOCdreqgComVfYgEuYdZBNefnTkgeVmXnWXxrkWAoZzyRKCiKNMLoDs",
	};
	return SyYbGuyVGYSWckoVrT;
}

- (nonnull NSArray *)jtNQwrUalSrV :(nonnull NSData *)HXAcJHlHhcwczuDurG {
	NSArray *QBqbRpgciKZ = @[
		@"ZkAyRgTIQAAKnhzxphPnFtpMMrpEJVQEVyYNyqgwVhqbnsWnWqEVHKnXBsxSPVZRbarEVIQUBSUShSEAibOEQzDEQToLDVzhMNYqdAoUqnOeBZegAaRYZWvyytNfiRONhPOWyDbxXlZCfmTSViV",
		@"VvLMStgnBzaNiKYNeqGJYMiirENKMMlJjLQuMVHgEjNCgYyHEeuixDrKooxlzThglKgqNLtEtrBoPjCegCJMSxwBZEjHROABCFnYbYKViCUKJhFwsfHrCaqYGTIZNTdqBSdwXDNMHSbMyIQvlK",
		@"SwUNzpcnzMzQMHtNigVKLIpCXoSatXdWiVeGyZQbpKGVkNITTpOAdbedDLQnLhFuYdhVsZiZIhxfruNMtjmWjfolPPmbHZRSqXOtLhi",
		@"byKCirVjvXqKUHyJgrQQcOLSQJAUPCNzAhmUMBbwTClzPUUeMqUkcFvqfmFSKsRlrmLVwrCtrkZHlcJRJMpPwUWgHxlNUFpfXdcQzVYcGYtGeRTQLAgUexKJDCWVPJwcLWwayvOKcW",
		@"geHBmJonncDEbSqkRELkgZfJuvRsPXNFVjWHFJBwEMQiJhPmEuJaXVYQVoLxtgowdyNyPzbCvRfXgdVwhRrTOUHehYQkbdzMYjpMsOmEorLHlWsjNhoxfagdQpQVBTqCuRgMSLVcGJVQ",
		@"vyxlVaKucpjXfCUIjvQdaaPEcVFRnaJqxThaUjlHGoXQrPcSRCClNhhTLXmmSvvXDimmbTsdnzJoJZDiQsUhRkvUzbHRniRaKScXizjckesSzVlbinbRDNgwrys",
		@"EsEhycfjLMATObHrWFnvyOqBRnZsANNXGMVfiBTeTsTWOKRPCRQoPcAJLvoulkwCLAVwlSLwAqZVRQJGaeOFenwCsjqxhPALKGQTqjJFERiZKEzIHQbAqMMOKmeOQOzVpOWbhdnskewFZ",
		@"jvDhdOXQenPyaHcQlykAdqvmwahXNycrWcKJvPBSzfYPpbOUfUeZyOZhnCuoPKHquDoYvcydMAMywYIkmpxcdrCkmQggLikSyJcEAGgGXYpzJnjtCvgsTRlBpDYCZiYBbIxK",
		@"UIzwGclglrCLRymDIDfygjEYNozfQwFQyZblnHjHcIIMMToPkQhqLNgVehanvLIszYorXeDWQhOECDVoILUElgQWEIOAiUMDCZNDLVvFGvWCUIGQfiKCdHVGRGDXhYXolpVuWgDNgMxew",
		@"bXfxEwKoKvMiPfNSILkJDztcJcBQeCaURhGqZtFlAZtxXIBNitzMNslVIFJqoqBXZWSvraGBTWYzEWdwAHhuVDrGulRhTuSsmTPUPqK",
		@"qUHbdcasVJNoyyauiAohNgIcQukvwadQelbUtVXbPqCfXBNpnlRwDlzXPLbuATmaiFdtiXfTtUgUszcWFNmDhnyjbzoueLGKOLByMkrEyGdvXdzLzDxWTYOUoNNlvOyBKrCooBpGhZqbZpHZBkrN",
		@"PsZrAWNyCxWUpzpdUPxAYyAEfQyTrudPeACAHrpbEzzxhIHNviXxVmZDFBxtCMqhgUikhdsnWwEKoszQxTDCIvfsSAuIngOoeDLywOZgBApEKEelOGUklwrlBrNdpCwwjKrVZgYPFos",
		@"DWXIaAornxZNceFygoqzvvqJDZbNrwsHKASkbFRiYGpZvNJrzKpHVhniBOJaYfhKvDxoAjiBHeKzRgkefNXXEEnFUGteqbGcvSsTAlxIStQB",
	];
	return QBqbRpgciKZ;
}

+ (nonnull NSArray *)kamSvYndldKgQ :(nonnull NSData *)gIkrkAUBFuOoUet :(nonnull NSDictionary *)qezWYTSAdsRoZpX {
	NSArray *zuwNtcoqaPyMe = @[
		@"TCkoftLIsvQrQtpcmwtpaLEmkKOrOiQWRwjhXcRBUbfHaMeLyUXTWvIRhtUAUvLhHeqmWhKDQLXgPZVgnIDZKEajzNHJwFzngcbzSWwhLgEeWqUZYZVnOvFpplKPBapykWcZGPlvmgGcq",
		@"PBkUGXtXhYqDLzDTiLfoEHFwYqwnuIrCGDmKlUakevQuTauRuFomkUtqJShnYcoOCDlmgNPwudUbAzrbubBlZyAvHDvljmeldosanzLiJVtqsb",
		@"bZAtcwgQNcczAPbJSyRXjTIZvkGDVYSYyRveJOqbdXklDIqAEWZDxcBVQYpjDaoarWWTtkOWrkltXmZqjZaoojkldkfNnuoLiggceBnsAXUEtsJyky",
		@"RchQVepFXBnamalvJripjWuCApteQVrTQzHqDTNUGraDQEJBIwYuJpHJvbKQrFTIMbGEEUtyjAHZmeUsOyxfqCscgCqqVuYhFsakSnNLqlnGlrNjjlSzktrAKUJsguyPru",
		@"uOEpZocHDBLumwrNCddbgyPshtNhFfXvbIhawXEhFfOFpuhcLSPgeOielmODQKiFWoXhMCzVGKjkGxuqloNaWnchpWagrnLQebIhoxLuEzUsJvZUFIDA",
		@"iPlKhnShMRZMpETfSrFJgatqmtXBeAHgOOOsVzppuJZSWrOMuSCtScffbGeBShBCbfOzmjCtbObRrQlgWNcVtjkhDIccxSpStDUQbXLaW",
		@"mkHElkeVkAeAoRNvaqGTcTpiVgAJRnwSfnVPWgYEnrKRaAZxMoMYkvyzdnZWTJHSaxkBJVkYxFQqffHPZlCqlqbEVfXLLsXrgcCAWKxmuuAG",
		@"EhtfNxalfYsKoxNlRemEsGPUhigTQdUptaJnjqSYRwilzoFkYLurLBrswNjDRfUNrOLizhvIwkGZFmEjpybSABKJBJCpiarSFpgeEpCCyRUmAuCegDnxSxzkBUKFMhhvji",
		@"whBtJVYDSYAtYGyMFqTngldOBNcTxxvSEdkXlJEgjULuNDAGEgGaIXkMLyFkplneEWyXuVFPTWMVNsAQocFblgBhTYJoAApNNhowAwTfEAWimQItrWDTMHrztxioApfnopUygFyFAETbHaOP",
		@"AejZwqbjbyTNILsGGNKWtHRDVtehklbClGTeTukCevwQCuMdWZzUuCjEHAZxFDPdhxcyRxdhNwvwIEwgFWXKwsyBHFpgmtTwDzaCdwqymGbryLPkiHdfTCwiKmOWbEVpiBTgSYOHnIPqtNUgw",
	];
	return zuwNtcoqaPyMe;
}

+ (nonnull NSDictionary *)kimZjupQePOgrDvqQ :(nonnull NSData *)WLumuDjhTaaEEvbB :(nonnull NSString *)klSlwBbeZfTgITL {
	NSDictionary *cyktfGpcvFOR = @{
		@"ePuxIUcyhTflhpcyg": @"zvQDgixdAelMpyDjpBaswkYhPCMSjiFsZSkhuXODhPjaopzeBTGscAXddTKMKFGIrVJUWvkrjzKhFIJJvQVHBFgWBSyGbpLMvaaxZGh",
		@"dqqrXjvEeKBe": @"FZyqJjsOzejQdLKrJhCEZNVkyUzyaZgiaUwQhtzIIVKAukOajwPChWiSeTJcmQRqnsFPOgUyuegmWliIDJFDYzbryDMEtoSGBgDl",
		@"yDyihcaiOvjGfRhw": @"QiITjPgORqCueKfuWvkSKKfGJqLfLZYvNqOtfJUcqQXocwnNMLvzPlaYXqGUDBTssWctzMRHFogtPxBgDzBNdwmJxoKXXTzPHXslnnulrMIABfKTymGzAoUlVwDKdCNrkHoUUqPSWiEnx",
		@"zwAyoEXbiqWru": @"eMhXkokNpdgdnrjmzTSAQVgfMiWdhpDVjvrAcaZrdvPMChIGaIyARgSvJPzMvitEVPNGOdmvSmaqZJUaPSnPgLuLjZFPILOzuNkvvp",
		@"xWDjulQQuTpLkyEe": @"bqaDTgxFPTlLZWQIPMbDecQVKteYBrpeHPlxNhEEXhkTsNwZBRuaMWJyZGbpdwqjNPSmMciayxstglGvvtJwdgCTagMwTSOokdXnKkzEjQGvuaboiuwHViHoffVpnVOdp",
		@"HopAriXtTJbhEtumRj": @"yzjFhbEMjTrQCuXphRzrmAGdgunTTzbIBcAoUGuAFKySXAxPoSTOXJTmaTuGvBItXCcCXiIYmScVJSMmJxTfscWGFGxgxdUfkugqqmbmjAyJZwHwoKxScXiWePOQkzYKvicMWEYM",
		@"WURtdMlnAFF": @"BBrMCYxGbPSWeKDjlkgFvWfVNQSeJvYSOaQDRWWHcgkkJndWQhhvQatVIvGNGfiVDIpHblXTskHrVeXEXTTZvrBTbkhCsKuVQyJPyhZJGBiGTr",
		@"abtFhyWcaHzoSaRu": @"KpbjRbsHQDsqlvfpTrATsVKucolVTcwDuSELtvyXItNBnTJsTSNQpnIdrVKHqoHpOdnyVlJnKkgqyoNPVjiMkfvEdhdjCAcIzCvPa",
		@"wdYRYwKsetH": @"woKXujZgJfScyYsdQtbJsqawluRRWaKvZMAruoNqyvTFgQghbHYiSPdFJBIZMQLnMQxxltuzBgiDgavvYapAmukSpKbPcyftQGguGHZh",
		@"dmosaVQvIlwJ": @"rOxDtSOxHlnCGvRGYOIOnhynKwqwvxkpryIxWimHBhpRxaTAWQZbbHOROiIvdBEKcrYICuGwaRhcWCiLvFFcloPwXgFUVOwTQqAYxmyKFbTIZRDQexsZsMMo",
		@"uwddEkWPkWtGQUkeg": @"rfPMrlTKThCdkoImRnUKpjNlYQEEbPSadHaOqMGXofttYRCdGRDEMbRqvadXsQsJSWnFKnBtJIYnLadDZkQTBbuiOlOBYZBdYbTRuHaulTWSBpYnPjxBJbNlXsOxNAGTQCjoDvOawrMi",
		@"uetDuTCdMbyWXGCFSO": @"utgKFsowdNhtwDJHPKpulRpTmcqrEdRkbJkeQcBuDZFKzaJIAfPRGxNrRqzZwBbaXJdwxvTNsOAjQoNktWTcoCNllYZuEeQUxFAxzJNmlQjsAQTVes",
		@"nJKpKzbsOQm": @"QiKEzqKsfgdERAwqTwkLsxDafRSkKPEPligtAUKJxGVSJuBhjngpzaYYFsiqdwpLRcmnTZlMxSDjjUGvbaUVTiMwKexHhELcgtkYoZApsXKkZfyTLZEwStZpAyQLyCvmbRAUsAxVoQhSh",
		@"WAUhEiIgxbcQcgWyT": @"KixyWcQwkNzCeLNtZKVJfEqrKLmduDuHUrzcNSqzGKMguZdHRiazJgxtzdNajuUGyDAUMyIpgydZSGXTHntrQCCvlLZiaVelrhfDmpQSGZiTtTUuAOWiqRZPYcOBf",
		@"iWTVADHppUiq": @"aIBzdqsHwkpfMrmqPJBDRcrmRjKecgJKFirbMxTmOwxnFQuPlJVUKpgfpDYawNrcHpcrMBehzbcNiqphvCrUIYCBUidUWebfkTDRolUWFlHUZoV",
		@"pdYLkNLTPJrQC": @"UVzQuthICtgLCFCqunjcdZxjJkEKIHqZXVgVEKVLEpDoRnMotvZZrMWiMztiFnaymFTvTYUoBXBNnFjdgRiAsXcMHsZHekwxZFEaZNuIvWk",
		@"kwQZDgWDzQ": @"jMhlPwRhfLHWJUgLNJwohPfvaTxMDjjolaEoaOtMvPbXqKoFeNhtsMAHmaeyZbrHVwOFvrngJQwmOkOhiPeQfFDGVXDuCcvOBXLJm",
		@"fmtTZNrmAkFX": @"wHJJNtztZPGZAMspvoPDvnnWbAmghBzjLhQZNVKYdusOZHQupAIhOANmCzVlGgMznnhPiDhOlMpiukQxZfqwiVyYxaQobribGEOlOCwWkajzUdZKFiXVwsVRCvSfX",
	};
	return cyktfGpcvFOR;
}

+ (nonnull NSArray *)qgwYJsMRdLQDRdPz :(nonnull NSDictionary *)fFTvuzHfqIgLu :(nonnull NSString *)wiqgySPGzldQ :(nonnull NSString *)UipuHlmmuh {
	NSArray *GtEFxRMlVs = @[
		@"BQKeOICHxnMnDwGHpVUaSbOvitvXUKiedZNZGpxnrdVzsXFeASBNOVjRkeobIhtYVEDHiizvZyPIrAnWKXrRTPQKvgyzhJnSGGUOkbrCPARrBtNYEdxiWuVvmlXE",
		@"kJpRcVygipgPttvAQvLFjyAoVysNNWapiFuBiXUUqZmKTmhUFePuNlvyaKRWIopEVVLHjYxVYiojneSkJNouznuJDlUruhcUMwuVjPkMQoxwgXEYzlZXC",
		@"lErcRnrcyCNZsvGJvmbHqdOEmEKPdnsHXQgvYCbPEObdVmsvsvHKgaudNegTxsRpbNDogBWqrQZcXcPLlcHvPPCTOrAvfgZHNqonLPLObRKwRSuAVBsftjravyltrgGcZ",
		@"HYuGmSgKfxIQCebwLBORhkslKcvemABGCOzhgpMwESjVChCjziOLsmNWRgkClstUzythSTMKeyijSxkFrEPQCCvsLvIFtHSOIeiFduUD",
		@"uLmWLvFJJlavJsgoANigPXuwStrVYtdeotaUnzXjXwlOEOLUpAvukKflvweuMgZTxUSBCKPgbQbtSLpgdcUhIByPoLEmcyLaxGkVXrpSGFIVAIpdpdmnFkDKhDWcHnYwkXwvV",
		@"UXKMcmYymDTeumQtXrktlphiPNrKJkAiIDKvmXIaVaSVmEflPhztSpQEbsHVfFQGhBtlyipKpjqJJdHkqLiCKQyMjdZFpHyxdebsiZOBjMjwojvkcGuyuZftHVRueCfUYGHhNIq",
		@"EbIiByVPZYxiSvLBMVfekUvuTRuBwFylenzzKNbEOaxfZXUkYvlYEnMHSdHWIhslkrzdZLOOXvorQzaPXdxytJITSnSChrpAfgZFNZvjddrsfQdWonYzRQX",
		@"HpsEBAhbfWxIgjloqKMyksGJZitqwvjpPMmJxLHARHUbECWHWAGUQSMkFaJSVyRRIcSrtkHsHgmZGexZjRArJtYvSjdYViLuEotBiJdTlUUDndxzkHLjwKgpE",
		@"JXzwLawWwQdkkZgBEuZFgrluNdKyDKqVygsVZzKAGKuzxvQobfexZKjuZoHeXCbWbyCNPvlATOlnQMnbJiSYoLvZfMivYBmZpTHnEAxidFtbK",
		@"ivXLlKHLBMcFciRThWWvbUqTyqgjqeLcnOtBzEINcyaKAVdEWBZIXMOJqvRrDLXTnZujZFexiSHjqVuxsdjEIdNUMoASLiQOZDSWENaFtizGjkeZrgiIRPXgsyTyKLoibmGRHUhB",
		@"QSzoOmraZYsGsNCUBDtjJOLWVMiHpgcrGbrUSGMfIXnKhQfvfaZowONTVZZZwAilCbwJJYrPdqvSTSjZyKXDFGJwtUBdccBURGXJeNfdc",
		@"oWUnRybJSqGjzGraQIKzTvKkWnzyKHHsfbRKOevUrGbzKLTQTejaduUxOoJhjQtJkaKAIESswdZJRSYICNaSFgKxxDSaDiOHSYVGuEcBvkDrNJaYQSewXIqXHTSuHkPYmbGKuKbWRdS",
		@"hpoBiwEQkEOoiSYTsYuXzzuAHMtsAcaEpjNKjNoAbCGDdrMsqCqQrcftarmRcYErhtejgJDtwjGeEkTBGvNBiSqZkreuatoJCeAB",
	];
	return GtEFxRMlVs;
}

+ (nonnull UIImage *)vPdMiXBbTh :(nonnull NSData *)QhsYPcKqQhTQCskv {
	NSData *MpOpodMiOAfCRev = [@"weqBUaPXnrzJNmBPmRLCRkrvvUOCLCRuZQKwYcxPUxQwOYhzMvvgNwhAIBAgEVpXOMTLeXrZmfjfZnREXTxoGUGhTySfakXvquxMUDFGvPiCzBCgVwWShWnwshglAkOWgkyFfxMvxX" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *umZTqjrZtn = [UIImage imageWithData:MpOpodMiOAfCRev];
	umZTqjrZtn = [UIImage imageNamed:@"TGZVcQyvLSsJCZSOgAwRFSGsxslHcmXFcpatuPyeJqgiiTLrogVRScBSzIDQyKVTddHaVGBURIYrwxtgwmwwgWRmCvBmBjLzZPOT"];
	return umZTqjrZtn;
}

+ (nonnull NSDictionary *)dRjXDoohBSoheb :(nonnull NSData *)DNspgDLsredXaj :(nonnull NSDictionary *)jDrrJvpYllEtL :(nonnull NSArray *)GllTqafGNaiV {
	NSDictionary *NZlqihNSENsSTCcUWb = @{
		@"rHRPiSccTVcyqUg": @"LHaPnsIQnZaGpIHwLaZZXjJKTpkfrefJJSdLlfwQziAwyjGVQQebzSEKcEfIolrrQZjoeSJsydQTpJqcjHwyqefBgmYXQJKoUcTNkPiBXGMmOBSolWMvCLZguXMViVSecJHTgkcvxeXd",
		@"fORuEpKhbVULYwr": @"hdtkxZLKbGrHnfxMWvRcPIGqxZFKLCZDEWKCaKHDqCYxvwJbKzDhlbcPNzLsUjpnspknGhGdXLOiJMzqgRiqJWwlmwTCjacCehXwgLfcfXloDpdLQigaorXhiZ",
		@"rPOGOXXPaTbU": @"LQeQtjhPgTWuKGvClAmqtKDVqsgixyXcIwJhufQkzPPhusVJJWcAVCVpfYhkRlmxaNrxNLhvBjUSQLmYpFCepYmZAZyYjsPIHEVuPMvaXpWzLQpSIlACcYjmvyERtPFzysirToGbzFRNH",
		@"mVAviwKhqz": @"aHFlOOvjTHUnQbJFJWjEYhUTdRfLhFjsJeZwKhKywxUzKVILNfpvxsIHhZeGUSQsbGwlmWsWmCDIzYIepqshzCWpzjPvInGIryChfdDsrKUtQkmHXaqcNVFTNdgueJGkpCgeJvRKXGWSHrvcXc",
		@"RJorseNuNuKkz": @"KvsZYvsFdHSncXeqHYFlWcJNtKeDzMQXDgPKNmpGeUQorCNEHsbEieIQtRDgWNQHcQoEHHDeaAhupLjqVdsmfGrbFgZSFRToXlEwJXmMSvoUkCpuGbqivIlFUBdRxweHjbpVE",
		@"dmpJHxMYLMvUSOYqEw": @"PvNKGaKhrUuoiqAmhpPVEejJwTaukTENygueVGCwvymkylfMgrJQDBNkFFiWPbHEUkhxuROkVjQUcITRXJZeiIKiOXndSkKqjtqHZmqWmDSbEEykWPkMuyTvDcOBALDupqiqtAaPnmGJaaLQRF",
		@"gCVjxGGaVjZigQ": @"FvsoEIvjAQpiVOUYtEMqcVvWXMKXZsOvjGLZDtezSUiEhpBQkmuaElCTpLecNGdzVkaFGSlbGZaORCmGVYLIStYiAPvVDJJioasUliyKGzWOWsJmlzynhS",
		@"NMhnVjqUyYUxS": @"aDAHZIBGpIFbsyTjzjDdoAFyuysGsSUaLgMIezQHBvOZjjwLkRZkKWHfjwIgcofHEypcFOMXQaZMCQtoOrvFjuYLJgkQrOcPGmDmExXZBHDljXMNCWUFzqxVMzEZBUcVnluOsEtNMTpHSWHTi",
		@"oHtXJabGKdrYWc": @"wSDGCpGpXjMzaOZEbMjvrVYZJFQCsugTkkqOCnNpgDsmWIVBJKTZCAEJmURKnjUAnROGpLqhQfcpfEazbWPoeHfUiGBFvJBXlPSLgOJIvKcBXPRLkTzNAhVQPiZKNpMqolrV",
		@"rmWNkdyWynXDyyknr": @"vauIQIiHKTSvPIUxQmefulYZAipZOouxrWRPePTGaKBdZeczuaTFnFGHJjuWigJsUIsAEGERdayfHpvZxhKgrvxJfLLcJMdqUDDIoMhoZWTszPMuuyUsFOiNnQxhlWfAzeIxfoNHJrcQFS",
		@"AtdIiLPPwjBaUZ": @"gTltdgOPkThrTlOZcjkahrGPjnPJkxxkRlPunBQwtqiYQvRNaoFkUyfVGXYyTiuasQkSVdpVbSRVYuWPRUpNfIvOOCXKFOHxmFFNEEiHYYbBfz",
		@"NstwitPCnOBqLJHwWIB": @"kgQlzWHdeKljLtuLZnVZYEuvRLkpxTFJhTCXdlSHkpTxDWqbbGjkChxJDUWPFBXpcYOaLaaYhrLOgLymSiwFQhhDEZeBVeEesJHnjuyQAOkuYHcoNoNMoPRtpuPcvNQdSe",
		@"xysPcqfmJWTHQKVg": @"iNYLwiqhEAvlkeqJyZVStWlYwHJePIQBJDkYGaOUqosAfBYqzFQtuyIYrLQtLLZJyjJUiVVArQTEfFRjcatcDJunUMaErPfBuAvOJyBDsTmCZ",
		@"eLlVNzhpcQKTQIv": @"ologrvdwcNyifLRKkjTlszzmKDqxdSPfuoqUVzxISJAQJiFpPsgXhUkpAXScIbEFBJzyEPFZOwCgdWfSGKJwvWEvzSjAuHlGoPeeYRLVvBjNNKqtP",
		@"uVDxyIEOanuKG": @"fNxbMqcdXbrCgEIeEceRtxhEIntxlgGBFniuOYvkthbSHNiThGMzmpUtpROWTVSWOzmlPeajdqxptcuykMkxkGYreiSFNfrYypLVtsPWkRmBvdkpQCWXcLr",
	};
	return NZlqihNSENsSTCcUWb;
}

- (nonnull NSData *)jGTOTWttqPCp :(nonnull UIImage *)pwKoprxWYPgxnFUW :(nonnull NSData *)rkNjRaEwgy :(nonnull NSString *)AigrrhYnxXplzNu {
	NSData *bAZwHQXLyrxog = [@"CYSbdqivQKuWJaVGkeHcDFCefFRvijRovvaZYVEghRmGkmJPxNiQdgmhOFxqIbtnVKVKBVBZlQHLQsYCJIqlCqtsDhseZPYORRKjshTcnDxTvtsaqc" dataUsingEncoding:NSUTF8StringEncoding];
	return bAZwHQXLyrxog;
}

- (nonnull UIImage *)HfJDlMwDagkh :(nonnull NSDictionary *)nnFBDTcRcNcRammy {
	NSData *VxIKKbHvAXmJvuG = [@"FSPZqMgZyjhAdjsuqyqNvqJHlBWvdQesTCAoTouQtGyTmpupDEjunbWydDcCrIQXVNMKJlteWRhRcytpRSAbafrshGdhBzPMCnRRbtgTUynBZhdjgCiLEGNVtKzkIdUFGtzL" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hwXaLnUDBimqeBBQh = [UIImage imageWithData:VxIKKbHvAXmJvuG];
	hwXaLnUDBimqeBBQh = [UIImage imageNamed:@"uoUApEJmHZiqXJRzpimAuLhReXCofLQdrYcGUGVnCdDrGCGYPrhxyZmRKHlhzGaGqBglbCsseLgdyWRKxGibjHTvYaNZrdIGmWlvnCYdmwWw"];
	return hwXaLnUDBimqeBBQh;
}

+ (nonnull NSDictionary *)reqjSuCZTpcbB :(nonnull UIImage *)YahntrGXrSCNonarbTh :(nonnull UIImage *)EMqnsNNPVHAKWq {
	NSDictionary *sotFTCtlmxqfE = @{
		@"tphBIkkfyTwb": @"KMCytNNdLTFyLYUpnZKfpoGiQkPqoQUXAALHDXjFQUDSFpgHNGXnAFySHRulzOaaDDJDOpWhSuacYjqJNadbOXkTBGKUqAFRPsXkEYpU",
		@"eUTWWmEORZrPsQuksv": @"fNMMrCCvlwVjkYKcsLsfBjNmReHIQRXeUBPnukkIHzgKCUseXlDgKHMuzZXkWhGPUPrLWxYuMNwVZwCLpVwedzCenqKytVoaxJyQUJfzmjYwmgbfcFUSwbqGdydQuYpJ",
		@"xUHTqfyJpXz": @"NevNxzhmQfywUXMEMdSXsFPKJuBJfrouodHTHzKyGAjSsWdhSrkkFAyrLJNRMVbDszuHKNuaAQtRQXQlARybZABgaYGjWjQelPgXiCgwKAdQlXBaItQBRFXmLczCPlLXKQRIsDzkuRgDP",
		@"oIcmcmuRZEtKMjfv": @"ejKRVuCLGGAEGyuUpJsBDBNVIQyTKXGBqfQRifmihqAIibpkzmgBQIxcCMSmbovFGhltWftqCvfFlUWTBlqAdSeKHaboqojGvXqGjJXDnBg",
		@"NgOdUYbLMCJHkSAt": @"ZSFwAWlrilLuVTPAlxIilLCNiKQPLOVazOyXgkWUcQmdOsVpWsrmWfMyTMVXTExJIzCbuGQpMpqsLALWqdbUhOVqPDXNtyDCXfJOPvlgdGzmDBCpvvgCwCyUwpWUphkMpJGzVWolpLTYkPLAk",
		@"SfiGyqsAfFafUy": @"dxfOHqVtNOQpZtfvJIMDwCEUkDOwPCtkiMymaaaVhFLXESWTPJlvppwrJADicSTvszJGffKygiXblNnTjvLxALtFLjcBTglVbwBSyDYMlInqJtNZUnJWoZn",
		@"EKBCclsJgk": @"wEXTfqgoliMaKtXVCbzEUQTZxpuexDsBtVvlVhpiJEEQYSVIFxFPeRRVmpqDRqeJRrwyBmRKsxGbNGBPdFvqDYbYSSLhgzTeaAutEfwFnVOXIfatoUHFQz",
		@"OuyMWjCyCWLlv": @"eXNifaKlfVzjgCEcLciZHmbeGnLTUyzyMRGPNkZLnqeLgFUNoMEhKABkjKxpuLmwLwZfeUTasEUmuuLDkGzGEgkFWdxsZqyiAXgbg",
		@"XNAWeWvmHhioU": @"hMwyhiNzqGSIRHGDUEAVHmfYVSGEOErqLZFPAjigAonzMAPgmhMcVBhCJfvxpKAgmdVKYsGwhNENjgfTTasZzzlQALAIXeGUbjAdIhAuNjtnyMABLhuNtGPoDcoZEwBLlWX",
		@"cyDtdeKtCgOPHtXfpZ": @"waIjfLBeqlpkWTDDyGqMMoINESuByCwOpOEqFUqMkwWtfOjNMNMRJOVnHBdqlyymcsSwwKLxbSWPNGtaEEngjheqbnSVLVCrqsbjNlH",
		@"TKLZwLKsCEBb": @"oYryiONrIisKywuIEQdJWlnVIxYcoirlpToeuRJwGCukOvCxwweBDLLLRWijOZKEXXArCOPtjPEIlJCttwreddRfAiIaKEWfWNyyBOYEIfK",
		@"XhrzRfgxtqAScyi": @"otXTDKGuDdpIYdRklUnAeAELBmkQjJaooDVKBBXTyyegbcwZqplaKBzFlPTjIFuGpxIzkeYpoPdeUEyMIHGFYoheeeIIHEEfgLIs",
		@"sKLiJNaoum": @"bBxbTLYbgkhXPgpbPYuPwSNGKyxiDjzJDsvNOYBkdTQxQFvKrDVKfQukGrrBbIkuMXHgDSIhcpRRIIgENdjFhtKxkUvcFDNvtwaUxVrAOCOLLBzcDzmANkvFUyZUfGuVzZimXW",
	};
	return sotFTCtlmxqfE;
}

- (nonnull NSString *)QtAbUkrgQGuPgO :(nonnull UIImage *)OAWXLSLYkzhvcWr {
	NSString *tPdpKVyvWzOEmS = @"gUVlUBfGseVdQPFEgsPniluPKEQmhuaOKYHSdKgTPvzmVyLImMKZXfbOhFJHVKweGXtddmEjjKafXryDReESAqrbIiEIUMYyOWCBOuJeVZgXWxmDdcHKRHiHdxRDK";
	return tPdpKVyvWzOEmS;
}

+ (nonnull NSArray *)VdgfQwUcTJKazJTzz :(nonnull UIImage *)gPOePTfjLzoVojWTkDZ :(nonnull NSDictionary *)YcHFDQZJvTKiFRla {
	NSArray *lcYeyjGAGULpFR = @[
		@"rsgmyAeZNMeHFSzSOmxAiQRyKDwHUDjeBJIzVpFrUvoAKUAnjNOxxxSujMtECTnqbuUWFPiluaFEnHTiJbwHCrgKlieYuvgDAveqgaMEPBUsWJnhPTcFFcjypDwbAyNhGBXL",
		@"xCLDMsGBJUCNllSezUmelsctEnvHfWGdLpjSCtGpDkoenjpScvOGHNexqCSulfqGmmzWNrVjatnWNwRLGbrpmhexLRBWKFbQoXszoYDqBYuPtOJJVhweyVCNoebaoThNtNJzxwsGs",
		@"cKhEevbTzDpzWbcbMIUGpZzjcwPtXuvDpsjsgtjiiEbqUWircTBsQfNgRhLdbYCAoXfWfVyXDPjotXPLhbVEVjMTMjGtRXcaubVwbpgjrQkYxleIcVTEUCCEPyhDDbianPpEIncdHDUVMjr",
		@"FQiGWxztJJqrOxnUhQHcwWyznbRhfSunyGWXrLXypnRMwrAdSXrKMLAiHsqMrStpIaUVuQpyByeeShwyUYoEXazAFqsLosmCaKJOmHftUoYygsDmzlNiSnOzCoHPTNp",
		@"iBywfcqOwzEmCyRRknKLeZVkoikrlQxSTJywZDuwqCviMQmmeFaTHxSLrgfmvmZACScJSkOksWSPBhlQoQgvvwDItnEdVTRaZmzwaBjbYBwqyVvaSzWRWUji",
		@"ZNmUjWKkGQrgHtkmmKYFPsInYeYVWVuCnRzfJQUPFZachtLBhpCfSZItOoTyIaKoijcyKVHIJSzIUJzPNMHUbNCnfHDZvbKuCyGDoWMGPUjdbnXHsiv",
		@"TYptzfqyjDnBsAfDcnWSKfGuHDTMzRNFHHUuZuzsCPEVGLvWLJNSFGwjJQNrBuhXROGqmIgAZUrBAXhbqCAEUiTQZwWigLEFdwEMPFLLpIxVVUbkZGnKhahmI",
		@"wZlMGUfghTPlxTjvwuDsLqzVrgKpKGvyyFsbZQgskSKUDsTUAmTfQYhyQLjJaQJdTBcCXOmjnLrESBPLXpuLnXxAgbnPOiItgqzEYtEtJLqztbPrWKlpGFfkBPZibbWCBitF",
		@"zLpXUDiKGMgDnEpUlPrbdVwiKaXDgLzjLYldIoJbQFIcWqGLSIExIHYSxBArPeuWylZefJQVQNfmZQXuMKqLTmTXOLDpALTGCtdtpMtqxeZTKhZvwsh",
		@"fuKHAhvDIERkXoCgeqKsNPydOdEeTLlneIXucdqMOKGaXgFQekhRJRlIgxmxDYddPzpoEEswOvVhXLfcUOUhhNaSTVqrTuujuDAvREdtweIcBYgsnBg",
		@"hluCgrFOJZsgHqDnVqGvvzTBhkOmYTGQidPVtnoruJSoXGmxdAlEbFxeVpFShEzNnjgZExbsjQafkjYeakrxSXTbMqVggaRUHbYgruRfTreICvJfS",
		@"kEIKYpHhfJwsvpUNQVICyZXhWCLibuZPtjiuxbtiAHkgGFoYpJPqJZZyjmtGyWPYRdxZjybWfZMGIYevTmaiLzjmEihqNlzwmFeQFukWaka",
		@"ngolNnTBvXauRHJUErAytEDEpDnBZeHffzeWtvbqevOBCbBDePUbyYdlLcCOkbuOTkEhmndlCMBpEZyjixwMpWHnNfqWoOEoyttWfve",
	];
	return lcYeyjGAGULpFR;
}

- (nonnull UIImage *)wiEJMPJvSrxUmCBkONW :(nonnull NSString *)qiDVnqawkRO {
	NSData *BmQulyjqmFdmTWGpoV = [@"tCDAOfaXfydUlXmGvtnAMQGfWAbtclSbUVaVQfowdniPdCDotrykcDCJeUnNmLgnSsjMYGkFWCjlRCJzuDelpExKwGpuPTEjmBkHdnsLBUxBCPqNgsOZesmXPrDySCwZaGONfbwjbk" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *IlrOEbJJNAiDcIJ = [UIImage imageWithData:BmQulyjqmFdmTWGpoV];
	IlrOEbJJNAiDcIJ = [UIImage imageNamed:@"sAIdgDXtrypfOskKBASrzHEAJbaVbREoBsTdtfcsAVuCoElEinjYODkzbVmmlaoJbSTFnhXQQEilFhpheMrKXRRnfhapvxmwTyVFVwKisUJSPXRVoZrGdPOuFjUjdcYsiFr"];
	return IlrOEbJJNAiDcIJ;
}

- (nonnull NSString *)PXQDRKoJAi :(nonnull NSData *)QyIzxSQwVpMmSBpmZD :(nonnull NSDictionary *)vsTsjfshartljyo :(nonnull UIImage *)lzlvzxMnjK {
	NSString *domTdsFSqXvkTgURW = @"SBqmyMNVkoaybCwtQoCbYZSrhKIyNNAtJHGDZZzThgOfNPMBXLzahFzHNOvivWWFDNeePNLjbrBKQFzhxMRCfWfUTRRyGQEOcKzCPhJlQzwrPRgOiZquIcjAAzGtrFmXcrIzmyHiMplEKKJJOhm";
	return domTdsFSqXvkTgURW;
}

- (nonnull NSString *)MYnzkstmVOIApdU :(nonnull NSData *)JxrTyTfXbKJRjvTB {
	NSString *rGTjJIUbDyPmcJzNu = @"WqkOFfsznGULzHPOnApTiKKCPGfoKyeAvDGvTvpyNRnNHEBcCZVuFJVCwEaIHFBGYCIfSzCEtZZoohQNEOWXzAZSWezbWekFqiEAdtdjNHyBZHBOXpMlCJfeOnVSgmQOqAvb";
	return rGTjJIUbDyPmcJzNu;
}

- (nonnull UIImage *)VhslfLeHCGW :(nonnull NSData *)QbKDGpeATmSWvEpgp {
	NSData *CwlaEOYuFTtqrLmSo = [@"aLOUDPUluGtLZefJuhFSKDdJewOdtjlrIyBQzxEeaqeKQMKgnvDTmBnOKmNSiDdcbfJoTaKVRfTRoaurtiegZArQjNrSOEGkDpHRELR" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *izmLKkrKUdbzJS = [UIImage imageWithData:CwlaEOYuFTtqrLmSo];
	izmLKkrKUdbzJS = [UIImage imageNamed:@"wiWFDqxqIHJeIdUQmYTuCVpoyeXvbDzNjFtseMTXiARVhqeyDTRSKfvPJhNRYGPcjMuKxARuvsnJZbfMehENgFvjyAblbLAULiOmIAOnaiY"];
	return izmLKkrKUdbzJS;
}

- (nonnull UIImage *)LzRFmbPMDcKmDcGwRx :(nonnull UIImage *)QDLxZfJfJSKTaS {
	NSData *csiaqlVSldkAaBaRN = [@"LTxNXpIMHfnleLnWWtNlvwQSCjuiPCdWPCKGDycYPDJbghIxzwVDBmCvCGOOnXaTodLBXimWFoRYuqsdZxQaVUxUINqItmiwGHhilOrUJbbD" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *VKmyzTfnFjx = [UIImage imageWithData:csiaqlVSldkAaBaRN];
	VKmyzTfnFjx = [UIImage imageNamed:@"pfgXtxQlUuIfdKHAdKiTZTNUKwSKupVlhAUQZZEnjxfbwtHEdusPeHHmcmxAAESJbhOAmCEJzEHXrIiaPBtUsErPvNryxOdKvUNcpgWAOHnBVgMPSaUSLViBIwMcsDvqSaSWasCbb"];
	return VKmyzTfnFjx;
}

- (nonnull UIImage *)BErvIvDQLl :(nonnull NSDictionary *)SCWXNEaKXtQneuiMUa :(nonnull NSDictionary *)nYqwWccTGvVRWOSWqi :(nonnull NSData *)WBHdRxXNvEccfSvvxw {
	NSData *JZGONetMrFzcNMEDK = [@"dePfcZUkqgWpiksILMioTiyRLzdeVdtZDTYuWJPMnEoHPJePCoocwNXFdnCfZGjnJCEvJfhOlNuknhftkbewdhUhBZxMgZcZAQdLGSqPOMTiXLdZOBkUwVYNVJSNsrc" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *JAVSPTUCAJVNuPbQuU = [UIImage imageWithData:JZGONetMrFzcNMEDK];
	JAVSPTUCAJVNuPbQuU = [UIImage imageNamed:@"OnGZsFuOTFDrniynKyrHyqWRvtpnRjWJOJAmylNwCaRHgDMevemZZPGqIRIldiRHWbruMTrVUQyrjqpMazRwivMzFPHBBnBaXpEraZIXHsUqn"];
	return JAVSPTUCAJVNuPbQuU;
}

+ (nonnull NSString *)eedkUkUTQuqgqKcKv :(nonnull NSString *)kNsDFjffomG {
	NSString *mrbgNhcVZcx = @"XOBOMALPQtXNSHPqDPYNamYntEUhTKBeuEkxutxoZIBkBXmjatUFMJrafXosIXnDAOeBbjljNEHKCtbPAUKvagSDKvebkKjeqdFqXOfnHAQANNtlVNITvqpUnVRkDfVGqmicDkM";
	return mrbgNhcVZcx;
}

+ (nonnull NSString *)HaBELFrwjsiYyPEa :(nonnull NSDictionary *)iRNvpwwXTpoGtzdMZ {
	NSString *cNTkXKqqICqaWiPzVm = @"BcojmldPlRZcUgxPjWVEwwSKEkRcxfChKEobWjslJObNGZXQtsUROqjlYLLKvSawZqygrVDgwUWzBvWkQacfnbNrlAQSigogSQzqgMCnMkYBuVWvqnvkkiLhETXZaTDHilX";
	return cNTkXKqqICqaWiPzVm;
}

+ (nonnull NSData *)rBvxdJKivRbqk :(nonnull UIImage *)YoXzQDxDrizJpZJoGJ :(nonnull NSArray *)KrGceCSKQLYZzzigwm :(nonnull NSData *)juXRIUsmgUatBziaFgo {
	NSData *rIjfhAVYgRmfZODu = [@"PTxkqUeqDbPmtPuKhBzzjMJQarHUebiKbnOzeUqMTxAeHIhRCLYXcBgZoVgHfYuGdXtgiYjtWyalWbOobpxwzbqdvhHlDmNDTYsXSGKAwNIsuIpfrXgdpQShcimAbLdtTqQgNGjDYNoBj" dataUsingEncoding:NSUTF8StringEncoding];
	return rIjfhAVYgRmfZODu;
}

- (nonnull NSDictionary *)sBaZSavsveLUBJhEoxp :(nonnull UIImage *)ZzUGfJrdcw {
	NSDictionary *vljggrcrkLLgNykIeW = @{
		@"VAusfgzScbPH": @"OfjCidhboXxwOClbLQNgOngAwxtabSigFbsWyaujOmGnaKnrMWFwORlevtrtmKJUXIWpNkDddBVxEOnKmLEfdqSvXSnoavNOmaWUZDMhEbZwYKnBvnrhuFcuMGvnBiljUsJrsW",
		@"pYUdpTISaYzHfG": @"mHusuSKlNHNrDTTKXuJvAaedzPNzhwVfJHSMhknHyxjwgjUwVBuMhJTjFrvuftjyslVuatqpleUSDKIRlZSNdlvxCcanmTqLsKJguNUrN",
		@"ZePlymDPKte": @"HkruZwJsWJgYhNLWAKbxPoTDzfEbaoHiVKewQnfppcOEVCbgmbDkGiPlpgitQRWKFMrxVKsWpIGxxXdOJdzErsLwJpvHistkqJNpNcfZzZTtA",
		@"GNDVsEJEJXrAfa": @"TdcOxICLCTULHIgZyLvhKskeTDRsZbxGRAyBWZDwdOulPOpcGNUHjUSuMeINRVOYgYGfhAnAVggjArUywdhpUGUyRsYikypPFRfcTnKCcMLcFbuOFHPwWu",
		@"kKtjsiTLyngU": @"sjoxyVPcQJNdlZnimGVMTnRrFbYtfcChlergAAXujPspzKYtuzszsInpNHogfBzTyhSmJEpFFJRushdkiWLLjUskCAQOvFDFFVJi",
		@"JVqxqXfPiGlRepVKsH": @"SbBCdyXRfSVEpWuXLoCthLGgiJWZikggdkPhoCHNQjwAqJZUMzKuhyPPpgzrfnAAWngKCjdyJnfjAlBkxJcpYNLGRFWJEPWdWvmmstSrnNpHrTkhjWFQ",
		@"LVTmFJRaxxgFYAK": @"oovSomcIxocEKRYRpThGmLwwpAZzdxXqFpUETdYBWnFcSnfCgMtPZUAwFnmadNbuqzxmXKzAOxPqljXXiUCMDyxoEAqOkdEYyDjuJqDvVZtlHIJjKskXdGEspVOt",
		@"aRPuNZSMxYwA": @"BAEEaFCVwCsmLmZGQLjahKudCpCBTiIiPLiacWpyLquKRvboMKviYYoMloKWkARTNPobTXWxTxmOozqbFLRnEUXxRBGTMnYzRtasdcJLAiBPjhLjgE",
		@"InvqrDBYXODYNIc": @"tQdeGVjyQghZfuJHtZVsYMMwerzWsfaxwqRbehKFXIUudxWiBWonUTqtTSISzpImncETQrgRXDXImyEGLhhspZQmwFVfEmlubhnGcOkGorEimHTuwAGApOaMoptDsgkCfKXOkIQtGPMffJhTeiN",
		@"fMkIILAxmBed": @"AHnVSnBDaaEObsGfWFKQAuhHRfHUiKCUwDxxfkuiDoZnkDwhRjTRxSquSrHSnvkvVcuLpdGUlSWyOZvYlLbddmMCTGZNNSbYXdGwzFTBqRpAapBGHTsQpknNXF",
		@"CtHglzSnQBASJEFwZSz": @"TpNYipcNJSXyUMORldENtqeOSINFfFNjqGMSzqijUuRgTXpnaaNcVkIZCEqkdCSsJOTvhbIigxuKXSZkNTjmiNMaDMGmjKeJvxVLyLUkJESSpzB",
	};
	return vljggrcrkLLgNykIeW;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    [self validateResponse:(NSHTTPURLResponse *)response data:data error:error];

    return data;
}

#pragma mark - NSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.acceptableStatusCodes = [decoder decodeObjectOfClass:[NSIndexSet class] forKey:NSStringFromSelector(@selector(acceptableStatusCodes))];
    self.acceptableContentTypes = [decoder decodeObjectOfClass:[NSIndexSet class] forKey:NSStringFromSelector(@selector(acceptableContentTypes))];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.acceptableStatusCodes forKey:NSStringFromSelector(@selector(acceptableStatusCodes))];
    [coder encodeObject:self.acceptableContentTypes forKey:NSStringFromSelector(@selector(acceptableContentTypes))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFHTTPResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.acceptableStatusCodes = [self.acceptableStatusCodes copyWithZone:zone];
    serializer.acceptableContentTypes = [self.acceptableContentTypes copyWithZone:zone];

    return serializer;
}

@end

#pragma mark -

@implementation AFJSONResponseSerializer

+ (instancetype)serializer {
    return [self serializerWithReadingOptions:0];
}

+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions {
    AFJSONResponseSerializer *serializer = [[self alloc] init];
    serializer.readingOptions = readingOptions;

    return serializer;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];

    return self;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (!error || AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorCannotDecodeContentData, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
    }

    // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
    // See https://github.com/rails/rails/issues/1742
    NSStringEncoding stringEncoding = self.stringEncoding;
    if (response.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }

    id responseObject = nil;
    NSError *serializationError = nil;
    @autoreleasepool {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
        if (responseString && ![responseString isEqualToString:@" "]) {
            // Workaround for a bug in NSJSONSerialization when Unicode character escape codes are used instead of the actual character
            // See http://stackoverflow.com/a/12843465/157142
            data = [responseString dataUsingEncoding:NSUTF8StringEncoding];

            if (data) {
                if ([data length] > 0) {
                    responseObject = [NSJSONSerialization JSONObjectWithData:data options:self.readingOptions error:&serializationError];
                } else {
                    return nil;
                }
            } else {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedStringFromTable(@"Data failed decoding as a UTF-8 string", nil, @"AFNetworking"),
                                           NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Could not decode string: %@", nil, @"AFNetworking"), responseString]
                                           };

                serializationError = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            }
        }
    }

    if (self.removesKeysWithNullValues && responseObject) {
        responseObject = AFJSONObjectByRemovingKeysWithNullValues(responseObject, self.readingOptions);
    }
    
    if (error) {
        *error = AFErrorWithUnderlyingError(serializationError, *error);;
    }
    
    return responseObject;
}

#pragma mark - NSecureCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }

    self.readingOptions = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(readingOptions))] unsignedIntegerValue];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

    [coder encodeObject:@(self.readingOptions) forKey:NSStringFromSelector(@selector(readingOptions))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFJSONResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.readingOptions = self.readingOptions;

    return serializer;
}

@end

#pragma mark -

@implementation AFXMLParserResponseSerializer

+ (instancetype)serializer {
    AFXMLParserResponseSerializer *serializer = [[self alloc] init];

    return serializer;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml", nil];

    return self;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (!error || AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorCannotDecodeContentData, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
    }

    return [[NSXMLParser alloc] initWithData:data];
}

@end

#pragma mark -

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED

@implementation AFXMLDocumentResponseSerializer

+ (instancetype)serializer {
    return [self serializerWithXMLDocumentOptions:0];
}

+ (instancetype)serializerWithXMLDocumentOptions:(NSUInteger)mask {
    AFXMLDocumentResponseSerializer *serializer = [[self alloc] init];
    serializer.options = mask;

    return serializer;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml", nil];

    return self;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (!error || AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorCannotDecodeContentData, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
    }

    NSError *serializationError = nil;
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data options:self.options error:&serializationError];

    if (error) {
        *error = AFErrorWithUnderlyingError(serializationError, *error);
    }

    return document;
}

#pragma mark - NSecureCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }

    self.options = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(options))] unsignedIntegerValue];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

    [coder encodeObject:@(self.options) forKey:NSStringFromSelector(@selector(options))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFXMLDocumentResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.options = self.options;

    return serializer;
}

@end

#endif

#pragma mark -

@implementation AFPropertyListResponseSerializer

+ (instancetype)serializer {
    return [self serializerWithFormat:NSPropertyListXMLFormat_v1_0 readOptions:0];
}

+ (instancetype)serializerWithFormat:(NSPropertyListFormat)format
                         readOptions:(NSPropertyListReadOptions)readOptions
{
    AFPropertyListResponseSerializer *serializer = [[self alloc] init];
    serializer.format = format;
    serializer.readOptions = readOptions;

    return serializer;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/x-plist", nil];

    return self;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (!error || AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorCannotDecodeContentData, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
    }

    id responseObject;
    NSError *serializationError = nil;

    if (data) {
        responseObject = [NSPropertyListSerialization propertyListWithData:data options:self.readOptions format:NULL error:&serializationError];
    }

    if (error) {
        *error = AFErrorWithUnderlyingError(serializationError, *error);
    }

    return responseObject;
}

#pragma mark - NSecureCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }

    self.format = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(format))] unsignedIntegerValue];
    self.readOptions = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(readOptions))] unsignedIntegerValue];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

    [coder encodeObject:@(self.format) forKey:NSStringFromSelector(@selector(format))];
    [coder encodeObject:@(self.readOptions) forKey:NSStringFromSelector(@selector(readOptions))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFPropertyListResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.format = self.format;
    serializer.readOptions = self.readOptions;

    return serializer;
}

@end

#pragma mark -

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <CoreGraphics/CoreGraphics.h>

static UIImage * AFImageWithDataAtScale(NSData *data, CGFloat scale) {
    UIImage *image = [[UIImage alloc] initWithData:data];

    return [[UIImage alloc] initWithCGImage:[image CGImage] scale:scale orientation:image.imageOrientation];
}

static UIImage * AFInflatedImageFromResponseWithDataAtScale(NSHTTPURLResponse *response, NSData *data, CGFloat scale) {
    if (!data || [data length] == 0) {
        return nil;
    }

    CGImageRef imageRef = NULL;
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

    if ([response.MIMEType isEqualToString:@"image/png"]) {
        imageRef = CGImageCreateWithPNGDataProvider(dataProvider,  NULL, true, kCGRenderingIntentDefault);
    } else if ([response.MIMEType isEqualToString:@"image/jpeg"]) {
        imageRef = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, true, kCGRenderingIntentDefault);

        // CGImageCreateWithJPEGDataProvider does not properly handle CMKY, so if so, fall back to AFImageWithDataAtScale
        if (imageRef) {
            CGColorSpaceRef imageColorSpace = CGImageGetColorSpace(imageRef);
            CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(imageColorSpace);
            if (imageColorSpaceModel == kCGColorSpaceModelCMYK) {
                CGImageRelease(imageRef);
                imageRef = NULL;
            }
        }
    }

    CGDataProviderRelease(dataProvider);

    UIImage *image = AFImageWithDataAtScale(data, scale);
    if (!imageRef) {
        if (image.images || !image) {
            return image;
        }

        imageRef = CGImageCreateCopy([image CGImage]);
        if (!imageRef) {
            return nil;
        }
    }

    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);

    if (width * height > 1024 * 1024 || bitsPerComponent > 8) {
        CGImageRelease(imageRef);

        return image;
    }

    size_t bytesPerRow = 0; // CGImageGetBytesPerRow() calculates incorrectly in iOS 5.0, so defer to CGBitmapContextCreate
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(colorSpace);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);

    if (colorSpaceModel == kCGColorSpaceModelRGB) {
        uint32_t alpha = (bitmapInfo & kCGBitmapAlphaInfoMask);
        if (alpha == kCGImageAlphaNone) {
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaNoneSkipFirst;
        } else if (!(alpha == kCGImageAlphaNoneSkipFirst || alpha == kCGImageAlphaNoneSkipLast)) {
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaPremultipliedFirst;
        }
    }

    CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);

    CGColorSpaceRelease(colorSpace);

    if (!context) {
        CGImageRelease(imageRef);

        return image;
    }

    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), imageRef);
    CGImageRef inflatedImageRef = CGBitmapContextCreateImage(context);

    CGContextRelease(context);

    UIImage *inflatedImage = [[UIImage alloc] initWithCGImage:inflatedImageRef scale:scale orientation:image.imageOrientation];

    CGImageRelease(inflatedImageRef);
    CGImageRelease(imageRef);
    
    return inflatedImage;
}
#endif


@implementation AFImageResponseSerializer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico", @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", nil];

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    self.imageScale = [[UIScreen mainScreen] scale];
    self.automaticallyInflatesResponseImage = YES;
#endif

    return self;
}

#pragma mark - AFURLResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (!error || AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorCannotDecodeContentData, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
    }

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (self.automaticallyInflatesResponseImage) {
        return AFInflatedImageFromResponseWithDataAtScale((NSHTTPURLResponse *)response, data, self.imageScale);
    } else {
        return AFImageWithDataAtScale(data, self.imageScale);
    }
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    // Ensure that the image is set to it's correct pixel width and height
    NSBitmapImageRep *bitimage = [[NSBitmapImageRep alloc] initWithData:data];
    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize([bitimage pixelsWide], [bitimage pixelsHigh])];
    [image addRepresentation:bitimage];

    return image;
#endif

    return nil;
}

#pragma mark - NSecureCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    NSNumber *imageScale = [decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(imageScale))];
#if CGFLOAT_IS_DOUBLE
    self.imageScale = [imageScale doubleValue];
#else
    self.imageScale = [imageScale floatValue];
#endif

    self.automaticallyInflatesResponseImage = [decoder decodeBoolForKey:NSStringFromSelector(@selector(automaticallyInflatesResponseImage))];
#endif

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    [coder encodeObject:@(self.imageScale) forKey:NSStringFromSelector(@selector(imageScale))];
    [coder encodeBool:self.automaticallyInflatesResponseImage forKey:NSStringFromSelector(@selector(automaticallyInflatesResponseImage))];
#endif
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFImageResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    serializer.imageScale = self.imageScale;
    serializer.automaticallyInflatesResponseImage = self.automaticallyInflatesResponseImage;
#endif

    return serializer;
}

@end

#pragma mark -

@interface AFCompoundResponseSerializer ()
@property (readwrite, nonatomic, copy) NSArray *responseSerializers;
@end

@implementation AFCompoundResponseSerializer

+ (instancetype)compoundSerializerWithResponseSerializers:(NSArray *)responseSerializers {
    AFCompoundResponseSerializer *serializer = [[self alloc] init];
    serializer.responseSerializers = responseSerializers;

    return serializer;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    for (id <AFURLResponseSerialization> serializer in self.responseSerializers) {
        if (![serializer isKindOfClass:[AFHTTPResponseSerializer class]]) {
            continue;
        }

        NSError *serializerError = nil;
        id responseObject = [serializer responseObjectForResponse:response data:data error:&serializerError];
        if (responseObject) {
            if (error) {
                *error = AFErrorWithUnderlyingError(serializerError, *error);
            }

            return responseObject;
        }
    }
    
    return [super responseObjectForResponse:response data:data error:error];
}

#pragma mark - NSecureCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }

    self.responseSerializers = [decoder decodeObjectOfClass:[NSArray class] forKey:NSStringFromSelector(@selector(responseSerializers))];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

    [coder encodeObject:self.responseSerializers forKey:NSStringFromSelector(@selector(responseSerializers))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFCompoundResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.responseSerializers = self.responseSerializers;

    return serializer;
}

@end
