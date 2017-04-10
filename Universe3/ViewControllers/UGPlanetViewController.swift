//
//  UGPlanetViewController.swift
//  Universe3
//
//  Created by Anton Rogachevskiy on 25/01/2017.
//  Copyright © 2017 Anton Rogachevskyi. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class UGPlanetViewController: UGCameraViewController {
    
    var planet: SCNNode? = nil;
    var moon: SCNNode? = nil;
    var satelliteList = [SCNNode]()
    
    override func viewDidLoad() {
        sceneView.scene = SCNScene(named: "art.scnassets/planet.scn")

        super.viewDidLoad()

        // planet
        planet = sceneView.scene!.rootNode.childNode(withName: "planet", recursively: true)!
        planet!.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Diffuse")
        planet!.geometry?.firstMaterial?.specular.contents = UIImage(named: "Specular")
        planet!.geometry?.firstMaterial?.normal.contents = UIImage(named: "Normal")
        planet!.physicsBody?.mass = 5.97219e24
        
        // moon
        moon = sceneView.scene!.rootNode.childNode(withName: "moon", recursively: true)!
        moon!.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "moonmap4k")
        moon!.geometry?.firstMaterial?.normal.contents = UIImage(named: "moonbump4k")
        moon!.physicsBody?.mass = 7.3477e22
        
        // satellite
        let satellite = sceneView.scene!.rootNode.childNode(withName: "satellite", recursively: true)!
        satellite.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "uhf-map")
        satellite.geometry?.firstMaterial?.normal.contents = UIImage(named: "uhf-bump")
        satellite.physicsBody?.mass = 11_110
        satellite.physicsBody?.applyForce(SCNVector3Make(0, -8700.3, 0), asImpulse: true)
        
        satelliteList.append(satellite)
        
        sceneView.scene!.background.contents = ["skyboxRT", "skyboxLF", "skyboxUP", "skyboxDN", "skyboxBK", "skyboxFT"]
        

        // animate the 3d object
        //planet.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 100)))
        //moon.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: -1, z: 0, duration: 100)))
        
        
//        // add a tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        scnView.addGestureRecognizer(tapGesture)
        
//        scnView.debugOptions = [.showPhysicsShapes, .showPhysicsFields, .showLightExtents, .showLightInfluences]
        
//        let xa = Float( sin(GLKMathDegreesToRadians(60.0)) )
//        let ya = Float( cos(GLKMathDegreesToRadians(60.0)) )
//        let za = Float(0);//Float( tan(GLKMathDegreesToRadians(40.0)) )
//        addObject(pos: SCNVector3Make(xa, ya, za), to:planet)
        
        //let robotStare = SCNLookAtConstraint.init(target: satellite)
        //cameraNode.constraints = [robotStare]
        
        var _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showPath), userInfo: nil, repeats: true);

    }
    
    func showPath() {
        let sat = sceneView.scene?.rootNode.childNode(withName: "satellite", recursively: true)
        let planet = sceneView.scene?.rootNode.childNode(withName: "planet", recursively: true)
        
        let distance = sat?.presentation.position.distance(receiver: (planet?.presentation.position)!)
        log.info(distance ?? "NaN")
        
        addObject(pos: (sat?.presentation.position)!, to: (sceneView.scene?.rootNode)!)
    }
    
//    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
//        // retrieve the SCNView
//        let scnView = self.view as! SCNView
//        
//        // check what nodes are tapped
//        let p = gestureRecognize.location(in: scnView)
//        let hitResults = scnView.hitTest(p, options: [:])
//        // check that we clicked on at least one object
//        if hitResults.count > 0 {
//            // retrieved the first clicked object
//            let result: AnyObject = hitResults[0]
//            
//            let loc = result.localCoordinates
//            
//            addObject(pos: loc!, to:result.node!)
//            
////            let robotStare = SCNLookAtConstraint.init(target: result.node)
////            let cameraNode = scnView.scene?.rootNode.childNode(withName: "camera", recursively: true)!
////            cameraNode?.constraints = nil
////            cameraNode?.constraints = [robotStare]
////            
//            return
//            
//            // get its material
//            let material = result.node!.geometry!.firstMaterial!
//            
//            // highlight it
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 0.5
//            
//            // on completion - unhighlight
//            SCNTransaction.completionBlock = {
//                SCNTransaction.begin()
//                SCNTransaction.animationDuration = 0.5
//                
//                material.emission.contents = UIColor.black
//                
//                SCNTransaction.commit()
//            }
//            
//            material.emission.contents = UIColor.white
//            
//            SCNTransaction.commit()
//        }
//        
//    }
    
    
    func addAntenna(pos: SCNVector3, to: SCNNode) {
        
        let buildings = SCNScene(named: "art.scnassets/buildings.scn")
        let antenna = buildings?.rootNode.childNode(withName: "antenna", recursively: true)!.copy() as! SCNNode
        
        antenna.position = pos
        antenna.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "uhf-foil_5")
        antenna.geometry?.firstMaterial?.normal.contents = UIImage(named: "uhf-foil_5")
        
        let (min, max) = antenna.boundingBox
        log.info(min)
        log.info(max)
        
        to.addChildNode(antenna)
    }
    
    
    func addObject(pos: SCNVector3, to: SCNNode) {
        // object
        
        let radius = Float(0.01)
        
        let objectSph = SCNSphere(radius: CGFloat(radius))
        let object = SCNNode(geometry: objectSph)
        let position = SCNVector3Make(pos.x + radius*pos.x , pos.y + radius*pos.y, pos.z + radius*pos.z)
        
        object.position = position
        object.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        to.addChildNode(object)
    }
    
    
    @IBAction func showSatellite(_ sender: Any) {
        showNode(node: satelliteList.first!)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
