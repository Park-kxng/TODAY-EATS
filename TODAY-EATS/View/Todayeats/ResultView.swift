//
//  ResultView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/11/24.
//

import SwiftUI

#Preview(body: {
    ResultView(navigationManager: NavigationManager())
})




struct ResultView: View {
    @EnvironmentObject var selectionModel: SelectionModel

    var navigationManager: NavigationManager

    @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가는 환경 변수
    @State private var isNavigationActive = false
    @State private var selectedItem: String? = nil
    @State private var navigationValue: NavigationDestination?

    let title : String = "오늘도 맛있는 한 끼 되세요!"
    let subTitle = "투데이츠 추천 메뉴 중 하나를 선택하면 \n추천맛집을 검색할 수 있어요"

    @State var buttonTitles : [String] = ["메뉴 추천 중 ..."]
    let buttonLines : [ClosedRange<Int>] = [1...4, 5...8]
        @State private var selectedCuisines: Set<String> = []
        @State private var nextButtonEnabled: Bool = false
    
    let fontColor = Color.teMidGray
    let fontColorClicked = Color.white
    let backgroundColor = Color.teLightGray
    let backgroundClicked = Color.teBlack
    let backgroundClickedRed = Color.teRed

        var body: some View {
                
                VStack{
                    Spacer()
                        .frame(height: 15)
                    
                    
                    Image("img_charc")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: 150, maxHeight: 200)
                    
                    Spacer().frame(height: 30)
                    
                    Text(title)
                        .font(.teFont26B())
                        .kerning(-0.2)
                    Spacer()
                        .frame(height: 8.0)
                    Text(subTitle)
                        .font(.teFont16M())
                        .foregroundColor(Color.teTitleGray)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    
                    ForEach(0..<buttonTitles.count, id: \.self) { index in
                        createButton(index: index)
                    }.onAppear {
                        fetchFoodRecommendation(custom: selectionModel) { foods in
                            self.buttonTitles = foods
                            
                        }}
                    if buttonTitles.count > 1 {
                        let retryAction = {
                            self.fetchFoodRecommendation(custom: self.selectionModel) { foods in
                                self.buttonTitles = foods
                            }
                        }
                        
                        let retry = SmallButton(viewName: "result", title: "다시 추천해줘요!", isSelected: true, action: retryAction)
                        retry
                    }
                    
                    Spacer()
                        

                    HStack{
                        Spacer().frame(width: 15)
                        // "처음으로" 버튼의 수정된 동작
                        Button(action: {navigationManager.popToRootView()}) {
                            HStack {
                                Spacer()
                                Text("처음으로")
                                    .font(.teFont18M())
                                    .foregroundColor(fontColorClicked)
                                Spacer()
                            }
                            .frame(height: 56.0)
                            .background(backgroundClicked)
                            .cornerRadius(12)
                        }

                        
                        Spacer().frame(width: 15)
                        // "맛집 찾아보기" 버튼의 수정된 동작
                        NavigationLink(destination: LocationCheckView(navigationManager: navigationManager)
                            .environmentObject(selectionModel)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarBackButtonHidden(true) // 뒤로가기 버튼 숨기기
                            .navigationBarItems(leading: BackButton(title: "이전 단계로")) // 커스텀 뒤로가기 버튼 추가
                        )
                        {
                            Spacer()
                            Text("맛집 찾아보기")
                                .font(.teFont18M())
                                .foregroundColor(nextButtonEnabled ? fontColorClicked : fontColor)
                            Spacer()
                        }
                        .frame(height: 56.0)
                        .background(nextButtonEnabled ? backgroundClickedRed : backgroundColor)
                        .cornerRadius(12)
                        .disabled(!nextButtonEnabled) // `!`를 추가하여 nextButtonEnabled가 true일 때 버튼이 활성화되도록 수정

                        Spacer().frame(width: 15)

                        }
                        

                    
                    Spacer().frame(height: 20.0)
                    
                
               
                }
            .navigationTitle("이전 단계로")
            .onChange(of: selectedItem ?? "" , { oldValue, newValue in
                selectionModel.selectedMenu = newValue
                nextButtonEnabled = !newValue.isEmpty

            })
            
            
        }
       
    func createButton (index : Int) -> some View {
        HStack {
            let title  = buttonTitles[index]
            let selected = (selectedItem == title)

            
            SmallButton( viewName:"result", title: title, isSelected: selected) {
                selectionModel.selectedMenu = selectedItem ?? ""
                // 버튼이 클릭되었을 때의 동작
               if selectedItem == title {
                   // 이미 선택된 항목을 다시 클릭한 경우, 선택을 해제합니다.
                   selectedItem = nil
               } else {
                   // 다른 항목을 선택한 경우, 선택된 항목을 업데이트합니다.
                   selectedItem = title
               }
                nextButtonEnabled = !(selectedItem == nil)
            }
        
            }
        }
    
    // ChatGPT API를 사용하여 음식 추천을 받는 함수
    func fetchFoodRecommendation(custom : SelectionModel,completion: @escaping ([String]) -> Void) {
        let CHATGPTkey = Bundle.main.infoDictionary?["CHATGPTkey"] as! String

        let customString = "\(custom.cuisine.joined(separator: ", ")), 매운 정도: \(custom.spicy), 기름진 정도: \(custom.oily), 장소: \(custom.place.joined(separator: ", ")), 날씨: \(custom.weather.joined(separator: ", "))"
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(CHATGPTkey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let menus = """
        한식: 김치찌개, 된장찌개, 비빔밥, 삼겹살, 불고기, 갈비탕, 해장국, 순두부찌개, 청국장, 보쌈, 족발, 곱창, 제육볶음, 국수, 부침개, 찜닭, 돌솥밥, 육회, 냉면, 감자탕
        중식: 짜장면, 짬뽕, 탕수육, 깐풍기, 마파두부, 양장피, 새우볶음밥, 고추잡채, 라조기, 마라탕, 훠궈, 동파육, 깐쇼새우, 양꼬치, 볶음밥, 새우볶음밥, 우육면, 사천식 볶음요리, 백짬뽕
        일식: 초밥, 라멘, 돈부리, 타코야키, 오코노미야키, 우동, 가츠동, 텐동, 사시미, 템푸라, 일식 카레, 토리야키, 이나리, 미소시루, 가이센동
        양식: 스테이크, 파스타, 피자, 햄버거, 샌드위치, 치킨 샐러드, 리조또, 라자냐, 햄버거, 그라탕, 샐러드, 바베큐, 미트볼, 피쉬 앤 칩스, 로스트 치킨
        아시아 음식: 팟타이, 커리, 쌀국수, 미고랭, 사테, 똠양꿍, 피쉬볼, 볶음밥, 월날쌈, 분짜, 라따뚜이, 인도네시아 나시고랭, 베트남 쌀국수, 필리핀 아도보, 말레이시아 락사
        분식: 떡볶이, 김밥, 순대, 어묵, 튀김, 비빔면, 쫄면, 라볶이, 핫도그, 피자떡볶이, 김치전, 해물파전, 고구마 튀김, 밀전병, 치즈 떡볶이
        카페: 카페라떼, 아메리카노, 카푸치노, 에스프레소, 녹차라떼, 바닐라 라떼, 카라멜 마키아토, 모카, 플랫 화이트, 아이스 티, 스무디, 프라푸치노, 말차 프라페
        기타: 케밥, 타코, 부리토, 팔라펠, 인도네시아 사테, 멕시칸 살사, 그리스 요거트, 중동 훔무스, 이탈리아 브루스케타, 프랑스 크로와상
        """
        print(customString)
        let system  = """
        당신은 개인 맞춤형 메뉴 추천 서비스를 제공합니다. 사용자가 제시한 키워드를 기반으로 알맞은 메뉴를 추천해주세요
        답변은 무조건 음식의 이름으로만 구성해주세요 절대 , 표시는 넣지 마세요. 모든 메뉴이름은 무조건 띄워쓰기하지 말고 입력해주세요! 치즈 떡볶이와 같은 경우도 치즈떡볶이 이렇게 붙여주세요.
        답변 예시 1. 파스타 된장국 케밥
        답변 예시 2. 스테이크 리조토 치킨
        답변 예시 3. 짜장면 짬뽕 탕수육
        절대 , 표시는 넣지 마세요. 절대 , 표시는 넣지 마세요. 절대 , 표시는 넣지 마세요.
        
        그리고, 당신은 아래의 레퍼런스를 참고해야 합니다. 더 좋은 메뉴가 있다면 당신이 새로운 메뉴를 추가해서 넣어주세요.
        다시 추천해줄 때 이전에 추천해준 음식은 추천해주지 마세요.
        한국이 가장 많이 먹는 외식 메뉴 순으로 추천해줬으면 좋겠습니다.
        \(menus)
        """
        let prompt = """
        질문 : 추천해줘, 오늘 먹을 음식 3개는?
        제시하는 키워드는 \(customString) 입니다.
        """
        let body = [
            "messages": [
                    ["role": "system", "content": system],
                    ["role": "user", "content": prompt],
           
                ],
            "model" : "gpt-4",
            "max_tokens": 30,
            "temperature": 0.7
        ] as [String : Any]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    // 추천된 음식 목록을 파싱하여 반환
                    let recommendations = content.components(separatedBy: " ")
                    print(recommendations)

                    DispatchQueue.main.async {
                        completion(recommendations)
                    }
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
}
