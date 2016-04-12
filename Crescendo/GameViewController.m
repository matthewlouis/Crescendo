//
//  GameViewController.m
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>
#import "Crescendo-Swift.h"
@import AudioKit;
#import "Plane.h"
#import "PlaneContainer.h"
#import "HandleInputs.h"
#import "BaseEffect.h"
#import "GameScene.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

@interface GameViewController () {
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    BaseEffect *_shader;
    GameScene *_scene;
    GLKMatrix4 projectionMatrix;
    
    GameMusicPlayer *_musicPlayer;
    
    NSInteger highScore;
    
    GLKVector4 backgroundColor;
    
    SCNRenderer *fxRenderer;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) HandleInputs *handleInput;
@property (strong, nonatomic) MessageView *messageView;

- (void)setupGL;



- (void)initializeClasses;
- (void)createGestures;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _messageView = [[MessageView alloc]init];
    [self.messageView sceneSetup];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    fxRenderer = [SCNRenderer rendererWithContext:self.context options:nil];
    fxRenderer.scene = self.messageView.scene;

    [self initializeClasses];
    [self createGestures];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    
    [self newGame];
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupScene
{
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 85.0f);
    
    [self.handleInput setProjectionMatrix:projectionMatrix];
    self.handleInput.messageView = _messageView; //for dismissing messages with touch
    
    _shader = [[BaseEffect alloc]init];
    _shader->projectionMatrix = projectionMatrix;
    
    _scene = [[GameScene alloc] initWithShader:_shader HandleInputs:self.handleInput];
    
    [self.messageView displayTitle];
    [Theme themeMidnightIce];
    backgroundColor = [Theme background];
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    _musicPlayer = nil;
    
    [_scene CleanUp];
    
    if (_shader) {
        [_shader tearDown];
    }
    
    [EAGLContext setCurrentContext:nil];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    backgroundColor = [Theme background];
    //Matt: debug stuff
    if(!_scene.gameOver){ //if the game is running
    // Update Scene
        [_scene updateWithDeltaTime:self.timeSinceLastUpdate];
    }else if(!self.messageView.gameOver){ //if game is over and gameOver screen not displayed
        [self saveScore];
        [self.messageView displayGameOver: _scene.score highscore:highScore];
        [_musicPlayer fadeOutMusic];
    }else if(self.messageView.messageIsDisplayed){ //gameOver and gameOver screen displayed
        if(_scene.restart){ //if flagged to restart game
            _scene.restart = false;
            [_messageView messageConfirmed];
            [_scene restartGame];
        }
    }
    [_shader update:self.timeSinceLastUpdate];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Rendering Code for Jarred
    glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glBindVertexArrayOES(0);
    glBindVertexArrayOES(_vertexArray);
    
    [_shader render:[_scene GetPlanes]];
    [_shader render:[_scene GetPlayer]];
    glDepthMask(GL_FALSE);
    [_shader render:[_scene GetPlaneObjects]];
    glDepthMask(GL_TRUE);
    
    [fxRenderer renderAtTime:fxRenderer.sceneTime];
}


// The first method to respond to a Touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Begin transformations
    [self.handleInput respondToTouchesBegan];
    
    if(_scene.gameOver){
        _scene.restart = true;
    }
}

- (void)initializeClasses
{
    self.handleInput = [[HandleInputs alloc] init];
}

- (void)createGestures
{
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self.handleInput action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    UIPanGestureRecognizer *swipePan = [[UIPanGestureRecognizer alloc] initWithTarget:self.handleInput action:@selector(handleSwipes:)];
    [swipePan setMaximumNumberOfTouches:1];
    [swipePan setMinimumNumberOfTouches:1];
    [self.view addGestureRecognizer:swipePan];
    swipePan.enabled = false;

}

-(BaseEffect *)GetShader
{
    return _shader;
}

-(void)newGame{
    _scene = nil;
    
    // Create the game scene
    [self setupScene];
    
    //get musicplayer (must be called after planeContainer init
    _musicPlayer = [_scene getGlobalMusicPlayer];
    
    // Store musicplayer reference in effect
    _shader->musicPlayer = _musicPlayer;
}

//Userdefaults not saving integer values, but working with strings, hence the string conversions
-(void)saveScore{
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];

    //get current highscore
    NSString *highScoreString = [userPrefs objectForKey:HIGH_SCORE];
    highScore = [highScoreString integerValue]; //get int value for comparison
    
    if(_scene.score > highScore){ //if new score is higher
        highScoreString = [NSString stringWithFormat:@"%ld", _scene.score];
        highScore = _scene.score;
    }
    
    [userPrefs setObject:highScoreString forKey:HIGH_SCORE];
    [userPrefs synchronize]; //force sync */
}

@end
