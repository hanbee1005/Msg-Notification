//
//  AppDelegate.swift
//  Msg-Notification
//
//  Created by 손한비 on 2021/07/16.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 11.0 , *) {
            // 경고창, 배지, 사운드를 사용하는 알림 환경 정보를 생성하고, 사용자 동의 여부 창을 실행
            let notiCenter = UNUserNotificationCenter.current()
            notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (didAllow, e) in }
            notiCenter.delegate = self  // 알림 클릭 시 이벤트를 전달받을 객체로 self 지정
        } else {
            // 경고창, 배지, 사운드를 사용하는 알림 환경 정보를 생성하고, 이를 애플리케이션에 저장
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(setting)
            
            if let localNoti = launchOptions?[UIApplication.LaunchOptionsKey.localNotification] as? UILocalNotification {
                // 알림으로 인해 앱이 실행된 경우이다. 이때는 알림과 관련된 처리를 해준다.
                print((localNoti.userInfo?["name"])!)
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print((notification.userInfo?["name"])!)
        if application.applicationState == .active {
            // 앱이 활성화된 상태일 때 실행할 로직
        } else if application.applicationState == .inactive {
            // 앱이 비활성화된 상태일 때 실행할 로직
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if #available(iOS 10.0, *) {  // UserNotification 프레임워크를 이용한 로컬 알림 (iOS 10 이상)
            // 알림 동의 여부를 확인
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    // 알림 콘텐츠 객체
                    let nContent = UNMutableNotificationContent()
                    nContent.badge = 1
                    nContent.title = "로컬 알림 메시지"
                    nContent.subtitle = "준비된 내용이 아주 많아요! 얼른 다시 앱을 열어주세요!!"
                    nContent.body = "앗! 왜 나갔어요??? 어서 들어오세요!!"
                    nContent.sound = .default
                    nContent.userInfo = ["name": "홍길동"]  // 알림과 함께 전달할 커스텀 데이터
                    
                    // 알림 발생 조건 객체
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    // 특정 시각을 지정하여 알림을 전달하고자 할 때 UNCalendarNotificationTrigger 사용
                    
                    // 알림 요청 객체
                    let request = UNNotificationRequest(identifier: "wakeup", content: nContent, trigger: trigger)
                    
                    // 노티피케이션 센터에 추가
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                } else {
                    print("사용자가 알림을 동의하지 않음!!!")
                }
            }
        } else {
            // 알림 설정 확인
            let setting = application.currentUserNotificationSettings
            
            // 알림 설정이 되어 있지 않다면 로컬 알림을 보내도 받을 수 없으므로 종료
            guard setting?.types != Optional.none else {
                print("Can't Schedule")
                return
            }
            
            // 로컬 알림 인스턴스 생성
            let noti = UILocalNotification()
            noti.fireDate = Date(timeIntervalSinceNow: 10) // 10초 후 발송
            noti.timeZone = TimeZone.autoupdatingCurrent  // 현재 위치에 따라 타임존 설정
            noti.alertBody = "얼른 다시 접속하세요!!!"  // 표시될 메시지
            noti.alertAction = "학습하기"  // 잠금 상태일 떄 표시될 액션
            noti.applicationIconBadgeNumber = 1 // 앱 아이콘 모서리에 표시될 배지
            noti.soundName = UILocalNotificationDefaultSoundName  // 로컬 알림 도착 시 사운드
            noti.userInfo = ["name": "홍길동"]  // 알림 실행 시 함께 전달하고 싶은 값 (화면에 표시되지 않음)
            
            // 생성된 알람 객체를 스케줄러에 등록
            application.scheduleLocalNotification(noti)
        }
    }
    
    // MARK: UNUserNotificationCenterDelegate
    
    // 앱 실행 도중에 알림 메시지가 도착한 경우
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.identifier == "wakeup" {
            let userInfo = notification.request.content.userInfo
            print(userInfo["name"]!)
        }
        
        // 알림 배너 띄워주기
        completionHandler([.badge, .sound])
    }
    
    // 사용자가 알림 메시지를 클릭했을 경우
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "wakeup" {
            let userInfo = response.notification.request.content.userInfo
            print(userInfo["name"]!)
        }
        
        completionHandler()
    }

}

