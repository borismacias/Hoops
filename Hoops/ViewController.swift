//
//  ViewController.swift
//  Hoops
//
//  Created by Boris Alexis Gonzalez Macias on 11/26/17.
//  Copyright © 2017 Boris Alexis Gonzalez Macias. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var planeDetectedLabel: UILabel!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.autoenablesDefaultLighting = true
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        guard let sceneView = sender.view as? ARSCNView else { return }
        let touchLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResults.isEmpty{
            self.addBasket(hitTestResult: hitTestResults.first!)
        }
    }
    
    func addBasket(hitTestResult: ARHitTestResult){
        let basketScene = SCNScene(named: "Basketball.scnassets/Basketball.scn")
        let basketNode = (basketScene?.rootNode.childNode(withName: "Basket", recursively: false))!
        let positionOfPlane = hitTestResult.worldTransform.columns.3
        basketNode.position = SCNVector3(positionOfPlane.x, positionOfPlane.y, positionOfPlane.z)
        self.sceneView.scene.rootNode.addChildNode(basketNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        DispatchQueue.main.async {
            self.planeDetectedLabel.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.planeDetectedLabel.isHidden = true
        }
    }
}

