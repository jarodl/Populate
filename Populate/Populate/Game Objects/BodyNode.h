//
//  BodyNode.h
//  Populate
//
//  Created by Jarod Luebbert on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"

@interface BodyNode : CCNode
{
    b2Body *body;
    CCSprite *sprite;
}

@property (nonatomic, readonly) b2Body *body;
@property (nonatomic, readonly) CCSprite *sprite;

- (void)createBodyInWorld:(b2World*)world
                  bodyDef:(b2BodyDef*)bodyDef
               fixtureDef:(b2FixtureDef*)fixtureDef
          spriteFrameName:(NSString*)spriteFrameName;
-(void) removeSprite;
-(void) removeBody;

@end
