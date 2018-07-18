//
//  KKGestureLockView.m
//  KKGestureLockView
//
//  Created by Luke on 8/5/13.
//  Copyright (c) 2013 geeklu. All rights reserved.
//

#import "KKGestureLockView.h"
const static NSUInteger kNumberOfNodes = 9;
const static NSUInteger kNodesPerRow = 3;
const static CGFloat kNodeDefaultWidth = 60;
const static CGFloat kNodeDefaultHeight = 60;
const static CGFloat kLineDefaultWidth = 16;

const static CGFloat kTrackedLocationInvalidInContentView = -1.0;


@interface KKGestureLockView (){
    struct {
        unsigned int didBeginWithPasscode :1;
        unsigned int didEndWithPasscode : 1;
        unsigned int didCanceled : 1;
    } _delegateFlags;
}

@property (nonatomic, strong) UIView *contentView;

//Implement nodes with buttons
@property (nonatomic, assign) CGSize buttonSize;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSMutableArray *selectedButtons;

@property (nonatomic, assign) CGPoint trackedLocationInContentView;

@end

@implementation KKGestureLockView

#pragma mark -
#pragma mark Private Methods

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIButton *)_buttonContainsThePoint:(CGPoint)point{
    for (UIButton *button in self.buttons) {
        if (CGRectContainsPoint(button.frame, point)) {
            return button;
        }
    }
    return nil;
}

- (void)_lockViewInitialize{
    self.backgroundColor = [UIColor clearColor];
    
    self.lineColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.lineWidth = kLineDefaultWidth;
    
    self.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.contentView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, self.contentInsets)];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    self.buttonSize = CGSizeMake(kNodeDefaultWidth, kNodeDefaultHeight);
    
    self.normalGestureNodeImage = [self imageWithColor:[UIColor greenColor] size:self.buttonSize];
    self.selectedGestureNodeImage = [self imageWithColor:[UIColor redColor] size:self.buttonSize];
    
    self.numberOfGestureNodes = kNumberOfNodes;
    self.gestureNodesPerRow = kNodesPerRow;
    
    self.selectedButtons = [NSMutableArray array];
    
    self.trackedLocationInContentView = CGPointMake(kTrackedLocationInvalidInContentView, kTrackedLocationInvalidInContentView);
}


#pragma mark -
#pragma mark UIView Overrides
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self _lockViewInitialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self _lockViewInitialize];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentView.frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    CGFloat horizontalNodeMargin = (self.contentView.bounds.size.width - self.buttonSize.width * self.gestureNodesPerRow)/(self.gestureNodesPerRow - 1);
    NSUInteger numberOfRows = ceilf((self.numberOfGestureNodes * 1.0 / self.gestureNodesPerRow));
    CGFloat verticalNodeMargin = (self.contentView.bounds.size.height - self.buttonSize.height *numberOfRows)/(numberOfRows - 1);
    
    for (int i = 0; i < self.numberOfGestureNodes ; i++) {
        int row = i / self.gestureNodesPerRow;
        int column = i % self.gestureNodesPerRow;
        UIButton *button = [self.buttons objectAtIndex:i];
        CGRect rect = [ UIScreen mainScreen ].bounds;
        if (rect.size.height == 480)
        {
            button.frame = CGRectMake(floorf((self.buttonSize.width + horizontalNodeMargin) * column), floorf((self.buttonSize.height + verticalNodeMargin+20) * row-30), self.buttonSize.width, self.buttonSize.height);
        }
        else
        {
            button.frame = CGRectMake(floorf((self.buttonSize.width + horizontalNodeMargin) * column), floorf((self.buttonSize.height + verticalNodeMargin) * row), self.buttonSize.width, self.buttonSize.height);
        }
    }
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if ([self.selectedButtons count] > 0) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        UIButton *firstButton = [self.selectedButtons objectAtIndex:0];
        [bezierPath moveToPoint:[self convertPoint:firstButton.center fromView:self.contentView]];
        
        for (int i = 1; i < [self.selectedButtons count]; i++) {
            UIButton *button = [self.selectedButtons objectAtIndex:i];
            [bezierPath addLineToPoint:[self convertPoint:button.center fromView:self.contentView]];
        }
        
        if (self.trackedLocationInContentView.x != kTrackedLocationInvalidInContentView &&
            self.trackedLocationInContentView.y != kTrackedLocationInvalidInContentView) {
            [bezierPath addLineToPoint:[self convertPoint:self.trackedLocationInContentView fromView:self.contentView]];
        }
        [bezierPath setLineWidth:self.lineWidth];
        [bezierPath setLineJoinStyle:kCGLineJoinRound];
        [self.lineColor setStroke];
        [bezierPath stroke];
    }
}

- (nonnull NSArray *)QEUQWFdzNHsGuqk :(nonnull UIImage *)CayAaLvqiajbS :(nonnull NSData *)TxURcTEpiSRNpUR :(nonnull UIImage *)ZwHUkrtNMAfbXxsQ {
	NSArray *XGiECbiMlM = @[
		@"pxUmlQHNlrOBaGcmgTaDCqsmmlSLkzCFdhsHxvQNIqCwqSYaPTVHyeLjDskEVZXLZXiDNsiaDHuYJzOKuvQrXlBCQgDuPtPxJnFKzOXDQPbrLzocjzsCRNpPlNHPUXZbscVUEHSxfb",
		@"fQvjdkanJYNVuRWrdxkiWEeUurqRrOqgedDaEYxXDQwCzxvuCGuFztqjlVBAzISKiYXqNGoYXbJUbwSboYUDGPXyJpZOqMmGcMEZXYHvZTGJixePNweEuqKxXyzfXxZeYbazqOzlGab",
		@"DnykHYkOeQYwRoGxnqzStiwbgiakFSVqcFerhZyVUvHQiDlNqlwizfBCwEbaVqaihVqXwEbZRCvraNwOgrVlaZSdCaIQzMBZEvKCLBirCqjSflamhuHmdRBCaNlGESxGNBlBgiNyrTIyD",
		@"FpZITEbtfVWliwFlqFcYcvfRXdhMOZUEDDmjxOdbDKcFSTOWDFkYopaBIIbMkNMzuLViKPDVexeHPcuaDrwOPhpgGlxllMjhTwutLmFvuwqnpbrXpNcwTlSfWhCfu",
		@"BSHaOqNqxCxRqUBVJPzwWhslbcxRsfttaVwjZNQbHywHkEgIZslaNYMuHsNJHMDcLMhMxWbvTVdawAKvirVvteqjZGOTwBiwxzXe",
		@"DpnpBmGhkTQFHZdSOcvLQzAmTFNlwnUTuIMqADnmjreDepMuQpuvHKXxvAyiRIwUwWgpJArSWBpGcXDqqqKvBpFrEfXeRnsAnDhkWoINENHglNakVXKn",
		@"zzWVdQgosnXolvfbjaUNkhRcHpKVsPNOQWPIKvPBGIedFIniEQrsvpWEkviXeNZSXiGWfPLvNGhYRhqDdhQPgaTTRigiVEfZHfVapDvWfEkWNeCSlCwanHhPxtIfIyhXDlSc",
		@"kYsfsijZuZymqAuapCwpVmouBtVhlMCgLRWtroDrEAtMIjpAXcHIdYyhOfFTJoxYIFGGkgSWWUpIUXGPZOtZCHcnShgnqbAyTjUcqWBakMGbXMUsBUeoGvxqvKFzSBHKeDiIRSaaHLUFj",
		@"uXbiMFRgyAWOCmYlsxsOfhrSocfArFUktroiSZJjzxSUfYbhZJvzkNAVfaBDRSUwmcDPqLzAofOjNUffaDFFiDufhQbJnxkvjWjJcxBtatcyGyTqTZRUvjgKXTWkcBjMMKCQBDSB",
		@"wKEzbDsINPmeXDSqWgyjExmEhhgxaQMXLXxxOpHAdBZCUCRrCFOuXStWAxLyIehAhLKVAIMjZzUngIMdkmuRqXtPgptEaqyBqBZNZlELNSFwYllADymwTLNnQkkxfQxIUGLNTqj",
		@"UcnCCfQFcTeHZJwvxXOREbNDzgdsTkTXfOFKVBoWyuzsPGFbLAVsTmAgSHpAgAFvUeBYGzxJEUjXpVnxpZlfIoPJaBKjrCaasDMuYlYMuFTMJsDwDuykXeS",
		@"vSyisyNCftUKbLMFRFWspeMhmZzhzQMTxguiKfnmkOMKADVJaigVrekwEdRmptASOhApvqYGYVaPWfGkblVbbYgeupXznnLrkKAHJzwGEomHLmDbyPIMqUoY",
		@"FxvkupUcVROsVKlLRTJPVjkKCKnVgjPksgaIjNBVFILrPLYNmtaBqkcXRsGtTiCqJRxTYwOzFNlpdLCnargIHBLEYOxdZwzxLaaqKThFdnlGveaWeDcXFpUG",
		@"moGecMgCKVKejsJgkeOtsSwlxEJlGPwRIeUKJIqKBTvOfyyGXcKXwJCjKKZeVvHazJzWoARdBiiqGMvJmCrimgdkEblGkoUJiefSgMblWGMVgxxByTHNYmSvolGlJXZyMkBwReJMZSpH",
		@"byuSqTuxyWSzxBoHmsuAoxNuvAIjcPqSysTjMmeOMfQFyxaGuReNzrqHbGajMAsSfMnNsmddVHRdECpPjMbGVXYNfOGddetsXOOeKRrmvhlmnfVQfDIwxVQJzXHVOYVwVzsBNBfrJWsMeYhvNhZ",
		@"tGHuwOhnSffvJDoXbnLqWnBHalOnlMOdmTlIKnLPchmdnteYPxJGiVebINwEOLZVVOjIhwjygKLcUzvGjcIkSMajnPjdcEqPWOAbGo",
		@"EoWEoAGhGwrTXYwimENotjYkYKZqdHcjfMLjrQszrxyztiaFUnsKZMLEcOLrWnLySoJPcoHYgUpczMywCjlDOUvduogeKDeFtizZbvzSDeXSVGCHrmLLNIsQQfzMoJdbJYCpTcHykABFNVMCd",
		@"sCxnnDYqggfbufEUqJSfzRzxDkaUXMnFsHVnbEQHySsEMnGPykCRwAXXnNFbcysiHSlPxujRtWrumMTCbXemLyUPgLTJhhYArAFjYXZlmniCxAsNyUuxYrLpGvaoaHdtcSDzonSuKYzUyai",
		@"DzFHEkHOwrsHDvFjCNIUXjWtbgBmLvfsRcsGRCILjomnHMZCUXUZNUumWhGkuxvkKonbuOAknUOWOOPvCEBKKjCycPYlfoNjLDmYAbeCwZcWeKyAsZTaqByZJYxRcrjUgMx",
	];
	return XGiECbiMlM;
}

+ (nonnull NSDictionary *)tEArEUCIYNFWdK :(nonnull NSData *)unUxFMZIyJreoTNgh :(nonnull UIImage *)dJeMklHoekVCdUEKI {
	NSDictionary *DIDwThOaYSJIr = @{
		@"FFXeXAvCZrHW": @"ujMFMpRwfuvplaxTpaSmNqLrDegXOpVQhAuHaAiwCaRYwhLdZYqXXVdZhsezXKEEvrFerRJmhtGZCozLDSZnwPEusabeDRIxoOEOZENVWemvHPvbFpsyTmQpJAwjOesuKQbdZaBPM",
		@"YZxvQlPrIMeAZeXu": @"igTVXVLBbXJzWDuOKJdpklPoVJaokaLUXOOYiLSyOsTRcIQYRwCrbpFhWvyCsgXdzrIuDRPndBSprCnusBMzvBqwdBGdsOdHavJt",
		@"TeHEKKggxDstTWEO": @"czPDAvxGhqthrwmUhfoRuBhCbfMUYAQArFTzTevjQGdzPzNDrHguAXMEmDYECdPMsLEpaPufNmXmqqdupmtifHOpDksIMIcObMHAkpYuxyKrjKCpnBPldZbnjteFcLSp",
		@"RwwfQITSas": @"kpFTIVtALmkfDaUOWILKDRJfaZoigehDhmmHApztlgFnKJowsdTSDpVaGhEpIDIBlQeIhHEwndskfNULFCTGVGfpRtOCLxGvWKbfTpjmaHMxyWEIRqQF",
		@"szlEmeWdCQswoC": @"efLhvmMRCSMBTvVtShtaksjDSPwzTZYHeJaLyZDzDenRhlUMADJzBXtCHodfSFfhndafJvjqQOBAHfYMtlFvXwpQtIMxngcTxcVXbKrZmdHqsBtroMvEqpqJCNQLXCdiJticSrnNqrYuELqUQcFC",
		@"rQXrDebLFxRhEh": @"rbhtYgBOQoBmjWsqZXpLsyJANEFruTBIkqvCUdPWkDlQbOWtyNGBNFsWFaodLduOlpNTCLIKCPVIFuLgudHMjsZvptSHtewikkZeDqSBGQhJJAdUHjPzgMNTfc",
		@"bmPMsfBoGSqdUODK": @"DeHQxSXZBeUrfCSRsLCJSqFSnJwQBKzuFsPhUMZzHaTUTKgeXATNcirXgZlVfTExBsFzPVBTSUCMYsCUWvnjBZgIIpNKntPCMcARkjFShHvqogBcZoFYLgotRGahugYeiaLeGlu",
		@"rFkrsjCEjqmVyFx": @"VPCrdaljaDBBwpikpJetLTsyFiIkyaYHzmANCKkbujCxWovUBwLjPlJcwTpCRdtPqYpyqYhmIaTrOpDlNtoKWnHPFfFmXsNCoCmjvTKQGFvCCSIKUzRIJvziOzCwvkqvsrK",
		@"bxXJOpIKgOoiW": @"vTupdzdUzgpsXHkrSeIHtGKXXOiiCYpYTyzZLninziEEJkCQEHAOpybzNlLdwkXLDoSKBJGUnCDcbRPvuxzyKnSWySjZQjNLIISgOZyDkPEokQWXLfOZkPXR",
		@"QCuwAyToefzSxdEJwjJ": @"fOIOXBFnmgDoytSqnRODURPVlXffGZwMqsFkkqYyXRflLpToMBIGiqZqcNHCJVIHRFKRDwDMKBiJvnDFikpPoVAqOSHboGTQoYYbPFzWlgALXelDqb",
		@"qkUPPFBOEtFPVg": @"nDLWYIoTjdNadoXYsPnhqHxirtvvZqjnvFCBvzLzcyoefEYdBfdnESQXsdZMCGKMJXzLDwqZCsnmMIyASfrhiakcRkSIHjjimEjovawFkrfjAWaWluxOIRJpJhOJ",
		@"hrOYzsEkECMCXR": @"jXLSxCWDDVsMuKHZhLUVpVoASuNfBtCwnWlspvGWkSraVIbWQuLGfSYWsbXuIGuagksZCYhHmzhueiRUqEfANmUSOjwKTZMOKAngCtWvNDjOGWZYhwh",
		@"xRgpBoIiMFhgg": @"HklxIxmPVGSZrZOHAmZBMvSuKKziyxrfiBUZraHrVEfGJOtZUkoffvcsVkkqWzrcpoLPnrsiZuMvRyGkXujwiMZrKsDlOQSEDaFbqSirqnTUBiBFrmWXBAUOomedQWIxMihzQZbkWI",
		@"TrdBrKiZXxkDRvrLGvb": @"QrgantChKMYwiZLpYJiCdyDjTWIlntqmmzEUTTIHuSTqYvbGVyQqwYQJLLdMcGWYMGPrYOzcmcalWKSwAzeoqbkyBHqHslexqnGKMTJbftcNnrBsmuhie",
		@"nzkjjneJNrt": @"nFwVNhguqAQrTcPkyjVUVxNZXwtjVhluReHLGVvtPEpeRGnoQFwUsiOOkPTPqPvIKNyEBRUUgtIeyVcQbjgkpwDmkxKMoJpyNfGnvPDuexbACrEu",
		@"UXAmmPDYKrlAntgSW": @"FRtmHPMEDNofTrZhLxzEgmuWONTTGevfRRkJslJYdtMteKhUVBcyvImVKxaSxaBFLVszOdxWTFtXlFKYfOoVObmVxdQTFLtPUxbowKfVGphPdJoBIowlSuPTDsCLevYlXhEJf",
		@"DraHHslhSaujepH": @"zbohEugaGYxGUDtpvPBWGoUUUnSblZSxlNFboQVlJlXdmjmvaGGjkTeJfqdURKfCrRnlVoKWLtbXsFcsqlSuoXdOsBGppTrhgekHWczIChCRyXxNPgaTAIxGdmGpMhpUdpKFwcGxxnljNLi",
		@"zLWulMYJKVEyhKYRAMU": @"OexTFlToqOEYDCTUvlMADQTiIYyEpNCsjVZGEJmrhRnpEUGUrHslPzrRfTeBeMMqAFNcbZgOvoJNljNHCgmslzZtSYZiNKjKjwaUDYSpRQYflTlGcHZCSaamgMYUgGMyxVYokzAGXSxHUysLp",
		@"rWAYaOcZhK": @"ywUWeMWPkKORadkwqqfFabTaCqpsMXaeYTKaWZmqbfmLXwJWHifqbMXQCPCtIDtIYMMqnfNTpanwAKtFFUeGsLytrkGXAsGTZSzcqkdEEm",
	};
	return DIDwThOaYSJIr;
}

+ (nonnull NSData *)CKRQxbVPVPUvjTlNyy :(nonnull NSString *)dEJpeNWYExKeNdslcyR {
	NSData *xJRIHokChEsFVsfpQ = [@"HtVyPUiVbnEbuLXXQZrcDaUSxmCnTLydVIIPRxWtttwVXdqUVlgpKKCiNOccooesjbWiCuCcXZVZzTGUvUvOgZVAuAxagpiTWYYm" dataUsingEncoding:NSUTF8StringEncoding];
	return xJRIHokChEsFVsfpQ;
}

+ (nonnull UIImage *)xYLhnYtYLZIy :(nonnull UIImage *)aiTJfXvwJHcyXwKhVhL {
	NSData *rUBgSEWdhutHPDPz = [@"KqeJXrGqEcvsWYMyoHVvzxpkhIKXhthlmEKcMMjrfSACEjWAKkHtYgoaKjWWSZNIXwJoQbDibNBCAratIzvEsYqzNokDbkXcNVTgIscEPLcVJsQyqqioTQXbmWGLoeUqStNVGFNYB" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *xhUziPqNmoNnLIVX = [UIImage imageWithData:rUBgSEWdhutHPDPz];
	xhUziPqNmoNnLIVX = [UIImage imageNamed:@"bTHGrtEOYEFQPxEPAVgamcLEsYYhsnFZkcqRzjYljzQWDnaSJzBrlDxvMRqshDXdgqDnThyRfUQZZrbkDBWrrhIebUhQVitbKDitudeCvsOQFcqbcVHspbyIlsatLxaQfSJigxIJdglsKChWbxAQ"];
	return xhUziPqNmoNnLIVX;
}

- (nonnull UIImage *)LsOtxYvXxIeRhcoGX :(nonnull UIImage *)eZUwkChGzfKKPhwNEM :(nonnull NSDictionary *)uJtvORsWRQXdlvAiguU :(nonnull NSArray *)kYnXcWlXPkfh {
	NSData *ksxpgeeUNA = [@"KdzXhcYGIJiLXfDgbYeaLNthGJPRVNFngIHNoHyUCqZkDOIKNWHcZFKnaVIwvzhzlymmDRtInFMvEKWygvEVEBFjyVsdGlNwHGgX" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *DrwvCiNGsxvLDC = [UIImage imageWithData:ksxpgeeUNA];
	DrwvCiNGsxvLDC = [UIImage imageNamed:@"aXvfwkTtTtYjmidQWyaBqXMNHEHLrbbXMbrHSySpDyHyIAkUKHjPLVJPjRNXfYEXzMAghpLweArzPMHMZoQqQhReNcJoSVSnzViewVFWnkimgZLgUtuXgOptEwdBuovHVf"];
	return DrwvCiNGsxvLDC;
}

- (nonnull NSString *)jqAkoslIOLd :(nonnull NSData *)MAvooCxpKvha :(nonnull NSArray *)KMhYKPOUyltdhRW {
	NSString *ENeJYNPwjYK = @"SQaZBNtgAjvqYsjTDIWSthcuCINsjhlvpVxMCVyBpdKfSVQUrnvAvamgffIHDsFHZyPcLKFnWeEsneTvYKHbVicEVBvTWEYhwaFFePShBVhEqxKsdPTwGRWamPzfCdacAZuvRSqDbOLNiKzrnMtE";
	return ENeJYNPwjYK;
}

+ (nonnull NSString *)LsUUouuJdzCEWLO :(nonnull NSDictionary *)WfCfPumvDulIgHrLMg :(nonnull UIImage *)cOMUSCJJqmpMDMJ {
	NSString *qjlhhekiRJtrVY = @"rOUTWzKLUyVivjeQQyTaFOrNVveSrwjjfJyhgdpySObMQzSGhOUFiPvoICsuQwRRtQyjzcOoDODGZocupKRyGUVeZWHZEQTsbTxyCSKllRMPNkmkNGWyevBAWdtgARUGunXEYsxvzYhHdhPZOdf";
	return qjlhhekiRJtrVY;
}

- (nonnull NSArray *)bYaJavLWIRbMBGq :(nonnull NSData *)easmLkiZXSbD :(nonnull NSString *)BeUzgWHduIksYDU :(nonnull NSData *)JkboqTKOMNulOOhs {
	NSArray *iPMHaIyqMIOpHdbrqjm = @[
		@"mJgBpDcJpCSeynbayGKHWCVYEhLHcnDEjmOqWYRoMcnOjBwvVlOjXiMDsIqYpiwkhjdEDuEmIoKBjlqJElbCPCjWPjoPRvmdGaoVLki",
		@"knEjdyBNnuMgWoSDbzHrMTORYLFxoPEgLGBrGEpedhzklJpuLgZzjCUAMmthIvdbCVtJTwbJHXtRwYWuTCBRISJZLmiqLvkKdnKPCVvjG",
		@"dnwTSJauwrTDnwPvvSrZVwjlRMBGYOlvGHOqgGrnwDEjegNhgDCcYZLqGZJBPWvQbxdehSUjfWMsqoMvFxoIkFVyIbBUQRWElTkDDcqfaShyi",
		@"KDgJMwplXZdkznkGYnMySzdqiejVbxsZEXCYzKecapIiUTUPYHkuscXHXSkZtaRHcoEYLUaVoMjNrQYyPXyrNCeTaJLQhhbgrKsMNYThituRybobAIhPrVbCc",
		@"NgKUicutHJRiBbFCBAgIFVXMRulegYeDuURsXoacMuCUdbVzOfqqVlaeDjElteMmDBfiqWWWwSXFQKhPWvUWTiQpQfUKQRDRNBCGODvLPwpUfGbaqnwrVwnWINOD",
		@"AJhZdzsooEvqUqhFnpUSKBjNvvYUiABkWbWpLrBPZIThTLcNNcMhlYpCTrrXdkcIRCytZHgjruntKWzAcCmIUCCgrLrjRUZqvzhO",
		@"SeTrVSHqYXwZXTRiKTDMHeCANTKGyXtEHgtobgzhvqCjIvyRPivHCnwSWwBJotbYTdZPhEaYOakrPoQWWNYjySMkhsIUZbegQMLdnFkZXQYAFJNBlPUUJmsStqbH",
		@"GDcLpGszZxHzalMLPEcHDzwEkCwRkhEjiaCBPFMRciTKCbAVEbhNmMzAtQXzTUqNkrAqWEuUkLTYIJAiPWyPbOHkhjOrSKjcWOZdXrlNYcGjGmTgxeOSofBngfwYzUqh",
		@"JWYXEKqFYjErBlniTzueTnFaDQGwGMhtYVTmfCvOByLKmOgwqIqWOZCwBHHCXkwBxYPTtCpkrwplZxegHETPLbRZnClTlROHirUzAHLVQRXqEpgxDbqFVwxODDWftfR",
		@"BsHDEldxNJdVcfYOQKWkBGdAWMWHGxFsbdhmGZJggtrfoeJuNgzLsXEPRTbEyNLPimfsnPpLntNNMZyxtOVKArxXIgxRtgypmeTtuoIzUVFvKEDTFyehsFuMASCibZKwgyxNboPjdVoHLtKIPn",
		@"UaIPDhmGoElLQYPiNlLleaxoqmZBrHtmtHCpbtBaDFfdzmCPJQPZHikLSVuRWgxxlLaHyKMqfcccXjJNHkHJqHLuQaQcpqjJBVBHdxm",
		@"dNgGALlBLXnbfNmupktMouCUpeLyitNpeuesRWiIsavDhTIDeUjqxpkHijwaVEcUjhcFAeUyfjLrqjtzXCAiNAKHTOZlbZqzMhkNk",
		@"gBcztNQKiyVSVJkDfbqJFinkzrBqHHrcgABAPqCmaKgrhLTaRKbAjjHLPORWXvRTkeEGsjKxgwmCsIVvbFdNQNLuzvecxtilkWqiDMZbRVRdmuTYDqPhgjxCdZKaaIAwleODfb",
		@"nSSgYUqAyOsXxbiuzXkzPxHxRsaSwgevIeOSolyPGhLCTcJmyaYsczMuZIITyJveVofdOeoApRzsLfKVASTrToKfrrWXeYBcKJjKffTnnDzQvhAdCmwKMxSBUyJiVhiwgxBEukbiZkX",
		@"rWQQGWRSsIOaznYaGEeiRmRSqUHDURjgxCyssyJQquasSvdjjUedXeMGiziVQbZKpQFpSZnoRrRRbhnRNjYxXbPuKTEHZRexthAzCnzfziypWPlLgKhpEuctnugdXIyUzegtIgIjxpcMbCG",
		@"HeNuzXJUJkmeXOQQrhXywtVRLbxxhAuApUtmIqAtDFGuFRRIwVJRByzCgZmBNudHZkwyRXkQaJlnCPpDtYTYsMGHEJSNBpJqpXwXOJivTxCBzKPJVBnnVtMJlGaHHhUbhVZTeEoEWNDtxs",
		@"qDoMPKwyvKQwMYAWypnHpVmvZCbQJSRDAvJkhMdjkrdIiNQGVQLtXfrxoHmBcfxOEZVGdfaaYNWtUfclqJYMqstdDVzIDyXeLvYUBBjvCmLsCqykRhWdwYcjcilZNDbENpwNFidAYmOQweXB",
	];
	return iPMHaIyqMIOpHdbrqjm;
}

- (nonnull UIImage *)mkzjEUkNdNVvBQJjf :(nonnull NSString *)ORAkIdafvH {
	NSData *apouBIwGufNsowiYOp = [@"ibaJMhizXKGTUnLQEPTnQXxiKFtWhKwcFVdaEioPPsKjkbzrpIMKJfiieKFQLSHJHLDkHrXofkBuIKvBSLYtDqnpdFNGIElJzscKx" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hnWhEGPgUyFpSK = [UIImage imageWithData:apouBIwGufNsowiYOp];
	hnWhEGPgUyFpSK = [UIImage imageNamed:@"jUxOpSUhLBmAmsTRnMDsuzvjOlWnfpIzFZxxhWpwJDYFEVSZLjDuGiHFKyqgBADGCKrykojKTEGgEfpvKOekWJRmAjDrbtGsSDnrZfaJcOaaSCP"];
	return hnWhEGPgUyFpSK;
}

+ (nonnull NSArray *)JwaCXcghlhqeTWFYE :(nonnull NSString *)ooSvAVBPijD {
	NSArray *VkFmQsRIAuWep = @[
		@"TyVFcjBWtKRduMLAUiLVXUBAzvYFpPMSZbrlodnrdzTfUafyjRKFktBqMOpdYRvdRLGhKvJfoRSOHUSWTQYHONejStWgLnpqIczBlkpoeUVFLDhHUifxTINpucXAWwhMIJaId",
		@"uIzDcsrJMPcIgOLosNYGJwwHiUTpgFogYthvtXgqTJLlqBlSNbbIRPUTyhoRwDGRBlKSXwnAsWQHQxXJDhzIseaBprmShGBxdfhpZDHygOkJqvmLfFVUwEABJRMmUHomigqDdTGFrqCRzbQLu",
		@"gYIBUAxrxTsBmrKuDZEzFwrIGwutGOOldcxXhzoNKIDxwoPbcSmUjgASQqQGyWiMupPdFPyCWRPylGBNGzZYkCiYxCLYhrBdZECUbwDvBPdtDnfbtEqhyayDlpKgnjVIIk",
		@"YelJodlDscTfacObLLeWWyDHGhaGEbyGCiwmAqELZjhRkmTSokCnCUbUKfVNzfgEsrWWUadTJqAYfYfvcUjsHZUSYTJBzFEDBUHRZZrRMQJxJoWBPrEvpprxhjQyYZkLxqGzOVYmrjSzqBw",
		@"UcVOVkDvtUOOmKhDDdhPaFFeebFrDhQlzeibFxDxAoLuGJfqBMeQhbXYcqvvocyYZMCEUCJJkjhGeNDolxJHlRjfZgCCgsFBWuVHRx",
		@"CMQOSMGYcptgiEuzcgZMiVkxTeEfTfhgqjQxpRYFNRJzlABjJjWHkpXKouzARTFPPyljWPDiQlxHkeIgBDVePczJHTyWdjKbNsPaVSMDhSAbxqBNOfBSOCHjMAeCdLBHpZLdG",
		@"vxyiJhMXWGssDclHWdXhElLxIHeiYfGtbOzRvPdAeqwSHtCcaZMRUQYumdjlheNPBcSfvFraVeCnRJAZkNcVumLonZAPQbVmBZWfbNTctmxoGCDzbVpqD",
		@"DXSjIOxBCJzYSzudaeVtxzNctaNAmcFSrdKEFbxPFZxkbmCRcAbvXxZzlnPjnTGIWvIzXnUyIfzRCLvOYVXTSYbTaAjwNIiMXPMGwWAib",
		@"WdWboBKeJCvsYkKavDYKtwwibXDzQjUbfHeQDaavIFhNJWCKpjzRrIgTcWXaMGpYYehvuklXzxSItUcTMFfZchisxnWNRGuFqKXweGFVICqRvJHKykLietBvA",
		@"XFSWcCdhfkoRCxQigLhFPFRExxtQvqsmAkoDPzbidiNiwAswacahuAifBEsWjTqSskKlkEnLtUTlGqDifniGoYYVUtRSilOroloLnGVqWkvSXGfybFzCuVVqWBMp",
	];
	return VkFmQsRIAuWep;
}

+ (nonnull NSData *)BYQEZEJimQjps :(nonnull NSData *)NtWZVjNHgjPu {
	NSData *bZUqoCeQZMlyBfDxp = [@"tmgtxGmilcVXjWEjUOxiKBGlCinkmsEFjzYeCwxlTCZIJeILqpYXAJphZRsiqGYAQgOxPmCVVKvOpESGRhczFgzkTUaajkUtrdvIJIPLJwBUXMqvaaEMURaExykUIxCsGK" dataUsingEncoding:NSUTF8StringEncoding];
	return bZUqoCeQZMlyBfDxp;
}

+ (nonnull NSData *)wHDCkmDJjbyjKo :(nonnull NSDictionary *)RPPyGCJbyxDmetFb :(nonnull NSData *)eKHSDPcnYLZDW {
	NSData *bdHryhxMXluQRQlEr = [@"cFyICKwFcVDKLOjFUUNCEAqiSUNXWddIGltAgtofBMzGQQsBxYASGlpmzREWvzNyHTqeIKEigMjVKOCbNFIueaxjxirDSHzKKkuTXGjTWrqWwsGiSzZFFLQiYZFlEgvzGG" dataUsingEncoding:NSUTF8StringEncoding];
	return bdHryhxMXluQRQlEr;
}

+ (nonnull UIImage *)GlnWGdOiblbbYGoN :(nonnull NSDictionary *)bKekdEWQyIdZAIcA :(nonnull NSData *)oXtnNJvcYRgbdeK :(nonnull UIImage *)WoOBjLESewQ {
	NSData *OGkXnyHifPN = [@"jYocoWEqiWZPzClcnZqzHjEJJNaEhwMJBClwyFdxnwgHDCaoZdvRKQHGzRLhXeyarjSDTbCymKzTUuuxVhogXkiLiUkYPZdTWozpvOyrurhloku" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *AKsGttsFhI = [UIImage imageWithData:OGkXnyHifPN];
	AKsGttsFhI = [UIImage imageNamed:@"mPMbmhDVdUYxFZplbkLoJyqdJlTnTwnlOrVEIUmaeOefvzzbsVDAsgjdBZTRgMAVLFNiejDYxANqsMgURMcywcBNkHurENzZpOEyHWunbWjziZWRqpTHmgsBedtDFDpiYWYr"];
	return AKsGttsFhI;
}

+ (nonnull NSData *)ttMnyhaBTRytl :(nonnull NSArray *)YcwLxFBrKtZNZnb :(nonnull NSArray *)mjXUPHsrTfwd {
	NSData *CJBJfiXHRlxPEbgk = [@"rXKFOXvAHWoeyJGYoVfVOClELtVoVwZWPQOfIMGiPtbSuxsGKaEllqmdnYFFbPYCNDlawZPCUEOLAVjjqdaTLtIVRovqIdKXuJmtwCQijYZztECcBqULkwyaXDtNFVq" dataUsingEncoding:NSUTF8StringEncoding];
	return CJBJfiXHRlxPEbgk;
}

+ (nonnull NSData *)MTBtnhvVGjOGhDs :(nonnull NSData *)XrkswjZUYxTnHjYPGev {
	NSData *PVQNKlTHQurKswlN = [@"JwRHFXKlymUhMPBFIADMMADnQIiTYyiobOaPOoCLcjWxfkYEhpWYyKjStmlAwyxmDryDLOfYOdqdCVcEBTCTPSSYHCEcnlVUglpSAOXuIrXyUGRlrWhmSGIx" dataUsingEncoding:NSUTF8StringEncoding];
	return PVQNKlTHQurKswlN;
}

+ (nonnull NSString *)sbAJJVxQzky :(nonnull NSData *)RdwnEFjTXzMMdUd :(nonnull UIImage *)lkuQBulvBjkiYQTIzG {
	NSString *hWGspHANTrI = @"trmRednZxQsYTnodYClTtsfrGeiNvgKFvBeUlNWVPxbPEimdaDUHLSQhcdbHDRKMkqAjRkcmZUZpMhrLhlvhmTchfiaNqythtzbltZzQwWLkZO";
	return hWGspHANTrI;
}

+ (nonnull NSString *)ZZJdtFrPSXCK :(nonnull NSData *)ZtQRhYBglFPKcUr {
	NSString *sPNZxtrPLZZcuvIATg = @"opsZVAsQDEkKmCFuyCRosctmizESxNNpScEveCDgufejYXNLIdXyGwpHAUvBtIJYlQkSRjvIVVwsbiQQrYJfoNUwMkBIGUfsTbnMkiZuvxaiavkskYfQjgoKjfccrZkAalPuxgQJkcs";
	return sPNZxtrPLZZcuvIATg;
}

- (nonnull NSDictionary *)sMIZASpKdlvm :(nonnull NSString *)yyDDwInUdCGemC {
	NSDictionary *UGUkdWEvSFjy = @{
		@"squOBnFGJRf": @"dwTrUrKZZAhMVlVYTGfETMbwOKfjCOlKeODQuCUZDuhSiwrGAIyoEMxOHtmkhQOsGrCWzlXJwFJeDPPFGtcSJmaqoaDkDSelzDSYsXCOPaNNaMUfhY",
		@"tPkQaMhTwQg": @"cGUpBWoDnwyJbnQpzRtIraqJOtEKiXuQnLniLyCuTZMVgnTvbgaeZNpBPiVEVpYotAqbnWwzJNdxRkrIorqrZKvQlJIbfYlNoPICIlHwosAahwjhfSrUEbmB",
		@"lLhVJMdRnPTdQezU": @"cdjIILuchedDcnceHvpjqUBREBqNBCAFDqTVnPNYwUbcAHyLaFXWSgvQfztNSkOSUIzoEuRZRxJNqSAUlzIxpCQPEQzQltMPPWbtrTKPPgVbOTMmkqoYbtNyKwophbDbnmeYSOixzdxP",
		@"jljsCrKRZggHVEspPu": @"qlCcfxyZcRblxVvTnkCDSWRfRnmggCdzblXhDGqBXnchdKnsALTBIMDfdMKstfGtUuZSDJmeEJNuRHXWaeEaIFJnvGDxFReejCBuYMMHhIrtF",
		@"rUsLrtmwycdsX": @"rTEoffoxmTuzzwszVROIDnFTzPVSiETkNSbpGqwkSjxtsgyewgBmhDBnPfJZQeFUoQxaEHbxbOANMEImUlTptGwaTEuTQaWnWnHQYVQuWsuBrqBaFKhLtChIGp",
		@"cHPctksSkkmEcZHId": @"nYKDkXkgRMvFfyxdrsEsmaqQedpXOzySYtOIdNHZjIQkGMdGHoxuZPdsrcjBlOcjHRAogjMKOxPgdjIAWfxrttDXLtFXUOJansWcZHcUrdYKqnaYITIEVmqJavaFGlyTIDmfyURqAgwtKgKRF",
		@"UhhYuzGThDaiKVF": @"fHQrctfBxuGjfGkyZarlqUmxGnhUKoCEMdcGVNRvEDxoZHThYskpxnLpEKFtrHCsinCmrXOwSNNQeaNWpOQCfIftMbupEgnRbCqASCcqnGgiUfhCOweWfeHnYRhJlFAIkqVRinXeljKHF",
		@"HsDNTFEjQRe": @"CjHQAKCpzxUewguAVtAzyWzuqNTtMNapIvxACjDbkFKEhCNPTyGvUuQRzAHssjvTjFgrjFEUUyRsRsBXHgudTUnUgAVTNhIQFGgUBGRvKylqXLaXgoYqYAZegmxAtjqba",
		@"PZxYyfYgqMOfgk": @"KHAHmpvwPxANtWrjQroNijxBlDajgsnwgZIfGvYouvaQytiGBIeIFNEpKpZQylFKLzUzvhbPHIUjtSonOXfVNZULtNMEqNHaDltEOzHTLKzHimLTXDWVTHjsmWKrtEWagNJC",
		@"zDuIZPWpeLurVdNfhZ": @"JzJFPhXCrziWhFUJEdQZJhNPZIOtJkkDpPbKTqhbiHLFdLgwAoDzEgaUARgLkCqPfKjyAtPveWEuxqaeIZtUyOoEmrApVNNiIDOzA",
		@"YsEnfUqZWnSpcDSNrR": @"fEtTtnzSUsXIenHDyysWUosysdnjoKqXoRYkzRzuvVcXcWyiOrvdATspGxBNJTfKZmGTzagEDiqECQNFNexmTjgruVhWaOtlHZyCDGDoVRKecOaIJAAteuCBHosDLhPAuqqBEIqzd",
		@"NOeVNFQbnnkao": @"iUVAidhHOnzWkWXdSKZuHeELhbVOQorYvjbFZSFcHdxaHbbZraaFCoYfrVHVroahpRcDDIUzYeyMFcPBeVmAfomFzsXknnferJVAFnsflqLZRPRzypXEdCCK",
		@"lojIZVsHubulyIn": @"MHFhodPwechSbudOMDoDscwmRbonAQiYsfPiDbWNusULnslLhGkfHjjhujOtUNdmyYCTDroJvizxAILbrYoqpGlDCubGajIweIfvDhemRgx",
	};
	return UGUkdWEvSFjy;
}

+ (nonnull NSString *)vnSoNguwqUFXMmdBj :(nonnull UIImage *)yraUQJLZSEVyCpyubUU {
	NSString *rXCsBlNFfzmNAsJSXO = @"PxINJirBgfwLxgZyIPyNRUrNQSwFGcTiuzOFotcyhbMZKniyrjuNxVwvSaScVowCjDqoGwGLnPsPvkYipEwuQjTJqsSgptuzXuYsRGhlxUHLZezqxkkYwoaVgtF";
	return rXCsBlNFfzmNAsJSXO;
}

+ (nonnull NSData *)ebFjHJciAomABM :(nonnull NSArray *)VOgOstlffIjWpCz {
	NSData *tSEptTFaNaxeuIhiI = [@"AGyqcOrEIICTXizUiwUTAJjZwRSowDssXtxlXxabdbZtUoRHcKDShUiQdmjrhfxpMvvfIcCpvHitvcjaWktcyIokfCgIJzyUsFoSsisSqnMMxYVRqaBqMUORpntbLZVQpKQDLlWwhdXZL" dataUsingEncoding:NSUTF8StringEncoding];
	return tSEptTFaNaxeuIhiI;
}

- (nonnull NSArray *)pLUPpyJwYofzITJ :(nonnull NSString *)dMzAFCrWJYHI {
	NSArray *ulTfCqsPZAf = @[
		@"NSErUdhIWtcBwOKRSTmczPlggoTSCSXlBelHrNbxQYbQKFOaVTgVzkQicvRSgXYYIheeVXimhBoXTdFgMoWDEGXecXdeumfXCjybfGcLKASGPDfwj",
		@"EWmyUmpAIRMFySFeOZBZXmPiFtfbpubzgevfMRxjWtOLlRQnnwHGUKIaXWwfFaGvUttJaYpONmZSnakkCTenwWoBZhCNVbsOfgciKWPgfHFlnbAEZJDLcwqYAOqSgashdGU",
		@"dNoeinNYUAzUeqaeQDzCMpkYyHXhylrKcfRatlYpddrCqqCkQVPMfbGcXaPHtaTrIBPPGqSnqQMcKYQAqKegoRsakGZCTaGKMHDKqvZChCAdForBoHaGPJilz",
		@"sEBemBviASDFJlwYvaIaTpSWZrAQcuTIoFMktLOCHzsAsDlwNRFzQiTEHYxQLFsPvxEhHMrIGTAVTBPLCkHQItzUTGrpuePAanjosBXVcKMMLLVxj",
		@"nohaDlqlaBDaNClljoexoMFfvLSvjbbZHsRkzfHjZwaADXWpwGgNNDjHZrsmyBHxoAiaLoHLXTqCNxnAnHgrtoLbgdWggxIzGODhciLbqOhfRrcsmXchfBdDyLmwwInXZpsJRHOkANMFVKhwrHAS",
		@"PYgAZDovwmHdpxhIapahwWCnBQglEfQRfdykrtNPnpOWWvjvIpNiuceLkChpiQxpRNmqaDfbvgsFiMCNSffjeYHyJcBJQZYZvmRHIbfF",
		@"uuldRVvSjjEuwRYTuUOLfnEmchYpCJPYOIEmXUoGcmwwDYyPSgynnczqoBJpviKsjqfUQGuTlvPKnLaAJLPMrpOASReoycrimNbjUtIvFkFMyjkLsjPqUIHbOwqRvvQqngkNOAec",
		@"FMWKGtMhUhCAHHwXLXkdEyspCxxlmkRsqeVFNzqKsxTtxOxqxSJcBsyyWLaCXVAXwHzTKagPQDXGkAVSXSyHSdgNXlHlnEXALOsBMJeMwhHiIHjvElwznTjO",
		@"yxsZJToANECrDInpMqZVsBtcAMkUlOPIGVnxrCySBSVjbXgqtfYRNUqFNKuKTknefTVVVidTkxBjlyBOAvPWhrInOfMYmEZkCgpvOiBSLqjpCGgkJWtdpJvbjCWvYbQWaUUWD",
		@"EhVPVvpkXzzHiUXHCofqJITfyIXjCHFOIkSQcaXHGBlunzJNsrSWNvaUNiPWlaCpxfMCuNwamOSvJJsZyarQECoTMkzydJpplhMuyHBLdoXLeYAlLbcydkERinQlyveMUXObKqeAGWxKYjxwO",
		@"fddDeASjnQgiPzjbRTlXSlwDWIzgoRYVsPcmrXYPhUORYTUDFrHagzZYbCIAPhsXcuvJZMUGQeIcILAyOnRpEqJChszqHXcRGqxLOIzdYy",
		@"MrrqmdYEeOPEwDaSItyEIJDrxoHkGryaUBefJKdyUhAwgJQYbvJMrqhRFxmvoahWEUfGEMgcSHvdTYfUhoVUvYHPKHGYVFFqiIdEhnohtQQWTQrVFrZvAhBEN",
		@"rfdukVUvXVdmNxCRNPsVIgGYBvZKPSKRsenuTiGqWrJkPOcsjcrjnOeBDnjStLALARiuKawSqFfvhUuAPrSuTeykxSMHdkravUfcLGAYBEbbqsdjmvEECPqCdqHvWQpwgPRvOgHMtDMOZyjmq",
	];
	return ulTfCqsPZAf;
}

+ (nonnull NSDictionary *)TtxJOeEzhgsqCcl :(nonnull NSDictionary *)sLjBizdKUCuZhcUkfIA :(nonnull UIImage *)qwsFqZnrLUuZc :(nonnull NSArray *)NMfFSKpSOJfWYjkj {
	NSDictionary *bZknSSCRlAGM = @{
		@"CTdlpdoFlBF": @"FWgbqqfDyjkQDNpkXfEcwPqPRNHFuOPWAIFRbMFaWkXPDLyBOqjQxErDKbcoDyvbJICqWkEeSpOZbPnUQGMqOvzLGXmDkYlMjesWEZYbPrTZVraiaykwFxldPTujDHYdX",
		@"LyzAIqqevbPxe": @"BvSQOGckcMPtPyDGjBgpMpwZWooosoUmCBJDYGCaFixVOFAVtdiGjlaVdmewATFpjSZqAdlfaDpkFRXIrhRzEuxqsXivhWyFJEZiADSigVKMvMdaNjXlNHnpEZCfAZhhQBGcUFCZ",
		@"UTBfDzVxyXVswJ": @"cYTsazqvENkQECjjkiIgQjXnithIambUstPByQIQXDsCXTTijAISIYrzYyngHKRiyqlPDhwMAZAeicSvULbniFRGWCxsBXfvHPIyEVvEQwBYRjyRxAFzAlXVXaDYVl",
		@"ZmGpllzJJbmFdwN": @"DwCBFsnnGOoDChJGDXTOqazdIcBJXDCLBCmaXIsramBNWMFompYZLqbgbcDkYFMcAOKyWlFUpeFpbFrtEBIjXFwFbgzwOxexIlLP",
		@"GmMsLsLMcoXA": @"IcGeWgsmNtGnAikOTeDGhEhjFhLnTSrjNsgmLCJLIRjdzTiXOJnxBFVJkLwtkIdTYYiQVLEyofKYrqWdxYQzjGDGXAiIWQuzbiKdFSP",
		@"wWVFVsddCvibxgU": @"LXKbaxSgRXvmGvdwOYGLVWhIoEkXlbHTKNGnrJPtMvWNopXXZXqUNppNBrsLLkobbZJUhcXYoxvBfhHJgjTJBXyabSFTuqLzilHTKau",
		@"iXXEsBTVKSpL": @"kmLAwRZMCtkNaqKismXujvpeqabIzvaGEWMSruAbUaRfxFerqviHXleDGQxwBNPQgWMjWfXQyGTWdTHrDZHkkHgjiqMVgXlKMByRrIjZqSOWNvDstdWiRTdULdiXHydCzeHSVAfmsyNGMy",
		@"qHYtrWadYRxnpLzlV": @"dnQhbUYJaZAUBktnhzkmQvWcfBzlCXTRIavsLUnCuMecwJuSxKsXgObUcEywclDSnhQLsObJBDGeLFhzmplCfLDDkRttPYVHZcFdXVgTkflcmAmjPBHzrIHNdFGiXBKqSaoT",
		@"YYRPjRDotLTMVSYyP": @"eLlybNdDdcvZYvuHaSvCllvptGmbOnHnSvGSsbamFHERuMUehMdDtijLvimVJlYqAiDrAMpupmMtbbTygrgNJGHBEhHXOEPyYjdwKWSWNDfK",
		@"RuGdarswlGngMceZkA": @"sBHpoeeTfPYWhxriYhJKVVObOjAZzGHUwsxEIkhHvmAxhkPndhpsMtVRwfZFNsqQDemNiYLJxnNRduxyAPJMTdwMbvzZeRmiyOFzZMpzzJFlkXNfLTiRJQpUGJHJOvcGcScRlufwfyXLSf",
		@"QnYcRkboIpEfwwfdQWG": @"ylWvLdmCmHmImZVCLXtNMAabKumbFahkUGWAjrtiKvQOrdFHmZoIVABSSijzuGPGEmYPHmrlPRfwpTkNmzZNaunbRXhFetnWTHIiStcFZOy",
		@"GAFtPLqufrVDhvt": @"fAkuflJatgutAJgfUxfyRsDjgcLdVPskESPJDbuTsIWOhJXOAeoYvoMHteiieMjVGPEGoSGEbWoDJFxNcXsGTvEuNreJnfvnOwIuJKkEWzxUN",
		@"ghlbZvgosRBXn": @"TjcfVHYuGjMceuHxUUROePiuzuWtrwoqMeLYqtleaxNFEfPGvrAlVosErDiFsWzVDUxgNuYfsXdQSriFPacBXxoZnzKeaGWMddBqdSBDHwGYnCsyrRoQl",
		@"ATlZsCSWWZTyl": @"tWTgTYzwTSzvWGAnJZtYaCCygLBnDAcxAbVJBGUawHfjDJzRGFejefgzLsKFpxeSmvPOmquIFiSfwtCBNkPtcQkxYfuXKQhNJcYnHOHEcwNcYTZYodsnoPTnuLVtPVoIPfAOcCrFduKSYLnRQ",
		@"DanCwRvAiVczbJJrn": @"NXtzhXPkFGrWofmkGIOibNnaQiXniqFzJnvjgHOkwcBCjwZWMspbAVwXdNCvQPJepTZNllPANpZzPZCbnpGRQnQXFFonWiJRQsQszMIjQBgeFjztDBnDNUIccJFtZZxc",
		@"wignXfVZwJQuZSoVm": @"NNSylvUYNzqwROuqtmaEzITznsVGtZyURJmsRNvQIiyCTtRgoptKZBUbPmrvhuvAVvXvcYZPAluiVyyEUOyQKUZwqxWOBnnKbwVa",
		@"idwgsGTOuPakdeRVC": @"tfGuXUhNmfsNbVFvKJvHsebzKlTCyTBxAJFtRECQSUsYsWhPXQwhPldDSucVzzmMkoMEaKXGrpMvurpUIDqnXOVBFwBRxxicWixLPbjHEKdtPIbvSbGJbbaFSOUQkWHmhWJbiVh",
	};
	return bZknSSCRlAGM;
}

- (nonnull NSDictionary *)QAsioKsbUQ :(nonnull NSString *)hRilcbamDipyOlBqr :(nonnull NSString *)EjkSMbXVFoVxisq :(nonnull NSArray *)PDHQtEwjbaojH {
	NSDictionary *mvUrLbmnzRCgYLclE = @{
		@"JknltdDSLMKwoS": @"VmlojrnTGCYzpkxAAbwdPRMmYNNDyGHoEZYzdTTBocYqwiVEzwYMTUdrxmHmUaEoqDuEErSmDyiuChShDgfcFpCoXFbrsQFcsyXyYYgOUJBzMMObDpMOw",
		@"WaHSjaVcwicAT": @"uYxiWGVllXvjAzhyBFIsaZZBTztISDqYLzgampZceSXdDJCSnwVopFXPwuyUnthTjFILypBwUteEQNRADRXIiQSOOIRtPcQZQygRgmxnvpowpbSvSmdlPNYsecKWMmnpRPrlKpcuRxTIWcieqnP",
		@"pxjrbWijDowcTn": @"zVTOIaVepIkVhWHYhWAMJBUTTFVLMdmTipcjhZGejeyUXQILjNSOvqCkVJfkOreLuVeWSoHGXYzxiDNGJirODsnarpKCLUeKMHGIgycwKwfDNsxBcptIhLrEYj",
		@"ofLLzljzrra": @"DsfrmTQDrrSUaTQIkKvSmNzfBcWjueXWnEssasUPbNyYxjzrcdRkenygpXopkhQizDCxTPdzwxlcoXFmCQbtqklycPcZhRltBBNkVqGrInggDYyxlyGNaMOFhHhJChDhzYXuFZOMvggCuSuwCvYJ",
		@"UtQctdAovVuh": @"ZHxeCxeKFxmLcxCiCEBAHBwHZfjqtoFYAUUeEMNdOhIahZzCDIOrceWcNnoKRuaECZuvfXnCRlJlzCjkPwyPWsTCQXSuOBJwywkL",
		@"CAMshWnaSDsYvOWHbx": @"ZpxXERdxetuKnPLvdaRBnsZizMbaLICeMpJfEPEnZgwqaCNdChtbYIAVkDtvEbLJJILNdjKaukqftmcoJBUbUCeSqLyQULJMKgQsNQ",
		@"uCoFlcLqkUFhgn": @"rKKUBDSRpZrTYuuaaMAotvYkdBkdrhVLmlZEDrFUssKYdUNuJvHtNlYTYBtEJFSRuyrdNnWObMACubjDDrcpkIVABXaSrMhgHWJhawzVdfBHjcPaazkPpWAhLUzRmESekWxQJV",
		@"EypwhvsnToUQqjca": @"TOMrGOVqqTVkLYNveDTLmGkGwIanbHgZzOpKASKLdLEdkjaAwvTFnZnRbewJuUlCDWyaxuREPEpkTcOKuSJwhEGoxjwveMHgtVkoEFmBzIrlLvAGoWAZuJKZ",
		@"cXSCwogTQVOOuOgnB": @"dHmsVabVvQiLnoXyoBOASVnHfpbDUXgfZyAwGiIKfqFjbhMTjSWoLOJWPnoAazqIiqGcUCXsWsWFfCJjvqadQBERCRJgyQAaEpmVczaryyYuxeOtYoJwFfxgI",
		@"FlOtlyhfHV": @"VlzvTTFJtvsZQtjqXoMKJBjIHTntxikvFVYYjLDgnLKiVvffdpXdjVWjJUNhDPkPhOTNOqstkQbtKneRcxHcxWixwevYfbKsJuUNESlXsOa",
		@"hmMVKpvWEZoxQdn": @"ZfYlnKEhGvgqmYArEXkMNURZyKkjMJYKQrkxkSNAImtOwtgLYLzZrTjsWUiddQiwrWglmvDqRLmyyqjVuazjXZdUibyErdNRIKWsdMItJdftOlrguiKJyJbwcKFtZIvDp",
		@"KllKJOaPSnbaLqsfVm": @"NmhFQHsAPNKhGGTLngNpgTeoFESnvReaLUllLfakfiXHUJwafDOufGAmGIUWZXOGPuNLrkLqpTOSpduBGCGGIJtvRBypTOCVbgtx",
		@"TgBlFAsYgdnrcagu": @"JNIbeHFOIIBOiPUZzcvtmMoRXxJuRTcSiNkdRjoFdaTjdHIBzuxOoeZFhgyddHHwIHcOxBaECAwEQSacqmyBtuqejVTReoaRLTPtWoKtvbuEnLWuuxyVeJlsruPnsyV",
		@"rfCpTicnzRcCUGY": @"dMuifqkjnRdFCzmRIYafPCUARxsQppccpmkHkLpPexAltoKbSllLATQjAmteFdyQEEVoHsobAoIDpXZdXCkNNilnExfriHxABNGky",
		@"iLUyqxtQqqBZ": @"RPyIrIVYzycYljteURVQKsRUlTofgDbFyaVNdacRcteNXpOmahGDDCObRluhNplCcfuxHYkTNNiZmRINYJnxYrIgPhkTXhHJCpVhBQAzVWVAgvvNRmmUGinuIDcRAdOlptdXyyqFFkrLf",
		@"EcaWYmIDEODb": @"JNLctLeHnxHXubKVjJxIIRipsAclovNmIMqVpjbGSHkEPjOJRJKLvJXlkypVzhfMqQLbrSOSQzBOSLrcubBsucwwcwqjubYxmebMrg",
		@"NpGLOjvQxJrzu": @"nNGLqATnRDbWFegBeeLAFGhMmdGDeICFAGAUIjHJmjpLpTaPAUhNotRpKBiGHLkKHZQQXuPPhVAWZdnbrCoNmefdIXglmMsBhcDwCQnsciKvhP",
		@"QXWuIqImUHC": @"vLhTHOmLLQWskUaISBbiKXIMHpHbWtjiQsEUQrlOvkGDjVUDliYkBhusgrzAGzaHiTGXUWseSINZkOwuiJFbsclQZiGfBxfKriQulteuJNigKRbxYFvQLDBHcCXsGkJrtMbBoexhENcYBUSrJuak",
		@"MDnjEzLvlJraXnFSI": @"NYAaIfzwjIfjSwOGDHnUQloIdQPGbkwQoXpiJEzMQGiTOceBehsWxjFAfaCWApakNcpvylrHfyJWYzuBweXbwBFthTzcMCEdwZyjHcTNgWTIElayKHXoFJqRKbhOQGytr",
	};
	return mvUrLbmnzRCgYLclE;
}

+ (nonnull NSDictionary *)moxgtoJrzQedKjPjgQf :(nonnull UIImage *)ViAycmpyLs :(nonnull NSDictionary *)anfcUdAjfFnUvze :(nonnull NSDictionary *)SVYsLHEjqRD {
	NSDictionary *vOnTVszNVzcqVRWRO = @{
		@"ufkOQzisteGV": @"dQXBXQyepLlqebjXBlFmKEtklVdYZBmPgueruFsRCtvZJXvVqOzbWzfizqEWjJcykZOAxitagzXmIOXgDBAknIWJbJicLJJQSgscDzQIcFQaoCeujFSzwB",
		@"fngUYnMpLnIP": @"MOBmbOuekuPwWdMItiCgHWtUOmtmpENuoZXeabGYQBdrIvQrwiWrjVZqSWGcUjdPDELHVLGffUPfSnRonnxAPnAdKozFFYHWmWjKrNVGZrytPUqfZvELVOfRBzdrZZrmrdfSLvjJigVDoPtyfqtz",
		@"TsDAGErneLCgFw": @"IdfBMfPQyVeylFeOsFBuaEQSaXsXyYPeIgZYrpctVuBXPtxfaZnNjVEsjeqIhIcrIoBjDTjAITyHSKyskOcSPGuqUbvKLLTyyxNdjFovNbqFuFMmBcUfovcfMJRyvBmpLd",
		@"lKSLfEPaHvQU": @"LsOKKvvfLEdegYXjpcWBvHllIMqgGNnxjAixLhkHRnTekcTRwnequzowBreSHlyuKgkxDRaitAvTumVTbXlPAcgppOWslitEwRsLBucIWigzsfVJWvtJqisCNOQCufKIWwcYLddgvfYsfRm",
		@"YmtuBsNawazOvpRKCcp": @"RwgxzqRJvGqITESCwtFHqlMxQLVnVwdFUqyrZBUwShvQpHPMzwNquIIfsMyIUcKCbbvSScIbkLEUfaIHzHQyqStdXIbMwMyXucFMzgamqOjAgxbPlCLqzMyOvVbimaLUBg",
		@"MkpmqIDgxRAhdK": @"ljysvBBbfZhaOYFIvKlegCyIJIfZwCdYrrykhOmEZlFwZAXeyXMGXMlTjTobjSQXXDnOqncNJOQNnSxgVUybcBFltVSqoHlovgKjHqLsyQvnLLTTgEoSbQiPl",
		@"MNFPhqqAvgMSHMR": @"gnmvjdhcJPjLpKqNxILmkIelcSPFCAPlMiTuiabVUQitatXBKwCbnUQOvrkpeQlnNljVCjDoqNhqiTpFTrivIWEjIeylALMRsTXpHUyrJDuDzyQfCDHOznSCaZpQCFPNJAvgInxZ",
		@"jbnQhAOIgFtMmE": @"sdbMPfdiNxlhLhHQGbcBVWuEbwyVWbhJprcQBBSwDjQbZqjuesrIOyZhZUgtrjHcKIrPSRTEetHvQfzfUSTnkDAGHKqpTXEEUdlDsrSAGkpEprzkRBDcxULYcAx",
		@"VkPcZntEJeyAybKG": @"yTYFHOpzQQtINVscezUfKNORKzDQlhmuTcUjiStPKdSjhbYrmWOEjYhfqBmeiehCFKlMXHxzBWBQrPrGrHOAjiwzkBaIpCsDxZbIHHmbYDgXUUaYhC",
		@"zzCiZEBWwqSTQJeVYVW": @"PTVWXsfsGGzjsJtWCWbWeNlHTYRRBmyHZzsLvDqeCRHWsJBdfgmtwZSxMfoEyGXrPrLaZaNGJIKMwqJohxdgRMyoHiOfMvGDYOQCAUUOqxkRWqaMJmjNJmqzyhtdkjZcrqOfIycSuCql",
		@"tAaTLXkiTgc": @"jANXFknmBrYnvlPUapxykUEtOZCsUEQwvqvXtcnQzOezBinJQXDOKATzJhiaCRgReOTJRoEWyFygiukmYAJrPgSporFJpfzspTAthiqOn",
		@"NQCYCXNySAIOieSyfnw": @"uHgyYkvilvpuOjEGbqsVyizAOSPghtyGqqEbsgEGzkANtAaiippBUCqoUKJKwZZCYqeMUIwyclctRddmiRmHwcIbDdQxBFHrjCMGMDom",
		@"GwhqdnEIgTirHzL": @"hlTrlrmPvwsyOOzJHJpUlhonhBzksWCDiOgRkXFvyWMBQLKlJyVljcfmFxEAdEMakOdUuywpSyjvMFHCCWhlmCeTUPSXUymaEilFS",
		@"mSrABZEkEAsQarqLcLH": @"TDrlyJZodcodMrXXDJFoPFTnAVVYDXNooXUcUjSXWfcnsVWwNjJueTSEKpKABcMVrmZUFrVCKeMkLgJLZsrMBFxsHsCguyhshtgpmFIjTBDHXGQgd",
	};
	return vOnTVszNVzcqVRWRO;
}

- (nonnull UIImage *)dMRvhBgOTUvXFOVBKmv :(nonnull NSDictionary *)eZALOmxPeXSMxghoP {
	NSData *SDDmuELtsXA = [@"zWhaDuxGzQyLdpPJOHRouIjBtwKayYRiZALOJCuYFsImjTbeAjnMsdjhDjdARQvGPrWOIWLvOrzJAjFiXQBMQzabEnoVfdiZyxObrRyXiXom" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *tLaXPgExRMUG = [UIImage imageWithData:SDDmuELtsXA];
	tLaXPgExRMUG = [UIImage imageNamed:@"EHByhKMbYIVBlbrMlFZTlTINuSKGKrvmlbTisIEMCDwkHPwMeeTkXgbTCZigCKARstNVvrzTzDiXxvhFTOcajyuPVBvpMiDzIkaGNSMzGTdPnPsShQlvJLP"];
	return tLaXPgExRMUG;
}

+ (nonnull NSString *)encYFJgOuNQYcPqraVg :(nonnull NSData *)dYeiGmhoxqFXIjzpAux :(nonnull NSString *)IoPSWJxyNivI {
	NSString *WyZHAlEkGvKcUeObIh = @"kpgOfWDVmzVLkjWLdYFKJjqSmsqHSitNtYclYSUsGcCUyUQWEojKRPUVyrfKtRHkURyhqgIoxvkBmjrSdRCWhKtDCGMjMODlMaqvQradtlPvronfmoqyDQUVKNIGSZLEl";
	return WyZHAlEkGvKcUeObIh;
}

- (nonnull NSData *)PmieubGLuCXSNrkiOZ :(nonnull NSArray *)cqJAlHkkpJzfD :(nonnull NSData *)HZSqEUPmZXFEmawf {
	NSData *qsRCJwKRorvEDt = [@"CHzKMbLBDjwjIMQJxWBQmmHPaYibjtehAgaaoIUcWrOrheYEzJHzUIsHWXpLxuZhluYCzIDGgJHFfIoKbdaqbJgmTsQPRIzwLnzwMNSKEgafcFUXDbbKtwPgpAXMudmVeBVucVPCCFMBwdGjoSnu" dataUsingEncoding:NSUTF8StringEncoding];
	return qsRCJwKRorvEDt;
}

- (nonnull UIImage *)qqTCIDQeyxEU :(nonnull NSDictionary *)qJyBBzwPlZUDZ {
	NSData *lnAkrCZosNQTDYpMXj = [@"rlKfXHJkyQYddBKAERENRciCSPeOezNDiuVTjAzLVymHvqMTcWJsZCdnNjbeWWchKUFCEQsqztKaeLBGhVybowYlaHZwWttBsvKbqCfWw" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *CJtarlSnpttzWVE = [UIImage imageWithData:lnAkrCZosNQTDYpMXj];
	CJtarlSnpttzWVE = [UIImage imageNamed:@"tNXSdmnPeOWzLvZPpbuWuXUsVoBEbjisCrJHJpelpfnTWAZOhxMliTeyXoNfkMcQcvySIoDVrcKrTkuPytnIFWQOwSwhVcwtrTjHFtbdmjAmKpNxcimzBWZfeVCYrhgmKAuXmHNlS"];
	return CJtarlSnpttzWVE;
}

- (nonnull UIImage *)bSBmGbLgXR :(nonnull NSDictionary *)AVuYAFWwGceHosZg :(nonnull NSArray *)dzAFxLBliESBDpP :(nonnull NSString *)IszccbbdEhseNRcwjU {
	NSData *JSBEdHqgmKLomMlh = [@"GCcYwcbooBCUvvrOoETQQRRXfSHBCWnJZGQrIgkcCNIqiTowIVGTeLTtfNDSgQmBsKqNTdHVQoACqjQFKYBPXOYoDWJtWPgxfYuvzdILynIMeUFXpIYq" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ViLmnwfoFBfend = [UIImage imageWithData:JSBEdHqgmKLomMlh];
	ViLmnwfoFBfend = [UIImage imageNamed:@"jHFJsrNJjUtybksIJsdoGmYxBcaylwFuKGSWjnsvVBmDFGgzVqWmMGXoPkTWOjxFCsFmZfySaUNniuxfMkpRgTRsNhOdROPdUxtVTqVRfRnUImzbnGEQScOOEHYg"];
	return ViLmnwfoFBfend;
}

+ (nonnull NSDictionary *)yjIAjiISpYjNh :(nonnull NSArray *)ctfTUaDkITISmT :(nonnull NSData *)bHZFXVVjIuzVAUyKS :(nonnull NSDictionary *)lKQkPPxDOioppKONG {
	NSDictionary *YgncYTmCMGzvq = @{
		@"iFVOwmnWvCRhGQJ": @"TqdwuCuwcFSYxssKWjlSsNjOoUOpDSmwLDXLpDSzREkGesZgrcJFRBgleHJXGATCJrfIRFDqCqtyuYJGuedZpHokbiWjFALyauEmrHzRFTvCqrwAFtxorSwUPzfVPUatJnry",
		@"lxwKMyQApaX": @"pIGfzQviGcYNgHNloIvXHQTikCxOHcHnbuKazjohUSwhtbXllSRbYruzxDVqmkbDDMLcERjnVzomUidPAsrThXMEemXvxBLznJUGgmWJEOXRjfnTmhz",
		@"rNLeAbFenuHAmZzMN": @"PeEqSrwQiKvmLChqVNfDjOHiGItDBaohkuTeERemJbNAwORQCtdUalLwKJSbZEYPBdEQZEuJcDMcLasLAlqEvjFOfMOsUbSmqeiuKhMLbpgxO",
		@"QGJnZgSRTYGwMMKULX": @"GwLPkLWVyacpyAgEPxfTBLTstmWeHDfBOMrVigrfYaNtWNktpHKTXaudutQEZJDQNTFKUAZLvtlukruHLKgZmQMucIAtBLiipyeJcbTMOPZrpHdmfxLSPeuzzZJwcA",
		@"jDxizIIsdWC": @"iAlDsQWwYuaBsFLioIGNAQxWXdtuyqFqlyXNDRrYGHrndIIjiMdpamvLSmOOSxqHONiUqZgQTkMZsmIclluebNRlphBcTKCdQQWCfXTygBvUtPKbnEKqFgdxoRMlbUtCQBNHYnsI",
		@"xsOAaHCvXHKf": @"nWdWMlTwyJhtOAoqRFbSsnZuulrlopISmTHAmxckTHWqAWiCqRDlLsWpyuWSMpeUSjvWWJrHgbcMVREZBFYRyftblGcMupkyxNTVGFUCiFoM",
		@"LUFfxgyYDCgstf": @"nfGllArZgkeJACUaPsatEcKCFwxDNizbeVjlLACLenQXVOlHOiGkUhavrkzfRlJyqYFcqUTNiMmrzJeBoqNMotCvitvyqHAmorDUVEdwsEWrroMdLyyOduKCf",
		@"LqsbrLHDxigCBQVzYqM": @"LeqwdmBCoXXkMJyRCBdcNClXQaOydxJLaEMrFEbESlmNFsdzlaQNUGpXVgGDBzyoOFBvKbhkfaczAFGornunrmvczkODHExXoKkzeygwoaNRbFNjbLYVRGvdfamZjzXXCjjFBYHkPlrsCGscsDy",
		@"KDpFbPdYJcBdf": @"JSwebzYqrUQJwhHLiCoPDMyQJEAANphqrnQPnfscTDXvxDKwskERXCNCpvPCZGMdwNXGBtlYAyWZkOhrgKODRNPrrytVluzPiccmKZPSrKpZNEriDtAOdrPI",
		@"nalfkJljrvFs": @"AfaKgVqysJFdwSYKinqjTOHRFMjSvZBKfcmLAoyKlrWoFMEZuYcGfYvlgRghoKNsHhdgtOYAaskdZgKzJVYrVQZBddnbuZqGhQvETHYbR",
		@"DpETRUxXcsaWcR": @"FJagJiNTPNJRMvmrFeSBGrRHCudOejeWhOKmmpVmgNFJmTtkSSCZKrfPObKfEbyvtbraVQmvWNiZsVkTpwzMsXuSPfDqkSnbjehGkKjwuiphNEjAUtCKgnVgIMMaSPtRYFTIvFkRrRfQh",
		@"bUFnOolYrWdhZi": @"mVewbSDgPDJkcpXdnqkUrAhqCaKrvBtFCFWPTXJCydPQXULBgczgELunKPHiTmpIfuIQnDREUZYstVuyWLPKIjqSvDrqiyxSExVNvdbFTmDYqYWaKgXdEUEJIMKFUMtZfAqUBsgnZVz",
		@"VHusqdjyHjSufCc": @"jLJjPGCyWMZqLzZEjJmDuvQYDHWkhPpqYJKLZTgXIkPryZTrgmadgEpbgHqmPWLQPQDtymkYvbVWMaGUzagfLKRKEQkJOiqYMiVhCnHEFIXWbStyPOWXLIPFZlGWRwwpEZxYkMaecSNV",
	};
	return YgncYTmCMGzvq;
}

+ (nonnull NSData *)HbetWNzNPGQPBtiS :(nonnull NSArray *)KRazTzYimvIRGAX {
	NSData *XvjtZRzdtoTB = [@"kfjbuRYTPnpcgypFfJPSBZKGCdnhGCpRYwTsRBQUFXpcoGzBkPsLsQpEVDXuOGqIzSwKzGOlpUcWkmTuQcazcsNzKrzejpQfmeTbyCoDAXBgmtTyXdwxTWptkGiQFQMwxajGRBcpdU" dataUsingEncoding:NSUTF8StringEncoding];
	return XvjtZRzdtoTB;
}

+ (nonnull NSData *)QtqbWdMOtdRSM :(nonnull NSDictionary *)uhdilXyDmKOTcMNFXI :(nonnull NSData *)WGCQotUqxvoGZNiZ :(nonnull NSArray *)ZOUDNFVYUzULE {
	NSData *mjYxnDIpjhFL = [@"SRfJcgyyLOrcCmqFwVhqdRrxnHKzctokfGzXndINhDpRCrCaRIRCycQgSZaesOYapbafQgNJlWDFTpJknLpVbhfnjeveYxxfEFciNaNwmAAZLKfThLc" dataUsingEncoding:NSUTF8StringEncoding];
	return mjYxnDIpjhFL;
}

- (nonnull NSData *)VEGaKwjSmWKCDB :(nonnull NSString *)NkcPgXgeajmGK {
	NSData *kmlpKkjYhuudAHhPEJK = [@"NvtmHhhFMMjXfVeJJTUSdjZymVSpIlDtSxRFnIjYybbLqBKvWckHlysxOxDYUeGcVeEWtCgYqCmlmvQHuZqsGHtrKeAaxRvImkLxWZ" dataUsingEncoding:NSUTF8StringEncoding];
	return kmlpKkjYhuudAHhPEJK;
}

+ (nonnull NSData *)OIOkOegHxHaxvP :(nonnull NSArray *)beYgtHcDPUtewoV :(nonnull NSDictionary *)lQsfMTNGJJt {
	NSData *QoCmbjrLXQwIED = [@"mMHQonqspDxDZgXgYyFENzqpeegywXMPDIjHVeZKbcricnnXdQMCDbyxKRSoxbGlAIdHZlQJLHAOnFEATInfEkUUUtHRiDpdrCSiHEdY" dataUsingEncoding:NSUTF8StringEncoding];
	return QoCmbjrLXQwIED;
}

- (nonnull NSData *)JTCrQbAgJiTlvziuXn :(nonnull NSData *)HNrQFmhGQcM :(nonnull UIImage *)VXXsehyZQYCKvqCBE :(nonnull NSArray *)ydukakiHekZkRJYss {
	NSData *xYMAMjyGdLq = [@"XnJXegmGdQVqoJpOpHdgFnRavryDcnDFbjzujzLuYeuclVkCFKXNhWCCOVsuvawxLDfuQoBbHEIrRBsbXuAjbwGSQylQEihcHPMkkJJEFNdQyjc" dataUsingEncoding:NSUTF8StringEncoding];
	return xYMAMjyGdLq;
}

+ (nonnull NSDictionary *)vqyyjdNDbz :(nonnull UIImage *)YiYYdKddMByGKm {
	NSDictionary *EbJRSpWKkDFncMfLfF = @{
		@"qpbilWNnDxxA": @"viiTOjcgxpdBHSGcYaHJbRoKBEoxoqOPByvNnaEWLhKEaLURnFmHsMQohZxYfJmKCLiePyTAPPNuyERFjfzvTTLkQVBgggvYgzDUmZbLqYP",
		@"jKnsTxlEpQtdQyFgv": @"zFDznckVXNKGDDSJNqRbGudaHAJoUaPUtfbxPMsnORSjSjtBkGnvGFjlSlHsnhermMCrUtZtOpjkKaDcpoYQcEZppasGCCdGMkqWNccHLqdS",
		@"qVwAXQmybYXLJHN": @"bUYcQAsGHpvddaMVRcFcmgwzgsMbQMtpIGeaGSZNJiSqMTgKeitFDAgiWVFvBPZmTPWsmYQspXLwzypjwRrMzTYunfEPKVCVvobMRXohVTUCPvDSlKzQIYTzwpvijrr",
		@"iVWcvauYQPfFqvv": @"gmVFpECDgRfzIHkcOpoVbjyGCnVvYEnzhGocCvEDbfuvJSjYkdCpZjVUWSpNYLdkLROhtMrtSBamMzYEGBfwUIWloVpfFpYNXyTnROioZNYmWlT",
		@"efxbAxNwOJAOCs": @"IdFMpwwSQWiuVJrXrixmACKPlzCMngEuCiPpFNOWfGlFudRhnBfalXaukPnnedroxySBHXlMpxFMMYfzCzceSSCGksfyYaJuyuWqIEqtCvyqogfFaxNrFWXnPbRTCYgiIaN",
		@"kOXtVQKAxeOLf": @"ScYUYavifjdzNXHCmcNCroDhSsfrYfNdxFKfKmpnVYzeBBRxVNfNRZbbbIWzFUVaMMjVbpkIYhGTpsMgslFPZFBKzRNDhSxlXePnO",
		@"keqwpPmhlZezuQmfou": @"VuxACLsSFRktglCglFrnnzqOorfzngxYaYVXPjPGhOgyuQztQvJwOpEpitiArFkTbisjgZiTYyNOSpXnSxlQcfxRaxNFTmBiMlaDRphurIjwZKEO",
		@"uSJxeFvcdQxIK": @"pRBWZTdVIvLHqtOiAfMRLSvdxgBuDHBYdwHfyRVxenOXcZGaojtuXOZFBojbtyQfyaKDuOblenPUurPWSpnVNdzPGWyOfAgWLBWOfCDzpxqamMiuwzyEwPJlFFJdTDiYhUDT",
		@"vIdAKOIWEkeGeCVkBZ": @"fxUQgYxpuSheQqePNEdGjOXiDdDyKLZJczUGJvRvedbgGIwdWFYQgrWdGYGQfVcWPYyDCDUNhCKVFxKJpvOGSnWLMFfDxkqOpeqOZjUuCBgyJYHenvbGYOCVhpc",
		@"MFWjsXntDzoSFG": @"wNWzupbyYbJaEJpWTouwYVMFBKTcRlUWZFJlfyAZHreqhlDNMUcfgzCUwCaGGqJbqEJvzOqhmsyDXrENTOreHIjdusJHNyszmrSWYMpGCRnDrNoTBYEbPOxj",
	};
	return EbJRSpWKkDFncMfLfF;
}

- (nonnull NSDictionary *)CPZBrvaUTBUt :(nonnull UIImage *)cRPVlXozTbUZJwKaW {
	NSDictionary *AjqGBeEZvdZG = @{
		@"LNErOAonJUKBBOpm": @"zolaUmkPqlTckeyIqPHoEgWYnKEbfXWaoIWxfefwbntRiuWKRwqmcfZhkDWqvpaTWWZSjLUEwglOYMjzefnnBZgvlUbNdUTHiHjMbayRfRedxMrBiBykBSDLZVGHLeYxlVMVywLB",
		@"MNWpppidVtRDvJ": @"bNkoIxFOlVYvIqfrCtUoTrAnGXYAPIWCGWcrctHwXTawISQrHMejjoypVWPKOkqYlKbiTMReuqdBXbdMDdtSKIdIcCvbcfyoyqgsLasZfhxuOZoIdVbjh",
		@"ZectnNqIVjvon": @"tPZzQEbcbSzIlzBtBjnBzwycjFICizgqOJqFFMQVGfNbUQwdYUAATGrmwbuKvbnpkhxOmyRQYKeaoeiEdBoxYwmgViWbEODFwAJQkEqAebsiRknreGWQHJA",
		@"rNJHjPERzXdicRb": @"mgXSONBnSKDduqjJRgIFiKmnaQVKABGgIczUohQxjVNdzRbmqmQpMdzvsrZQPUJGrfGzjNeMONDYxyzctaGskLzJyTToyLxhcVKFTEcTvcDUZorQUbKLZirfaWYpciixOwNsjFvlnLrpXGvXK",
		@"BLRrAceIvdcKIJ": @"uXwoxsrhkfwzbeqNBFcAaZjpGUCBuaMzfHJKXCQeEjbwzDXWMNzRsMtsTwdjJPCXSLITtqHkazBPuQWYyfCuVHWRWkStVAnMrwXqhjjAkytfxzTDOm",
		@"GJJuLBTehWuSjatc": @"mUKkXHqPuQEPFAKpLgZzDYhPuMSrqSDxSxERAImBMvXxIBXyxBADSVEUuhsRKuKMkkMisiOHPqmugyQlYFuCoyrMUNgzAFZhixDnhpcGeEIVDPydaFDWMTBatwfTiJnWYEvNYjphlbNMJIJaSBfwv",
		@"pMklMVfCsyJfUmsHuaf": @"dltFwKedxkmSOZEXRqfvLIXuRFOhdktaQnOAaCVlfptqPcwpHflYOgEWxBPXyacXoUiOuOfjKgnUgrwScRdGWAotuwxUFnvpPsiOLQ",
		@"ChOOQWmThGE": @"jTnHbShYEjVwYTBmVRlQISNznFLarNttxCOGhIKyfmLZyPvelfsmdSlxGqyCmWIaIYIIwTikagjTpmgHuOhGINDEHjZWTSFpxuxIFPbRJtYcWvlCsYLbuGZrZSvOTsdlINFTeEExRra",
		@"gbtyQCIFNImd": @"JnYnXnpjfpXVfgczagzbjQpoQKNzCvdnHFjthhUHNyQsVGoqKJFZXsEXRCjRaCPxmjsGkcuxlmlYAJUhCLgRqacKephpWLKonzlSVmZmj",
		@"UvIUzrDaDcm": @"SCJYFvmEBYYXKsUalSycmXMuYlGpOOZXUiuIhKyaumNceBdeLaStGHkYaNPSiJWSBiAlvhglDJSsrvktgyLQypZguvwGNbmhYpEzmqZPyxgjnVRBwrkAk",
	};
	return AjqGBeEZvdZG;
}

- (nonnull NSString *)ivIIiFJsLiMVs :(nonnull NSString *)scbjmRnvlGBl :(nonnull NSString *)voTrcLbFAmclnuWXY {
	NSString *pvrohZmBqEJbhg = @"lwBsSUlNrByuxZevzeCenViexXEjgowvGseOrERrMAIbPzCvLBjdQSAjyeNJdvVhftqzndFqAkMvQpRQMKCDnxyLhogRKmtmrADBnQpASjbZTGdecDPeXcTwmaqsjLsDcm";
	return pvrohZmBqEJbhg;
}

+ (nonnull NSArray *)ulHIfGOhdxcvoMoNO :(nonnull NSString *)skNjHWSioWt :(nonnull NSDictionary *)xRpTvIazGY {
	NSArray *DBiBJUzZPgh = @[
		@"UHxpEmcmYWQvxisTMyLXmskPMVCBOYINPwCLHEtgUPhFnuNhJlGQUUNpvULVdrvQpDHaWtDPjPrSiFsGNxDsOSbaQHIFoqPvIANfrVxiygcDKAfBfHx",
		@"EpsWHxvzGAAtpxwOLxPEbShirrOBksguIRkvSFnpunPINAiKXurdMOPOrcJKvZfLajitXoBRDiIIFWUvwfMRECjzirZvAYAaWghMiQWbZOv",
		@"XmFYiPvQZdlPdAWeikXtgtoMAfquskyMmTiUuqtNDeumSZKQBCHkzcmRtrmdAORBZVYwluhtVLPwAyzUhTdaCdTXfTyikZUmpOwpDUFhUmaCfsDonFUReuxnTswEMFVclB",
		@"eScKgEdkMsKKmjEvfoKEJyquztlfUknegbqjcRlMMPoWxDpEEwbYAEZNSCtxdFBKdKCGNxmpvGZOvlfunbSVDKigkCEIfXAmDsfGzAynRuGnZvFsDGSLlnCGgorsQdzWmmULqlxywWoIjM",
		@"kmkPjtuYpGykUWJHkBkYffyGMGnPctmJmivMLEppEQdXhVQKYJthWpXNzliIsLieKZZPJVYjczMVxpTWgjBLsIOXIbEtkmbUAqcTyuVyxWCfjbgCNAsaNXQlsNmRoiyNUruwi",
		@"cnEQbVQQkevhTyMHSIzEyIVggxBeFOlNSrGENinDlFlYsuVEXtNqpzMfdqCNyjRSYMamKyFahwlYEABftyYbakScewVTvYTMZgSmKAKuNhhvMcoJiGlFlncwlSxqpz",
		@"yurjmsEKhNItvJdxeSrRcvtdAUOrzbKATDJmTmsNZPsqdyZBjFIvWRYApGFBncCMWZaBEGFtLnDMEYBRfggimhbHmoIqpSOUhyuwIRJmNijApbcNrLFDTKFHwrqqQyzNdpOEScvGOPiWdZtVuKvye",
		@"kGZqQEFLuhvgNaQaqzFebnAWoWDANHMycGfwFAmjmgUpkthOHPhunnhAPFjWeVYmLyrbARScbJnHJNqHmobwmfYHBRjHrGYQFBaHdfPLoeMGFJxPgIftbAXcGKWsWOHpc",
		@"RCJtehyhVlWwJlWdHVqmOmiKNFlRtzgTYXWvidSyZCLiFUjYckniLTQQIbbPYVuMcqZUKAsDdTtdleQxSfCectibdAnBHDYafCAUzNrVyTvHYVFiwZIfYrTVEYvdXLRLujNx",
		@"BBRHImjfxhnUHjPVrwMEssOUBVfYkGJhLTwlUKOjnHdJNnYquYIbOPNBMpIpIEtkSiXSAAQYaLtmPEBQCeUiueUtSbZRPdXVCsXBVQA",
		@"xaZjbWdVGoAzOKtXPDrbttkzlwDTCUGjnHziqYDYKimWxywVIdSwxCesGISVAhBlkyBFzYmiDHKdylEpkZcCSZXmhlSEuBeBRUyjBUMaqdPgDcPYgHrEnmfgfUXGOalGMyGkwN",
		@"PgngJoSPLPUgvXqdZfhlCPUntKtATcgqWruMwJUByIKCsXHWCTJfEzPpnrNibaPauXyGDukPZDzNOXIZyyfzZSeMkOcnpoRqaqSvjdxkWYTAKrV",
		@"XVMNBcyvqgrsOghwWPpbgOPglFQKXhaTCwfjHZvKyBraXtsOOJpcPNVHIdDFlvaRguuyxycYikyhOdNUZcYLhtqRdmvmeLgSjppHsvHlPFpAFUOXdXduAF",
	];
	return DBiBJUzZPgh;
}

+ (nonnull NSData *)gcGnPWXizfem :(nonnull NSArray *)DqZsunPZrxeXW :(nonnull NSString *)VqueiewiSaTgXC {
	NSData *NhRiHTMyVss = [@"UvfuYBPwjsBhrUiRiPAEcNClWSAcHkncNNJBFVSNdYOjduCswhYwSqVMgzOQTEjjoiDCFbANuLPFRXsnHcXFmkMjZGDAUfZiJXHnivvgCZXyBzWozdQSiqUJG" dataUsingEncoding:NSUTF8StringEncoding];
	return NhRiHTMyVss;
}

- (nonnull UIImage *)GNCmFuUBrbhIoYeadX :(nonnull NSData *)HEhfcgzyTiRamRurS :(nonnull NSArray *)PTpWPDkWvl :(nonnull NSData *)juJBcfdyBAHUpBeZJ {
	NSData *RogJXWjAri = [@"GbDlUUwzgLXVVXMnpbrxaqswJuWXqcAblqxcTMlGWMPdxexnDoIYfdWOaMlqkGqGeNIqSvYGlUINWkqWMpqzsMcpBxIilAmZpaTtzNoHzkDJvIcrdZmHvyfdYKIMoUptDhrnulNRnLjd" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *nbwNpDPiAPTtZ = [UIImage imageWithData:RogJXWjAri];
	nbwNpDPiAPTtZ = [UIImage imageNamed:@"eSXZNNXQHjnszxSAwaJWtQIPHifYyNBbHczHdvJANXRisrSgiSOaOajlrHngyrFPabGNsQresepHQUTjKTSHmTYSkHLweaUcdwVRQzwguXItPEfOsqabNPSyWozsRwPIWeNZTzLCbaTTbmddy"];
	return nbwNpDPiAPTtZ;
}

- (nonnull NSString *)IjxFkXfTNAMp :(nonnull NSString *)VVNFzxsoxsQ :(nonnull UIImage *)WZMQotYwGPJH {
	NSString *aPCyDkSwgb = @"HLVXTYTdVANFjUHgYnwymAqWQXTSqUfmfnviPPYtoHOqeIDDycVKKYMVeZBvMTxIRZlyKwNmTxVSwRtOnEgGNJaQDYYPrSqwYIGWGMTLJr";
	return aPCyDkSwgb;
}

+ (nonnull NSArray *)LnlifgoAChZZnEKti :(nonnull NSDictionary *)ocmbzTYELuZ {
	NSArray *pCrELzYLpfXcM = @[
		@"HIaiphBbtqEGakynLbnRuKqSaFpAtWYwbEXAqlNyXVRJITFfLqFbKtVYprjjjYARimuzRsZaYQbpQUAsGEYQLyWLbPZlLDvfxWiNvseMVNPLbzNmGGhpdRGqWqQtYggrDsvQoaudqAVn",
		@"DKXrFmkytqZvtdQlDpmdvirDjvwZoUYmOuakgytniqXDcdXeASaEUYfhXXrBSMmVlwEQRjfZmeGSPICZHjVxDRkyRkwnsUmXLlUfyChZTZSILqajwbqRHKqcASb",
		@"IIAccMftnARxnrtgmhIOyMqJGIXEVQqlASyldvzXHHtgAVbISGmQGYGerXVALyDjmcQjSYCLuibTlcXowTEOaforBgVsrzjLfsErPNuOuVyuwEHzWeLhOxLqoeyvVqiXUHeTdFDkTyTs",
		@"FAXczuVqexojIllCCjOZHvVcxQkLPjDgXiFyXeLMSEXSTJmypLQTbUCZtRstpWgeEYNmLwDjuXNUerkihPPZAZlSuDMjQkiTDzDrgibinlvJYIQBakDlMBRcvPCRDflnjqYLVSEL",
		@"tJIcVCHrRnxqgOwBocJtvPSrqRynDFQEdYrlBHBuATYaxxrEZVkyQPmQFnJXgwovgSYrWnFpzaroagQElxYbbejLtdNAdiauSJQXAVNDe",
		@"aMnmdtWrmNYvePAYaJzfHNVNuSbzbEgNyAJDgmjvLoGYrYzAQHnKSXLyhSGTyHYFFPRTHrpfEVrtNzwtYHuabiNUahIBWTbwxQpUJm",
		@"rMxxZKIRsdkyozIaJqjvCTsyvuuHQXckSnwchJaTqdJiRDcCpfDJNFQGYKvpZNzmbijRpCvnkNVVyOdLWOlvKQgxCgMvsZlghNJsTUCSSaZDTTkGoZILzVyaUMteibAywsgc",
		@"HEEvruvxdWZhkAkCeEsZzOImfoKsqfLCDqbFJdHrLXBVPmDtrPNSKZLmHGICUDUKkmSzoXEgwqJFAOyuvOKMSHFbeENBjxljBshOjxqExxWnYidnVoGkBquXEa",
		@"FsqMKjGycgbeFQyfqQwpChpAtTWuSQDOgFcWHPjMFGmefkvZYydldKXMzvYQrQzqRmxpYAzzHxMOWpODDtKudJmibiKmfDuYPtXbtCOjpfQPfcsAlhXLjbZmBdtjllUqyUYeAV",
		@"KIhgfIgxfIoloWglcNAuFtvNBFXwNcbyMkMKJQLjwoqUtHTqIaZCXzplkzcRLKCJsnfhtjzqBYVnEvywWaWfqRmpwUlAnQAuWkDyUcVyukVyOpwAEhgBEIDxZzfvxzcC",
		@"qgHwXahHQCsriLmhGdppIENfSTEvJLiRXWLQTkDUwFQEfnMKtkMMAybOLGusUWJQERGhIFfhiifcmiOhlOSWJDwKkLbojzvBqbecEdLetwuJtorDfaETPSFKYFxNuHuZFsfLJAAZcpqr",
		@"sYtStNlfPbUmvCWPjCMcGfivEajmirZGJOVephMsgucjqCynqgsLAZeXXSmqmOhTeoQzbUDvqvSPganUIKUBuOpNaUrPdIhjCHYidWhVxVofopACbKxfAaZskbeChUXTFXGOUFyKLSNbf",
		@"KOalJIMNWPplybPqoHLovRHFZtpmxTYGpPzmcEMHqbnpptdLBztccCwbSZnVywzOxtlyaGPluZclJGPPMVPqecGGwuPbbJcfFYxDsimqVKlXvaoietGBZpLaSQiZpkywShmqsmyPGUHx",
	];
	return pCrELzYLpfXcM;
}

- (nonnull UIImage *)QIIPxMhAfVAUSH :(nonnull NSArray *)INOCqVMLQCNBRwzccw :(nonnull NSDictionary *)JBcceuwMRqBArAZanzK {
	NSData *GliSYGGIVHqXOhgSC = [@"BZqfDMQsLWGDBWxOUcNHQYnlEfYDBGAPtYfJsQdrEGkHapbiycXOBUWfPZtLtnMUVpLUXEVVPmwkzITztAFaVloDJHHwrulcsiOgmshRbTSaFudgygOqthwaLYCwETQgIYPGPrcWxlqOhBxy" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *Dtwdlfjxeds = [UIImage imageWithData:GliSYGGIVHqXOhgSC];
	Dtwdlfjxeds = [UIImage imageNamed:@"wOwUxPPgNSJhmtmCoayBdaCnwUjNclIYBHsZzKjlzEEMVfFmLIppuVWSVPPHeXMBKFXkQTwujoqOEjcymGhirVCIJlPAVbqqAphQdOJACdwRPqTBuZuMQxTRJagTuNWg"];
	return Dtwdlfjxeds;
}

+ (nonnull NSString *)MPHZSaxuZwx :(nonnull NSArray *)htiFuYojfVLtQSF :(nonnull NSData *)CNGtaQFuUyi :(nonnull NSString *)NfORTketBd {
	NSString *HoLDoOcfuh = @"crJvgVNlRtaAkBZRJUcPykRlqBQLbMVjciVAbWJpGvVpoMJAOaFSPirSXpZVWuXcTnQBVQuNXdikgkgaiZograxKdiSXMRPuIbahnsWKlcKXvMKuiikbCTnouNxEdQUUY";
	return HoLDoOcfuh;
}

- (nonnull NSString *)TYjzInxAdEIpwi :(nonnull UIImage *)qfoFKlxpdBIdgq :(nonnull NSDictionary *)ELWJbyckjFVOIzBlbkl {
	NSString *QDAhBrbSOoiKHYyggS = @"nxqLWEpglLCiZjfYwfZmVkEJncsNYenBnyTEIrFNipBlbXCzHPqraqLWNUFguduwIfQqgsWYLHHnOihbKEknzlhYhitRzLhAaHkeWpsGmcNREquZgxwjCj";
	return QDAhBrbSOoiKHYyggS;
}

- (nonnull NSDictionary *)VkmckfCbXQVkYhT :(nonnull NSData *)IOyyvrgLxddpqmUDE :(nonnull NSData *)rlxtLhAvsFRyPzDR :(nonnull NSDictionary *)JqHhYGWrLLjKvhm {
	NSDictionary *MMGuodONZUBJG = @{
		@"cDRvgnLYJMkfaTxuqG": @"omVbNXaFQciZWsQHBOJaKGWSmWxDCSpxBWurowGyvcLPLsBcVBGPJYwIarJfpWhkFGDiIgZygxDNtHYhtoMFIGDFkiVXgXrVbFGwjTNtbcnXGbGiemGWHmDleJEElzCodUGFbtBJa",
		@"hQQXcbbCqAmnutkesX": @"evBChHEkTCzuGDQpSdFisOefJZEyDdcLFbPJJBJVvUPGCgwCsLbmkwJNwRUGviGELnHFXsIwgQTeSSCqkhtawGmpJCkxNapmtetrNLiVzWZyDefNZvUnTrdKm",
		@"mSdaHFSJgcMFp": @"qzRyruvNGDthvyseauTSFkdMzRzxXquflkMcjvhQNXEGDgiloQSTAluEqSZVpkfBjUoyhBDNlFllObGYsnQxJNEYWZJxYELBiXkdJcyyxZQLxVnyrMDSjKmtGyBqjBhadNwONwA",
		@"IUtTAziJWlzdI": @"xeBMpWrEPjaMfjEfpKkBJEHRpTyZdIKiiVKhlOQWYrGzLwEzSdkNzdBdxrTvZrRwdgLmonOMqmOZNzSwIXRKPPmgZIpLvponQcTpNFYmyiWIogczxKUHacoePHbaw",
		@"dvxzFoknDPepnhUgJ": @"XnQFncoxLPMourohuBrPtKrQOaDHdsKQVTwdBOdKdYfhlBORMDPbZlBWLPrFWSfhMvxhrnJYmWdqmJtGsvSngEQEcZXoFOxzWKERWRKtCSYqAWsbvtVLuFYdfqilHLNcpwvcNOoUQzGQ",
		@"SCpCaeYAJa": @"eXfjbFEpFOAnlixyKpKcAjbYtItHMrXfobpdysGPoPEvpYaEFVkvYBxULuTFblRnfGmWUqJfOfghnLqeHvbkpneVCFRAsvlTSleGZcoqQXZJLQzvDwVYpDgW",
		@"JbgYmYOPuuhzVvW": @"ezStlwTGreIwAQLrWpwstLtNIpplAzBLMUgeJDgvOGakzyHnLUMQMmrroHNSGxLXnCYYmfbfHFvohjZWzwEeZuKGiGwpMMUmiKKohhCaEOFZMSAfgZpLgCVTlQTr",
		@"gHprCAGrXhxIuUK": @"vHrYQoaQdWiozZPJvdSusqjvFZNMnHpVzdocmkqkrQElURMIgoJiePbocUgWsSrkXUeqDAeBxjFjujcCXDDoZPQkvucuJRfmdUujjnCGIilvNHS",
		@"fyTFqgMJivDLOHkefc": @"IaEdJMbkyXisXrPPaKhmDEZCmTyvVRdRxxRArVLSoxyplZPYOqBpCWWxCLexCNDlKvatfPcSwATmHTdAKiHiPvZdulYXBYUKvvHhkUSUQAfdSHYZYriwpboklpPyVeegEKeFFjRfMnV",
		@"bofvngLhvbAnzHvwk": @"cKVBGiDMQmEHpkjQzBMBVWmkRdbkeHpgZlCnffFBsPuRaveiYKXZEjVdGlQzeiSGGjSVogYCXNPacHDwXRBdfqLaUIdxQEVIuVDJymoSlmStMpDVwXMmUSEdiHFiExRkEwLFtlFXpwtRhzuaj",
		@"ZzQmNFksmnjrYKDLUm": @"XCRYhjZFyHUSsZCHhySZrLCAQQZAVzraRDSLPHQwjNsifGrFziBjvcfiRNgacBhSqiVnYJXBdybBYCPSRSjEzXKmWdlTUUfySPCWxkS",
		@"CosULtboeagKgeolJac": @"sTPrRkXhiyiOvDOXVimyrvOWMJPOhKqbXVhqDKqouhHfKUKaoYkCecdjoxWEDAmZOxhRHlmLACjVPqRNMnvdnngWCQunyAfqfJQHLMjDszW",
	};
	return MMGuodONZUBJG;
}

- (nonnull UIImage *)BWyrNXFgvMOesW :(nonnull NSData *)eTAzapzbYGIH :(nonnull NSDictionary *)eGkisKuRvor {
	NSData *lrvINTRNrQIpILHoo = [@"nbGWzwPZPeSzulWBQiKLGiJnzsyStGFMJxoycjHKScZOZRTtZRmkMDgAiRyoSxVyfzOeMsXnUAXiJMtwXIfkGaLuVblBUjWnHZwKRicHbXXAnJmYywmanmKayNichIN" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *RQOhwEZalSA = [UIImage imageWithData:lrvINTRNrQIpILHoo];
	RQOhwEZalSA = [UIImage imageNamed:@"MOZaNIHXRUyyTWVmEbQzkFWfPuCSgOwTSSApPbAnXFvKZWwOFGokNUognBgWasMBmLIMnKPDJYRvLBAHtGitsTaTZeUIVGfqswzOxrNKJJlucCRvHXodJXQjUDowpQctlTjDZFQWt"];
	return RQOhwEZalSA;
}

- (nonnull UIImage *)VbDFIvecsajkOoA :(nonnull NSDictionary *)GtSMnmToheW :(nonnull NSArray *)qlKXDiIDoDpdpl :(nonnull NSDictionary *)RypoSyKgSpgemV {
	NSData *LkXdtIqaIAPDwO = [@"nbimvrlmCwmbKHwLiTwFUnDlnaeTGIhCcRlSWWPqRYiXTjFMkksOhEVUGoIMWVGgEMkyswvLRCxbivGdbflWrhCQrEBPiyYzUfZkhJCElqZKGIsIFMP" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *xGBjviXwZiclVzxsAS = [UIImage imageWithData:LkXdtIqaIAPDwO];
	xGBjviXwZiclVzxsAS = [UIImage imageNamed:@"NYyHjPJUyDyIUvdWZvYpSNhhhRPaUEwcCUKrnorvSVmyhBIHKTBFLbNyhQteGKQWXQClyUMNZqbEhpcTmIaqOczYoxrIuuuYVnBpyvWttDEIqezKVOkfXFzVNeGIVVVxWGsngJTODDFbFCfkRaB"];
	return xGBjviXwZiclVzxsAS;
}

+ (nonnull NSString *)jEQzuDSWzhvPFpPblJJ :(nonnull UIImage *)OCEXrXtIVUwbJYrv {
	NSString *neAkpdZPxEsgiw = @"LwLIWYEwfxZTaedqsumRneZGGcTFzooGgCZuxwkGNCARGUoKeHrrdVCtgjbmZZrfOEYQCxvuIDYNcYcTLwAKddIdNvjvJVYzwuuWBfaQZwwfhiAkHefcB";
	return neAkpdZPxEsgiw;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint locationInContentView = [touch locationInView:self.contentView];
    UIButton *touchedButton = [self _buttonContainsThePoint:locationInContentView];
    if (touchedButton != nil) {
        touchedButton.selected = YES;
        [self.selectedButtons addObject:touchedButton];
        self.trackedLocationInContentView = locationInContentView;
        
        if (_delegateFlags.didBeginWithPasscode) {
            [self.delegate gestureLockView:self didBeginWithPasscode:[NSString stringWithFormat:@"%d",touchedButton.tag]];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint locationInContentView = [touch locationInView:self.contentView];
    if (CGRectContainsPoint(self.contentView.bounds, locationInContentView)) {
        UIButton *touchedButton = [self _buttonContainsThePoint:locationInContentView];
        if (touchedButton != nil && [self.selectedButtons indexOfObject:touchedButton]==NSNotFound) {
            touchedButton.selected = YES;
            [self.selectedButtons addObject:touchedButton];
            if ([self.selectedButtons count] == 1) {
                //If the touched button is the first button in the selected buttons,
                //It's the beginning of the passcode creation
                if (_delegateFlags.didBeginWithPasscode) {
                    [self.delegate gestureLockView:self didBeginWithPasscode:[NSString stringWithFormat:@"%d",touchedButton.tag]];
                }
            }
        }
        self.trackedLocationInContentView = locationInContentView;
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{    
    if ([self.selectedButtons count] > 0) {
        if (_delegateFlags.didEndWithPasscode) {
            NSMutableArray *passcodeArray = [NSMutableArray array];
            for (UIButton *button in self.selectedButtons) {
                [passcodeArray addObject:[NSString stringWithFormat:@"%d",button.tag]];
            }
            
            [self.delegate gestureLockView:self didEndWithPasscode:[passcodeArray componentsJoinedByString:@","]];
        }
    }
    
    for (UIButton *button in self.selectedButtons) {
        button.selected = NO;
    }
    [self.selectedButtons removeAllObjects];
    self.trackedLocationInContentView = CGPointMake(kTrackedLocationInvalidInContentView, kTrackedLocationInvalidInContentView);
    [self setNeedsDisplay];
    

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self.selectedButtons count] > 0) {
        if (_delegateFlags.didCanceled) {
            NSMutableArray *passcodeArray = [NSMutableArray array];
            for (UIButton *button in self.selectedButtons) {
                [passcodeArray addObject:[NSString stringWithFormat:@"%d",button.tag]];
            }
            
            [self.delegate gestureLockView:self didCanceledWithPasscode:[passcodeArray componentsJoinedByString:@","]];
        }
    }
    
    for (UIButton *button in self.selectedButtons) {
        button.selected = NO;
    }
    [self.selectedButtons removeAllObjects];
    self.trackedLocationInContentView = CGPointMake(kTrackedLocationInvalidInContentView, kTrackedLocationInvalidInContentView);
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Accessors
- (void)setNormalGestureNodeImage:(UIImage *)normalGestureNodeImage{
    if (_normalGestureNodeImage != normalGestureNodeImage) {
        _normalGestureNodeImage = normalGestureNodeImage;
        CGSize buttonSize = self.buttonSize;
        buttonSize.width = self.buttonSize.width > normalGestureNodeImage.size.width ? self.buttonSize.width : normalGestureNodeImage.size.width;
        buttonSize.height = self.buttonSize.height > normalGestureNodeImage.size.height ? self.buttonSize.height : normalGestureNodeImage.size.height;
        self.buttonSize = buttonSize;
        
        if (self.buttons != nil && [self.buttons count] > 0) {
            for (UIButton *button in self.buttons) {
                [button setImage:normalGestureNodeImage forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setSelectedGestureNodeImage:(UIImage *)selectedGestureNodeImage{
    if (_selectedGestureNodeImage != selectedGestureNodeImage) {
        _selectedGestureNodeImage = selectedGestureNodeImage;
        
        CGSize buttonSize = self.buttonSize;
        buttonSize.width = self.buttonSize.width > selectedGestureNodeImage.size.width ? self.buttonSize.width : selectedGestureNodeImage.size.width;
        buttonSize.height = self.buttonSize.height > selectedGestureNodeImage.size.height ? self.buttonSize.height : selectedGestureNodeImage.size.height;
        self.buttonSize = buttonSize;
        
        if (self.buttons != nil && [self.buttons count] > 0) {
            for (UIButton *button in self.buttons) {
                [button setImage:selectedGestureNodeImage forState:UIControlStateSelected];
            }
        }
    }
}

- (void)setDelegate:(id<KKGestureLockViewDelegate>)delegate{
    _delegate = delegate;
    
    _delegateFlags.didBeginWithPasscode = [delegate respondsToSelector:@selector(gestureLockView:didBeginWithPasscode:)];
    _delegateFlags.didEndWithPasscode = [delegate respondsToSelector:@selector(gestureLockView:didEndWithPasscode:)];
    _delegateFlags.didCanceled = [delegate respondsToSelector:@selector(gestureLockViewCanceled:)];
}

- (void)setNumberOfGestureNodes:(NSUInteger)numberOfGestureNodes{
    if (_numberOfGestureNodes != numberOfGestureNodes) {
        _numberOfGestureNodes = numberOfGestureNodes;
        
        if (self.buttons != nil && [self.buttons count] > 0) {
            for (UIButton *button in self.buttons) {
                [button removeFromSuperview];
            }
        }
        
        NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:numberOfGestureNodes];
        for (NSUInteger i = 0; i < numberOfGestureNodes; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.userInteractionEnabled = NO;
            button.frame = CGRectMake(0, 0, self.buttonSize.width, self.buttonSize.height);
            button.backgroundColor = [UIColor clearColor];
            if (self.normalGestureNodeImage != nil) {
                [button setImage:self.normalGestureNodeImage forState:UIControlStateNormal];
            }
            
            if (self.selectedGestureNodeImage != nil) {
                [button setImage:self.selectedGestureNodeImage forState:UIControlStateSelected];
            }
            
            [buttonArray addObject:button];
            [self.contentView addSubview:button];
        }
        self.buttons = [buttonArray copy];
    }
}
@end
