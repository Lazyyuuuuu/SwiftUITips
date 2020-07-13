## 奇妙而强大的修饰符 (modifier)

在 SwiftUI 中，修饰符的功能类似于 CSS，用来在应用布局中定位和配置视图，如修改视图的大小、背景、添加动画、添加手势等等。View 协议通过扩展提供了大量的修饰符，它们以**协议方法**的形式给出，同时提供了默认实现。以我们熟悉的 `frame()` 为例，来看看它的声明：

```
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Positions this view within an invisible frame having the specified
    /// width and/or height.
    ///
    /// Use this method to specify a fixed size for a view's width,
    /// height, or both. If you only specify one of the dimensions, the
    /// resulting view assumes this view's sizing behavior in the other
    /// dimension.
    ///
    /// ...
    @inlinable public func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> some View

    /// This function should never be used.
    ///
    /// It is merely a hack to catch the case where the user writes .frame(),
    /// which is nonsensical.
    @available(*, deprecated, message: "Please pass one or more parameters.")
    @inlinable public func frame() -> some View
}
```

类似的声明还有很多。可以说，修饰符在 SwiftUI 中起着举足轻重的作用。

与 CSS 类似，修饰符的效果具有传递性，也就是说，父视图上使用的修饰符也会影响到其所有子视图，除非子视图显式的调用修饰符来覆盖这种效果，如下所示：

```
struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!").padding()
            Text("Hello, iOS 14").font(.body)       // 覆盖 VStack 的字体大小设置
        }
        .font(.system(size: 60))
    }
}
```

![img](https://mmbiz.qpic.cn/mmbiz_png/3QD99b9DjVFcEOIticzuHqH0XsBedPIic5OXELocvb7icOA1J5h7dZpzlcibYaXpy7DIyPI82vxgaM9jUMa18a0Ukg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

一般情况下，每个修饰符的作用是特定的，如 `font()` 用于修改字体大小， `frame()` 用于修改视图大小。然而一个视图通常会有很多属性，同时修改多个属性时需要依赖于多个修饰符，这时我们就可以通过链式调用的方式将这些修饰符串连起来，以完成对同一个视图的多重修饰。如下代码所示：

```
struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .foregroundColor(.blue)
                .padding(.all, 20)
                .border(Color.yellow, width: 1)
        }
        .font(.system(size: 60))
    }
}
```

![img](https://mmbiz.qpic.cn/mmbiz_png/3QD99b9DjVFcEOIticzuHqH0XsBedPIic5ofNib6O1CC95JJ4KFV8lMzxWdBb7wqRFCYhQ29VpOabZEBFu3phdaeA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

之所以能以链式的方式调用修饰符，是因为每个修饰符方法的返回值是 `some View` （如上面 `frame()` 的声明），仍然是一个视图，所以可以在新的视图的基础上继续调用修饰符。

需要注意的是，在链式调用的过程中，修饰符的顺序会对实际效果产生影响。相同的两个修饰符以不同的顺序调用，呈现的结果可能是不一样的。我们交换一下上面代码中 `padding()` 和 `border()` 的位置：

```
struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .foregroundColor(.blue)
                .border(Color.yellow, width: 1)
                .padding(.all, 20)
        }
        .font(.system(size: 60))
    }
}
```

![img](https://mmbiz.qpic.cn/mmbiz_png/3QD99b9DjVFcEOIticzuHqH0XsBedPIic5ERrrHoawNHVDZnaM3w4Gyiad1ZXHLdNrayJqSQ1dYoep0NgqIxfORibQ/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

可以看到边框位置的明显变化。实际上，如果我们稍微探索一下每一次调用修饰符所产生的视图，就会发现两者所生成的视图类型并不相同，我们将代码稍作修改：

```
struct ContentView: View {
    var body: some View {
        VStack {
            createText()
        }
        .font(.system(size: 60))
    }
    
    func createText() -> some View {
        let text = Text("Hello, world!")
            .foregroundColor(.blue)
            .border(Color.yellow, width: 1)
            .padding(.all, 20)
        return text
    }
}
```

在第 14 行打上断点，分别运行，并通过 `po type(of: text)` 来查看 `text` 的类型，可以得到如下结果：

```
// Text("Hello, world!").foregroundColor(.blue).border(Color.yellow, width: 1).padding(.all, 20) 的类型
SwiftUI.ModifiedContent<SwiftUI.ModifiedContent<SwiftUI.Text, SwiftUI._PaddingLayout>, SwiftUI._OverlayModifier<SwiftUI._ShapeView<SwiftUI._StrokedShape<SwiftUI.Rectangle._Inset>, SwiftUI.Color>>>

// Text("Hello, world!").foregroundColor(.blue).border(Color.yellow, width: 1).padding(.all, 20) 的类型
SwiftUI.ModifiedContent<SwiftUI.ModifiedContent<SwiftUI.Text, SwiftUI._OverlayModifier<SwiftUI._ShapeView<SwiftUI._StrokedShape<SwiftUI.Rectangle._Inset>, SwiftUI.Color>>>, SwiftUI._PaddingLayout>
```

可以看到，两者有不同的嵌套结构。详细的结构我们会在其它 Tip 中分析。SwiftUI 提供了丰富的修饰符，让开发者能尽情地创建生动而奇妙的页面，同时 SwiftUI 还提供了方法让我们可以**自定义修饰符**，以满足开发者创造的渴望。我们同样也会在另外一个 Tip 中来介绍如何自定义修饰符。



转自https://mp.weixin.qq.com/s/QqVGJEJRzOaQCbI_Ksu86w