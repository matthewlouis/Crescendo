//
//  GridMovement.m
//  Crescendo
//
//  Created by Steven Chen on 2016-02-11.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "GridMovement.h"
#import "Plane.h"

@interface GridMovement ()
{
    CGSize     _deviceSize;
    CGSize     _planeSize;
    CGSize     _cellDeviceSize;
    CGSize     _cellPlaneSize;
    
    GLKVector2 _gridCount;
    GLKVector2 *cellArray;
    GridQuadrant _playerQuadrant;
}

@end

@implementation GridMovement

+ (id)sharedClass
{
    static GridMovement *sharedMyClass = nil;
    static dispatch_once_t onceToken;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    dispatch_once(&onceToken, ^{
        sharedMyClass = [[self alloc] initWithGridCount:GLKVector2Make(3.0, 3.0) deviceSize:screenRect.size planeSize:CGSizeMake(X_SCALE_FACTOR * 2, Y_SCALE_FACTOR * 2)];
    });
    
    return sharedMyClass;
}

- (id)initWithGridCount:(GLKVector2)count deviceSize:(CGSize)deviceSize planeSize:(CGSize)planeSize
{
    if(self = [super init])
    {
        _planeSize = planeSize;
        _gridCount = count;
        _deviceSize = deviceSize;
        _cellDeviceSize.width  = deviceSize.width / _gridCount.x;
        _cellDeviceSize.height = deviceSize.height / _gridCount.y;
        
        _cellPlaneSize.width  = planeSize.width / _gridCount.x;
        _cellPlaneSize.height = planeSize.height / _gridCount.y;
        _playerQuadrant = GridQuadrantBottom;
        [self calculateCellsCenter];
    }
    
    return self;
}

- (void)calculateCellsCenter
{
    int cellCount = _gridCount.x * _gridCount.y;
    cellArray = calloc(cellCount+1, sizeof(GLKVector2)); // First index will be (0, 0)
    
    float x;
    float y;
    
    // Fills each element after 0 with world positions based on the Plane size
    for (int i = 0; i < _gridCount.y; i++)
    {
        for (int j = 1; j <= _gridCount.x; j++)
        {
            x = (j) * _cellPlaneSize.width - _cellPlaneSize.width / 2 - _planeSize.width / 2;
            y = (i + 1) * _cellPlaneSize.height - _cellPlaneSize.height / 2 - _planeSize.height / 2;
            cellArray[i * (int)_gridCount.x + j] = GLKVector2Make(x, y);
        }
    }
}

- (void)debugLoop {
    
    for (int i = 1; i < GLKVector2Length(_gridCount); i++)
    {
        NSLog(@"Array Index[%i]: %f, %f", i, cellArray[i].x, cellArray[i].y);
    }
}

- (void)dealloc
{
    free(cellArray);
}

- (GLKVector3)getGridLocation:(GridQuadrant)quadrant
{
    GLKVector2 gridLocation = cellArray[quadrant];
    
    return GLKVector3Make(gridLocation.x, gridLocation.y, 0);
}

- (GLKVector2)gridLocationWithMoveDirection:(GLKVector2)moveDirection
{
    if (moveDirection.y < 0)
    {
        // DownLeft
        if (moveDirection.x < 0 && (_playerQuadrant % 3 != 1) && _playerQuadrant > GridQuadrantBottomRight)
        {
            _playerQuadrant += (int)moveDirection.y * 3;
            _playerQuadrant--;
            return cellArray[_playerQuadrant];
        }
        
        // DownRight
        if (moveDirection.x > 0 && (_playerQuadrant % 3 != 0) && _playerQuadrant > GridQuadrantBottomRight)
        {
            _playerQuadrant += (int)moveDirection.y * 3;
            _playerQuadrant++;
            return cellArray[_playerQuadrant];
        }
        
        // Down
        if (_playerQuadrant > GridQuadrantBottomRight)
        {
            _playerQuadrant += (int)moveDirection.y * 3;
            return cellArray[_playerQuadrant];
        }
    }
    else if (moveDirection.y > 0)
    {
        // UpLeft
        if (moveDirection.x < 0 && (_playerQuadrant % 3 != 1) && _playerQuadrant < GridQuadrantTopLeft)
        {
            _playerQuadrant += (int)moveDirection.y * 3;
            _playerQuadrant--;
            return cellArray[_playerQuadrant];
        }
        
        // UpRight
        if (moveDirection.x > 0 && (_playerQuadrant % 3 != 0) && _playerQuadrant < GridQuadrantTopLeft)
        {
            _playerQuadrant += (int)moveDirection.y * 3;
            _playerQuadrant++;
            return cellArray[_playerQuadrant];
        }
        
        // Up
        if (_playerQuadrant < GridQuadrantTopLeft)
        {
            _playerQuadrant += (int)moveDirection.y * 3;
            return cellArray[_playerQuadrant];
        }
    }
    else
    {
        // Left
        if (moveDirection.x < 0 && (_playerQuadrant % 3 != 1))
        {
            _playerQuadrant--;
            return cellArray[_playerQuadrant];
        }
        
        // Right
        if (moveDirection.x > 0 && (_playerQuadrant % 3 != 0))
        {
            _playerQuadrant++;
            return cellArray[_playerQuadrant];
        }
    }
    
    return cellArray[_playerQuadrant];
}

- (GLKVector2)gridLocationWithGridQuadrant:(GridQuadrant)quadrant
{
    _playerQuadrant = quadrant;
    return cellArray[_playerQuadrant];
}

- (GLKVector2)gridLocation:(GLKVector2)screenLocation
{
    int x = (int)(screenLocation.x / _cellDeviceSize.width);
    int y = (int)(screenLocation.y / _cellDeviceSize.height);

    return cellArray[3 * y + x + 1];
}

@end
