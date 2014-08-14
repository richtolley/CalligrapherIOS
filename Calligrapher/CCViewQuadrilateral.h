//
//  CCViewQuadrilateral.h
//  Calligrapher
//
//  Created by Richard Tolley on 22/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface CCViewQuadrilateral : NSObject
@property CGPoint topLeft;
@property CGPoint topRight;
@property CGPoint bottomLeft;
@property CGPoint bottomRight;
@property (nonatomic,strong) NSString *key;
- (id)initWithTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br;
-(CGRect)boundingRect;
@end
