//
//  Player.m
//  Populate
//
//  Created by Jarod Luebbert on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "GameScene.h"
#import "Constants.h"

#define kPlayerSpriteName @""

@interface Player (PrivateMethods)
- (void)createPlayerInWorld:(b2World *)world;
@end

@implementation Player

+ (id)playerInWorld:(b2World *)world
{
    return [[[self alloc] initWithWorld:world] autorelease];
}

- (id)initWithWorld:(b2World *)world
{
    self = [super init];
    if (self != nil)
    {
        [self createPlayerInWorld:world];
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)createPlayerInWorld:(b2World *)world
{
}

- (void)update:(ccTime)delta
{
    // scale the player if it is active
}

@end
