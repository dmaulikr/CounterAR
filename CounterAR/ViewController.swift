//
//  ViewController.swift
//  CounterAR
//
//  Created by Zsolt Pete on 2017. 08. 04..
//  Copyright © 2017. Zsolt Pete. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var numberNode: SCNNode = SCNNode()
    var numberGeomerty: SCNText = SCNText()
    var timer = Timer()
    var actualNumber: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        self.perform(#selector(startContDown), with: nil, afterDelay: 3.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc func startContDown(){
        self.countDown(number: 100)
    }
    
    func countDown(number: Int){
        if number > 0 {
            self.actualNumber = number
            self.initNumberNode(string: "\(actualNumber)")
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.bringNode), userInfo: nil, repeats: true)
            
            
        }
    }
    
    func initNumberNode(string: String){
        self.numberGeomerty = SCNText(string: string, extrusionDepth: 1.0)
        numberGeomerty.firstMaterial?.diffuse.contents = UIColor.red
        
        self.numberNode = SCNNode(geometry: numberGeomerty)
        self.numberNodeGoStartPosition()
        self.numberNode.scale = SCNVector3(0.05, 0.05, 0.05)
        
        self.sceneView.scene.rootNode.addChildNode(numberNode)
    }
    
    @objc func bringNode(){
        var zCoordinate = self.numberNode.position.z
        self.numberNode.position.z += 0.05
        zCoordinate = self.numberNode.position.z
        if zCoordinate >= 0 {
            self.actualNumber -= 1
            self.decreaseNumberNode()
            self.numberNodeGoStartPosition()
        }
        if self.actualNumber <= 0 {
            timer.invalidate()
            self.numberGeomerty.string = "Go"
        }
    }
    
    func decreaseNumberNode(){
        self.numberGeomerty.string = "\(self.actualNumber)"
    }
    
    func numberNodeGoStartPosition(){
        self.numberNode.position = SCNVector3(x: -0.2, y: -0.2, z: -3.5)
    }
}
