//
//  GameScene.mm
//  Populate
//
//  Created by Jarod Luebbert on 4/14/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "GameScene.h"
#import "Constants.h"
#import "Enemy.h"

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

@implementation GameScene

@synthesize world;

static GameScene *gameSceneInstance;

#pragma mark -
#pragma mark Helpers

- (CCSpriteBatchNode *)getSpriteBatch
{
	return (CCSpriteBatchNode*)[self getChildByTag:kTagBatchNode];
}

#pragma mark -
#pragma mark Initialize

+ (GameScene *)sharedGameScene
{
    NSAssert(gameSceneInstance != nil, @"Game scene not yet initialized");
    return gameSceneInstance;
}

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild: layer];
	return scene;
}

- (id)init
{
    self = [super init];
	if(self != nil)
    {
        gameSceneInstance = self;
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
        
        [self initBox2dWorld];
        
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"populate.plist"];
        
        CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:@"populate.png" capacity:150];
		[self addChild:batch z:-2 tag:kTagBatchNode];
        
        Enemy *enemy = [Enemy enemyInWorld:world];
        [self addChild:enemy z:-1];
		
		[self schedule: @selector(tick:)];
	}
    
	return self;
}

- (void)initBox2dWorld
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCLOG(@"Screen width %0.2f screen height %0.2f", screenSize.width, screenSize.height);
    
    // Define the gravity vector.
    b2Vec2 gravity = b2Vec2(0.0f, -5.0f);
    bool doSleep = false;
    world = new b2World(gravity, doSleep);
    world->SetContinuousPhysics(true);
    
    // Debug Draw functions
    m_debugDraw = new GLESDebugDraw( PTM_RATIO );
    world->SetDebugDraw(m_debugDraw);
    
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    //		flags += b2DebugDraw::e_jointBit;
    //		flags += b2DebugDraw::e_aabbBit;
    //		flags += b2DebugDraw::e_pairBit;
    //		flags += b2DebugDraw::e_centerOfMassBit;
    m_debugDraw->SetFlags(flags);		
    
    // Define the ground body.
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0); // bottom-left corner
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.
    b2PolygonShape groundBox;
    
    float widthInMeters = screenSize.width / PTM_RATIO;
    float heightInMeters = screenSize.height / PTM_RATIO;
    b2Vec2 lowerLeftCorner = b2Vec2(0, 0);
    b2Vec2 lowerRightCorner = b2Vec2(widthInMeters, 0);
    b2Vec2 upperLeftCorner = b2Vec2(0, heightInMeters);
    b2Vec2 upperRightCorner = b2Vec2(widthInMeters, heightInMeters);
    int density = 0;
    
    // bottom
    groundBox.SetAsEdge(lowerLeftCorner, lowerRightCorner);
    groundBody->CreateFixture(&groundBox, density);
    
    // top
    groundBox.SetAsEdge(upperLeftCorner, upperRightCorner);
    groundBody->CreateFixture(&groundBox, density);
    
    // left
    groundBox.SetAsEdge(lowerLeftCorner, upperLeftCorner);
    groundBody->CreateFixture(&groundBox, density);
    
    // right
    groundBox.SetAsEdge(lowerRightCorner, upperRightCorner);
    groundBody->CreateFixture(&groundBox, density);
}

#pragma mark -
#pragma mark Render and update

- (void)draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}

- (void)tick:(ccTime)dt
{
	float timeStep = 0.03f;
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	world->Step(timeStep, velocityIterations, positionIterations);
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
        BodyNode *bodyNode = (BodyNode *)b->GetUserData();
		if (bodyNode != NULL && bodyNode.sprite != nil) 
        {
			bodyNode.sprite.position = CGPointMake(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			bodyNode.sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
}

#pragma mark -
#pragma mark Input

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity(accelX * 10, accelY * 10);
	
	world->SetGravity(gravity);
}

#pragma mark -
#pragma mark Clean up

- (void) dealloc
{
	delete world;
	world = NULL;
    
    gameSceneInstance = nil;
	
	delete m_debugDraw;
	[super dealloc];
}

@end
