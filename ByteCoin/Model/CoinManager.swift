//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUPdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "Your API Key"
    
    let currencyArray = ["USD", "CAD","EUR","HKD","JPY"]
    
    // baseURL 뒤에 각 나라별 화폐 붙이는 함수 by Picker
    // for을 이용하여 VC에서 외부에서 접근
    //MARK: - getCoinPrice
    func getCoinPrice(for currency: String) {
        // url String 생성, 선택되는 통화(currency)에 따라 받아오는 API가 달라짐
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        // if let 바인딩으로 값이 있다면 아래 클로저로 내려감
        if let url = URL(string: urlString) {
            // URL Session을 인스턴스 생성
            // 아래에서 dataTask 처리
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, reponse, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    // data가 받아와지면 safeData에 저장
                    // data 받아오는 부분에서 JSON 파싱 처리
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        // rate 문자열을 소수점 2자리로 리포맷팅
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        // 위임자 업데이트
                        self.delegate?.didUPdatePrice(price: priceString, currency: currency)
                    }
                }
                
            }
            task.resume()
        }
    }
    //MARK: - parseJSON
    func parseJSON(_ data: Data) -> Double? {
        
        // JSON 디코더 만들기
        let decoder = JSONDecoder()
        
        do {
            // data로 부터 데이터를 CoinData로 디코딩 작업 진행
            let decodedData = try decoder.decode(CoinData.self, from: data)
            // 디코드된 rate 변수를 lastPrice에 저장
            let lastPrice = decodedData.rate
            print(lastPrice)
            // lastPrice 값 return
            return lastPrice
        } catch {
            // 에러가 나면 nil로 return
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
