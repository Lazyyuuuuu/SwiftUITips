# 一切皆 View

新建一个 SwiftUI 工程会默认为我们创建一个视图，其中显示了一个著名的 `Hello, world!` 文本，视图的代码如下：

```
struct ContentView: View {
    var body: some View {
        Text("Hello, world!").padding()
    }
}
```

可以看到结构体 `ContentView` 遵循了协议 `View` 。协议 `View` 表示应用程序中用户界面的一部分，SwiftUI 中一切显示在 UI 中的元素都遵循这个协议，包括诸如 `Color` 这样的结构体。可以这么说，在 SwiftUI 中，一切皆是 `View` 。

![img](https://mmbiz.qpic.cn/mmbiz_png/3QD99b9DjVHtw4GInExUzktMnOUps3rhwiby4cS5uoHibPVFBYkgTOPxHLarx8CvsRHcp6DQXpHYibGaXeIjCZHTA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

协议 `View` 的作用类似 `UIKit` 中的 `UIView` 类，但却并不像 `UIView` 那样臃肿，也不像 `UIView` 中有 `View` 和 `Layer` 之分。其自身的声明并不复杂，如下代码所示：

```
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol View {

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required `body` property.
    associatedtype Body : View

    /// The content and behavior of the view.
    var body: Self.Body { get }
}
```

可以看到这里只包含一个必须实现的 `body` 计算属性来提供视图的内容和行为。视图的层级结构就是通过一个个视图的 `body` 中的内容组合而来。

`View` 另一个强大之处在于它提供了大量的 **修饰符(modifier) **，它们是带有默认实现的协议方法，用于定义视图或布局的各种元素属性、动画、行为等等，如文本的字体、颜色、缩放动画。先举个简单的例子，如果想调整 `Hello, world!` 的字体大小，则可以使用 `font()` 修饰符来修饰 `Text` ，如下代码：

```
struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .font(.system(size: 60))
            .padding()
    }
}
```

这样就可以将 `Hello, world!` 的字体大小修改为 6`0` 。而如果要用多个修饰符修饰一个视图，则可以通过**链式调用**的将多个修饰符链接在一起，就如上面的代码所示，链接了 `font()` 和 `padding()` 两个修饰符。

![img](https://mmbiz.qpic.cn/mmbiz_png/3QD99b9DjVHtw4GInExUzktMnOUps3rhb2DblRVGX4NEMfXGxtichJgJB9ibiblTjzl8YkibkAQ6ouwzMn2IMqIDtw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

关于 `View` ，我们先了解这两个基本点，后续我们会继续探索。



转自https://mp.weixin.qq.com/s/EffEUsw9NsBsV7JDXr6TUQ