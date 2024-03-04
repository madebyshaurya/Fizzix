import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String, volume: Float, loop: Int) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.volume = volume
            audioPlayer?.numberOfLoops = loop
            audioPlayer?.play()
        } catch {
            print("ERROR: Couldn't find and play the sound file!")
        }
    }
}

func stopSounds() {
    audioPlayer?.stop()
}

