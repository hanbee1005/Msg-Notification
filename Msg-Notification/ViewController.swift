//
//  ViewController.swift
//  Msg-Notification
//
//  Created by 손한비 on 2021/07/16.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet var msg: UITextField!
    
    @IBOutlet var datepicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func save(_ sender: UIButton) {
        if #available(iOS 10, *) {
            // UserNotificaton 프레임워크를 사용한 로컬 알림
            // 알림 동의 여부를 확인
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    // 알림 설정이 들어갈 곳
                    DispatchQueue.main.async {
                        // 알림 콘텐츠 정의
                        let nContent = UNMutableNotificationContent()
                        nContent.body = (self.msg.text)!
                        nContent.title = "미리 알림"
                        nContent.sound = .default
                        
                        // 발송 시각을 '지금부터 *초' 형식으로 반환
                        let time = self.datepicker.date.timeIntervalSinceNow
                        
                        // 발송 조건 정의
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
                        
                        // 발송 요청 객체 정의
                        let request =  UNNotificationRequest(identifier: "alarm", content: nContent, trigger: trigger)
                        
                        // 노티피케이션 센터 추가
                        UNUserNotificationCenter.current().add(request) { (_) in
                            DispatchQueue.main.async {
                                // 발송 완료 안내 메시지 창
                                let date = self.datepicker.date.addingTimeInterval(9*60*60)
                                let message = "알림이 등록되었습니다. 등록된 알림은 \(date)에 발송됩니다."
                                
                                let alert = UIAlertController(title: "알림 등록", message: message, preferredStyle: .alert)
                                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                                alert.addAction(ok)
                                
                                self.present(alert, animated: false, completion: nil)
                            }
                        }
                    }
                } else {
                    let alert =  UIAlertController(title: "알림 등록", message: "알림이 허용되어 있지 않습니다.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    
                    alert.addAction(ok)
                    
                    self.present(alert, animated: false, completion: nil)
                    return
                }
            }
        } else {
            // LocalNotification 객체를 사용한 로컬 알림
        }
    }
    
}

