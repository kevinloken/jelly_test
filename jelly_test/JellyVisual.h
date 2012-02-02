//
//  JellyVisual.h
//  jelly_test
//
//  Created by Kevin Loken on 12-02-01.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FallingBody.h"
#import "ClosedShape.h"

@interface JellyVisual : CCNode {
    CCTexture2D* _skin;
    FallingBody* _jelly;
    ClosedShape* _shape;
}

-(id)initWithJelly:(FallingBody*)body andShape:(ClosedShape*)shape;

@end
