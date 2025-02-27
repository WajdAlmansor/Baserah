//import SwiftUI
//
//struct VoiceControlView: View {
//    @State private var selectedVoice = "(ذكر - سعودي)"
//    let voices = ["(ذكر - سعودي)", "(أنثى - سعودية)", "(ذكر - أمريكي)", "(أنثى - بريطانية)"]
//    
//    @State private var volume: Double = 0.5
//    @State private var speechRate: Double = 0.5
//    @State private var pitch: Double = 0.5
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            // Title
//            Text("مرحباً بك إلى شاشة التحكم")
//                .font(.title2)
//                .fontWeight(.bold)
//                .padding(.top, 180)
//            
//            // Rounded White Box
//            RoundedRectangle(cornerRadius: 80)
//                .fill(Color.white)
//                .frame(width: 400, height: 750)
//                .edgesIgnoringSafeArea(.all)
//                .overlay(
//                    VStack {
//                        // Dropdown Picker
//                        Picker("اختر الصوت", selection: $selectedVoice) {
//                            ForEach(voices, id: \.self) { voice in
//                                Text(voice)
//                            }
//                        }
//                        .pickerStyle(MenuPickerStyle())
//                        .foregroundColor(.blue)
//                        
//                        // Sliders with centered titles
//                        SliderView(title: "مستوى الصوت", value: $volume)
//                            .padding(.bottom, 50)
//                        SliderView(title: "سرعة النطق", value: $speechRate)
//                            .padding(.bottom, 50)
//                        SliderView(title: "درجة الصوت", value: $pitch)
//                            .padding(.bottom, 250)
//                        
//                        // Button
//                        Button(action: {
//                            print("صوت مضاف: \(selectedVoice)")
//                        }) {
//                            Text("إضافة صوت")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.orange)
//                                .cornerRadius(20)
//                                .padding(.horizontal, 40)
//                                .padding(.top, -150)
//                        }
//                    }
//                    .padding()
//                )
//                .padding(.horizontal)
//            
//            Spacer()
//        }
//        .background(Color(red: 0xDE / 255, green: 0xEB / 255, blue: 0xBB / 255))
//        .edgesIgnoringSafeArea(.top)
//    }
//}
//
//// Custom Slider View (✅ Fixed: Center Titles)
//struct SliderView: View {
//    var title: String
//    @Binding var value: Double
//    
//    var body: some View {
//        VStack {
//            // Center the title
//            Text(title)
//                .font(.headline)
//                .frame(maxWidth: .infinity, alignment: .center) // Forces center alignment
//            
//            // Normal slider
//            Slider(value: $value, in: 0...1)
//                .accentColor(.orange)
//        }
//    }
//}
//
//// Preview
//struct VoiceControlView_Previews: PreviewProvider {
//    static var previews: some View {
//        VoiceControlView()
//    }
//}
