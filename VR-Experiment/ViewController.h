//
//  ViewController.h
//  VR-Experiment
//
//  Created by Tim Carlson on 12/11/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <CoreMotion/CoreMotion.h>
#import "TCCardboardMagneticSensor.h"

@interface ViewController : UIViewController <TCCardboardMagneticSensorDelegate>

@property (nonatomic) IBOutlet SCNView *leftSceneView;
@property (nonatomic) IBOutlet SCNView *rightSceneView;

@end

