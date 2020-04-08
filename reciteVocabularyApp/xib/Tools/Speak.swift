import AVFoundation
import Cocoa

class Speak: NSObject {

    let voices = AVSpeechSynthesisVoice.speechVoices()
    let voiceSynth = AVSpeechSynthesizer()
    var voiceToUse: AVSpeechSynthesisVoice?

    static let share = Speak()
    
    override init(){
        super.init()
        voiceSynth.delegate = self
        // 后台播放
        //try? AVAudioSession.sharedInstance().setCategory(.playback)
        for voice in voices {
            if voice.language == "en-GB" {
                voiceToUse = voice
            }
            if voice.language == "en-GB" && voice.quality == .default {
                voiceToUse = voice
            }
        }
    }

    func play(_ phrase: String) {
      let utterance = AVSpeechUtterance(string: phrase)
          utterance.voice = voiceToUse
          utterance.rate = 0.4
        voiceSynth.speak(utterance)
    }
    
    func stop() {
        if voiceSynth.isSpeaking {
            voiceSynth.stopSpeaking(at: .immediate)
        }
    }
    
    func pause() {
        if voiceSynth.isSpeaking {
            voiceSynth.pauseSpeaking(at: .word)
        }
    }
    
    func `continue`() {
        voiceSynth.continueSpeaking()
    }
    
}

extension Speak: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {

    }
}
