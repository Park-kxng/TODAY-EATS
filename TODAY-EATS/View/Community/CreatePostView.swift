//
//  CreatePostView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/12/24.
//

import Foundation
import SwiftUI

struct CreatePostView: View {
    // 이전 화면으로 돌아가기 위한 presentationMode 환경 변수
    @ObservedObject var viewModel = CommunityViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    // 초기화
    @State private var location: String = ""
    @State private var title: String = ""
    @State private var waitingTime: String = ""
    @State private var content: String = ""
    @State private var selectedImage: UIImage?
    @State private var rating: Int = 0
    @State private var rating2: Float = 0
    @State private var widthSize : CGFloat = 0
    
    @State private var isImagePickerDisplayed = false
    @State private var contentPlaceHolder: String = " 내용"
    init(){
        let locality : String = UserDefaults.standard.string(forKey: "locality") ?? ""
        let subLocality : String = UserDefaults.standard.string(forKey: "subLocality") ?? ""
        let administrativeArea : String = UserDefaults.standard.string(forKey: "administrativeArea") ?? ""
        print(administrativeArea)
        print(locality)
        print(subLocality)
    }
    // 별 모양을 생성하고 사용자 입력을 처리하는 함수
    private func StarButton(index: Int) -> some View {
        Button(action: {
            // 사용자가 탭한 별의 인덱스를 기반으로 rating 값을 업데이트
            self.rating = index
        }) {
            // 별 모양을 표시, 채워진 별 또는 빈 별을 조건부로 표시
            Image(index <= rating ? "star_fill" : "star_fill")
                .renderingMode(.template)
                .foregroundColor(index <= rating ? .teYellow : .teBlack.opacity(0.3))
        }
    }
    var body: some View {
        GeometryReader { geometry in
            VStack{
            ScrollView {
                // 사진 선택하기
                VStack{
                    
                    
                    Button(action: {
                        self.isImagePickerDisplayed.toggle()
                    }) {
                        if let selectedImage = selectedImage {
                            
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: 300) // width와 height를 같게 설정하여 정사각형 형태 유지
                                .clipped() // 이미지가 프레임을 넘어가지 않도록 자릅니다.
                            
                            
                        } else {
                            Spacer()
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30.0, height: 30.0)
                                .foregroundColor(Color.teTitleGray)
                            Spacer()
                            
                            
                        }
                    }
                    .frame( height: 300)
                    .background(Color.teLightGray)
                    
                    
                    HStack{
                        
                        Spacer()
                            .frame(width: 20.0)
                        
                        VStack(alignment: .leading) {
                            
                            Spacer()
                                .frame(height: 15)
                            Text("별점")
                                .font(.teFont12M())
                                .foregroundColor(Color.teMidGray)
                            HStack{
                                // 1부터 5까지의 별을 표시
                                Spacer()
                                ForEach(1...5, id: \.self) { index in
                                    StarButton(index: index)
                                }
                                Spacer()
                                
                            }
                            .frame(height: 30) // 텍스트필드의 높이를 설정합니다.
                            .padding(.all, 10)
                            .background(Color.teLightGray)
                            .cornerRadius(8)
                            Text("웨이팅")
                                .font(.teFont12M())
                                .foregroundColor(Color.teMidGray)
                            VStack{
                                Text("\(Int(rating2))분")
                                    .font(.teFont16R())
                                    .kerning(-0.2)
                                    .foregroundColor(Color.teBlack)
                                Spacer()
                                    .frame(height:-5)
                                HStack {
                                    Text("0분")
                                    Spacer().frame(width: 10)
                                    Slider(value: $rating2, in: 0...120, step: 10)            .accentColor(.teYellow) // 슬라이더의 색상을 녹색으로 변경
                                    Spacer().frame(width: 10)
                                    
                                    Text("120분")
                                }
                                
                            }
                            .frame(height: 50) // 텍스트필드의 높이를 설정합니다.
                            .padding(.all, 10)
                            .background(Color.teLightGray)
                            .cornerRadius(8)
                            .font(.teFont14R())
                            .kerning(-0.2)
                            .foregroundColor(Color.teMidGray)
                            Spacer()
                                .frame(height: 15)
                            Text("맛집 위치")
                                .font(.teFont12M())
                                .foregroundColor(Color.teMidGray)
                            TextField("위치", text: $location)
                                .frame(height: 30) // 텍스트필드의 높이를 설정합니다.
                                .padding(.all, 8.0)
                                .background(Color.teLightGray)
                                .cornerRadius(8)
                                .font(.teFont16R())
                                .kerning(-0.2)
                            
                            Spacer()
                                .frame(height: 15)
                            Text("투데이츠 제목")
                                .font(.teFont12M())
                                .foregroundColor(Color.teMidGray)
                            TextField("제목", text: $title)
                                .frame(height: 30) // 텍스트필드의 높이를 설정합니다.
                                .padding(.all, 8.0)
                                .background(Color.teLightGray)
                                .cornerRadius(8)
                                .font(.teFont16R())
                                .kerning(-0.2)
                            Spacer()
                                .frame(height: 15)
                            
                            Text("투데이츠 내용")
                                .font(.teFont12M())
                                .foregroundColor(Color.teMidGray)
                            
                            
                            
                            
                            // TextEditor에 직접적인 placeholder 지정은 불가능하므로 로직 변경 필요
                            ZStack(alignment: .leading) {
                                
                                TextEditor(text: $content)
                                
                                    .frame(height: 200)
                                    .cornerRadius(8)
                                    .colorMultiply(.teLightGray)
                                    .font(.teFont16R())
                                    .kerning(-0.2)
                                
                                if content.isEmpty {
                                    VStack{
                                        Spacer().frame(height: 8)
                                        Text(" 내용 (선택)")
                                            .font(.teFont16R())
                                            .kerning(-0.2)
                                            .padding(.leading, 4)
                                            .foregroundColor(Color.teTitleGray)
                                        Spacer()
                                    }
                                }
                            }
                            .onTapGesture {
                                if self.content.isEmpty {
                                    self.content = "" // 사용자 입력을 시작하면 placeholder를 지웁니다.
                                }}
                            
                            
                            
                            Spacer().frame(minHeight: 20)
                            
                            
                            
                        }
                        
                        Spacer()
                            .frame(width: 20.0)
                    }
                    
                    
                }
                
            }.onAppear {
                // geometry.size.width를 사용하여 화면의 가로 길이를 구하고, 상태 변수에 저장
                self.widthSize = geometry.size.width - 200
            }
            .sheet(isPresented: $isImagePickerDisplayed) {
                ImagePicker(selectedImage: $selectedImage, isPresented: $isImagePickerDisplayed)
            }
            HStack{
                Spacer().frame(width: 15.0)
                Button(action: {
                    // FeedModel 인스턴스 생성
                    let admin : String = UserDefaults.standard.string(forKey: "administrativeArea") ?? ""
                    let locality : String = UserDefaults.standard.string(forKey: "locality") ?? ""
                    let subLocality : String = UserDefaults.standard.string(forKey: "subLocality") ?? ""
                    let userID : String = UserDefaults.standard.string(forKey: "uid") ?? ""
                    print(admin)
                    print(locality)
                    print(subLocality)


                     let newFeed = FeedModel(
                         id: UUID().uuidString, // Firestore에 추가할 때는 id 필드가 필요하지만, 실제로 데이터를 추가할 때는 이 필드를 사용하지 않습니다.
                         userID: userID, // 현재 로그인한 사용자의 ID로 대체해야 합니다.
                         userName: userID, // 현재 로그인한 사용자의 이름으로 대체해야 합니다.
                         feedTitle: title,
                         feedMemo: content,
                         time: "\(Date())", // 실제 앱에서는 Date 객체를 적절한 문자열로 변환해야 합니다.
                         resName: location, // 필요한 경우 사용자로부터 입력받거나 다른 방식으로 설정
                         location: location,
                         rating: rating,
                         waiting: Int(waitingTime) ?? 0,// waitingTime은 String이므로 Int로 변환,
                         administrativeArea: admin,
                         locality: locality,
                         subLocality: subLocality
                         
                     )

                     // FirestoreManager를 통해 Firestore에 데이터 추가
                     viewModel.addFeed(feed: newFeed)

                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Spacer()
                    Text("완료").font(.teFont18M())
                        .foregroundColor( .white)
                        .frame(height: 56.0)
                        .kerning(-0.2)
                    
                    Spacer()
                }
                .background(Color.teBlack)
                .cornerRadius(12)
                Spacer()
                    .frame(width: 15.0)
                
            }.padding(.bottom, 10.0)
        }
            
        }
        
    }
    
    
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        @Binding var isPresented: Bool
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            var parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.selectedImage = image
                }
                parent.isPresented = false
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.isPresented = false
            }
        }
    }
    
    
}

#Preview(body: {
    CreatePostView()
})
