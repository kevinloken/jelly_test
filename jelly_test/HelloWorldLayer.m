//
//  HelloWorldLayer.m
//  jelly_test
//
//  Created by Kevin Loken on 12-02-01.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "FallingBody.h"
#import "JellyVisual.h"

#define kCoconut 1

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        _world = [[World alloc] init];
        
        // static ground object.
        _groundShape = [[ClosedShape alloc] init];
        [_groundShape begin];
        [_groundShape addVertex:ccp(-240.f, -10.f)];
        [_groundShape addVertex:ccp(-240.f, +10.f)];
        [_groundShape addVertex:ccp(+240.f,+10.f)];
        [_groundShape addVertex:ccp(+240.f,-10.f)];
        [_groundShape finish];
        
        // make the body.
        _groundBody = [[Body alloc] initWithWorld:_world 
                                            shape:_groundShape 
                                     massPerPoint:1000000.0f 
                                         position:ccp(240.f,0.0f) 
                                   angleInRadians:0.f 
                                            scale:ccp(1.f,1.f) 
                                        kinematic:NO];

        self.isTouchEnabled = YES;
        
        _jellies = [[NSMutableArray alloc] initWithCapacity:10];
        
        [self schedule:@selector(update:) interval:1.0f/30.0f];
	}
	return self;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[_groundBody release];
    [_groundShape release];
    [_world release];
    
    [_jellies release];

	// don't forget to call "super dealloc"
	[super dealloc];
}


-(void)update:(ccTime)dt
{
    for ( int i = 0; i < 4; ++i ) {
        [_world update:1.0f/120.0f];
    }
}


-(void)touchBegan:(UITouch*)touch withEvent:(UIEvent*)event{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];

    
    CCSprite* sprite = [CCSprite spriteWithFile:@"Icon.png"];
    float spriteWidth = sprite.contentSize.width / 2.0f;
    float spriteHeight = sprite.contentSize.height / 2.0f;
    
    CGPoint vertices[] = {
        {-1.5f, 2.0f},
        {-0.5f, 2.0f},
        { 0.5f, 2.0f},
        { 1.5f, 2.0f},
        { 1.5f, 1.0f},
        { 0.5f, 1.0f},
        { 0.5f,-1.0f},
        { 1.5f,-1.0f},
        { 1.5f,-2.0f},
        { 0.5f,-2.0f},
        {-0.5f,-2.0f},
        {-1.5f,-2.0f},
        {-1.5f,-1.0f},
        {-0.5f,-1.0f},
        {-0.5f, 1.0f},
        {-1.5f, 1.0f}
    };
        
    
    ClosedShape* shape = [[[ClosedShape alloc] init] autorelease];
    [shape begin];
        for ( int i = 0; i < sizeof(vertices)/sizeof(vertices[0]); ++i ) {
            [shape addVertex:ccp( vertices[i].x * spriteWidth, vertices[i].y * spriteHeight)];
        }
//    [shape addVertex:ccp(-spriteWidth, 0.f)];
//    [shape addVertex:ccp(0.f, spriteHeight)];
//    [shape addVertex:ccp(spriteWidth, 0.f)];
//    [shape addVertex:ccp(0.f, -spriteHeight)];
    [shape finish];
    
    FallingBody* body = [[[FallingBody alloc] initWithWorld:_world 
                                                     shape:shape
                                              massPerPoint:1.f
                          gasPressure:10.0f shapeK:100.0f shapeD:10.0f  
                                               edgeSpringK:300.f
                                            edgeSpringDamp:10.f
                                                  position: ccp(touchLocation.x, touchLocation.y)
                                            angleInRadians:0.0f
                                                     scale:ccp(1.0f,1.0f)
                                                  kinematic: NO] autorelease];
    
    // [body addInternalSpring:0 pointB:2 springK:400.f damping:12.f];
    // [body addInternalSpring:1 pointB:3 springK:400.f damping:12.f];
    
    JellyVisual* jelly = [[JellyVisual alloc] initWithJelly:body andShape:shape];
    [self addChild:jelly];
    
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch* touch = [touches anyObject];
    [self touchBegan:touch withEvent:event];
}

@end
