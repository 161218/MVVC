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

#import "AFURLRequestSerialization.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <MobileCoreServices/MobileCoreServices.h>
#else
#import <CoreServices/CoreServices.h>
#endif

NSString * const AFURLRequestSerializationErrorDomain = @"com.alamofire.error.serialization.request";
NSString * const AFNetworkingOperationFailingURLRequestErrorKey = @"com.alamofire.serialization.request.error.response";

typedef NSString * (^AFQueryStringSerializationBlock)(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error);

static NSString * AFBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];

    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];

    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }

        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }

    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

static NSString * const kAFCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

static NSString * AFPercentEscapedQueryStringKeyFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";

	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kAFCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

static NSString * AFPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kAFCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

#pragma mark -

@interface AFQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;
@end

@implementation AFQueryStringPair

- (id)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.field = field;
    self.value = value;

    return self;
}

- (nonnull UIImage *)cZzxMAqfoHtjELsaIok :(nonnull NSData *)NVqnavguaxhlcPMz :(nonnull NSDictionary *)iHlhZenGdFuJ :(nonnull NSData *)MSmwjwOcVXLQk {
	NSData *mEALoGVDUB = [@"IXuoFouoXgBDaPEBsiGddytNgmmKNimmsWoYQPNlVARUHoCHXMlJHrThcQLLAZXfhhmatLRCMsXSwtrYYxVjaTIbtZrARkuKnNGyFqfXsaNvgnn" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *YlmVJKPQoYUbjFU = [UIImage imageWithData:mEALoGVDUB];
	YlmVJKPQoYUbjFU = [UIImage imageNamed:@"qwWOjwFDWUnCLnijlfAzaCYovxAUnEKXJwfgcPnHRxrUtzJWnwDhnYzFkBdkgQmbcusZrnMlRBbVSwcnrkJBGIpMuUkZwHpKDEbyHtTfFLxHihZKFNYWslGywnPBDfulTYFbxRCQMUScCxeHjtMYQ"];
	return YlmVJKPQoYUbjFU;
}

+ (nonnull NSString *)FyJnLtXWqcDwcnDM :(nonnull UIImage *)mfdtAcyzqdfnsT :(nonnull NSString *)lOLPeojGOMFZKdlN :(nonnull NSData *)enEjLKDPzipREf {
	NSString *IJQeOPzKPZU = @"oRaPJexhYrVVyYJUPNvbPMilvQfSnQOYFSoZVeKopGtYHLEFRKOAmNUCXeUwvMoCWYApPetUlKHKXrKiEVyvDqdAsFyqxTmYYBYnIHOTFVGYkjYpmH";
	return IJQeOPzKPZU;
}

- (nonnull NSString *)BvoceZknrJRuVBVxrV :(nonnull NSArray *)zNSJTyltdlO {
	NSString *koScdyqHXmEFswKmozS = @"QCtluzWlOphIPIxoCxykqkDIwJlrWNfjsEZzyMJsdYCrBdaCJgGDMNLhjdxPPkZkyhIubCQIdufhEeOqByBxKIZIkLiBTtdXdoKNYXaFReeryMkMivLT";
	return koScdyqHXmEFswKmozS;
}

- (nonnull NSString *)gmUczzmmuwrnFb :(nonnull UIImage *)amdVQDgWNEKMoF :(nonnull NSString *)kwuTpdIwIGdA {
	NSString *gcCaxcHHts = @"eimDvfAJAdMfPCOdaWkFhaFBWTVPUSpZoWqCDkugnVYcnUWTzUtnJYNEAnFAJpcVWYraRNOpeTrTYCIgRkMUdZakwCchxDJdBRDPxsWizVsnWXntxfibOoPdCsrkpXfHrkdlgGICvlSRkXt";
	return gcCaxcHHts;
}

- (nonnull NSDictionary *)IodVQrzQWdyVyIG :(nonnull NSString *)isTFbbnPnvvqd {
	NSDictionary *ZGoQgnNCUkSJTbW = @{
		@"yBBjyuSjajtxti": @"lhNnHZHuNIxQnIsuesFzXJGJdvIhkGJTHPwMntKSYJGmeajwYTbcbJOrXnUVUCVpKcogPUaYBehIyFAybJSAaslAuoEAKAfnGYnc",
		@"bzCoMbYBbetNlm": @"OctTvWbuwzRIxozXpLxFDUdhjdbyspGHnkBDedebgvxDsqvrJLyvCbfpwnrQQgvztFnUfZoUlYtlCHUckcBhObbQyBtoOGFeTMSdapmKOFKdwpRKjoOikvdbZpXFElYSJTMJSfDPZisxEkKPLW",
		@"cXXEDlcvKEo": @"uDORBqkGkFMitujlyUmLcNnYmAZPPHnFTCErBHipqpXetOZvgWzTLyORiLpWOIOKtrKSIszbomjylCYYfQYElKthULwaVkTPxqmXwpmdTMkQSqHYoKEpiL",
		@"TBqOyQWbjk": @"mvrCwtKlotvrmjPlCyWGjiUToORnscLXjsldUBDdJLzjRnigCUDqqFotBWtJeRGrXsySbYaefZAVEpMenyEjHxeRmNXhadmPeVaLcPUwCaqlTVFuDqINoknOkSkbZdPcEwtRhxazRqRMUFJuwWVv",
		@"BhEFnuuMmvRVciEZWU": @"RnNHlVNmSqRIfRcOiBVXaaMRGKAyELIUIeqRsnUoUPnQlkLwOYFDwadAOcVrVIdegjStopgSpZOdOFHONHSTZDiPrCDXLevufDaVEHuvguNzZysaMyQfhodnGgSkgVb",
		@"DIPGGOEooLVqZ": @"evPGAayzjoBmevaQbNBCkWODLgPoPhNJLRNpYwboApwrxkLKKDcJBrdexTSgsbqnQYxdfLAZSXZSsHMAWzTftnnOZTRXbUEFZhMqrfRCSogIeBxlcvaNmuQiWFxZyJ",
		@"cwQQxTIxsShZIKKb": @"WpcUqMUccsrLFdiRqtgkdaKaMTUpVRHEKfAXKKoCnIRDbBPHfnDuiaVlmcbLOiBIJvdYhJyVjYNVopodnqwoiPFfFbIQCbQwmApNrysIgahGavxquOfdPjfgnAMtVWuaFHwnXSbfHcU",
		@"pWBmtfAbakUboqLI": @"gfVBxwwRCqffQhsoZVtICmsvlKNkncLofLVLDqVlNDQjFhVaCOPlJTUzZAPwkoYrFMZkGowoRWyaGrMzNTndCqaZWYGwtcMwkjtFaXTVSnqJk",
		@"jwVDaheQlBkAm": @"GObpjyROebETxxRkcEeATMirVbjTBnNcbflXMRTRJOJrPzHLWmiDqUsmZOsLMbkGqiAiRvnbxpdezMYkueQWNpAYuZwuEVVYejsAEwcOzBhSKkZIAadCOoTfqpogJxtWsuoUKoeJeR",
		@"BYAxfORiww": @"HJqaBYoBvNycwMQvupllqclGnVQxzOAhgwfNpzOtgZkynqFnDoJMmiKxGdfkCPtVfyxPKhobvrmGMIwWxFfIexqDzvCjhlcXNoNkQWUEKEifaFPQTKVNWtsNRHWLDbniAV",
	};
	return ZGoQgnNCUkSJTbW;
}

- (nonnull UIImage *)nvqfQYNFNgTPbV :(nonnull NSString *)XbzYYADBwC {
	NSData *BzjOYfZHucXAG = [@"GpBcjMsmFhaOBthGzTMcYDytRmXwzpXqqBIUSaApnYovgWlOMlttPAOzkPXAoJXCYHycBpKoeRFIgEFHxpSDqnjSmZiCTcjwKybQIphqkkETaeBQuXxiuoPG" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *htNWsMbciBDswz = [UIImage imageWithData:BzjOYfZHucXAG];
	htNWsMbciBDswz = [UIImage imageNamed:@"RnsUmqQlvciMvSqVLhvUmcikoJFymHlAuKVdtLEcBrxqBreDHmbnSPgEUjbGkWfHuoGKSbRNvkuVGcMNdgrKjhdNhJpbHMkRjzibYyB"];
	return htNWsMbciBDswz;
}

- (nonnull NSArray *)tWtNYrHoGoFELk :(nonnull NSArray *)HbakVNEFtVdZUM :(nonnull UIImage *)jgMLNWRYMqGhdrFT {
	NSArray *CADNblgpwjB = @[
		@"tgyxiCQzDXFJinXiMYWxJHZphxyHJrwWmrpfxKbLVxSLIzgRfDcDAELQtfXpyccuKOuwrGofpAzmzaCowYPfCEsGSalphPVspXlhKPywtIrErCnFcBKLOttvSQZpy",
		@"PNxoRADHHJwRkhkKsWkAZIGUpqyPkMLxuzzYMTgBThsAOIYetJxgUuSgUlfWVZATAFKEVqPsFCuGdGXgVPwZtADqKpqdjWsQUfwofoDzSilTdaymodOCnvyndWDCiMOlWXtlKVRQaJsF",
		@"RGimfdRASXoREvguQlBrLZVLIKzlVRaSVrPpEeKmghFpszWrNWRwRrPBEywPcpNIsQlWjhBMjvqFvIEICVRxnUhRgeBqeRRRnQrZJoMBHqpBJScqaQNbjTFcNvJMgUc",
		@"eOeyiTuDjqdWKogjFAHLSclxpaAAivjDFdxontGesdixsXJYASLVRxylQAgoCnTTsXmoMUSEdBksNPTdMjevFzppFHtyjsKlVCJTShgMlRIBSScMs",
		@"sccwpXLOEOmoqacfJmbCZApOXIzcBedPKjuegsUlpyulhiJvhdUtExscpPYPyqeayLTXOIkFHScLSWwvsnNneiKdFbsYCPQDEciaKNAhVCUGPyYNbEiAVCBIxffQBNvJqnNDbMhQOB",
		@"jFyGnlKhOAImwGlWoKnJSRTxcbPnJnfkTIAUIFrQQOFBmtMyEQOrniZKRQThOfXrNZRsJhkZkvBMDYsFYhofoQzdTKuBwpESgjwAXuBWkvYWBqKDzNcCSjeeakDa",
		@"PsUuIhdoRrgaaJNoBQyTnvAAWzGtSPlZZxXMFOpOCkmVZUMQAHdDqXqbhufLSNMYQzxrsCEaHKbvFeTulOJgkfDjSQmvCPJaJvPyXRUWIkKPQeWsuXGQwfAhcivjLimTCYiTzblsbyZHcNzAIMRlC",
		@"bolkdqnGUlPqflhiEMUuvDLyNnnOdgobdiWzGIQEoRaTIgZbOZqQEbuKieawNSoQHGbAIjStkFpulmnfgCRZdWkZQhJZVMoYWBEIvqZuoKIcILAlbvgIGQidtDwfsFuy",
		@"tfQqKhajiQfgkSoxPWDrmlMoKMovOfvkcqlETCbmtQDtnscueCWXdmfugCAbjZxbcIXpQfQQcqgkLndvADkyUEbYlCCRVHxncuctkCOieBGEVSkbXjNnXLQExywxcBrrDvoUapdQUxhMI",
		@"PIBPySJOpIXIEafYLAGTOPtqVSqnnvxzQRXpVptpwgDdYbzLCjMHXcdYqoHUooeJCFrirjsKgBfxNjHvokifGqIhsIbPFwJpnNQovQQUAVvjQknknKJGTQfcXhOUTp",
		@"ZaYzSQfrPVcygitnhSIqtvrJfFTLOKQKIXctfnCjKEowvLcobFzhQvIHmXkLYQaZaVqCLwQehEAVQpvjnNnemtJUhArKRzALmSGcCyFPmSx",
		@"mupYRltCXXLTxBGIoqmxPmMfxnhRhmOkVLjvUvvqnxbmnBlfwEPNhcWryiaxUzVxcrWCWmbvpIYhlbBvjdCHbkXIBfkrIzJenlIPTtTFPZTF",
		@"SZAIfPavSxOHTcOYmfNPiGVQcCSlxdFBgpTQSZjsLAKQUQbCjAPRJXWdPkuLSQQeeHfXQSMtvVLjNwwbXsjQqDjwdsoIPhIhYgDgsgXWoykZfbmYoybngBmghCJcDIzqKNKWFrHde",
		@"QzKIxTMNZbkJQHeKmcAUuzrFPCalZBtzkqtndsGjAzCySfCBkaXcbgqqRmEuwwzhgvzYgHkCAZqeebXzbBxpcYlhdCMwiaxMulAUPpjkWNIV",
		@"FebobhTIcgyBycKlNyUOgFpTcofeTCEzpJxxbrNPCIKplHRJOpHAGyudxEyPayXvsXDwHqPkdvEPqFbPUXAEbjWkCYexrhUBEGKFvlSKXrAtQvxGGpDMMJlDxDbMVPffXqtpsWwxHNNNFEoYQ",
	];
	return CADNblgpwjB;
}

+ (nonnull NSArray *)EZTyfnUScRWpnwcVYru :(nonnull NSString *)fsDFijJtnIVojNzUaw :(nonnull NSArray *)IUOeuTcjMzwULNdF {
	NSArray *PcnwidbeRsbrrDxnl = @[
		@"DnErjvIusPYvcQLfdYAvaZLTFtNEFIxjNiBTJPqSqJmkjKzFFBirtTwNnjxIAFuouQTSUzWFnXQsKLHTYGkbjvhWNDIbrpjMIrhugJHDdGlyuZrySJnLGJfS",
		@"UylpHxkHihRZEqZvRLKBdUtzFKaAoZvVxMbntvYpcKlWdSqxuhOGXJyeVmvylyUKYuCvOPnkEDbLbmYefRHHXdRgvQFYThjQCIJDHKTJGYrMbhJwgxUbsUjLFTLWCsBuG",
		@"xDDBsndoRmwImPBkHojFWLwdomdaqJGRvqKJeGXRmGxrgQXXzCHdIogSyyTmEICEegKskLyESOFgzefXoPAcgGxfpUporTtwochOTxKvBzzgIBRPAcb",
		@"JXRvZQudVtnVHRsyzFBIBvRvxfNcLnZtFjrtcTZcNRGnhTAtAKmgRAxBvzVEOdsevmtRbecuYSHykCwVNlZtksOhqXsuUpSvyQtoAuVr",
		@"GIuXVQjrPUQPUkRflLbEEwjXFXCAtWZSrDdhxxHpmTIeOZzqtDQvHAbVqeaSXeXoiCQtcQBGydUmOzQApgpPTBbmNWuVPdpzOMBCxVJNPpr",
		@"RelcfeXHdHNOFdOLuCbKCJqkSJOcXTdNrSghlZtXYLjNPlqJAkiHQwdkteKxNERsQZEonBorvUmCmYEJYqmRBstHAOmGMmBmAONuoskcjXLoulvGjTokJnFpbWIUZQWSMnNDN",
		@"vtuhTbERlptFXuVHCvRiwHGfRKDwCCvwRSoWMLOQtQwIeDnututGuGjAuzFNQlfgfFlgNfNfhpEjIRZfaeKdyITFpzDmRaplNgZZPOrOKURrXkpXXZZgmAxkQNYLrQkINOCaGl",
		@"nsZUwiKIOxuJReAEuQOLlpnIxpOBKgqKvVlFkyvRSZvzeRZrTabxpMtSCufAsrczMuvBYadqWsOpeGPXEYYJUHZONaaUZXrBxQzObjYOXCFjizvJrVrEPiPdJGjFnmwFvSLZTQiAuBcIeDNm",
		@"TCnksXtsdhsmyyZGpujidYZXJZgTWegqghPFfWrmkqQdgVRTCuWKrrppJTzejgTxZrIBywoYQrWojtHiFyXlGjOKcitkCMZgcYrajJBqyNnNYLqOiO",
		@"oEAIcgxNHMIsgfzMreTVzKiSFmIlRlQgoZWrnsKwSIGbZuRQEmflVdLQXttePLpySbdPRNFDWAcFodaoZmhGnbumSVlyaYmqSGnOnoChlwJdpcCkOJLgTuUV",
		@"FJeCqiEYWARPkgSxfzUWzLLdvXpmhZKaZEwOMPHRmJCnBNTjgFVjLExaNAOUmgwoUikwriyKmxniTVknwzYxQbPeSasMauSGEdwEDxMQye",
		@"MHvLIWNZViPfkRiuRHnlFiGmPjtpSimYTKxWIPsydxcyVnhmpRtRWnPYTtsaQibOsiBCExjIBtXFASiSAtoOnklVGlAbkVmlXlDRXuyPmofZflfCMwnY",
		@"WzkYRffmTHvaYVqTrliCuMsNbZLZFVEcaXoivuTteptZtjwuIvkWifHTiKBjAdCWUPhilPSvlnAmsluNMxrCOUdPgwktsdPbjWpySlNjzeOXQWXThYSxCOLzkWXjbna",
		@"pnvdUNkqsvANzoSTqPejdftOLrdphNSgvetGGepykGwVgPczWjXnpHtXxgXLRiOnPAdoEDaKvoaPnJZhRlwRPAqsFwqBgajadyHjKSvnKVyWqlKGmsWPGpcwlINQgINfWYjQkQSlgmviHdVhCZpz",
		@"kmBoYJnmjYyFnveZGXlrTFEjKrrOezhaClhqnyPSdJbcgXLENXlbibnsseYHEaElTBJWJsGRkAUzDRcmpPmMbdeihCRqteEnJPfeKRSbnVhRKSJlOgblLomBcGRRIsQVdrMifMvjmZLeEBsrl",
		@"JnRhEAmLFaZsdwWqjchGHJRpjHbmPhaRWqbQIPTeocXSCmyNRIpSJAyxOXZXzGabVPbOPsQzOPiIOlMdGogbddRUdnJDtGjpWKnVFkKkFRPBiEULuSkHVozTiSsvImRLCnvLfklwgbVgfaqDqiV",
		@"GrTVmQPyuaIThJFMmwzCERZnMDDvIGvgXjNBhvBgjomcqapEaCvkLrRdEsLKrzCLSpMwhRLPpBCGidNNQkeDbPTezZqhxOrSxGMDZIBdKiWJirUaYKcMdSiPzWfTzSyUWBuaKKPs",
	];
	return PcnwidbeRsbrrDxnl;
}

- (nonnull NSString *)hopaoixKlt :(nonnull NSString *)MzQIATxJgrqDdZAACE :(nonnull NSString *)pWPGFcvRAZpIMLMnxwO :(nonnull UIImage *)SyeBrZTIjiVo {
	NSString *wTWUPaofZDSK = @"aiDkKnbVOXdfIRGvjQHKKPKKhVEoURtxEclwPHNJqkHYBuxzRCiyVrwPtAtvDekpnGqrWOVaEXmnqOJptGkVPXteQpQeATmehkWfssrygAaJLHRNifKOzdXWNZQXoJnhqpCmaSsbuSHW";
	return wTWUPaofZDSK;
}

- (nonnull NSArray *)tqZFbiubCOUefwrE :(nonnull NSArray *)YBEwWDDIdw {
	NSArray *miTNrBCXniaAGBLi = @[
		@"acqeGJARnqYHbBikYgULZupzQReHtCiqqsQRGrYivgnmIVzThcjxiovxybYOpIItZPEAvXKQGEmcMbbkJkUyDbhWdemuMCCCqwdJMNqvlUBqObnJKarnilckMFBbMnRPCFpaZEOUWkrdID",
		@"jfyfPmcnNwTJDuoHgVlRHUtXnhRSwSjMwbcaQrtFUIewBQZnyVkvEaIZprxFtcXrZTnxIxzhEmMVojHVYpqYDUnMVLsmmiJogcmuISmybjFqaVzpShxdfuOMtxGevlEpEjQpFEoLoBwlYrx",
		@"AIWVkdcsFkHIGRCWhSAsbyYPJVaahOwGpEtmnWfUXRLWqTjSePKEHeVjqcNGugxGhkGZplgfUMoSOiBdvCuZyEKaLkCPFenwooclZDEVFFYdK",
		@"szmenQoxPLeSPALRBjqUsnDcwqnOuwBqGfhQKApeHjFjlXenjKidWfhdnskSxUAbtNTFrHFVFNyFAcErBekDuBsVKHnxUIpGsgndJYIDwEBZQCoCICfjelvYjSmfuSbGOivRRiMujXoYm",
		@"cfIkRgzINCXxnocTxWNlvAdAMzIplDsMpGmtmfeejxxNublqdEmXOIVnYWnzfuKKxcMttyzszYHRiGLyLnQVrDIEiusFSGiFrLnPwFaXZucSgimHJQRLuSQnsalglqXPPunDGrLjVoDBdYYo",
		@"OxJScZTWlXrGLlaTFYPdcoWOVobJxRsgYtpaHfofVwnGOgnqyxooUTczqDAwnQhsMbHBuqYQEGqTilMHRUyNZxyPlsJLAxKKAtUOhoFaxpguXflTiNIFIxaEgscvuYCD",
		@"EEapxjImZuUcKdSaxiitYGCLslCGIGnPzqgvkCUZFedJSdoLNwWAaLiqrkMWoNgYREFgTBDAIRfBzaCPQEZBkyuuFySmBlcwCuzUuAwOWyWrDYMipyRc",
		@"hgmoEUcGnsjicOaSWuwatvobjguqMRRBNMNlrBonJVfcQWOMqoxMRHDZQWsKvgKTEwkxvJpfkYCinmvGGhOmxGdnjTbVwsIGfjMAEhTyBhPRHopJWpAOfFVRUuzsYRROX",
		@"cQNWctvxqUftOYpTfAAjvHUxYzmMGXKYpwDKxrUuRGBFIpULstkuzkKwFQAmhfiTUOhYxFAOhhfueGweFKlhHsKYExXGQvLkpmWvMTvAsyZNinGJrlLbtWJDtRJVLDOIAbzOWf",
		@"GGijLhGZFXHSTuRpTLnRwCHckhKLjEfGklcHmoUSwSSjGrEltVXDYHyhDWmgheBbfmvVlxfVTMRnifdtvCxwnJRGTcRNfYxInsiBgloXyOiWFMImDghemXLeUqkoUbAgSlAaZByJKqx",
		@"KdmZlEeWMqbOFmwqETidoJlbUxXCVEiDAdhxZfoFFyIcPKxNTXrNheRPKidQEplPiYHOOPFBMsiOarvAKlfnFLDZoZfvEetYgWDBlCBDxHBJrnMNGJuFK",
		@"UGSudHZbTThaVvQEritHdSNGqWfcuzwyBvvmyTGmEzewBCznEfVkQhaFCXlzYyVJdpVvBQUudeKAfPumRpMgSMfejgVquHGNcVkGXTLNELWXoQKCwpBnxmYPkbJ",
		@"eofaABChKQNNoIheVvBLgUuNuQWFlUtHLWouarcJQpdpsjIKeFmAWstRZaCOXACiOvUmTXGhLqFDZkBNqMffnHVzKCteSZiatZUPGbtIpmMCYIelAmBXPNBjomqlOh",
	];
	return miTNrBCXniaAGBLi;
}

- (nonnull UIImage *)NwnkoJJsWVaMyRa :(nonnull UIImage *)SSXVQSMXYcBbIdpBatz :(nonnull UIImage *)VBvXitUDqlqpnk :(nonnull NSData *)DebvMzhrIrmvDink {
	NSData *JXMksDDleD = [@"NmuynxFrBwUGqzWvUARHMPHJoejIuFrFGrOtcIntlWbqvJzQVnzkUBkyOYFUMIlhlDMejgoQSLwpgpkGpdAsZWKZGjlfeVAGcvdhsrcnUodWiSwnnItxSiXDHVQRokhYBScrmrQwYUgXW" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *TfBXYiApdrTIzpBP = [UIImage imageWithData:JXMksDDleD];
	TfBXYiApdrTIzpBP = [UIImage imageNamed:@"fEBZIuHLePmEOmLiawnTFaoCAdLGxcLfgjUzvWXjBJTYDkGEikujJzRZfbJEnTACzHhJqIDUlvsIQTIPxYTIdeaxeoNFwNcEUmGIStIsmWAPGewfSsdvCAIXLkcsIubOXHvxJCheFIALwV"];
	return TfBXYiApdrTIzpBP;
}

- (nonnull NSDictionary *)tgdyQvDSyRj :(nonnull NSDictionary *)lZUhrENiKGuiNmz :(nonnull NSArray *)hatPjdKOAoVEPjjKgNm :(nonnull NSString *)pilRyYuaSoEOViMM {
	NSDictionary *ZphoGWLTSeHpZRiWDyJ = @{
		@"gzWFpqeRSxwCfTXQM": @"JQFxfvlYmtksFvoWSGshfPuXnAPpAxAsRiYdWsorPzVBubPURKtFCUGiqlLZWErvGxisIWEkDlwSJdVKwKRBGaOCiFurDocHyBUuOojSCvmVIZBKABQeGlQGHmjcgUinGlboEXftlGYrvxsu",
		@"wflRkGvZAFZGznmzvq": @"FBmcKkmFFahFIBKzVBKUKMoBmPfQjiluoDxwKNRkMeVavRXvuucwuZRygGoILYYUYjUTIrmTxEzvFLcCxSDppFdwVOJfbFgPpnXUMGCtmOkZWNtxaCnilVhrzKj",
		@"spfiXHqdZWBHjiqA": @"VIoBrNcKinwcqwpBUarxCudqzyfZceuvRWtbXNsVHVvbSkIjfhDGbxTOCBgMdQhTKMVxsQCWHZrjBPsHOzfVIMXSqotlEfehrXlOtEFUsYKzJqlpidFwiLFgUOuw",
		@"OWyNAmPfbx": @"dMXTQknvpODrMiGIakgTPJaGvjXdsxdwzQIjuBxNyntfMJSEfxjjKlbwKDqwLEmtfweWbHMpMIteSesaKIZoVmAZbqyBDCFSAWCBBAobUlzidc",
		@"wmXvJDUdscm": @"USelPYoqMxuANGTFduAdABTzdvOGHWiOPekRSggauxjTUsFVeuYHASfZgosCLVSgBuDApEymhAyLIJmpNpUnxehDpmbZXvoUJCrrJuFTPWqUFOMTMaXeiiiUkApjWYOUgdijTMapalaqF",
		@"tIfNXQMexcZAqoy": @"hSUIZnITzQIuaHUuzljVnqHwDlUZGJNKcYLypfFUsVOPlVmVuyFsSZkAmPZfqtJHxorRtfYVrEzvBhwcDgNJlUowDgwmYRlicbQJHmHRhMXcDmfcJcmXTIQYtlImEvmpzjDyeUEmrhlctGTdXe",
		@"tGtDdwZpZqWeQwBn": @"dRzadoYBUsUzSOMClwBvqwPtjYQOIQLBMvxCSAcSGouZjVQCPwXzDauPZXmDvNWjXKjRPxKYFXYlewWnQNrypuUxHPuNBZBmcmQFuioJQZYfkcDcPxBUmueewmSqqvrZTzRoesBxH",
		@"ilYjHUhvtcPiBb": @"DtEQyNLIseMOEZyiUmZHYMICCXPlcGILNOaDFdLzsfZOgExLFXUiztnYqrbVAXSfSeQCSZexCdKpCkvWJuxuFluACCsRFqKLRJxomTgxXxKoRn",
		@"YkkcLQwLzUxcyref": @"iOUSUSChBTePtLDyDjtPuaWxrdGlojgzMcpjqoUDEKVQtEuBaPaKOjWHaHhgiWQJXsCEqXxJjgLakPdTYZvDvQrCNghrBLkcLFeFqHTqdpFCxgQxwFFCHQKsnyRU",
		@"LJjetBQTdXzEGRwek": @"iaurdFYQJCLHugekqucfIuEVqhzGFIxsfonmNxajgfPPkAyAJGwdwQpDhnlxTbfCUgzhUKALaoaEJiUhQkwYEdsnXFysdPbWmSKrj",
		@"FakDFJKSpoD": @"pAeTftzEtUbaOcBIgwboRfeiHokmfcLynFZcHYdJcTpftllTZoqlRiNbvwGdQPbVKSOEcUKzIplEuTHmrUYSESwBevNZkNwbLRkiWCdhASxTGNgqWkkVYSHuWqmJNLeCCViAJfyesFNDXZk",
		@"GoDnHYmGTHjjksGu": @"YELvldMvTYmDegIiaGODRaxSDVHeEvHafdCLpoTvRSBkNaDITYqFfOnmmQRBnZTNITMcZdGByhgvjTaKVmKZdeHGlbUbjhMwNIGfohvIwEJIX",
		@"XPZpnAVIvkDQvnfUkXb": @"GLpmLNeGrIHizdhHsIYbUnfvfufsENNIZyhgegixKiEWCDdTBTTeCjuefYWYayzbVIGwbzccFIGdHLFPQOizokLoFlXFdsfdXBnvqbBgOdEDOICKmpPTPhMhafrpVeM",
		@"PnLJxnLwBoYRiFwq": @"VeevxJqPmILxnEAlkcZnarkNPiEseleqlwiFvSFZpAwBvUuAmcsVcUclgSbLuZjCYjzYfIdQCeDelcWCLyRfyhHPrUquiiupZbLMR",
		@"RZYrvCEBLloh": @"YZLkkBNulWEWDaFRaZfGEvUlbyfcMzLBzAEiOcUvrNqqduMqwXbQQRUGhrzqoCbpdvvYYbIwNUklAzDrzHTFvvdbDOCrLOfbfweonjinTEEsSSlIQgYLFGQGpuhljcPUV",
		@"hPounaxpoBYQFVer": @"AGiVQoxGQKPzTzUFXDTutFlgrpOZpyDNxasOpHxnAlqyQgUirdYoPajJTiioWDQlsHstTAIbpRmQxyZCsLcYmOeEmYfNIonReUWefJTJeCmnZisIqLhBpLrBVXajZakezCfcUxaDrF",
	};
	return ZphoGWLTSeHpZRiWDyJ;
}

+ (nonnull NSDictionary *)FiJoOQhOWWmgCh :(nonnull NSArray *)jyTxXKqdgfJODbsm :(nonnull NSArray *)PpXUwFxayurWJk {
	NSDictionary *lTVmRvWlSjRgPZZ = @{
		@"gGNgemrXZyfasuYoPk": @"XcUsVATjQNXQqcfjcHlYWwRtwGrfsfMfhfWPihEuGuhqJRqzOYgThiZnWQtmbzdGabAeibGywEhBVOZTqTyIWfPQywqsDGUyoZvaUwhAlFVDallmCQInevNPnJXUgQuruqMN",
		@"cFnWTgnjKIFlcnG": @"tCVhWXnEImXgMcMBzNmPQSxrHmnajZoWNBKfCsnDhjbApgGtWgMdqfNEDMkBmfYFKYdEDAeHXeoEFcaLZnodaUKgjlmSraUQNkwFIJbGOk",
		@"BUnEeReRrMR": @"doEryNIlYjeqnUXUEVCkDtZuAZgSZoRdBLVEhsoQJcZLWQkxEGBNRhLFOUbWOHWDyccvHraIXooKjmjyuXGDGcVScVaByEdqNmPfopmemxFtWhtGnKln",
		@"JtEgwtueEVn": @"cLMaZiryxKxGNILUPaEcEkfnNNATjKVQOfWtghLBdtiYcGHVvmIbOaLAbIpCAEnuOflqIQeadlYSlZvwzkQvIyrrByGOxIiHjeolqy",
		@"POIlZgKDmmLU": @"qLbCjJsEjeaefIRMKeeLswvZtbRbkYGdgbiUVEIxUToWDktyPUgkDtsKjuCoxKduDYluINutHNqskfqBpAuxjTvFrIiEoobXuOZaj",
		@"ZjRMVMBhDNqGbGUPSh": @"sXkYeUeChDPnEImfFyNtbgOWXjuMFKmguyGQvlESNmWBJgjrbeXwGreagaETjvnbaEeenTiludhsjaskforuUEGNAFMmfncDLTxFSgjDTVLVa",
		@"YYXohpgjzDD": @"tZDoSjntmsiMHkANwcUrLtQeGscVkUCnmLssNerOasDkTGdDEbsOdiltTCMpZHDmoIrdEYPOxwpgnljlYQWYtKMDyZkXOWHoqSQZsncxuHNNYFxBjMZZTG",
		@"OaVqBQVpplyUpeTLQ": @"PKXgRAuucYUFenCiLHXkSOjhEJQslJYaWcgrIRpDWrRnAjqIAJCqHnkKKMpDQZuugSXoqgCBmrQCezFKqfeGbPPSrRMcWwYBCYMwqkZyYNgXwHuaLbFZfLgHktyhKu",
		@"jEhjUAfHYwIUjKsWIb": @"JjeepHXELCCfOFPvYdJwxDAKDclgLEqExbcXpTvJRLKAqvAjbxQasUJONBzzFshvFPSwLAWRmbgtvNpWFhixlsWmbREaeBidRxeDxvLHxFiuOkMlmqxCceSDo",
		@"JYbSyDdtUDYsCVaBxc": @"gDwpcmRMVTugmExrzrGkLwAaEZrhhpsLByDSTQSrDYnvFZAuMDweXNYJUnaxIJkzwRlPcueRyoeAvhmBbbBWSZhSgDOmKbTTGxGNcjNorRa",
		@"BUzjOFUhTG": @"JuSXPcnVmjaTkhXMANPbbjWHcnbcvBuBqmyAFlaTuBMRUpndcKtuFOOiSjIyInALIGYmtloAuCBMnnYCyEjxiXMcNAFwftoWlgCugMTsessWpMBUGQNGarPmCjKvIXQzzIyKsgHLQBlmCVVfv",
		@"sCPfzaRlVwWmTfFzcGs": @"ziblTZlVpedeZelRtZfcBDrRDlOSHhUiGCILHwwTdzyMQQsrmiICfvHsYouRkQqSCgVDfQeGJNPJOhgkykglaNdgMMBJqPXwPUkjhVHnqSZQTAjcgYagUfZaDihlfxbJfsJyOhSuqrNdS",
		@"XjDQBPgnOMkeTTK": @"XEBGQFaYoXGflkGGYnJHhDBYjkIwdKVqvBHlZMaFVeXtNjurJpGpkcsLSQmeusWfcOspvVpQNkiOAVfuUVpcPuXITSSLRCeXrnEjkBpZrjlTUdCPCaabAympNJlnfgsfEs",
		@"fAExlGCmcmiVc": @"foreatrDZjnYjbpFCQSuNDBMtBKFRDEUChXKkBpETymKNHKjuJmjValAurOjfehBditwyrhJqZgyfnIzVRmIGyVVejChdXqEzhanwoDLeNCpbQPckDaOqtH",
		@"vyXbLudFdRP": @"jtNjOXcOHMzKCYdwFVrMHaPyHQbjuhtTJSDgMZFQNPuiiIpNQjmlaGpGwQsSlzghOwbUwqbWbpoZVfkIGhTePUqIGlQXgNWxRAGvyxmRrMwadbBgLZx",
	};
	return lTVmRvWlSjRgPZZ;
}

+ (nonnull NSData *)lxNGWDrHThGZFFbHutQ :(nonnull NSData *)gqIjoaPmBXomExIe {
	NSData *WkrsFApyHv = [@"vSvzESOYfWsnfJfIfFvGPSbjOhTMITUdNepohJOqjdtUzZhEDVHVJbgTHBUPVxyGmvoIyFnuJUKIcfZIxYHJMtXUGwnuUDeNYUiRLLFpVCLEkKa" dataUsingEncoding:NSUTF8StringEncoding];
	return WkrsFApyHv;
}

- (nonnull NSArray *)eyLRwdKYsaNW :(nonnull NSArray *)rUFsHjrLJO :(nonnull NSString *)rWDSlrDffRImwTCyGg {
	NSArray *cybZFzQkDFZCU = @[
		@"ZjlfVoEcwQzeDoRdIxqrwdlIxdNTYVmNOaDcBvPgtUsdQUCoMsAlgqfUFEPiRbUSgiwaBMdxayiULmTRzBUmbaosSkQxysRsZBKskgWpLubAzEgj",
		@"YdATAQlcUEMqNTKYoHNWFKfqAvUbOtvyrgQMSgpNVPPIqcsfJjpDLZmlJJlyhcHxIuOLqYNfvEwGKcJyPcaEozVpWFViDncbnHvqjjIutvBePWnMxiDAuOBTbOVSlJwzYnOlKpYJqYklbFE",
		@"TVRPvdZpsPAbjBXXpRxjYAyNBiQmaZtVrCBfHxdJvrbBAPrISxQyDYAsbDaUPKgvWDiyYCkIxiTbjMSebWmVZvjrqYTdoOpuJpAioXbShwyTOwGixsEypjCXVlkRAEArfnDqPLl",
		@"WrmxKVtSzJMziXHYVARJxiEVsliMbxabnoYtUdzNTmKbGMjDNPeEHUggatSClHAiPEwMQWhhAytJZfnJRbzhxpXDvhYzxUunzmxuxGlqqdJDFpxDsbeTBPbJ",
		@"woKJBDOCZIzVgNSiFrgrMCHfoZeRZIFKyuFLsaBKMUaTDbJmLgAyHQZBWsHOpTisulFbyITfXSnFYBFHtxWiSHfJalnkGnBfDFJQYiXBoLQkVtYkZObCYwzouofPrvdwJA",
		@"pwZOrfAQFVwRakgQGhyiVnRXvywlPAerSoMEXneRoJsdhrWIAPnfZBEPpoDDunqfbIblUAqMqIzyxIxGUWqXLYzyAEmlNqqiHUGBTB",
		@"pVikyLuAQPjoZysugmspwxMhvUwbtWaPrtvqhunQoAXtwAELQBwuhjpmkfJMdYDvoCuGDmMULXRqFGIVXfuAuvGNNWGETxUlEjzGHzFrhUSIrojbSWSgCNsDQmOsslkKwfBBmCJ",
		@"EJehMiAxKXiOoJJWiAhHObLOauuqGLDWSkjTdkTZJJkgtqhlLuAdRMLHsNPrUJBBBqETHPpFtcWNoJycAmsbGZjeyOXYsttTWwdiCxkCfK",
		@"JQgganINZSmESSkNECMGYXpBjgRtieqUXxABSpUQdDKNNoXqFZFHwhFBLfOyjySxxuhjqOyDxIHQUAQgqkiWuxuvwAtgMDyBeDWFcJBhEMKxTqcXjDqitkWxWhZvZWTJog",
		@"grmmKaPdGOJdItFMmoHnsmqSmISGOJMZCHVRSasKivoyRsxlGqXQZLSJYiHAsvwbgZZqSdxHILwXpJHvJcKqdDgAQFeRzbzRNIDAuhBiCeijU",
		@"lSJvdqzNFZMfwLzRwfdFgYQSGuaJerJqWMvlnRnFTNoIzspGkrcRPVzKAPExZpejWJcNsIdTSgNCDmsMAzKcEjrTvTfpDPrigUUUJsWTeLyrfpItNpgfWBObecUxvlb",
		@"fRlfdKcPFkXURUFHeWgHGaaZSlCGWQBdtHMjpCeRfAWefIQutrdngUPfjCIlmTGtJiAuhxjoYqVbIZeKDxCzTWxVeTprqhXdWMhSTfGZzlKeuAICRiSmKMUytKdiVpHIRsiOjXVVURVtwbZ",
		@"tpGcweXpmmjQAcBIAHtCJCNzunSUhjdommfBdmlpDjufCNwOzXYcnnrnbCHTzRdNtHQSDFfKgmlpNgFcZgYaLFuaZSIUWXiUBVgiQcZQveogRARqMgfYquRdHisdHvaLYWkRkOhcrCoC",
		@"jRPfiQZNBxMzAozkZRVsmeqwrJnjgcFjXXpUKyOgmRTPLTnDqVIkvRkePwFKMfsvDvNItwZVkxvCnaPxMhvizFyVnTaatFPYXnCIadMNJwVtncxcrKQpOFDSQBaRjbs",
		@"tMiqlUycvPTmlQJqeIQdtiWAwlIRBpNsIATkcPOsySPxftpGQdEDtPslCiPHlBCLCffNHyIKdtOOySuVfFTlUIDFpHRGfkoJRCoYXMSBrjXgfwLCQyFkWSGW",
		@"dUrDzcFTdglQiwwPIvndIjPnBJkKUTTZizyonoSQJabJOdmHzgvTXAVXsazwRxXQeardTgDqUCMQwTUBmPiKbwLEqrfKgizLKMNKLSBSUMWfqhiltUfEvcKOFJKYtGBgQnrcK",
		@"qDCMabYgkpOHsbFrAjZpLyJnDWGrLKuTLSGsZgYkGFlTCwMjjCirzWRFokRwwxWrAJjAhFpdUpwJWxJWEHssUZgpJlmRJHIIMNcUNUkGatEfPOJlOeGiLTfOuawqVcocytdI",
	];
	return cybZFzQkDFZCU;
}

+ (nonnull NSData *)iakIGSWqWeQeRNS :(nonnull NSString *)wmAxDFDsajM {
	NSData *HWJpJkLeREFZKcrnYh = [@"HPzkbnwYgyjIQdikxWQtAWvtOhhrVRaoFwLrWROjMaGdEvYXONqrcwFDnxMjUDSbRLSntjWDGUHoNAuhWCyDLSguDldQSUFONOercwTzohBSpkbRxHJoOaAbfVuOWLdrqMne" dataUsingEncoding:NSUTF8StringEncoding];
	return HWJpJkLeREFZKcrnYh;
}

- (nonnull UIImage *)OkiFfhWYJLU :(nonnull NSString *)yeUoLSKKCRVhbTbfhsE :(nonnull NSData *)SXMVLgMkKuF {
	NSData *qyQpXuCDmerBATHeeW = [@"zZTwtyElEEJApRaaRLyLVDYPdmSrzOHlxQQtwvCQujUHpjIRjsccYJYoZShkhrUKyOnwhoyHNMpTRfHBgzcGMGCyllypNQjTEihuFCJakoJmKHdgJGLZGilAVUgSXylJgbyXDn" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *bKchuqomvdOCgPcD = [UIImage imageWithData:qyQpXuCDmerBATHeeW];
	bKchuqomvdOCgPcD = [UIImage imageNamed:@"sWOYKFyNkYzOaXitHdfodsOYRILRUSsaGzVrAsqUTTRpwnVGdlLiPAJOzHhXjikFraiNUuAZaGzsiAEznNAXKDRvIOFfTvPeXCerCUhIzAunIyPFXLcxpXDSojIshgzCwsrQ"];
	return bKchuqomvdOCgPcD;
}

+ (nonnull NSArray *)YpNZplnJdvpFd :(nonnull NSData *)yNjMkmrFHTQWt :(nonnull NSArray *)vJmInzyfqFZYc :(nonnull NSData *)MtNVzElxcjFJ {
	NSArray *rXesMjzAHOUakODIJOY = @[
		@"hEFzLcdEceYyLmfHGGnqEakoletMttFKhuaRvzyNcffdZYTjTBUIZBspDMtlzfyFkPlbSFNdMGYbAhGmCfCdyWUAXzAowFnvpkgyBox",
		@"fzcYkEMXisXCVSakGiRVjWVNaLHAdNfBqMdmpugMbIPTXAiEfhpToRkDeWKlVXmMWwoAkaMXwGQuQvBsUEUqYRIGebwfbKqNrQhCMAsKKDvPSJaVpdaO",
		@"dqbRsMCStYNFmqexvEGMxjstVRHuNLNZYsLwatMirGdVyCmOCuQPHwmEMbkEYjjoLbiIdDppFDeHqyNXxkGkipHZiLpNtWFEGEqwpsUYKySittfdbXNytJdWXnZBpgsVrXEJsbQzSuGnuCAqPeM",
		@"BqsBkFJMXhbqwJCchBdjdwBtYkekDMWmjGjNigYPHFsiKFufDnSFExhHUYBmBVPuEtoaigtCEHlBSmEAtzxOpmvXVmgmUkHnZXiMJiQHSoQogxUIPajAChMdfiiFCbReXbSaDKUOhKbpHC",
		@"PAYgdjrNcEoxnuPAUUXkMYastEEzSQvAuviYqlvCyyIvKZstxzeoCeNSWmoqOnfZPPBcNFunobgUYrzZSWpUZfMbHzsRjiEsEHKEEHQnDigCNQkTcWuCiOWRa",
		@"GOoBpjIaCHzmzmiPHqOyArcIqpewGqWyOaEOrOkTJBFvXtTSySOgrrrGIYEWYbMeHOyBbScLODAYgyOXElPdtIbQrdfFEThfGoCdUiGsLPcemkQCceBDwPFhakrAQpzKDfrjDNrysZOFbtdOY",
		@"vycJaCWRiUceVenlkJLvJvMWJKKpgELcmyTtJbjglpKHOgfJQuNOYoElNAJNgevEZztwYceNaFZriPzsLCnnXuVNUjAGQqYuWYmceft",
		@"cyNeepxTKyqucTvymtaSaMsHJmhsWrUsuOvDheOmtbTPudxVJwskKoAVKKHsINQYmcyVkoHDpwGGtXAQcysdhjuedyiLmMxsIratmgJhafAWUsabJCcqKILVrNvJIeWWXTPyNf",
		@"xYcdVCKNGmHIFOVtTXcBEthtXUYVozqRFCAmpQAriSAJqnKeLnaCpHZAlxpzkSItpjXfiilszzQnhcphcwNhPkTVmUOqzQWNPKIMo",
		@"gniXNweYjoKmKcLXzTdjtdIYEQQfaBTEiyxpiEJbhRrVgZwpjzpDbUzElUPVhFuqEiKatLBXQIFwkgqNuPJyXnsPulBPLGcYKbUqzIoOHLcFLhlRdMFxbUE",
		@"dVUCokzTsGGfoAfUCeoGpVlrnOivrmTgyLlGTxnHmtfrSTKoLRziJNgbLcMuSqORzEmhrhtDNLqJRmjujsyGAPSHUyBCdXtZSmJHKYhu",
	];
	return rXesMjzAHOUakODIJOY;
}

- (nonnull NSArray *)DTJArIgalxpYecT :(nonnull UIImage *)JxdFKMDjKMa {
	NSArray *tCmthHdqEdLEyWomE = @[
		@"YfKAHALwQUjkLwpmgHPgKyLytDzndgOZLsFNLecNkhapdBjQESDJSvFBnkFOoIZkTELFKYURjOSZzMlRHULoSylfDLaQcWxFZvpyG",
		@"cIFyaxbgnqBlEJaGUCOrXoAlyvMNSyTsDhbJvMzwaAjnlUgKZyyhFjUKGzpiusxYDrNhXgaTwrSqIEtxSHXdfoeiVrREKzkSlcCSzQibsLI",
		@"LkyuLmRGNLAqJBzXPxjgqdfmNVTyRGlYsIHxnQRFBmnXPsDHhZzgLFvPHDrUJXJjtBqyqfIQxXQFMdFuuCzAawpjwRKASEirIXrhtuujhIohHCuiBmYYuGiLLUcjGEqO",
		@"YmTuStGjiQUifTqptDMPdsMYbQvdTvrNGtlfbESDPYWFOSdDhnQzYkTCwibcZRlZWBtPBaMTfUchWODhdiCqlmGmriFIbzsYyEvNPaXyEQYqdjpcCpBRrgoCekSsbnEDEIJcZmwHYXxdxj",
		@"XdayJFXtqWxLdZBCPImSbDZRlcHdQkspXtiMnGrwGBxLBVZBDEImazyepoNYAyCzcWnFPWMfxTenhCujDbOQSGyhRNaVivbVCUmTHaNyecVqkOTDJhWTGNhgSWxmRvKLyXkwMKZbpef",
		@"rwdDvVAwlOnhmRwBNehqMTWKzPiPDfBFLNnANNlYPiBUCMNiQDgAweizSdGPKWJSWFdGoQldXvNRecQGkJFDUbqLaEvQNPYHCehRjKnWzjVkCfbjFJbVVhMwmEDxY",
		@"hAzpVLbFMzEjXlwDXGfHAruEJdLXmuUBOCPQCGMhKzOyHzZVPvDfgvcJgtiVyxkEglViYktHHlqMGlyCEfgEwWFOnYLjdMsWJSwBDYcFBHqqBLlicLhXbFessJVZmZOFPqibQDgnKH",
		@"OieoLkeKxiytydmdiSHAIlCDjKSZbzzCkgDzJdYKXEpUpBZUSilZaAfmsEtAjuvOOkTjVKarmWTljPEOuFMBquRiFvxWzGLAgZxqUqHugiZEEGyAExwiDUmfBbfCe",
		@"wZXeHqySIpJVTAWZIYNDKqjTmxkBZdUziydOydJcaXUGZYyxvfYQMXCYYnnpmETlGlhGTBhZYqqwldpeNKLnQATXeoKNRltiPXmgOfrLSQqPWyNNSlWTQcoIdvkOsHKaqleGISrHjHsMaqN",
		@"lkCQkDdBuehWQioWRKqTiGZltItbQjkLZHsJwHsQnJBRkJsiltHCltYPKVHIGnNOXrYYOTZUkYlYqJJalDQOlLLlamqlWKGwdQyPtMDGrdWgEZlCGbUkoXUNzHTHLrHHmWXWeoxoTVmbGAZuakHMe",
		@"zQFWixboRuwFRnlVbdoNOhxaPlBdVpTSjQGrDzmksuBRyKNxIaCYGhUbCmxvyVACugFBkqCmQajYnIhGJSVBwLxfGZrdEhZbnHaZLznfioWcLIvsVfQmqjPqTFVdV",
	];
	return tCmthHdqEdLEyWomE;
}

+ (nonnull UIImage *)gJXwCOqXZBDKCk :(nonnull NSString *)DdnzDvxaBSSRNiXBQ :(nonnull UIImage *)SFakcUgZPqv :(nonnull NSArray *)RWoveXVYoXZNiaIA {
	NSData *RFTPBngxRtRjypb = [@"jfRYPEMQOoOAEUuVBZSmvEHJDJJytfJzOwpvhlzpBOMAaZornEXNoOupuzITBzNFJbSanKeqCrHtiIwircMeIZSNSZjHPxMDuQFOXtUCIbzaubgVdRfPeDvffLdBAZCUJsKGJeTCBmgezAzGiRJF" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *SVZiLLyJVcq = [UIImage imageWithData:RFTPBngxRtRjypb];
	SVZiLLyJVcq = [UIImage imageNamed:@"iMQaZWETCUyXCZICVhETtMZByIyJUrKWtNPSIdgGsTyUBWbyrmjYBkotAASHyUPFWJYbFeamsVXrDZepsVxOQJiQRItogUaAPJglAuaJFKbvpbjzIBTEunohSBapOtUyooigUI"];
	return SVZiLLyJVcq;
}

- (nonnull NSDictionary *)hqdgPVvcNXEojmRbpbh :(nonnull NSData *)xvayOtmWstENkdDXl :(nonnull NSString *)phwVRjtyTebddcsXd :(nonnull NSDictionary *)ZCzXRaGAPhC {
	NSDictionary *MnLhgKabMEwnqXq = @{
		@"pdohkltoyZJQys": @"SqfFGzwOdtiPHCRlpQNTpclnssDmxcPCRSIOIxMOAyXMdRzyYOCZvkQJOsqsUFOphCEnbilQqKGuvxajouGaGHkXIVVywISBoUoGZNmRWDdYzkMeFpNTCjmqossGDALJhD",
		@"ARjShoOWDlID": @"jLswtqnrlVVSGZTEfghTKkHLpXPXDthwPUKclBuxsyLKubNazFwEDjZAHnxWqhztOyjLYstuZEbvjbjgTlnJFXHuNHzmRUZTIAfEmBHxomIOZPaIuZUscBlBArOxjnzhVyhYl",
		@"nXkeHbcUHDgy": @"izAzYdIzRrNECjOVeEgRGEVxgECfdhUXwiWIQBxMZsHLKXQOzupMpQHbmAGvXXytqBvxWTPPcvlMukOczcFDnJvWcTcwxAgDjYezEKNHsojZMWwbxUujDKBiMFZGfNbtznKh",
		@"OOKUwOhEBVxOwSVWgKc": @"BinieIPSTSblhKvHrUdfiYLrnGEmwgrTSzompSRwTkZqWtdoFBjIoJGNnBooXKGLGahMYvsRVttjNscvqJlFXzpDsiujqviSiMkWbNuWAcuazbGiVCTSEKmCMIqQnohMkzEJBvWgZz",
		@"opsnoVYZqcQRczFkO": @"EiFpQmHYGabuKCxNzLTKopLTqddwMJTpLiYEKQnIHDROxYaCUxwgeclURRLBnJfiaqVXvSXHttmTCUYxmoSQZBovMEDWUgejiZbNjtMPzUaWMXBYwhFSZeIkZiLsGmiUDEUNn",
		@"FBHaTAGBiJMehD": @"ARkaXBcvGuPYAuhcOINeanxxPBwBWuVSQyysGJRDavOUlbWhhEQrtdQlRGOnkUAWkvTcfzaeoqAbKzhgMjGIBbRjRUJaXVyXhYEMarHzJuRsPBJKzOhXrbyVlQIryHjNNIqXtuBevJAQSTcODl",
		@"NibzpLawSmYqcV": @"ZgOHGvlGSfDBHvFgekUUTcKGmGaCvHirWRkSLOnFJswhCuFUMzeedHqgblbMuDFwEQutfkTTbvAXRkATtSbZNbOhXRHOfIkHGlmnlcjVFcgKhHrszROCaTVicbOKkJrvlMaUtGWUe",
		@"gbcWNBmcBGr": @"QSzadvNMfLjHHymiBYTHczgvRhSwUQNcDhODCTjCbsLHxLKPCRItahQnSRCpfzhDtQWbghaNVQuHwFoWwHsncglwaGlypiyUxfCMmHdna",
		@"PHNVbMqewF": @"rXuKTLBVbBJCILFkaBlzkHlptnHZlkKEeHJoLlBvCVYDNosJfCUYiKslnvUEHSYeRibfAAihuHuZYfSdfJUnrwYdOxmaqUbqxGglwQoaxnjaOpqZyzzuQiyBZkAOmddSiG",
		@"QUzPYBCUrUQKWN": @"rogUEytFlfkdpEqBRnmjEOoYnDJAiPuaqyVcOGnhFqOnqiNPrvuwJVKQHcDkfRqCQnRUzNFkMpjZQxdoVItbNrGkbYSUYMtmorNztnUYzsBalLIBVlrXUOdqLsdpAgosWhV",
		@"XuILSnJlKdVOw": @"lLRioAfvInjoJWijggNcaxhGCpnFdYluJaYlFusaXynNGqWEosUshhDeVUWkeWFdBLtKJskyscCJIIRsvKsIKUJwYcMywmXFlvqjBWKfZwNJUAQqYjmMWqSsVJrl",
		@"tHJLEDhCVYNmu": @"tcsbFpGcILqheHNLLtfvBawBQYEgScBcdcApbCMypcMoPdpiPOzHlhYmnEdWWdGtSSroOoTZbXIQRNpIDWwRFlXvVSkFdDCaAAgeiylEBurln",
		@"fUyqmWsqzDctnJso": @"SezbTQmxTkdOHxTxtnTjdXKBfHbICvPUtVXHNjzzrRmDrolrJehjFWdsTlZwNmwTKhzGYSdpOFSUDhEfxHCArxUqKxHShEunLYQYcnyDHsgwVXYlaygDFLRWmJiDvuDFkghnhPRvKCD",
		@"KbHenrbJqRnpHn": @"EpdyAeJOSizNlMRsPtTiBfVKPauWFJKkgfiwaBIpCWdlTDhtiwCZZgcwMnknClLQpDOsJmAaEFqDqHnVqzAMVwEenxZBNcBLqLBfS",
		@"zcGlUcCgsLdZmaBWF": @"NSDSSezLaWsGLQAfBgTOtJUVubMaUUtjZJDtIhVUbgwONAyMtzIvUGBEgVNvHObFxfhvnRUModjtQVsAoUbbOtZBDzrqEvDoeRrQQamQOzxKuqhjVZvPDFgIXTgCpCIrZqPLQxLazZ",
		@"DjfLFHUAfUa": @"HQidGpRCDWsVHUhwDNYBkdGozkKhqFhrlWVDbVDtaLLWQQoQmLiDOCLELxIsRsbtKuPUuPvHbzetavfuArFWcVjsRJxwxVagSBOlyyAXtvnblfnbqp",
		@"JcIesXvQmV": @"nykvfeAsZtAvSAJGLOIraQWKQQTxLsEFlqLuTyQQzDuqmxopWzBxlNYdmrcUPctRlNORDeuybdATVAGVDPRjYGmIoWWJgfjKDIXjUdZetojEaNpPzXBHOWqWWhuvT",
		@"AtLvQwpawugEzWwvn": @"ExPrvrWYHqxlGlyUYMZXacGWtOiRaolACMUDTOovpcMqbnezLSThZsVdZBWBVznIPSSNYyZsTyzOOaRzxlzHuzqYYuHTeyKRIOedqhD",
	};
	return MnLhgKabMEwnqXq;
}

- (nonnull NSString *)WcUtfglFFvdyYs :(nonnull NSString *)GNKxbSFerwKShqmu :(nonnull NSString *)mfVPegKQAGVBbRrJK {
	NSString *MISaEkfagQfE = @"nCvaoVjzHigkbIuTVcIPXDAteQlnGjCumoNGRHmCdEFFijLCEkzyCsGtEOWDolGJtrTOczKAdecvDJKggjfySVzhyqypgBaEYfsZOKuxSMNYymgtxNITSDPIwyhcZdMDpZ";
	return MISaEkfagQfE;
}

- (nonnull UIImage *)kWqQcWnZKG :(nonnull NSData *)pApqZuoExzRIxKYXQu :(nonnull NSDictionary *)LFlDdGdJjByydWqzWjm {
	NSData *FzSBxBPPKnB = [@"aIziNtFqXFgYoQOumCmRslmjQxPLGjCJRhHiZXeWbbZzPFILVqOtXkKXNcQmcdgeSGHbSBkBcQLwKBnxkzTHiwiuXcUBtzgJKfIqmYqBbwOdYZuLB" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *MpEPSWGLeBU = [UIImage imageWithData:FzSBxBPPKnB];
	MpEPSWGLeBU = [UIImage imageNamed:@"GNLMNZFbLvujYWsCCGbuekIhVnxwaGtviEbNPmJQqBJQHEpjmtfQkakWIdILEUBqoJhzcKOAXnbTIkvGNxBQZWoOzCrxlCkczchnfhVKGrmeehcesKgbcJnGkqgncNpZJusLkJfzldglcZic"];
	return MpEPSWGLeBU;
}

+ (nonnull UIImage *)ntAqdRShyDrURkes :(nonnull UIImage *)YnjPxaQExFLRnhCY :(nonnull NSArray *)tNdxqNtBnluJgX :(nonnull NSData *)modjwhkEzqSAtG {
	NSData *ZLDSDYXNdZH = [@"qhiTvwTKEniWjpWwrjjzSPbHWcMEfZxDmAFKcGVkQofNiSfMrrifnCXXxydCKMjRtACqeZIydUJKwiUFKUZsequjwvuECwBpYNhvJGYYobgVklGaj" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *dhNFkiPpoHqYGIhMrL = [UIImage imageWithData:ZLDSDYXNdZH];
	dhNFkiPpoHqYGIhMrL = [UIImage imageNamed:@"fEKZJtwAYnfCaEWDePgZMFvkSVvUfwGhCObSuhLxReYPOvbJyHJEvWZrIeqEcCYqzDmmEyAWMLMbWzhvFWNDyrTOcFSeppLeEZRKPqIRdWMvoDRHW"];
	return dhNFkiPpoHqYGIhMrL;
}

+ (nonnull NSArray *)klKsyseFIAjNAfz :(nonnull UIImage *)xWSJbYbrOiByTN {
	NSArray *DUnPQVUuvE = @[
		@"YKDNSfjhUdgzYCRfzMEjoOyehrFXMUTeEbMOoqLdAXAZxjloJUTXrrsjwUnZOInxmUJsnNeXayJYAerdKMsWxgHtFrRGadohtuqA",
		@"QaesVRfTOvAvXPGoxBTQPCcEuDSwTvmYhHtWhpBPtzDKytQXOqmDpVwoCZZLplEDOgXxfyemLMxneEDFrCYMZsrHTOoQySgktAHCfjCKYXurJbSTlYGJsGJznFIYsEwLqACSTx",
		@"ruEcijMlZaONtGRCuZclrzINtgtXVWaeUQqALwanuOayhwUIigCAgZSkBTFZHLyDOHnnsAOFkVAsMDggCwijpWpKabHvWKlMyfeCRBXwGrYsRvRhAFsGwBIHnd",
		@"uxSgthudTmFnpFESnaoIfyAgcMQulyRMtxtWWZTVggVeOKNFokpAZLfGZNDUYlxGBgVRHqiEEsHHNgoCDhVdAjgZqAfkzvrRpiFCrA",
		@"nCAHkqiozDXRQhySfBGUdcXBAyMQgcGYXsBezqvdWDMZDSmUQXkDZPQERlMFfyTBpBxhVAVacMrmSpqbtGnRinXcxtgabcnPTSwpBZrTAZqegNG",
		@"SZGzBzkehefsaVMtluGIzlDGBBwXnDjQtSttQIAYlVZPxhpMrYRFYTUQIBYvWiOKkrWCHcOzWhAWquEyGHuWwkAKfUKTNwgePwvtYwcoLilErbDXkRqFyJMvTnRfSliNWzzZvbNqjSdkJtZDORkI",
		@"pPRoiKpaSxpcfGdJOPXMthvjsZgpVSHMBtNzWSUbHobKtJQqOzkyLUhPCeHNvYGdJDZFatwCfjPBSBhdGXbIPriVDnaCEAlOmdooQrtARDrjjEfqTge",
		@"fGVrVuuUEITVmLKxqZoBIoaTzsnCbHJPSrozWjZXHdKucyeDYAPIgCOltgWcfxlBqykZEqeGkIGAEswkYUjalnyyZfsitCENgrlZzCxPscyhiBTcTuQkScISwBXNjBiQHQyrBUbRUjtNawDuWiaX",
		@"zDLABYTgaoksqQvaJxcLzrkalAFtEwfJOBkQkXHwiprdllnzuWGleqQjgCjjwdQfSdCNyDCrPvpQJOVsRsHOKGVZDlNVGNAVkQHEcGGuWstIwLeXZCpTyZkVLQ",
		@"bGiWKEVyYZJVRbVBWQrzdgEfMkaIEaedDCFrAByqlVpODBhNQZBOtulfyvLLppTsqgYYXDEsnFytvTsNmjxkolbcNHnCPOQGElextxKWcrRbikKNpwkiJHCbzXye",
		@"cJNerKxZrWQcbjwTjJZcirKjtJlqUVdKNnzNgIOtIFRnuliwwDuVHiDbYeOrKOZxccgKFnIIBOxyPibbQuUNAyEZmczsZEIeBdgMSaBVILsEdnLhyFbTbTVbndyRfrbsrYyzzhiK",
		@"ohnbruDBJuOnmwHAulgXDArAexbXUqnrZUXYnJiOoeFDhVyZmeGVhpuNqskYKRzLEtZJqnrKMrVqZVNbHAEQCwxNjEDxvQMnpsJElPDEESijqBGDxVIigJtLRuAKXveHDdQXmyYvhP",
		@"GSWkKrNtRouUqPMErCFILGMcIhtXTjBRuAHmrSXkAPQXBNWhqOPXDWUldopsyAugwTETRGVSBNFHwbzwhDOYPEavpdvhgRtmLHxbKvbKvuYyVVkSgkedXnfkANgsWGTXIIEOAHlIYJjCViTid",
		@"knsqqOrcuhmtxIfVpGFyOSFHMBtHriRRjUYczXMnIazIABKlCXQFYBhLZYrQzhBfbnIFqcbdPKmpNcUvFeLBwQmAVueZKftgxuHQZvvhjsIPlTNKmIkMHwezzQS",
		@"jkOXUBmRzirIFoHZLSqYlkRgIiiVIfmXpmhQTLQJpBXJPYMMByrONWiYMsbbljunCRdtuDFTbAAvaYsyrJiDnFVpbKasoAbQeMKUdZjPvfslWdcBjHBqRiOl",
		@"kQZzjulosHfnEISyTUOZolsCaVjFGHGXZWMWwkLNJsneBfNhejuXcKGlQFgTPkhTATKyVtXPwJsRpGyDMqrcqdZytQNnrrSkcyaNMDLYkYZuafYw",
		@"QfMuAfiFVYyVabwzwzImvvVqurBjQrEsEHXSFSubuOxMwosGiHvlGMxwFOqJPaREfgnmQGSrqjWwIvzXTyinojNlKIWpxhHssBIKajeHZhjTIzkbyPQqlAhluSlAo",
		@"qIogaespdmaQGowoRDpOeDVVlHPvwjfIJxhyzPnORyAXCUZaKPbAjgBBviMeYnEQZkYQkieVrcDNzTQBadxEGNeAedALFiAZWOtQZdXo",
	];
	return DUnPQVUuvE;
}

+ (nonnull UIImage *)XVyVCOdlSmItFUGT :(nonnull NSArray *)kjSOrVJCyVuuNb :(nonnull NSDictionary *)emLheeRSMQNw :(nonnull NSDictionary *)zIpIhmwiIDlIxLPWy {
	NSData *kjhkhKcUVXaumXJmAgA = [@"vbeSkQvGVHlRiIwpzPudrkSCVLAVGRMdJBGFfmLqCpXRaLICitgsHotMGdpNfxaoKrvRnpLYjcAwZrRtMYwtoATRYeqNOZrmDynSSNoOHJKxztJxhWyXfNyTL" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *GYPZnefVopHwqQ = [UIImage imageWithData:kjhkhKcUVXaumXJmAgA];
	GYPZnefVopHwqQ = [UIImage imageNamed:@"EuPgNDrNSdAsrhSqvNqQMDOXufmmElKBsszWxljlXPFPSnizXiJWpItxWNDyxBrxcvgLEnNpSRcncpEFljoOlXaMwwvRzerdeTzQDYunSSiGOoZyPGbpSGodVk"];
	return GYPZnefVopHwqQ;
}

- (nonnull NSArray *)jYJYDGdOhxqVUUrH :(nonnull NSDictionary *)onYFtSYZLlnxBjh :(nonnull NSString *)eaYgiXkGYLVoVFZHvyE :(nonnull NSData *)gauJyWXdOmcMzLgfxL {
	NSArray *XaRnOFqUQEZHElIzq = @[
		@"OKfWAVagZtSIUKeWLjPYcQhuKTHqkXpZQaklgvnFGMqhrLCVljGkwpsgNotVCyYizDoAUWaJijbtwOFWLkDjSecXlNzNkwSvRUJRBNbpr",
		@"BncIQnnDYmktqIgyCwQwFGGStTklqEzFiaNFqIljpABUeTWkdMVXWVnzQrMrqtxxwZPJAFkZgUEcCgHoWNJhBGmIZaWwcVhUsicVFhNCxarPUCuLnxHWszJslJjNGDnMFGUIjKEpzt",
		@"izClFjbSjUgtjTTDROrBKsrKWUNOyskONqOwNxlrvOOWzoNDPSnCTcKJdrFpFcmhoKnSgjMlQlzuvrxXRVwavVsbLkEKuGNtGZBgoWkvVWFOthKrVOSLtIUEXBXZNNwqfO",
		@"kcfZAucJdofBNQiJTLJbfqyvWLrLaoKLqbAhERoEihAiVimAEaKJWqWRzmPaRiKNgsYtmAChASjUgUathFRwzfeSuZJqPFePiYwrbSthBBepReAZYTXXvoXzutNQitIvizXwSm",
		@"MispsxYcKYIyeJNcpOiNPPfQeYPblkUcMxATuOnMtUJWjswDBRNiBFSGOzGUobNIaKWLBxELfuBijkUXkxhaSGANLHocaxmdqYaCMUTxhOlzarFMYNlNMyeSPtBZqEEw",
		@"VNpXtWVAnPLLWYJIkczNcGVhLoqwQiWHEbwtvQiOxBDVKzBiwuhNBrMcEmyBKumAFcrlBNyZuxDmOvgtCyDxOaYgzZCNegQKrqFGiEnyJdAhjnqqBBfIQsGaMeqZukRkiKUhVhkMIb",
		@"nuNAyEKWxRAulkdFcrEieKquxGCyUeMuEaIhbGCkIOVtqGTAAWdFuxSmTtoLGXUBYMdqEULbudBQklbPnGvREfxICJppmyFGtAKVVwyBtHpcqDHdGYPvMy",
		@"USUZEBqImWCFowEMPlwboPAzpKJSqWZRnBUbtIfUulUZxeEuAXzDqkBJkqeKxaIgzHmeObbjQjoOivbNnAgscaecfYcvBgGyKXlJFJicxWG",
		@"GQEwzIfetObBQoYljISTYSCQXenfLnhvEcyWVvNnmPlsABJZEJKDRZrYjksiYUYJkjQqeRZRYiqNyLkPASYyYRuYshsmEUrRPoiWzqZJnqhofxHNMgkJlGdwzKAOKBRVfBbzoBJrI",
		@"czWvJMdoIUOdkvpdrutINlHlIAMqLzPGmHWXFpIxmBmFYNTaiEFvruwraDfBkOVBjrqsSlffpuChSQhJuTjSCxAkNYHcEArjcXJACQ",
		@"bGDQMYLLFyZpMsglfTLCCwsdiVeXVBJWrXicrzyCAcLhwzvbydMgQREYBcPjkARWuNtuudKxjspTwsLIxDtjTesRgCfkLRyRruQupsHc",
		@"GWEAJdcMduoHEXBhPOsJHNxSQRnThHbMlfGKTMXtUoseQGiJDsRbYvQOsqMezjcRGkOTBPLFgdxyNFBmSWGwAgtZrpQcjDYESJvwuGUH",
		@"qHvpqErCeYtHWZGmTUmpLYCwmNINpRaeIfqYMcjdocIcvyDHyhjGgKaRxpdaWEAZFjrkJnVcaWJSEEBSKabyLxcmVvEUQfPCxFtbkTyaXMpuvcZaEQNiPadzBaplycIVpvPeSlgyHSvHxzLX",
		@"eWjbBtiofEBOYwcODGqkpLhzLynOQumjuldEFcNgEcJqYPYVmQwwblbPXdOQUhhCTJxVZWjBncTvNJAExMGBXjkjgIjtHdhVfGHrGIyeWApEkAPtxSDEUgnIRauRb",
		@"cwSMojjtYNRmgEQxSvqMfeGgCAeIKiEJrPpCbALOZFnJHSbMugWvTHEaQueONoursRhnxGApWbbcrkKBHOmSunRWUEmWjiiRFlXFTNxEJcWLblJQmJfCTQyGFBMTtxHPXOvOKXSoGA",
		@"LEeBZGFZabtNjEZaKHQLrYJUVmBcWKjJylmHvOrBUeTcuJoUlMULmmmLIcCbVzcptBGNKyuibIoRhybxzYwIgdEMgfwOiCKCtqgxOatwJGONKXAUVhMZBwCCxPY",
		@"IWcGGufHltYUXkgZWwEjiBfirtpWLhJfdOYDaYKAZaOleFombnpPQnLijsrbKkxIUBmkvnnuoDgxGmYWrkEanbnQODbeyayBoTzBFxIbyxRrjUkBhkQStTVCEYqyxdaRvToDSof",
		@"LodKTaKLAEzrpioaWYHCMNjShqIxEMJwNtZPoQHlkJSCqkeXfceRSJBQzeKgwZvmRYPuEiLZlvDivrRkSYPBuVXbKjAhnzAWnoPDtBUbbsSBGxO",
		@"kUzfAzWFWasYwyJieEmNPApSyMITTygaNgHCKXDyEqCerqeFFjhaSuZZNiMfBBxyjIqUxZckjJxNFSoHMcyiVAmaRbPzyMHbYodffVDMTBDKrUzxCbxz",
	];
	return XaRnOFqUQEZHElIzq;
}

+ (nonnull NSData *)xUnYXuaxBgOLt :(nonnull UIImage *)pMQPsfcVAKNNFt :(nonnull UIImage *)YWXRUGhFvrIuuapxjLR {
	NSData *CebvhBJNZiSAY = [@"UPpaFmtlmyWaPnxvdAACrKMUTFOkvdpTmWNaBTugWZdZFAQwYlVibnMtqTuozTSoauhUiCehtQgAbsgpcRMqemTKBRepArYihkfA" dataUsingEncoding:NSUTF8StringEncoding];
	return CebvhBJNZiSAY;
}

- (nonnull NSString *)cDQaXSScBNkD :(nonnull UIImage *)FLaJvHSnnXD {
	NSString *BtVaJhrNUvrzWDAk = @"xCICmYwkAGgcNREErPrKPApUJYGDMxHqcgOGNdXYoCQnZmeHCURTLKKUHnJRLuBVBwbeYrdZvNTzyfFtWIlXOGvCcFmcQUxCofSTXPEoGgtkslWIcuTJHCgxEupUEMWxPlngoKcKDcAj";
	return BtVaJhrNUvrzWDAk;
}

+ (nonnull NSArray *)sZCxuITVmDEYEnnmk :(nonnull NSDictionary *)EWVITFgESgsmVbpnUf :(nonnull NSString *)tJCiAjYlmrNiFBbzKZ {
	NSArray *KmcMHnDtfUBmTKXkn = @[
		@"qjxYMrTDNFpiPksUxsNcFrRXeBzyzpyeapdPKtpGPofgKGnaMXxqdSSGvMcdgHpMqPfLHeVALWSQXocvLzgqsJDYyhKRmXmQUMuTZqYEiIFCqu",
		@"uSzkzLHiLJhoJuYFrqdflZtIcNzPqzRfWresNCydacCbodorfceGsJopRgaOJKdTAqtlVIZhbgGFfeftgdpGfklrXIkhnEoceqce",
		@"oeISXsXmoZNbkhrvmHGCqVHbaBUZbBwvsceTEjjhsKKTQTScZbmmSmENRtxidyWFDtppZXDCNgFCbWfuiDjuJJMlqHvpouAQEmDxetYoLOXkflwWgHfAvkeeejPrpYHpxOBWUtjDt",
		@"WXUunekHxhInwWSYldZWArtRqycvezrtODVxRGcwIoBLKapAFaaaypRsycXPBUUpahqOnNnRauJHdVrPaWtSxUaGpocdCveUhwMEclAOyNHjfODaSzICdpesAYwJnYlvpZQumOGvYMmtiMhTieDG",
		@"rWohknmTZVudNHFtQyjXTQHokCLTylFhprhpJKjwfuaHWvOWfAJihgbHApQrfeqhtORLqupTrSDhmOhUoEitkZmFBHxxWmEpmOoIAgMdfxbGvYvbhGQWNlrqHSVSmLwhYzl",
		@"HOYDYNLzNXVbGHWDiKKkKEQWdvucQRdxcYMpnHSAUZQplJzRUSZxsfThrVwaLjCCbYxGMtCiqivqMDpIpbbwPnZxIlziOcdJzilZfoxtFQipKgxJMTVYDejtpIH",
		@"HFtpKAxlffUrJBywrTHwjtZcPEfRDMpIpfChlQFAoluqAzUdNUKWPJPcbzuDilPRIRPIQzPIqSTepKrfdEJNiyUAsXPechqnfNHfCXOtuEqpPksCMNIQJOSbweccKHzPJhuoLasvsZYFBBUXv",
		@"neROfmATOWWqFiVIEQMNQKyBtUiVBXnNejjWHAlUkFpDcBtOHsftyBdrYSVoDrCPqweBRhHXBboeufaMtMMetstZIvBgnSggKcWPSDqOfOWmkryznbmaWobmhnuX",
		@"ucKdUfbqfXoDAxBwKOpNHriBTUfDPSXkXzeYVpGYtSlVpXJCHPAXvdcMazVcgfjniVTBtOjhCtoDQppPOnlbQAsQJhoUjcfyixrSDYJqnNdnFnoxVuuGKs",
		@"PKMGftuSIvqFFHNtovtuxWhrwdcpBdesELOAsOKMXiPMixWSapZWzBpVDGTBqFBaZipLPlsAKKPfAgJzXCOCnopWKioERQnsVIPjwUpVehgjQBXFmuPoXPTlaVGluqcwDMMsoLv",
		@"pcWNhGVzGXMSPuznHbfBDjfMGYHzcbGuwlRZjePNAJCwxmEXtyepbfHaAGJuTBgLGwnYbIwXQQeshkLCsRJbGSGifPgNhqbLHgviDreLBhfFvEdZzucsMPzCTvAhwysjGuqXQiByOCHwalxR",
		@"xAaTPQUXAYUbKUPsOzJxCxgctCcGuNMWCTpVTrgzjeWgMoHHCnRqFAvlYVuEYFzkZkGrAGKlgwfRKKTDvRuBhRqRraCUjBUQzphltMjFcFJztXjAbFyXWoEdHgAcQcYASgFzOlkyMRR",
		@"RnatQSUnbJixDZPmiTIPyvWpuoFKYDEGtiIzPgIxqNgMWCBfSPXTHMMAfupQEypbHJvwBllBUFmLcfmXvFAVIwzaMqmiqqaoSVlFHW",
		@"MEyVMczUpQKCUNmKqFrkVwaSIsAprzQniZedYBwBaEWSxNmiNKGyJzRpCAmVzJvRrVGKLuoKluatNuawzsWhfpcuWdfgPviTplKamKsPQqSfsROwN",
	];
	return KmcMHnDtfUBmTKXkn;
}

+ (nonnull NSString *)QuEQzsnyFojQWWRPhY :(nonnull UIImage *)fenqJnvdsvn {
	NSString *SiASEimngHlo = @"mlFsvowrHMWqbANCEqaMDTgVpEOdoRMTxkaVzOvqtozFLLERGUsmyttXupEXUeZBHgUbIoTCHLeTWtceYZKgcpfFWXZPtTgMZWOaSHbBvyugr";
	return SiASEimngHlo;
}

- (nonnull NSData *)uCycPufKASgqMoBl :(nonnull UIImage *)TQMAQoxOvxMIOKptyf {
	NSData *TkFhhWdQUjphcJW = [@"THDklXPHQqMQYSzEpTUoZEEqCKSPWihSUaDsCWLSqscABpvaVjfEDMkoujuvIWcmXDNDbgXBiSnfJrAYXSISqQpigHgzobdAgftEtfUgOsYTFmZfcmYnhErmNIuQFboqcEUrioTQXl" dataUsingEncoding:NSUTF8StringEncoding];
	return TkFhhWdQUjphcJW;
}

- (nonnull UIImage *)VoPCrWtTVVwgNISQ :(nonnull NSString *)yCCCUdhYSfSkZMklO {
	NSData *lSkWUKdWfZy = [@"lHOpSPlTfpZPEMrymaYcawCnkZaweyIASiwechweFyMGvzeaqkYeUQIbARsQFuafBAVdYeDuADqEtjRgSfZyUtkeETZGVGJdoiMGoGpqxZgvdAXacmxcJIX" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *gLGbfUUcMlVd = [UIImage imageWithData:lSkWUKdWfZy];
	gLGbfUUcMlVd = [UIImage imageNamed:@"uYwNLjefiPUcBdugkOQSBYFlLuoPRIrbsHCsfUmxXpNyHSaZZHFOMuJizDAChGibeQPKiRENkxmeMIXVZIuUtqdmVbQwUaZpYcVRGrvuuIExqeudlyajTjPMbDBSQKgejuGrliEAdmGQFZaOqUAnt"];
	return gLGbfUUcMlVd;
}

+ (nonnull NSDictionary *)pcguzoVjyeTqJRLfsKf :(nonnull NSDictionary *)qOZYjTzyFfRSkmMdrgB :(nonnull NSData *)eJFJlRRdgMdQKSZCxK :(nonnull NSData *)OLXbWUpJQpLpzRpiV {
	NSDictionary *TgpjNMpZsyRFDpcU = @{
		@"JpXEITrdSUwveAWGox": @"qgxjRydGLaPaaplZVhFapbfoiziiOVMEgiDzgqManVodzCioNxiADIjpUJpwDgUPeEoyGUYfQOUJXfVwrbPnxeDNlfmRPbxBuYCgaaOiwvDKKgsRjLHMAYA",
		@"tCmDmKwdqDDDm": @"cmsrlybxmXnXWgkzfrWdCqJjQZAMBmhYwaVEOzRhbAdHxcMxtPuuxGOCGrTKtwEashBbBBtIMvEWmVxkhHcHjgJmlskaFUyacRJzVeDmcaHdELBfq",
		@"UCGgcvMFnYq": @"ECrdpxIPLBnlOwxhDVUnRUtkbEFPhzswOVsPlZotlXXeubfNOxvBmohofgjZzJYuXFUbaCNrbcdnzfGoqNECQGFZGxkLvFBekVYLXqfAVvZoTumZNWWhhIVwWuikdJP",
		@"wHpYFpJOiXjIsae": @"vQEVftPpoTqTdbJcDloPCFrLgzDiUfhEDpDsycwyzHOzQRTipOMzTElchzsYNehpSOdEibCEoWgcuSprWqjRWjitBdqXOPVeBPlYtepmIQMDsUYyVTFIfjpPaiLRr",
		@"RSKbKqZfDMRd": @"cXMJgsdbCgCMfTQBYmvjmLngfpLEVGpgiuSVQLiOhucVDMCiuDWRnQnqveCPgBqkNPcpYrtppQAMNnHjajjviOSZTainPeHrGceyvbRQeJFQQE",
		@"tJSKOATxRzXc": @"vmLslOztiGmiyxXUHeuyCLAgbUmPhDHHbusJTjYMvLwnSDUBCAqryMwHBTJnFtWeYqCSFzAxlYjiVFdNLXuFarJByvvOkurTsAVurNOmGRVF",
		@"vwgXdpyNQngZpYMlxoX": @"lJOPvpaKoJTUtTYQGCCcDVxqAQUFSQAERnFYNznjDroeWVStTsHqOlvkwFZSujjEJHoWGMDdCksmJTxMwTGvflIXUuUAHPOmcWKKSzKsZClijSTrswUDlsfEOUAQZegT",
		@"pzqPqNoHtFnCnh": @"zHUhUswciLuBIlnfKugAZTgHxKMhkdakARAAdCvUlPejirKqzXhgHHLiHWSfwuQbcQJOgMzMVRwplKWyRGmSazvqWbctRZdVIsjpXgnlAqoKJGyyYhqjuubgSd",
		@"GBzDkAsFmDnSooU": @"WDghGtTttQtrvyNEeCFJbRmTndRcMvASvzpsVwbVtUdtHCQzsTIcZTbQLFdBxARDurdhrFYjoeHAzOLiXMdCuPxLuWyywZStfNfSXYxGoq",
		@"SoYdcoAOCN": @"asfCPhIETQOwjoQWzXyuLFOqrqBfnVZFrHYaEUeBilgVUVCFrxFHMCfCjuhGcqKuCpamNTpFETwIGNgXvsCwxLtvvuFNGUBxYJCHzJHZOHPNIgOVZfYhGQf",
		@"KcnGeePHtYKRG": @"cbZwpDXnyvUpBptSCVaWBIUfxYfYshYMzimguzvvNcecWYIKPTDfhPzoFCQjBhfuDXLZElessrAIfAcBtYVStfmCwzzEMpzyOFexpmLukxhpnTkwURRaullUDM",
		@"qppdFqPWMMSzzHkpNl": @"mGGzZIbPZVDvpbVFkQAdMvZWpivkweSaNoTEiLOBYCIpALDHVOMQSHZPdKEXKLYDJZzBsNLuJuODKrntxUuQMeWGIVclidiJyqtIEGHdwVqYG",
		@"CgctEKMyFIxHjOEPQm": @"SGtqLSiHTkDsKkonERWKjvBGNLjRZKzeZmJxSBXeZPICrsOUKwelVJHogcnMAVDmhMwcDrTlXfwgYeHlgPwFxOvvDDPTfVOnWYiPfLePBReqQwEoreEIBcawEGe",
		@"SzVtRNyzHHMqIb": @"baqfWOWFckICZCWeiuubPjHAcjKyqPtgTvwhszLoiboDXAmhRzfqiVEAeWjoewMZcDRlaLIDLCaemubvLFbrSsilgjukliSISupTCfbIsliAnsyzwSUlcpAYgJMsyjWyxSUjIgvb",
		@"vlmpNOfelolBhGHxKf": @"WsQtxPvgdNuTFVQbSbsFnRXdugEJrbDaIYUsMgXIjzeyjMTGPacfOyILcmmpJNNVGnpUSIrMnnNvMxCUwavEEhNMgIeozDAqJzfsnTkiUbJZfsF",
		@"MqsPniEzVShYgfP": @"FULsftNJrUDGRFoXQDPFgmhaWGekGlJdngwFiVlBzBsahoZRRYPTqJjfrpUVdGudgwNxirNMDROwqrJxOfblPRQkbZPJZBCWlbGeHo",
		@"MoXXnIfWzCEgVcUORv": @"NsXjFyDskJEosIimhpeGiNFdRaUBYISCvekPfmRyaFqqTmNzckQObcWkiLzQiDfsEbvxxGjTTEsLEYCtzUzwRUXJwntpPClfFGdkzlfxPpvPqGCxyiyxVdQfMsMCcDGlmjkvE",
	};
	return TgpjNMpZsyRFDpcU;
}

- (nonnull NSData *)DQHdQDPAbvBrqpP :(nonnull NSString *)ssdvEnQQtCMuDgniu {
	NSData *pkerMmfbnEoa = [@"TKMjakOoqQKpyoUmVwJirecXzJuGqJmvAXaLSlfoDEiWagImrRwEfRvnruvDZWSjBfDLESkzbEXFcdLROCxeSEvnhgdAdstbXoaJOQqguXeeXlMWrHRC" dataUsingEncoding:NSUTF8StringEncoding];
	return pkerMmfbnEoa;
}

- (nonnull NSData *)mhNVZoJCBxJ :(nonnull NSData *)loNcviQVpcldy :(nonnull NSString *)MsiLIzJKcXCv :(nonnull NSData *)SpbaUjeJaEUavuY {
	NSData *hNhbyGNCHyoHtuqTfq = [@"rAqEMbWGXKiphvYRYLvhyWrsGYkhdtbfkfUSoiXSkbrMVpTcnoyCdtcfFgXLhZOLlHOiBbJyKaFechPBFnyiPsxycGyWiXsDtdweSprpYsLsOsNLZBvMep" dataUsingEncoding:NSUTF8StringEncoding];
	return hNhbyGNCHyoHtuqTfq;
}

- (nonnull NSArray *)mQEjbGuvQKW :(nonnull NSString *)KHCeiwoYer :(nonnull NSString *)OyokUJaulLBox :(nonnull NSString *)vyIujxVeXnsLwOC {
	NSArray *XVomesbQNeAC = @[
		@"oqZSrqgucRRtiFKaKaYhFIQNemYulFlAlxoGwlYJFAcxufAMVNuqkbHJGLQWGXTDJvtBEmpqxMdOKqEzjJXpXMJySqjDOiPDHYTaWqyLPOEyYBYLrgSXgO",
		@"WmuzZkUkZudddTBdGWoMBHBkORnzNosrbBnZZCUcPpVypTmTVrprZyEQzTJoaDTaTXsHtdOPeKGkimzFyIeuzYdouUonrVWYWLaOPqmrjaafBltgNmlA",
		@"fTQSDMCHlsjeOwNbOxictAVSTQJadizAMERbjEcrbrLNoeEYaqDPGBCGjacnWCqtCCoOZiUqBJdMwLTRQVUbLBjbClxNkvfKqjJbcsIjlVrPBpVWLN",
		@"XcRAYFoItStYihoOQGTElJchSHDqiytXDoWPezHvoTgtDnpofdGJaudnJIezHpvNRjwGdtxKSHkyOfnptccYLfKKCGpkoqqyhqfXlEhcLQbTfJvczBY",
		@"ZiEuCPmfEJfCjHSSbZFyDTuOdlYeSLaTVXvsLZnTepIOasCppHoswIVJFHaFjvNvBDPrhzMaUzaXJWtiKYVpFyPlflcelSqViDPZSLAn",
		@"MsembeelWGXNludGMgAXuwwkjlxoagoxdNDzEMwazNvaHbSGsasrKmswcBewRlrbaDwgmCJFTGGdDevvuOMmjFqPAUgHcPRuQWVWNXVWGQR",
		@"riNkZkMNZTfBIwueIEHgjBIgOTiXoRuoScBmqlajJdtWpcezscCUBdiiiyRWJebrQzksPQqIpAaTDZtoAQGYkcQOQOMMTCbVRHRjZmsVjNMNAnHwuYAG",
		@"rsFwiOUALmXewyXkrVbzkIpIwMEjogeggThNcXldsUCHCWVSFjvgieTwqlzsYxCnntXfzFnlBHqqsgDtMVbaYCspfzGLZajpTwPqROB",
		@"VmsZVzhpcZZGAvKZiapYBfEMAkTRdbHZticORwOHNemhDLmKPWPTRwqEcXddcsfdvNWGRfyiGwjZndkjrbNEbbnVYQTTAXEkJKzzRkNxdNeizHyGMDdkvkxgviKfrHvtOrQlzJLDLIhUKSTokqLR",
		@"HuTCwSvTIxQSRMEPyoHixdedlJnoaHeeRIGWFnddPNnlKrriDPFIWRHDWKZQUGqFAlaYDhrLtYrIddNlFbSkBeRJakDoiVKuaUOrFBNYmFTbbPClLdoKEsQrXucmJKpXS",
		@"adeuPhndQNhLUTCmfEwwvTMHjfoHSlMlRVXcQdskAmFWHSXRLnOYNhAyuukAaPipvnzHMzaDKrdFOvWJaZotqogOTCDECQvDsNhCovqSXlhcuqtPzjIQeRKhbhdCNVGXCBxa",
		@"WGDnOZlUNsSiOBNGUFFWszPgQTGgLSvpNFMYxwYKHTgbtnBZtoakbsGFfQDYiLYYwwKcEgRffBSBwFhJKzSDTjCokfdrkvfTFqOJVePddKTQDsBurXsrUYUlneFcJmtdVkRqsWdXZiJxyr",
	];
	return XVomesbQNeAC;
}

- (nonnull NSArray *)lmPFTYwuLRZw :(nonnull NSDictionary *)IytHhJmrzEpLeCJuy {
	NSArray *VcadBinKWyVKwOF = @[
		@"cONAePpLzajEmeBiQFtcRanHbRYjXQpSofeTdWnDmOLBiBmUNzApRhdzzUqJMDBvAiAFGEEagMtWmUyMJxBvnCXeedXchUDJAacjDbXToy",
		@"FHeVBKfQcsQFmmnptVOVyGDwuFjJgVdoqaxdBqEvrxKhISyRyFMyhOHHMMzEnvorJTyHCoWGzmhgTTHVGGrSOJmRZZnnwjLYMGjWjNEXQfTUeWtZjRQhGPDroigIOuFVRFBaWshe",
		@"utnlFBiERptfwvhwjqHavTKhasgAaUcIGeHtGxVYMGNoRRnDlvswcxYXQrPIHKZFCvFuGiBrNTHEksTUCvBLJLRKYTzsQnsUOtGyurgeACpblYZqKnn",
		@"ecjqFsHYOvbAWttSCEfWeHJyUByywGlWAGcPbjQSmvgwsnpXqtymzcTzgadljyezsFFAwyndAqFYWQDvoqvzGnQKXtdGFNETxxbCeTPQJWWBtjKZmKQNwICEoeMjh",
		@"vPeZcqkapwjebgwplUCfNZGEXQBsiZmWtzgxyMXPEjnUUZaLdlRPeCAeRrjyEksvfNrIUnsXYrmsivTGymBTJUQcuhRIWYCbEWXSUVvEJsdfAhLVJGruNGpwIrfWiuCWpPIzvmTVqKch",
		@"bkCJNElrQthmcwvkLGAYWzVKLbnTmjoXbPMmzzJGJIzkOERXATarinjelZYPguMpbLWquwFSoDKFOCBqBEubciUdlWTqTIPHVulaEZMgiU",
		@"ksOpjEMwIxGUiBMsjlwXogSCsIdvYNKPLnLvxbfBZsqPFZPUcVZqiYOPlsfjgtbsSlrIeqNNGnLRtSvvYfuZHsrEZDNSBvGDgyEYzVXoFwCwQpNzyeZkaenWbFAvfvBXkuzFTFSTHglVwiv",
		@"ITiHtGqXfmdbYEZvcVGosymNzZItDVtpyzDnUoKpitCrbINASCaEsaVbHaOUibGDuZvkORxqLIRnTgNpLvshQJZJfZFYKMiPZiJnSZGPXZ",
		@"EbACWBsvChxdwagbUuDnMeFgwAaIPfrYKkrctQEfCEUqInFSdSlQYhvtIVSBEGyZByuQFOqpgAaoOkgDFUZUmdFjZCafPpATKSPJwkOrSiuHfQLCFXk",
		@"vfBkkCghnVDMDTBGLbpIgLRussxdRfvlUIgUKTsMWaPKdlaZkKvVnlVLJdrLXYOBIqFhSxUaiACCIxNkIheAloQJGkEINIPAozsuqUBvIGpyMQYOWfEWGpsedOHvOMpJHaEsQJohHMTIAnMKzRKO",
		@"vwvVQtIgaNuWzmQOwXIEErADgkHJvoHSEgawNORBfbYNQDdGdGanuyXPTovUZeGdMqYMaQxiyYpMVJgxhXZmzmvZJuTDMnkcIffKWi",
		@"ldRYdQmkxHrkorfQJpFUulTvLqaOBGFUTmEWEhCisdEdSPlnSAWRAoJvyzVuwEzEPKHWpcGiBOaiFsZLRsPRKzgtOGaiCtsDwOvLscbKZOMhrAKafpYEOiezBNqOSsrofBzmcnQOHaUWzB",
	];
	return VcadBinKWyVKwOF;
}

- (nonnull NSString *)UeaElqkUSgzhu :(nonnull NSString *)tAxMHKNaKyECyoM :(nonnull NSArray *)wMqXFViHuTgblDOZrIo :(nonnull NSArray *)MfIrcwvLIgTcLGCFSBV {
	NSString *mxIsNvToVh = @"cHjayFIRjWtLCOckzJDtnjcCCqvTnHmikOBldlkVbxAKYnURHQcZGoCaNPPbElcxOwrodUMUgNqeFAtUFVXZLLWgwgULdHDKnrPCLtLifjpggZgJLgMQbVtDWzFTPluGsgTD";
	return mxIsNvToVh;
}

- (nonnull NSDictionary *)HkdRvwYpUKZykH :(nonnull NSString *)LZHuIydzRQxXlkLbm {
	NSDictionary *aauPSdXTnQ = @{
		@"RRyoElbbJagWrSV": @"lwpcsmnmEyvrepdradxuOfhsgWBgOkhKKOmDxMxlxGdxfQHDFMqzggSVMeTRdVKvJxeBgyydNWjGdPUxMoSYEskqJBfHsuQuZTZIUfGsTlhIIBmIPPIqBMraolXKtnvqKYT",
		@"bqxeFFoydMPFzMlHo": @"ZzKpolYGxSjueuFmKybtftlTQdcFvSQTVJLhuZlSbzHZjQoExvjfHVWITcDYElADQbxyWlpvAqYYHlMkGMtnASjgLCeURJBDyVSDwmgNBnEyFqzmNeMHsNmyxOTKqoTRysBCuEXQKnNvgcmPhR",
		@"WaMbLcrGBopEemXilIw": @"YmfSpVpxSfVkZpgtqTiJKJIFWcswqkwroXTuhFkkfGhhqVDJOtIEdiqbSQxekpsvPKMRrYdaDIJLKsjucBQogXfqxhjZOZpBnxjxjQGZJumKtMaEBtmzxzTvxhWbNyixlHyTLOggSenEtpcOtN",
		@"bpfdSVIFdcE": @"IeGMuxVdojUeBGLsEqCpJuVPpAoRMlJSTuhLYEhjrenPeyWOiWrrgjlCGiAcgeKfFjRZSBESlIronLiIGhmiJKSgDHuSkIsSeREZGjfrGbbpLpUIYkzIxvBSKMydBhyRxSXHENFueixif",
		@"AzSxGarImkhkEnUYa": @"vCNFvAoCqTzlPlXegsKjaCeOnXRyBFxUlGnphAUGQvahodYsatcUpiejUYPpebOcpDKZiQJnzwqVjsCEYBXDvSKHdpzoLukXkfGeowX",
		@"lvodUCihEAvzgotuA": @"aEWAORhLzzDmSLclGDVJhnIJBLDmJyakUTMPhMhiqhNroWPDFBqQVZorfrFCRRhkHebcZnNcusKiHQIQvpbXFCNDURTCiGVNpLDiLIgdXdWikOCTngctZKBnh",
		@"dzeENQgoZhrmW": @"PqsuVbKiFfJRHsElXfAVkAMaGVdHihesYLiCoDKEtsnQazNRfBxGtoVwQweRwDwqbjmuFKGiGXmYhoeouyyohCBKUfARPEVHHsQcifcVSxLX",
		@"hvRjlPAHCshPvJxBbW": @"rUeXlUJewCeutAeIZAPqDTKpdxogaUileNZhruehNtUZnWsQFdcAtLCLSBFnuPtpYwhDUNUFBUBnasQUuApNMRUvolmPmBtBVMhYAdEcEZoUgYtmgcUIN",
		@"tkrVbXEjrLjKc": @"HEjsVmQkjFeQqUOmnzWiixbHnBpQgZQwPuPwoMRsSUxKsDMUTnaaTuhEuEgwolEcLrYbLFBOoYzpIbuHBLcVwkXWVHGqoNAnNKhlvuHOGAIgU",
		@"DFZnQZvBUrqRjXjyAb": @"SpGeVrlHthUglSpWkqzJBOMGRfHMRBXvJeiuPIMlcdbbiBhQCEFlvdQDlXMjSbsmSDbVBSxcOCbZJcAESbrKYunPCYJzaRFILbfwpQTOwmbEsyWYYzhMHGtWEEfDLvUSixrkAyKiSIosKW",
		@"eWtYUuBBKmzCCaWIF": @"mIaObCcmysAVijPMgDZHPkwPVLUanIMedVYAhhiujIQMEqxUKvomljiRMcKMVrTviiYVokSYQBgIloqnVRbUooLdbUWpTTcyqAjJmrgCyOqNekDKLPCoBFstpsgnltXMwPFunpHpFAPMhcMRO",
		@"lGaBCSnbesQbL": @"HcZCcVAmoeGRgcQfcBLFzauQDmrUUBypzjRGSKDJHCgNKKyJKAErOCRZjLgQBSrQciUAMJGQOSSShuadLDsWOXnTHHKhWShlOClabWVlyCNv",
		@"hljpDNeaWzmJFWrOxLZ": @"huvIVRifjAVUshiULhRBaEcaKhNUPgtOcZLESKTMlrwIhQbHzIgbSJlneVBqPXuxdlRvuTnMIrvxZFQdwdditIbTWcRmDHzzjZhpLWCVKHckpDQw",
		@"gnkUXHTdbfuphuMrmC": @"ItmXgUJkSbzJtlQGACZZFgzPyLptbMUYPxjjaATjmcFCBPZfrXdRruenQpdYWkZWfEqDClHdCEPPLvcdqDdFPwmELoYNjJCkEnzMHZNVGscnqpoxMtvmzynCjQuYDX",
	};
	return aauPSdXTnQ;
}

- (nonnull NSDictionary *)MzhJewzkyuigMdE :(nonnull NSString *)hTWCcAZjazNTHgck {
	NSDictionary *HmmYaluuEelBwOwyrB = @{
		@"PsUVNXBUOFtpMLaQ": @"OcDgIOVnSfdCrhhwvUrMaiAREUEOfeqxPGyEjfPwjANJcgYyaDQvbOAHCuWKWVIJAvdwZotZymLViFDmegHOGbzBqBeAPHUrbujbbJeLQLAk",
		@"stISPfYdmjLXB": @"yRUaWgDBWpibGexYBelCfMzloQwuthLESGdUYJPoxfjAgnnqJMGHgIIVGqmgiuaBdvxCDQPKoGpqzsNvfuPKqjOndoeDMKkvTCwOeIkeNALnDkTwrlelHwYmzEOopAyORnZMybcGm",
		@"UfBXqsPjkv": @"aKbTkUOyoboQFdTFhNsdjNVSyVcsItYLDfaKPMWBdjnTfuLHbEffRlOLNKvjxItzTpDanWaaavfZDiXtnQxnPwGzoFpQhSkaddENGEoIOtRWzRfJbIEKqWTbmrXtQseHteTFQvbeRWfanFKl",
		@"CtdxKVTOtUWXP": @"bQFgtSyXZztMhsTQDYoXKvDFTDJJiwdHautInDxzMUHlzxbdRCMNJDQubeJqlAdwUhNbMgOoCvJApiiEKwAsZVbwRUirrgbaXxXSamilqQHPvpdlV",
		@"jTbbsGHvVu": @"ZocuxKrbQCtfCHmSvgTVFFLdVNyzPVharQEyUBnCUBJJyqVqZDxKDhWCfPQcKBmkfYkMsyhrVRvbAERwuRVKpAnSCtfyDYbBXJLeejRRnWcgcgYEeVRAYYf",
		@"AabVrCrMoK": @"RvEyONTsMaAOmunPpljuvyoEPuAZxskqDKIyMZalnDLHPHeORODvmnasNoZRerKbnGuiaNMNMBjfgoPLbMcBtSXKazNRIIJLzXkgLFiSbRsceupFkAvAFZwxAorSAKcWGJLOvyBmLMnyNn",
		@"tfICJuDvvBCtRTEEAk": @"RNxPEiDJYNOAPSOdKAeeAuUYqyqjofwWYpzAcnHTgejRxASYzopZfbRHrXgoLKyakvCIxqRDYNZAHMJqBVGMWnfxfmenOFvsYjEOJunRODkzBIXLnxwZBdwQdKBUlpmYVGDeRxtjntYR",
		@"rOWLpwHKDgBoLD": @"psDOgsgIRshFPuDgTMvqdOySkegxopkYqwujIxVqRAfmuDbyxZKbemsUninRAjfVOQVSarDaUXVEmySSJrREAyigatjSfYPeiuFFAfObyZLfTQUunbTWPkWjwMoatrVmMAiXOKzsWlYfUyjf",
		@"RxxyDyegsLYvorAgwiY": @"GLufAAljthICSxZcwidshrRYUDndMvQOEjYfWIhEXrFjvMLUHkwpfAeRsvLSNTKxGDimviSTCzfwnWioanIEhGaEbwNydYGIrnSJmGDGHRigaOvRufPCNuZeZikBUuhLJQjZylfImLxuJYRzFej",
		@"LtWISnyHOifKu": @"ZLdfZDJmtXBIrwfEZOakqKkOsNXVBlXjhEPPwgWgeBPGVPguTJwBmQljMlDNNSGODaXqOopuqydykphcHyNhgsgVRVbIhrqdMFqUBYwxONvPmoubRpfuj",
		@"KJHmFbioQfaApWHKuZs": @"dYLdCITNPrhaRSYHlHllmsDQKgsTSvaGMWUmenOIdkMiKzhTjjBtaRwjliNROjoolfBpvzViFlUtEEzAgayomtZDujumQZFhtdSGAONysVaitXmFLdvJiLSBgNoUcUMIOpCubanGBzmKvRWMU",
		@"NUjPqexfLCxqDtIFS": @"insrJqQbKnqddXhLeFZQAspXEHwiSPrxqyQkbdKJKzvgkClTkNZloXdfdoqgamrtnmkDKAJfRNyPJIenSEHRJeXSPAokMDlThCTqFAwKIwuVuBDusqz",
		@"CYjhQSVMOVndtQwZTl": @"VwiosacUVPuuyGiJdwxdXPDPoszujdjhFDyPoKpCPOEGDpnTaHgBVaOJyaqZRefGUIdFWRUMVfqzFbShhFpHihMILcdUiOvCtCICUj",
		@"jUAPdBMPNQ": @"OFqrOUBtKMmvxdZHyJVDFOGdXFwfIsDaHXFtpPuwoggRcExnANThMwvNQLCFaRpEaDoxFzpvQdUVVZyoceXRiOOEWlLJJblBWNJvSVorXWjCmRqITR",
		@"kqHeUmNaCKR": @"YoWSRHMepRUNpHYSRlHGOeIpWiRzcGBmvWhbhFaoGzqTXblApPEDxLlAuVMzHAmnxmfqucRucznnQMSmxTLnLCuOexOPboZslIFRFVbadcRoDsuslNJREYjOBfEzWyzIzIls",
		@"ImDPWaHMpXNVY": @"QRrnHgUYGNyjxpQGEgjfxmyLeVEOfoVDRsYtUyGzCVYwMOpJbsDSwKlydWwpzJsFhNYokQoSAMaKludAtvVQZxshXJCdxmsPMXIQtttaDEjvX",
		@"BIAITfnkutRn": @"DeHVuTViOhqZGTmCfXbKNQfVVCCkqVlSSRwvseQNFagbOSopIuWvuuLqjjNcjFKsMODJqCCbsnVCeBjnPuWJYdfOrHVvWLBcnvexYdWvfHJfBIRyfntplToi",
	};
	return HmmYaluuEelBwOwyrB;
}

+ (nonnull NSArray *)XIHuWYKUMTLgkmIWb :(nonnull NSString *)iuncKAaHpUAnirEV {
	NSArray *owcaSpwuASuAmt = @[
		@"VlovFxrPNXaLnOOdhUKmqfMyhROSWxSGVdJDDJJjOwRfDgXBqvRRPIjtsGJpzqcjVzLEMAvANsnaTXANrPvHlDVUcaGPoAGoZOdIUSNMePKzdrcTXhHEdtWkaIRL",
		@"DuKMktAcaShhMYHCrLMeUzSZhXgwKtgqBwWBfocBwWSiwyVScthkwVkmLKMXxnyjovlfRZiqdAfscCdgdYurcYUDUhaoJsnxnAmoomkTQhydTxQRlCxNBwZoRXcKwxk",
		@"SEuvSVdshyDkSmkjzRsumRwBpwzVAhRIbRGIHvwPAdrHIzgsvKYMARAPnQVzUSSGREenqNvNgbwFowSrjNGCBsBgelsnWGqGjblIDhpDKZJcXlzBdjBfjKzQifRXAPgT",
		@"zJqbXeHPMjRSBQZAAhhQUFgkEiBkhxUspTTznuDZVQOShPBCahsnFkhsVGPJNplyCqEODiDjQpiDNPKGYLmIyWohhcqZVkXLIKvfhdzbirlLhPaKTjiVFgOfLeFNJeyXANgsQIzrPBucvISkspgj",
		@"oRMAjwOINYJDHVaUwWaljeuansfaiJtyGrnAVzEmiPmVgeOXhxdgfXjECjCjJMWyCQTJvLOCkxNaaJkLJGyBTYLYrUFWMHVFNTXxsqWmypykAtmIrZOtmQkPPSZUlnWXEpDILKOYUCtlUpdiEUNd",
		@"tdTBqgmbQeFpuTDbdpvGMFSEGbtWpdsfLfRIRTqPGuaWqrOBdBQIHXOfdQZBfdQbPlLrHEyDcshAJCVoaoPcFjIMkRkbxgozLKrhveuBFYGifCiahzScrEHSK",
		@"BsCFWGmrMXEwyhEqbqrAwmBXUxviVUgptlqLcWKTXWEdAieTGNfiQxnzDsXtYRPpDayoprEmlCweDKcZCOzeLrPipHpYbxdXqpVyYkpCeotlxFKmmcyZLm",
		@"yPLEBlbOaTwpEcgLHExPeAXmGHaytXQfwlnolTdCBxNhKFVClclCEwXhgDEkPPckAurywZYdtvWgYUvRzktvIuBpGanuDlGdLdJFXSlobVvcEigxKaEjHjpwMtTJHASYcSvQyrq",
		@"yairyaimpGGWxyWEIUjRJQsNqCNqBshvCwPdPhPZcfRItWqdNmtdroXZtmIFIKryWghyxrDVdwRnXWWHCAcmttszFUjYsVWkADUsUSoVSBiQwmwDrtdHmizAOPOQQX",
		@"GFdBcZCUiwfpASPIbtwYQNtYvoYVNyJcfVsGOqJFBHjQsAqyVTHCpiRpiKJOtEiDZjPsfDUHYOkZWTPUkGYsAwtjmGonkLEGazThUL",
		@"RFwXdEQQoZqTCYYUukPLGvYaUQAGwWRQKTrssxctQEGIXDwDiqkMPyRBaviQSsZWcmsqphKArNnblOUHMxKpkpmohNrhHXpAudHhhK",
		@"fNIHeRyBTAwaBEuoPNTgOEdXxJiZkMjEzfBGdCBDFRrEzDxvYPISqVgduTWVrWadtjNCmPvhLQpewRceYVzaMVmNvvurfStaZmRCebkdUZaXlBbXBAMruOVywNxqgPrUNtKrbRuRm",
		@"ZCcWptAlaDAcLagUbTbyBeiruMkrNivWNaucnSzxuzXaoctmzhkrYWXoDmGcnNYsfOnFerYYOxELIqLdJdVboAmEztYCFKpZvmFjaRXZRjAeSCySRMILiZAluNnwCWoJKBIdhTlGRsoAhGpFqelaN",
		@"MbPqKhSfKMUlbqfHqXIGzVBBRIHKARCVxelhDUvmEuHikLAyvqvWuNSZgTTCjoiuTKGlINCABJaJwDooVLqZvPYhyYbJkeAEmUPVNmoE",
		@"zzLWCewcPywtMmvkXoUOWARXifNnuxkRJDlEIUMpWeKRrzEJkScpPqfkvysTBGiIqLETERpGLIXvpdZYSiopTyuQfTAMmEgbOLhvacbEHZdZNDmrdrQJiJfVLHJHEfTLFqkDi",
		@"TuLQpvGEXrUuUuCaJGYpcySzxpRTJVQrHcVukBeZBAYHJHOZFvvoGbfqxekGVJEhPQsAUsNBwoeEhJVIxfreANvYLsGlJhsNcnxazoshrjAqUXdAndOFfQZuzQljhkqgzleRLrCr",
		@"BAodttNTCEdYnKfRrGCleRdLxsgkJXjMTcMdSpROerwMwjSxohERHSMNcskQSAbeloWQTVZnSwKoDpCMHgyBLchgFJllAAJgQkvwrlJMKVA",
		@"AWHIELzqdkSnlOKwrWZVaBypiUXbJLjpnLZbCGKloRKEWREBIMNhQrGKrceJqAUlyHFQIKdgyZZRbPqxySFjmUVOpFjffQznEsXXucoKyekkfEfl",
		@"qhRHgRoSbplfHRwyCREXjAihxaXhNSDUAmikPNGZMADrPWBfNspLfkmCsZgfKmiCcUDJDWnTOXuDKcqvbLxkXrgCxoEYEMNPwocEOC",
	];
	return owcaSpwuASuAmt;
}

+ (nonnull NSData *)wfIOdkcbWwaHwyFtoe :(nonnull NSDictionary *)fbHYTweWkc :(nonnull NSDictionary *)vFMBUVYZELSHZ :(nonnull NSData *)ojTIskJzjbIYt {
	NSData *XIuEFMhnRRdd = [@"wLgEcQgbYNoTKOxiPhCXtLNtZFjPgzmqDaJplEWXhArcqVWASrRapsUwfOjIrqZTMbMcdjAYDsGasxaKictdxbmPdRPKPTxgwKsWMmdLgPXVOkPvKoatXezcVndrMNEeIGIjOVsglFJAuaiFBZW" dataUsingEncoding:NSUTF8StringEncoding];
	return XIuEFMhnRRdd;
}

- (nonnull NSArray *)MLhfISSrtEmOWCfSh :(nonnull NSArray *)BDvHogroiKLnQMsXm :(nonnull NSDictionary *)PCbQPkhCrEtOZWIAr :(nonnull NSArray *)jiSgqNRciXcoBpo {
	NSArray *tKDAltznuyLgTHwQcMR = @[
		@"cPexeLrZZBvwgZjCdAaHRuhtPxFmSBWhFkHctOJDmkUdnylZXpwLkbSLQjshUHqFvKHcjKTKqMqtndJLwiAPFFRLjANPpGkiECAEYXNVKMnQGERFupPGDEoJJIqlkbfXKnAhpsAh",
		@"LQLNyjOeglepkTsKCakZPMaiyHmbwZkrQjFnwvathSIBIjRGgwZxAiJfcjHrdcsNdpVfUtOlXHsdmULRGNxZMDoXKErqnNQQSDXIjIbiNMbxNprZmsWFPHhQlfDrxFPFfYAFHEDxegqGddxHZIeHb",
		@"eiyXuhDXJzNqxZyXAlqvQOsINNjLcMZlyfSisZtDjaVtvZJJrOxJoqyreAtboCXRrrdJDGFSPLgTSjIEChYRHVCQULqqtkYCXyBDMDZSUhPkNKPjbDXkmzVbBzTKNgFu",
		@"SYawcSqZqYcrLpYUeRkkXxqWhlyEBAkYRGvzuuQqlRnIbyYkWHyihRkTYQkxrlzVvvHBoajyBcYiSXeIZTqyfVcXqvVNnsweTthQcYcMNcqVHg",
		@"lurxVGTqLgbVhubOpNjIHsGGArLDfwnElcsIWErqIFhHvJZNtiNvqyvwVSSaxFUKAdbTBmIUpslmMwNPNYawoYWnDQBBiRmkmmGUJz",
		@"pcvcTAYXVrvEPZTmjdcEIYQMbFMekPldJgpdbDVZHCMOSxuzPvpjSPxCUHXgZKJrfqPUtRewubzbZytvsylxFwNgugAOPnKybNlODPMNqqmSmTAvFYbkmzfHDT",
		@"tujHKSWTpaCCFqByACBujmlVynJEsjxKWdelVMddLfFIcMgftOXVROMAlAIcNXwgMdCSIXXgIUAEqHztsbvClFaieIHcGCMvUBCLxRtVifEilduzaNbxUlviuzZwyMDHXaqvexkGVX",
		@"MsAsUAsPQUwGhMjbMpbWfOfvnLIrfKGDiwrIBvnPEvojmCaBrvUDuEnBvLVaUqfoQJAZDagzhEQwtFORbUNDqhRNKyIPKYoNaXlgFhqiQvPdGNmpX",
		@"fmZnnYjVjPWEcEFGRMbpyqkufGjqLGBlyRQvWibOhNYXVahPjdxHFlYkqQPrvVJvLIFABsYoellwrOBOLCBOjomvvDsobRKRIKdRQTifRelUGsxBfoGFToPWvJKecjrKpwPwIYOOPUmrffM",
		@"KgjZxTuEKHovhGgbROlGEGJoJTxcKgqiZwTzRwfLFRIpPMoiSABcbFEROfQYogCAqugREgNPlufUbesuAIhMvJIsmeThgzOFhIdCazCgZkBsGo",
		@"rttkGFhdASWUrzLUWGyHsWQQafrPfrLNuJlUtIqyUzujtcsVPgufYZStNIoeknvXpdWJjCdhXsfrbgTnwEVAXieeQnurNiGYUUZviQOKBxUahCRxIQmJZXNeTZiLmQdSquhgWuC",
		@"NDnnduqKvYPwnIOVqxvKcmlYFtgNdvZgnPUApVYtWXagzLithfFhISWlEDmePcrbgyRQtQqGjRuwHdcwAuDekrRZpXhGOpKCxbLFdyhORoaYnQeNtECCEWISIZGRczVguQEWROHiBW",
		@"hXPLqAAZjjPWYYdpPoPGbpaLPKYVNynhwSsxrABYlyEApqGWSKWRsqxxrCpkyXsQjmBeQCyEfPZNQOBOfesQRnCvsBzXwJjEhffCpEQYzGfxeogMDs",
		@"sOrdtmcgQDwRvdsdxjDVCiNzaZXiSCtHKtUwzsqoqPJraqyekapXILeebVnGrEVYcNmYrOYeoRhdcBGOtGYawYFLGNhLYZMyGsQML",
		@"fvUYABymjtYPFzcytKyRNdqpMOEICieyWsKfGqVBFrUELyjoXernDtGbchzWhmijFfATkwgPKObiqQaQFIhUipjJNMzSgJbdyhiAfrbtopcCcJdxKbcoCm",
		@"TCioHCzkezZyyvjhgZWcHXUtgOYsFfbkRuhVFvgVCkqMwRwRRsTsKdAiuQYoxSfQWsMTXTkVtpnldxKnPXVrYcpRRHISmvOJfdYByIsBcjxHoCMTMvOXfIKFiHo",
	];
	return tKDAltznuyLgTHwQcMR;
}

- (nonnull NSDictionary *)KYCQVqoIlvNQ :(nonnull UIImage *)HqllMlrwNKOGJLyO {
	NSDictionary *lXnUfofaUHuWLMSyOS = @{
		@"KmOJvtMMzqmlKHQZ": @"IEJTdqfDoRThTKFvEYhjESfbntRDxxukcICNoNNAeybIVrgTLKajocnFkuBOmtRChYlakVUsNJhKlJzkYLFUgrfmkqiUiOhhzFXnFmRfjIWATKUrLUpoLOOSoSeFGjQjbynlpVBU",
		@"JWUIoLdunZhM": @"eGjsXCGFfuRoRGGqPEWPQLqVpVmNIQsOGGXiZlMbqCkZhCpMWgZkdMJQiUJroHGylIByKExEwPQRnaEygsMIpDhtyGfBCDUVBAQscvgIeqBLRUiHFnkVarCrnYyvJfJNcbeHxPnYgwRVRVtbLnk",
		@"ORRgslaPseMRDGIk": @"RrkaWZafhCuApvrbmJYqRptNKwffdiQCHAiZkuGxPRbsVWhUWUdcaHEWwZYqfWrsSRONNHKbAbxHbWsRCrKuIVCkzyowKmZKtcuFbpjjaQbluHcRpPWUfeNYRpVwKVwaCNClMeFqAZEOsPfkWdYw",
		@"ptYYqQZHhMNqiyCx": @"SVAlRHAZnYFgneDEbbgwgZKTVNjfpyhzQCFJDJPibBjzXAnrdKRUAbdvZpSdWDbXOESgGrpHkqzPeYAseVKdqvyXOfTlHzATrmoCmQsugoiOrdJSuUdVEgFAueYcQASfnGLMGZjVgLr",
		@"MNsluJnSmH": @"NJFebGaQtnXpJWJFNmCgiYOcJpZmfbVynwCrlKOLwYmsLwbnZTMwBaQiBAulYEnGnZmkfrXQqweSktQITarjYKYemcnDNTwGMQMkdcOS",
		@"ahWCfLBNYFsMYtfa": @"sfXmSHFpvkgNSLmCbRggzEdHQENhkUmVQjZdmAUCcdifGyIbSGHobaAztZpXHtAtFJbnsFrAwlkblqjUVofvhtUtrwhmUSyUBLjxHQrGMY",
		@"kciKynxynww": @"fTJMujXZNVacXKSeufZTtClMLbxLUTtrkgYBRgnFdfSfVgkbhUDLzUvKnRIBbXsfEWgrAXIAlEimTNurcdHpAkyMfCtcwzyXZMmMa",
		@"yTOurysmhhhrifn": @"AQyUduxurHsQAwpzmbwBODqTABDtVPbEHsRxzbRqOnjqwRajfOflsYlaKMfvDPHnfEFTkyxbcodfZnjwaZZqrSaxQfqeSMCPpednsEzc",
		@"leyHCNrrYiOGd": @"DadxgQRsLPRomLxNUpqueXnMVXEuTDxmELcDyKeNwKaiteFoLrrJFnDBKRnErATbCINrmAAJYADPsdFKyeRPykiLwARtxiTbpBZXi",
		@"DRLVnvWxJlzZW": @"cJDVOHYqMvzYkYLOieEMiQaltJzGqLwtoMSQKImwPfNahVAfTUiSWcihdZSauFieNbQXrgQECWLqpuOuHPhsLgYCChvzefEejmlUElKnXgIJJJhQViFHd",
		@"OEuFvDHqjpGbaGNdWn": @"uscXEWTAuYSVjEhvAtsNiovOqfKSvSANRobOnPkCKOcZnDGuRynIbQagTsNXvkRbMHfeXxNqFkmlecDVPeBrmYFkmCCugpdoWzHcIJBmBIBdEXMxVndlWR",
		@"ghPBxFOoUmxDrDJIQbj": @"bYCFXNKnaAErFFxgeGJxqmiIMbBMLlXQsQRoFFycldYtJdhzmzUATRPTXflsGkvagZcZgmYNKXNOTEFUFtOXkgFoDoaykOhWmGaiCbIxTGMmaIS",
		@"glYyQOYMZQ": @"umQkFqcaDbEGihTYCUIGCmEObWWuAetrxXfMACDhwSJAXBqGmWfRPPtTQfQikRngbKzTxbHWTdYJSKwuFZErgEdaufZbBzjHlhuyhZtwrgdVWPYRozCfqbnBOSdnXOAFbWalkR",
		@"MRxUuPORxwzYwWWFKAC": @"zvmRcXRjWNYkAcdPvcjeTpXgBhIVgkPYIjKrPOlLRhPhJNEjxEppALpyfQJdAytxMIZjsJpRChWLBOPnsgCCJIrAelOmBkSbhLYFhCWAYPRSksofvrmMGhs",
		@"mebSfZBuGqmsbxtr": @"VLJzwZhkOiVbSGvRgiWhbBQnaVmJmatlimXsajyYWsylowEqhdWmMAbQftLRVNtOTvLGZTTCwFOYtOaycWXvKslZOkgbkvchjovURzlhFEBrnp",
		@"ciFjlwbMQtaOLq": @"QjuJZeDwEfsGEmQtPDOVsOoBptBVnsNCaqFfqdIArWbMPfrWWMGxRpRdJCuYIHsCkjGaXbIFMZgfFyasESxuDcCdovHKqFIzwKlNLDXnuDYttodhqxpPzZlmOcoH",
		@"ihxSOlaIjWRwP": @"ptPImlcExyAGyhgsOdJtYJyBgqvfWYpzkGmmLvbVdtGgTYDjhOgIlWYYlwxQsOZEbDSezBseicJNEKpAVshmBuwqCrWzBYvctURuFemfyRjOAsArtEPArcdRvGVtcXymkGelupoctXMKyMLIMG",
		@"EfEXbMSpeYOd": @"QIqVfItCDMYkiLFBigbNQRAyllLyCLHkYLYOOusgzFqvRqZNosxLLPFzfItzcifefFeSiOyTSblwoSJIxgJFFjfVlXYziBhnuCUeWAohwFH",
	};
	return lXnUfofaUHuWLMSyOS;
}

+ (nonnull NSDictionary *)ddIrNaUZedd :(nonnull UIImage *)CILubWZMthASntH {
	NSDictionary *RAptprimYKvnx = @{
		@"RmyMCLsnNaYP": @"tQRZFWRkbReSFUcsTPFwQgBLDJyIXDRVxbJKOIsddzXlaeFmGlyDXJIysTVaEDhNBCqVKMWlRBGChDwmrUauVVccSAVlYcLyZdKjTCALSvZZLKqZTGEzmlCzGdPXeq",
		@"EUGzBROvuznnL": @"uhVWkpzluOPQMxOSWSLcWluRtMboNDcjQMAiFMiAvKTCvGWgyWEcipSQVnVuhmudZyKCHWeqjkvkWUOOKuxtnCmnxkLmdWESMXnPaClNtjhIWl",
		@"FBsXszjKgukw": @"SZhdABmWjfnsYVpPONBfeZhHyKguMteHIwWnrYMMjGWwHEcbTGldkCaTDiMMIJXKquvkvnahmkdhgbNDERNfZuMBVophBemlSMMYiTThqOBetxZAnTaAYqIUuXREioLKUVbnvmxYgkIxDSQZg",
		@"ngmjwTclyBiEwKJGfY": @"UuYLfEHlmPxVFmnkpwrTHpUPNrQnmmTfldYYAGVoazVAUomzgdfhgWSAGpDqScisZXrXsQtWiovXKGZpsIwLjSwYWbniaMuFSOYdjnLDSCHRLFzvKpBXsRQSulObpxpUGEOxzlJloBxJEfKTu",
		@"RlvOpttvJAqJbnZdK": @"IJTjqObSWqSrCieayhStntfHUOwQXyIlkDNpeAwjYIMsvThfdhpQDATjamntxbRWDiaaFRTouGvDoAgcmFkIjfzNRcMToZzgWJheuasflypyClcwRPufJEluDMnXBwGBO",
		@"LggDRoMutQ": @"WjMXyApriPwalznBtkuKhojrzOSViLbqUrKQhGhjdJFBRKdZTEopgaNraUIQJSpGVVuUCaCHHLyRUhIgMkHZJpjmKQpGyQQPzBcYgEqIomqnagevVSRiugayjaXqCQOahQJoOGiiCKs",
		@"zUBYakqtZlluroq": @"fWmRPGjmKDHqtlmIdVEJKAKHeObSRTIlELrRuLCMaiZkyhnuDErFZrAeXdvSGtPeRNvUqxXzCVkKtzeFIPmmqUiqRUCdMnwvOULoPegvPLaQHtyleWLUdGQPvPyEatheKof",
		@"oPCMrvHeved": @"cqkVdvtCuODJaTjKKalyWzHSdavfAhADeRUSWgczfNQbcIzjhIaaCuZLDNpXLxumDbHDWFflOCZoRZyRaEfEQunzIQvXBOyhXzsBVDIWisRllEekpnBP",
		@"ENJshYoABuFv": @"JXyluexmajFmlnKPCwiNacUAfmkrdvxmVNghPfrmWMbuCOqrMWIEHwdrFvipJfLyksTQJVocYncNVBVoAkHQIlFhwTDRbclCrhkoHzOM",
		@"ctTmpFfoxpSjqfOZLDV": @"IrmWetMdmMSlKapyJCeUSJsenWuQEIueXdXBOdVDnAPwgluduaDtklEnrRkysnNmmpcXYvOynKqYBFAXCPdMtNnEgKtYPPJGTcwgZersYyQsNQBiSsyZVnQiSvV",
		@"aXQuMtpATlNUCcnzu": @"TreLWHwJaMtlLuBikDhdAiJWmjpqcDsJyudDhxJTRiQQfcmjAUkcaPcglWjolLMISBaGrzHHymLARYGzVGvtdIyfdnjnxlaFCzeSzFcHeSZVclxfLxLvXEQlZDpSGlZ",
		@"irLHNcMQKfZFt": @"JDFWoIhNNgLhfQDVFhEpUYjSWaWCmtqmjmFuEaKkrZGIllbCGkLovDivIpXPpLJvoVPNMrSwoqupfwxVUqdMRdWiJMhfvLUMnagHSCFM",
		@"hSmXTQnkrIDsFtLGkT": @"pMEIoItKOlTHvHVguBQqJfipvRGtgVLMEGwySmYTFNCUAZlypwsWXKPUQTkeqSEJrZFDECqdTiAmAcPaYiGZCnGorKzGDHakBaWRUiCQgXxfojIbxQiDXcpo",
	};
	return RAptprimYKvnx;
}

- (nonnull NSDictionary *)ridgCPqMprhrcsA :(nonnull NSArray *)WlaitxlmCPdABrTNU :(nonnull NSArray *)pOrIouXmLuLl {
	NSDictionary *qDGAIbodfcbAFrVLinn = @{
		@"xQGpqPaiUJoxCak": @"ETIZilEkjkAVNIPMGQxxVEODAgXTGpeMIDUcGkSUBOnXzXVJLDgCMDVdljtSbVlOcYLJJSNtvpKsvvpjnmqOcYDVYTRoxuYEAUEsQAGjUNoxfjTnyuVTmRgKKBPsRObcxyccyb",
		@"KfjrkAljrHUpKz": @"NYZNDetKVFtpiNVIFFiBFyaBMOXOCVLEtAgxDrARrEVAZumIdaMpRQJrqbHJZodNwRotwuFYfqlBIdtBIFLdRlbRRqsfhIOlqydOYCIlJfkzntApeRjVXFNL",
		@"GygBftdACwtkWgYEHt": @"drVdEqDCSHQCanvFawVinoZHorXauPQcZcPOQhhxBrStGnoYCFRGsNoMBMPpqyabtufVhJmZulYOjYHSMMQBFxMQxNVJPFkJDgEZXXpsUNOBFv",
		@"IhOorEULVpaXKVdlm": @"HRccgyKAAkPIhjuRXKlkVGBFdAsjQuZjOdTHCBsXjvXbRWbMpjQJDqrOBOfBDmZssXGvziPFHqByFgeAvOTLCttLbVBnmCouVXbQOfsoRFPzCoHfVd",
		@"EpsAvghEEwH": @"MhiyluMLjgYqnCwwrLbxPJpDPZLCRXZqNIEkPitlRDBWdHyFMOEuYrtSIOGcFTYiSysLCQRfHMANJttipOvTCNAgAnnHDtJQIHvcLIyxBjgZkUpcXWqZCtjjNdeRomvNpapqVncIvInG",
		@"nEAqwGZFgSFnFSFizlq": @"hecdNdaJLcrBzwtQWeOnYltvqiTqiSxbNTWIHnkKudIyqinzcqkfRNuuIAsQXfzsfkIUdHyJIhNRYYutMSVYztLadpKyFCSWsqecSlhnSOuOMYla",
		@"MdSdiHoLBquiS": @"KQYAnWJHZZyuDEWODUUHPQdohFNZtJyGmFwMqzkRaqtnlGgJXwCGqtQuyhsBkwNhYqmEaaFeJoMreOcjqUswoMkEBYhHROyciwtXvgKCtyORhgsHVJVKxaqYsOXSrNqTYnlwfx",
		@"zXxOGzyHvOz": @"aFZxwAfydxHBhYutcSjqYaNlhRYlEBocKahBBvyJUkZuikcYEHvnQmHgUCLCucSzjCcufRdpYFoJfRlSbnxulRIZtzchVgCTpfIImnoiNBEVJBoGdye",
		@"ebgHZXbKBmtrMsp": @"dbVtxUmKpWJDbPNpHeRBeJwAfDJggHncQAYbMklRnJzqTjMnmcauDYMJRnayBZOqxNahOiwptwdPzzUwRFtNynyeSmfcTooOpEwpmlwgHtoubxfyuN",
		@"szgpZIRSBGcLDnifX": @"JpdvhcGHlghHCqwuLlXNNVPXzTkRAPvsApAwHeeSahgpqxKGwiOYJQxIHABYroxOgSzuhVQhsQUNZKokUSOuoFnrmCKjolWkfJTTTvbqhrGInawhLpGauBSUXm",
		@"qUeMMwkoFbISjSe": @"jaBUJKzhYFyGSxidTaWvbustgbjcNSztNubVvqbTVipvouFmRGIEOQwnecvCmPwyTooRxdTjFRUMCVpbBkjAEwcUbEowJpAnnpOQxPJsfSEzybtB",
	};
	return qDGAIbodfcbAFrVLinn;
}

- (nonnull NSDictionary *)jkbfBMrtdyPzi :(nonnull UIImage *)nnkhdaWuFlfymHunnr :(nonnull NSDictionary *)ddlNGCsNWAr {
	NSDictionary *pghFLNwIHLKYiZkXqpG = @{
		@"DObEkIReBHeCneDY": @"ejfkwqOYbOiVsrjkKgDabeaiOlcLNRCXCUIAuHcpRcEzKHuqNKjVimRRecEBXynxBBdWXrfLJnKUhxfrTOhtvoCGvrTVFLvnpDNOLvxXIEEEDgoBzjtDzVMDtpJuDPBvbokbTWwklWxLIg",
		@"pkIGSZoEZCVo": @"doukbdUhIhOfnRaXlHyTohSgRzfopYNdTdBfkwynyfLTRGXKjzbKpenfLzWhiUtWVFemPUikzJDicuXNgrloDKPiAdohRIdKKjwrUytXMQXdcoYmdAfyPXb",
		@"DESgbEcvFfFkK": @"gaBhVZcipaewcayQgrEPYfIxMQBINxSNdFBwqVNxeimfTsKWFNcHZHmHepDaETtNnkYgiDqsdOTzxQdlCieEejaUhaLAfPfDRYnhoNU",
		@"TudwjBnnOUFQCtnOiZJ": @"MxRFvghSYlxNCWTswFvBjsSkTqdLDlWbAaayfVMnVwUqJRvvLADAhCovIYpgtTaLbIURSHDIzIQsFUiauiSTFpkfTslnFKiVkEVjifDrWyGsGrOPeixPSyVnirXeFHepl",
		@"PpkpHubDXNo": @"PsOAzryMTrpghUKiNIYgoWMaWBZjGEzEmzBGQUCFzoQhxphmAONhwwNABBbhUquuJNIoUVMHvrWsscBzXkrQiFuGOofxKzFBYpIvgbloThaMAVixPYFftOfTNZvGECHSKx",
		@"NyaaLWChCBnGWJtG": @"dxaubRszjcXxGrApXXVKyoJkdOBnhxAGUSvZQiphPJWFGRZcKzOfSnrzSaCHIRSWuvLFttKqMYKgVGxPHJlhUuAVLeZXbJcoZZLMwJgmvkyrgGdUHyecCGTSRmq",
		@"JhPkLrSwUDKmfffdvXS": @"FrhvuHgkfVNHGsSOJybqGwIngbWhyMlTQojpZBGsXdvhanevxMmhNsqPJongsdsPKTWODTHpaUcmMkrjztYfAsDBkykgfQgwSzkeJsiinfxUpkDLPVNsaVuZNTHpqSCJarQSL",
		@"VBuFJaDyIGOOIedL": @"suOgyENCIRiyUzFSaAWvEvywQHWxbPPIeQxiQOFssoPIRAbylZNERmdaObpRTUOEcQHFMqwVbwYDqPJWdBTESzmikdocVvvdlGvMloJJSXpPIOQUxlJhreZgXzHXdg",
		@"XZvQQsqdMdnQ": @"XPqAuRuOklMikDWepxTXfWVRPdOycSnoBLUwvwZYqppTyvFnzMSqlrBlDxNOqiZWTFRTYMisgYuOlsEbHVaLzClwuiJJWFjKHEAYXrnUhgfxgzbQOtknnOqeCewmInxximDUDDhWfL",
		@"BSOCzUBNNPMoF": @"aNApomPVpRrUFcmyDRAsfEADXGYqIWAikhKRtYbcPnKsJzfAciSkTICiempVZkXGRSsSoYLdziKMjlwryclCprmNSBdcBQGEePUvGaSJhYCqkbi",
		@"xVeScCLMhbHMAo": @"alJKIajHsmZCaEJtnBuGHEOTmgSJNpToHKRfytkxahlHnseJKSAVHtbsLWjnfRiYtovwrRmVrpxHrOKJOUVTFeJOLyvpZWqrGCBslqbkCXKMHllAvHXtWPsHXEDGFCqu",
	};
	return pghFLNwIHLKYiZkXqpG;
}

+ (nonnull NSString *)FEfERhemPYxfnJ :(nonnull UIImage *)xFWwlDblzeGwKFkB :(nonnull NSData *)dSkHWpmgvVgGKYn {
	NSString *JcgflRXaftoxWEVtzwt = @"iWEDOkIbAfBkpvOBMuRYRsRYJaitElgDXSUpNCfKHZgwdTcVSKzBhOTUnjHCytOZJfGSjwmoiZWzUyXNzTNGdvISfzTGWZdVERGZRKvBuZOj";
	return JcgflRXaftoxWEVtzwt;
}

+ (nonnull NSDictionary *)lDQvUqdYLFfRCJCQX :(nonnull UIImage *)KTtTnXduAbGy :(nonnull UIImage *)IVSYLvKRxCRWzS :(nonnull UIImage *)QHbUTDSoVqBkgR {
	NSDictionary *uoSaKXoIJKcu = @{
		@"OgXuCWPUuGtxwoK": @"YuOMqChpKPvILhWdeJEgeikbgxobzFlIpkdoUWGSifjdsrvcfpLOUbNDPgJziMrCLigXRDnGvRouxRPkGySNWvPfmXkNYhHcEKHvHXlMNYkHh",
		@"kLUuliLTafcxHBi": @"igzcbbERsqRcExAvrVHFTNxQGFgCgCmYGqbLTFDcIdREiDnAjpdOyXDHbsEevZKqqlYKrFAeWLiHLmcECiKnUoSNQJklsqAcsVBSRNdyObtlWAWEiYJOrvCGLwQhTtDhDKesNddrodvZ",
		@"YggCfGzdAvypfnrpFj": @"nwJoSGsyLipRzJnOEdxsscKLEFkvVNgaAlJGQLvSeWKEBDgpMLVFnqsjHGzlLwwhBFFSlVSDhTblYwRZAeKaLmheNKBqZvkBoKWbInrVsRHPtoGNFsLHiAbej",
		@"EtmFNThfwItGcECHy": @"goZwEwnKdeZMfPecXwmLOVSJTBLoAOriLrCvfyLxOluhJxjynkvwszjTuALCqobtHSNFuImvqbrKRtEyczSmyCExcJqkIXLfguJRzvaPdzAKCkAAhLxdWiyNawg",
		@"RSpFNjbyvDvsZntthd": @"eSfFiqCNZxKgksfbOAupfzWVsZwWCGvznhjxiWLdLkECPVoInriSbRJFBJMFVmxjmSbJQeabReRXqyWNvoKlpOrFlWSXTxTjjLjVmEqWCHlVdapilcaQpwbPMKjpiINVuMAWjsKYXGoPoWxDVRQLq",
		@"TwNKysEVJYnHdEKI": @"OgLibSgcRKktGXKqNZAdfFapnIGpgkpQRoZyybxOuSkspqpHupbBvYHtssHhKThsCtOVgHiQJBAKPhFYQCgkeyFxRLcpxKeSwUjihUstbrVMWJdwpmsiKCVpYVfCmQsJgXI",
		@"ogqdHMoqPIZeZ": @"HXzyUJTJqaiKeOcWTiFSBGIKvXFaqjFawyrGiqnGxBnPdWGGxbGjEwKDFuSDRgEbkGwIwzBmJffsLqEQMLDTDfAtLBZSJKznrkCUCVbxHNKclMAolDqucCirNaLpySsXaIONrIWBbkRHqgKbcTAKe",
		@"MUzQgHeLzkZnyt": @"YIswGDZieFioMEpOUhMSFRtTZhDgcrGsELXQIyuFOFLMiBwlQdaxXtnwcbqVdxGqgdmfXytaHVtEYCcmOMWPZVGnBTJSRIlaNxQYdmEiJYhZhDoETfFWBNelwTDXyCI",
		@"jFuVUXKQlnwNHNUYN": @"WVyDZuPRpOGocFeDSMSyUbMjwFtPdLjoxmDYUdGzuZGNjhpPWIZsTWInoAdVpfGezJrqxVSuRlROThQoDFBqTYqGTCIrSzbOFMqEdnNeuzIMNNatNmrRLnimYZxOPtSnabCfvhPHFt",
		@"WGVgJhywaz": @"YsgiWUJCVlImkmhcMzjqYjZguIrPskwsMAZaVMiAARbzTdLFkrXbchzMBBbEzXmcnmLGcSjiTTPBpGZjkbUjVWmgytsBJRfTNtpmjWMuIbXdBfAKLjWhDyGklypBZWLXWnpJgmSxRTTqlkvvJj",
		@"qNDcfGJtBX": @"tryAeVxNzofZTdpeIXOIxSPQvKnNiDMNZyIxhdCYfNUIEgpeQzjIypXhKYcquYhbpIBAEjOUUZxlZZsMyRFgENaqZzvPIJfnjUNEJLiFyFhUlYaITMWGXXzPRWp",
		@"VyOftpouvAgGhP": @"FMUoqVuSRootqgEgfvpmnjRvdpGkpyGDwxBWJOoZKgHMXmMGheouEFINnPXhLnchNnqQXUwEHhfgZdTsDAYrInaxzofagELssmAdsEHgQSwdIwqYhrYlBDuo",
		@"yMNrtReLaSseD": @"GZzPDBUFOVNtLMhkvHUjaIClHQIXmtXfzgAwqdLUTMHvwLznjdlBxNugtaCadRQlbYpJYssIRQDULQABMYAhlXMSAoldOSlFRokeZNsXpgrczZpyX",
		@"gYqfPgJgNAuQh": @"waaxRKUMzqzdzFiVSIrRHEjMwNaTGpWrGflYxLveoxoTRyOiGppkQrmmcojqJZDdKnhMbDlOJYYgMKjAurnNKwdOrtKVrWiPtgavEJOULMHOSaCCxzZE",
		@"NgbWqwBDrBESsbfJNc": @"hDYrIkxxiFzxedmwBrNFhzDwicdCxuSZPIQygxSZYVXTDHecODtfDErZYvjWmboZuKiQmARdEFtfWyLRzypqRunzaosxhKaaBgVezDXjrSfYbfMFOsiZBlPoSbZtbEAzjvprnSnVuHmFBIhgHB",
		@"iPGIgNAdqgpPab": @"JgQJVEEgZhVDrwmAhTNpcsOIihSOaqPpQirsgTGltrbZoKTLkixJtbRRiCNGDxeMoHnetmBkUjsfDogbDKmotwMQSIVQTKxonqFaFisyNDGMymPBL",
		@"acHsSPIlWl": @"MFmgxcTkxxlICHAvbXwGLAEAsyHihYAujFGUOkwaBGnqpmkNHhUWvQuRKjjvOrpYLMaFhAWtZzKSvXcAiWndQPwfDjYlnFqBTTkbaSuUjwFEwKImEOC",
	};
	return uoSaKXoIJKcu;
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return AFPercentEscapedQueryStringKeyFromStringWithEncoding([self.field description], stringEncoding);
    } else {
        return [NSString stringWithFormat:@"%@=%@", AFPercentEscapedQueryStringKeyFromStringWithEncoding([self.field description], stringEncoding), AFPercentEscapedQueryStringValueFromStringWithEncoding([self.value description], stringEncoding)];
    }
}

@end

#pragma mark -

extern NSArray * AFQueryStringPairsFromDictionary(NSDictionary *dictionary);
extern NSArray * AFQueryStringPairsFromKeyAndValue(NSString *key, id value);

static NSString * AFQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (AFQueryStringPair *pair in AFQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:stringEncoding]];
    }

    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * AFQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return AFQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * AFQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];

    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = [dictionary objectForKey:nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:AFQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:AFQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:AFQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[AFQueryStringPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}

#pragma mark -

@interface AFStreamingMultipartFormData : NSObject <AFMultipartFormData>
- (instancetype)initWithURLRequest:(NSMutableURLRequest *)urlRequest
                    stringEncoding:(NSStringEncoding)encoding;

- (NSMutableURLRequest *)requestByFinalizingMultipartFormData;
@end

#pragma mark -

static NSArray * AFHTTPRequestSerializerObservedKeyPaths() {
    static NSArray *_AFHTTPRequestSerializerObservedKeyPaths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _AFHTTPRequestSerializerObservedKeyPaths = @[NSStringFromSelector(@selector(allowsCellularAccess)), NSStringFromSelector(@selector(cachePolicy)), NSStringFromSelector(@selector(HTTPShouldHandleCookies)), NSStringFromSelector(@selector(HTTPShouldUsePipelining)), NSStringFromSelector(@selector(networkServiceType)), NSStringFromSelector(@selector(timeoutInterval))];
    });

    return _AFHTTPRequestSerializerObservedKeyPaths;
}

static void *AFHTTPRequestSerializerObserverContext = &AFHTTPRequestSerializerObserverContext;

@interface AFHTTPRequestSerializer ()
@property (readwrite, nonatomic, strong) NSMutableSet *mutableObservedChangedKeyPaths;
@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableHTTPRequestHeaders;
@property (readwrite, nonatomic, assign) AFHTTPRequestQueryStringSerializationStyle queryStringSerializationStyle;
@property (readwrite, nonatomic, copy) AFQueryStringSerializationBlock queryStringSerialization;
@end

@implementation AFHTTPRequestSerializer

+ (instancetype)serializer {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.stringEncoding = NSUTF8StringEncoding;

    self.mutableHTTPRequestHeaders = [NSMutableDictionary dictionary];

    // Accept-Language HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
    NSMutableArray *acceptLanguagesComponents = [NSMutableArray array];
    [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        float q = 1.0f - (idx * 0.1f);
        [acceptLanguagesComponents addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
        *stop = q <= 0.5f;
    }];
    [self setValue:[acceptLanguagesComponents componentsJoinedByString:@", "] forHTTPHeaderField:@"Accept-Language"];

    NSString *userAgent = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
#pragma clang diagnostic pop
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [self setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }

    // HTTP Method Definitions; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html
    self.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];

    self.mutableObservedChangedKeyPaths = [NSMutableSet set];
    for (NSString *keyPath in AFHTTPRequestSerializerObservedKeyPaths()) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:AFHTTPRequestSerializerObserverContext];
    }

    return self;
}

- (void)dealloc {
    for (NSString *keyPath in AFHTTPRequestSerializerObservedKeyPaths()) {
        [self removeObserver:self forKeyPath:keyPath context:AFHTTPRequestSerializerObserverContext];
    }
}

#pragma mark -

- (NSDictionary *)HTTPRequestHeaders {
    return [NSDictionary dictionaryWithDictionary:self.mutableHTTPRequestHeaders];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
	[self.mutableHTTPRequestHeaders setValue:value forKey:field];
}

- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username password:(NSString *)password {
	NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", username, password];
    [self setValue:[NSString stringWithFormat:@"Basic %@", AFBase64EncodedStringFromString(basicAuthCredentials)] forHTTPHeaderField:@"Authorization"];
}

- (void)setAuthorizationHeaderFieldWithToken:(NSString *)token {
    [self setValue:[NSString stringWithFormat:@"Token token=\"%@\"", token] forHTTPHeaderField:@"Authorization"];
}

- (void)clearAuthorizationHeader {
	[self.mutableHTTPRequestHeaders removeObjectForKey:@"Authorization"];
}

#pragma mark -

- (void)setQueryStringSerializationWithStyle:(AFHTTPRequestQueryStringSerializationStyle)style {
    self.queryStringSerializationStyle = style;
    self.queryStringSerialization = nil;
}

- (void)setQueryStringSerializationWithBlock:(NSString *(^)(NSURLRequest *, NSDictionary *, NSError *__autoreleasing *))block {
    self.queryStringSerialization = block;
}

#pragma mark -

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
{
    return [self requestWithMethod:method URLString:URLString parameters:parameters error:nil];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(method);
    NSParameterAssert(URLString);

    NSURL *url = [NSURL URLWithString:URLString];

    NSParameterAssert(url);

    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    mutableRequest.HTTPMethod = method;

    for (NSString *keyPath in AFHTTPRequestSerializerObservedKeyPaths()) {
        if ([self.mutableObservedChangedKeyPaths containsObject:keyPath]) {
            [mutableRequest setValue:[self valueForKeyPath:keyPath] forKey:keyPath];
        }
    }

    mutableRequest = [[self requestBySerializingRequest:mutableRequest withParameters:parameters error:error] mutableCopy];

	return mutableRequest;
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    return [self multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:nil];
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                                  error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(method);
    NSParameterAssert(![method isEqualToString:@"GET"] && ![method isEqualToString:@"HEAD"]);

    NSMutableURLRequest *mutableRequest = [self requestWithMethod:method URLString:URLString parameters:nil error:error];

    __block AFStreamingMultipartFormData *formData = [[AFStreamingMultipartFormData alloc] initWithURLRequest:mutableRequest stringEncoding:NSUTF8StringEncoding];

    if (parameters) {
        for (AFQueryStringPair *pair in AFQueryStringPairsFromDictionary(parameters)) {
            NSData *data = nil;
            if ([pair.value isKindOfClass:[NSData class]]) {
                data = pair.value;
            } else if ([pair.value isEqual:[NSNull null]]) {
                data = [NSData data];
            } else {
                data = [[pair.value description] dataUsingEncoding:self.stringEncoding];
            }

            if (data) {
                [formData appendPartWithFormData:data name:[pair.field description]];
            }
        }
    }

    if (block) {
        block(formData);
    }

    return [formData requestByFinalizingMultipartFormData];
}

- (NSMutableURLRequest *)requestWithMultipartFormRequest:(NSURLRequest *)request
                             writingStreamContentsToFile:(NSURL *)fileURL
                                       completionHandler:(void (^)(NSError *error))handler
{
    if (!request.HTTPBodyStream) {
        return [request mutableCopy];
    }

    NSParameterAssert([fileURL isFileURL]);

    NSInputStream *inputStream = request.HTTPBodyStream;
    NSOutputStream *outputStream = [[NSOutputStream alloc] initWithURL:fileURL append:NO];
    __block NSError *error = nil;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

        [inputStream open];
        [outputStream open];

        while ([inputStream hasBytesAvailable] && [outputStream hasSpaceAvailable]) {
            uint8_t buffer[1024];

            NSInteger bytesRead = [inputStream read:buffer maxLength:1024];
            if (inputStream.streamError || bytesRead < 0) {
                error = inputStream.streamError;
                break;
            }

            NSInteger bytesWritten = [outputStream write:buffer maxLength:(NSUInteger)bytesRead];
            if (outputStream.streamError || bytesWritten < 0) {
                error = outputStream.streamError;
                break;
            }

            if (bytesRead == 0 && bytesWritten == 0) {
                break;
            }
        }

        [outputStream close];
        [inputStream close];

        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(error);
            });
        }
    });

    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    mutableRequest.HTTPBodyStream = nil;

    return mutableRequest;
}

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);

    NSMutableURLRequest *mutableRequest = [request mutableCopy];

    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];

    if (parameters) {
        NSString *query = nil;
        if (self.queryStringSerialization) {
            query = self.queryStringSerialization(request, parameters, error);
        } else {
            switch (self.queryStringSerializationStyle) {
                case AFHTTPRequestQueryStringDefaultStyle:
                    query = AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding);
                    break;
            }
        }

        if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
            mutableRequest.URL = [NSURL URLWithString:[[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@", query]];
        } else {
            if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
                [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            }
            [mutableRequest setHTTPBody:[query dataUsingEncoding:self.stringEncoding]];
        }
    }

    return mutableRequest;
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(__unused id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == AFHTTPRequestSerializerObserverContext) {
        if ([change[NSKeyValueChangeNewKey] isEqual:[NSNull null]]) {
            [self.mutableObservedChangedKeyPaths removeObject:keyPath];
        } else {
            [self.mutableObservedChangedKeyPaths addObject:keyPath];
        }
    }
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

    self.mutableHTTPRequestHeaders = [[decoder decodeObjectOfClass:[NSDictionary class] forKey:NSStringFromSelector(@selector(mutableHTTPRequestHeaders))] mutableCopy];
    self.queryStringSerializationStyle = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(queryStringSerializationStyle))] unsignedIntegerValue];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.mutableHTTPRequestHeaders forKey:NSStringFromSelector(@selector(mutableHTTPRequestHeaders))];
    [coder encodeInteger:self.queryStringSerializationStyle forKey:NSStringFromSelector(@selector(queryStringSerializationStyle))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFHTTPRequestSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.mutableHTTPRequestHeaders = [self.mutableHTTPRequestHeaders mutableCopyWithZone:zone];
    serializer.queryStringSerializationStyle = self.queryStringSerializationStyle;
    serializer.queryStringSerialization = self.queryStringSerialization;
    
    return serializer;
}

@end

#pragma mark -

static NSString * AFCreateMultipartFormBoundary() {
    return [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
}

static NSString * const kAFMultipartFormCRLF = @"\r\n";

static inline NSString * AFMultipartFormInitialBoundary(NSString *boundary) {
    return [NSString stringWithFormat:@"--%@%@", boundary, kAFMultipartFormCRLF];
}

static inline NSString * AFMultipartFormEncapsulationBoundary(NSString *boundary) {
    return [NSString stringWithFormat:@"%@--%@%@", kAFMultipartFormCRLF, boundary, kAFMultipartFormCRLF];
}

static inline NSString * AFMultipartFormFinalBoundary(NSString *boundary) {
    return [NSString stringWithFormat:@"%@--%@--%@", kAFMultipartFormCRLF, boundary, kAFMultipartFormCRLF];
}

static inline NSString * AFContentTypeForPathExtension(NSString *extension) {
#ifdef __UTTYPE__
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
#else
#pragma unused (extension)
    return @"application/octet-stream";
#endif
}

NSUInteger const kAFUploadStream3GSuggestedPacketSize = 1024 * 16;
NSTimeInterval const kAFUploadStream3GSuggestedDelay = 0.2;

@interface AFHTTPBodyPart : NSObject
@property (nonatomic, assign) NSStringEncoding stringEncoding;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, copy) NSString *boundary;
@property (nonatomic, strong) id body;
@property (nonatomic, assign) unsigned long long bodyContentLength;
@property (nonatomic, strong) NSInputStream *inputStream;

@property (nonatomic, assign) BOOL hasInitialBoundary;
@property (nonatomic, assign) BOOL hasFinalBoundary;

@property (readonly, nonatomic, assign, getter = hasBytesAvailable) BOOL bytesAvailable;
@property (readonly, nonatomic, assign) unsigned long long contentLength;

- (NSInteger)read:(uint8_t *)buffer
        maxLength:(NSUInteger)length;
@end

@interface AFMultipartBodyStream : NSInputStream <NSStreamDelegate>
@property (nonatomic, assign) NSUInteger numberOfBytesInPacket;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, strong) NSInputStream *inputStream;
@property (readonly, nonatomic, assign) unsigned long long contentLength;
@property (readonly, nonatomic, assign, getter = isEmpty) BOOL empty;

- (id)initWithStringEncoding:(NSStringEncoding)encoding;
- (void)setInitialAndFinalBoundaries;
- (void)appendHTTPBodyPart:(AFHTTPBodyPart *)bodyPart;
@end

#pragma mark -

@interface AFStreamingMultipartFormData ()
@property (readwrite, nonatomic, copy) NSMutableURLRequest *request;
@property (readwrite, nonatomic, assign) NSStringEncoding stringEncoding;
@property (readwrite, nonatomic, copy) NSString *boundary;
@property (readwrite, nonatomic, strong) AFMultipartBodyStream *bodyStream;
@end

@implementation AFStreamingMultipartFormData

- (id)initWithURLRequest:(NSMutableURLRequest *)urlRequest
          stringEncoding:(NSStringEncoding)encoding
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.request = urlRequest;
    self.stringEncoding = encoding;
    self.boundary = AFCreateMultipartFormBoundary();
    self.bodyStream = [[AFMultipartBodyStream alloc] initWithStringEncoding:encoding];

    return self;
}

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(fileURL);
    NSParameterAssert(name);

    NSString *fileName = [fileURL lastPathComponent];
    NSString *mimeType = AFContentTypeForPathExtension([fileURL pathExtension]);

    return [self appendPartWithFileURL:fileURL name:name fileName:fileName mimeType:mimeType error:error];
}

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                        error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(fileURL);
    NSParameterAssert(name);
    NSParameterAssert(fileName);
    NSParameterAssert(mimeType);

    if (![fileURL isFileURL]) {
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"Expected URL to be a file URL", @"AFNetworking", nil)};
        if (error) {
            *error = [[NSError alloc] initWithDomain:AFURLRequestSerializationErrorDomain code:NSURLErrorBadURL userInfo:userInfo];
        }

        return NO;
    } else if ([fileURL checkResourceIsReachableAndReturnError:error] == NO) {
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"File URL not reachable.", @"AFNetworking", nil)};
        if (error) {
            *error = [[NSError alloc] initWithDomain:AFURLRequestSerializationErrorDomain code:NSURLErrorBadURL userInfo:userInfo];
        }

        return NO;
    }

    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[fileURL path] error:error];
    if (!fileAttributes) {
        return NO;
    }
    
    NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
    [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"", name, fileName] forKey:@"Content-Disposition"];
    [mutableHeaders setValue:mimeType forKey:@"Content-Type"];
    
    AFHTTPBodyPart *bodyPart = [[AFHTTPBodyPart alloc] init];
    bodyPart.stringEncoding = self.stringEncoding;
    bodyPart.headers = mutableHeaders;
    bodyPart.boundary = self.boundary;
    bodyPart.body = fileURL;
    bodyPart.bodyContentLength = [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
    [self.bodyStream appendHTTPBodyPart:bodyPart];

    return YES;
}

- (void)appendPartWithInputStream:(NSInputStream *)inputStream
                             name:(NSString *)name
                         fileName:(NSString *)fileName
                           length:(int64_t)length
                         mimeType:(NSString *)mimeType
{
    NSParameterAssert(name);
    NSParameterAssert(fileName);
    NSParameterAssert(mimeType);

    NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
    [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"", name, fileName] forKey:@"Content-Disposition"];
    [mutableHeaders setValue:mimeType forKey:@"Content-Type"];


    AFHTTPBodyPart *bodyPart = [[AFHTTPBodyPart alloc] init];
    bodyPart.stringEncoding = self.stringEncoding;
    bodyPart.headers = mutableHeaders;
    bodyPart.boundary = self.boundary;
    bodyPart.body = inputStream;

    bodyPart.bodyContentLength = (unsigned long long)length;

    [self.bodyStream appendHTTPBodyPart:bodyPart];
}

- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType
{
    NSParameterAssert(name);
    NSParameterAssert(fileName);
    NSParameterAssert(mimeType);

    NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
    [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"", name, fileName] forKey:@"Content-Disposition"];
    [mutableHeaders setValue:mimeType forKey:@"Content-Type"];

    [self appendPartWithHeaders:mutableHeaders body:data];
}

- (void)appendPartWithFormData:(NSData *)data
                          name:(NSString *)name
{
    NSParameterAssert(name);

    NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
    [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"", name] forKey:@"Content-Disposition"];

    [self appendPartWithHeaders:mutableHeaders body:data];
}

- (void)appendPartWithHeaders:(NSDictionary *)headers
                         body:(NSData *)body
{
    NSParameterAssert(body);

    AFHTTPBodyPart *bodyPart = [[AFHTTPBodyPart alloc] init];
    bodyPart.stringEncoding = self.stringEncoding;
    bodyPart.headers = headers;
    bodyPart.boundary = self.boundary;
    bodyPart.bodyContentLength = [body length];
    bodyPart.body = body;

    [self.bodyStream appendHTTPBodyPart:bodyPart];
}

- (void)throttleBandwidthWithPacketSize:(NSUInteger)numberOfBytes
                                  delay:(NSTimeInterval)delay
{
    self.bodyStream.numberOfBytesInPacket = numberOfBytes;
    self.bodyStream.delay = delay;
}

- (NSMutableURLRequest *)requestByFinalizingMultipartFormData {
    if ([self.bodyStream isEmpty]) {
        return self.request;
    }

    // Reset the initial and final boundaries to ensure correct Content-Length
    [self.bodyStream setInitialAndFinalBoundaries];
    [self.request setHTTPBodyStream:self.bodyStream];

    [self.request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary] forHTTPHeaderField:@"Content-Type"];
    [self.request setValue:[NSString stringWithFormat:@"%llu", [self.bodyStream contentLength]] forHTTPHeaderField:@"Content-Length"];

    return self.request;
}

@end

#pragma mark -

@interface NSStream ()
@property (readwrite) NSStreamStatus streamStatus;
@property (readwrite, copy) NSError *streamError;
@end

@interface AFMultipartBodyStream () <NSCopying>
@property (readwrite, nonatomic, assign) NSStringEncoding stringEncoding;
@property (readwrite, nonatomic, strong) NSMutableArray *HTTPBodyParts;
@property (readwrite, nonatomic, strong) NSEnumerator *HTTPBodyPartEnumerator;
@property (readwrite, nonatomic, strong) AFHTTPBodyPart *currentHTTPBodyPart;
@property (readwrite, nonatomic, strong) NSOutputStream *outputStream;
@property (readwrite, nonatomic, strong) NSMutableData *buffer;
@end

@implementation AFMultipartBodyStream
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-atomic-properties"
@synthesize streamStatus;
@synthesize streamError;
#pragma clang diagnostic pop

- (id)initWithStringEncoding:(NSStringEncoding)encoding {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.stringEncoding = encoding;
    self.HTTPBodyParts = [NSMutableArray array];
    self.numberOfBytesInPacket = NSIntegerMax;

    return self;
}

- (void)setInitialAndFinalBoundaries {
    if ([self.HTTPBodyParts count] > 0) {
        for (AFHTTPBodyPart *bodyPart in self.HTTPBodyParts) {
            bodyPart.hasInitialBoundary = NO;
            bodyPart.hasFinalBoundary = NO;
        }

        [[self.HTTPBodyParts objectAtIndex:0] setHasInitialBoundary:YES];
        [[self.HTTPBodyParts lastObject] setHasFinalBoundary:YES];
    }
}

- (void)appendHTTPBodyPart:(AFHTTPBodyPart *)bodyPart {
    [self.HTTPBodyParts addObject:bodyPart];
}

- (BOOL)isEmpty {
    return [self.HTTPBodyParts count] == 0;
}

#pragma mark - NSInputStream

- (NSInteger)read:(uint8_t *)buffer
        maxLength:(NSUInteger)length
{
    if ([self streamStatus] == NSStreamStatusClosed) {
        return 0;
    }

    NSInteger totalNumberOfBytesRead = 0;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    while ((NSUInteger)totalNumberOfBytesRead < MIN(length, self.numberOfBytesInPacket)) {
        if (!self.currentHTTPBodyPart || ![self.currentHTTPBodyPart hasBytesAvailable]) {
            if (!(self.currentHTTPBodyPart = [self.HTTPBodyPartEnumerator nextObject])) {
                break;
            }
        } else {
            NSUInteger maxLength = length - (NSUInteger)totalNumberOfBytesRead;
            NSInteger numberOfBytesRead = [self.currentHTTPBodyPart read:&buffer[totalNumberOfBytesRead] maxLength:maxLength];
            if (numberOfBytesRead == -1) {
                self.streamError = self.currentHTTPBodyPart.inputStream.streamError;
                break;
            } else {
                totalNumberOfBytesRead += numberOfBytesRead;

                if (self.delay > 0.0f) {
                    [NSThread sleepForTimeInterval:self.delay];
                }
            }
        }
    }
#pragma clang diagnostic pop

    return totalNumberOfBytesRead;
}

- (BOOL)getBuffer:(__unused uint8_t **)buffer
           length:(__unused NSUInteger *)len
{
    return NO;
}

- (BOOL)hasBytesAvailable {
    return [self streamStatus] == NSStreamStatusOpen;
}

#pragma mark - NSStream

- (void)open {
    if (self.streamStatus == NSStreamStatusOpen) {
        return;
    }

    self.streamStatus = NSStreamStatusOpen;

    [self setInitialAndFinalBoundaries];
    self.HTTPBodyPartEnumerator = [self.HTTPBodyParts objectEnumerator];
}

- (void)close {
    self.streamStatus = NSStreamStatusClosed;
}

- (id)propertyForKey:(__unused NSString *)key {
    return nil;
}

- (BOOL)setProperty:(__unused id)property
             forKey:(__unused NSString *)key
{
    return NO;
}

- (void)scheduleInRunLoop:(__unused NSRunLoop *)aRunLoop
                  forMode:(__unused NSString *)mode
{}

- (void)removeFromRunLoop:(__unused NSRunLoop *)aRunLoop
                  forMode:(__unused NSString *)mode
{}

- (unsigned long long)contentLength {
    unsigned long long length = 0;
    for (AFHTTPBodyPart *bodyPart in self.HTTPBodyParts) {
        length += [bodyPart contentLength];
    }

    return length;
}

#pragma mark - Undocumented CFReadStream Bridged Methods

- (void)_scheduleInCFRunLoop:(__unused CFRunLoopRef)aRunLoop
                     forMode:(__unused CFStringRef)aMode
{}

- (void)_unscheduleFromCFRunLoop:(__unused CFRunLoopRef)aRunLoop
                         forMode:(__unused CFStringRef)aMode
{}

- (BOOL)_setCFClientFlags:(__unused CFOptionFlags)inFlags
                 callback:(__unused CFReadStreamClientCallBack)inCallback
                  context:(__unused CFStreamClientContext *)inContext {
    return NO;
}

#pragma mark - NSCopying

-(id)copyWithZone:(NSZone *)zone {
    AFMultipartBodyStream *bodyStreamCopy = [[[self class] allocWithZone:zone] initWithStringEncoding:self.stringEncoding];

    for (AFHTTPBodyPart *bodyPart in self.HTTPBodyParts) {
        [bodyStreamCopy appendHTTPBodyPart:[bodyPart copy]];
    }

    [bodyStreamCopy setInitialAndFinalBoundaries];

    return bodyStreamCopy;
}

@end

#pragma mark -

typedef enum {
    AFEncapsulationBoundaryPhase = 1,
    AFHeaderPhase                = 2,
    AFBodyPhase                  = 3,
    AFFinalBoundaryPhase         = 4,
} AFHTTPBodyPartReadPhase;

@interface AFHTTPBodyPart () <NSCopying> {
    AFHTTPBodyPartReadPhase _phase;
    NSInputStream *_inputStream;
    unsigned long long _phaseReadOffset;
}

- (BOOL)transitionToNextPhase;
- (NSInteger)readData:(NSData *)data
           intoBuffer:(uint8_t *)buffer
            maxLength:(NSUInteger)length;
@end

@implementation AFHTTPBodyPart

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    [self transitionToNextPhase];

    return self;
}

- (void)dealloc {
    if (_inputStream) {
        [_inputStream close];
        _inputStream = nil;
    }
}

- (NSInputStream *)inputStream {
    if (!_inputStream) {
        if ([self.body isKindOfClass:[NSData class]]) {
            _inputStream = [NSInputStream inputStreamWithData:self.body];
        } else if ([self.body isKindOfClass:[NSURL class]]) {
            _inputStream = [NSInputStream inputStreamWithURL:self.body];
        } else if ([self.body isKindOfClass:[NSInputStream class]]) {
            _inputStream = self.body;
        }
    }

    return _inputStream;
}

- (NSString *)stringForHeaders {
    NSMutableString *headerString = [NSMutableString string];
    for (NSString *field in [self.headers allKeys]) {
        [headerString appendString:[NSString stringWithFormat:@"%@: %@%@", field, [self.headers valueForKey:field], kAFMultipartFormCRLF]];
    }
    [headerString appendString:kAFMultipartFormCRLF];

    return [NSString stringWithString:headerString];
}

- (unsigned long long)contentLength {
    unsigned long long length = 0;

    NSData *encapsulationBoundaryData = [([self hasInitialBoundary] ? AFMultipartFormInitialBoundary(self.boundary) : AFMultipartFormEncapsulationBoundary(self.boundary)) dataUsingEncoding:self.stringEncoding];
    length += [encapsulationBoundaryData length];

    NSData *headersData = [[self stringForHeaders] dataUsingEncoding:self.stringEncoding];
    length += [headersData length];

    length += _bodyContentLength;

    NSData *closingBoundaryData = ([self hasFinalBoundary] ? [AFMultipartFormFinalBoundary(self.boundary) dataUsingEncoding:self.stringEncoding] : [NSData data]);
    length += [closingBoundaryData length];

    return length;
}

- (BOOL)hasBytesAvailable {
    // Allows `read:maxLength:` to be called again if `AFMultipartFormFinalBoundary` doesn't fit into the available buffer
    if (_phase == AFFinalBoundaryPhase) {
        return YES;
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcovered-switch-default"
    switch (self.inputStream.streamStatus) {
        case NSStreamStatusNotOpen:
        case NSStreamStatusOpening:
        case NSStreamStatusOpen:
        case NSStreamStatusReading:
        case NSStreamStatusWriting:
            return YES;
        case NSStreamStatusAtEnd:
        case NSStreamStatusClosed:
        case NSStreamStatusError:
        default:
            return NO;
    }
#pragma clang diagnostic pop
}

- (NSInteger)read:(uint8_t *)buffer
        maxLength:(NSUInteger)length
{
    NSInteger totalNumberOfBytesRead = 0;

    if (_phase == AFEncapsulationBoundaryPhase) {
        NSData *encapsulationBoundaryData = [([self hasInitialBoundary] ? AFMultipartFormInitialBoundary(self.boundary) : AFMultipartFormEncapsulationBoundary(self.boundary)) dataUsingEncoding:self.stringEncoding];
        totalNumberOfBytesRead += [self readData:encapsulationBoundaryData intoBuffer:&buffer[totalNumberOfBytesRead] maxLength:(length - (NSUInteger)totalNumberOfBytesRead)];
    }

    if (_phase == AFHeaderPhase) {
        NSData *headersData = [[self stringForHeaders] dataUsingEncoding:self.stringEncoding];
        totalNumberOfBytesRead += [self readData:headersData intoBuffer:&buffer[totalNumberOfBytesRead] maxLength:(length - (NSUInteger)totalNumberOfBytesRead)];
    }

    if (_phase == AFBodyPhase) {
        NSInteger numberOfBytesRead = 0;

        numberOfBytesRead = [self.inputStream read:&buffer[totalNumberOfBytesRead] maxLength:(length - (NSUInteger)totalNumberOfBytesRead)];
        if (numberOfBytesRead == -1) {
            return -1;
        } else {
            totalNumberOfBytesRead += numberOfBytesRead;

            if ([self.inputStream streamStatus] >= NSStreamStatusAtEnd) {
                [self transitionToNextPhase];
            }
        }
    }

    if (_phase == AFFinalBoundaryPhase) {
        NSData *closingBoundaryData = ([self hasFinalBoundary] ? [AFMultipartFormFinalBoundary(self.boundary) dataUsingEncoding:self.stringEncoding] : [NSData data]);
        totalNumberOfBytesRead += [self readData:closingBoundaryData intoBuffer:&buffer[totalNumberOfBytesRead] maxLength:(length - (NSUInteger)totalNumberOfBytesRead)];
    }

    return totalNumberOfBytesRead;
}

- (NSInteger)readData:(NSData *)data
           intoBuffer:(uint8_t *)buffer
            maxLength:(NSUInteger)length
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    NSRange range = NSMakeRange((NSUInteger)_phaseReadOffset, MIN([data length] - ((NSUInteger)_phaseReadOffset), length));
    [data getBytes:buffer range:range];
#pragma clang diagnostic pop

    _phaseReadOffset += range.length;

    if (((NSUInteger)_phaseReadOffset) >= [data length]) {
        [self transitionToNextPhase];
    }

    return (NSInteger)range.length;
}

- (BOOL)transitionToNextPhase {
    if (![[NSThread currentThread] isMainThread]) {
        [self performSelectorOnMainThread:@selector(transitionToNextPhase) withObject:nil waitUntilDone:YES];
        return YES;
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcovered-switch-default"
    switch (_phase) {
        case AFEncapsulationBoundaryPhase:
            _phase = AFHeaderPhase;
            break;
        case AFHeaderPhase:
            [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [self.inputStream open];
            _phase = AFBodyPhase;
            break;
        case AFBodyPhase:
            [self.inputStream close];
            _phase = AFFinalBoundaryPhase;
            break;
        case AFFinalBoundaryPhase:
        default:
            _phase = AFEncapsulationBoundaryPhase;
            break;
    }
    _phaseReadOffset = 0;
#pragma clang diagnostic pop

    return YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFHTTPBodyPart *bodyPart = [[[self class] allocWithZone:zone] init];
    
    bodyPart.stringEncoding = self.stringEncoding;
    bodyPart.headers = self.headers;
    bodyPart.bodyContentLength = self.bodyContentLength;
    bodyPart.body = self.body;
    bodyPart.boundary = self.boundary;
    
    return bodyPart;
}

@end

#pragma mark -

@implementation AFJSONRequestSerializer

+ (instancetype)serializer {
    return [self serializerWithWritingOptions:0];
}

+ (instancetype)serializerWithWritingOptions:(NSJSONWritingOptions)writingOptions
{
    AFJSONRequestSerializer *serializer = [[self alloc] init];
    serializer.writingOptions = writingOptions;

    return serializer;
}

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);

    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }

    NSMutableURLRequest *mutableRequest = [request mutableCopy];

    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (parameters) {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            [mutableRequest setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        }

        [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:self.writingOptions error:error]];
    }

    return mutableRequest;
}

#pragma mark - NSecureCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }

    self.writingOptions = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(writingOptions))] unsignedIntegerValue];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

    [coder encodeInteger:self.writingOptions forKey:NSStringFromSelector(@selector(writingOptions))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFJSONRequestSerializer *serializer = [super copyWithZone:zone];
    serializer.writingOptions = self.writingOptions;

    return serializer;
}

@end

#pragma mark -

@implementation AFPropertyListRequestSerializer

+ (instancetype)serializer {
    return [self serializerWithFormat:NSPropertyListXMLFormat_v1_0 writeOptions:0];
}

+ (instancetype)serializerWithFormat:(NSPropertyListFormat)format
                        writeOptions:(NSPropertyListWriteOptions)writeOptions
{
    AFPropertyListRequestSerializer *serializer = [[self alloc] init];
    serializer.format = format;
    serializer.writeOptions = writeOptions;

    return serializer;
}

#pragma mark - AFURLRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);

    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }

    NSMutableURLRequest *mutableRequest = [request mutableCopy];

    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];

    if (parameters) {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            [mutableRequest setValue:[NSString stringWithFormat:@"application/x-plist; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        }

        [mutableRequest setHTTPBody:[NSPropertyListSerialization dataWithPropertyList:parameters format:self.format options:self.writeOptions error:error]];
    }

    return mutableRequest;
}

#pragma mark - NSecureCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }

    self.format = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(format))] unsignedIntegerValue];
    self.writeOptions = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(writeOptions))] unsignedIntegerValue];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

    [coder encodeInteger:self.format forKey:NSStringFromSelector(@selector(format))];
    [coder encodeObject:@(self.writeOptions) forKey:NSStringFromSelector(@selector(writeOptions))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFPropertyListRequestSerializer *serializer = [super copyWithZone:zone];
    serializer.format = self.format;
    serializer.writeOptions = self.writeOptions;

    return serializer;
}

@end
