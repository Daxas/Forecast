
import UIKit

private let ForecastApiKey = "cfb098593c0899de76d374e96d68c8e3"

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        NetWorkClient.Configuration.apiKey = ForecastApiKey
        
        let serviceFactory = ServiceFactory(coreFactory: CoreFactory())
        let presentationFactory = PresentationFactory(serviceFactory: serviceFactory)
        window?.rootViewController = presentationFactory.createTabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

