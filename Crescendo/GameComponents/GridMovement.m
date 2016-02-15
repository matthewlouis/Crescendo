//
//  GridMovement.m
//  Crescendo
//
//  Created by Steven Chen on 2016-02-11.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "GridMovement.h"

@interface GridMovement ()
{
    GLKVector2 _frameSize;
    GLKVector2 _cellSize;
    GLKVector2 _gridCount;
    GLKVector2 *cellArray;
}

@end

@implementation GridMovement

- (id)initWithGridCount:(GLKVector2)count Size:(GLKVector2)size
{
    if(self = [super init])
    {
        _gridCount = count;
        _frameSize = size;
        _cellSize.x = size.x / _gridCount.x;
        _cellSize.y = size.y / _gridCount.y;
        [self calculateCellsCenter];
    }
    
    return self;
}

- (void)calculateCellsCenter
{
    int cellCount = _gridCount.x * _gridCount.y;
    cellArray = calloc(cellCount+1, sizeof(GLKVector2));
    
    float x;
    float y;
    
    for (int i = 0; i < _gridCount.y; i++)
    {
        for (int j = 1; j <= _gridCount.x; j++)
        {
            x = (j) * _cellSize.x - _cellSize.x / 2;
            y = (i + 1) * _cellSize.y - _cellSize.y / 2;
            cellArray[i * (int)_gridCount.x + j] = GLKVector2Make(x, y);
        }
    }
}

- (void)debugLoop {
    
    for (int i = 0; i < GLKVector2Length(_gridCount); i++)
    {
        NSLog(@"Array Index: %f, %f", cellArray[i].x, cellArray[i].y);
    }
}

- (void)dealloc
{
    free(cellArray);
}

- (GLKVector2)getGridLocation:(GLKVector2)screenLocation
{
    int x = (int)(screenLocation.x / _cellSize.x);
    int y = (int)(screenLocation.y / _cellSize.y);
 
    NSLog(@"Accessing Array Index: %i", 3 * y + x + 1);
    NSLog(@"Array Index: %f, %f", cellArray[3 * y + x + 1].x, cellArray[3 * y + x + 1].y);

    return cellArray[3 * y + x + 1];
}

@end
