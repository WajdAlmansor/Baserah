import SwiftUI

struct CameraPage: View {
    @StateObject private var cameraManager = CameraManager()

    var body: some View {
        ZStack {

            CameraPreview(session: cameraManager.session)
                .ignoresSafeArea(.all)

            VStack {
                Spacer().frame(height: 50)
                
                HStack {
                    Spacer()

                    VStack(spacing: 20) {
                    
                        Button(action: {
                            print("الزر الأول مضغوط")
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.8))
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "person.crop.circle.badge.minus")
                                    .font(.system(size: 24))
                                    .foregroundColor(.black)
                            }
                        }
                        
                    }
                    .padding(.trailing, 20)
                }
                
                Spacer()
                
                Button(action: {
                    cameraManager.resetDetection()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .stroke(Color.black, lineWidth: 2)
                            .frame(width: 60, height: 60)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            cameraManager.startSession()
        }
        .onDisappear {
            cameraManager.stopSession()
        }
    }
}
