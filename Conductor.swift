//
//  Conductor.swift
//  AnalogSynthX
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import AudioKit

class Conductor: AKMIDIListener {
    /// Globally accessible singleton
    static let sharedInstance = Conductor()

    var core = CoreInstrument(voiceCount: 4)
    var bitCrusher: AKBitCrusher
    var fatten: Fatten
    var filterSection: FilterSection
    var multiDelay: MultiDelay
    var multiDelayMixer: AKDryWetMixer

    var masterVolume = AKMixer()
    var reverb: AKCostelloReverb
    var reverbMixer: AKDryWetMixer


    init() {
        bitCrusher = AKBitCrusher(core)
        bitCrusher.stop()

        filterSection = FilterSection(bitCrusher)
        filterSection.output.stop()

        fatten = Fatten(filterSection)
        multiDelay = MultiDelay(fatten)
        multiDelayMixer = AKDryWetMixer(fatten, multiDelay, balance: 0.0)

        masterVolume = AKMixer(multiDelayMixer)
        reverb = AKCostelloReverb(masterVolume)
        reverb.stop()

        reverbMixer = AKDryWetMixer(masterVolume, reverb, balance: 0.0)

        AudioKit.output = reverbMixer
        AudioKit.start()

        let midi = AKMIDI()
        midi.openMIDIIn("Session 1")
        midi.addListener(self)
    }
    
    func midiNoteOn(note: Int, velocity: Int, channel: Int) {
        core.playNote(note, velocity: velocity)
    }
    func midiNoteOff(note: Int, velocity: Int, channel: Int) {
        core.stopNote(note)
    }

}
