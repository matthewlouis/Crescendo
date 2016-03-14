//
//  SequenceReader.swift
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-03-14.
//  Copyright © 2016 Equalizer. All rights reserved.
//

import Foundation

class SequenceReader:NSObject{
    
    static func readFile(url: NSURL)->[MusicNoteSequence]{
        let whitespaceAndPunctuationSet = NSMutableCharacterSet.whitespaceAndNewlineCharacterSet()
        whitespaceAndPunctuationSet.formUnionWithCharacterSet(NSCharacterSet.punctuationCharacterSet())
        
        
        var sequences = [MusicNoteSequence]()
        
        
        let encoding = UnsafeMutablePointer<NSStringEncoding>();
        let fileData = try? String.init(contentsOfURL: url, usedEncoding: encoding);

        
        let separatedInfo:[String] = (fileData?.componentsSeparatedByString("\nEND"))!
        
        for seq in separatedInfo{
            if(seq.characters.count <= 0){
                break
            }
            
            let s = NSScanner.init(string: seq)
            s.charactersToBeSkipped = whitespaceAndPunctuationSet
            
            let sequence = MusicNoteSequence.init()
            sequence.track = Int(s.scanInt()!)   //get track
            sequence.seqLengthBars = Int(s.scanInt()!) //get sequence length
            
            let notes:[String] = (seq.componentsSeparatedByString("\n"))
            
            for note:NSString in notes{
                if(note.length > 0){
                    let note = s.scanInt()
                    let position = s.scanFloat()
                    let duration = s.scanFloat()
                    
                    s.scanInt() //skip seqlength
                    s.scanInt() //skip track
                    
                    sequence.addNote(Int(note!), position: position!, duration: duration!)
                }
            }
            
            sequences.append(sequence)
        }
        
        
        return sequences
    }
}