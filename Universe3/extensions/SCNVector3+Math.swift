//
//  SCNVector3+Math.swift
//  Universe3
//
//  Created by Anton Rogachevskiy on 30/01/2017.
//  Copyright © 2017 Anton Rogachevskyi. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    func distance(receiver:SCNVector3) -> Float{
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
    
    
    
}
