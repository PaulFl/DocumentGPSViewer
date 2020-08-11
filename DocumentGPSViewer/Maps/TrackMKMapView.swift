//
//  TrackMKMapView.swift
//  GPSViewer
//
//  Created by Paul Fleury on 26/07/2020.
//

import SwiftUI
import MapKit

struct TrackMKMapView: View {
    let trackData: TrackData
    let trackIndex: Int
    @State var mapRegion = MKCoordinateRegion()
    @State var selectedMapType = MKMapType.standard
    
    var body: some View {
        VStack {
            ZStack {
                MapView(trackData: trackData, trackIndex: trackIndex, mapType: selectedMapType)
                VStack {
                    Picker("Map type", selection: $selectedMapType) {
                        Text("Standard").tag(MKMapType.standard)
                        Text("Hybrid").tag(MKMapType.hybrid)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.all, 10)
                    Spacer()
                }
            }
            
        }
    }
    
    var centerButton: some View {
        HStack {
            Spacer()
            VStack {
                Button(action: {
                    self.mapRegion = trackData.mapRegion[trackIndex]
                }, label: {
                    Text("Center")
                })
                Spacer()
            }
        }
    }
}

struct TrackMKMapView_Previews: PreviewProvider {
    static var previews: some View {
        TrackMKMapView(trackData: TrackData(fileName: "20200703_Monteynard", fileExtension: "SBP"), trackIndex: 0)
    }
}

struct MapView: UIViewRepresentable {
    let trackData: TrackData
    let trackIndex: Int
    let mapType: MKMapType
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false
        mapView.mapType = .hybrid
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapView.setRegion(trackData.mapRegion[trackIndex], animated: false)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        //view.setRegion(trackData.mapRegion, animated: false)
        view.mapType = mapType
        
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        view.showsUserLocation = true
        
        
        view.addOverlay(trackData.trackPolyline[trackIndex])
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, trackData: trackData)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        let trackData: TrackData
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKGradientPolylineRenderer(polyline: overlay as! MKPolyline)
            //renderer.setColors(trackData.speedColoredWaypoints, locations: trackData.polylineLocations)
            renderer.strokeColor = UIColor.systemPurple
            renderer.lineCap = .round
            renderer.lineWidth = 1
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "placemark"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        
        init(_ parent: MapView, trackData: TrackData) {
            self.parent = parent
            self.trackData = trackData
        }
    }
}
