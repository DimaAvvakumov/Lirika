//
//  NewsListViewModel.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright (c) 2019 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol NewsListViewOutput {
  func configure(input: NewsListViewModel.Input) -> NewsListViewModel.Output
}

class NewsListViewModel: RxViewModelType, RxViewModelModuleType, NewsListViewOutput {
  
  // MARK: In/Out struct
  struct InputDependencies {
    
  }
  
  struct Input {
    let appearState: Observable<ViewAppearState>
  }
  
  struct Output {
    let title: Observable<String>
    let state: Observable<ModelState>
  }
  
  // MARK: Dependencies
  private let dp: InputDependencies
  private let moduleInputData: ModuleInputData
  
  // MARK: Properties
  private let bag = DisposeBag()
  private let modelState: RxViewModelStateProtocol = RxViewModelState()
  
  // MARK: Observables
  private let title = Observable.just("NewsList")
  private let outputModuleAction = PublishSubject<OutputModuleActionType>()
  
  // MARK: - initializer
  
  init(dependencies: InputDependencies, moduleInputData: ModuleInputData) {
    self.dp = dependencies
    self.moduleInputData = moduleInputData
  }
  
  // MARK: - NewsListViewOutput
  
  func configure(input: Input) -> Output {
    // Configure input
    input.appearState.subscribe(onNext: { _ in
      // .didLoad and etc
    }).disposed(by: bag)
    
    // Configure output
    return Output(
      title: title.asObservable(),
      state: modelState.state.asObservable()
    )
  }
  
  // MARK: - Module configuration
  
  func configureModule(input: ModuleInput?) -> ModuleOutput {
    // Configure input signals
    
    // Configure module output
    return ModuleOutput(
      moduleAction: outputModuleAction.asObservable()
    )
  }
  
  // MARK: - Additional

  deinit {
    print("-- NewsListViewModel dead")
  }
}
