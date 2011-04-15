//
//  MenuScene.m
//  Populate
//
//  Created by Jarod Luebbert on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "HelloWorldLayer.h"

#define kMenuItemFontName @"MarkerFelt-Thin"
#define kMenuItemFontSize 32
#define kMenuItemPadding 15.0f
#define kMenuTag 100

@interface MenuScene (PrivateMethods)
- (void)createMenu;
- (void)playItemTouched:(id)sender;
@end

@implementation MenuScene

+ (id)scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [MenuScene node];
    [scene addChild:layer];
    return scene;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        CCLOG(@"initialized: %@", self);
        [self createMenu];
    }
    
    return self;
}

- (void)createMenu
{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    [CCMenuItemFont setFontName:kMenuItemFontName];
    [CCMenuItemFont setFontSize:kMenuItemFontSize];
    CCMenuItemFont *playItem = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(playItemTouched:)];
    
    CCMenu *menu = [CCMenu menuWithItems:playItem, nil];
    menu.position = CGPointMake(-windowSize.width/2, windowSize.height/2);
    menu.tag = kMenuTag;
    [menu alignItemsVerticallyWithPadding:kMenuItemPadding];

    [self addChild:menu];
    
    CCMoveTo* move = [CCMoveTo actionWithDuration:1 position:CGPointMake(windowSize.width / 2, windowSize.height / 2)];
	CCEaseElasticIn* ease = [CCEaseElasticIn actionWithAction:move period:0.8f];
	[menu runAction:ease];
}

- (void)playItemTouched:(id)sender
{
    CCLOG(@"play item touched: %@", sender);
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

@end
