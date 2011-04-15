//
//  GameScene.h
//  Populate
//
//  Created by Jarod Luebbert on 4/14/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@interface GameScene : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
}

@property (readonly) b2World *world;

+ (GameScene *)sharedGameScene;
+ (CCScene *)scene;
- (CCSpriteBatchNode *)getSpriteBatch;
- (void)initBox2dWorld;

@end
