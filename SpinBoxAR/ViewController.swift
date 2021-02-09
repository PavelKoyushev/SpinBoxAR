//
//  ViewController.swift
//  SpinBoxAR
//
//  Created by Pavel Koyushev on 09.02.2021.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {
    @IBOutlet weak var myCanvas: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBOX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARWorldTrackingConfiguration()
        myCanvas.session.run(config)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        myCanvas.session.pause()
    }
    
    func createBOX() {
        let box = SCNBox(width: 0.10, height: 0.10, length: 0.10, chamferRadius: 0)
        let colors = [UIColor.blue, .cyan, .green, .magenta, .purple, .brown]
        
        let boxMaterials = colors.map({ (colors) -> SCNMaterial in
            let material = SCNMaterial()
                material.diffuse.contents = colors
            return material
            }
        )
        box.materials = boxMaterials
        
        let rotateOnce = SCNAction.rotateBy(x: 0, y: 2*CGFloat.pi, z: 0, duration: 3)
        let rotateForever = SCNAction.repeatForever(rotateOnce)
        
        let boxNode = SCNNode(geometry: box)
            boxNode.position = SCNVector3(0, 0, -0.5)
            boxNode.runAction(rotateForever)
        
        myCanvas.scene.rootNode.addChildNode(boxNode)
    }
}

