//
//  Enemy.h
//  Populate
//
//  Created by Jarod Luebbert on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"

@interface Enemy : BodyNode
{
    b2BodyDef *bodyDef;
}

@property (nonatomic, readonly) b2BodyDef *bodyDef;

+ (id)enemyInWorld:(b2World *)world;
- (id)initWithWorld:(b2World *)world;
- (void)update:(ccTime)delta;

@end
