//
//  RestaurantMapView.swift
//  TODAY-EATS
//
//  Created by p_kxn_g on 3/17/24.
//

import Foundation
import MapKit
import SwiftUI


struct RestaurantMapView: UIViewRepresentable {
    @ObservedObject var  restaruntViewModel : RestaurantViewModel

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow // 사용자 위치 추적 활성화
        mapView.delegate = context.coordinator
        
        // Test marker
            let testCoordinate = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
            let testMarker = MKPointAnnotation()
            testMarker.title = "Test Location"
            testMarker.coordinate = testCoordinate
            mapView.addAnnotation(testMarker)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateAnnotations(from: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func updateAnnotations(from mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations) // 기존의 모든 마커 제거

        let annotations = restaruntViewModel.restaurants.map { restaurant -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = restaurant.title
            annotation.subtitle = restaurant.category
            let latitude = restaurant.mapx
            let longitude = restaurant.mapy
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RestaurantMapView
        
        init(_ parent: RestaurantMapView) {
            self.parent = parent
        }
        
        // 여기에 필요한 MKMapViewDelegate 메소드 구현
    }


