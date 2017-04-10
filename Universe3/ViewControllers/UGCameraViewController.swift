//
//  UGCameraViewController.swift
//  Universe3
//
//  Created by Anton Rogachevskiy on 09/04/2017.
//  Copyright © 2017 Anton Rogachevskyi. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class UGCameraViewController: UGSceneViewController, SCNSceneRendererDelegate {

    var cameraOrbit:SCNNode? = nil
    var cameraParentNode:SCNNode? = nil
    var camera:SCNCamera? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Camera config
        camera = SCNCamera()
        camera!.usesOrthographicProjection = true
        camera!.orthographicScale = 12
        camera!.zNear = 0.01
        camera!.zFar = 1000
        camera!.xFov = 60
        camera!.yFov  = 60
        
        let cameraNode = SCNNode()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 200)
        cameraNode.camera = camera
        
        cameraOrbit = SCNNode()
        cameraOrbit!.addChildNode(cameraNode)
        sceneView.scene!.rootNode.addChildNode(cameraOrbit!)

        sceneView.pointOfView = cameraNode
        
        // rotate it (I've left out some animation code here to show just the rotation)
        cameraOrbit!.eulerAngles.x = cameraOrbit!.eulerAngles.x - Float(Double.pi/4)
        cameraOrbit!.eulerAngles.y = cameraOrbit!.eulerAngles.y - Float(Double.pi/4*3)
        
        sceneView.delegate = self
        
        // Gestures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        let panGuester = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sceneView.addGestureRecognizer(panGuester)
        
        let pinchGuester = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        sceneView.addGestureRecognizer(pinchGuester)
        
        
    }
    
    func showNode(node: SCNNode) {
        // Move camera sphere to node
        cameraOrbit?.runAction(SCNAction.move(to: node.position, duration: 0.2), completionHandler: {
            self.cameraParentNode = node
        })
        
//        if node == sphere {
//            camera!.orthographicScale = 50
//        } else {
//            camera!.orthographicScale = 9
//        }
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            let result: AnyObject = hitResults[0]
            
            if result.node != nil {
                let node = result.node!
                showNode(node: node)
            }
        }
    }
    
    func handlePan(_ gestureRecognize: UIGestureRecognizer) {
        let gester = gestureRecognize as! UIPanGestureRecognizer
        let v = gester.velocity(in: self.view)
        cameraOrbit!.eulerAngles.x = cameraOrbit!.eulerAngles.x - Float(v.y / 1000)
        cameraOrbit!.eulerAngles.y = cameraOrbit!.eulerAngles.y - Float(v.x / 1000)
    }
    
    func handlePinch(_ gestureRecognize: UIGestureRecognizer) {
        let gesture = gestureRecognize as! UIPinchGestureRecognizer
        camera!.orthographicScale = camera!.orthographicScale - Double(gesture.velocity / 5)
        
        var minScale = 5.0
        if cameraParentNode != nil {
            minScale = Double(cameraParentNode!.boundingBox.max.x / 2)
        }
        
        camera!.orthographicScale = max(camera!.orthographicScale, minScale)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if cameraParentNode != nil {
            cameraOrbit?.position = (cameraParentNode?.presentation.position)!
        }
    }

    
}
