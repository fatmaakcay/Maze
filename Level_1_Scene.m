//
//  Level_1_Scene.m
//  Maze
//
//  Created by Fatma Akcay on 12/5/13.
//  Copyright (c) 2013 Fatma Akcay. All rights reserved.
//

@import CoreMotion;
#import "Level_1_Scene.h"
#import "LevelScene.h"

typedef enum {
    kEndReasonWin,
    kEndReasonLose
} EndReason;


@implementation Level_1_Scene

{
    SKSpriteNode *background;
    SKSpriteNode *dont_touch_this1;
    SKSpriteNode *dont_touch_this2;
    SKSpriteNode *touch_this;
    SKSpriteNode *tab;
    SKSpriteNode *ball;
    CMMotionManager *_motionManager;
    int _win;

}


// Menu Button
- (SKSpriteNode *)MenuButtonNode
{
    SKSpriteNode *MenuNode = [SKSpriteNode spriteNodeWithImageNamed:@"MenuButton.png"];
    MenuNode.position = CGPointMake(30,535);
    MenuNode.scale = 0.2;
    MenuNode.name = @"MenuButtonNode";//how the node is identified later
    MenuNode.zPosition = 1.0;
    return MenuNode;
}

// Win Message
- (SKLabelNode *)YouWin
{
    SKLabelNode *label;
    label = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    label.name = @"winLabel";
    label.text = @"Level 1 complete";
    label.scale = 1;
    label.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    label.fontColor = [SKColor whiteColor];
    return label;
}

// Lose Message
- (SKLabelNode *)YouLost
{
    SKLabelNode *label;
    label = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    label.name = @"winLabel";
    label.text = @"You Lost! Try Again!";
    label.scale = 1;
    label.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    label.fontColor = [SKColor whiteColor];
    return label;
}



-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        // Set the edges so the ball does not fall through
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        // Setup background
        background = [SKSpriteNode spriteNodeWithImageNamed: @"BlueBackground.png"];
        background.position = CGPointMake(160,258);
        
        // Set up maze
        dont_touch_this1 = [SKSpriteNode spriteNodeWithImageNamed:@"Level1_Maze1.png"];
        dont_touch_this1.position = CGPointMake(225,450);

        dont_touch_this2 = [SKSpriteNode spriteNodeWithImageNamed:@"Level1_Maze2.png"];
        dont_touch_this2.position = CGPointMake(75,75);
        
        // Set up red dot
        touch_this = [SKSpriteNode spriteNodeWithImageNamed:@"GOAL.png"];
        touch_this.position = CGPointMake(280,40);

        // Set up bar at the top of screen
        tab = [SKSpriteNode spriteNodeWithImageNamed:@"Tab.png"];
        tab.position = CGPointMake(160,543);


        // Add marble to scene, add a 'weight'
        ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball.png"];
        ball.scale = 0.025;

        // Create a rectangular physics body the same size as the ball.
        ball.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ball.frame.size];
        
        // Make the shape dynamic; this makes it subject to things such as collisions and other outside forces.
        ball.physicsBody.dynamic = YES;
        
        // You don't want the ball to drop off the bottom of the screen, so you indicate that it's not affected by gravity.
        ball.physicsBody.affectedByGravity = NO;
        
        // Give the ball an arbitrary mass so that its movement feels natural.
        ball.physicsBody.mass = 0.05;
        
        
        // Setup the Accelerometer to move the ball
        _motionManager = [[CMMotionManager alloc] init];
        
        // Add all elements
        [self addChild: background];
        [self addChild: dont_touch_this1];
        [self addChild: dont_touch_this2];
        [self addChild: touch_this];
        [self addChild: tab];
        [self addChild: [self MenuButtonNode]];
        [self addChild: ball];
        [self startTheGame];

    }
    return self;
    
}



// Function to set up the game
- (void)startTheGame
{
    _win = 0;
    //reset ship position for new game
    ball.position = CGPointMake(20, 500);
    
    //setup to handle accelerometer readings using CoreMotion Framework
    [self startMonitoringAcceleration];
    
}

// Self explanatory
- (void)startMonitoringAcceleration
{
    if (_motionManager.accelerometerAvailable) {
        [_motionManager startAccelerometerUpdates];
        NSLog(@"accelerometer updates on...");
    }
}

- (void)stopMonitoringAcceleration
{
    if (_motionManager.accelerometerAvailable && _motionManager.accelerometerActive) {
        [_motionManager stopAccelerometerUpdates];
        NSLog(@"accelerometer updates off...");
    }
}


// handle touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Transition to menu
    SKTransition *reveal = [SKTransition flipVerticalWithDuration:1.0];
    
    SKScene * Menu_scene = [LevelScene sceneWithSize:skView.bounds.size];
    Menu_scene.scaleMode = SKSceneScaleModeAspectFill;

    // if menu button touched or the win label, go to Menu
    if ([node.name isEqualToString:@"MenuButtonNode"])
    {
        [self.scene.view presentScene: Menu_scene transition: reveal];
    }
    
    if ([node.name isEqualToString:@"winLabel"])
    {
        [self.scene.view presentScene: Menu_scene transition: reveal];
    }
    
}

// update the ball's position from movement
- (void)updateBallPositionFromMotionManager
{
    CMAccelerometerData* data = _motionManager.accelerometerData;
    if (fabs(data.acceleration.x) > 0.3) {
        
        // velocity in x direction
        [ball.physicsBody applyForce:CGVectorMake(30.0*data.acceleration.x, 0.0)];
    }
    else {
        
        // keep ball still if x-direction is 0
        [ball.physicsBody applyForce:CGVectorMake(0.0, 0.0)];
    }
    
    if (fabs(data.acceleration.y) > 0.3) {
        
        // velocity in y direction
        [ball.physicsBody applyForce:CGVectorMake(0.0, 15.0*data.acceleration.y)];
    }
    else {
        
        // keep ball still in y direction
        [ball.physicsBody applyForce:CGVectorMake(0.0, 0.0)];
    }

    
        
}


-(void)update:(NSTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //Update ball's position
    [self updateBallPositionFromMotionManager];
    
    // detect collision
    if ([ball intersectsNode:touch_this]) {
        _win++;
    }
    
    if ([ball intersectsNode: dont_touch_this1]) {
        _win--;
    }
    
    if ([ball intersectsNode: dont_touch_this2]) {
        _win--;
    }

    
    if (_win > 0) {
        NSLog(@"you won...");
        [self endTheScene:kEndReasonWin];
    }
    
    if (_win < 0) {
        NSLog(@"you lost...");
        [self endTheScene:kEndReasonLose];
    }

    
}

// function for end of scene
- (void)endTheScene:(EndReason)endReason {
    
    [self removeAllActions];
    [self stopMonitoringAcceleration];
    
    ball.hidden = YES;
    ball.position = CGPointMake(20, 500);

    if (endReason == kEndReasonWin) {
        [self addChild: [self YouWin]];
        
    } else if (endReason == kEndReasonLose) {
        [self addChild: [self YouLost]];
    }

}

@end

