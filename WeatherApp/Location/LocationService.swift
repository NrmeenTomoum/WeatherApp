//
//  LocationService.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 15/04/2025.
//

import Combine
import CoreLocation

protocol LocationServiceProtocol {
    var currentLocationPublisher: AnyPublisher<CLLocationCoordinate2D?, Never> { get }
    var currentLocation: CLLocationCoordinate2D? { get }
    var error: Error? { get }
    func requestLocationUpdates()
}

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate, LocationServiceProtocol {
    var currentLocationPublisher: AnyPublisher<CLLocationCoordinate2D?, Never> {
        $currentLocation.eraseToAnyPublisher()
    }
    static let shared: LocationServiceProtocol = LocationService()
    
    private lazy var locationManager = CLLocationManager()
    @Published private(set) var currentLocation: CLLocationCoordinate2D?
    @Published private(set) var error: Error?
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func requestLocationUpdates() {
        error = nil
        guard CLLocationManager.locationServicesEnabled() else {
                error = LocationServiceError.locationServicesDisabled
                return
            }
            
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            locationManager.startUpdatingLocation()

        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()

        case .authorized:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        error = nil
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()

        case .authorized:
            locationManager.startUpdatingLocation()
        default:
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
         
            currentLocation = location.coordinate
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        self.error = error
    }
}

