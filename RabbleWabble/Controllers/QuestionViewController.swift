/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

public protocol QuestionViewControllerDelegate:class{
  
  func questionViewController(_ viewController:QuestionViewController,
                              didCancle questionStrategy: QuestionStrategy)
  func questionViewController(_ viewController:QuestionViewController,
                              didComplete questionStrategy: QuestionStrategy)
}

public class QuestionViewController: UIViewController {

  // MARK: - Instance Properties
  public var questionView: QuestionView! {
    guard isViewLoaded else { return nil }
    return (view as! QuestionView)
  }
  
//  public var questionGroup = QuestionGroup.basicPhrases() {
//    didSet{
//      
//      navigationItem.title = questionGroup.title
//    }
//  }
  public weak var delegate: QuestionViewControllerDelegate?
//  public var questionIndex = 0
//  public var correctCount = 0
//  public var inCorrectCount = 0
  
  public var questionStrategy: QuestionStrategy!{
    didSet{
      navigationItem.title = questionStrategy.title
      
    }
  }
  
  private lazy var questionIndexItem :UIBarButtonItem = { [unowned self] in
    
    let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    self.navigationItem.rightBarButtonItem = item
    return item
    
    
  }()
  
  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    showQuestion()
    setUpCancelButton()
  }
  
  private func setUpCancelButton(){
    
    let action = #selector(handleCancelPressed(sender:))
    let cancelButton = UIBarButtonItem(image: UIImage(named: "ic_menu"), style:.plain , target: self, action: action)
    
    navigationItem.leftBarButtonItem = cancelButton
    
  }
  
  @objc private func handleCancelPressed(sender: UIBarButtonItem){
    
    delegate?.questionViewController(self, didCancle: questionStrategy)
  }
  
  private func showQuestion() {
    
    
    let question = questionStrategy.currentQuestion()
    questionView.answerLable.text = question.answer
    questionView.promptLable.text = question.prompt
    questionView.hintLable.text = question.hint
    questionView.answerLable.isHidden = true
    
    questionIndexItem.title = String(questionStrategy.questionIndexTitle())
    
  }
  
  // MARK: - Actions
  @IBAction func toggleAnswerLabels(_ sender: Any) {
    
    questionView.answerLable.isHidden = !questionView.answerLable.isHidden
    questionView.hintLable.isHidden = !questionView.hintLable.isHidden
    
  }
  
  @IBAction func handleCorrect(_ sender: Any) {
    
    let question = questionStrategy.currentQuestion()
    questionStrategy.markQuestionCorrect(question)
    
    
   
    questionView.correctCountLable.text = String(questionStrategy.correctCount)
    showNextQuestion()
    
    
    
  }
  
  @IBAction func handleIncorrect(_ sender: Any) {
    
    let question = questionStrategy.currentQuestion()
    
    questionStrategy.markQuestionIncorrect(question)
    
    
    questionView.inCorrectCountLable.text = String(questionStrategy.incorrectCount)
    showNextQuestion()
    
    
  }
  
  private func showNextQuestion() {
    let question = questionStrategy.advanceToNextQuestion()
   
    guard question else{
      delegate?.questionViewController(self, didComplete: questionStrategy)
      return
      
    }
    showQuestion()
    
  }
}
