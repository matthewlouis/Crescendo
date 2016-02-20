//
//  Bar.h
//  Crescendo
//
//  Created by Sean Wang on 2016-02-19.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#ifndef Bar_h
#define Bar_h

#import "GameObject3D.h"
#import "Plane.h"

@interface Bar : GameObject3D
{
    @public NSMutableArray *m_Planes;
}

-(void)CreatePlane;
-(Plane*)GetPlane;

@end

#endif /* Bar_h */
