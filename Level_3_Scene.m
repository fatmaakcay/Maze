//
//  Level_3_Scene.m
//  Maze
//
//  Created by Fatma Akcay on 12/5/13.
//  Copyright (c) 2013 Fatma Akcay. All rights reserved.
//

@import CoreMotion;
#import "Level_3_Scene.h"
#import "LevelScene.h"


typedef enum {
    kEndReasonWin,
    kEndReasonLose
} EndReason;


@implementation Level_3_Scene

{
    SKSpriteNode *background;
    SKSpriteNode *dont_touch_this1;
    SKSpriteNode *dont_touch_this2;
    SKSpriteNode *dont_touch_this3;
    SKSpriteNode *dont_touch_this4;
    SKSpriteNode *touch_this;
    SKSpriteNode *tab;
    SKSpriteNode *ball;
    CMMotionManager *_motionManager;
    int _win;
    
}

- (SKSpriteNode *)MenuButtonNode
{
    SKSpriteNode *MenuNode = [SKSpriteNode spriteNodeWithImageNamed:@"MenuButton.png"];
    MenuNode.position = CGPointMake(30,535);
    MenuNode.scale = 0.2;
    MenuNode.name = @"MenuButtonNode";//how the node is identified later
    MenuNode.zPosition = 1.0;
    return MenuNode;
}

- (SKLabelNode *)YouWin
{
    SKLabelNode *label;
    label = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    label.name = @"winLabel";
    label.text = @"Level 3 complete";
    label.scale = 1;
    label.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    label.fontColor = [SKColor whiteColor];
    return label;
}

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

        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        background = [SKSpriteNode spriteNodeWithImageNamed: @"BlueBackground.png"];
        background.position = CGPointMake(160,258);
        
        dont_touch_this1 = [SKSpriteNode spriteNodeWithImageNamed:@"Level3_Maze1.png"];
        dont_touch_this1.position = CGPointMake(30,170);
        
        dont_touch_this2 = [SKSpriteNode spriteNodeWithImageNamed:@"Level3_Maze2.png"];
        dont_touch_this2.position = CGPointMake(200,27);
        
        dont_touch_this3 = [SKSpriteNode spriteNodeWithImageNamed:@"Level3_Maze3.png"];
        dont_touch_this3.position = CGPointMake(245, 300);
        
        dont_touch_this4 = [SKSpriteNode spriteNodeWithImageNamed:@"Level3_Maze4.png"];
        dont_touch_this4.position = CGPointMake(20,400);
        
        touch_this = [SKSpriteNode spriteNodeWithImageNamed:@"GOAL.png"];
        touch_this.position = CGPointMake(40,40);
        
        
        tab = [SKSpriteNode spriteNodeWithImageNamed:@"Tab.png"];
        tab.position = CGPointMake(160,543);

        ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball.png"];
        ball.scale = 0.025;

        ball.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ball.frame.size];

        ball.physicsBody.dynamic = YES;

        ball.physicsBody.affectedByGravity = NO;
 
        ball.physicsBody.mass = 0.05;
   
        _motionManager = [[CMMotionManager alloc] init];
        
        
        [self addChild: background];
        [self addChild: dont_touch_this1];
        [self addChild: dont_touch_this2];
        [self addChild: dont_touch_this3];
        [self addChild: dont_touch_this4];
        [self addChild: touch_this];
        [self addChild: tab];
        [self addChild: [self MenuButtonNode]];
        [self addChild: ball];
        [self startTheGame];
        
    }
    return self;
    
}




- (void)startTheGame
{
    _win = 0;

    ball.position = CGPointMake(20, 500);

    [self startMonitoringAcceleration];
    
}


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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;

    SKTransition *reveal = [SKTransition flipVerticalWithDuration:1.0];
    
    SKScene * Menu_scene = [LevelScene sceneWithSize:skView.bounds.size];
    Menu_scene.scaleMode = SKSceneScaleModeAspectFill;

    if ([node.name isEqualToString:@"MenuButtonNode"])
    {
        [self.scene.view presentScene: Menu_scene transition: reveal];
    }
    
    if ([node.name isEqualToString:@"winLabel"])
    {
        [self.scene.view presentScene: Menu_scene transition: reveal];
    }
    
}

- (void)updateBallPositionFromMotionManager
{
    CMAccelerometerData* data = _motionManager.accelerometerData;
    if (fabs(data.acceleration.x) > 0.3) {

        [ball.physicsBody applyForce:CGVectorMake(30.0*data.acceleration.x, 0.0)];
    }
    else {

        [ball.physicsBody applyForce:CGVectorMake(0.0, 0.0)];
    }
    
    if (fabs(data.acceleration.y) > 0.3) {

        [ball.physicsBody applyForce:CGVectorMake(0.0, 15.0*data.acceleration.y)];
    }
    else {

        [ball.physicsBody applyForce:CGVectorMake(0.0, 0.0)];
    }
    
    
    
}


-(void)update:(NSTimeInterval)currentTime {

    [self updateBallPositionFromMotionManager];
  
    if ([ball intersectsNode:touch_this]) {
        _win++;
    }
    
    if ([ball intersectsNode: dont_touch_this1]) {
        _win--;
    }
    
    if ([ball intersectsNode: dont_touch_this2]) {
        _win--;
    }
    
    if ([ball intersectsNode: dont_touch_this3]) {
        _win--;
    }
    
    if ([ball intersectsNode: dont_touch_this4]) {
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


