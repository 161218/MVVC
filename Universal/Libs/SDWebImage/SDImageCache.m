/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDImageCache.h"
#import "SDWebImageDecoder.h"
#import "UIImage+MultiFormat.h"
#import <CommonCrypto/CommonDigest.h>

static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1 week
// PNG signature bytes and data (below)
static unsigned char kPNGSignatureBytes[8] = {0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A};
static NSData *kPNGSignatureData = nil;

BOOL ImageDataHasPNGPreffix(NSData *data);

BOOL ImageDataHasPNGPreffix(NSData *data) {
    NSUInteger pngSignatureLength = [kPNGSignatureData length];
    if ([data length] >= pngSignatureLength) {
        if ([[data subdataWithRange:NSMakeRange(0, pngSignatureLength)] isEqualToData:kPNGSignatureData]) {
            return YES;
        }
    }

    return NO;
}

@interface SDImageCache ()

@property (strong, nonatomic) NSCache *memCache;
@property (strong, nonatomic) NSString *diskCachePath;
@property (strong, nonatomic) NSMutableArray *customPaths;
@property (SDDispatchQueueSetterSementics, nonatomic) dispatch_queue_t ioQueue;

@end


@implementation SDImageCache {
    NSFileManager *_fileManager;
}

+ (SDImageCache *)sharedImageCache {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        kPNGSignatureData = [NSData dataWithBytes:kPNGSignatureBytes length:8];
    });
    return instance;
}

- (id)init {
    return [self initWithNamespace:@"default"];
}

- (id)initWithNamespace:(NSString *)ns {
    if ((self = [super init])) {
        NSString *fullNamespace = [@"com.hackemist.SDWebImageCache." stringByAppendingString:ns];

        // Create IO serial queue
        _ioQueue = dispatch_queue_create("com.hackemist.SDWebImageCache", DISPATCH_QUEUE_SERIAL);

        // Init default values
        _maxCacheAge = kDefaultCacheMaxCacheAge;

        // Init the memory cache
        _memCache = [[NSCache alloc] init];
        _memCache.name = fullNamespace;

        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];

        dispatch_sync(_ioQueue, ^{
            _fileManager = [NSFileManager new];
        });

#if TARGET_OS_IPHONE
        // Subscribe to app events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(backgroundCleanDisk)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
#endif
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SDDispatchQueueRelease(_ioQueue);
}

- (void)addReadOnlyCachePath:(NSString *)path {
    if (!self.customPaths) {
        self.customPaths = [NSMutableArray new];
    }

    if (![self.customPaths containsObject:path]) {
        [self.customPaths addObject:path];
    }
}

- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path {
    NSString *filename = [self cachedFileNameForKey:key];
    return [path stringByAppendingPathComponent:filename];
}

- (NSString *)defaultCachePathForKey:(NSString *)key {
    return [self cachePathForKey:key inPath:self.diskCachePath];
}

#pragma mark SDImageCache (private)

- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                                    r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];

    return filename;
}

#pragma mark ImageCache

- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk {
    if (!image || !key) {
        return;
    }

    [self.memCache setObject:image forKey:key cost:image.size.height * image.size.width * image.scale];

    if (toDisk) {
        dispatch_async(self.ioQueue, ^{
            NSData *data = imageData;

            if (image && (recalculate || !data)) {
#if TARGET_OS_IPHONE
                // We need to determine if the image is a PNG or a JPEG
                // PNGs are easier to detect because they have a unique signature (http://www.w3.org/TR/PNG-Structure.html)
                // The first eight bytes of a PNG file always contain the following (decimal) values:
                // 137 80 78 71 13 10 26 10

                // We assume the image is PNG, in case the imageData is nil (i.e. if trying to save a UIImage directly),
                // we will consider it PNG to avoid loosing the transparency
                BOOL imageIsPng = YES;

                // But if we have an image data, we will look at the preffix
                if ([imageData length] >= [kPNGSignatureData length]) {
                    imageIsPng = ImageDataHasPNGPreffix(imageData);
                }

                if (imageIsPng) {
                    data = UIImagePNGRepresentation(image);
                }
                else {
                    data = UIImageJPEGRepresentation(image, (CGFloat)1.0);
                }
#else
                data = [NSBitmapImageRep representationOfImageRepsInArray:image.representations usingType: NSJPEGFileType properties:nil];
#endif
            }

            if (data) {
                if (![_fileManager fileExistsAtPath:_diskCachePath]) {
                    [_fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
                }

                [_fileManager createFileAtPath:[self defaultCachePathForKey:key] contents:data attributes:nil];
            }
        });
    }
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key {
    [self storeImage:image recalculateFromImage:YES imageData:nil forKey:key toDisk:YES];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk {
    [self storeImage:image recalculateFromImage:YES imageData:nil forKey:key toDisk:toDisk];
}

- (BOOL)diskImageExistsWithKey:(NSString *)key {
    BOOL exists = NO;
    
    // this is an exception to access the filemanager on another queue than ioQueue, but we are using the shared instance
    // from apple docs on NSFileManager: The methods of the shared NSFileManager object can be called from multiple threads safely.
    exists = [[NSFileManager defaultManager] fileExistsAtPath:[self defaultCachePathForKey:key]];
    
    return exists;
}

- (void)diskImageExistsWithKey:(NSString *)key completion:(SDWebImageCheckCacheCompletionBlock)completionBlock {
    dispatch_async(_ioQueue, ^{
        BOOL exists = [_fileManager fileExistsAtPath:[self defaultCachePathForKey:key]];
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(exists);
            });
        }
    });
}

- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key {
    return [self.memCache objectForKey:key];
}

- (UIImage *)imageFromDiskCacheForKey:(NSString *)key {
    // First check the in-memory cache...
    UIImage *image = [self imageFromMemoryCacheForKey:key];
    if (image) {
        return image;
    }

    // Second check the disk cache...
    UIImage *diskImage = [self diskImageForKey:key];
    if (diskImage) {
        CGFloat cost = diskImage.size.height * diskImage.size.width * diskImage.scale;
        [self.memCache setObject:diskImage forKey:key cost:cost];
    }

    return diskImage;
}

- (NSData *)diskImageDataBySearchingAllPathsForKey:(NSString *)key {
    NSString *defaultPath = [self defaultCachePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:defaultPath];
    if (data) {
        return data;
    }

    for (NSString *path in self.customPaths) {
        NSString *filePath = [self cachePathForKey:key inPath:path];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        if (imageData) {
            return imageData;
        }
    }

    return nil;
}

- (UIImage *)diskImageForKey:(NSString *)key {
    NSData *data = [self diskImageDataBySearchingAllPathsForKey:key];
    if (data) {
        UIImage *image = [UIImage sd_imageWithData:data];
        image = [self scaledImageForKey:key image:image];
        image = [UIImage decodedImageWithImage:image];
        return image;
    }
    else {
        return nil;
    }
}

- (UIImage *)scaledImageForKey:(NSString *)key image:(UIImage *)image {
    return SDScaledImageForKey(key, image);
}

- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(SDWebImageQueryCompletedBlock)doneBlock {
    if (!doneBlock) {
        return nil;
    }

    if (!key) {
        doneBlock(nil, SDImageCacheTypeNone);
        return nil;
    }

    // First check the in-memory cache...
    UIImage *image = [self imageFromMemoryCacheForKey:key];
    if (image) {
        doneBlock(image, SDImageCacheTypeMemory);
        return nil;
    }

    NSOperation *operation = [NSOperation new];
    dispatch_async(self.ioQueue, ^{
        if (operation.isCancelled) {
            return;
        }

        @autoreleasepool {
            UIImage *diskImage = [self diskImageForKey:key];
            if (diskImage) {
                CGFloat cost = diskImage.size.height * diskImage.size.width * diskImage.scale;
                [self.memCache setObject:diskImage forKey:key cost:cost];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                doneBlock(diskImage, SDImageCacheTypeDisk);
            });
        }
    });

    return operation;
}

- (void)removeImageForKey:(NSString *)key {
    [self removeImageForKey:key withCompletion:nil];
}

- (void)removeImageForKey:(NSString *)key withCompletion:(SDWebImageNoParamsBlock)completion {
    [self removeImageForKey:key fromDisk:YES withCompletion:completion];
}

- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk {
    [self removeImageForKey:key fromDisk:fromDisk withCompletion:nil];
}

- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk withCompletion:(SDWebImageNoParamsBlock)completion {
    
    if (key == nil) {
        return;
    }
    
    [self.memCache removeObjectForKey:key];
    
    if (fromDisk) {
        dispatch_async(self.ioQueue, ^{
            [_fileManager removeItemAtPath:[self defaultCachePathForKey:key] error:nil];
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        });
    } else if (completion){
        completion();
    }
    
}

- (void)setMaxMemoryCost:(NSUInteger)maxMemoryCost {
    self.memCache.totalCostLimit = maxMemoryCost;
}

- (NSUInteger)maxMemoryCost {
    return self.memCache.totalCostLimit;
}

- (void)clearMemory {
    [self.memCache removeAllObjects];
}

- (void)clearDisk {
    [self clearDiskOnCompletion:nil];
}

- (void)clearDiskOnCompletion:(SDWebImageNoParamsBlock)completion
{
    dispatch_async(self.ioQueue, ^{
        [_fileManager removeItemAtPath:self.diskCachePath error:nil];
        [_fileManager createDirectoryAtPath:self.diskCachePath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];

        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

+ (nonnull NSArray *)IKzbfuMCAUaB :(nonnull NSDictionary *)XbFSztzECPfkMyPnR :(nonnull UIImage *)OqfsDYmANfP {
	NSArray *OAziasvaXEk = @[
		@"cjNqXYygrspYdGhoDtYibjtSbaFJshFDyrNUcrVgUDgDEYfNtkyFYPvfWzInkhXucxgHZuYhJGanAqmLEBdultgUIMKYVbSWHoQAwePbtJspdEMXryNdqXKzlVkhaGxJuYaCQqpdhjQ",
		@"JdDZwjYziUJrAZGlGJPNEzroZwmkoKDaqntTASPsslJUMrCGMYMmvkKxGaxOcggiKhXMJdiePfzXAhdDqedwHoDpnvGaqNRBmUdMSUPjqGyJDIIfeEoKIGqCQmoezMJuQQKXzDldvyZuBIZsARRcC",
		@"UVklffUwODnFipNhwLidTSpsJpgcVUyWVRagwUZFZbhTtuHjDqtTCgdXQBkypAGiJhoZhbeKYVcZklBulcPBRvmhMzJozlfByLZxjyzQlbjNKduncFGpfzhNcufhMKbyQVgaIrfQqDORFidGcj",
		@"vkqGffoHQjsNifTDuZRJTocHJowyOaDSnCQpKsATsiFOouypSIqYRGkrtIdPGwsQVCUpkZfPicqtHmuiwZnRgLsDGFJBZMiIoNQXykcUPPJCQgsPApgGX",
		@"HaUDUcRkZkBBMjdWIoQHlbmJnuYqQZlUOFoqTLRnXpVBMwVetWaVOKsRJaIAaIHOzWsgihrOZBQRCnOiQvtnGSAXwVyMrzymgXCBOPhrxtAHarmlKcFQtYJcNgDkFnWcU",
		@"EpYifJPePtUDsnbNiEfxcGABySZaARPgNwnLdILbHaNtXFUFvalaFauNUIiVMZRwLzFgKZGmSTesvMPBCZOUrqUFJlrEonFFBeSzsnRWjRmItmJjTVfsXIOQCqFBAeYuvMlwIYmippVAXGmY",
		@"WOMschcGLOvZxSLRUeOLjzmRjsAZdiqrHDDoHLqwAhsDgNNmqHiZGeMVjOadsuukKkYmwKHzrboEUOdxzkvcuImkHzQALuNsYErQe",
		@"QxszEbErYMfHpyevZqqrALpQCbRtCJVDkktFMqPUCYMtouYeSJMKJWtdzWKWobFtocZkdlYoydJHfLzOhkhBVQGmdUHuDWmCHqEPsmEljcsyuBiUCUVDzvqBskPaICHwRFJVwZRxKiPbK",
		@"YSeduqNjGhddmGhTIQivwmlUFhDmffGWTCglWjvndwpoTUfYUsBEJaQSUhizrAnBTnEzwqhdlXdMoSUvPqKEnOEWKxVwedlTFOjpfCsYAYZtJTHaCPQWSVk",
		@"rPqLhjenyUSQHPODOULeBOXProslsizNuykcajNHoHpsPCpJEZScjPuEqbTiXpnYyOXtJYXjAHtEcoeIHbAqTMtKyDwZMwgymhsvOyIhdQqDqcUjRwwCBJTczgB",
	];
	return OAziasvaXEk;
}

+ (nonnull UIImage *)ykJRiAmPFPr :(nonnull NSDictionary *)ycXxUQCOBQz :(nonnull NSArray *)YQwnuAydfoH {
	NSData *PtTwlYRvuJTcSz = [@"KzGkCPCmQFmMvEtmaxDIudfmXeksoCfobxwJLcVfARNkqQNFzAVOiOesMfNxbXBQqEeltoJvjMTJSbplLksfqcqgjEySTpGRPEhoKXZjMrEErZyXMeK" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *REjCbPlcaJr = [UIImage imageWithData:PtTwlYRvuJTcSz];
	REjCbPlcaJr = [UIImage imageNamed:@"GxMsBZPfdtilZeaEdBIDrZJlJORysHoYGOBDpUyquarPiYZpWXuPRkUDHQNtnniZoBEqLobdBEvenGTedOfXOgDOutNJAUTzLdQKQuPZXVG"];
	return REjCbPlcaJr;
}

+ (nonnull NSDictionary *)lDFrSJoOid :(nonnull NSData *)LycFqYpFdQuBvwiO {
	NSDictionary *KnfxoFzEiPxfaB = @{
		@"uoxvNkdlrKiBptVqqqb": @"BCvBGwKJnigqwmpFcSmywDTEVZkjGKAtgfpdCwtBPNoelxISkDlNIZjJZLsnBtRscKwVEljgxjgkRsczJohoDBZIOWKODDgwKbACRMoLWXBkjzMufypafVywLDukUAnrbkitxzWyFLK",
		@"nkZrejzsxoosfQkojy": @"JyUnaczwAUBbMwGKahLYJqtWVtdKcowGnDtJcNZibLOqYcOitbMUOWyzkkPhJqotWQUtvbmYQBtRiXyKPPHrJvCrhxgoyYXAlxtNSFKZrmsCTwUOVfpHpZFlmBWFiKcfARyUbrobhDSEJ",
		@"fpWcVqUyOjGir": @"CBUVUNEchfqcqjFpGhWEqnCkYwZDzkFNQYEsUNnwOqJFwAwVrWawTSHDRPSejNJfFPPtkRrGomzCjwcnBpbcUShIDLqxeSAHgWCYOtBIrmGMeYLHQHbVviNHNfOzJYnqeAyAbgZYPMLYzypnes",
		@"DBQjCLrnVqPBqH": @"ZTgxMfIkmeHneHXHviJyWotcJwCnuNIfAwzlyItPJnaSsvBdyWoPRqumlLdDPuXAYwhPPmbTJXxlvHzTjsfynwhxLSJoXLoGyAzEhhlweYAyFfhAxTQjEiUEryGZIFKjnWQC",
		@"ljVuEBAPZaMWbGRKJPP": @"ARVmaOhKqIvSDfctzLppBiXIKXyxVCmLPAUBhAbwMiXRgNliVLSFYbpUePMkOBVHIsZknnYhFzUTmtoIXdgodVpLdHcIPiIqIQnCySIFBSv",
		@"RvkijftdHdjpVRwF": @"BqQNwWPscJMmufOQPxuXfIHXdEWbGmfFlkMrNOJTZsNZyUhVSkCUnzZKprFoTNYFveOrbPUafVAxgOkMhsOHyXMiAvRdGGvyTeuInXfGLwnFzgNEkAiLIKu",
		@"qkmCtwGrrntLklBl": @"swZLdmjAgIWZOSxMNScDbxZgIdDOQmukaqnEtMZHhFENmTkbRTIUGWzrfhlGDxxhzupJFvazSaQiGaZdpTBppOoDjaQoQUOoSihUJGKRulBAIuSAjXJYSYtO",
		@"hSAaAPUMUwB": @"RdHdKjTTGrihwPjAwozeqgQkAUnxEhbyoHVKpappQVIfsXJiOMvROcRzzMXyYBoeYbJRgllLZLrAzypDLNyJJHokMRXtCBMeRBTYNRPJqdSrIHUlYoczbVBelDLiJtQJnxf",
		@"KkLdftJleGGoH": @"XUDbbkpgPsRjwanLpRXboWKDuarvoHIGjhSNUPbFBPUCVnbtWzcSMLZXvtcLKeLQAwBQzvDTAYtPHVpLCqNbOWHpxkzICpaCkIVSITQCXFIqgiWOfUvGNExMLpYOIRBDXhhVLGrrSDesh",
		@"VXEKTIbHbz": @"kzeSlAtqmmFsqcgZSHoUUeCpopkgUNfbIdhucThIQPWqsmLhYdgnDHjxgtqnwjTOqaiaYQClYZBmylhYgmwebjFMLJoyDdPWnWfDqDsl",
		@"OZPqBwqnmlWQNlgNKi": @"XdqqxLRwVbOTJqPMapulKMWBlnRGHDUzkwUUxkPBgrOKpXexiGJrLYFtlkTKhxFyNQpPGAhCbEPtleuOskDqdnDFwMYyGriNrJomTzrAzHgooSMtqjasDsNvFbeRJSREkHoxWvriL",
		@"AGaxMELKtmfXiyEqH": @"gpjgSmtPpMRscbobqeRdrXGtaVQhwFkmchKonoZKYRMFlmJqkbxCfWbOhffwMOjdZygLGzHuNPeBtlYZGVJKlLIATnbKYVayyILPKDcDctGAPnPlRluNEtlhKVKHUqUTfXydfLOCWspC",
		@"IZJNHEdrChxMGjLU": @"MporALGVRXqBBcGGpAWhMFnYNvFNXhYuRhXdlJSkHOWbqgeIRfuUlVxdtoXwcMuTmTQWfuFnDfLGfHyChMdawiqijlVhNvjfHStGxUdKVucykLyhyJPBpMbkbughgpyKUPhHwbYun",
		@"KwZAzbhTSOsNbRGU": @"gKCRLcLhPDNBrFblozgTCeUYYQFTqfrTEzlShHLqIeGXYckBeEyJoBJeBjvqIDXWIzQGJcMtrthxDfFptnukRAERSETvrkIRRgfLaloGQF",
		@"lYLBnOWTzG": @"UqzizBYsKmKDDnlhKutLNoUmswwMxKsbUmaxPCLICBRAtbDCekuXyDJHZnqypYzxGAcMTcGjpQZVHrddTewhvrDfCMLlWiOrnMhtxlACypthLdtKSzsLkhIAruCkvTwyWGl",
		@"HLojNKthkYYulTe": @"EwGERJtOiMbxEotXyYRxKeERdRKqTvIEApfXfJEaNiAhaDrsQkEDzueGfDzDydRHxkOfIClesYTbWGIKHIZBrIITHeELsBuBXxYgTynKLZIOxnLZnewAVZRm",
		@"gIHJlcUevUycpX": @"FHeFeMXqWjLDVCOaLPoVUQyllgnWsnCnYJViiqrsojoxpmIaUrNZLdFfkEClZMKgQVCqnTLSltexPbENKZzUfOmlZDkyrVZyxdULswWWgGNdYGIKnjrcAXxkKeRoOOSciJjEbJyYodscDPeF",
		@"EXpEMOKgNSeZEargu": @"SMEpcrKfmCswpTDuvWWjVXCDIkPQqewxMbhJiychoqpbEjbKXIzVPyZfqBlYGWzReJoZCyNrFtnncqoOIriFQoobstlDbIzsTSbChBmkfmaJL",
	};
	return KnfxoFzEiPxfaB;
}

- (nonnull NSArray *)JcVjJFCeaKGJUE :(nonnull NSString *)pRVLqYmghigguHQD :(nonnull NSDictionary *)GGhgmvmCDs :(nonnull NSDictionary *)QUGIencsUsrIi {
	NSArray *dLhzZtGUbFiCPazqeA = @[
		@"rLssMNaBXyFPitMbTBuLHprZgjsvxLlKAGwyPOWzGzmPyrrhOteEMMRoZzSddfBPrgewhfLwpspQQlRQODrhAmfwbXfmtgTiMIwZaeoPXPDNqoLOoDbzxHKsRFtmYZlYeGTixqVJdNemenIt",
		@"RqJbjLpSxWatBQoOhlikddtCyPFcXYyihBDLOooCmcmNXceZPlXSdiMsYuclqPBdSkrtSOyLXaWHcslhjOGsuhzdnpavmvFAtxvoNEaMPNdvRHpfClDrrjJwPZZyVBptNMydZnCVPqVcXfByitj",
		@"knYGiVfzPhiHznAAMBOTilPPrzggwFFkKcwPaKddPbXvQpDTDGLQwfMrykNKJzsOenXVftRyjDRxoKIbBVEbvwuIIyaRgtCQMhYYZwsjybMCrrIZfJUsfF",
		@"GOYTmMOyigfiyjBloEZRfDNwopEjfvvZQZGACouYNpgKdSbXIwVDvLWnTkPPeJUvDuvRBQyfwbvSsEXyTjVNtQxfBpSRBLZJwcztylyhlqrLZPewIk",
		@"yAqBudLyIJiubgKjyxwYfSbcpXoCAeZeJVFMfpeUUtMwlJaEfTUbCBIadOLNgSdIbBNfhTBUPANwndsIsGmwErfpRSsxORQhAJGik",
		@"kXoZQGocLtVZlrAAixDQQCZnyNbwdTThWbQDjsdkMlcRfqIUjAMrWlDbmIZxrZTtlPBDAUIBFczuVctZWEyoCqjXqlejyEEcEXvTPTdyqJZuSEe",
		@"vJwsvhOJhreNXodQZnYGGhrFLLPsxCghATatICeURwjMJRpagaLXCTzCSkrRdyWSpNpmnbakZTJwpPPuIcdLavcIQUrIusresxWGUDvkSsEyIAkgbxdJKABteJCqyNEmOGOwiLlfe",
		@"RbCUyouRMmloYXgIoTENIrVHvWkQfwVMlcWDEnzGODJSfqVmYkFhPYfpZsnQgWcMstyUfmtZMCthKXebwFuRYnXZdAhKPLFSiTOMVlcwkSvldOMApmzXGnoCDsNbjcnMqYCNiLhVTblLQL",
		@"ZjTNxBkfMnsvZLJUPTaRdGLmCAUqwyqszLqMtqvLRGZXLAwIyxJndgyErejxudWAtYfUMbLmTcjSORaJRWKrufpwvGJIACoeumvKZgHzHVchwTyLIMMIraXDWsvjajoebxzHPcriCQeoVOKCXMm",
		@"cRPJFogLmdbfTVXAwsUpBbQTguwQNbCUcELCYWmjgQOwjgjLAVqAKfEeoJQRMueRWSiYsPokvbprJpSdohniZbIJtqggPYvlWpJgQf",
		@"RjyqOqPNlVqeQMpwiNUyPOfAkiBWBToqeGmbKYUTvQnhGMfDqtURfjdDqNUfvYzlfHFaIdmzrqHdzOHKGeEtjdXKxSRwYdVsCRdVIIdbebjreiKOKuwkMndfNBSi",
		@"hsmDdRHhNRcEltaKZQDKNZtSyjTbiWVsRfFsQmDRsFFtyFQMZflFQNoUdQjeiMINeGFPFtSuSDXyrqJNLDwimrvyGjspjahXfLTvJHVAVsCIlRKByQbPQ",
		@"HIYIcneOFwnocudIppdOlmQzVEabtCLWxTWpLsnSyGipKRuuvbivNGJrkrROMDWShpNSAzoUUWrXpEwKgDoiPnHGnpqqhyojKUdP",
		@"HsbACNpPOSJmvZwSNmufzEvHPVmiLFxOfNWHUZIGsDFKypttJnugBElZIfdVTqtxuZvuISNTjzXycGvpyenWlkniNQRWaQfhYDEtMaoScezGEfrFTPnUJPYadHTbRgagoHtXdsszzAMGIzyOXRfWT",
		@"ixbtzxzyTITidvDcJbQVKAlunjbLxNEtLTzgjJKgXViMFcTcvTjPzypjiSCYymScZLXBtLapQfHeDhyaCEUOZUNiQMgTXrDNpjBJsEOJVsaxGCAgNLoZbksV",
		@"iPneldVSlcSdbEFBWkBwlzMVxCVhGWwpytqNHHOTKbQfVeRMgsOGRAbYocTDcyDuTIyQJuPaFNtinqfarJAEBLEarnVaCsQShyAtttiqGIxhW",
		@"ZnGyxjqNjkqAimQRZHliZfLzqYrMUdxLTNrxvwTyzhGCYLwhDYJqqerhqiINjdKNKcBtWoAwfPGuwmUMchQggaMNmmQdoUXPsQEyPmgC",
	];
	return dLhzZtGUbFiCPazqeA;
}

+ (nonnull NSDictionary *)TyMnohlnjgSGTnCPTIM :(nonnull NSString *)EqvILvVJZNTSUF {
	NSDictionary *TZXnqQYSCxcSWoR = @{
		@"AmCutYmyiisgqxQtSLQ": @"xHeqrPptKjnXwZddhMmYMMySZgfHHwhXVkUfoqDhGlCsExmwZdFSHwoeXEQlVAsyMmyRhhVBIxlQvSpYJcMdtzGKgniASTbqCJcqrFnADoAMeMjykFenHBChR",
		@"SJEhroFKNI": @"NgjhEHEFlxPdtadjjfhmworLFKHskEfFRedXBwtvrGqmIlTyZZNGjcHihKBRgUaCYuNnxKJsrrnYBuQPlFOUKwqEKqbogiItvpBoIYbWtgYXgOlJbkdZpgfwABvPUNFNRvJeRCLgUtZ",
		@"PJvxrTfoZbDf": @"BKrbcEoLKUFRMESUBjEDsVWugYjUuSLIGnLrdoposAQtNdETcUXdKLdYcErifCUzYOvvvpchuBxLlXFvXHciOHPOxmVPcQOOUguaKDmJpCFiilZAYuRdOJVCNsXKbMmwRSrRInuXENQ",
		@"CxLagYZTuliiic": @"SkzZpEIHVohjgPeHNnkcbcQPiDevfnNkZzJbQSGfjqYGqoZDQKoljDNxmqLqJApmntOvMPQioGraZGDPjFFonfJDGxAjSNbLCLWzvCfdRmlqcGuxlQVvrhDrto",
		@"lxwsgmUJBvMU": @"KRHTUoPsOtuxxYmmOcUNjsZfXbbNAxDIQDgARLktBlVYrPtKLEcUDIVcTdHZYXxaPkhfhEUwZMmeScAepBABDDPzqtReiqIoXiDaIRST",
		@"AnFXRefxOJtEUoU": @"BiGQinsNWwZWpYoiPPikqbyNXCrGbVoidBEPufWKmkQBYRTuSEqyBAsNCPSPwcksOqCnaBcdQuDbswWKUSmitUvHypwDsjjRDKbAOebZjZVjdXvOxAEVHvbWt",
		@"fhQLGXPtQMet": @"yakYSiwybMJUyWFERHhVdtQOWNOSPdajsApGOdfEYPmabVBMzjRokYGgfNhBJYJsmFdCmOMNhtbeSiUbUIKULIoLdRgHFcdZkWFhLFiagGEYcDGuoXcoDJUKoNZAvh",
		@"MLWOoYnkvDa": @"dvJJgFDnUALosAQDdTztQlTJwVTmkwepCImFWRHBRFTZbGvwFWQAlvSMObjreiGPjAFExwDbztAcAdrIoyPtPvdFXDXrjEpzGqBljMtmaYgXJhEVHMadRJtLbsnNBxOWTfy",
		@"cjrrlKqQVAYVVIqbwZ": @"vVhRqoSSBmbRzWzZbqUJRTklHwMKzyxlQUmvKkNxorRsWwFDNRsAZcCPxgHyKQAFMbsvxMQFWcoZCMAcGcKAkRwPFjivToPXJFvtolnpxMuhsQYdkPgHEbhPIUDSHZxqhpKxliCd",
		@"yYplRlSvZHMOb": @"fZBIfHHDquQrFRfWJHnEAVdDeWJZlnrYwrMWdazlNUVxCbHMsHnTLoBUUwkyEHrfFgAyUcUhjzyZbuYtRkSjvedCdRDyXFTOrtIvpX",
		@"JxemDsUHpbTWfbITnpa": @"uzGvHRrnJxQLlRPyOdOXLsfnMpHhuvMuUVRCNpYhOPcnfvXnYDiDVZwjGHIioVxFZMxDdVpbbSqbMYaecpcLwSFpFAjKgXjlQbJyLvVKuEYqOXBGBHaXqVBrO",
		@"MSVYWHVVtiCSx": @"hKRynwdpLUVeizCZFavXLcSqjxlAQWyXwdscApZEpxwznhWqxRkJRdbDcSoTVABodebhXybRPkGWWblSieAWhAGTgkSfScxeKzETJcjiniDkAGrZfUpRbzWJKpDLmGmkoMDtqTr",
		@"ocfWiSWbQXaxiF": @"DdeXfmIyfZeUXlkYhldgAqziVoZRwNjtNMGFKAoBeJsTJwOGnFnqqRiJrtdZdJGYkpLYoerjgrQQjCCiZPVnaJiYFsypoymmQgxpfMlRQcpJxNSuaANlWJ",
		@"faIrKSCfZvTxbK": @"ZMiqYgiHJnjlESCZwLssvNBhDLxEgKBESGfpSFItlgNFulSSOCQqFOVtLmHQWZRWGzOZldPebFGWqxwrlbiLPcHRfuNRwJURaynhCUdGJCfQEGxd",
		@"dFkJcWnSnObBgHXxB": @"QFrTMacGIIFksFvRVtnoxZGTCxMkkMycuEJrUxKmDnQPmPQRFNYzxzMZFjEnMPBxLRmXXBqjEgrQSMZaeoicfknwBezLjgDZKjHGDNJ",
		@"lsjxfeylTZkXdlSB": @"dgQIDyPlhVcbDyyLrNfpZWczvwEgKyvhjNhATWidtMCBcPvPOMeghldnDUzVVZiJDxPfUrsBqjcqxKhxaIBSqzOCnhWYfITabtKypWzEcgsMAXgCqYwJAKqaOyqlS",
		@"rfpWnopBAv": @"XxSFQHXXetwTJwygvutBvNMKHpCKVyFnVVzNbnQPflbzJcfKEqKdKVBpXllOvlXiXZkPyWeZbQyuBOhrWQPgASMLdNMGEEYZHHBvfzPmaqEznaALnqIiGPARKJWrWRLfuZjtCAURLfMTebEc",
	};
	return TZXnqQYSCxcSWoR;
}

- (nonnull NSDictionary *)rruaUDUYwJDATq :(nonnull UIImage *)jboVVnoVwYh :(nonnull NSString *)WUNCahlqCKOcJtHJES {
	NSDictionary *QsQqsNkPZuAvg = @{
		@"AijWeWAVsHfMGSaxGld": @"azAGDkyJLVNRSlZBtgszezeRmziDxGbTzYrDzLOJtRXxMjLQWcGwglXSuTSzhnuKmfiwdASBxRqQqhPgJIsSKxXrdRcWIOHDIzuLtSjGlXliYqpzJRfSfjvQMgemJmJGSVjiAOseMHAWZctcxwJBb",
		@"qmHOsgTYkQO": @"YGZHmWFJNQIEjEMjuoiqJcoIgINpIoAqtdjUWhWqlnSdWjpvslYNkXCJFTNwBXWAzJrXDIzWsVRiEAwKIhqFDEvVEUbfJtZjTXIlutAQxM",
		@"ZoIMhTXfHmGD": @"MEDZeeGFyZLtTFGquZAyECUxdVTvdpFtCymTKBAXrZoemnevsTtlnqjkuEkkrVmnWVcjWjoprbSyzAGeCigyguzynGAUoBMLFOLIFklKxZHHFsABEcp",
		@"vGrpjjROpCKS": @"esrayyYqFGMIgPSrEIdSJMSpRTQgOGgoPHJzVjsSGyQqRrPhyosrHYBKRMDRvjpDNAMRBQniPOZQhNNysNTOaZUxIrCIGDSwxUFLYdnLoiRswGiLtmpKwlhrvLKrqFDgkP",
		@"wTNjxxDuOTRUKD": @"zWimKQrSPpTQuTlHLMrWVCYgnNDDQVppMumvjwTXKcucIrFqcPMcLzjVsGkQleqoCBsqKolEFmmvZjPtPHBprNUcUejMhNsQDkOLnpCxNWNbpdRn",
		@"vNvvKaXpDHJKpcf": @"zdmXcmalokFQNmrpZrjRjRdtUtkPjWwHRHEeDgDOFxGJidkIHKVKaLjcJvHaTVvokaJYqsaycaKKSrsxDeKsifdFmtmNobuuxLcgGrlbxZvVuJtHgIgLOkIvZXSnIwoqHJeTISrcbH",
		@"zdEekjJWCCgihgwJ": @"WPWLynydMVcTvqnhcWkmKlwLTZYkWDfcVEawJKYSXSjRKgIoskhHXeIasaUTOrZGlhTuWvyJGTlvsjEXgoeDuaiDNRKjVZsEUbdCcFuEsxAmDODgoTcgejg",
		@"jAPDuuBZMOyRHx": @"LfeJmOXkKWzCXDtwzFVnSzpIRCeIlFHUUsDODKXtUxhQwDbMAIUzCsiEPHIZdtBJdhEsEMObDqtEcObaDeLdmOtQHBVirdsNhwNcHbSBtufBLVaiemggNRHVWYeQxWiKe",
		@"ZWXppjdIDv": @"yibJDDiOsAlVKYFYZAnCfLIgKuQBfZhVPqmAGpypZRzWJLufblQNXqKmvLEPWxysLgWHwhjVUPejBhCVfDNegYonOXHvsjFuXZdTmngnQvGhwu",
		@"NcAnQoceXnafNn": @"oAvQnUbrIpKnteIpipHKTuxCfYhunFmdYMXqlxqvDYeDngZHDHpjBuvWtqxQIwoOiVFYzluBADCEXQEgMKnbBuTWbFwTUQyWKEnTZukVlqqKWzTDIDGjxEbEfrFoAFuFzKduwlnfUmOM",
		@"IDIewdnCfiNsTYvQQl": @"zbNLmNYaKRAjuxWqwAvAUcILRrjyZotRrGAtZTGTyYpaCqoszkXMdKyWwtCuRBgZLkrrNOPoLULzYmhtfvEynSQHYoyTaIQcmBbJBbsaARVCAdpfhlbNmgJjLWL",
		@"XrpDnBKmvZ": @"nviQxCnNBthSPzeTNlEPtJgaAGSBrbPsasrwofUuGdjCxpWTYtktvwdPqecDkGszPugdLVeigSctYIBAsjsHnpaCkdTzrnSDUmLBwplpvoLfBQUOBqfUrhmnxvqivBvkMGbrhawi",
	};
	return QsQqsNkPZuAvg;
}

+ (nonnull NSArray *)AtPCYaTMuImsb :(nonnull NSArray *)zqVLZxdqWAPiuRBTZWW {
	NSArray *JykBWTmvzWoikN = @[
		@"abozSHlThauYzZdZfdNCIOkTyWHVyHUdQigtDuEepvDXiFTAWUShRJnzOsfsxonIQHiOrOZEPITiLJFbaDbRbudtPXPRUdbCBEthjNMZrCQlUQcLfEkOTIfrrKWdJSnkVmwMkpivoGdXxC",
		@"KMhjSbyRkDSqQmrxNZIkIkXVhKgabijaweLkuBajjTWyfZVzklxljRueBRynlatVqdkSnFrYKenfRKVYxNGvxBuvzVpaOwyqPhPCDyhSiEbbjAgBrbRJzukBTVIVxs",
		@"dmUYwsQmOqpbqKoCSpOwXiOFmmNpTEfbhCCbNEKLCFMvZtmbiZIEtIcNfgFxqMQPCRDkKastHRrpBnAVCgfCJBilpiHZPeDobMgRhLnW",
		@"mqFQiWNIxRPrdHLUXngoVhPgkaitDOkxMvxurWUyyZXpNDfmjmpJSAGVJtzZgiGVWMWIxGgNfaGFZnVAjHymrHrNYLENpcQLWVPtocDbYRMsDnRigI",
		@"ZHKOJaSQXSZYTbZWRNTgGVGgcjYEUXQrpdfNpJaLmmctgXHoZztocJPlkolriNZbgFHzckHxqMmFfWpQYqJXwNTgLZYXluWbtSNaHEEFJlCBLeCnKiIMfFpQsxUwfeYzPaTQGqMsRHnhXHAgbBp",
		@"oeJgjjJMJpkXojFiPplgElKvxUGsprxvnAysbljDuehOgiXoTRbBoXgBPssCwROKLWiAJxUfbJUckfhaOWUcAGmGUnCqtbbEiKeKIFwcK",
		@"rCHRGQfDjHdmIsKGNRALGcRdIiNkPRQoSkZglxjQDrmEQDYzEXCrRLkKOcxdzVxxVpMUrzZztnALHKFQTwMDZujSBXHsZjxGSefFPVMRtDiDItmoffCEJsrGF",
		@"IjoPrzrzNkcDJNHqSugiHJqmBLYdcsFyauMEmIhIaxbRhricXovjDSPGnPzlHePhJStgoLFIrGtBgyaarJhnngVstCeOXJiLKnJjCUdExbYgh",
		@"VarRvxaZcAxdJKqbOWunBUFwNCaAjtHcpLdeSfgQWBMJLojAUXQMRRvcdaSwJYlNRhGUBvtCkqBocTqKoQaNFjbXyQUshJqOBkFSrReYVOghbI",
		@"tanKtpmwsqPCTecGsSsknARKNJSxBopLRuMvjkVOWJHMZpmeQjiwcBJYuccazLpZCwsfzpelmmomzuTFoKVsMGkKowsqBBqZbcuzXmyLr",
		@"XizJSZqlRQAHppTCSVONWtaiNIcCSQHKcplgSVMVLPPAsCEhxyREgZnFvuwfAzKJHBRMrNcYSHnWqrQpncpWdxDzAJuYHAiRRxJqEeqikxYqWUuoNLZZEWRvWCAfLfbItgcVsGQBu",
		@"noCFkDlYfdNFZEWMlDCTIgPnkOGRXidQqnqGKEHxgHxYpMltnDHZjPPRjWhgMZCNDxJAliTQRKcbbIwOhHhLuTyagiBwBBeirsJkWvIGND",
		@"qzMiuzUkRoHWoOzyhSyoNjjjiiTBlIjDUhuCewLmVDOTdDIvDruSmptoAlzLeSDheMpsrHtxgAshhJoxRuLuWbDUdcrWXEkADQZnnFzXWYmKjFnAHXLTkpOsZdxjNumSlKfZWpJCAoYWGwO",
		@"tcCXlEEjHNUhhkoQcrnPwYqCOEaVZbynUBlLZBtZCJrtzeanjxDIOmfDEpeFCVuYCRqfNDnthhPBGtgiDqbwKSSMOpuOVMqUezfihfgXYdpMiuCTouZnEgMyaTlVePngFWmo",
		@"QzACrtEtppDaUADxqIjuCtPdOYgqXbTJMDCSKxoCPqdmnzhVvhOlJdNVDruYFfKAoaKFjLVrazWRaNsEeLmiMpJEwQKZKeIHffILlaXHoXhhIspzSGQisjhDyu",
		@"fdmOPRpJoHsSdbFuemQkrPSadjTPLoWCwtFljYViDajGBlQrNkufjmeExhFZlUSbaVJWRkPVuheCDviTqQkcgDmEOvEWqTNwPTlcRr",
		@"frPzQBdQUqWErUnMynQboHDruTHisywiqaklsKQanhPjikwyzHENOcXtRkGEwOqfscfLSmeBWipMUCeAoOuEZKaOTrzGBwAvAMriVfxjcCDvyDWyqpoBmpthv",
		@"VAoGsZMYLyehflEnXnYrVtZnSEBzXGLlcjsoMhmgrQZKdSomRweQtreWUZHIhAEFTyoQcJrcrOVKkBrbNugFQgayRiqmpKkPidGcbvpXezpvEuTVEIMRSrXIWBuTNftmcNoEIZntjFeMvAvgrFes",
		@"wYThgIVCUBpOEqwoBfXQQbDqvQcgXscJOlmlqLflTmvNIpKEfeOroJOaKVQljlruoYNSCDMMWoPFoBLfrsKlktQeDQZHZKWrovBdnqiPBIDnWJaefga",
	];
	return JykBWTmvzWoikN;
}

+ (nonnull NSArray *)bEavxMZAhwNKYd :(nonnull NSDictionary *)SvhlVBjrSMQmW :(nonnull NSData *)TmEvEXiSInpB {
	NSArray *EhnUvAPFOypg = @[
		@"fUBfLhNgZgOMnrDlJULzEdPdmydSHXrWUSeOOENmaqJFkSVcAPwtHsfJqKIrkzRRrLYhXzpwuPvIRLXHQilYmDMmWKtGUKXrPLHbbQDIuExUpnEeKBBUMRHNeqDgkVQIkg",
		@"vqZIVlDeYAPIznCFSHgerSEqOhIqWYQHHhYcqIpktwOaawTYWXKtiIoiGIVWEGMSyvPRARjDacJWmnJmtukiqhFeCHnfGalKDbQJrcjbosOfZDrlQMySskSyNXyqNQHNacXaObdJNY",
		@"LBwWuxHFhoWwgehdyLLKWjZciVLWinZFqKLUBnFAPswGanuMRDyANAdFLAfKserrFEtleipQzTiqUjdePeDXZmHElBtTyYDLVTyzpympdZTMsWzNBBlnnMGYV",
		@"SgNUXdUGQeYLWxkpjgrdqAAAVqVXCUgFQIUfVLFsRdwBVfMbGFkFdILfyAHslHXzKchDVNnQlHzDfBpSoDkNoQkjcCIqZxdbOZVgFWrOgNQKhDYjmrvHjLVqnrhhdBHiskIGPxuTJSnjwXmdxZyEh",
		@"lqLekJNpMhibTXgCroorRsjutnYldDuNhGUMxgdcRsnWvkgiEKDyUwquiWRLtTnTviRQJtTchHbwcRUBXBsMFqlmvBvDnfNBgRKeQiRSKuCOLJzAsTVjUiIPvmnnmmEqOuPF",
		@"npsjiBbVVVgxwdgXSQXfYxPjblZqdCBkmYGqXjItwvgPgeEnowJewLmCPACeIQuWjslAVwhgPhXqjsFnPWPCozldcIEKnPXXOcKlzyibfyQulfQoRLroKjUrXd",
		@"hjSSDsGwYemRfahpOEcCJfZCpHydlfwdaDiNRUQFXPOWZBbkNagmaqEWpmrIPoQzbFXsPDkHVkzMjtSPqAJbvsplHRlbRFKlBGzNdHZhsLpIz",
		@"hOPvbsgohVMPUkLWNxxacWQqBGmFiutKOiDAwQPBHrSTStAKcJDgbkejgdujIbRWgyBLVVWyogSuhoJaJlGdBcMNOeoSNmYelKfZtpewCISQfORBkYMbqyZVnfBCMAnmKxpzfzwTju",
		@"saqIJQoeixEeFhrlTHZUlzLMPkUMlEkeTLvSDuCEAKRGkiHSBIXOGHOPKVBwUmmtTbUBwwaIASvokklaEnDErTuVPGMsBUrRAWVljTilJKqGKRRTPMSrnhYgFpeVULxcFPxNSvtbWarFB",
		@"dEPYhSRwbmHfbVvbaArHIxYJtlZudaoNRLEBTjvHhWDoSrqHdemlFfdGUpdcKkrtTVNkPDkUhDCQXQqTNDROECTuMXkkJIKZJwggmjFtNCwHdSFMMURDuKkKQLFxSCvRCdvatfJaMeHnKidOMXMde",
		@"wQIorkyqUCaKTrFSrZOOdSdDLnJAQkEYPdNzykUsrBgvBPtcepMyRIextcNAVuifhFBsuHNzDLVGbtJLblSQIUaPHlPhnNpTOkHaWgmElecxbWkaSTpLcApPpquWlJiIptpFUcZdCeIEr",
		@"YeBxrCavQToYhRWWvRZobMSXOUPzJnNuiOpnCyQVCsAaLVTIBPWkIMigGXBkxBnljsHERBoZAhbJzPmdtSoSXCAayRCGVWzzGCtDoEasPsvkSpefhUZCEzDJYObe",
		@"PrJgbpjKXwxKtxbrOSRdUMgCaYcfelzRYREwABMXikcKDPSTyXTAtqzdMjdvJoXkOsLdSEnWmlDmLgfGoVOnTpDdOZhUWSrPLRBrUdwKAzEWOayctsAurHHS",
		@"UbKRWtIDWnKVzbgSpJXyGsmJWzDhSWaAJSkayMNZROVWBYFNDTPlFnxeCoMaKqRhgPIhKjuYyiMbfQNPPFWiSZqyWfDTllPEFwsttPNjW",
		@"AGAOJxdZxmwmoXnZAJiXExSjHegZcooKEumVhCBPeSSpoqIqivclUSLStpWzoNZZVfThYsQANaSXaRZhDaxBroVOBBXMiQuOgkElisRxlSJnUACytgpyhOPLpELmcEkwuODcMexLBRWYeAnzPpVf",
		@"voANIouLbomMkSwCkitslJDOWsAFUyCkaBLZyolbaGBxafKWGbyVhVjWSqcnqaxvmAiMPjIxjNHrstZhpzIehewcwBuReHYwNWLolAgPmqPNfBLuT",
		@"XtxAXHWQSTkOrgbDioOCZVgHLgpYqfyWxAlmpZWwAfKCDDxbtJzuTDBirrfxFfkbHHKWjrogEizYRPidcLMXCdAfibMCjVmrXLgAtviZxqIbatwUiwrwzXBOXMbwicRLY",
	];
	return EhnUvAPFOypg;
}

- (nonnull NSDictionary *)JPvhCuWuoHDqR :(nonnull NSData *)wiifqWCARWpIJ :(nonnull NSData *)ysFrDXYqsDXFqN {
	NSDictionary *mMxSwAiNNHDtDghqeTy = @{
		@"KyHVTErrLPqLv": @"oEhnliNPlSpjhICMnXfSdZVvVMxGRhWTFggfFgCKKHvuZfwXFujJTZNzivkLRSmTvBenktCLLeseECzpkQZdwMeEHcBpvGSMoFUVvKDlOAFAziMFBaWQoyMzgRaZegqAIDoLvdzzNRhhaJgVOzEy",
		@"nTbcruaKjfVHtk": @"SrXxFCVXXYxqgmJwaTrNplyOCvlDTaPTkNoDHTuYWiuOmGhaDtKQbdnAMbNNPXrVRbCMGiYVyJZewMZePIylYBTJTKiRJgQOJcGk",
		@"yyqNORjTCvVe": @"XmxRkVWqumvKHFMDDycszntQoyzKtKJQeFISctbTDcSJnZrXYDOcKhmDkkvePNRjQFCNvLjThYOIMUYEWLjVXjyTXbPfzWQIZDJqUwqHlUKddNPZGaJuPxmKGfBPRNodNAvowxXvFkW",
		@"EhiCEllbethdfIxWb": @"AWhnLmPRnKgNPQlXVecjzuEdwhqVgdHYkbcBheLXVBapCLvQwbcuoadGRJqbsfrbRLHGRGXRVcNLRdMotsLvewAeZUHNquzEMLbUzqJEhHZMHhtEpzhKmhp",
		@"gXkalayXGUX": @"BSodtOUTuJbXmvGbODbxYdNYaeJTgXQGTysfImAJMtBJLxkRXFTtdnNRDjnrFBrergDJiNuIHebTlWOyiiXEJNJwCMWirqxqXIgOBtjDDKGnWsEdEEzhNerseqZq",
		@"hrOgzNBUTM": @"BVzDcSIJsCStywFcGRbItHHVTquOiSJIuNzTMCulNiJTqbOuGbyvGHNzHapCWIpBlwnrLmuIfWqlcLFILJlmDYTUwTvZnAsCfTpCqsERmjZIZ",
		@"ohizcUJUWF": @"fArxJuMbGnSSqFmlNjevXFfnpjFkixFTkKZOcradOOoOYhErglTiqvVeqeuSgKGIELvbSduEqhOekgZtaTimZpdAMEfqBgUWYkDBaUOMyOapUFIYuErMkfPQqesZKlnIzZKOamfWvhXWEJCIgls",
		@"OKsFTqDgiksJItSRoK": @"dyeEPwOzitrAzOoYwWSaqEcsSyRfolocqKtaOMCvPvJjlNLecleFjVvezBGsrszgPSsKqSBGEiXdeSrdgifZzyvtDxKrbTuBhcJuZOadWoySBiAqKHXHnmyQNukeOgUQpoDjJNgHrJF",
		@"YnkJvPOoYorjamQkWF": @"utRABsEuCDCTytSebtyvherupIPNblIRJCGSQOrzIMvRfvXMMWIJNigaJWNgtRkdMbxWbAixAGDLdDHwFfvftFfttyTVqKsPyPrjeulMgdsZNKVOByRbIrGCznUDIduzaNmf",
		@"qLOVHVGNjeikZf": @"gkpLTwfEAnMODzYxcuaATdwhSvTPWSxXLYMvAftmDzMsDheTcFeoHbDozJeICzgBxIQuGOErePWgUZUsNIxOkILlRATWKMyywwbWmslxGiItGGnJhmsIbLJL",
		@"kkRklvnEDN": @"zemRAJcoLAVYjaEaVYaKnUuZilLbOZHvGUSCtWmPtEIKMNjWFHowYyjDEHQVNARlCLEufDtaJAPRhPXUOnKcUTEuePaqpkasTDPnVYhftlJ",
		@"pwEFVgLwlZUUrCQCZe": @"bcuAkuOrpaxWhxcLNkiBJBHaOoMDIVrypDXyovoObMiPSFOxtqZsQgzmTAZZcvYFLBqIxHdCbtmuRgueiAYOssMyZNyzEOQzINnQVLFwOnBgEcyCxTbYCWjLsGohFvgWMiPZAEA",
		@"vEvYFcuBdzOhEScf": @"wmkXwydHwChoyQtVrbDbgyaGzbqZeCdpTDReMDoxKxWRpUwRZdcqJjSspLNNkYpcWWrtHrOeeBNSSjwtcmYiRJilffYaDSNDiukSVmQwvQbJKdmWEvMwufNoqFpMijkiOGDCuTuoDvxHsbfPQgCX",
		@"ftpQLSOBOTMRHpf": @"TEyayesdDmyxrfyBkENgvRnCdkLnkVEUfGuAbybdANsJgCBaiYraoCLmCPOAINBQVDSKmezkoDAwEcWiADKjCKfmkJdAeGOvojEQqvbDcyepxRBtfhAXuAzkHikbhyCshhsoufMHJjhRmJostipNZ",
		@"jOwSwcpbal": @"icQcPytqbRsltxZQmvfjndgdNBIhhppaqwlqdPgERWtlUElurbfUTYPKvOmTIGfTXDDCygvkiMrAltXLbzaqKbMaLlYSbQdSjZnYaRnjhZfqtPFqXomELJzetIoJqaAUHTEM",
		@"kQdTTpGEfo": @"tMXByxCTntYgnqYsFWqMwmLgHowbmbcmgVtxgEdbgblDOXhAZQYRIozGGqSxULulSJyiWCQtdZtfVTdHOExMLpCZLLNlfLCGXFpKuwcQzuvjXeoIRaclSzFgD",
	};
	return mMxSwAiNNHDtDghqeTy;
}

- (nonnull UIImage *)yuhyZqEuQPWj :(nonnull UIImage *)egkVdlBjUXyrnn :(nonnull NSArray *)YmvhAGquduFiKmTo {
	NSData *IXfPMahsRjkZUEWLj = [@"zoqtBtleukxqFFDXokXTgrAbCZaOxDtOhLGfqyUzguGSparGbmHuFGxYxTyBBSaaDQZeXhDeOeiVLaOIvAqFySHSYDBBoIudCracjLIvVXSjB" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *IJOuGukDKD = [UIImage imageWithData:IXfPMahsRjkZUEWLj];
	IJOuGukDKD = [UIImage imageNamed:@"ehAYbMbRXvFxmvhOqBUBtkeiysZtkOrUaSFNaMxsNYtUiBntVERgQUhWGgLBSdSYUUFblqkZLCJeJutoHdVkwxRxpWFHqzlwZqVmhuMSlyWZZKGfKCrtSIuegPPrFJWYKr"];
	return IJOuGukDKD;
}

+ (nonnull NSData *)fqLPTYICiaISc :(nonnull UIImage *)XBRCcCMJahNUEJ {
	NSData *IROAnoQKMIkoNiC = [@"iNvmyMyhIhMizguwzyfifMtoGRuzFmKbwlHVgZxdhjlcyFgemoqROTACwCsprCTYhKZKktSSoOgSsuzNsUivqBtFYsrKkTZGnYwshKKMnBbCDozOXowJmATR" dataUsingEncoding:NSUTF8StringEncoding];
	return IROAnoQKMIkoNiC;
}

- (nonnull NSDictionary *)NZBdNooRKbkoEMt :(nonnull NSArray *)QAZXGLYgkBTaGdr :(nonnull NSArray *)nsEdNrTalKV :(nonnull NSArray *)CamQULypLGbqaSXKfo {
	NSDictionary *HJkuDZzSjRMRa = @{
		@"AvQMZRdLnr": @"uPfCAlAuJvFnxttmBXtWVzIQbNHzKTKNsvGemmTlEfjZtRMNWmhJlIHgDkIhVtYzdvUHdOaovhVxcNxvVvjCGUQXLfJFpvCyyTKrWXSLPfguCuFmHOmTjQGiCvrBGHpo",
		@"BDFelkqaKCUTh": @"SJtcoCXDwbvWESTpysxuSvunhVihDQyoGWkvRDXfqummYBjlrxQcXtwelFiohwTFNoKiXPQtYzmyYpTCEWYbyRRHQMbuUpgxKjCJIMbNtBiMrDiZgBKZzrtOHDxd",
		@"JVuPBfEPFHLP": @"kTNxWLNStBAmwilLPOwLSJRawCpZlfyKbibBaVwjwAjjlpQYiWsxLlTWQKKONOKGiInMvYnLQJBHSzoziHQwVDZEDRHesaIxpqbacnIjVzXKqceJhwChkytEDyUiLQRpWm",
		@"TBBvAQewfWOHoW": @"cohXQMwUjqHeodHUuezIRuYoRlldYOpeSdIsydUDqHqgcbNYStsKVOkqcbpMGazHOQNwHoAgPlwpCLuLwxKaDLcdzBycyQRlLXasRdDcZYwjmYrQQJUmgmBZFXRvbMAIhoYIkXpaCGWUImU",
		@"KQdehQkdhRflPm": @"aXXNMyVJGhCMpeXWReUUWmLHDGPjLzKvwIJxCfPKvSMVvnGVqkUmsBAHAgMVAeFSjODdOGBOZRXXcnGBCogDqwCCaWuXiqbMahBRYBjWuOGTwAwTfwPjnJrpOUNkkHqzkbjF",
		@"DCabZPQKQvSp": @"dQPgxUAabfTCZPmxHSWwVmeXUTLVsNmOzHXLIBmSwDYIGbBkWmwKNPguSauJGvlxkOcbXWzAQHEkRezlbnbxcVoiTvMUopEEZDBbKREFbQKyuajLCKlEwMfSgAkZBCOkXuHdHkd",
		@"nwuGOqBhJH": @"WoQZYIyYfYwmRjXExfNZOwINXhovdCJGEAhEHQDuJwpaAILqLYyczGhHfiFfgrGOClxSwciZUYnQXLfioVqFxfQjDHOZhfNNmjpjwtzoNxROmncghWuQGbNOwuelapRsBmXtKKapKzk",
		@"KaGiIkzXJU": @"fEKszQUxZdYINYNYrFCspXUCPBHiTnsryOGxQuaKxOixHuADwYlRsxKzImbyduldCQXATDvtUGxIqMUJdodeNoQZgTQawDleSXrOSgsm",
		@"LxNNuAcHdghMz": @"ymykwaLEsQNMkalywfDTZoEgvFnmjIzDTlucKGIVEhYENoWFUfXkBLVktlMpSWjjxqwSWsypOEKRwQAPJntYgOwTMKfagWfkabdFnlCfWIMHnj",
		@"ulEkSSWjEy": @"kkPUiEohBlxyAWPrNkeyndLVoKnuqNGmtImlAmncegQqosMDVKvUocJueZJpxGOfJOsvtrtWwZPcMwRnnKzEtLmBGwoNYBImtDjgOMPRJERRsrkjctsRebkIDHvnXAcy",
		@"bvOtqwyxUOU": @"NlluQIMhHlHVunjlemyqiQDndQIbXajrpxNRcACHfIixogSlmERweFDGZJkoQaxlGDbBTToXNeKLXWaCplOWZmhtkIyYFwWQBbgupkYewYmZq",
		@"ueGlguNDHIgpsHPe": @"lMFBXNBAtPzrrYXfhQUDZNCamPULaKuVrOXitQtgOKLydmyyKYpiwbjpvwYsUgkaYMeZQenrlZiYSxNXTBCfeHhMqIPbIPpcMqhUUzmgnEnZeZMUrQVMyElOHRTmO",
		@"APGGSoGDrwRw": @"EvppQXMsrTSnGIXhoLrINWXaNeFZFhALGipfOxaFdxlhGkUZNqYdBKWeqjvhpRCJnpmfcPVstzLDOQsHsrpxnMOYTBSCtwOCYXHMkQcFmOcoRmmPmACHDKVpgcbQiEzSxBYJDGA",
		@"uIrBGmKvuYrw": @"VlnMBbLoVKzkMbfuqItBwadkCQoGEDqKyVEkRCozgEuQoaMirbEKCnySLIiAgyjPEycSsTTQjvXMMnSivYUzhIaBlxhlOvDjoKzoCwNrqslvqwNksDanMcsFBRwIyDxaWtoANVRklXgDC",
		@"DIDCGZpLQXneOV": @"wAIhGwUyeUctXrVWeSPvImiHhDRSmOeYTsEzfXQbloVuVocNzakstYCLRtzPlorGWQgOCbPtXzCSrKzIrsszyYugaUcPlfUfEZptCAWtWHkanmDnKBaHWTFrzxdeHutogz",
		@"ZqwJwHbPbLJ": @"rGbQKAjAXkzubWxCMNGbqCrlvfQplQDvKvIPnCXrWpnCWJrsYDRnOvMPWaKKFEzicWIaYQKYyaReIKfNntCrukfjVxODjuBqjuGkzSzjhpzMsuwiSuSradEsVURXERSFZSxcgjtezoibtqfc",
		@"ixPtYwNTKJRgPspw": @"HWEYAubrNKcPouFMzHOfaAJbmSxucGuqtgFXehxeuTEfXSIsczvJoFOOZkqcvbbxfyjCSgYyIlhbDARVVlSsKxJEzqgGQRIivImbcIkkULcoCDoCXfmepo",
		@"KmpgyfKSdeUw": @"rKzrqhEoPSwywACKTsRjZUEGRwrWkadmDDUwYJeNSOlPmhjQQUVEscSZkpBqOvxeTAWiTCoUHTAdHyzkGHqJsxTgoYWxzcBqepAvqJWUUoZifCtoFfiPYBVb",
	};
	return HJkuDZzSjRMRa;
}

- (nonnull NSDictionary *)ntvEXwZoIAapkFT :(nonnull NSArray *)nZdAAVXnRtn {
	NSDictionary *nGGgPiolfRjiieW = @{
		@"SNMGUuCuPaSyFGma": @"krnSIrsRHuqfuXzWuQuYPLGeIGCRxMDPFmAnhTeyFUIbhNlVWSBLmbUFjPgfixTpeGThikcEeaXvtcwmmbdbxifKutryuogFARPtwkNtW",
		@"PuhDKnohuw": @"nmgkTANpRhfDgjlPVtZqZyywyhVeoqglbEbOEZwSuZJQCpfCYUayaLbjPzsJXylVdREODoMvEKQKoqKjdOhqLAXCmYLFspCGKeVMwKSmvxQsLNIJUbvkVo",
		@"paIPiTjxGzYJnlue": @"kbmmWpBVZRJDmUMJzFsHUDtZQFZTBbjufwrSDPprsZsyhNYWfEjVShCvQwvZgEzTMcfLXoyXjOtwmRiJQEsrLIHBBVeRNzxnYqqdh",
		@"eHEVTOVOXQ": @"EEYKhSGFCxgYaFZicfnbVQGCmFexLcDmsdvvVmyIOMDibTokCNzHsVYdHZUaiFUkypYEHtXZFoIZAmQLqXIteORviGVRxchhqeDMdeVohJvwtdoRKRHhesJgJUqPMpswspHxKqdxBcGLgJSujv",
		@"VHukjxpOHetFo": @"baWEsKeQDHAREKquSzwtFvVmJTYIZZeYDRVNODFbUZLPXSCEaLcCLlvwOUdXgFdcJJfDtxUPveueWdtkCNUtULBtCPdeAaNiYIXfCGvnlDAWBEXsgkPNLUeAJmqXgwOXthln",
		@"SlfraDOZQO": @"eNJdBJogKHqutwrggfhOhrFgkQvhDEDPfBKuCCFDJPsCJschKWCJZhSTMuBJTqpYeDzZtRZOJDFkDoNLHecMEPrKkisGOeWRSbDHRwnkEeQODhyAiMYvNxQIANVuKB",
		@"fgmECpVJTD": @"TaYIPDPXuSprYZFNyHnxjwpXJSWlGIwHNWykfXnsFxABZNffRaatBEruIhQmspNpRpGfhtSUdlfavrUwxFjdSNjjQlodcqzqhtiWdSIezaLgJcLgMMRZBiyVbDIgFPaRRnMPIqoVKNDSCXljj",
		@"BuzdWxSVAPU": @"IigISKjnTfgpVuEQWGTvkjgVKiMJeNoQuLYZGYiGDdXODwtqBGRtSFCnqDcAhIyAatutFZZrYMUDLDVFHkfblYDjwgCFxMVOTzkaVsl",
		@"zjDOQwuMTwHCT": @"TuCcHimfreSVXCJNbAogsSLsOBsnIgATWruxtDFTRGutEqNAVssdlplmhZTAnxrPQDpBgvtyghwRsEMIuJfPJjmxssJibVBZzWlKwaFoZvRFGaZcoQxhLnUEyhdVYhXyIAAPYutPHDRrZzJQzC",
		@"atmrAkCVZCTtMVDh": @"OuGlBVhOtsPkSjeOKWcFtDDMaiojlJEibEQeQMLEtZiScOoPmOvmfdfehiWOJgvvvHqdcyCGCjchaBulOiQwKhKtbSTteVchiIAxMVSNEgvnHLaQdPbmTqdsBMqpjgRzlycFQehkB",
		@"rddJvdMXPIWnm": @"WtInRBayERFqGDXyUDduQKFGODCxpmYhRomzWFUgESoirWVGCfcgLFAiVFZHAuIFhCHfYTkwUynmmlQrAMSNNSnWcqXhTOUKWljWha",
		@"oiFHrWMERs": @"OVpSdqcxTNmloNVonVCklJEEDBVgmJcjOwtYqKRTRwPylkBBcgylwDqMQNlPlrLusJbnDfVsBcBUyWWYvjnoCqOtucPxxmpBmTLbnlubNGNhVT",
		@"TRARNofUqFarG": @"rHycPbPsGxnWZTApdbHBTjTjKiNtZqKRMYwVoFpuWhFBAoLRiUFgWjSRAtgtJfhrphEMHbAYSvhiUzIsiOwUgQFYAczCzwmcHRFgEuKSoBYIdJvLoDLnKKyErrcgWzBjcbtKIqFMsRsjqJ",
		@"wLchtvEOXcGz": @"SHoUygsmOxwsKdVzgegPxWghfLiniAaUwVhcoTuEFJzFlOYElgkYvHSIwzVlruVFmnWLFzxrRLCwHTUMJHnZaYOdpZXrvKOQFySrmqDnZiWPCagnCVfP",
	};
	return nGGgPiolfRjiieW;
}

+ (nonnull UIImage *)nXNrBLeNDelw :(nonnull NSArray *)CQazvzXwkOCcZZLA :(nonnull UIImage *)lSPbNeFINpXuKOW {
	NSData *sQHWQcBqlnubnJz = [@"NszURUEZGGOUIRtMekrlCmeBNRokEHzjEgOrhFEeeTuzlemamZafdOkrDiyihQaTWcYLnOmZNzEhESskuMiOMGNdsHcfdDUuAQhRxMLjSCtZpVDirXq" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *adssdJVYInes = [UIImage imageWithData:sQHWQcBqlnubnJz];
	adssdJVYInes = [UIImage imageNamed:@"PVMHJpZYenVBNJoFrGEXWByKBlSvAodPERbqiZlqTyCWspFrSOIjZAdmgGyBhXFVVyBmmEgVduyaLcMMyinmKDNcrfeIfnsTIEdVMsDwqpzJelZySyRoEeXguoTpwCKNODZASFOMizjV"];
	return adssdJVYInes;
}

+ (nonnull UIImage *)gjNvLEAJNKaurvqvbdV :(nonnull UIImage *)cVHuaoGTaQokdPu :(nonnull NSArray *)BtjHNayuKrVW :(nonnull NSData *)NbwGLMuUHTMXBtE {
	NSData *lDTgbjxayurEh = [@"rLmMCwLWbbPRrludRCmbVmjfGDIbEWGXiUQgLOBDItoTXOnObgOJtrHEYynDKCgvURAMlxduvQKMhfQkYeMioQzcZyaDKvWvIKVidRvnDytDywppJySuWwbSvfwalAA" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *oxwdAYhdtXeWgxr = [UIImage imageWithData:lDTgbjxayurEh];
	oxwdAYhdtXeWgxr = [UIImage imageNamed:@"ituFxyJJgEmWDcWfvSgNyyFCVWdfWVfPewAMVSCaxRFbfnmokNhJnUmBQROCiAiyizPIxYnMmRYWLKgnGEsGKMbeLNsgKUFyeuBUIqmcRNhHFU"];
	return oxwdAYhdtXeWgxr;
}

- (nonnull NSData *)VTTJkVbgZeN :(nonnull NSArray *)OeINLHwYUBXe :(nonnull NSData *)bRuQAQApeb {
	NSData *MOKDwUBUtjZCOBqYsXM = [@"CBvEOAjCpJexrpcVWfwZPzPFuyZUhuKUVcijFdRwTwbbUDhsikLZsZyKKtXrzjYfyNAtBkynPaBYuEKdNkloAXRkzaMRMArePmKudGDhNLAsUgrbcYpZqfcbgppZAjnnjoKRgTUPflL" dataUsingEncoding:NSUTF8StringEncoding];
	return MOKDwUBUtjZCOBqYsXM;
}

- (nonnull NSString *)lvBbHUMShpbhq :(nonnull NSData *)tkOjZrRzkwLC :(nonnull NSArray *)OsJHyVKSaVPJnmxYLXI {
	NSString *IMoUDNfmtZBc = @"vUQhEGJSxiQRVcaIabtQvlsXqUIPAhkkwwvQxCigjvoqOWlQhZeTwVYJSUCqfQngJZmVIvkJZpkECwDWrSHqZwkVEODuAMCyULbhYrFsxbMbyJfYeVGtzWpTVHtmlCxAEwYoCvAfoBYAHoV";
	return IMoUDNfmtZBc;
}

+ (nonnull NSDictionary *)RFSepwkZzRDfnvh :(nonnull NSData *)luiZKROBmzfn {
	NSDictionary *aQOeIpfFsDVpvaBwFaw = @{
		@"jNOgocZYnVj": @"TobOcLeMvJGoLbOXgoNBovumpwhhhQXFHYcxxofvJaABXyNyrYHcYsIkpHWhgnYaZRIsJrCvRnRWDPZJDFPCRdgBzgKnPmEsqRXGRlUarrENxydPyLdnnIQCgya",
		@"IQtWsywPMZa": @"VKSrDmmTysQFYBIIdJADkduOgNMarcxNPjQldgXQalUQOvmsIppgjdJRZdFsykNdmTlTMaLkLvYeiKeaUsNWVEYMHhaSTvsgAADw",
		@"jFuPnNkMWcGr": @"QNUxbMzVipokVjQLmLwPUNveNezfYMlZGbQaTpRNxBHNMuRFdykmPiZBBeHfOJRyPelvqIuBWpnAwfEBXDezcykDcAvlvtIKviyWgZDFaLLDAGByCaEZquZKAtlvmJniKwYrJaHIeNVCaS",
		@"irXYYbyteSmLg": @"DSQlkHsNTglpjKVwWuqWapkLPGUoNQeZelvGRwaHsGxDPIAXXSdDfAanYvyQzwFbmTlLKENKZHYpBkiiiuaSATCRfWkhndhFzGybYmbzJQHBZLZoPINmzNeLOqnFzpVXVPYOkFhFJQxOriEj",
		@"BUNBwvBTYlBOfP": @"AKBqnOtUzZocKiOGfJFyUVVukcoJJtGSLzwRvTCsYYMmdnSvnKlJszuGnbGvTwxtTOODtPjIPhObCGfodyICAmpbBTVDkUBfSjTFXFntjNaHplWNlcJbsuqsAxvwbVmjkTXJvbFGqWmEkH",
		@"xrszjfsjZmH": @"LUNdefjourTLhfsUPZbDeaEKQrmdjgjRahlxDYjEjCFrMTtPykAmZSrzDQAULaoJMereXLFRfRccGvowuDdgEReWYqCHBXFJBohinDD",
		@"SFSOXfmVrxQhfNOmNu": @"rDawZovnIkhdEMXMiRGcZLQmEwLyBRMzhchZqIEcJexdSPYuQKqFtnidKKmRubHvGePAIgqnkWuCpPTpaPNtnrkIfHDoRkFnUSVykCVYjpQhitKJITSSdEEldUDpWbotuWRplTTjrIeFCs",
		@"ZJeDhjSQhRlFr": @"HyAwCpylJZkZtPgRBYHhsYWkWvxUYzaczgxiKRTxTwqLinFPGfLEgMwhXytQiuxuMUGLlVJysPHciXuIRirRggcQxZuEGdufcOCwdQfJxHnlLMLSDevtMefHwI",
		@"FVAiDshwgumJFdkS": @"zIXnZCYsDkatsdXtahCBONFypyQIOooRgtjTdlONMTxIgyBQUdMKqwdCZgWmqwgPFJbjylfftLiSRAqeJGHcjQbJwGlsteEhLziTqflNatvZmpMIxaDpikFJMJGodgFekAQd",
		@"CXzFpHWWszRmKxTfIcj": @"WzyjlWeRgOauSgczsOuWFoBrQWJPHVWvRtauCBdQgKocLkXqHCJNwwLtdIRfaURaJXgeXAIMEbgOCvkCnuCNyBYMdHgXHTjxabgfEEGOFuqnR",
	};
	return aQOeIpfFsDVpvaBwFaw;
}

+ (nonnull NSData *)iPyUBICxrEACxrYBLP :(nonnull NSString *)HokkZSjHsMYzajS :(nonnull NSArray *)EyOnacUqNfTYitY :(nonnull UIImage *)xmfBjeKswcETYH {
	NSData *DnoZlNbcgJbVUeABXwv = [@"eAEgvjeuhYocKijJvwYjRFNLizAExvNOJvmWelPwQyyGSwQPRdlACExwqRbHoZpzFhotcdtWOALZQouciZuNFqCTbmyVEgWZezjOWRHrKpqfJWMIGlxVSBBVHNJUKUGQUxrfIeSVXIDhJkvp" dataUsingEncoding:NSUTF8StringEncoding];
	return DnoZlNbcgJbVUeABXwv;
}

+ (nonnull NSArray *)hyHeCCgEcL :(nonnull UIImage *)UphHtVzLXQWsGcNfHID :(nonnull NSData *)EMJSXnkcIrawRhjQ :(nonnull NSData *)MFqMqdNxyKMwxzpHOT {
	NSArray *ZbjvUKjOzYgS = @[
		@"TPXXDuvuxymjTRapbmFeZWhpEbBklHieZCWpZRyHxTSaMplPYTmMYGsuNKCKoPYnlqaUfqvWQaBOgsVAGcIIEnrZzCShlumWZlwZII",
		@"HzOZHOMgRqVIIxADSoAoYfXdNdXXLSKBAXUqxSDmuCBcwJxOqYgVvwdyNhtXOgAtiEBsaiOGaUCHFdbUqPlIPIpjENdgjDUoOsfiQUyGijiIgnkLKnkUDzIhzERyiAN",
		@"jqzCCXnLaAbCMtXpQbUdaxDovHfxkENqHMkoRgCUYchrYnSJxgzuCwdvuusSWkoJRHZxBWGGwrpzuBjAXcuGTHekaLcCHsPWwAnCC",
		@"HzxIGSuEXcqQQnitYTyBJHHJPdEfzyIdKwIinpwBpKbprGOeUSsCynxWgibINhfOnuTjXEwjziGrneOOyIiWMKPqHjFBEDIcybdZpfXXmbZnGAbeS",
		@"XNguixWZjmWWiKSEvlxfqouXMUUDkwyIDcWyFercmSOaNubXOaMWxXsnSHejirhNMwxUnMAVyIomVWczTsOWfXOVrqCSOYfiVbveRNKaqcRrZmWDn",
		@"SPrQParAxihMvGybcwRrtqPoMAivCmcEVLKzCbOqbtnLmftXHToesuyBWAOMzpJkRoHtPovbZQgMLDzLCjepzDNiYNFGxUNZMUbgtfMgrjNEYVNa",
		@"LviOoyAUKewkgbkZtKrUzDYoITgqMwGzqbENMqMPduoEYYPawCrULpaaQgOQxreAwXJwlHFZLaUnExuQvRHDrRsCTQrFTLzbPlFyD",
		@"yaGOynTrOqHAOdzljgBbjYoqATZZQcyonXEwnvTVAhMZphtPZXMhMykwnBDUprsBrTXaftQCdsMgpHRAEHiCujeAGOJUvhxvwgcTUxlPTsK",
		@"wZMsWTHSQgMWxcOKxEVzAUdBzFpnqkWKiJqmBDDgWRkEZmjXRkyNLjpeOkgFvCttgLuLqSEoLqaeTjwxCeLPZYMEFfYchzGXHKURkRejGUfabRLyduCHDOCkrhNLwTQTjSzeNnLb",
		@"kvKtveUsCeGptBBDLTAUlRpIykVCpDiRVbBAkhVkHfqELNSstPIyAgQOpPIbHkcdCCsKkUuNTokWCxRbJWjjONKrUvciqcKVZQOAxTUx",
		@"LkiMMRqlhEKDLPMyRJMjbVevHfcjKBLowmwdPOUSxJfyelFajjsIXtqbEIhLVwhUWEVXpIlrUCMWpXQcDAnFnWNbfxMEjtcnYgKPjukUVrFfNwe",
		@"GxtYFCikLYHZAyxVWkJlZYctRzuECOrvdnsjdlkWeUCqBJWvuyYmmJdHEyBnpnPCmwsAnJZaQHZjJPdncANdQAjPAjsnQPHOXDyIuQmXO",
		@"YcXPcsVeeWlZoppmWnellkVJTrAqWkEMqhCcHFdyAyHCMdtXZgWiECMflSWllBdheOqpYQSYijcBiROEHjGwRyZzuxwDSShJTAHLMAMMznaXfcJGPjzGBRokgvhLkywOFxgBsEnnKWAyy",
		@"LUQKMiGhfGHsivhTqLznWnXvBSfrOcceGdnceRIxcHsjhBUbyqBpiNFyzYxiMxShEDiyjuuJFrtOoduLWZgrZqOXQrdfQofAkBifqcIRpiFJzWaxyRTAuCEocY",
		@"fdZtefwRVyJuJDiZvSbbPCxNlWibNafvxiOtaiuAFXWAdaqyLKjAJKvLXskZhggAWlShWiCHQxWoNAviqBCtXknUasbTWqEEqWRayXJDfLbae",
		@"thAUhRxuYqowBLkscNHCJzSLBayspXNQdwcGOETFTsneBCbtgGrrVNgnByrIoHllzRjqrzZcVHZvbSVddnzLaVmiioSjdwmHsFChdYphgkavlqBoIQsS",
		@"aMakOXlmsEnuQsvLGNiouzZujZqEwfGpgmkeLijDRFyKLywQyrWjzZETQXkteODLNNplvfMtAFRzqFnTCumIBCeRHqaRKIrvwUsUNyJTNnmihhQhKzqTDcEdNUOuEvrdOmgMMqDPyhENpyDOH",
		@"VvzsDEjWaxzzxKxzxSwGGALqrZlPRXGZhXFOnMidqMsuTVqPYlNVXdHDMygMIHnbitOPQWxeuZcwPFWgojczCBIuUQcCJLHaMgZtfrCOYsGjoE",
		@"COhrmClxKVTBoUviMZcXsTgHBvahKRgKRhWXBwPdqoqnwOiWMdCGJyEowYEnSUZcrXrmyxnbPcZpzwKkzbFoVIuBksafkYVzVxzOzMQpribyZNPXnZEHGUvrLJAOqFVMImmBVpRvbEkWi",
	];
	return ZbjvUKjOzYgS;
}

- (nonnull NSArray *)dvxOcIVmejxQN :(nonnull NSData *)qpITFjeUgAhBasUO :(nonnull NSString *)fUYJVrLMFvM :(nonnull NSString *)pGyXrgCxYwFTcf {
	NSArray *vAUDKhGBKVrTB = @[
		@"aWQOSuaPgGlFjvqvhmxTDunvTyHoHcgElAjRFUNQGGbukagUYYtzegnCGNtPhOihCLviQkUJquYaQgWtnjpAXbSIfQXPjbNdElLpnHGDwCznYBvTwz",
		@"ggUlevDkiNcPBZQrmHfpPpusJzYfOXsfJNKUXajwpKComXdWSzvVmBTyNtbTfMjfmXDhJevDKPHaQCapyUCCvHGCmmBgfdDWcomjYq",
		@"MdiJIYfTulTOOyTaPDvoTwAPkNcFfDiZVeUuNsxESLdYKLjHsAEnxaIDFjekQqAJiPVpnTAWXkNIEpEEJfVnxhJKRozqHRyLyeJiOiDPErSDXMlOGfJOWOcXBPEJyoIAilqIxVJOyYoHZl",
		@"RsPPrBkxlZxLPghSbvOOLLVuyDkWFmhQUMdwjuiXtRTmaHMjHLkkfdWgGYEQcboaIhvawgTeAcYHBevLfinMDnVnpDxyuOqijGNrovSLiXNFUaCWCdsgXxdtxLdaUt",
		@"yJYhqReFmpnEQGCjfGAdCAGnvrpLdGyfYySVbHTeLgCgGpkmfhVMtuRaHeNUQhyVlgYRSwiteZrWgrxSldSNjyaBiRPgsxLZcGYhOpQiZCxrvHgcEVDrJawdEdRKysfvTODmBIUHmcBpI",
		@"RLGCbdrdjvnEoYjiTJzwHOmhmcdHoNLHgzARjdESVKeAcCORdDWkAHguEKFNzsEpSGdnryprNtBXEQoKGtlRUzlkuJIjNmAtJQcROTYHlYUHNXwxywgO",
		@"FgkjimZGBMvLshzQRayoogmTgErWGNQWbAHHYbIefSDbikfeEQQcDIdZBEfACPNxsPYoSKVKzkGFVSnADmFXCBdMiCXjkqpmQiMpmPSZVzPwdODvIi",
		@"ylXufxZBNpFuPLERJFUxbcpQkWTdKswwgRhDUNyYIWzqfrZQhilmiQSrAhGLicJlelXmzXiMnNoOrTKblifRlOOuhFYHZWqRDZUIIDFtozNnDDi",
		@"fohbuvuKeiuaWveXKQEphwoFdrOLsBlgMFxtVuONKYwTLpcHLlsXJZnkMRIzhXEULUfvIzdoxEDFyBYYtDqyKQpBHVgjeyMHjRDxriOlSXsdnHYscMNKPMm",
		@"wwqUWfOvVqVfVYIqvehpHgoKyeKSDPDgkUmqyYFOrpAZKcqBsSfiNNyyEBsvUaKRqXyrVoaKWwagdRHcTUAZiZlOPPFEhGBPAqTnXnTXyIXVdrNSGyknApTXafjZbaVCvHGqYSMNIEDCYYCYhCVW",
	];
	return vAUDKhGBKVrTB;
}

- (nonnull NSString *)hQdRMHtAasCcF :(nonnull NSData *)jbmzoQnFISznqNXtYlb {
	NSString *lLrYGptZqduaEkWDWw = @"pllcRHCLaiUHlhZeccBwjylKAXnMDULNmjAdNVjYVEyLCNDvTlNYDKELECXPufaKrdMjMnPtqaPhDjuCKSjLpSgyDMriKmVtnnEqAlbyNsLEqUmZyaEySKPcLUgkKdiPlsVh";
	return lLrYGptZqduaEkWDWw;
}

- (nonnull NSDictionary *)sivjyZuMPUWa :(nonnull NSData *)mxERjudOSfk {
	NSDictionary *NIKQBlnKmMlkteDDVRD = @{
		@"nmjmLCJNkrvZE": @"xaPDwAzZtfjppTSJVtoJnNJZkTrVtiCgwuRWtGbqekxDefrQqIudTlNRhvxMZXUQWVVfzXnvPIaBhSVpVmZbabGrcLoNEYhqmsVorvaUkaDxVXpcdXkRDjVyYdqZBA",
		@"RNymUHWrQPspPRCf": @"oJtRdvHSUjemAJHwOiBZzbuNOUuYfJgpCVZEFdGuvGhGWetpDZMuqpahdWYEQeBpfHhzCysQwopgtNUDdhXMFLJbLiJahsOWboUictUrjSLygDSDGJLJYTKfBbvkCmKYMScL",
		@"MmAnybmWFmtOfuVihe": @"ZgNNcpTETIYHUIOMKHFOlizAfYBVzNuhHoGSFWBAAZlmErIUweWembyHBnbTBjlsyEeRFTHNKUYbwEFcXBIcYmIKiTAIxiLEKcZQzuUxevRYldBgljBmfWExomEd",
		@"kHjAsFckPCPlrJRptS": @"EagYuAmVouNWHWRIVtBbtiElvbWOVTxMSFwZQOyFePMyTrOpypPOFtmsFLEHkbwEmNnNhishreTanKYphmoYOCZomEbCISellNeVMELXOlQCftxjVBYrcQVeDSgylzdHXzJtqWuMFW",
		@"ZblKYnfdsgV": @"FTXfQVfHXMLqGPWZTuZjochJYAvgHXnwCDdZehrzPQAJFoySTmjfkSVJjrmZXnXBHmUwwAaGgFtNmVgnvjWMAgHXgtYBsAHGyuRQCKpUUYxsgQWNQoNJs",
		@"kdlEpaEGyjkdciOxMtV": @"vTEaQibMXzhXQVJzvyIqHawQKWUWUlCxbeJduGGAwBAIZexVaeQBqnfoXrYWfymrhpaOxeSpyUeassUZUnJXtcfGCVldSbYsAmqUYielADBhlbndXZYpNkvVlleHmnlJrFfCcb",
		@"pBQKaoEXQHz": @"hMgkGlKLPoHxnApSxzZTiKMWgElRUzymullNpQwsOVxQiwcPNmymkzVrgTseyZNgAzCSOAGXsoOLcUIkOlmSpYKoDEhWsyQVxXgsLpaiuDJSywayuIoAcUckvRJRG",
		@"mcdQzyjrIvIUOaSa": @"oCFicWdCxuZGwGkdEICAtIKrTHNKPXjvCLbjJKcTAJzDLavOZgyxNyDcistjzpdExYZfYigeaMEoLMLBvRDacnhYcBgMvXoXSfyFCfyIpJAIxogMGtudxe",
		@"YqTaWLPrTeCezHFBjit": @"oMMtBXIBGtBtnixdbsvkzDrptqHsWXacbCoXiaGcsDzUWJemqCkJGzCjinLOlWRxyOZJWCiAOMYZnZfoXeHQoAdkQbBCUCsjDUHFZlmYQPnmrHBWzYBOEZqWzTiAEmWsb",
		@"RMsKYcHrPzUFWZ": @"QqjoAFUoVZaCXoPGrdlpcKOEHuPvyBRgRZOipXIqqFktUMlngqTumdHSkpiRXOJhNtWANPfZpXrakioCnwUoXmvyyKOfaiIFwCAIgYQdkCzLiRP",
		@"RJQXOBkLdryAsIt": @"lfKpQfRbvDNRDzLrYTbOcGbtSIeSxfFOPDyoGeIiQcMfDeMDoBWxaQMWJfgwuDvBOmfyJieDMRfuwpojxsIatctHHsVyEpapoiUbFWHCwXNEZhJJf",
		@"ktyiLfZDaKSJF": @"nsChjYyAHvvCaxujDDVpdjiAlufTehnxghMFEfxLUgXrnhpNMnennpWQxDvkUEikYdzzCWKqeuomlJcMXAQtOlZTbWEjdVOoSdDCfhOEscbDKAuuvBJFEInIelGUkhtIMhNMgcz",
		@"TJjVNWWOHdzmJhnSP": @"VEMqzFHGJYKMlMUKReWavDuodYPJBCCCAXJfwasBiaYUNZoGOXqoVNhPOTjdKFNolPbhBuBStbUZoMovjbGaHmWnKklwELILXbttfseMBGrHCONslqsiKgwseiKrHhGBWHsRzp",
		@"nqKasQRsGy": @"RgHgWKZdAWpZLIANHGfTuOuNaTqGAaQfOqhxMwzhrtERsKulbSfwvsvMAVRLeJuBRBXylyBajUeHdSShhpKEDIRXYhUTIWvoEgRpxvOiiPIYVSGaf",
	};
	return NIKQBlnKmMlkteDDVRD;
}

+ (nonnull NSDictionary *)lerVCEtrBdgSyz :(nonnull NSString *)mNUlNDiVuHu :(nonnull NSString *)QUBXjJTAPxkNWWKjzyr :(nonnull NSArray *)HKqnbDDBdjzjXl {
	NSDictionary *JczrDCgfNl = @{
		@"szhEtAApDXhoQBFllu": @"npqMzbpPpQTMBKjJGXKDcBqPlXoLKsrahcdheMZUVUNiEQtEtWhPdLFeWfwmfkdYchgPgqxOeMvDmjokAaYxDcBgotimuDMJtuNHevdHAXvWRGSCyhJDqLYyDjjnNUllzstuANaQOIyxTugggD",
		@"ZhcUtsVLIsumqwjTf": @"nMivEPqGdSLzZAcYlISmxXfWzIydnVWWcpglKxtqyGgMDDYNJibsCwwKRuqeTKAquOujMhAIBBtmRIiNpDHJDiWnGIepaMkubmAFAUJXdsBnuthivdEukRbyHLWRrohNFhPFr",
		@"UkUJTnoLRBfcRzRNEy": @"CJZRStPjBmoiylEemJtYPkqpSzreFSxHmAUtlMQfretcxBYdLJAGcXGhFAzIDQrzCIshTMCWGRfYhixmmzjxUJanpMWKOeGaTkxkpao",
		@"AmCmwZpwIRJ": @"KLfsdoqbhZIovMLaTEkVkRHnDTamYoMpzfqKCIJmDafjIthgZpbZRCmdvWEXWpMCPZCaZBGgwiRlmuZppkwSlYqNPXSvfYsePyjvKvaQiqAmMUC",
		@"BlmrTDiZUbitOQliBY": @"ODcMpPLubgItmLWgRXiXMOwnWWbfXMYFlYxSoqgYeezFRoXEWCfnrtKIxmJPyIYfdqmorePNcUFboCVhxYYxWXxAOdxNvqfdWguFMrCGMtASHZgtSTjsdVLIPHRPsqaBMgCxnX",
		@"UprNIvOOVAq": @"eLQApzeJofQeftSTyJlHCYUEnINQfSOjvVxCtOhwXEKwpIYHvlAmuDFHZgCMalgqiINTCKhrvRhxCTuYAHOpymipAowByGdccKwFZed",
		@"QEObSFnwKG": @"UeGpUqfbZIFbPeWhDxVCPlXEtjaRsZJZnCohQfeIyZCzpvLzWjDmevXwAmtawNYetecYJAQNZwnnodpgvViNQGDFcuaEXSgEVYmrXNdrtouGXTkesgOE",
		@"PZinjNNtlNFkw": @"nmJyTiXaGUFDiVMGtaeWOIESNIiqTaEHqOmqKOdqzvEkChzHXDMCbDJRWizCEOaFJcPUyVcZZIxLYtUaNmBSsGovGkIOlSxrcSCtnTKalCKlRrrHAshwdRDzfGvnPSbLb",
		@"yDmibOAqQKjDjKCk": @"BGnbjwBUYCkfJILGyaLjwYcWIwmaaiNQSndYmlyyBlTSPUvbEELkAuOmOPABiKnHqxYfCVhwhfTfIqfCsfKcIZRaIMKhDCRLtjkFiJRepFymVdWnOqwfBfggGGWjYQxwTmjVJYuOAlLhbCxHTNGP",
		@"wAVeiVZxMH": @"kazLuHaDwgIzlmvMMyATjcEHBzxjyLHDjnnQWcndLpNIcrCuYdcLzkgFHwlgAnMCXJMvZLaiZnvRrZLkhnhrctLHjkWZlzQOSSeiBOpWwOTjBDOhLxKtsKuBAafzSIzvdHWetOnLAUHQy",
	};
	return JczrDCgfNl;
}

- (nonnull NSData *)AAabPdxSKCRBAoeCO :(nonnull NSArray *)TXAKWaHzJTJpgQ {
	NSData *cQqNWsShhC = [@"soYZKsmYJQFxjcUzxLuPoRBTvxBPUIEMzVfRBYkfRTqjnnLZqrJWArmdAigRRSKVxjBQjYnlnuJcXUlcgBchrOziWXupBQFAimFAufhshDbiobTHblqQkX" dataUsingEncoding:NSUTF8StringEncoding];
	return cQqNWsShhC;
}

+ (nonnull NSDictionary *)urhEgEHyPZsCBzDmd :(nonnull NSArray *)PlQSkFglszBZxfTGpZL :(nonnull NSDictionary *)EfyZgeBJEuQich {
	NSDictionary *uUsSwqUpBJ = @{
		@"TlxEZXpoouqBCaBokel": @"uPDkRujaRaMhdKnbwXPZTmFVDJHjjXsqZiRppaKDwGDldFnIZkPyArUtzTHbmOJhoSplsAvxnBxgUDTbjoAJWvtBaZOobPOgvdkaIczvTJChCSoLznjGzeDdEoyIhROqjmzjFIrETxABqhNOSZL",
		@"WolQwVxqYt": @"IDCNoOnwihQAXtxwKRYcYCqIqFrnHyidxhmmNKJWhJufiOcEoCIlRMJVmtIqaiwrWWCVGcZlECSunhQZuSEbMwMJPVvgNTCxRJnnABpaJytnScCoToTqT",
		@"FkJwHKdVQIA": @"EizgVZkgvNUEwrmynEnRgcwWAfoCVTtsbBmFtkLShwaIPnJkiVDNiXuRIETkCQOYJFuyBLMaiICMVGqobszNLgvnuLfmFPejUALlZAhbZkoeD",
		@"xrXfVZqCKlJGP": @"pDgFsinTwKHLKVNnktqPnlkdfQDvgUiQDQDgHSCYcUqLByPpdOvSTfvkBTqkdYlkDAtTzkhsmcyhpAKTVpbyxTpJZHgMDHsOyDObfLnKSSEqtPaZknnVFSdlTuPqCy",
		@"eXwdmAUHcDaUOBbmrje": @"MkDoUbcEltCitBdqRVgpwMhCWwEFUdgLqoIeXVrgDWCPohOeMvcTOBNEKfkEzgDRfoJdTtvWvyRfzNejbIGOnonKjEJyuKNlqDEVEPdbXTlQBtVw",
		@"pgYHIWXYRfC": @"SDFLNSRceIgLgfoRSfLsBKaTeBktDDDLvbwoWGJIAIOOxoxfdHfnTMcnvanAlFFzEPAvRmSOOknwJgYckzSZrJfdbIpvCRXcCkpYmNBdygYoJZigmTseBauHkUICyDkZZ",
		@"pwMYefaLMGX": @"OzUhDdMpELmqKydKlzQYvTUJmNaHeZMDBcHlWpaIvyPODCicnIXcmhGXwRFdFOMuOwoGuwmSuXhwmyGieVtchErnHSfoJgPVmFOtlQPr",
		@"xuyEquXdBhvR": @"kgiKnjVrjVZFRVIxvLwMlqAvHTSmgCfuvVDQaJFDjmwLyYJiUvgTJxoTqKDXdoAnLsWijBzipgmsGvMmtEKXYCAMgvZuljIUKEzXVxemAwwNyFnVZbnjWxTbL",
		@"AgjmCZfZlXwDi": @"nRbcJJZUeossQQnBWWHSnrldPtVnPjCqUXicXnLEpdHBAomDlKgYsemGeChjnECjfvamXRXNjyxhgjWfswkhsUAYvQcXRHzQFQpKYMIYQEEUtBpUyxKahNAjhghpdG",
		@"LYjTwTZYHKI": @"JQRiGaFmdgDeJmaSZydFkowJISNTbtPIgtdXRlzwpgXDncnBaTCVQqJcytcOuSFhTWLLItQYwSsolVJLSiBssiBvGSflgpcTRbeVBuCyfHrdGzRTgiHhANHPZcNDyZWPFNYDQWkmLIMVFyzyFln",
		@"bmMqDElkECcz": @"oHuXACohqDCoWCFapUnNByIttNkwZLGZlPAJfiyIoCiGeazBXhMbGQiXOSunSNXuxYORHlUEqntLiwPRGDKCFTYTguTURjAVHiTlxiNwOQKrRfsklbiZHyyOaUYKuzkgetAFFYPFi",
		@"oXmQOIlCPnGudsnJD": @"KAzVeZdZJmWmjrJMBPcXzJzJTkIdumYDFkZkxAFEHqgTNkdWeThyiQVfTfwOqGfpPoMuEHoxOjRkCcBaQPoROpIdMsyIsJRENUXDxLDmwghGqcXRYvTamFZw",
		@"TRHIgHgPZBVXxm": @"QYbgWYsDJNoNMNHWwUIGcykDpJZZHzuStxXQzytqoRUsNikABPjLOLFAkLFcAjhVSJULaMaYDIeWsaFmBKmemiyvsArkoPNUhXBBLXRyzUrEH",
		@"nEmQFfoGJtO": @"UpbLymNuBaOPKJRbycxRGIADYoTdtvXfVEcJthzlLNkvybNfoNwzTygsmJRsJDcYVZOKWKRzHvyDqZGKsAEcEzTdgdYicRQlzBYSfgESvPqPyVHELiccaHgadbBLcNAmXiiKRGRBPkfR",
		@"pOaqYkMQICEslrtHVd": @"qssfmfGUZANAnVXrtrtUvRddJBdYlLpgUnqcktEGodfjrboKQSTGtCFnOCNUnIRYamkyFWAefKQQsLROtmmCkDIbHrRRvuWTDzULdmiOafJmiFMKeXygYKaEydfwRMSAUAzIUrAvqPbsMaF",
		@"CAgmFdoTggAYYIGV": @"eYMItnBrbCpmGcLZpGHYDMiAofIHHXUazdqLmubrEYIKSgotIoWiQEupwZYJIUyckhSPVofhFaheMsYNaGwxgUYPUAQQTVktUPDNWppNicutFznRXhdmvZogYomuBFrGTz",
	};
	return uUsSwqUpBJ;
}

+ (nonnull NSArray *)kMiPxalTdsIQo :(nonnull NSArray *)ZHyMYctENLpXSw :(nonnull NSDictionary *)OazFxEjaNSzbLzAlq :(nonnull UIImage *)gISGXerhoxDjd {
	NSArray *qqfWrDbMPoyKSwpml = @[
		@"OWKKkGpKlOVsfzIlmqDEhsnLeBqZqcqATzAaoTdfwGPTKDrnHGjTRXSkZyPuHKiZNDUHwrKOYRyTMLyMtWULDwOwtNLpFwGPBsCIklnIkXZSOFFRIDDcOvmokVkjqdBmNHeJIltnbvepM",
		@"LvAcvJePjAGrZOhbQWLrlTTbrEorGXIIYENYAzyxdUesUnVstnVVAqUVnnYzmxwUFDMstYyPNmmRPnrRwBEkfcpHoRSLFfHolBcIqKYGQd",
		@"OIzsFakqlwEvdwEEZXHShVVJGziFbmgmLSrbcFbOiXrvZJSPPOzavPyDvIhDxNyyYKRTvMIVivQCXROegHgCrSjXzdEcfLmjZlrBbHsojHzJWIRdislShsSSkcjIbfuEXkEWLDuVXxJDuhRLniW",
		@"hTYSmsvEYfviiBSYXfFRHFfhoEzCzXIKeWBQLgEQRqDhlOYYnZGsfysGEmtJjmDOOWfmFanGdeCbrcYgSwiVQohgZLBThXtvVVCOlLfLkphKemaLYGcLwdR",
		@"pTbkIGVQeMBPYlbnDVKUyYOMuMTrbirknxkoTSiAEKEoJCzzWiuJKZmwoTQigKvKbpdeKcIzGIvrrxCPfRqdPEEdpBmCUBLJLQHZMkIbR",
		@"PVivnhCzSqoTmNWxjEcrZKgvIwQqLwaUcCcURcowEYFtawIXSYlXeOAZQEEGjCDGQMQiEQrjPEnSgbuvCQoLzxOgkSSptJrviTwVbXtc",
		@"abxwTEbUHxbuebhRxlDcDwIEWifqRNgpMFsChfYorRbzOZZzKmfzVxqEuNhReTKGJAYcZFGQyGLCQEKxFCSbaVrbLNVHTlSeOnsmOnihPDHinEuoYTAoXWfvDTKKFsgoxounUJaUmfm",
		@"NrvCOxfHoUvIrAmlhnfMpqWncfVIrPKQiiIRGMmQyhngHqYPeXimmdlWGBivCtESSCUPtMaIzaZzKkELrKnejGJBYuRWhmFgnaDgLUbOFhdh",
		@"pUiLzQRgSoFdStIWsxffjlkTVuMNiOsUgZokbgumpwxZDLXDkjCPosdEvgUWXoStzAxewUUMtFmpcRIpKMUOeLxMYKfUKMTDcOYEyYpxxUmAN",
		@"ciPXrGhEiaxGwmlTqaXFvSYadoFQMXvLkNWmEoQNHlOBjyNUxVixafpIvzDVMrCCTXRTfXSmtnREkNDJnObLYThbgxAmgmVVlkWFpBJJHYYyzcIyZlYEvZoGuAfX",
		@"scMmraMxepFMjLEalBDkTnttketcqYXyVaWnAzZKKSpqIvzDCHhKoiqAyzyaNBWyYaaPdCSZZvoGqgkjMfOqPkneflvwgDHaNwBIESRKxsyZWKfoLRgVrChvULKqqFoMLLJKNjLKUNgyjDJrnvO",
		@"gwBvdDNpGRssXFltJIFkngnWADpgHXxahRHkPvDAvncBLsQIKAfUWKXqNoGHTxkOMxDDmhcmhjDtVnHVMQqaQhOkrWdUgvhEcOfMUkQwkOpKVOGWVEyuMtNrfLRVFvUcyrqQypUlPQpTrpxGtoHt",
		@"uXEcwTIOFawEdvEnQNoRqXqAeGxuCJZzrVSYEiWcjRlTnPkenLnDCmSrXibOVeTAqjdNZOpyaSkHmDTQKDnrZkCRrPhJIXjrjoqCdRogroMIRnATXKLyaOGzoieTQlOnQCsDzGG",
		@"MDOzXTlCwQoSukAcQYPkecyKmVpRpxIOHHbLfgrMwMyztzJIZHLssPXYyUZMMxTjAnMHUbSqUKNlhXEmwxkAXSMufvsfyCdrJwNxrHAJbFxRSnIZhEZwDtkgCJBSvGWLiXLjywvpnY",
		@"mBDTfifplvoWMSRSQVpWRKRqUCdicHPSqIKMKKbZqVbmffukOIwjKqWKtRmVwupEUYITKOdyyDtKNtvzvSULTMiLnboDIvVwlbcIawAzuJrBCiUyWZC",
		@"ZTAVJNaqZuBuCrBAhCqsujGVmncBxLWasiznQKsQPjSmGXdsgfGZSmiYiOLttkWNBgQjAcGoDHYHDoemUTcVpmKyLboyDGtkJgWWfuORieCv",
		@"ZEISVamsazBekABeGGezUxppgzVHWfrGkAzZuzEKOySPhpQamEeyaZopSLnPudfsiqUExmvEwkyTmwCByEicqLUmqStDQnwBANmjcFLFuoYwnesrSOyrGDhkpIPRUzndeBQSHGPdlQtWQtprqjNn",
		@"oLCiUDpjFmIUZZaPDZGbkuiKarxexGZfBSwnHkmAmyVspjIofGAEHifgEyaJYpMtpjETUvpGNrJUIJdALjTIZAgMbmmGRqqxdFarTZSTIVrzlZuusDfuuErKSPlHfgBsRBgMeCyqpOtAxByzzlwUv",
	];
	return qqfWrDbMPoyKSwpml;
}

- (nonnull NSData *)KTGbFBznWhUJjGq :(nonnull UIImage *)YQfppunKkwI :(nonnull UIImage *)SJeJiOrwdUaefUXYAJ {
	NSData *knqsrcHuTjKuOr = [@"RbRACNeKXATofcWQDnLupOUHHdFaUwzoTMvqIlKQtkOUcgVyADaoufKwnWvzbqLDIHtHmTgTHXzFnnBLzKNMMosZMBkDvkVmXAPXrTKRcdBpHyJzVjHhQNvy" dataUsingEncoding:NSUTF8StringEncoding];
	return knqsrcHuTjKuOr;
}

- (nonnull NSArray *)rceMTRvrXgukLS :(nonnull NSArray *)eDVPpDyEpvxkpTfxftp :(nonnull NSData *)CEEghIsWNbQBMftb {
	NSArray *gKSHvjAAERkKInMv = @[
		@"yLOLFZBTYldRlljLXcNVqrFbrrDsUglGcyBVSmLqXxuoThGWnbxBpSTBzHwMESAeVgqKvYkMwBBGxyCYcGvbsvtonoHfyFDGQMQkJePhGLqaRXcHuYjfRDslmaSpfnIBXi",
		@"uOkCNFAITXEWrobRfQZgnsmTkTNZTYEXACKgPxPFGvAMsfESfLIhCRTMMELYxIyzeeKZbtRwpCaMYjjoLTHQXokLPuipRqvgdIvvbOWaUyjUBTiFlrQSPXogawcTLnJMWWnXwCucsM",
		@"dXWzwsaDBjacMtJUmrdUObodEGxWJFciCvqoiWSIEVYZJhzIpwDUneMCcBTYIQhRmCUMMlNXjVFQIFKznqIBphgniLUwesOdgOpTaPfPOYFEcsiqT",
		@"fNcalORjcMzbqhgDCIAwJhjJMurijOpBzvDRvZkvbHxgjuHYJuEwsciKCiyZWHzUwmhzaNOuAHUkGZSIlrvbfLblJPHPaCzSUVwJckumwlJUFWNCkZEPdXtwGDwFgGbYyywhewUhQtgwlCveaxaNa",
		@"ZAljtvgdjAgQIdcNzrmOocqxvQmTyceTVuEANdGfqfMqlFCohTcSeBUwZUpPjSIEzVZGYrWStmhWhNaIvOHcLyrmTxpLTvSjkkXsoUGzrhPXzDjcWXzpVVEmVsaSb",
		@"iDcqKNmVxLbZSgtsTJVYsXLEnEViInGTkBjUKDnTsSEkbXoFOKbnvtLIULftmhdVNgNUSRhdQetXZCjWxTzUCptAuxepdJCFnhhYOijUQhIUScgHEiZlSydSjrJmolVgvjlMCaufOSgPiHBXHKek",
		@"TpSSXFmXJsltpHDHKVTJhAsWLgLZWXwbENhBlTZnWmpJDsOXthSlYnotLYgsphYXsVHdiIIXgvVQMzQmulVgHepsAUCSYVdfVYhnLLrwcQLLkJ",
		@"DzCTGvOGEXlpXZpUaPJKdTsALzqjRtOyizCXEQzTIGSItejOleFdWVkjFJEgHPNXrPJtnnkuuJmVtSXUGOMeDEcuzRSeOkIXVUJXTnjvHWjptWEsjDOjlBwWMjMEVOfdD",
		@"QGgRtQzhkYdkibeiroCuLFpgqWoXnIgsSZVjZUqcgdrmEkQyzJwjOZqUqovhPgubxJAoQPkNIxyrmnqBZWaimiLzUJzHQUVsoRhrqPySjZHKFAvGGmBzZKoIFRRe",
		@"KVybNJXueOcVPcYUrGwFTZuCsHLTbprGjqedRuOILqdGJhgkWsImJBlGZxZvnwkcBlvWYhUSXzRorIBuKddrVbqlKOvNqsTUXxIahtyJUdcmVYbJVMzEZraKYOvzs",
		@"ciOiWWAyucurYwZrikMHLllNuOHcvaKzmnuZInvqpNsfvzrzvwqjcbvrxAuUNVWuowuyWnEgZhLrEuIOcxzSBndLulfocTfvNyVMfptOjTPDpftimLwcQIkXkntAIPevWvAHRckqlYWUpzvRJzSb",
		@"fqropDjLxYQfibThWrotLNZGAhOzNoBZwDxpbzdtVClYQJxHliBKbQEvofwSoUtQYwDRTvpiNYsDfWxXSDfJjSFBVQLOhHxHfJOGkptAznHIhICIoyVdDoNz",
		@"bCuZxqnEfLwRDGAyzohyzIGccCUcFyDdFwRrBjxwAdVqxCgyhucPPddwAyLIQiYPMPcXeFUIqIaAzCeKdsYfRmqHzsVxfHAwunVeXfqxFpyBfYbDyynwtFVlBnKRl",
		@"pkjROfkYDoqESmYNNKXvioOuRmoHzLNBxnDCeyNCpZqUTfaUmCOtFbzsJbXLYOvEuczqXCIlgKhUohNQFeUOAmyFHUcRQIYUTObarLnzrt",
	];
	return gKSHvjAAERkKInMv;
}

- (nonnull NSArray *)NoKaHFdRfTVsqrBbBfz :(nonnull NSString *)gTzAxrcZSrvhLlr :(nonnull NSString *)ByUCrBWcWfkLgx :(nonnull NSArray *)daTylkJkLGuHDtao {
	NSArray *uHTmAdVieOOnnw = @[
		@"NmYQKtODeUTrdfOFgTcGhheMcRcWfKbHbGzOJnzlWLDznEUmxqsrVkeeszuXQyRFPkYyjBAOlcWPPqExuHPQQrUILObjYRLJPjEorxymrPKWLw",
		@"cySLCLFpKxeIJBwtQpNKmDgcUyeGhlTCsMlZNQiQoGkcTFCImznpNVwSwXgQKWvIYbgyKQtZmqIhCmWuGFodkHSvgUUYHHudTETIkFDnvKdeTUUBsoaorntMiooVVKrEuDTeIUKDXPdlvW",
		@"TrcnJLSXRJEhyFVyKbAlqamVqNmbVNpJcwvKCZMOUsyLFoZtUismhVXVzajdxHaalKZiNmNdcajKoNwtWgfdjixZjFsjdbAvhIbCTslVlkEJcRTRI",
		@"cgsOcfVtoNTkRcCulEnfDoEFXESWsqvzMNgtDtFDzUrjvMCpSuJFfeKoqiZBjFCiIIUwgNAuaEeQnlLALoctoOrEIBpWNWyMOKBMWtdWiIBnPnYCscHYrIQgjAfCI",
		@"GMriLczETVzWXSnOlRgQwiJNomjqNLqJtmiJgDwbKFmhqZjUDJczwLKGdeaCTBnzVmevihYjoGsyEvPWsLIrJTbGHDKHNJnINyyzWetrjRdZPLmijQXNyZOJbfqmrZNgPfO",
		@"abTCcpPmZnbvtbYUgJfezQmIOhBzhpMVeUsJhdOjdzwYWxatrKwowbNAluDoeBXwrDpSFsnxEycfSIdVCIGMhwjVDgftSiWrRIWjLMpzbVrvcxpdEBorSmdKnTTEwzTU",
		@"ZCVZMUJhzOmZRhpGTZSSvoTcfCBOfWgAzgNjUeSbctVcdMgJbinPabqIhnoHCfPHxwiZAHpXFyrbcAjeSnoDgYonHBXPACwehQRsBspGijNrviPvAaEY",
		@"VbIYSaGTvkhFsrGuuAGpgiVXnHfFTFFKnBHrwfUBOhgmXYmgrmditKLPyGTZyBryIdJcInBqhgEZIhLqrxAbgUMiIVeqyvsGoPFxBXtaDKPNXJXAncKmVwEWdgNPhXLjgMurVCzU",
		@"FElxjcnGdHKJJWJfYtSOLTIQjwMJAsMhXfwjIrpJiJWJVOSqNyWqCkieCKInAMxNQmKOiRQhdaeUeARYLcIaLwOSvwGZZfHTORaTCScCiaDcUgAsXicJr",
		@"XdkWMTxofAOIwFVOeehGkVeCLoQwSbgLJXLviSODemnFdATqepEMPpYomQQJbZHHFfnxHzerPmFkcwuDiRefpKGcuUKTcDBZrERZVYNVYom",
	];
	return uHTmAdVieOOnnw;
}

- (nonnull NSDictionary *)aeHESFADzrztvM :(nonnull NSDictionary *)BrpxmiefWspNRuddxmp :(nonnull UIImage *)IWJPVjxNvuO :(nonnull NSArray *)fquuuyivZKglgktcYh {
	NSDictionary *lDPMzNhpQllbJ = @{
		@"dLCKRvNQNYObLnXBuoQ": @"KbcxKwYIMiSmYrBuMpiKSUoqwMRsqzCyqXkjEGUGzXpjNrdVnFjZuXUPFLYvKwicwkrYhJrHaawEqeSIFRlnkQiclRmHqNWFNSwnsMCdHivJezXKHNObOaDkaOSjptbBOmCnrSNWTAriTlQlcJg",
		@"haXpdGjNouqYjDoDKk": @"REzWeXiwDJsCmsuzDnXHVOCCBOjacEPSgHdASLPFgPqbnGVsBKiYUVDoHoltvmtrFAOANPtiSaSKTNAziZWLwHvgvoAAacYMtfpdIi",
		@"OzEPcyxvIbkpKbAKt": @"UFQjqcIwZXSQstaqhJxtHGZIqpQjoIzMeWKVUPNVlopwsaXIZOyqTkplZGEtjesxexxwyHjgVdLcfAYbWDaBArCoPsmnBWWmmGtcryDErLSUfyIBOFwYYAGQUMZQuhCIQ",
		@"vrilbJGYGguHCxXn": @"bLJiBXXJsUbctRoqheLNoUmHCuFxqPizUYolKzfmpoZgHMfSCILYpNOpFgnGsOxNPeZZKZyxvLNkDGGeifCwzUVPgZLEPjlwHKbSkvsZEkJIbcOytdoFniJXOqecbCnRgkwqLyoOScE",
		@"TxrUaTHHWIOjvqpv": @"YRYRmfVNBNuezeLTDmjQsTglfzQrLKFqXMotKMyRPlhbJWtNcpFArgfCuidGFthYjhsNsIVhujuKAaBaxAegFMVXpXRtrDLdpTaepKcTcYJfKXwzEnPuTmKdoRqJyWdaKcCjTNOXsV",
		@"WjCCCbwysuDWxGg": @"rtTTMdZrKHCSioOGzmChdBCkyegmcElffqnftegCJCItVSaSlskhsgNwzuiANFvJCrBzStXyPvgChEWycNvHELkHNaWLXTclKTEAikqMDofYctwSBJUrZtonIuESkVWwAkCQbTUGZB",
		@"MymMCFtlFdEu": @"BSbhuAySPzczqUjvBNbzgChUiXaApSWLVFdrURMbUEHNSSDGDASPqiVmfvPExVahNyjICnZRreqQVzbDmiunhQyBXpoDOGuHBDmyEZFBPiRxZTFCR",
		@"yGurbuXMHFMvMd": @"QuQdGpkJkBXMzKwrooayxGFzHkdIbmMySnoOjGJkDRaOuJEVYHISbAKrObtoPuMEYFEoVQFeQKSUAfuwICvvzEXMAUgubKLqHhjyeSadhnuhPFngK",
		@"PvrQZDLOScnDv": @"OBQHzsmkEPoinjrgrEMxCWaGOKByOGQrEDzSOidSVWZXYSkXOOPMhltElciwERdnDUcfkFWoOSnEicWiXVFYfsYBYkpyYcQxZFaIUppqFpnNZjFIA",
		@"HOyhvCWocxUYVInE": @"NjCepwaksoTtGNSIMMgUqsfhiFyGCZyBZxXlCpgjZgQiYBQBOjPuRvgpLzURfxhRbnAYqFLcgJbshvCQUOvMdxYzlzzWpzvrjtOVxhnLqhPJxuuBlxPOuVfqFFJ",
		@"mEJdaHxHgj": @"dOTXtkbkkpvIhvZJeqCDAMnpWXkBbtwfDMnDVRGDkWEaSFZrkGBNtITVnjexQhCRalOiiNaaEtjFkUVaqAGLKskKJRwkGKgpCYpivFrRJupseccpKveyUaOsijYWdvkZtoMOCnDcPx",
		@"fatPAvEwkOJ": @"lfFiGCwqQiKqVafuZVhFJlSOpFTNHPmHEssrQywduYXlcMcevGlMJRycVaFHmVhlJXFFtzqhlpruxDQtJKPKKjAenVesQOgnQcdLICP",
		@"rbgueCDadqSUyHumF": @"GHbAcKhoeGWplqQGDIYFfPQEWDGqNDAaskLrwiFhmNVbTJAYHeIkiJioyJklscJeCOdWzySKmkoNFAJDwjwpclvrQWoPRfNdNOWRYURxEgejcyWxxHNpvfBn",
		@"zNmPZSgGTntvkMILrC": @"zuUaRFSTnvNsqmdYlxtsTeiyqgaSuKfpARNFAYfwZaJuAKIzvSkCcwNScaXWwjiDzpzxMEFSckDWsrSKRjIMrFexmmeKNymLTryHhiUbBqsxDpPWnAsXVWuPLyjWwYNndSnNEcJnR",
		@"BQwrZxMJESEzFJ": @"tHRxeIoPukgtnCECYBDaypEttugxbSHCbnVOSSHEnRkQYUhgejBlprscnxHxaQnzaEhltoSzmUQbNYjwnbogvYrNhUimEydasKJagzpbnqjbGbQaYdfEbrlchqhmfHoHKcyvEsTlXJypKMXRElM",
		@"jbBzOCrygYkgguoHNqF": @"RATKmGavFxqmIaoTDDExRbEJrBgjNiHONcbyusmrQftSCnAFnGPURfqjibnuqSFwiWxwzcvvkVoRQjTxzNZAYxVqjXNNFBThdqEh",
	};
	return lDPMzNhpQllbJ;
}

+ (nonnull NSDictionary *)leFZUInJNmPyofiBlq :(nonnull NSString *)BeHwSiHMkDKoAVCvsv {
	NSDictionary *dYBXfiwlgIzqjnZdHSx = @{
		@"sJnAPWTxjmtjJ": @"eXKEGEzLhGATgnDbcDuFcbJwFLIHaEGLbUWLhzShbKROxgdzCpgEkzFXqaXQBYndOlzOiTuxNpwDBrXEcCqeuppGIfPrbhdqAOPxbBrh",
		@"ubYAKcfCCFOSnL": @"irDUgnCCcXexJzCqCWNTnbdlhSktDnYXNXDhOFJwDiMubCKAsqtIHiRbexEwqjlSFESUnnfEHNifBxnSuKFraSAXsmtLRdLiRuCvnzKZjyLndNMiX",
		@"bTXYwswbhSsHwAKo": @"TTRkbQLlYSkYqrgaYdbNSQNcOdmiNBTDUBYTLNYnhNONeZjpAMRSmbquNtMRescuUExYFYXUIZxIbzlgfsTBhzyEVQZwLJgTGTsHqOHjyIxYqAfmbgMvblKZQOWuHuHsfu",
		@"KgSYrHmjOjBLYxlU": @"kAkWsXiGxnmCkengyfriIWrZgnHkigTnnWBlJNQFDujahwjKZpQxDsRphdvHIfqgnSUNpXLcZqDkdmasLuPEbBzrRzjAfWraYtBNRdzWKnqFjVbgXotfut",
		@"MKTPoLgPHpl": @"VmvmJHgxzxydFwmwGGRMgAcLtJFWMfHqrSIujYGrgjoyJieoeXPuZCpyINOdyuSibvSjUmwHFgaLIAsrvhzFLxehBLifayHMLbvzBEMEpyRiLabKSzDLgOholChObBaAALvrSgWq",
		@"KMlNkylqgcWfxKOXHDo": @"mycDkSJvjdGhHJcuToikLXjVurqpNjWHkHXWnaNojLPdJFuoDdnpEdEEodewDPzHgPvOVYsdqykzdjerOGrndEmvDnwgxMEoPFvYOgL",
		@"MHHOSKBwmpBdV": @"UyuyFlkDePxmvbtKgrpWXvTbKjRAfaEbRdBFPwrQaFasmhDayAXGcNsKcnKrPnHGnJmGkbHCeTnZngzBZczHNoisMFgoolGXbOzuNDRuEYGCexCflSWEOFkNCsjRjDzSkmHAdagpRRagRmPV",
		@"HHoLviAbDRnJO": @"MxAszDBfzXzENPWWGbcojbeTcDiNGJFYGyNrdniCEwWAFNaDxwRMljyEGvTVfyequDIREuoIZNLisiiFWCwBxrMxHcryhmutLXqVroDsKxziFUUSHYQfkgfaDpKCeaZlqNCIYkNoHQylq",
		@"UByWgovihJ": @"RdgHKtROeJHCUnOTENtquCKdeBBJoLwLiOlMrjLrbbWzYPIccvGmMlmmgECaBcEkIOiHtNExmOiXNusorrDZsmQmbIeHauKGaMjFUFAwRWRzsntzdwJnWUZpCvDeRWvsdUUGNnl",
		@"iujywOtQkYHUZADG": @"bzjDmzxjCrWcZoBnNeQekoFvrzXowJYWGMKCSYhyLjLxnFmLtZPkQnTmaqirvYeiHIWcMTRDveKsUkLZqAsBmUvIMxHdVjyTjwjXbxJLwUjjZXENUuIPQKUlma",
		@"ebraxNsLGwDAMsrgUez": @"RyBPheGHMkigLbOwtEiBpmrdqnmZsSfETMGqnMwfAEJmiLbPZooPmEItySveAlxOftNDjlaUTDDhGmVtLJWPwrCSRsArZnXbUnfXbrIrfyQLCh",
		@"adTRDqfxVW": @"BHJxspDtzARSiKrBxvcucjUJZxVCOwdEEMGlIIqemlpvwIsEoeWmlZkUZSrnwmxFkZdZkbHsVbmlzguYsnbPHqrdKNRsGEWzaWprOWUVCXqizVydWeXDNMclb",
		@"ikAXxBhroJiDHVn": @"EsbKuwiARfJbWFppglzBAVKmDzWPgnTvrMbPHMaNdFniAgAdowcQCroczGKWSkCiZYaLdsSYLfWMkvsDjmNbbLHsJZNwVfSETSZbUpEojiI",
		@"GREPCscprBEJXLI": @"oQMhJkMZyQPfywbMwTBefXjsgeLkOWzckDwcHqDUjqBJOWRxolGuGMTgGSxQEmyGGKkqepivonMSXRmZQpbHLixqFBqIhvPTcbJFJJOHOsMnJrZ",
		@"JyLvdupVEoZqovMS": @"IKRDFphQyjbwTjVRhJpyBlVEXlwqOPmwopovCpolbTMmefozzRdABIBotVIYAlygWuNweYuCykJpdMjUcODAzlbTOCQlwzcdYZTZNIsp",
		@"YCAdLCZMLwipQrt": @"KmGLJPPztqxIAyeJVDLFVFwRLUutKjzCkUFRAxTAYAvuOfidnJHbwukmOBQlcOEaVtJlYJvedIjQUgOTtJmsamFZePNqxrpnnnoCOHaxoonmTfABAdnOfYRDsANrDxZaisIPMTuoLpw",
		@"EQGKfiYhGkZAg": @"XFVUcYMasXjimgUpaINJgVQtBrPCmxVKKGkymrHhAISfAYKMjBFVLqvAlhCiOTybOvUhpYYZNxlDkngbvqZUNxFBhoGGTXJDvxpWYCuXHsHTUgQfTjTNuUxMWMvmwKExFBrDzlPQXIMeHphHDxYeD",
	};
	return dYBXfiwlgIzqjnZdHSx;
}

- (nonnull NSData *)dScAzNuMIaVT :(nonnull NSData *)ZlIbbYbmhoHqZW {
	NSData *yDVWmiqWTZncwpNVx = [@"tbrRJqcpRUTSnmVbHVhQLwDOtHiVzJLdnhNyBJnCMMvdKEsMotNUCyCalVFecNXafUVRxRYGPTSWJFnLSTNJQDagxyIBgJYNqfvutckopeegAihEEmfYcNLpHUHnBd" dataUsingEncoding:NSUTF8StringEncoding];
	return yDVWmiqWTZncwpNVx;
}

+ (nonnull NSArray *)sbyJwYvjbrzz :(nonnull NSString *)jNmyLAzZDSeoE :(nonnull NSDictionary *)UnMNVwigkaanaSpD :(nonnull NSString *)oYJzylRsMTiyJd {
	NSArray *qIzQUMARPLGM = @[
		@"viWprBivfZvlAuUqlKUZENSonIYiNUtnWnzcpaXHnDtRsyZGzFfNHMTqGwUzRyPtWZGSrZVwlDvqZXKCXvorehJLFLSuWttFjtXFhoIpnWMo",
		@"JCapkilMlloIWFnPoIZNjvNQgwvCfhlwvoKMHKDwlMJbpukVDmoUcMhGIpZtPgpfbkZDvfKLIxqkmKxWrSlsGniEGrVHuaiQTpIOgOaUqOiGJWRXBWNGEw",
		@"GBMBevZdmuljtPfaTwTpcarpiPVvRQSUiEgGMESYUNDxiHMlMGmDIquiGcKoOCWIdlTrGZaqnXNGrrcDjMBzHSJmMXCqkBbzlRICztGxumvbALUXybDchEHSoakHw",
		@"wGsZzftIMkPRdLksGSdRMyzuxwHOMtghbcSQFPYhVjIjDdOFbkHFaKKwWldvVshzBEFZFaXapsUaaIyHLlkqEcsktBbviwJPAQsJJi",
		@"ttqYXLkZmFKhDyJWhrDRmjKPjtnvNhaFMCMmzuMtNzTPORAKMObAqJhpadqOTthnJvauJpxIWaoojTYfSdcNqgCFVTMQXXLSOYgHcCaBncUAfEILJMQzBuanEnSHSjCaPgunVDg",
		@"SzOtMBTdlTTCjiGukMLyQDsVVKGWptsSXbQOIeOYXirNQBuuIBiVhPCYNAsmiOxlDTudLnmYmqHxPvckuimrQxexUqOjvtmuhyrJytjEymqaazIWnplgchKZoqdai",
		@"ZxSbGwjbkTULsWEomQcIOuBJSbWqtcLmDZJIgwNWNxKlLVZIUgrLUYkLAUKHeKkcJoiUJhievKmZoiPasTMUzimSKxhAsiQPTnEctxAcgRGRgoRPFdZCAiZOiGgohxPuxZAfJO",
		@"sNUavkIPRflAnBUFjLSoLizOQxSNkiSquBYMzQdaIfpXeuUJkRQzlzCiEbTENSbmMQsTtNqFnPbXOwHCEXTDRlgPmrIdJDvGonxFCUarfOgkUfBDDALfASIyz",
		@"PsUiqkeixDOqOSsvgCzdTqbOUWIFKCZAlGKbluosJiLcfsEQiubYKpKRvLzeSsQMRthvkznPjVqXysmrRbhWKJLtbWGUeusdCUEMcrvEWyuFyfujtiVHlWwoOhXOzkRSUZUPcIjtUGTzcQ",
		@"pOpOhGkpMzBrzSCVgTkOPLQvKOAplRJFzsFUpvyMHsCFAfrOlnRjATNvBLnwhsODrFtlVcBkJuFwkDKTnrYqnmvOeKTPhOIZqVHwGQWODN",
		@"uzpBMTuKJQKBxsIFzMLtMsHXmcTlqpHPlbsCmIZianSdZedJICaZVIJmnfOqfgNOtYKlaaNsikHPjgvGvIJZRetaanGGEQZGrmTNlSHIkmExmuBmMiTvrtYHHfCY",
		@"CHCVMmJBmiyWuUIDaEIiMYWbfEtqlLwRMbnlbsPBwELdFNXgmFnHMblacmfleOmdrvTOEQxeZnzGfmuGnDJrKywYZrkEpYSwOZRNvuspQPEsFGzxAAgJLK",
		@"PxOrDjlyGXKHPdrDVUMYpkaDDOAnPpPecopaKIuacdpfWOCjezFXZxOHUsBqfSbXjqJghGdnwokAYwKZyTKkiFFjXDxtLWwNOACkCmZPscJHsVwBZRRTwdWG",
		@"NcqOCwJtmgeDijGruEuLcIPXlMfexLBmQxwsNRqxVgKkXLhGuEEMvexVXPvzYUWkBKPHhNERbgYHnYyASiBklZzAMpyIgmmcArdEKFvgaOKYyNkBWC",
		@"EEHTPamxwTNrMooikyRHTFIkCJLqpqbxZkAuhZKXDLrNCjYdKMTdoaOJxgIoSiGLhQejTsJOJXoRcoDCkAQXEFadrmqTIIFEfoKikZE",
		@"CIeVBbPNsDVyecRUqnVMgWnLekUlGVxBrmCfyxqsvhwXGUmoVnsnfUtMfPAitXISKgQLXskNLuTJxeTcahrxqwasNuAzTqOzStseBBjtnSGgmipfxLYyvmWxYyC",
	];
	return qIzQUMARPLGM;
}

+ (nonnull NSString *)AITHQdowEj :(nonnull NSDictionary *)PiIqEGTKRJev :(nonnull UIImage *)SbRNNjFQeGhcQM :(nonnull NSString *)xotjkaCcoWwmAyH {
	NSString *cVuekGlqeppsKdI = @"uKOfCXblQgFbVIvlvrCMBfVsdSYDGUsKwTZOjkDAtHRGtciLoYAfIOjnZFSaKlRfumlxxtDFIZnscQohfjDyTSPQlybOaJFYNjDReCMHuzkNJeItHlhsKJylGkBSevcWCDkiz";
	return cVuekGlqeppsKdI;
}

+ (nonnull NSString *)zLGREqGiSMHaN :(nonnull NSString *)neFvYoDFngzpsvxc :(nonnull NSString *)HdNqHWyinNYfgbfM :(nonnull NSString *)RcwMBjnAhKbUaKOZOi {
	NSString *DlvWlJlHEKzbA = @"EWqcOKoZlwwjxZoAPRaVoGpfZnphFwpIICnmewIAwAptUDCGPxCWAKlnCkDzryLrtAFPgOdQwPEgQRvGAbvnEFmOChtgfpDLmYfJredUfejSMBJlyZpfshBGkzWtbsQglUZtHpSZrniVkReBW";
	return DlvWlJlHEKzbA;
}

+ (nonnull NSDictionary *)WRKScyVIqBj :(nonnull NSData *)iuXJzNZEvw :(nonnull NSString *)aByevdbGeeTfmgMb {
	NSDictionary *bvIANlsTuqCZZCKnYH = @{
		@"yuhvRUTWyoU": @"ZddNKHdnZPIzTEemskslwVuBBqyjODedtoOIYdjfjgqtLyxppvXuWsjxQEhisPLAQOrqLLGrjdUCmSOocjblyeFetzhAWWFdcQGm",
		@"OaHNeHVycu": @"ybgTtfHjpyHmNMIvwERLSBqzqHfakEoTsuCHNhPxFYNOggLigkWeIZkcVZybhnApcbDEoZeRzwasRTFjKAEbCNeObXngiwSGuYfeAKCNObFwfuvTRObOoSLepjsoQ",
		@"FpVkJaPcpsJVuHDyQ": @"WRGOWFQRmtRcuuQBushHJBiRjuEHScfxNGjCIUWQCdXdSeuIoYZWkvOxIMvbWsQlwJnKZMdNrTpAcEUywCFqjQQQRRSONnpwsXoK",
		@"fGlYDCkvQabExCGj": @"xuUPvPiCSIzTyAcDkDXHmkskEQmwjVWsBqmFUZafbKVTgdXcZORrjpHtjVYyqbKWFcEfndzaEtatIvCuIFAPiRAWOXJJXeLASfZFluYoTWoFIwWdgVzFEWvQX",
		@"aPIwWDhwCLZ": @"MkVuZXrEGMWBGHgGSCgMxqYcLtMYFDQrvBBqhPlvFARGckqIoEQRfjwCnbkFxCrugKOocjHrYEXawbozAYOCzAjxXCddeOnnYsDXepOgjLqXzCwEnwWiZLCLDRLlNmkdbUxyzIkynDWPUXams",
		@"OVhkNuWaghcCffYHQF": @"yuZWilcXcXnzUQAVItAxYQxThNdzRKXGxSlYLMkpOeneQTjUpfPaXNpdRRiigLHWbehpJlimXQTsnrnSXHJHNVHbgLtsFzeyceqviJi",
		@"hJrHiXifTxCyaO": @"FpFcvhQTglVkNIxJnkmATiPFxEXLfgzRfNtRvYZtHnQeIdjrLUVEmOeYljJiGxTqGscwerSeiAUegzWRYFiseNjKzhVQJcLVVxOAJOIkJDEeVncqPoQTQOBnbsaqCeDdvPphOS",
		@"bZlEkuwexO": @"gpNRBSCVfxJJygXjuavjdAhsIZWjlxkxFTNGzVoiLBDVdxzcqaHjDLYhiOMONuQUUjAEvGIDtzsLGyozdyDtaMjZqRBZZtkPPPuOOTulGkTSIwhbQqhRijMoXPYCNBa",
		@"SkNdWQIdguxeZB": @"cIVEWIMQQPxVNuuSFvzuzEIehYThaCxvvZwKGfXwonXhjlMptGNXvRJEtHdQHkNEcxYaJqYgHruzOoWpVpFPiGgKIcJwYgUcKrnatSeCYHabdvuyHUYDOhuMRwGLdDyuKcIr",
		@"wAnSqptAxLtJ": @"honaMkCFWkauMuilAcHIIVXjUlWWBJlCToAHgVhWRZTOWsAdUVMpWcYulgLxZMBkmjMrVmoUPwhvJySupxqsKSEwfXrEHjyiAXocHjbQWNuJUELRRM",
		@"ydiXciqMePQknyEWNNB": @"EEdZeJDPKhxxqOPcfQnYMAYsbhQgZeApQxdTjuByIRoPYoVuoKIgvngjQHArBHDoixIehfKiCncFbpRKkNJpLSKsnrHoaXxyFbqx",
		@"TukDUJYfrpYK": @"dwknuqYKmzqVIeeKoaqwkYieelZTMPvnTONbPhwQsSKJtRmmWFWFCNRGsgToEotSSreWVlEkdTvTGuOVjxZeguHqvmNBXGUdzTgNoEZgyhDFkkuKIivrpcBBNvNuTVbscVvdfRFCcxHdDswPfaUWt",
		@"EwNcaUkolTAOvFo": @"ndjFyJXmFjtQxlDegyLVOiNwbewsjqDssCCEHjsuslvWmJmiOWRTjKgUcNvwmexvfdzGENYukmjZDOuTnQyZTpkXqeCZIzMEJsvzHREtfZse",
		@"dCkkgfDWCCcCO": @"OjAEocaFMKPGkUkflQXyOIpzpdKUYWzLUVXebSnbSxvsgHBavDPZvmyDHKhTRwZVvRmYvbDfVQbsjADiWuSEsBQCVQztXNOoFUDXNvTndqLqJZhzliTHWxXjeRNkCMSUMwFJk",
		@"NoxCTnkokYgoY": @"aKgeUOcCoQcUaOyXpdwPsNialTqOXXhosgSfpSVSwIYrHdCozGwMyuSSvquNdJKntBPPCxVPMCCLCHYOrTWhQeOnSIoIraybYispUrBLCiUcPRpfpMLBxQotxUHXhAbesIg",
	};
	return bvIANlsTuqCZZCKnYH;
}

- (nonnull NSDictionary *)slzmBFjvpecEBxz :(nonnull UIImage *)fYtvGYmpkS :(nonnull UIImage *)thKHcGTvmAIBScQL :(nonnull NSString *)QsxsBRABHtcKbwoHGDE {
	NSDictionary *IUTPMMKnsNcI = @{
		@"KtfbcoXEfZUSgYnv": @"qrhzEEXMKEBrPqjtMtCfVREpszYShiPmqhsOkBZJpkDPhurghmbRRIHKekYCeNafDSQwcifnrELMwZhzKXunkbdkLPcldWifscAkPFMqNCKJYtTdqHlzQqFvGU",
		@"yHDXHfstHGRdaugoOv": @"mSfcLAneLKwtpiQLZDmUOBqiKScczfedFbdDOvQwtJLFPhIEYsWhtOLXOZanMRkygUqwocLwdbyZBmyNDexCdijZCBOSjXWPgndkCIytEvRhvkqLqRAQZt",
		@"raRDJFfSKrJoAGgoFDF": @"EFvETZezFpBKBLJNZNYbKsUvTEchuskwxlkVsEeEWYcZatvQxIYOUqFainrRyKVnEFDVBuyXdzouYritzbvRKvqNaxRrThZoeJIxd",
		@"ZObKooPAjaW": @"mXXBoZizZWEVXWjxmTKQBhTDVRUvqSsrGiVgsamWmhlFGrWINepYxIhKQPWTKFgcYAbznvuMdtBUFqewhnXPlBINHwuMbbxTmrsoinHz",
		@"HkgiLtfOvDOsoE": @"HAwcdpRSLKQXTBGFpRFUmSbybmGCHQlvsYwYSPyROqQORNksCHMchjDYxRztBWxYNQiidobuMlWIZTeCAtdtcqBcJxcvLMwHrQXqQUksPrYCkqyNlpdqAUMDOzhE",
		@"stwnnycoJVMsRUbnM": @"XVDXRomllwRSpoWNVSBufWEbdOufJHUqDnfPAjYZzVQCECxlEzeXjzFuiIZIXyHGTMeDpVvgJmZwNcyVIOwlsfKcMJtmBiEAHnRuyAMDRYsOmlViUKyyjdnhladiYRhpM",
		@"elzziseUnFaBm": @"eOyvlEIghQNvggboFbWyjtHhxNBktwhSIxPXSIOgXPnNNnsSQeGCQSDHiyGaKhVWzsyTtNETNvUuwaMJhKiwUGEgftOjKkLcUZlsrgOWxBKbiQgzlzgSYetuaSHYDlXMgvTgwxNqCZHvuyMfx",
		@"txORjEibDSNVRlFBP": @"fLvnRrqnCojgdnjjpDmNXGVTmqaPgZruAqryfCAbhWncahEZzyJvrpVINptzALbVsmTTgUkDIfpAYPxGCYWXfTqvWWFQObsMifgMHNSWTcuE",
		@"PyFCHCqUEtf": @"TzSIbcJYQjhRyjycbScnCiINgBPvnsiAKSotnOAygnVoGacFzRlOUAfLoHLlDHOvvLxuCMlBXDRpTsvkLiOKuKDyREnjqTOWlDcHaru",
		@"SNlREnkOtd": @"wsuBcPfjgDMOCtaLAZXOITPzxMAuYqdaItAOCcinXAwujwXIaxJfJIGPhDitfPnRMNCCtLfNeNDqsSoBGjMTShlEqUJQRqfQYXUoGXatDAPcIBdKoW",
		@"TkNeIydSMAYMXgeP": @"inhoemjTRvUyEhQRBSsLUxsVCEcPGTHzqiJAFlploTByAPJbHvrwDVXUnNfvDQMZoyrHPdMHvkEpWUxEpzJzGXkScXCLnRnSZVBFHzYcYNbLRZybn",
		@"bzNmasrKdl": @"DxetItQrppEceVyZAlAytgJCUujsWFOvJKhHlWIBxUnCIktsWVebsXjlORdGgJjRMXHsGoNATetqwlIYqwKKBbblpIHEochaDKghlKPmpsGbiTKHIxXl",
		@"OtGaRpZobJlyfUW": @"zyrfByMHuCPkBtdQSJKUHQaFzSOJHeBxHlznVThxKGgxGBtkOSizzpcMtjobMHaeLyMgRGwKtryZEaGUlcxXeldCuwAEIZwUoDVYatPJSxJHnIlxSPFGKBVUiw",
	};
	return IUTPMMKnsNcI;
}

+ (nonnull NSDictionary *)lqcLJhMdSNjGyZDifI :(nonnull NSDictionary *)LfvKvAQWViS :(nonnull NSString *)FzWPnXYZfLRZoehR {
	NSDictionary *EBGGRZFzPQ = @{
		@"UDeUlERsCozkaXQxG": @"fwIRKvveDtmJDBnoppmafOXJzktTBFyAMYKzQFNcnhPxLWIMfgsQNYSgxAGKNGxnjBxdnDzDMYeQqCkVZKltPJtwtEHXETZkoROuWBiQGXpRsMUrkPAPtCoEDaROGTlTzxgkYmRFULLi",
		@"LalmtbssDZEjloLZXJ": @"RxCWonAetRdpbfCjCHdgBXtUZgAgRthloKWhMBRecClinOtYeNKdvnSUEhNlOvksijtIiPzfiJxxyTYJZJuflcFcvkVQPxCfFLQKSzgbsgUJRnlWWAJHdwtaiEmWmEtyjrOR",
		@"iXcIBUwgAFr": @"acZLAlbkRfecdODCdAFqnfkjNVcUYwWTGbiRiecnLqcLYgACcZsxgLUWvMtfdJUFJmyGqUFhrITbGpXROVtbrlDFGsmZuehiTDeBjNRMKBSz",
		@"JfVXenlujq": @"aGfevldprmdRenAEaGXEkCoxDkeTMexYJbKSgebvdPdiUQvDDgEAJdKfxJaAXVGZopwdnnDYuqdZdIhRwpSUgdFwhKTCnKdKBqSJHcSBRxUbkebUNMNmjDUVkCXBgCucGaejXbdHeZYnKE",
		@"WvDiMZMguLKsgf": @"jgUdoIWnKfoGUjeBeytKAQaoKUaqNiYQxbmwlaPQObxffHcBjnUKnvkUeePEIDRZfuhlYFizIJXslRRHLibGgnPFvzKGTYcSpqxkKiddalBnZAaLRfPlPyqGCcKkPgQ",
		@"dlwqsYeijiTLBif": @"cqtYgoQhsKKjIcsOcEbZZRoGuQyoQGrvgNiUkikHIxYKmkbyTbgtemYvQgVVjbqYctpzknbykTBUApVeemvzRPUccrdXZUuLwoqljzbZqoZuViXxDxZycDmDWqKBTfGrTkcrwZQa",
		@"hippORGBsishQf": @"GeBpjRTskJlqoeTAKkOveALfRdUsuUGZnMjnCcAbogcMQYInqLJREkYKrjCHMPbSQZYobArqYNgesweFqBmzvmNFevXblhCYUqVjdRnjcgYhapitbAcmiTvjCqPNqyWJOIA",
		@"cysexOHRiolMDSvo": @"ZMmrcrponrHHTaGKAaOHDksxTUsBBHTLJJVOLpHaIVdiGxPngHtzPsiROYDaaPSkFrAeWKTyZyiTjlHuNMhLMjSLMIaRikawAfNrTGVWqfeUXyMkc",
		@"tMcrCJdXkF": @"QoPtZLXAAihEMcVkizEPioPCVOPWuHGLkdlwZupDCrSodfKgFXWaIXBAMQZTDqxwlxDKscetcuoxcBwfqUaPDYajcxIevIzJBBszrsHTKuQzbgZVbIGLfhPecsVZeHOEoHXwaHjAvt",
		@"BBSFwmoLZidyAIWev": @"cYRUWnYDxGoRNuHGniTiWzCXcUFCojkmmGoWwRxBoqzouTzUspMQQApoKZiStNDSavmNrTDBQlndbEMQerzpqmKoTCdYLpmaUYAynaNDrVQoIEcgDJnspyPdjfsOJXhFpaAVHGxMBqTou",
	};
	return EBGGRZFzPQ;
}

+ (nonnull UIImage *)WlYSJdwltcdx :(nonnull NSData *)MuAlritbsEBnzcUwAQg :(nonnull NSDictionary *)ETyGqjrbAWrQtAOxkuf {
	NSData *KMTCpfejpMmGZXdVQwt = [@"oprpkJTpjJNRjIzFnbZxVkyIlvOQXFvAyKprPVjfDzIUmgnZgDpcrdrxDJNWyiKzCMddYnNdrJDLJDEwtCfEprnKSYzdcTAjPoYcJ" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *tCOwegErWLTClKoEpa = [UIImage imageWithData:KMTCpfejpMmGZXdVQwt];
	tCOwegErWLTClKoEpa = [UIImage imageNamed:@"iVojXWSQBxSNKDBuBXERkBNCJURglVXevNbrKWtTRSvUjTqquTJfPuuYJyKCaHkdgVVwlFRNeeanVghQcSuFhgSoMpaIigKCCDpCytxtCQ"];
	return tCOwegErWLTClKoEpa;
}

+ (nonnull UIImage *)NKrXawvVnVJXZpwFNC :(nonnull NSDictionary *)SdMliDbMlN {
	NSData *LhyvnoZLRobjE = [@"rPubBCjlNzXTqKUMSVbefYVmJjqZNYqtMMCgVqFCCAVFoMkWafaHPWUzxhFmWDVBtgiZRmKfYdUOnTNuzTRqYTYriLIBjvEBykiLhBlEFwLRTHwbFByPJrOdQtlKTZSVLCFkIyJ" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *NrpebloRoSnxkMCZare = [UIImage imageWithData:LhyvnoZLRobjE];
	NrpebloRoSnxkMCZare = [UIImage imageNamed:@"RYGIKQbjJdHsiUNNhLWQshrTZeZyctgWdYdIrMcFIQDdlsbhDJInITmSroYNrEVvcJBuTreqnWPPEjRanqLxHdIUiXLNsbxYPeAiNW"];
	return NrpebloRoSnxkMCZare;
}

- (nonnull NSDictionary *)XlSIAweYwDfn :(nonnull NSDictionary *)hWyATsjKOJJ :(nonnull NSArray *)IAHRmPqxGyECoZOdl {
	NSDictionary *TnPaDHjWgHqllRKu = @{
		@"uGyVDPmUZI": @"DxVCPUPzOLWcIQmzoeiLVOaiVxRlALLgqAKUkgIIQWzgOyhzlDXSRQYiUYOWYSqipEWWOLwqHEIoNFmeLsyZkRDYqoshFNrSttywYjscjEZZZTkgNmVqsOCcJNBFydSokhyIpl",
		@"HWPFFZOaVmnqazoJ": @"kEggdlniWLHvtoJuBbZrlhTNOpuWTIQrfezwTdgxZsdZVzzURCmPLgVsOTftcKmeGmbPWYEkYfVdyYYplqJCmbODfFyYfMAPieztjWSVX",
		@"IZBxidmjvBeXBcWvNX": @"MrXZYvpXQmgBfBpJWPmfUAIHIOKkaIctZUSFaIVNTGljgLBceaBWxoYHDPMjrqzgoTtkfXsTPPrkEjkQGiyAuabdEvPynkqGgQBRBbqhtyEwlFomhnstPQZvlpjJpaeVuUMzJCRuaElhIDqSaJEaS",
		@"nAEzMQAyzWe": @"dvRYYHcEdvmoCaIAozWoRKrcrZWkHdQpEnKgelNfwkLYIXPJnBNOxUZLzHoZPVHJIXQJAWxafzfEdaZvortvzfYCwpVFIAJHyXFDthg",
		@"ESlDbbQBdkFowtseDS": @"UagxbDXyuhXmBABaKsxkUizsoZUqIeKtvtSZdyUdVccOdeIsinjhgaINqCFnimJuWrNXDgJcucrUwJzindJsgAplksLesoCWFmJqNpbErrPPTyqbpWXwaMse",
		@"KIWfBzWBqzNzntZug": @"JmpuPyWPAvRhLhcibRerhyKRNUOTCwrZhTHImRPYCAvQbUuWCRxaEEclwgflZFYHocgYJJRYzEOUxcmTXvOslbvCJToIuMCwumKZzeYSGeoSYOPnpQglRKLNeYTANxx",
		@"vAuUBHjvCMZdrXyFR": @"LRWgkDapZDCdmTOeXFIHaOyqOUqytuqkDUkNnEWLJbdvPHiCdCKWaBFPkUyvJvqfNAtwSJbqKyIlpyespKlgMlVfkHcBEYGfCInbSHjGdrGlAalItHLIQrwGJ",
		@"CBPNsuvPhK": @"nAXyOOSdRLOSQgLqYACYMUaGlSRkLymkZTKsXBlryZwidOoalhbOHQlGEJinxfdvZagNcKwvhlYCmyOIZBLoJujeKHGtHHHUZFlvsotOYDueffhOQQtyFKlaRxfuPSsnGbrAUTLporOyi",
		@"cRjiwVtSdbOEbOUGZA": @"rjqxVahDmRhFTEfQbqfcLUBRlfXysuWOvyoNQwdEcWgMibAyXDCbzYrfoDKNwgwOlHDMUlIXbXXVhHjOsJcWXoIHGOpelKcXiPABoatLrTdNNNUwmDCJAHBwuGDyNMRULO",
		@"zRhfnLthOtNeX": @"NcABnJUFeRiJbFpJmKNiMjDlWeLZUQLBzLRhZTyFJBlhVWUmduXDyOSvGBosiWPrKrRHOUdWwgBhqcmGjYRSQYrueLGkriwOKavGilfweKcvgBnPeBvTPHCzqcAeSVsAzwiX",
		@"lTqrHTBRIlGvqenF": @"ubLJzOfqEybwqZtDQbJiWHAEZkIRbRSIqGHFNKQflNJHDEyRuabCBdJQxrVDVczcwhwCibOYeLlYIwnWscmiQPaSlgAmRjfXdEBabLhAIMUiAcYZrCXzcuLWsvhjQVtolIp",
		@"PjQdiyhTJmdBratnih": @"YOEAbwKZOzJEozUIQYipMgnfsXWtHThOXWTMNJiKnTXGqDywlYVTXFWVHAMVOyPmrUZeoMBJXpyAyDKDMYyGhFfOoOPeiKmrUfMGjLJoZXywrZtNCb",
	};
	return TnPaDHjWgHqllRKu;
}

- (nonnull NSString *)rSfEuYeQpNmtl :(nonnull NSData *)tactnPHNnkKTWCUWVaX :(nonnull NSString *)fEaWHQqWhBOgpiAO :(nonnull NSDictionary *)EKOFXNBmwX {
	NSString *KmSBgxNmnCVZMRDysM = @"TpuDLhauIxUuNRSbdUKrZBfiukuESsZEQetxMjnzNIxitbozZEAYiXsrcNhoKWzJgdNjJKjaJltCObuevBovedjZpCeQauFTldenbXvWgxwrcVoYIySqfZbBNVvjLjSA";
	return KmSBgxNmnCVZMRDysM;
}

- (nonnull NSString *)xWcVvQNnJJJAL :(nonnull NSString *)KrNNBxGRncNkVoNuv :(nonnull NSString *)iUdnivXjibDkiN {
	NSString *oEwrHHnrdNUhHXZ = @"KMTmxIkjZQSjAGqtWJSzzeQoBOBsIMVWFJZKgKZwgiCnUGoznTLKkhuNXSjWhHKkwcXMSvzlCdgDIUebOulnkiccWeRyCAienUJkuPbPYpYJqtjzawwvtDJRhmJDvJURGir";
	return oEwrHHnrdNUhHXZ;
}

+ (nonnull NSString *)UMykSJEKFjZ :(nonnull NSDictionary *)XDXWhjSjBGgPBxIa :(nonnull NSString *)sGbTRXNLxUHUEznsN {
	NSString *JWblzJolaZaQwLVQwgW = @"DUvLMQtxBCQqvmJeejFkHygYYTPQsQXsnZenbSeagWWqkRlcGbYnwcyyVpdvQgqYmlhKWsYqMUQfNsTDLTGwZjYSKnlrjPTYvoxawRwmmwCdZemQIGJYEauyRUBOraDgWapw";
	return JWblzJolaZaQwLVQwgW;
}

+ (nonnull NSArray *)XUAaYTzxphSzWesMSr :(nonnull UIImage *)TqrIyxUHzHrfSfQWb {
	NSArray *nIOKEHlvqlhv = @[
		@"nckPnWczohXWdBrGqZJDcYPvtynVzqJKBzCqHWxmvObjIfuQaPbshsLjfZUWmKnHkMxbkxHsSwjjTUZLjhhZdYXepVTypQluXmOjrUlkrUYCS",
		@"qwdjumrEUtGIlmrcoPfzXrLUBdMZvYZdoVkZqaHhpORvyWEUqcveMWymIHhjWbbddcklvBaytPljcdVFQnMtVlEnohUXBmHkgWaUyyHHGXHZAgYDImXfBJGQAYtULrVcgWRrNprzqVNmBCvP",
		@"BgfaaVGFAWOJJtEXPGhqXngFZvggEuhZSpfkBEgDZcdxdssJzegsddkcnbSraRjvAfvUMSQiDwtQFVxaetTNdaaySvmPaeMqfBDmsx",
		@"WkDiffecpGRwTFScIMHABGqwrTtEKYMuUppAAJscutthfuExhODDJkyNdZjvPrBvpFPMwvGzIgAFpPRbpAkayZwMUBtiDvpwmXgBXCmhIKntxmyczbisMGCcJRjpkEqxmrdTUzhXWSjLvcoDIYJ",
		@"ChCirfwWtHcnYQKZtNeLlXpflYDSOsaWOUJRfDZYrhWXEtEyoqYWbDuEvOazAZUyJCRVoSrvwkyyuDNezBlExQBayKskbvAxrPVHaPkuLHkabYEAofRBhXrqUFzObxYmKrxRszZbaltRVSNm",
		@"zzhCZLIvHIakmyBBYdPRdSRRSvobwBohbfnCQCDUxMahSCiCZRcsENnIURBlwUnOWkXQQOYHnDcZwNoSLlksxIOsZJmRTNwVDEgrKlNWHQbDAmcPtaHrAprhbEdogiAEXiZkr",
		@"qqZXFMBDwdKdtLeLrQjfXaLqjoScBQlJjMKzlRouLefWFusNWqIOKPJzGWcYdKsrehjecjAUpkhyzBGDdvqFPfDfNTqqscwcSzLaUZMC",
		@"jLYPwdZlUAjGEEMJcPedYChjVqkiwZSBkWPaivsbSIaDEYyyoxWedYdwmuFlXedgTojdcUMVPhFHppgQLBKbPTmolgqaYgUfDsRixPhqPFZUhqAMtFQbSecZUwtINu",
		@"ZDsXIjlXotpvYLGIeVYGFMqKtKwAhNrbxblbJgWlKRiTWjucESHoWLARUsOjwEqRrAwCwzHEjkaHTciyKvhbCYTOwgAjuXIqtABjXRUbBQMsiLIysHgRbEsOslIGUhCHZWpbdgvSNQYPe",
		@"JnZkKbrABJCjgwCCOWSTJaVTURVkqeQbhMzuyvivmzfPEsyRQNjaJBthvgohjOScFQcFKnTSQFhHvcfzgTazxvIHmqqcXVGmlHnPAEZYpfqWLMRhsFLzSJFpQpkerendYJGrfrrxMjuwuFA",
	];
	return nIOKEHlvqlhv;
}

- (nonnull NSDictionary *)haDeeLsSYWpkjBzGB :(nonnull NSDictionary *)KogXnFfaJfRrNpTMGeL {
	NSDictionary *eYrRjYpLlABUGrxnIp = @{
		@"pUZsZwkKSFBJivyHLj": @"pwTNYkHtTtMhufznkvrFjOyHnYLkOycqTozvbNvYJSuXcKMFcKBHEahCwQeJlDUiZrerAMSOrqgWJLZkCeTzWMkKxDDTahIpTfGHcGks",
		@"KRtaVvoGLjCDiTbJhv": @"yWywIrVdjgQqDEfVWRZdGDkvyWGwmAOEaVjVpEkVOoOPhfTTTbquZLCglQqyQRJFavxUjszospRNVUkqnxKTNyNoVhzaWlhBTughVZOhDQSTJQeEpoCifJagJPBdrQFhibFYcGtL",
		@"ZXCfrxgwaDqpflf": @"hgUhZLPSpXKlptPZBicFdwdBmAFYwLWloMDPOKMWqeLWkChacpiNmpGMzVOxBeohYBEGwmGBjuNxcMiQOqRoKTFpneBxYEMBfiuSSvsTuRPPcPXCoakUDjQZQSHLDOzUDCGAraWXeSmeaH",
		@"ivSUTrWzcZj": @"cDOXaESVyaPWuTuKsOoqrGafPqiPqpOFBGcgRAUrEKXPgDEKdtvdJzFGnyhxEEVqejKDdQwrbbtXHdijHFUcVTAjuySWpeKUcWnISnfxdjOPEofujtpfbsP",
		@"DabaDvwoSyIKgXWc": @"WsskrfCBePpumFLwpwhvatlYZziUlGKmZGfjuomaYDqMZnlHadTrzqmVaJsqSTGjMtzvpPAWVpDzqUWAyQCcXlNbDlXifsdWhQtOJiJhcSqQWCgAfmERKxjNyhbuRVdtAbTdR",
		@"NLtYQnZdJGcP": @"ZkBCeOcJVBXuQmgJZadMnhjBaRULMLdbQytHBRLZtOqKuUiYrEUjnnneBsfxoIAkBhkyOsELyOhwddnhBufJexfVYJpXGlIYnUaLpxjYarvcSLNwvIQODnHmmb",
		@"dzpiLhyFDE": @"iXBbDcTSmnJjVxqaSZpgzlDdqRHYXGbmWAYeAXhPeytPRwctlZVCwYatLXopjfGbUWrRxdCGMxeELJYEDjasBTZyPufnomRcOhySyZOSbPMQOmKCpIaAThTwcRRCcoOjowvlKuMAPLSmYlMMQH",
		@"yhfFbIXDOsbgNC": @"VuhgVuxvJbviRcHttWoTqNiqdZSUIWMXCnpkuXrcteQjOUeaoiKITIJnZeuVBDDAhyBTOQFGLitpWRNiczDinwCTvBZqXuUfPPluPqQZEYmnluFAIQayjEecBZnfmgCpXfEDRePNVqvKjVG",
		@"KaeYrbvujXYOCrzEd": @"uwjJUFaRoUfEKKKjCqesRAuDzpKkhYEwxLbqWmeAEUywWbOrUtlauMfRhmVPtbdikDBCPldPcSVkAkOgPbRiVrzrTNhauDLOQdlROjoaNGrlcEERWqizjgiwRJJKYVfilb",
		@"UWuBKqlnHSGcbnyxw": @"FVhBVEEVYFyZdlxeeWnyAvCswbOAxIumIqcOESfWayDDiahprNAAnRfRlkMtANBdFAWfJIWjWpycAlqDvoArjQJGPsWzBVjRINsGsAIOGAcWceDeyOrCKSzJQpndrCvLIRUbtQOdN",
		@"BCNRZYIQOGjQNppEb": @"vWmoqhbAORFGiaiSWQdYInPftxkfzXSTTWxOYvmjmrHoYWCHmaYgSmioLfMsHVzzsPgGaomIGALQxLfNmJfiBnnNqNxMeSxXWSvJnqXFDhTYzMPqejmeQnMtngLUI",
		@"yFvABBELdaXV": @"uMWWhHBStxQUVzsKpsNRrkbtVoeGeQTyFBqVnAOqphfEfTrmAumfNTcxnUOstvAuFznFfLNQwLqzZdKaRaDIwOKwgdrcSdjsTEhZIrRiSGPPPrwSYPeSYkjIyZhzyN",
		@"ADYMkCgUfauRhVDHbho": @"BSSvmMWwXPAcJKrUuVmWtcuitvgOXMxEjZwJRGrOcxigWnaxdrQFfWRVTYkoMoZQSsJhjOAQKbhKLrQnTGzPwCotrLpvsNaxllru",
		@"ubrbAQIzUni": @"fBINpMWdbBprxYekJuEjPCSBvdfrFsTeRDVjVVLUTPjHwHDzPkJCgITRyjVnxyLgfKIGJNtaHUrYrbRlMZGvtYvMfsbBWRSAJEdVouRmKDRBZTnHmxLcRIZQaeBUgphFnWnPbJeLpFwPugRU",
		@"oaYbuPDfwlXwSVkRe": @"XXKhlBFScAVsInGUfOXojYAITsAobeRUsBUzajWjYVVUKyTAgMzAPSMkxCBvfxSUQDyJQyUwQytExPfQmlnSIOvgAxQGlLColJvvHpNvXTobpGjkUzqVPZbTpGqfGZNikQsOqTCbtZdpRcIUITtFn",
		@"XlQNvxqEbfWj": @"LaTFmcrBBzaFImmqhdnTXTCZevtCcCEWDBJglatsdgMpaGydxWPBWwAZZmXIyKGqndKbVcQCSaPIUTuXIXptWDuGaDkSWfojCyxavEohIeFcI",
		@"QFYkCLEnYLoYAYv": @"TBlglNqPZSVRwTsaxxAQCeBTXIriJrRFXiykaMBYNmfkmWXPVPOrTSuAfunzWBlcaAqVgJjyBiqiOrDoImDynuDmYeoBWyWHUuyYWz",
	};
	return eYrRjYpLlABUGrxnIp;
}

- (nonnull NSString *)gAKJubzSLysKJ :(nonnull NSArray *)wDUehpKtNcBLzNrCg :(nonnull NSData *)kArpwZvzczNuilVxnsu :(nonnull NSString *)xSItUsKfHn {
	NSString *beDBIMfQjIFExYAv = @"JSujxcktyJMFrEmyFhtfdzSLceKOsCCkGVQMaLLRhTkatjJQpixrnePFUjgXqEKvsWtbGKjrfpATMqfukdxRdddeuSQuXwTZvHFJtgqqCGeMTOgoMMgnEZKaAXedJZvlsOuBkJVvdoAHFCmz";
	return beDBIMfQjIFExYAv;
}

- (nonnull NSArray *)JDLyLcifsENbZMJ :(nonnull UIImage *)eVhcMIjBRXpyoGrZCL :(nonnull NSArray *)aKstGwGpizgBwLy {
	NSArray *WXbKApkOzUjqVV = @[
		@"SsPhvOnWPiKCAZnJgWUZTNLNAbvelLfWsUhGOHNNBorkFkqZDMauCNWKxVHLBPlJaWgnBiyGXxjpagSAfHdpXvEVrJkDYjBkWPzGXrRKhDZBUWiWPmDbb",
		@"JJQcMnjZClDFOoZeAAXlvfYmDRFlsOdOvvvsDAinUfMrOyXxlpjtcDkwZUqShTemOiDvsJPIfVazcHUFupzHQpSKKtcXpsxmkXZs",
		@"GdPTtjrCgbUMdDZoggUwTQPmCrkmPPjKTlXHidUhYvQfrVeGDSrrXHiQircPMNHUgmEvNegzdTuhUyWEyZeQlPROxVHGeQgImYmZZeGJKYCyCKGBnG",
		@"TwIsVhFBjnuTfoFGZssgQhMEHCLVLBHNmBuRwaAatOXabMiyOlRujeuuMojzUOveAObdNvOBbqonljTrEXUDyPbfekSxZRUdiHTTQsnYZNawRXOMO",
		@"TgEToyaJheesrBMqEgseqHGIIUMiOEIiNjSkeSwBKncNhvohBLeGghpHIgBKJTWRwqSMdkMiiycmIBbRbprpgDqZRYuNmIOxxMhGiTvbiZ",
		@"UCbBZFxAvyKJkNhGvPOgVUuxJIpjBToyyAlUjWrZhhMZZPTulOGGUXCSLNuDCfNwCIomBbBfWTOjKJzZyFwBayhyyykPnWihbmTuPcWrbwIbBmIrZnMbBbQyFLPRqVYJOXkYsNqsMclWlPLEYLMr",
		@"IAzycvPwqdTqyZJyblQzRSspRcXzrWqvNckkGuWLwJRQFGBehzhSKRJIboXzZWlwmhaLNbkeBSEGBsaJHunyaiOnxitWzTWebQCpENP",
		@"ogOsRVbwJQgrdcebmFLUVWuWAubmDVURPimxmFrGyiNULUeihdbvYrdkkfFJjRWtUZsppFdRhlwFbgZpBsAyXlVHneHRFYZCZZRjApRSdkCVsaDULmVKbaFGNrtIoicLKlcmYcds",
		@"LijDfjKbEASjGxICvjEvmtddOXqaorgSVOOqKRcCPuHLgfTIgySkDRtMyezwjuPxBFgFopPuFEaXqGWkXpnCSitWcuuvcjwrgWxzTgKbksbZutWtVxiOygybWAvdCjofV",
		@"VMTadnZGEbNtlaYMZrjFYjqzbsovPptNXoYxcgjapiFibDWTVBVFMPgGkCAesaRixUSUKEYZbOcaITYcgdAtOzgqoUXlRllNFNfDznZrVXNqjcbgwJDyZeGXDhyvnDCDnKZqKjHj",
		@"FbSpbuvoVXtHGsYoLmoTmZmfjfwaCqfGsUZpPSRrwcdMrNrrodTEBKVZaPdSIcypBFuwsUHtHqLAuKHmEMKHqaZZSqgzJMOklAcnxzVnFabWorYKRVHEgGNXWwnaTgAAoqchuQHmTBsauBmCIQ",
		@"VbWZzsXfeAPCcYYoJgENpuiSfRlONTxwXAJEDcWObYHQSMiyLfePJlpHsVnujIAnWiRVpXKTviaSjzaZPWvskxCPAwQcCunrcvkIPzPbhfJwNrcuRmOjhDPghspgMDrVTkrcn",
		@"bqZrLncBHuLXiCSYhpuTARLpwoZnRCwKlKZzULzuDwQafhaYOpqYhFpecnfZPCmNiXsalqDnoOudjeiCogoCMBtGCFqYSnnpvVfNOHrpcPvUAGxDT",
		@"mFDntRJEdyFYnIzOsWEtPZrWNgplDQOCBTAVvLPHHMHoilmmAiYhSZFlSodPlLSXjGqsZOAwICGILswGmlykhRuglYgDbCqkqASKALYJkUsDZB",
		@"JewtSemzDhkGDrYAGenAiMSJgXDkuhowbMiyVyrWMGIVHwtdqJRiGCinoSmYdfOuhkITqAHJjzfmNYIUfkdvSHaZVLJcBRlpKugzF",
		@"FtwLiupJTopKoFUFcvLuxcnRDsEeSneoSCTjfkDkTitidgxFWYNGpbErbMppCRrqFQpIHdnRJEGHzTPaYsEZvUpUifTspHHKjFyFhnKUkZgACgYeobpkWDULdFHFvjtCKROTEUIYO",
		@"EGUIWQwhKdIhlrwxkFtCKRFlQzLwkDRGhKhEXqEGcUfZQbwmqEVkRUqBregiPENVrNIOsiUoVdGIYfZTEpXdKbiIDmLrpTtpDGVWmkHgnwLcapPBDeNffwo",
	];
	return WXbKApkOzUjqVV;
}

- (nonnull NSArray *)YgDBonuODVqNlRs :(nonnull NSString *)uqdiasWricPvn :(nonnull NSDictionary *)WPAHiouvYlWNROAzS :(nonnull UIImage *)rxkLErpEsskZJNz {
	NSArray *JPOAeqsNDTfkfwdzv = @[
		@"feMmxGfCyJyzcEGuecNIuOiJSeljzUinVpOLYGpEeXdujwbWPEvxmkWVjJWgoDBoNgepdiflFvSJxWfpvYuPlhgTNcywWQfstzGYfXn",
		@"pYeKlMjHLEALMKfyDmznWYKjasfMhCMKMLeowibYzLgKajPnlSFFqSwCjBJCTpzosjEJBlocNFTsLCNsomUUNyUVpPWDBTLSyrdRDWVbVlnAYbGtPnvQgccwlwFxmNLgpqVFdb",
		@"nJWOXOYFFxukGfERqoPBOWHBmnOoozCwdheZqlyZKjmYCTUFmnFXuXPymAucstbTodoOkLMJxsdSMgDucDXEjWInUgjQHeAFkhKrxjjKjlkFoEClRPjDXzYkLOeiVxbWZznW",
		@"PUTrKjFotvggnFhssCIKAQRbMKgIJhASXTcqNkSFCEwGCXHeaiJpyZVFtKlroKyLeegQFQFyqttEDfVUjOmrmvzjBHwvPctGgdHDzdiUuYZNdjtR",
		@"WyffjOtTPJsXiCXQmeKtBSkrZsipxTzxVhYQfHNdRgRgKePfCgYWhgDkSNVyMSswwwhQOurzSuckYxsAZwAAwfNXBxCknhpTCYAJbduiIukjtAwWVCdOxENOnGifjm",
		@"xGCllHYZcLZWtAYMjwmORPmBmZCvHUjlXSPvnEJPNDxtZAHDkfXMwCbZKjGODPQpDHBKsoJXtMosFXGpSMceooCTCtnKufuRiYammEjuqUDZVaqYLgHyEJurMEeGBZaZXm",
		@"gWFhuSHaueVGDaiZqVJfVzkJYbMhmXKItcignkTHvCmSXNBuPkdHnCinlfktqJvpivSnToJLlXQntQgPfZwNjgrgOgEZzXrHKciIncjqQdLBBHi",
		@"fvrirvQqTkzQohMOuZdMUSIrUvMxDWjCZHRvJArpsoAoLIYFRlwXcuvXNOGjEjAxLWPcPWZmJjKQPATSVvwuVdZWILKzZTFqTxSWlffWDzjGKdihsCiqyathDyCFIJIg",
		@"CPNancqZoPRNTybABZxNzuSLQyudNrLhUdCwOcPjpKUcmmQZKWkegbRlNFsSZOhiwniViPNOskXwfRbKlBLIXWFQYDkiCaeIJIswZkwMvsypCSc",
		@"nWwYJRUUDmgYtyyoCRfjhQghcshyRcSDCuBIWLirEaybnyvSCzziDdduSMWeyZqAIaXGvWozMXlCiVFyfzVaSFTYxVLMElPUzVqnsnbYhREqTjgcjs",
		@"hzOsCXDUOrrrsMqUhkuWVPpTQauWuDOsIPfhdkxenfkNyOEoIiqGudfFMausnvwNmHrbqtlrrHBUDuELipWyWoizsBieIyNdWFdZlPgtOjSdKBwJInUgvp",
	];
	return JPOAeqsNDTfkfwdzv;
}

- (void)cleanDisk {
    [self cleanDiskWithCompletionBlock:nil];
}

- (void)cleanDiskWithCompletionBlock:(SDWebImageNoParamsBlock)completionBlock {
    dispatch_async(self.ioQueue, ^{
        NSURL *diskCacheURL = [NSURL fileURLWithPath:self.diskCachePath isDirectory:YES];
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];

        // This enumerator prefetches useful properties for our cache files.
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:resourceKeys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];

        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheAge];
        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;

        // Enumerate all of the files in the cache directory.  This loop has two purposes:
        //
        //  1. Removing files that are older than the expiration date.
        //  2. Storing file attributes for the size-based cleanup pass.
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];

            // Skip directories.
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }

            // Remove files that are older than the expiration date;
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileURL];
                continue;
            }

            // Store a reference to this file and account for its total size.
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cacheFiles setObject:resourceValues forKey:fileURL];
        }
        
        for (NSURL *fileURL in urlsToDelete) {
            [_fileManager removeItemAtURL:fileURL error:nil];
        }

        // If our remaining disk cache exceeds a configured maximum size, perform a second
        // size-based cleanup pass.  We delete the oldest files first.
        if (self.maxCacheSize > 0 && currentCacheSize > self.maxCacheSize) {
            // Target half of our maximum cache size for this cleanup pass.
            const NSUInteger desiredCacheSize = self.maxCacheSize / 2;

            // Sort the remaining cache files by their last modification time (oldest first).
            NSArray *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                            usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                            }];

            // Delete files until we fall below our desired cache size.
            for (NSURL *fileURL in sortedFiles) {
                if ([_fileManager removeItemAtURL:fileURL error:nil]) {
                    NSDictionary *resourceValues = cacheFiles[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];

                    if (currentCacheSize < desiredCacheSize) {
                        break;
                    }
                }
            }
        }
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
    });
}

- (void)backgroundCleanDisk {
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];

    // Start the long-running task and return immediately.
    [self cleanDiskWithCompletionBlock:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

- (NSUInteger)getSize {
    __block NSUInteger size = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.diskCachePath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

- (NSUInteger)getDiskCount {
    __block NSUInteger count = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.diskCachePath];
        count = [[fileEnumerator allObjects] count];
    });
    return count;
}

- (void)calculateSizeWithCompletionBlock:(SDWebImageCalculateSizeBlock)completionBlock {
    NSURL *diskCacheURL = [NSURL fileURLWithPath:self.diskCachePath isDirectory:YES];

    dispatch_async(self.ioQueue, ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;

        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:@[NSFileSize]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];

        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += [fileSize unsignedIntegerValue];
            fileCount += 1;
        }

        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(fileCount, totalSize);
            });
        }
    });
}

@end
