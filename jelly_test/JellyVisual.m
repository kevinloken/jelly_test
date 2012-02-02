//
//  JellyVisual.m
//  jelly_test
//
//  Created by Kevin Loken on 12-02-01.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JellyVisual.h"


@implementation JellyVisual

-(id)initWithJelly:(FallingBody *)body andShape:(ClosedShape *)shape
{
    self = [super init];
    if ( self != nil ) {
        _jelly = [body retain];
        _shape = [shape retain];
        
        UIImage* image = [UIImage imageNamed:@"Icon.png"];
        _skin = [[[CCTexture2D alloc] initWithImage:image] retain];
    }
    return self;
}

-(void)dealloc
{
    [_skin release];
    [_jelly release];
    [_shape release];
    
    [super dealloc];
}

#define BLOB_SEGMENTS 4
#define BLOB_SKIN_SCALE 1.0f

-( void )draw {
	CGPoint segmentPos[ BLOB_SEGMENTS + 2 ];
	CGPoint texturePos[ BLOB_SEGMENTS + 2 ];
	CGPoint textureCenter;
	float angle, baseAngle;
    
	// calculate triangle fan segments
    
	segmentPos[ 0 ] = CGPointZero;
    // get relative position and multiply for scale
    CGPoint pos = [_jelly position];
    
    for ( int count = 0; count < BLOB_SEGMENTS; ++count ) {
        segmentPos[ count + 1 ] = ccpMult( [_shape vertex:count], BLOB_SKIN_SCALE );
    }
    segmentPos[ BLOB_SEGMENTS + 1 ] = segmentPos[ 1 ];
    
	// move to absolute position
	for ( int count = 0; count < ( BLOB_SEGMENTS + 2 ); count ++ )
    {
		segmentPos[ count ] = ccpAdd( pos, segmentPos[ count ] );
    }
    
	// remap skin
	// done to be able to control skin rotation independently from blob rotation
    // ChipmunkBody* eb = [_jelly.edgeBodies objectAtIndex:0];
	baseAngle = 0; // [ UTIL angle:_centralBody.pos b:eb.pos ];
    
	texturePos[ 0 ] = CGPointZero;
	for ( int count = 0; count < BLOB_SEGMENTS; count ++ ) {
		// calculate new angle
		angle						= baseAngle + ( 2 * M_PI / BLOB_SEGMENTS * count );
		// calculate texture position
		texturePos[ count + 1 ].x	= sinf( angle );
		texturePos[ count + 1 ].y	= cosf( angle );
	}
	texturePos[ BLOB_SEGMENTS + 1 ] = texturePos[ 1 ];
    
	// recalculate to texture coordinates
	textureCenter = CGPointMake( 0.5f, 0.5f );
	for ( int count = 0; count < ( BLOB_SEGMENTS + 2 ); count ++ )
		texturePos[ count ] = ccpAdd( ccpMult( texturePos[ count ], 0.5f ), textureCenter );
    
    
	glColor4ub( 128, 255, 128, 255 );
    
	glEnable( GL_TEXTURE_2D );
	glBindTexture( GL_TEXTURE_2D, [ _skin name ] ); 
    
	// glDisableClientState( GL_TEXTURE_COORD_ARRAY );
	glDisableClientState( GL_COLOR_ARRAY );
    
	glTexCoordPointer( 2, GL_FLOAT, 0, texturePos );
    
	glVertexPointer( 2, GL_FLOAT, 0, segmentPos );
    
	glDrawArrays( GL_TRIANGLE_FAN, 0, BLOB_SEGMENTS + 2 );
    
}


@end
