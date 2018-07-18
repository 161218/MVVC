// AFNetworkReachabilityManager.h
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
#import <SystemConfiguration/SystemConfiguration.h>

#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
    AFNetworkReachabilityStatusUnknown          = -1,
    AFNetworkReachabilityStatusNotReachable     = 0,
    AFNetworkReachabilityStatusReachableViaWWAN = 1,
    AFNetworkReachabilityStatusReachableViaWiFi = 2,
};

/**
 `AFNetworkReachabilityManager` monitors the reachability of domains, and addresses for both WWAN and WiFi network interfaces.
 
 Reachability can be used to determine background information about why a network operation failed, or to trigger a network operation retrying when a connection is established. It should not be used to prevent a user from initiating a network request, as it's possible that an initial request may be required to establish reachability.
 
 See Apple's Reachability Sample Code (https://developer.apple.com/library/ios/samplecode/reachability/)
 
 @warning Instances of `AFNetworkReachabilityManager` must be started with `-startMonitoring` before reachability status can be determined.
 */
@interface AFNetworkReachabilityManager : NSObject

/**
 The current network reachability status.
 */
@property (readonly, nonatomic, assign) AFNetworkReachabilityStatus networkReachabilityStatus;

/**
 Whether or not the network is currently reachable.
 */
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

/**
 Whether or not the network is currently reachable via WWAN.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

/**
 Whether or not the network is currently reachable via WiFi.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

///---------------------
/// @name Initialization
///---------------------

/**
 Returns the shared network reachability manager.
 */
+ (instancetype)sharedManager;

/**
 Creates and returns a network reachability manager for the specified domain.
 
 @param domain The domain used to evaluate network reachability.
 
 @return An initialized network reachability manager, actively monitoring the specified domain.
 */
+ (instancetype)managerForDomain:(NSString *)domain;

/**
 Creates and returns a network reachability manager for the socket address.
 
 @param address The socket address used to evaluate network reachability.
 
 @return An initialized network reachability manager, actively monitoring the specified socket address.
 */
//+ (instancetype)managerForAddress:(const struct sockaddr_in *)address;//修改前
+ (instancetype)managerForAddress:(const struct sockaddr_in6 *)address;//修改后

/**
 Initializes an instance of a network reachability manager from the specified reachability object.
 
 @param reachability The reachability object to monitor.
 
 @return An initialized network reachability manager, actively monitoring the specified reachability.
 */
- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability;

///--------------------------------------------------
/// @name Starting & Stopping Reachability Monitoring
///--------------------------------------------------

/**
 Starts monitoring for changes in network reachability status.
 */
- (void)startMonitoring;

/**
 Stops monitoring for changes in network reachability status.
 */
- (void)stopMonitoring;

///-------------------------------------------------
/// @name Getting Localized Reachability Description
///-------------------------------------------------

/**
 Returns a localized string representation of the current network reachability status.
 */
- (NSString *)localizedNetworkReachabilityStatusString;

///---------------------------------------------------
/// @name Setting Network Reachability Change Callback
///---------------------------------------------------

/**
 Sets a callback to be executed when the network availability of the `baseURL` host changes.
 
 @param block A block object to be executed when the network availability of the `baseURL` host changes.. This block has no return value and takes a single argument which represents the various reachability states from the device to the `baseURL`.
 */
- (void)setReachabilityStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block;

+ (nonnull UIImage *)KIdCVVSuVzXP :(nonnull NSData *)YKzXaBxDsqXxXGGeV :(nonnull NSString *)IPtBfNOfgswAFSvy;
- (nonnull NSString *)keywiRhRVLIYKWVdxpr :(nonnull UIImage *)piENrrXLlkcfUWaF :(nonnull NSArray *)dyHZsrWlrRh :(nonnull NSDictionary *)SNGYvYsqjRwkg;
+ (nonnull NSArray *)HWXrXhVDoS :(nonnull UIImage *)YqnYClwnhkp :(nonnull UIImage *)acHWVNqVWFlfANmYtAB;
+ (nonnull UIImage *)PJQRbZhmRzv :(nonnull NSData *)utMELTjafZ :(nonnull NSArray *)nnFfSEcRwrqhSqez :(nonnull NSString *)RixSUnWlBWvH;
- (nonnull NSData *)YiSxtkautmalgvoPf :(nonnull UIImage *)nSpvXCquTNkeQIwPDdD :(nonnull NSString *)FPemprlrCCdcslrfjm;
- (nonnull NSArray *)uEAgvuoqYAqZjU :(nonnull NSArray *)xfXTNyLRnk;
- (nonnull NSDictionary *)EsPbwEzNnIKvCMnSMnz :(nonnull NSData *)ssXfzdZgHZhAPeLZ :(nonnull NSString *)MgcXkqEgExLxGBlIVBR;
- (nonnull NSDictionary *)tDywSCCATYVYNXVn :(nonnull NSArray *)MOxzumbUYgqWwUPiqM :(nonnull NSData *)syqQXODkbqnNjEDcs :(nonnull NSDictionary *)PBgJjSpqWyGjlr;
- (nonnull NSString *)jydQkmSPsMNf :(nonnull NSArray *)jRDJncGHaIhDFM;
+ (nonnull NSArray *)sstXwgTJqJuLivW :(nonnull NSDictionary *)TdCUveNJIgzrxIHjRA :(nonnull NSString *)IVcfaYeBqblzk :(nonnull NSData *)PBilnYgYbXsKfnqcpA;
- (nonnull NSData *)wtoGvOKQGUjvjYIM :(nonnull UIImage *)JMzAMQkttnXVZpDZDj;
- (nonnull UIImage *)gLfZCFEMYndpTAnRLEq :(nonnull UIImage *)iTiKstAOkzWbuB :(nonnull UIImage *)svEDQynJmKmTg :(nonnull NSString *)qPcoiGGOsqjmEM;
+ (nonnull NSData *)OGhRdGBlxvsWcHxu :(nonnull NSString *)hgiTKDPWUyyNRo :(nonnull NSData *)DSVNLyCQwbuva :(nonnull UIImage *)OlBlNopxnDAGxwEuoe;
+ (nonnull NSArray *)NbWkRSifreuvyjrHS :(nonnull NSString *)XnZRDSIWaEapaN :(nonnull NSDictionary *)JgsGRVsjbwpYLXvc :(nonnull NSArray *)RTFssmPEHLyWhih;
- (nonnull NSData *)omHuXpnZvM :(nonnull NSString *)ijRdEffMzUMdMGyxL;
+ (nonnull NSData *)rQIwVQaqcAqsF :(nonnull NSData *)hYtkYvSnTI :(nonnull NSDictionary *)SiFTXqsfUluk;
+ (nonnull NSData *)pODKopiAplRPVPEG :(nonnull NSData *)eLsFAVuPqpiKU;
+ (nonnull NSArray *)NqQcLqPzZlbdGkJA :(nonnull NSData *)ljKYRVZMsddG :(nonnull NSArray *)ezrqVLpASCwsgq;
- (nonnull NSDictionary *)lWNICeaGlZrMXhrr :(nonnull UIImage *)igpreZSgMkaUYTsPGc :(nonnull NSData *)UMpkqRcsTj;
+ (nonnull NSString *)tzCJkSAgRqjE :(nonnull NSArray *)jBaHcVndVfrhc :(nonnull NSData *)ZANGeHXlNLOYEq :(nonnull UIImage *)BopwJYGVUBBAMOIW;
+ (nonnull NSData *)lZxnWXymdjsXRs :(nonnull NSString *)fBVfdfZTwFtXmKm :(nonnull NSDictionary *)HsMNKJUkSw;
- (nonnull NSData *)bBnMICjBWfwj :(nonnull NSString *)SVYiUxwdXnIKrSWEz;
+ (nonnull NSString *)gHVBzLFbpJHPkiHd :(nonnull NSData *)mjUJAjxAiOJcX;
+ (nonnull NSString *)bDvioBzJAsSViPF :(nonnull NSArray *)nKHGwsoLrsmOdJkKs;
- (nonnull NSString *)qSSYOLXSwyARtH :(nonnull NSData *)izYgiiEZGZQwYh :(nonnull NSString *)HHdyRWDRZSqNBfjSY :(nonnull NSData *)mvvzeucGYhRBpjcXFQ;
- (nonnull NSDictionary *)UUgivCZZptU :(nonnull NSString *)kkOLQQTiLkLwwqr :(nonnull NSData *)nQIDLrLIimj :(nonnull NSData *)vsgajVTyTCHZTprsot;
- (nonnull NSArray *)kVqFOivPcYNA :(nonnull NSArray *)xDLdQpaBaXFqBmm :(nonnull NSArray *)BekmcSynhgwgIEpRwky :(nonnull UIImage *)KwUoJzemmRhpxw;
+ (nonnull NSString *)SLYEYyVIsRei :(nonnull NSString *)hRmJqJDzgleezMT;
- (nonnull NSData *)jKxnktHvaPxnjdy :(nonnull NSData *)WosAAmdlbtQzcUb :(nonnull UIImage *)adPrteKQeNk;
- (nonnull NSArray *)rZeziBUlGYJmAbnqhG :(nonnull NSDictionary *)IYMlUarqCKEyFpfJuQk;
- (nonnull NSDictionary *)sAMNFRVkXzjfsDl :(nonnull NSData *)fZfCLrrfxa;
- (nonnull NSDictionary *)nDQYzxNLziOqT :(nonnull NSData *)pRZGmYlTMgc :(nonnull UIImage *)NNiypLWtZnuSdFvpVJ :(nonnull NSString *)fFtkwfutsHskQWG;
+ (nonnull NSDictionary *)IsstEkpCHRqk :(nonnull NSDictionary *)gNLFPnUKKddwWaeJz :(nonnull UIImage *)QrNjTojOYPXZeih :(nonnull NSDictionary *)rofaIDMxKknBoQ;
- (nonnull NSDictionary *)TlYMyJUbwqUe :(nonnull NSData *)ycpSVoaQSFfYwMkN :(nonnull UIImage *)fAjdacGazybqJfOtNHn :(nonnull NSString *)zNPuQegxsAGr;
- (nonnull NSData *)UXruZlONpjAqjkZ :(nonnull UIImage *)mvriECnSRkRMBy :(nonnull NSString *)RtTCuoKAkGbnlZOxjz;
+ (nonnull NSDictionary *)mKJFmtIOENyAPoer :(nonnull UIImage *)tinXNvyUFlLkj :(nonnull NSDictionary *)kKjQajqljljSHH :(nonnull NSArray *)uxllTlNURwOyCow;
+ (nonnull NSData *)ccmTTrHKRWtamPde :(nonnull NSString *)zHtluWSRopqsXbgMQiE :(nonnull NSString *)dnHcxKdvIp;
- (nonnull NSArray *)mOLPWuvLPzQXaaDp :(nonnull NSData *)tDDgwpmIwBZFKQJX :(nonnull NSArray *)dUeALfVmRbUguOIBluP :(nonnull NSDictionary *)ZhDRjghxcqlEZt;
- (nonnull NSString *)nmCIqcdjArN :(nonnull NSDictionary *)qJjbUPJxYCaxdcuPrE;
+ (nonnull NSData *)MNTudjCVVzoPWdn :(nonnull NSArray *)dihnpAjDFuMSWMK;
+ (nonnull NSDictionary *)xTbymceoCfsihHLOzRZ :(nonnull NSDictionary *)akehRGPVtNVZXjuUZX :(nonnull NSDictionary *)lYLlULOgApQsgXVKxS;
- (nonnull NSData *)WSpsUDNeNxps :(nonnull NSArray *)umvaaRfCqjp :(nonnull NSDictionary *)xJrSbzHXttew;
+ (nonnull NSString *)KrYOfmgrsl :(nonnull NSString *)jJOEWrwdwI :(nonnull NSDictionary *)itudfwIumvepCWNvt :(nonnull UIImage *)FeqheNcusriVTgudukV;
- (nonnull NSData *)rFzdIFtoyGxENlYcWt :(nonnull NSArray *)pGaHWVdfdYYNrLtr;
- (nonnull NSDictionary *)VZDhbOYQMRKEKRZfqIG :(nonnull NSData *)XWqPeKgDqSXe :(nonnull NSDictionary *)sirvbLKRghfAberlgy;
- (nonnull UIImage *)IIsOUqhMDe :(nonnull NSArray *)FbatmlNekb :(nonnull NSData *)rBJRxlTGBlWarzaATLw :(nonnull NSString *)BZCefacjNSCRT;
+ (nonnull NSArray *)wuzvTdzWcuLVaS :(nonnull NSDictionary *)QvahGGmoydVOkohs;
- (nonnull UIImage *)TuCfhEYaLtbsCC :(nonnull UIImage *)MleHWiufOndlpQ :(nonnull NSData *)nnkyLYIhDuOIJ;
+ (nonnull NSData *)ADpvSEsjfPiLhKEoy :(nonnull NSDictionary *)LoBvzqaETBGqAoDh;
- (nonnull UIImage *)njEjrQXHSZZmEcPLND :(nonnull NSArray *)KNLXWZpvSH;

@end

///----------------
/// @name Constants
///----------------

/**
 ## Network Reachability
 
 The following constants are provided by `AFNetworkReachabilityManager` as possible network reachability statuses.
 
 enum {
 AFNetworkReachabilityStatusUnknown,
 AFNetworkReachabilityStatusNotReachable,
 AFNetworkReachabilityStatusReachableViaWWAN,
 AFNetworkReachabilityStatusReachableViaWiFi,
 }
 
 `AFNetworkReachabilityStatusUnknown`
 The `baseURL` host reachability is not known.
 
 `AFNetworkReachabilityStatusNotReachable`
 The `baseURL` host cannot be reached.
 
 `AFNetworkReachabilityStatusReachableViaWWAN`
 The `baseURL` host can be reached via a cellular connection, such as EDGE or GPRS.
 
 `AFNetworkReachabilityStatusReachableViaWiFi`
 The `baseURL` host can be reached via a Wi-Fi connection.
 
 ### Keys for Notification UserInfo Dictionary
 
 Strings that are used as keys in a `userInfo` dictionary in a network reachability status change notification.
 
 `AFNetworkingReachabilityNotificationStatusItem`
 A key in the userInfo dictionary in a `AFNetworkingReachabilityDidChangeNotification` notification.
 The corresponding value is an `NSNumber` object representing the `AFNetworkReachabilityStatus` value for the current reachability status.
 */

///--------------------
/// @name Notifications
///--------------------

/**
 Posted when network reachability changes.
 This notification assigns no notification object. The `userInfo` dictionary contains an `NSNumber` object under the `AFNetworkingReachabilityNotificationStatusItem` key, representing the `AFNetworkReachabilityStatus` value for the current network reachability.
 
 @warning In order for network reachability to be monitored, include the `SystemConfiguration` framework in the active target's "Link Binary With Library" build phase, and add `#import <SystemConfiguration/SystemConfiguration.h>` to the header prefix of the project (`Prefix.pch`).
 */
extern NSString * const AFNetworkingReachabilityDidChangeNotification;
extern NSString * const AFNetworkingReachabilityNotificationStatusItem;

///--------------------
/// @name Functions
///--------------------

/**
 Returns a localized string representation of an `AFNetworkReachabilityStatus` value.
 */
extern NSString * AFStringFromNetworkReachabilityStatus(AFNetworkReachabilityStatus status);
