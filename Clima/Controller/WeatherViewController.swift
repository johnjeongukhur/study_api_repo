//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    // Text를 입력 받는 변수
    @IBOutlet weak var searchTextField: UITextField!
    
    // API 키 호출 생성자 생성
    var weatherManager = WeatherManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        // 현재 가리키고있는 뷰컨에 알려주는 함수
        searchTextField.delegate = self

    }
    //
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    // 헤이 뷰컨 입력을 끝내야 해 하는 프로토콜
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // 만약 입력란에 문자가 비어있지 않다면 입력 멈춤
        if textField.text != "" {
            return true
        } else {
            // 만약 입력란이 비어있다면 Type Something 이라는 Placeholder가 뜨며 계속 입력 모드 진행
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    // Hey ViewController야 유저가 입력 멈췄어
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        // return 혹은 search 버튼을 누르면 빈 문자열로 클리어 됨
        searchTextField.text = ""
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        print(weather.temperature)
    }
}

