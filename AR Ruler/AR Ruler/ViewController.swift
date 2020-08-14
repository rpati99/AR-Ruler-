//
//  ViewController.swift
//  AR Ruler
//
//  Created by MacBook Pro on 12/05/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!

    var dotnodes = [SCNNode]()
        var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotnodes.count >= 2 {
            for dot in dotnodes {
                dot.removeFromParentNode()
            }
            dotnodes = [SCNNode]()
        }
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first {
                addDot(at: hitResult)
            }
            
        }
    }
    
    func addDot(at hitResult: ARHitTestResult) {
        let dotgeometry = SCNSphere(radius: 0.005)
        
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.blue
        dotgeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotgeometry)
        
        dotNode.position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y,
            hitResult.worldTransform.columns.3.z
        )
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotnodes.append(dotNode)
        
        if dotnodes.count >= 2 {
            calculate()
        }
        
    }
    
    func calculate() {
        let start = dotnodes[0]
        let end = dotnodes[1]
        
        print(start.position)
        print(end.position)
        
        let distance = sqrt(
            pow( end.position.x - start.position.x, 2) +
            pow( end.position.y - start.position.y, 2) +
            pow( end.position.z - start.position.z, 2)
        )
        
        updateText(text: "\(abs(distance))", atPosition: end.position)
        
    }
    
    func updateText(text: String, atPosition: SCNVector3) {
        
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
    textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(atPosition.x, atPosition.y + 0.01 , atPosition.z)
        
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    
    
}
