//
//  ViewController.swift
//  Weather App
//
//  Created by Jaouher Bejaoui  on 14/7/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call fetch weather when search button clicked
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map{ self.cityNameTextField.text }
            .subscribe(onNext : { city in
                if let city = city {
                    if city.isEmpty{
                        self.displayWeather(nil)
                    }else{
                        self.fetchWeather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func fetchWeather(by city : String){
        guard let cityEncoded =
                city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL.urlForWeatherAPI(city: city) else{
            return
        }
        
        let resource = Resource<WeatherResult>(url: url)
        
        let search = URLRequest.load(resource: resource)
            .retry(3)
            .observe(on: MainScheduler.instance)
            .catchError{ error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            }.asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map{ "\($0.main.temp) ℉" }
            .drive(self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map{ "\($0.main.humidity) 💦" }
            .drive(self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func displayWeather(_ weather : Weather?){
        if let weather = weather {
            self.temperatureLabel.text = "\(weather.temp) ℉"
            self.humidityLabel.text = "\(weather.humidity) 💦"
        }else{
            self.temperatureLabel.text = "🤷🏻‍♂️"
            self.humidityLabel.text = "🤷🏻‍♂️"
        }
    }
    
}

