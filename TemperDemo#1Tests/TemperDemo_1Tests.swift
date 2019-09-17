//
//  TemperDemo_1Tests.swift
//  TemperDemo#1Tests
//
//  Created by iTelaSoft on 9/16/19.
//  Copyright © 2019 Danutha. All rights reserved.
//

import XCTest
import RxSwift

@testable import Pods_TemperDemo_1

class TemperDemo_1Tests: XCTestCase {
     //Assign the on next value to be true upon sucess of the network call
    var isDataAvailable: Observable<Bool> = Observable<Bool>
        .create { observer in
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
    }
 //Prefix should be test always
    func testObservableBoolCollectorForJobs() {
        let collector = RxCollector<Bool>()
            .collect(from: isDataAvailable)
        
        XCTAssertEqual(collector.toArray, [true])
    }
 //Prefix should be test always, this test the viewModel
    func testTitle() {
        
        let mainData  = Dates(title: "My name", distance: "12", client: nil, shifts: nil, job_category: nil)
        let viewModel = JobsViewModel(mainData: mainData)
        XCTAssertEqual(mainData.title, viewModel.getTitle())
        
    }
    
}
//Subscribed event
class RxCollector<T> {
    var disposeBag: DisposeBag = DisposeBag()
    var toArray: [T] = [T]()
    func collect(from observable: Observable<T>) -> RxCollector {
        observable.asObservable()
            .subscribe(onNext: { (newObj) in
                self.toArray.append(newObj)
            }).disposed(by: disposeBag)
        return self
    }
}
