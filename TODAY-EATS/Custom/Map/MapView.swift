//
//  MapView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/17/24.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    func makeCoordinator() -> LocationViewModel {
        LocationViewModel()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true // 사용자 위치 표시 활성화
        mapView.userTrackingMode = .follow // 사용자 위치 추적 활성화
        mapView.delegate = context.coordinator // MapViewCoordinator를 MKMapView의 델리게이트로 설정
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
}
