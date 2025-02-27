import SwiftUI
import AVFoundation

struct VoiceControlView: View {
    @State private var selectedVoice = "(ذكر - سعودي)"
    @State private var voices: [(String, String, Float, Float, Float)] = [
        ("(ذكر - سعودي)", "ar-SA", 0.5, 0.5, 1.0),
    ]
    
    @State private var volume: Double = 0.5
    @State private var speechRate: Double = 0.5
    @State private var pitch: Double = 1.0
    
    let speechSynthesizer = AVSpeechSynthesizer()
    @State private var debounceTimer: Timer?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("مرحباً بك إلى شاشة التحكم")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 150)
            
            RoundedRectangle(cornerRadius: 80)
                .fill(Color.white)
                .frame(width: 400, height: 750)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        Picker("اختر الصوت", selection: $selectedVoice) {
                            ForEach(voices, id: \.0) { voice in
                                Text(voice.0)
                            }
                        }
                        .padding(.top, -100)
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .onChange(of: selectedVoice) { _ in
                            applySelectedVoiceSettings()
                            speak()
                        }
                        
                        SliderView(title: "مستوى الصوت", value: $volume, range: 0...1, onRelease: speak)
                            .padding(.top, -40)
                            .padding(.bottom, 50)
                        SliderView(title: "سرعة النطق", value: $speechRate, range: 0.3...1.0, onRelease: speak)
                            .padding(.bottom, 50)
                        SliderView(title: "درجة الصوت", value: $pitch, range: 0.5...2.0, onRelease: speak)
                            .padding(.bottom, 100)
                        
                        Button(action: {
                            addNewVoice()
                        }) {
                            Text("إضافة صوت")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(20)
                                .padding(.horizontal, 40)
                        }
                    }
                    .padding()
                )
                .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(red: 0xDE / 255, green: 0xEB / 255, blue: 0xBB / 255))
        .edgesIgnoringSafeArea(.top)
    }
    
    func speak() {
        speechSynthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: "مرحباً! هذا هو الصوت المختار.")
        
        if let voiceCode = voices.first(where: { $0.0 == selectedVoice })?.1 {
            utterance.voice = AVSpeechSynthesisVoice(language: voiceCode)
        }
        
        utterance.volume = Float(volume)
        utterance.rate = Float(speechRate)
        utterance.pitchMultiplier = Float(pitch)
        
        speechSynthesizer.speak(utterance)
    }
    
    func applySelectedVoiceSettings() {
        if let selectedVoiceData = voices.first(where: { $0.0 == selectedVoice }) {
            volume = Double(selectedVoiceData.2)
            speechRate = Double(selectedVoiceData.3)
            pitch = Double(selectedVoiceData.4)
        }
    }
    
    func addNewVoice() {
        let baseName = selectedVoice.contains("سعودي") ? "سعودي" : "صوت"
        let newVoiceName = "\(baseName) \(voices.count + 1)"
        
        let newVoice = (newVoiceName, "ar-SA", Float(volume), Float(speechRate), Float(pitch))
        voices.append(newVoice)
        
        selectedVoice = newVoiceName
    }
}

struct SliderView: View {
    var title: String
    @Binding var value: Double
    var range: ClosedRange<Double>
    var onRelease: () -> Void
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Slider(value: $value, in: range, onEditingChanged: { editing in
                if !editing { onRelease() }
            })
            .accentColor(.orange)
        }
        .padding(.horizontal)
    }
}

struct VoiceControlView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceControlView()
    }
}
