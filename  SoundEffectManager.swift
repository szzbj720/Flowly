import AVFoundation
import SwiftUI

class SoundEffectManager {
    static let shared = SoundEffectManager()
    
    func playSoundEffect(named soundName: String, fileType: String = "mp3") {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: fileType) else {
            print("Sound effect \(soundName).\(fileType) not found.")
            return
        }
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
}
