//
//  ViewController.swift
//  simpleGuessNumber
//
//  Created by Byron Bacusoy Pinela on 27/1/17.
//  Copyright © 2017 Novex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //-------------------------FOR BACKGROUND-------------------------
    @IBOutlet weak var background: UIImageView!
    var pointStart = CGPoint(x: 0.0, y: 0.0)
    var pointEnd = CGPoint(x: 1.0, y: 1.0)
    var phase = 0
    let gradient = CAGradientLayer()

    func backgroundEffect()
    {
        getCurrentPhase()
        switch phase {
        case 1:
            phaseOne()
        case 2:
            phaseTwo()
        case 3:
            phaseThree()
        default:
            phaseFour()
        }
        fixBugDouble(Phase: phase)
        redrawBackground()
    }
    func getCurrentPhase()
    {
        if (pointStart.equalTo(CGPoint(x: 0.0, y: 0.0)) && pointEnd.equalTo(CGPoint(x: 1.0, y: 1.0))) {phase = 1}
        if (pointStart.equalTo(CGPoint(x: 1.0, y: 0.0)) && pointEnd.equalTo(CGPoint(x: 0.0, y: 1.0))) {phase = 2}
        if (pointStart.equalTo(CGPoint(x: 1.0, y: 1.0)) && pointEnd.equalTo(CGPoint(x: 0.0, y: 0.0))) {phase = 3}
        if (pointStart.equalTo(CGPoint(x: 0.0, y: 1.0)) && pointEnd.equalTo(CGPoint(x: 1.0, y: 0.0))) {phase = 4}
    }
    func phaseOne()
    {
        pointStart.x += 0.1
        pointEnd.x -= 0.1
    }
    func phaseTwo()
    {
        pointStart.y += 0.1
        pointEnd.y -= 0.1
    }
    func phaseThree()
    {
        pointStart.x -= 0.1
        pointEnd.x += 0.1
        
    }
    func phaseFour()
    {
        pointStart.y -= 0.1
        pointEnd.y += 0.1
    }
    func redrawBackground()
    {
        gradient.startPoint = pointStart
        gradient.endPoint = pointEnd
    }
    func fixBugDouble(Phase:Int)
    {//Parece ser que no se suma/resta 0.1, si no que un poco más. Así que nunca llegarán a ser exactamente 0.0 o 1.0
        switch Phase {
        case 1:
            if(pointEnd.x < 0.1) {pointStart.x = 1.0;pointEnd.x = 0.0}
        case 2:
            if (pointEnd.y < 0.1) {pointStart.y = 1.0;pointEnd.y = 0.0}
        case 3:
            if (pointStart.x < 0.1) {pointStart.x = 0.0; pointEnd.x = 1.0}
        default:
            if (pointStart.y < 0.1) {pointStart.y = 0.0; pointEnd.y = 1.0}
        }
    }
    //--------------------------------------------------------------
    //VARIABLES
    //--------------------------------------------------------------
    var maxNumber = 0
    var minNumber = 0
    var avgNumber = 0
    var tryNumber = 0
    var isAnotherOneText = false
    var constantRightButtonConstraintY: CGFloat!
    var constantTryLabelConstraintY: CGFloat!
    //--------------------------------------------------------------
    //OBJETOS
    //--------------------------------------------------------------
    @IBOutlet weak var titleLabelConstraintY: NSLayoutConstraint!
    @IBOutlet weak var tryLabelConstraintY: NSLayoutConstraint!
    @IBOutlet weak var rightButtonConstraintY: NSLayoutConstraint!

    @IBOutlet weak var stackButtons: UIStackView!
    @IBOutlet weak var okButton: customButton!
    @IBOutlet weak var rightButton: customButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: customLabel!
    @IBOutlet weak var tryLabel: customLabel!
    @IBOutlet weak var numberLabel: UILabel!
    //--------------------------------------------------------------
    //FUNCIONES BUTTON
    //--------------------------------------------------------------
    @IBAction func okButtonAction(_ sender: AnyObject) {
        animationOKButtonPressed()
        calculateNum()
    }
    
    @IBAction func highButtonAction(_ sender: AnyObject) {
        minNumber = avgNumber
        calculateNum()
    }
    @IBAction func lessButtonAction(_ sender: AnyObject) {
        maxNumber = avgNumber
        calculateNum()
    }
    @IBAction func rightButtonAction(_ sender: AnyObject) {
        if (isAnotherOneText) {anotherOneGame()}
        else {endGame(userWins: false)}
    }
    //--------------------------------------------------------------
    //FUNCIONES
    //--------------------------------------------------------------
    
    func initApp(){
        initBackground()
        initGame()
    }
    func initBackground(){
        gradient.frame = view.bounds
        gradient.colors = [UIColor.red.cgColor,UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.blue.cgColor]
        gradient.endPoint = pointEnd
        gradient.startPoint = pointStart
        background.layer.insertSublayer(gradient, at: 0)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(backgroundEffect), userInfo: nil, repeats: true)
    }
    func initGame() {
        setAlphaTo0()
        getMinMax()
        setInfo()
        titleAnimation()
    }
    
    func anotherOneGame() {
        prepareAnotherGame()
        UIView.animate(withDuration: 0.3, animations: {
            self.setAlphaTo0()
            self.view.layoutIfNeeded()
        }) { (true) in
            self.prepareGame()
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (true) in
                    self.appearInfoLabelOkButton()
                    
            })
        }
        
    }
    func endGame(userWins:Bool){
        setTextEndGame(win: userWins)
        endGameAnimation()
    }
    
    
    
    func prepareAnotherGame(){
        getMinMax()
        tryNumber = 0
        isAnotherOneText = false
        okButton.isEnabled = true
    }
    func prepareGame() {
        self.setInfo()
        self.rightButtonConstraintY.constant = self.constantRightButtonConstraintY
        self.tryLabelConstraintY.constant = self.constantTryLabelConstraintY
        self.rightButton.setTitle("Correcto!", for: .normal)
    }
    
    func changeRightButtonText() {
        self.rightButton.setTitle("Otra?", for: .normal)
        self.isAnotherOneText = true
    }
    func setTextEndGame(win:Bool){
        if(win){tryLabel.text = "YOU WIN!"}
        else {tryLabel.text = "Im the best"}
    }
    func setNumberAndTry(){
        tryLabel.text = "\(tryNumber)"
        avgNumber = Int((maxNumber + minNumber)/2)
        numberLabel.text = "\(avgNumber)"
    }
    func calculateNum(){
        tryNumber += 1
        if (tryNumber < 11) {
            setNumberAndTry()
        }
        else{
            endGame(userWins: true)
        }
    }
    func setAlphaTo0(){
        okButton.alpha = 0.0
        infoLabel.alpha = 0.0
        tryLabel.alpha = 0.0
        numberLabel.alpha = 0.0
        rightButton.alpha = 0.0
        stackButtons.alpha = 0.0
    }
    func setInfo(){
        infoLabel.text = "Piensa en un número entre el \(minNumber) y el \(maxNumber) y lo adivinaré en menos de 10 intentos"
    }
    func getMinMax() {
        minNumber = Int(arc4random_uniform(1000))
        maxNumber = Int(arc4random_uniform(1000))
        checkMinMax()
    }
    func checkMinMax(){
        if (minNumber > maxNumber){
            let aux = maxNumber
            maxNumber = minNumber
            minNumber = aux
        }
        //Almenos con 100 numeros de diferencia
        if (maxNumber - minNumber < 100){
            if (maxNumber > 500){
                minNumber -= 100
            }
            else {
                maxNumber += 100
            }
        }
    }
    
    
    func desappearStackButtonsNumberLabel(){
        self.stackButtons.alpha = 0.0
        self.numberLabel.alpha = 0.0
    }
    func moveRightButton() {
        self.rightButtonConstraintY.constant = 5
        self.view.layoutIfNeeded()
    }
    func endGameAnimation(){
        UIView.animate(withDuration: 1.0, animations: {self.desappearStackButtonsNumberLabel()})
        { (true) in
            UIView.animate(withDuration: 1.0, animations: {self.moveRightButton()})
            self.changeRightButtonText()
        }
    }
    func appearInfoLabelOkButton(){
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseIn, animations: {
            self.okButton.alpha = 1.0
            self.infoLabel.alpha = 1.0
            }, completion: nil)
    }
    func titleAnimation() {
        titleLabel.center.y = 1000
        UIView.animate(withDuration: 2.0, animations: {
            self.view.layoutIfNeeded()
        }) { (true) in
            self.titleLabelConstraintY.constant = 5
            UIView.animate(withDuration: 1.5, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (true) in
                    self.appearInfoLabelOkButton()
            })
        }
    }
    func animationOKButtonPressed() {
        UIView.animate(withDuration: 1.0, animations: {
            self.desappearOKButton()
        }) { (true) in
            self.tryLabelConstraintY.constant = 5
            UIView.animate(withDuration: 1.0, animations: {
                self.appearTryLabelNumberLabel()
                }, completion: { (true) in
                    self.animationStackButtons()
            })
        }
    }
    func desappearOKButton(){
        self.okButton.alpha = 0.0
        self.okButton.isEnabled = false
    }
    func appearTryLabelNumberLabel() {
        self.tryLabel.alpha = 1.0
        self.numberLabel.alpha = 1.0
    }
    func animationStackButtons(){
        self.stackButtons.alpha = 1.0
        self.rightButton.alpha = 1.0
        let aux = self.rightButton.center.x
        self.stackButtons.center.x = 600
        self.rightButton.center.x = 600
        UIView.animate(withDuration: 0.3, animations: {
            self.rightButton.center.x = aux
            self.stackButtons.center.x = aux
        })
    }
    
    //--------------------------------------------------------------
    //METODOS
    //--------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constantRightButtonConstraintY = rightButtonConstraintY.constant
        constantTryLabelConstraintY = tryLabelConstraintY.constant
        initApp()
        
    }
    //--------------------------------------------------------------
}

