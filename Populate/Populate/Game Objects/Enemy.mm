//
//  Enemy.m
//  Populate
//
//  Created by Jarod Luebbert on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "GameScene.h"
#import "Constants.h"

#define kEnemySpriteName @"ball.png"

@interface Enemy (PrivateMethods)
- (void)createEnemyInWorld:(b2World *)world;
@end

@implementation Enemy

@synthesize bodyDef;

+ (id)enemyInWorld:(b2World *)world
{
    return [[[self alloc] initWithWorld:world] autorelease];
}

- (id)initWithWorld:(b2World *)world
{
    self = [super init];
    if (self != nil)
    {
        [self createEnemyInWorld:world];
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)createEnemyInWorld:(b2World *)world
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    float randomOffset = CCRANDOM_0_1() * 10.0f - 5.0f;
    CGPoint startPos = CGPointMake(screenSize.width - 15 + randomOffset, 80);
    CCLOG(@"Adde sprite to position (%0.2f, %02.f)", startPos.x, startPos.y);
    
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
    bodyDef = new b2BodyDef;
	bodyDef->type = b2_dynamicBody;
	bodyDef->position.Set(startPos.x / PTM_RATIO, startPos.y / PTM_RATIO);
	
	// Define another box shape for our dynamic body.
	b2CircleShape shape;
    CCSprite *tmpSprite = [CCSprite spriteWithSpriteFrameName:kEnemySpriteName];
    float radiusInMeters = (tmpSprite.contentSize.width / PTM_RATIO) * 0.5f;
	shape.m_radius = radiusInMeters;
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;	
	fixtureDef.density = 0.95f;
	fixtureDef.friction = 0.7f;
    fixtureDef.restitution = 0.95f;
    
    [super createBodyInWorld:world bodyDef:bodyDef fixtureDef:&fixtureDef spriteFrameName:kEnemySpriteName];
    
    b2Vec2 force = b2Vec2(10, 10);
    body->ApplyLinearImpulse(force, bodyDef->position);
}

- (void)update:(ccTime)delta
{
    // counter the gravity so the enemy isn't as affected by it
    body->ApplyForce(-1 * body->GetMass() * [GameScene sharedGameScene].world->GetGravity(), bodyDef->position);
}

- (void)dealloc
{
    delete bodyDef;
    bodyDef = NULL;
    [super dealloc];
}

@end
