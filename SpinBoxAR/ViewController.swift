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
        addTapGestureToSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARWorldTrackingConfiguration()
            config.planeDetection = .horizontal
        myCanvas.session.run(config)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        myCanvas.session.pause()
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        myCanvas.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func createBOX(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        let box = SCNBox(width: 0.10, height: 0.10, length: 0.10, chamferRadius: 0)
        let colors = [UIColor.random(), UIColor.random(), UIColor.random(), UIColor.random(), UIColor.random(), UIColor.random()]
        print(UIColor.random())
        let boxMaterials = colors.map({ (colors) -> SCNMaterial in
            let material = SCNMaterial()
                material.diffuse.contents = colors
            return material
            }
        )
        box.materials = boxMaterials
        
        let randomDuration = Double.random(in: 3...7)
        
        let rotateOnce = SCNAction.rotateBy(x: 0, y: 2*CGFloat.pi, z: 0, duration: randomDuration)
        let rotateForever = SCNAction.repeatForever(rotateOnce)
        let boxNode = SCNNode(geometry: box)
            boxNode.geometry = box
            boxNode.position = SCNVector3(x, y, z)
            boxNode.runAction(rotateForever)
        
        myCanvas.scene.rootNode.addChildNode(boxNode)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: myCanvas)
        let hitTestResults = myCanvas.hitTest(tapLocation)
       
        guard let node = hitTestResults.first?.node else {
            let hitTestResultsWithFeaturePoints = myCanvas.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                createBOX(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }
}

extension float4x4 {
    var translation: SIMD3<Float> {
        let translation = self.columns.3
        return SIMD3(translation.x, translation.y, translation.z)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1), alpha: 1.0)
    }
}
