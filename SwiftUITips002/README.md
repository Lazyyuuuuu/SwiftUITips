## SwiftUI Tips 002：极简应用入口

早期的 SwiftUI 应用程序的入口沿续了 UIKit App Delegate 那一套流程，初始工程会创建一个由 `@UIApplicationMain` 修饰的 `AppDelegate` 类，如下所示：

```
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
```

同时会创建一个 `SceneDelegate.swift` 文件，其中包含一个 `SceneDelegate` 类，并在其 `scene(_:, willConnectTo:, options:)` 方法中指定初始视图，如下代码所示：

```
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
```

另外还需要在 Info.plist 中的 `Application Scene Manifest` 项中关联这个 `SceneDelegate` 才能将其内容正确地显示出来

![img](https://mmbiz.qpic.cn/mmbiz_png/3QD99b9DjVHtw4GInExUzktMnOUps3rh0hynVeb83icH9rXmH9rk3yvXCaL9ia0hibzcRKNbmQ7bGVff9iaMRJJBqQ/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

虽然这些代码和配置都是自动生成的，但终归不是那么的优雅。苹果的工程师们也意识到这一点，所以在 Xcode 12 中，引入了一种极简的应用入口，只需简单的几行代码，就能完成上面的整个流程。

在 Xcode 12 中，在创建 SwiftUI 应用时， `Choose options for your new project` 面板中多了一个 `Life Cycle` 选项，这个选项默认是 `SwiftUI App` ，即新的程序结构。如果选择 `UIKit App Delegate` ，则为上面的程序结构。

![img](https://mmbiz.qpic.cn/mmbiz_png/3QD99b9DjVHtw4GInExUzktMnOUps3rh7bialIvJIpto9WZuS0yCaRhFa8Olpv80VicmF8rgTsIAsxiaVIsB8F7aw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

创建完新工程后，我们看到会生成一个 `SwiftUIDemoApp.swift` 文件，这个文件包含了程序入口的代码：

```
@main
struct SwiftUIDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

简单的几行代码即完成了上面两个文件所有的工作。我们来简单分析一下这几行代码：

- `@main` 是在最新的 `Swift 5.3` 中引入的一个语法糖（SE-0218），用于指定应用程序的入口；
- 入口元素由类变成了结构体，这符合 SwiftUI 的设计哲学；
- `SwiftUIDemoApp` 实现了 `App` 协议，这个能够轻松地让我们用一个结构体来代替 `AppDelegate` 和 `SceneDelegate` ，应用的场景的生命周期都由这个结构体来管理；
- `body` 属性也是和 SwiftUI 契合，也是遵循 `App` 协议唯一必须实现的元素；
- `body` 的类型是 `some Scene` ， `Scene` 是另一个协议，表示应用 UI 的一部分，通常作为视图层级架构的容器，生命周期由系统管理；
- 使用 `some Scene` 作为类型，表示存在多种场景类型，如这里的 `WindowGroup` 是基于窗口的场景，还有诸如基于文档的 `DocumentGroup` 场景等；
- `ContentView` 即是我们熟知的自定义视图；

除了代码量极大的减少，Info.plist 中的 `Application Scene Manifest` 配置项也简化了不少

![img](https://mmbiz.qpic.cn/mmbiz_png/3QD99b9DjVHtw4GInExUzktMnOUps3rhibblZb2WBDNf2ZiaQUcGxqdmOj2lSxwl1jsp9H3ibjXJgE7qQ2FKQPoew/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

怎么样，是不是简洁了很多？./SwiftUITips000/README.md)

转自https://mp.weixin.qq.com/s/FNOCXoeoo7PzWriVAF2xEA

