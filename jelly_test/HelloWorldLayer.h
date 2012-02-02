//
//  HelloWorldLayer.h
//  jelly_test
//
//  Created by Kevin Loken on 12-02-01.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "World.h"
#import "ClosedShape.h"
#import "Body.h"
#import "FallingBody.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    World* _world;
    ClosedShape* _groundShape;
    Body* _groundBody;
    
    NSMutableArray* _jellies;    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
