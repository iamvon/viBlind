//
//  SecondViewController.swift
//  BlindVision
//
//  Created by Hoàng Sơn Tùng on 3/21/19.
//  Copyright © 2019 Hoàng Sơn Tùng. All rights reserved.
//

import UIKit
import VerticalCardSwiper
import Speech
import SpeechInjector
class SecondViewController: UIViewController,VerticalCardSwiperDelegate, VerticalCardSwiperDatasource {

    var injector : SpeechInjector!
    
    var articleHash: String = ""
    
    @IBOutlet var cardSwiper: VerticalCardSwiper!
    @IBOutlet weak var Date_lb: UILabel!
    
    @IBInspectable public var isSideSwipingEnabled: Bool = false
    var Data: [Article] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is VoiceRecognizeController
        {
            let vc = segue.destination as? VoiceRecognizeController
            vc?.articleHash = self.articleHash
        }
    }
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewDidLoad()
        Data = callAPINews()
        self.cardSwiper.delegate = self
        self.cardSwiper.datasource = self
        // register cardcell for storyboard use
        cardSwiper.register(nib: UINib(nibName: "ExampleCell", bundle: nil), forCellWithReuseIdentifier: "ExampleCell")
        
        setLeftMarginTitle()
        setDate()
        
        let connector1 = SpeechConnector(words: "vision") {
            self.tabBarController?.selectedIndex = 0
        }
        
        let connector2 = SpeechConnector(words: "next", "thanks") {
            var current = self.cardSwiper.focussedIndex!
            self.cardSwiper.moveCard(at: current, to: current+1)
        }
        
        let connector3 = SpeechConnector(words: "ask", "as", "ass", "us") {
            self.performSegue(withIdentifier: "showVoiceRecognize", sender: nil)
        }
        injector = SpeechInjector(connectors: [connector1, connector2, connector3], vc: self, language: "en-US")
        
        injector.placeSpeechButton(buttonColor: UIColor(red:0.34, green:0.67, blue:0.18, alpha:1.0), yOffset: 65)
    }
    
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: index) as? ExampleCardCell {
            
            let article = Data[index]
            articleHash = article.hash
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
    }
    
    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        TapticEffectsService.performTapticFeedback(from: TapticEffectsService.TapticEngineFeedbackIdentifier.pop)
        
        let vc = VoiceOver()
        vc.sayThis(Data[index].content, speed: 0.4)
    }
    
    func didHoldCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int, state: UIGestureRecognizer.State) {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}

