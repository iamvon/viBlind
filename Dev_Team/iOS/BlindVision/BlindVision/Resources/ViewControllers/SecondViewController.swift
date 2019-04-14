//
//  SecondViewController.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 3/21/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import UIKit
import VerticalCardSwiper

class SecondViewController: UIViewController,VerticalCardSwiperDelegate, VerticalCardSwiperDatasource {

    @IBOutlet var cardSwiper: VerticalCardSwiper!
    @IBOutlet weak var Date_lb: UILabel!
    
    @IBInspectable public var isSideSwipingEnabled: Bool = false
    var Data: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Data = callAPINews()
        self.cardSwiper.delegate = self
        self.cardSwiper.datasource = self
        // register cardcell for storyboard use
        cardSwiper.register(nib: UINib(nibName: "ExampleCell", bundle: nil), forCellWithReuseIdentifier: "ExampleCell")
        
        setLeftMarginTitle()
        setDate()
    }
    
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: index) as? ExampleCardCell {
            
            let article = Data[index]
            cardCell.topicLabel.text = article.topic
            cardCell.titleLabel.text  = article.title
            cardCell.contentLabel.text  = article.content
            cardCell.setRandomBackground()
            return cardCell
        }
        return CardCell()
    }
    
    func numberOfCards(verticalCardSwiperView verticalCardSwiperVierw: VerticalCardSwiperView) -> Int {
        return Data.count
    }
    
    func didEndScroll(verticalCardSwiperView: VerticalCardSwiperView) {
        
        TapticEffectsService.performTapticFeedback(from: TapticEffectsService.TapticEngineFeedbackIdentifier.cancelled)
        
        let vc = VoiceOver()
        vc.sayThis("Topic: "+Data[cardSwiper.focussedIndex!].topic+"  "+Data[cardSwiper.focussedIndex!].title, speed: 0.4)
        // Tells the delegate when the user scrolls through the cards (optional).
    }
    
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        // called right before the card animates off the screen.
    }
    
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        // called when a card has animated off screen entirely.
    }
    
    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        TapticEffectsService.performTapticFeedback(from: TapticEffectsService.TapticEngineFeedbackIdentifier.pop)
        
        let vc = VoiceOver()
        vc.sayThis(Data[index].content, speed: 0.4)
        
        // Tells the delegate when the user taps a card (optional).
    }
}

