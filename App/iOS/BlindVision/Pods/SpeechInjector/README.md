# SpeechInjector by Richard Simpson 
contact : revsimpson@casema.nl

The easiest way to apply voice-commands in your IOS app.

![](SpeechInjector.png)

Simple add words you want your program to react to and after that program or call functions you want to react on that specific word or set of words. You can make as much different sets as you want. I no time you have your app fully navigational with voice-commands!



![](Dec-30-2018%2022-09-45.gif)

# Installation


<B>pod 'SpeechInjector','~> 1.1.0'</B>


# Demo Application 


Demo application can be downloaded here : https://github.com/revsimpson/SpeechInjector-Demo



# How to use?

Here is some example code how to use it :

import UIKit

class ViewController: UIViewController {

    var injector : SpeechInjector!  // Allways initiate here not in viedDidLoad or anywhere else!!!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up connectors...which are a set of words (add as much as you like) which when are being said
        // will perform the action you specify in the closure. PS Also keep in mind people do not say the words
        // as they should so you should take grammer errors into account. During debugging you will see what word
        // is captured when you say something.
        
        let connector1 = SpeechConnector(words: "hello","hi","good morning","hellu") {
            // do some kind of action
            print("connector1 action done") 
        }
        
        let connector2 = SpeechConnector(words: "next","forward") {
            // do some kind of action for instance transtion to another screen
            // or do something in the UI. Always refer to self within the closure
            // but code complition will let you know ;-)
            
            print("connector2 action done") 
        }
        
        let connector3 .... etc etc etc
 
       // When you made all your voice-commands add them to the SpeechInjector
       // You always send 'self' along with the init of the injector
       
       injector = SpeechInjector(connectors: [connector1,connector2, etc etc], vc: self)
       
       // Now place the button in you viewcontroller
       injector.placeSpeechButton()
    }
}

If the button is not place correctly in your app set the injector.placeSpeechButton() in viewDidAppear

# Plist

Add the following privacy settings to your plist and tell the user why you need to use their microphone and speech recognition.

<B>Privacy - Microphone Usage Description</B>

<B>Privacy - Speech Recognition Usage Description</B>



# Different init options for the SpeechInjector

You can set different options when you initiate a SpeechInjector 

<B>Basic</B> :

SpeechInjector(connectors: [SpeechConnector], vc: UIViewController) <- Connectors and a vc is a must!

 
<B>With options</B> :

<B><i><font color="green">Valid</font></i></B>

SpeechInjector(connectors: <B>[connector1]</B>, vc: <B>self</B>, language: <B>"nl-NL"</B>)

<B><i><font color="green">Valid</font></i></B>

SpeechInjector(connectors: <B>[connector1,connector2,connector3]</B>, vc: <B>self</B>, language: <B>"en-US"</B>)

<B><i><font color="green">Valid</font></i></B>

SpeechInjector(connectors: <B>[connector1,connector2]</B>, vc: <B>self</B>)


<B><i><font color="red">Invalid</font></i></B>

If you do not want to use a property do not set it to 'nil'. So you either use it or delete it from the init.

So this is wrong : 

SpeechInjector(connectors: [connector1, connector2], vc: self, language: <font color="red">nil</font>) <B><- WRONG !!</B>


or


SpeechInjector(connectors: [connector1, connector2], vc: self, language: <font color="red">""</font>) <B><- WRONG !!</B>


If you do not use a property then just leave the whole thing out!

FOR LANGUAGECODES CHECK : https://gist.github.com/JamieMason/3748498




# Default settings SpeechInjector


When you do not use a property default settings will be used:

language = "nl-NL"  (use your own country code to capture words in your own language!)




# Placing the speechbutton and its default settings

The basic placement of the button is when you have an instance of the SpeechInjector and you call

<B>injector.placeSpeechButton()</B>  

A button is placed with default settings. You can change the image of the button and the button tintcolor and elevation settings etc etc.
Just like the SpeechInjector init... just fill what you want to use and leave out which you do not want to use and for the rest of the parameters defaults settings will apply.


This is the default for the placeSpeechButton.


<B>func placeSpeechButton(position : SpeechButtonLocation = .rightBottom,
                                  buttonColor: UIColor = UIColor(red:0.30, green:0.50, blue:0.70, alpha:1.0) ,
                                  buttonRecordingColor :UIColor = UIColor(red:0.94, green:0.17, blue:0.18, alpha:1.0),
                                  buttonHeight:CGFloat = 60 ,
                                  buttonWidth : CGFloat = 60,
                                  xOffset: CGFloat = 16,
                                  yOffset : CGFloat = 16,
                                  image : UIImage = UIImage(named: "speech")!,
                                  tintColor : UIColor = UIColor.white, elevationNormalState: CGFloat = 6.0,
                                  elevationHighlightedState : CGFloat =  12.0)</B>

So you can call for example: <B> 
    
injector.placeSpeechButton(position: .leftBottom,yOffset: 39, elevationNormalState = 14)


OR


injector.placeSpeechButton()   <--- Which uses all default values

</B>

The values you did not fill in will get the default values. 
The standard image for the button is the microphone materialdesign button called speech so make sure you do not have also a picture in your project with the same name. Otherwise you can put any image in there you want.
But again....do not fill paramaters with "nil" if you do not want to use them, because it will fail, just leave them out and it will work.



# Extra offset after setting the position


When you have set the position in your placeSpeechButton ... you can still change the offset of that position.

Remember where we have set the button : 

<B>injector.placeSpeechButton(postion: right.bottom)</B>

You can add offsets to that function like this :

<B>injector.placeSpeechButton(postion: right.bottom, xOffset: 20, yOffset : 35)</B>

Default offset is <B>xOffset = 16 and yOffset =16)
    
  
# Thats about it for now.... ! 


If you want to donate my addresses are as follows :

<B>TRON (TRX) : TAo7ydaxqXu6bebuCUH2qEdhP6xP65E35K</B>

<B>BITCOIN (BTC) : 1AmjnkZsXuBmowGjw6gEyisdkYBPYhaD8z</B>
