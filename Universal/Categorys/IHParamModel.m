//
//  SMParamModel.m
//  SMAirlineTickets
//
//  Created by Liang She on 13-5-22.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "IHParamModel.h"

static IHParamModel *manager=nil;
@implementation IHParamModel
@synthesize param,configData;

+(IHParamModel *)parammanagement{
	@synchronized(self){
		if (manager==nil) {
			manager=[[IHParamModel alloc] init];
			manager.param=[[NSMutableDictionary alloc] init];
            manager.configData =[[NSMutableDictionary alloc] init];
            
		}
	}
    
	return manager;
}

-(void)clearParam{
	[manager.param removeAllObjects];
}

-(void)setParamNil
{
    manager = nil;
}


@end
