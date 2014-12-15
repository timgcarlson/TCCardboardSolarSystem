//
//  TCVRCamera.h
//  VR-Experiment
//
//  Created by Tim Carlson on 12/14/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <CoreMotion/CoreMotion.h>

@interface TCVRCamera : NSObject


#pragma mark - Properties

/** The camera node that should be added to the scene.
 @abstract This is the base camera node that is built to support roll, pitch and yaw motions. This is the node you will add to your scene. It is the position of the "viewer" in the view.
 */
@property (nonatomic, readonly) SCNNode *camerasMotionNode;

/** The point of view for the left view (the left eye).
 @abstract Assign this node as the pointOfView for the left scene.
 */
@property (nonatomic, readonly) SCNNode *leftCameraNode;

/** The point of view for the left view (the left eye).
 @abstract Assign this node as the pointOfView for the right scene.
 */
@property (nonatomic, readonly) SCNNode *rightCameraNode;


#pragma mark - Instance Methods

/** Initializes a new TCVRCamera object.
 @param addCameraMotion Passing YES will begin camera motion immediately after creating the object.
 */
- (instancetype)initWithCameraMotion:(BOOL)addCameraMotion;

/** Starts camera-motion based on the device motion.
 @abstract This will run NOT run on the main operation queue.
 */
- (void)startCameraMotion;

/** Stops camera-motion based on the device motion.
 */
- (void)stopCameraMotion;

@end
