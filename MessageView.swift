//
//  MessageView.swift
//  Crescendo
//
//  Displays Messages/Titles/Insults on screen
//
//  Created by Matthew Moldowan on 2016-02-20.
//  Copyright © 2016 Equalizer. All rights reserved.
//

import UIKit
import SceneKit


let DEFAULT_FONT:UIFont = UIFont(name: "Asenine", size: 20)!
let part = SCNParticleSystem()
let fontMaterial = SCNMaterial()
internal var messageDisplayed:Bool = false


var currentMessage:SCNNode?

class MessageView: SCNView {
    
    var gameOver = false;
    
    var background:SCNPlane?
    var backgroundNode:SCNNode?
    
    required init?(coder aDecoder: NSCoder) {
        
        fontMaterial.specular.contents = UIColor.grayColor()
        fontMaterial.shininess = 0.99
        fontMaterial.diffuse.contents = UIColor.redColor()
        
        super.init(coder: aDecoder)
        sceneSetup()
        
        background = SCNPlane(width: self.bounds.width, height: self.bounds.height)
        background?.materials[0].diffuse.contents = UIColor.clearColor()
        backgroundNode = SCNNode(geometry: background)
    }
    
    @objc func sceneSetup() {
        // 1
        let scene = SCNScene()
        
        part.loops = false
        part.birthDirection = .SurfaceNormal
        part.birthLocation = .Vertex
        part.birthRate = 200
        part.emissionDuration = 0.5
        part.spreadingAngle = 20
        part.particleDiesOnCollision = true
        part.particleLifeSpan = 0.5
        part.particleLifeSpanVariation = 0.3
        part.particleVelocity = 100
        part.particleVelocityVariation = 3
        part.particleSize = 0.5
        part.stretchFactor = 0.25
        part.lightingEnabled = true
        part.particleColor = UIColor.redColor()
        
        
        // 3
        self.scene = scene
        
        self.autoenablesDefaultLighting = true
        self.backgroundColor = UIColor.clearColor()
}
    
    func messageConfirmed(){
        if(gameOver){
            let materials = (currentMessage!.geometry?.materials)! as [SCNMaterial]
            let material = materials[0]
            
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(1)
            SCNTransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
            background!.materials[0].diffuse.contents = UIColor.clearColor()
            material.diffuse.contents = UIColor.clearColor()
            SCNTransaction.commit()
            gameOver = false
            
        }else{
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(1)
            let materials = (currentMessage!.geometry?.materials)! as [SCNMaterial]
            let material = materials[0]
            material.diffuse.contents = UIColor.clearColor()
            SCNTransaction.commit()
            
            let action = SCNAction.moveByX(0, y: 0, z: 100, duration: 2)
            
            part.reset()
            part.emitterShape = currentMessage?.geometry;
            self.scene!.addParticleSystem(part, withTransform: SCNMatrix4MakeRotation(0, 0, 0, 0))
            currentMessage?.runAction(action)
        }
        messageDisplayed = false
    }
    
    func stringToSCNNode(string: String, position:SCNVector3, transform:SCNVector3 = SCNVector3.init())->SCNNode{
        
        //create text and set properties
        let text = SCNText(string: string, extrusionDepth: 4)
        text.font = DEFAULT_FONT
        text.flatness = 0.2
        text.materials = [fontMaterial]
        
        //place and return node
        let node = SCNNode(geometry: text)
        node.position = position
        
        return node
    }
    
    func displayTitle(){
        currentMessage = stringToSCNNode("Crescendo",   position:SCNVector3(0,0,0))
        
        scene!.rootNode.addChildNode(currentMessage!)
        messageDisplayed = true;
        
        let move1 = SCNAction.moveByX(0, y: CGFloat(0.2), z: 0.0, duration: 0.1)
        let move2 = SCNAction.moveByX(0, y: CGFloat(-0.2), z: 0.0, duration: 0.1)
        let sequence = SCNAction.sequence([move1,move2])
        let repeatedSequence = SCNAction.repeatActionForever(sequence)
        currentMessage?.runAction(repeatedSequence)
    }
    
    func displayGameOver(score: CLong, highscore:CLong){
        
        currentMessage?.removeFromParentNode()
        
        currentMessage = stringToSCNNode("Finé. " + String(score) + "\nPreviously " + String(highscore),   position:SCNVector3(0,0,0))
        
        scene!.rootNode.addChildNode(backgroundNode!)
        scene!.rootNode.addChildNode(currentMessage!)
        
        messageDisplayed = true;
        
        let move1 = SCNAction.moveByX(0, y: CGFloat(0.2), z: 0.0, duration: 1)
        let move2 = SCNAction.moveByX(0, y: CGFloat(-0.2), z: 0.0, duration: 1)
        let sequence = SCNAction.sequence([move1,move2])
        let repeatedSequence = SCNAction.repeatActionForever(sequence)
        currentMessage?.runAction(repeatedSequence)
        
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.5)
        SCNTransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
        
        let materials = (currentMessage!.geometry?.materials)! as [SCNMaterial]
        let material = materials[0]
        material.diffuse.contents = UIColor.whiteColor()
        background!.materials[0].diffuse.contents = UIColor.blackColor()
        SCNTransaction.commit()
        gameOver = true;
    }
    
    func messageIsDisplayed()->Bool{
        return messageDisplayed
    }
    
    func cleanUp(){
        scene = nil
        currentMessage = nil
        gameOver = false;
        messageDisplayed = false;
    }
}
