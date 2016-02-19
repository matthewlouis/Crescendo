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
    
    GameMusicPlayer *musicPlayer;
    AKReverb2 *reverbEffect;
    
    // Plane Container
    PlaneContainer *planeContainer;
    
    BaseEffect *_shader;
    GameScene *_scene;
    GLKMatrix4 projectionMatrix;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) HandleInputs *handleInput;

- (void)setupGL;
- (void)tearDownGL;


- (void)initializeClasses;
- (void)createGestures;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    musicPlayer = [[GameMusicPlayer alloc] init];
    
    // Initialize plane container
    planeContainer = [[PlaneContainer alloc] init];
    [planeContainer CreatePlane];
    
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    [self initializeClasses];
    [self createGestures];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    
    // Create the game scene
    [self setupScene];
    
    [musicPlayer load];
    
    //using this to show that we can affect sound from game code
    //reverbEffect = (AKReverb2 *)[musicPlayer getFX:4 fxIndex:0];
    
    [musicPlayer play];
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
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    _shader = [[BaseEffect alloc]init];
    _shader->projectionMatrix = projectionMatrix;
    
    _scene = [[GameScene alloc] initWithShader:_shader];
    
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
    
    if (_shader) {
        [_shader tearDown];
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    // Update Plane Container
    [planeContainer update:self.timeSinceLastUpdate];
    
    [_scene update];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Rendering Code for Jarred
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    [_shader render:_scene];
    
}


// The first method to respond to a Touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Begin transformations
    [self.handleInput respondToTouchesBegan];
    NSLog(@"Starting Gestures");
}

- (void)initializeClasses
{
    self.handleInput = [[HandleInputs alloc] initWithViewSize:self.view.frame.size];
}

- (void)createGestures
{
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self.handleInput action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    // Drag model gesture
    UIPanGestureRecognizer *singleFingerDrag = [[UIPanGestureRecognizer alloc] initWithTarget:self.handleInput action:@selector(handleSingleDrag:)];
    [self.view addGestureRecognizer:singleFingerDrag];
}

@end
