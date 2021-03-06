//
//  NewsCoordinator.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright © 2019 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum NewsRoute: Route {
  case seletAbout, selectNews
}

class NewsCoordinator: TabBarCoordinator<NewsRoute>, CoordinatorOutput {
  func configure() -> NewsCoordinator.Output {
    return Output(logout: outputLogout.asObservable())
  }
  
  struct Output {
    let logout: Observable<Void>
  }
  
  private let outputLogout = PublishRelay<Void>()
  
  init() {
    super.init(rootViewController: nil, initialRoute: .selectNews)
    
    let home = AboutCoordinator(rootViewController: nil, initialRoute: .about)
    let output = home.configure()
    output.logout.do(onNext: { [weak self, weak home] _ in
      self?.removeChild(home)
      self?.router.rootController = nil
    }).bind(to: outputLogout).disposed(by: bag)
    startCoordinator(home)
    let value = try! NewsListConfigurator.configure(inputData: .init())
    router.set([home.presentable(), value.viewController], completion: nil)
  }
  
  override func start() {
    trigger(.seletAbout)
  }
  
  // MARK: - Overrides
  
  override func prepare(route: NewsRoute, completion: PresentationHandler?) {
    switch route {
    case .seletAbout:
      router.select(index: 0, completion: completion)
    case .selectNews:
      router.select(index: 1, completion: completion)
    }
  }
  
  deinit {
    print("Dead NewsCoordinator")
  }
}
