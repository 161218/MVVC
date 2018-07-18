//
//  SMParamModel.h
//  SMAirlineTickets
//
//  Created by Liang She on 13-5-22.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ParamManager			[IHParamModel parammanagement]

@interface IHParamModel : NSObject {

	NSMutableDictionary *param;
    NSMutableDictionary* configData;
    
}
@property(nonatomic,retain)NSMutableDictionary *param;
@property(nonatomic,retain) NSMutableDictionary* configData;

+(IHParamModel *)parammanagement;
-(void)clearParam;
-(void)setParamNil;

@end
