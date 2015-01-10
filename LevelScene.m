//
//  LevelScene.m
//  Maze
//
//  Created by Fatma Akcay on 12/5/13.
//  Copyright (c) 2013 Fatma Akcay. All rights reserved.
//

#import "LevelScene.h"
#import "Level_1_Scene.h"
#import "Level_2_Scene.h"
#import "Level_3_Scene.h"
#import "MyScene.h"

@implementation LevelScene

{
    SKSpriteNode *background;
    
}

//Back Button
- (SKSpriteNode *)BackButtonNode
{
    SKSpriteNode *BackNode = [SKSpriteNode spriteNodeWithImageNamed:@"BackButton.png"];
    BackNode.position = CGPointMake(30,535);
    BackNode.scale = 0.2;
    BackNode.name = @"BackButtonNode";//how the node is identified later
    BackNode.zPosition = 1.0;
    return BackNode;
}

// Nodes for each level button
- (SKSpriteNode *)Level_OneNode
{
    SKSpriteNode *Level_One = [SKSpriteNode spriteNodeWithImageNamed:@"Level_One_Button.png"];
    Level_One.position = CGPointMake(160,380);
    Level_One.scale = 0.5;
    Level_One.name = @"Level_OneNode";//how the node is identified later
    Level_One.zPosition = 1.0;
    return Level_One;
}

- (SKSpriteNode *)Level_TwoNode
{
    SKSpriteNode *Level_Two = [SKSpriteNode spriteNodeWithImageNamed:@"Level_Two_Button.png"];
    Level_Two.position = CGPointMake(160,300);
    Level_Two.scale = 0.5;
    Level_Two.name = @"Level_TwoNode";//how the node is identified later
    Level_Two.zPosition = 1.0;
    return Level_Two;
}

- (SKSpriteNode *)Level_ThreeNode
{
    SKSpriteNode *Level_Three = [SKSpriteNode spriteNodeWithImageNamed:@"Level_Three_Button.png"];
    Level_Three.position = CGPointMake(160,220);
    Level_Three.scale = 0.5;
    Level_Three.name = @"Level_ThreeNode";//how the node is identified later
    Level_Three.zPosition = 1.0;
    return Level_Three;
}


-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        background = [SKSpriteNode spriteNodeWithImageNamed:@"Background.png"];
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        
        
        [self addChild: background];
        [self addChild: [self Level_OneNode]];
        [self addChild: [self Level_TwoNode]]; 
        [self addChild: [self Level_ThreeNode]];
        [self addChild: [self BackButtonNode]];

    }
    return self;

}

//handle touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    SKTransition *reveal = [SKTransition flipVerticalWithDuration:1.0];
    
    
    // Create and configure the scenes for levels
    SKScene * Level_1 = [Level_1_Scene sceneWithSize:skView.bounds.size];
    Level_1.scaleMode = SKSceneScaleModeAspectFill;
    
    SKScene * Level_2 = [Level_2_Scene sceneWithSize:skView.bounds.size];
    Level_1.scaleMode = SKSceneScaleModeAspectFill;
    
    SKScene * Level_3 = [Level_3_Scene sceneWithSize:skView.bounds.size];
    Level_1.scaleMode = SKSceneScaleModeAspectFill;
    
    SKScene * Menu_scene = [MyScene sceneWithSize:skView.bounds.size];
    Menu_scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // back button, and level buttons set up
    if ([node.name isEqualToString:@"BackButtonNode"])
    {
        [self.scene.view presentScene: Menu_scene transition: reveal];
    }
    
    if ([node.name isEqualToString:@"Level_OneNode"])
    {
        [self.scene.view presentScene: Level_1 transition: reveal];
    }
    
    if ([node.name isEqualToString:@"Level_TwoNode"])
    {
        [self.scene.view presentScene: Level_2 transition: reveal];
    }
    
    if ([node.name isEqualToString:@"Level_ThreeNode"])
    {
        [self.scene.view presentScene: Level_3 transition: reveal];
    }

}

@end
