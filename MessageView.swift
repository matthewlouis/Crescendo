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


let DEFAULT_FONT:UIFont = UIFont(name: "Acknowledge TT (BRK)", size: 20)!
let part = SCNParticleSystem()
let fontMaterial = SCNMaterial()
internal var messageDisplayed:Bool = false


var currentMessage:SCNNode?

class MessageView: NSObject {
    
    var gameOver = false;
    var scene:SCNScene?;
    
    var background:SCNPlane?
    var backgroundNode:SCNNode?
    var mainLight:SCNLight;
    
    let trail = SCNParticleSystem()
    let trailEmitter = SCNNode(geometry: SCNBox(width: 1000, height: 1000, length: 100, chamferRadius: 0))
    
    let backdrop = SCNParticleSystem()
    let backEmitter = SCNNode(geometry: SCNBox(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height, length: 100, chamferRadius: 0))
    
    override init(){
        mainLight = SCNLight()
        mainLight.type = SCNLightTypeDirectional
        
        super.init()
        
        fontMaterial.specular.contents = UIColor.grayColor()
        fontMaterial.shininess = 0.99
        
        fontMaterial.diffuse.contents = UIColor(colorLiteralRed: Theme.messageColor.r, green: Theme.messageColor.g, blue: Theme.messageColor.b, alpha: Theme.messageColor.a)
        
        //super.init(coder: aDecoder)
        sceneSetup()
        
        background = SCNPlane(width: 1000, height: 1000)
        background?.materials[0].diffuse.contents = UIColor.clearColor()
        backgroundNode = SCNNode(geometry: background)
        
        
    }
    
    @objc func sceneSetup() {
        // 1
        //trailEmitter.light = mainLight
        let scene = SCNScene()

        part.loops = false
        part.birthDirection = .SurfaceNormal
        part.birthLocation = .Vertex
        part.birthRate = 15
        part.emissionDuration = 0.001
        part.spreadingAngle = 20
        part.particleDiesOnCollision = true
        part.particleLifeSpan = 2.5
        part.particleLifeSpanVariation = 0.1
        part.particleVelocity = 50
        part.particleVelocityVariation = 5
        part.particleSize = 0.5
        part.stretchFactor = 0.0
        part.blendMode = .Alpha
        
        part.lightingEnabled = false
        part.particleColor = UIColor(colorLiteralRed: Theme.messageColor.r, green: Theme.messageColor.g, blue: Theme.messageColor.b, alpha: Theme.messageColor.a)
        
        // 3
        self.scene = scene
        
}
    
    func messageConfirmed(){
        messageDisplayed = false
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
            SCNTransaction.setAnimationDuration(4)
            let materials = (currentMessage!.geometry?.materials)! as [SCNMaterial]
            let material = materials[0]
            material.diffuse.contents = UIColor.clearColor()
            material.blendMode = SCNBlendMode.Alpha
            SCNTransaction.commit()
            
            let action = SCNAction.moveByX(0, y: 0, z: 100, duration: 4)
            currentMessage?.runAction(action)
            
            /*part.emitterShape = currentMessage?.geometry;
            part.blendMode = .Alpha
            self.scene!.addParticleSystem(part, withTransform: SCNMatrix4Identity)*/
        }
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
        currentMessage!.light = mainLight
        
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
        
        currentMessage = stringToSCNNode("Finé. " + String(score) + "\nBest " + String(highscore),   position:SCNVector3(0,0,0))
        
        currentMessage?.light = mainLight
        
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
        
        material.diffuse.contents = UIColor(colorLiteralRed: Theme.gameOverFontColor.r, green: Theme.gameOverFontColor.g, blue: Theme.gameOverFontColor.b, alpha: Theme.gameOverFontColor.a)
        
        backgroundNode?.geometry!.materials[0].diffuse.contents = UIColor(colorLiteralRed: Theme.gameOverScreenColor.r, green: Theme.gameOverScreenColor.g, blue: Theme.gameOverScreenColor.b, alpha: Theme.gameOverScreenColor.a)
        SCNTransaction.commit()
        gameOver = true;
    }
    
    func messageIsDisplayed()->Bool{
        return messageDisplayed
    }
    
    func cleanUp(){
        currentMessage = nil
        gameOver = false;
        messageDisplayed = false;
    }
    
    func trail(position:GLKMatrix4){
       // trail.blendMode = .Alpha
        //self.scene!.addParticleSystem(trail, withTransform: trailEmitter.transform)
    }
}
