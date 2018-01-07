# UIViewController详解


## 概述

视图控制器管理着构成应用程序用户界面中的一部分视图，其负责加载和处理这些视图，管理与这些视图的交互，并协调视图对其展示的数据内容的变更作出响应。视图控制器还能与其他视图控制器对象协调工作，帮助管理应用程序的整体界面。

视图控制器的主要职责包括以下内容：
- 更新视图的内容来响应底层数据的变化。
- 响应用户与视图的交互。
- 调整视图大小并管理整个界面的布局。

## 视图控制器的作用

视图控制器是应用程序内部结构的基础。每个应用程序至少含有一个视图控制器，大多数应用程序都含有多个视图视图控制器。每个视图控制器管理着应用程序的用户界面，以及该界面和底层数据之间的交互。视图控制器也便于在不同用户界面之间的转换。

`UIViewController`类定义了一些方法和属性来管理视图、处理事件、从一个视图控制器切换到另一个视图控制器和协调应用程序的其他部分，可以通过继承`UIViewController`（或其子类之一）来添加实现应用程序行为所需的自定义代码。

有两种类型的视图控制器：
- 内容视图控制器，其管理着应用程序内容的一部分。
- 容器视图控制器，其收集来自于其他视图控制器的信息并以便于导航的方式呈现或者以不同方式呈现这些视图控制器的内容。

### 视图管理

视图控制器最重要的作用是管理视图的层次结构。每个视图控制器都含有一个包含所有视图控制器内容的根视图，可以添加需要显示内容的视图到该根视图中。下图显示了视图控制器和视图之间的内置关系，视图控制器总是具有对其根视图的强引用，并且每个视图都具有对其子视图的强引用。

![图2-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_ControllerHierarchy_fig_1-1_2x.png)

内容视图控制器自己管理其包含的所有视图，容器视图控制器管理其所包含的所有视图以及来自其一个或多个子视图控制器的**根视图**。容器视图控制器并不管理其子视图控制器的内容，只管理其子视图控制器的根视图。下图说明了`UISplitViewController`与其子视图控制器之间的关系。`UISplitViewController`管理其子视图的整体大小和位置，但子视图控制器管理这些视图的实际内容。

![图2-2](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_ContainerViewController_fig_1-2_2x.png)

### 数据封送

视图控制器充当其管理的视图与应用程序数据之间的媒介。子类化`UIViewController`的时候，可以添加任何需要在子类中管理的数据变量。添加自定义变量会创建一个如下图所示的关系，其中视图控制器具有对数据的引用以及用于呈现该数据的视图。

![图2-3](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_CustomSubclasses_fig_1-3_2x.png)

应该始终在视图控制器和数据对象中保持清晰的职责分离。大多数确保数据结构完整性的逻辑应属于数据对象本身。视图控制器可以验证来自视图的输入，然后以数据对象需要的格式打包输入，但是应该最小化视图控制器在管理实际数据中的角色。

`UIDocument`对象是一种独立于视图控制器管理数据的方式。文档对象是一个知道如何读写数据到持久存储的控制器对象。子类化`UIDocument`时，可以添加任何需要的逻辑和方法来提取数据，并将其传递给视图控制器或者应用程序的某部分。视图控制器可以存储其接收到的任何数据的副本，以便更新视图，但文档仍然拥有真实的数据。

### 用户交互

视图控制器是响应者对象，能够处理响应者链中传递的事件，但视图控制器很少直接处理触摸事件。相反，视图通常会处理自己的触摸事件，并将结果报告给其关联的委托或目标对象（通常是视图控制器）的方法。因此，视图控制器中的大多数事件都是使用委托方法或操作方法处理的。

### 资源管理

视图控制器对其视图和它创建的任何对象承担全部责任。`UIViewController`类自动处理视图管理的大多数方面，例如，UIKit自动释放不再需要的任何视图相关的资源。子类化`UIViewController`时，需要自己负责管理创建的任何对象。

当可用空闲内存不足时，UIKit会要求应用程序释放不再需要的资源。其中一种方式是通过调用视图控制器的`didReceiveMemoryWarning`方法来删除对不再需要的对象的引用或者稍后重新创建。例如，在该方法中删除缓存的数据。发生内存不足的情况时，释放尽可能多的内存非常重要。消耗太多内存的应用程序可能会被系统彻底终止以恢复内存。

### 适应性

视图控制器负责呈现其视图，并使该呈现适应底层环境。每个iOS应用程序都应该能够在iPad上运行，并且可以在几种不同大小的iPhone上运行。不是为每个设备提供不同的视图控制器和视图层，而是使用单个视图控制器来更简单地调整其视图以适应不断变化的空间需求。

在iOS中，视图控制器需要处理粗粒度的变化和细粒度的变化。当视图控制器的特性改变时，会发生粗粒度的变化。特征是描述整体环境的属性，例如显示比例。其中两个最重要的特性是视图控制器的水平和垂直尺寸类别，是它们表示视图控制器在给定维度中有多少空间。可以使用size class changes来改变布局视图的方式，如下图所示。当horizontal size class是规则的，视图控制器利用额外的水平空间来排列其内容。当horizontal size class是紧凑的，视图控制器垂直排列其内容。

![图2-4](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_SizeClassChanges_fig_1-4_2x.png)

根据给定的size class，可以随时进行更细粒度的尺寸更改。当用户将iPhone从纵向旋转到横向时，size class可能不会改变，但屏幕尺寸通常会改变。在使用自动布局时，UIKt会自动调整视图的大小和位置以匹配新维度。视图控制器可以根据需要进行其他调整。

## 视图控制器层次结构

应用程序的视图控制器之间的关系定义了每个视图控制器所需的行为，维护正确的视图控制器关系可以确保自动行为在需要时传递给正确的视图控制器。如果违反了UIKit规定的规则和呈现关系，则应用程序的表现可能和预期不一致。

### 根视图控制器

根视图控制器是视图控制器层次结构的锚点。每个窗口只有一个根视图控制器，此根视图控制器的内容填充该窗口。根视图控制器定义了用户看到的初始内容。下图显示了根视图控制器和窗口之间的关系，因为窗口本身没有可见的内容，所以视图控制器的视图提供了所有的内容。

![图3-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG-root-view-controller_2-1_2x.png)

根视图控制器可以从`UIWindow`对象的`rootViewController`属性访问。当使用storyboard来配置视图控制器时，UIKit会在启动时自动设置该属性的值。对于以编程方式创建的窗口，必须自己设置根视图控制器。

### 容器视图控制器

容器视图控制器允许使用更易于管理和可重用的界面来组装复杂的界面。容器视图控制器将一个或多个子视图控制器的内容与可选的自定义视图混合在一起，来创建其最终界面。例如，`UINavigationController`对象显示来自其子视图控制器的内容以及由其管理的导航栏和可选工具栏。UIKit包含多个容器视图控制器，包括`UINavigationController`、`UISplitViewController` 和`UIPageViewController`。

容器视图控制器的视图总是会填充给定的空间，其通常被指定为窗口的根视图控制器。容器视图控制器也可以以模态的方式呈现，或者作为其他容器的子项安装。下图显示了在容器并排放置两个子视图。

![图3-2](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG-container-acting-as-root-view-controller_2-2_2x.png)

由于容器视图控制器管理其子项，UIKit定义了如何在自定义容器中设置这些子项的规则。

### 呈现视图控制器

呈现一个视图控制器时，通常会隐藏当前视图控制器的内容来将当前视图控制器的内容替换为新视图控制器的内容。**呈现最常用于模态地显示新内容。**在呈现一个视图控制器时，UIKit会在呈现视图控制器和其呈现的视图控制器之间创建如下图所示的关系。

![图3-3](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG-presented-view-controllers_2-3_2x.png)

当呈现涉及到容器视图控制器时，UIKit可能会修改呈现链来简化必须编写的代码。不同的呈现风格对应的视图在屏幕上的显示方式有不同的规则，例如全屏呈现总是覆盖整个屏幕。在呈现一个视图控制器时，UIKit会查找为呈现提供合适上下文的视图控制器。在许多情况下，UIKit会选择最近的容器视图控制器，但也可能选择窗口的根视图控制器。在某些情况下，也可以直接告诉UIKit哪个视图控制器定义了呈现上下文，并且应该处理呈现。

下图显示了容器视图控制器为呈现提供上下文的原因。在执行全屏呈现时，新视图控制器需要覆盖整个屏幕。容器视图控制器决定是否处理呈现，而不需要其子视图控制器知道容器视图的边界。

![图3-4](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG-container-and-presented-view-controller_2-4_2x.png)

## 设计技巧

视图控制器是在iOS上运行的应用程序的基本工具，并且UIKit的视图控制器基础结构可以很容易地创建复杂的界面，而无需编写大量的代码。在实现我们自己的视图控制器时，请使用一下提示和指导原则，以确保我们不会干涉可能会干扰系统预期的自然行为。

### 尽可能使用系统提供的视图控制器

许多iOS框架定义了视图控制器，使用这些系统提供的视图控制器可一节省时间并确保为用户提供一致的体验。大多数系统控制器都是为特定任务而设计的某些控制器提供对用户数据（如联系人）的访问，也可能提供访问硬件或提供专门调整的界面来管理媒体。例如，UIKit中的`UIImagePickerController`类显示用于获取图片和视频以及访问用户相机胶卷的标准界面。

在创建自己的自定义视图控制器前，请查看现有的框架是否存在能够执行需要的任务的视图控制器：
- UIKit框架提供视图控制器用于显示弹窗警告，拍照和录像，以及管理iCloud上的文件。UIKit还定义许多可用于组织内容的标准容器视图控制器。
- GameKit框架提供了视图控制器可用于匹配玩家以及管理排行榜、成就和其他游戏功能。
- Address Book UI框架提供了用于显示和选择联系人信息的视图控制器。
- MediaPlayer框架提供了用于播放和管理视频以及从用户库中选择媒体资源的视图控制器。
- EventKit UI框架提供了用于显示和编辑用户日历数据的视图控制器。
- GLKit框架提供了用于管理OpenGL渲染界面的视图控制器。
- Multipeer Connectivity框架提供了用于检测其他用户并邀请他们进行连接的视图控制器。
- Message UI框架提供了用于撰写电子邮件和SMS消息的视图控制器。
- PassKit框架提供了用于显示通行证并将其添加到Passbook的视图控制器。
- Social框架为Twitter、Facebook和其他社交媒体网站提供了编辑消息的视图控制器。
- AVFoundation框架提供了用于显示媒体资源的视图控制器。

> **重要**：切勿修改系统提供的视图控制器的视图层次结构。每个视图控制器都拥有其视图层次结构，并负责维护该层次结构的完整性。进行更改可能会在代码中引入错误，或阻止其所属视图控制器的正常运行。使用系统视图控制器时，总是依靠视图控制器公开的可用方法和属性进行所有修改的。

有关使用特定视图控制器的信息，可查看相应框架的参考文档。

### 保证每个视图控制器独立运行

视图控制器应始终是自给自足的对象，没有视图控制器应该含有有关于另一个视图控制器的内部工作或视图层次结构的信息。在两个视图控制器需要来回通信或传递数据的情况下，它们应该始终使用明确定义的公共接口来实现。

代理设计模式经常用于管理视图控制器之间的通信。通过委托，一个对象定义了一个相关的委托对象进行通信的协议，该委托对象是任何符合该协议的对象。委托对象的确切类型是不重要的，重要的是它实现了协议的方法。

### 仅将根视图用作其他视图的容器

仅将视图控制器的根视图用作其余内容的容器。使用根视图作为容器可以为所有视图提供一个共同的父视图，这使得许多布局操作变得更简单。许多自动布局约束需要共同的父视图来正确布置视图。

### 知道数据该存在于哪里

在模型 - 视图 - 控制器设计模式中，视图控制器的作用是促进模型对象和视图对象之间的数据移动。视图控制器可能会将一些数据存储在临时变量中并执行一些验证，但其主要职责是确保其视图包含准确的信息。而模型数据对象负责管理实际数据并确保数据的完整性。

`UIDocument`和`UIViewController`类之间的关系就是一个数据和接口分离的例子。具体而言，两者之间不存在默认关系。`UIDocument`对象负责协调数据的加载和保存，而`UIViewController`对象协调屏幕上的视图显示。如果需要在两个对象之间创建关系，请记住视图控制器应该只缓存文档中的信息以提高效率，实际的数据仍然属于文档对象。

### 适应变化

应用程序可以在各种iOS设备上运行，并且视图控制器被设计为适应这些设备上不同大小的屏幕。并不是使用单独的视图控制器来管理不同屏幕上的内容，而是使用内置的适配性支持响应视图控制器中的大小和大小等级的更改。UIKit发送的通知使我们有机会对用户界面进行大规模和小规模的更改，而无需更改视图控制器代码的其余部分。

## 子类化视图控制器

### 设计UI

可以使用Xcode中的storyboard文件直观地定义视图控制器的UI，也可以以编程方式来创建UI。但storyboard可以将视图的内容可视化，并根据需要自定义视图层次结构。以可视化方式构建UI界面，可以让我们快速进行更改并能看到结果，而无需构建和运行应用程序。

下图显示了一个storyboard的例子。每个矩形区域代表一个视图控制器及其相关视图，视图控制器之间的箭头是视图控制器的关系和节点。关系将容器视图控制器连接到其子视图控制器。Segues可用于在界面中的视图控制器之间导航。

![图4-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/storyboard_bird_sightings_2x.png)

### 处理用户交互

应用程序的响应者对象会处理传入的事件，虽然视图控制器是响应者对象，但它们很少直接处理触摸事件。相反，视图控制器通常以下列方式处理事件：
- 视图控制器定义了处理更高级别事件的操作方法。行动方法回应：
    - 具体行动。控件和一些视图调用行动方法来报告特定的交互。
    - 手势识别器。手势识别器调用行动方法来报告手势的当前状态。使用视图控制器处理状态变更或响应已完成的手势。
- 视图控制器观察由系统或其他对象发出的通知，通知报告更改。通知也是视图控制器更新其状态的一种方式。
- 视图控制器充当另一个对象的数据源或委托。例如，可以将它们用作`CLLocationManager`对象的代理，该对象将更新的位置发送给其委托对象。

### 在运行时显示视图

storyboard加载和显示视图控制器视图的过程非常简单。当需要时，UIKit会自动从stroyboard文件中加载视图。作为加载过程的一部分，UIKit执行以下任务序列：
- 使用storyboard文件中的信息实例化视图。
- 连接所有的outlets和actions。
- 将根视图分配给视图控制器的视图属性。
- 调用视图控制器的`awakeFromNib`方法。调用此方法时，视图控制器的特征集合为空，视图可能不在其最终位置。
- 调用视图控制器的`viewDidLoad`方法。在此方法中添加或者删除视图，修改布局约束，并未视图加载数据。

在屏幕上显示视图控制器的视图之前，UIKit提供了额外的机会在视图显示前后来执行需要的操作。具体来说，UIKit执行以下任务序列：
- 在视图即将出现在屏幕上前，调用视图控制器的`viewWillAppear:`方法。
- 更新视图的布局。
- 在屏幕上显示视图。
- 视图显示后，调用视图控制器的`viewDidAppear:`方法。

添加、删除或修改视图的大小或者位置时，也要添加和删除适用于这些视图的任何约束。对视图层次结构进行与布局相关的更改会导致UIKit将布局标记为脏。在下一个更新周期中，布局引擎使用当前布局约束条件计算视图的大小和位置，并将这些更改应用于视图层次结构。

### 管理视图布局

当视图的大小和位置发生变化时，UIKit将更新视图层次结构的布局信息。对于使用Auto Layout配置的视图，UIKit将使用Auto Layout引擎根据当前约束来更新布局。UIKit还会通知其他感兴趣的对象（如正在呈现的控制器）布局发生更改，以便它们可以做出相应的响应。

在布局过程中，UIKit会在几个时间点发出通知，以便我们可以执行其他与布局相关的任务。使用这些用纸来修改布局约束，或者在应用布局约束后对布局进行最终的调整。在布局过程中，UIKit为每个受影响的视图控制器执行以下操作：
- 根据需要更新视图控制器及其视图的特征集合。
- 调用视图控制器的`viewWillLayoutSubviews`方法。
- 调用当前`UIPresentationController`的`containerViewWillLayoutSubviews`方法。
- 调用视图控制器的根视图的`layoutSubviews`方法。此方法默认使用可用的约束来计算新的布局信息。然后该方法遍历视图层，并调用每个子视图的`layoutSubviews`方法。
- 将计算的布局信息应用于视图。
- 调用视图控制器的`viewDidLayoutSubviews`方法。
- 调用当前`UIPresentationController`对象的`containerViewDidLayoutSubviews`方法。

视图控制器可以使用`viewWillLayoutSubviews`和`viewDidLayoutSubviews`方法来执行可能影响布局过程的附加更新。在布局之前，可以添加或删除视图，更新视图的大小或位置，更新约束或更新其他视图相关的属性。布局之后，可以重新加载表格数据，更新其他视图的内容，或对视图的大小和位置进行最终调整。

## 实现一个容器视图控制器

容器视图控制器是将多个视图控制器的内容合并到单个用户界面中的一种方法。容器视图控制器通常使导航变得容易，并基于现有内容创建新的用户界面类型。UIKit中容器视图控制器的示例包括`UINavigationController`、`UITabBarController`和`UISplitViewController`，它们都可以方便在用户界面的不同部分之间进行导航。

### 设计自定义容器视图控制器

几乎在任何情况下，容器视图控制器都像其他任何内容视图控制器一样管理根视图和一些内容。区别在于容器视图控制器从其他视图控制器获取其内容的一部分。其获取的内容仅限于其他视图控制器的视图，这些视图嵌入在其自己的根视图层次结构中。容器视图控制器设置任何嵌入视图的大小和位置，但原始视图控制器仍然管理这些视图内的内容。

在设计容器视图控制器时，需要始终了解容器和包含的视图控制器之间的关系。视图控制器的关系可以帮助告知它们的内容应该如何显示在屏幕上，以及容器如何在内部管理它们。在设计过程中，需要搞清楚以下几个问题：
- 容器的作用是什么？其子视图控制器扮演什么样的角色？
- 多少个子视图控制器同时显示？
- 同级子视图控制器之间有什么关系（如果有的话）？
- 子视图控制器如何添加到容器或从容器中移除？
- 子视图控制器的大小和位置能改变吗？这些变化在什么情况下发生？
- 容器是否提供任何装饰或导航相关的视图？
- 容器视图控制器和子视图控制器之间如何通信？容器是否需要向`UIViewController`类定义的标准事件报告特定的事件？
- 容器的外观是否可以用不同的方式配置？如果可以，如何实现？

在定义了各种对象的角色之后，容器视图控制器的实现相对简单。UIKit唯一的要求就是在容器视图控制器和任何子视图控制器之间建立正式的父子关系。父子关系确保子视图控制器收到任何相关的系统消息。除此之外，大部分的实际工作都是在包含视图的布局和管理过程中发生的，每个容器都是不同的。我们可以将视图放置在容器的内容区域的任何位置，然后根据需要调整视图的大小。还可以将自定义视图添加到视图层次结构中，以提供装饰或者辅助导航。

### 示例：导航控制器

`UINavigationController`对象支持通过分层数据集来导航。导航界面一次显示一个子视图控制器。界面顶部的导航栏显示数据层次结构中当前位置，并显示后退按钮以向后移动一个级别。向下导航到另一个子视图控制器，并将子视图控制器添加到数据层次结构中。

视图控制器之间的导航由导航控制器及其子视图控制器共同管理。当用户与子视图控制器的按钮或表格进行交互后，子视图控制器要求导航控制器将新的视图控制器推入视图。子视图控制器处理新的视图控制器的内容的配置，但导航控制器管理过渡动画。导航控制器还管理导航栏，该导航栏显示用于解除最顶层视图控制器的后退按钮。

下图显示了导航控制器及其视图的结构。大多数内容区域由最顶层的子视图控制器填充，只有一小部分被导航栏占用。

![图5-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_structure-of-navigation-interface_5-1_2x.png)

在紧凑和常规的状态下，导航控制器一次只显示一个子视图控制器。导航控制器调整其子视图控制器以适应可用空间。

### 示例：分割控制器

`UISplitViewController`对象以主要-细节排列方式来显示两个视图控制器的内容。在这种排列中，一个视图控制器（主视图）的内容决定了其他视图控制器显示的细节。两个视图控制器的可见性是可配置的，但也受到当前环境的支配。在规则的水平环境中，分割视图控制器可以同时显示两个子视图控制器，或者可以隐藏主视图控制器并根据需要显示。在紧凑的环境中，分割视图控制器一次只显示一个视图控制器。

下图显示了在一个常规的水平环境中的分割视图界面及其视图的结构。分割视图控制器本身只有默认的容器视图。在这个例子中，两个子视图是并排显示的。子视图的大小是可配置的，主视图的可见性也是可配置的。

![图5-2](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG-split-view-inerface_5-2_2x.png)

### 在Interface Builder中配置容器

要在设计时创建父子容器关系，需要将一个容器视图对象添加到视图控制器中，如下图所示。容器视图对象是代表子视图控制器内容的占位符对象。使用该视图来调整和定位与容器中其他视图相关的子视图。

![图5-3](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/container_view_embed_2x.png)

当使用一个或多个容器视图加载视图控制器时，Interface Builder还会加载与这些视图关联的子视图控制器。子视图控制器必须与父视图控制器同时实例化，以便建立适当的父子关系。

如果不使用Interface Builder来设置父 - 子容器关系，则必须通过将每个子项添加到容器视图控制器来以编程方式创建这些关系。

### 实现自定义容器视图控制器

要实现一个容器视图控制器，必须建立容器视图控制器和其子视图控制器之间的关系。在尝试管理任何子视图控制器的视图之前，建立这些父子关系是必需的。这样做让UIKit知道容器视图控制器正在管理子视图控制器的大小和位置。我们可以在Interface Builder中创建这些关系，或以编程方式创建它们。

#### 将子视图控制器添加到内容

要以编程方式将子视图控制器合并到内容中，请执行以下操作，在相关的视图控制器之间创建父子关系：
- 调用容器视图控制器的`addChildViewController:`方法，此方法告诉UIKit容器视图控制器现在正在管理子视图控制器的视图。
- 设置好子视图控制器内容的大小和位置，将子视图控制器的根视图添加到容器视图控制器的视图层次结构中。
- 添加任何约束来管理子视图控制器的根视图的大小和位置。
- 调用子视图控制器的`didMoveToParentViewController:`方法。

以下代码展示了如何在容器视图控制器中嵌入一个子视图控制器。建立父子关系后，容器视图控制器设置其子视图控制器内容的框架，并将子视图控制器的根视图添加到自己的视图层次结构中。设置子视图控制器的根视图的大小很重要，能够确保视图在容器中正确显示。在添加视图之后，容器视图控制器调用子视图控制器的`didMoveToParentViewController:`方法，以使子视图控制器有机会响应视图所有权的更改。
```
- (void) displayContentController: (UIViewController*) content {
    [self addChildViewController:content];
    content.view.frame = [self frameForContentController];
    [self.view addSubview:self.currentClientView];
    [content didMoveToParentViewController:self];
}
```
**注意**，在上面的例子中，只调用了子视图控制器的`didMoveToParentViewController:`方法。容器视图控制器的`addChildViewController:`方法只会调用子视图控制器的`willMoveToParentViewController:`方法，我们必须自己手动调用子视图控制器的`didMoveToParentViewController:`。因为只有在将子视图嵌入容器的视图层次结构中后，才能调用此方法。

使用自动布局时，在将子对象添加到容器的视图层次结构后，在容器和子对象之间设置约束。添加的约束只会影响子视图控制器的根视图的大小和位置。请勿直接更改子视图层次结构中的根视图或任何其他视图的内容。

#### 移除子视图控制器

要从那个容器视图控制器中删除子视图控制器，可以通过执行以下操作来删除视图控制器之间的父子关系：
- 调用子视图控制器的`willMoveToParentViewController:`方法且传入的值为`nil`。
- 删除为子视图控制器的根视图配置的约束。
- 从容器视图控制器的视图层中移除该子视图控制器的根视图。
- 调用子视图控制器的`removeFromParentViewController`方法来结束父子关系。

删除子视图控制器会永久切断容器视图控制器与子视图控制器之间的关系。只有当不再需要引用子视图控制器时，才能移除子视图控制器。例如，当一个新视图控制器推入导航堆栈时，导航控制器并不会移除当前的子视图控制器。只有当它们从堆栈中弹出时，才会被删除。

以下代码显示了如何从容器视图控制器中删除子视图控制器。调用子视图控制器的`willMoveToParentViewController:`方法且传入`nil`值为子视图控制器提供了为更改做准备的机会。子视图控制器的`removeFromParentViewController`方法还会调用其`didMoveToParentViewController:`方法其传入`nil`值。将容器视图控制器设置为`nil`，也会从容器中删除子视图。
```
- (void) hideContentController: (UIViewController*) content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}
```

#### 子视图控制器之间的过渡转换动画

当需要用一个子视图控制器动画替换另一个子视图控制器时，可以将子视图控制器的添加和删除合并到过渡转换动画过程中。在执行动画前，请确保两个子视图控制器都是容器视图控制器内容的一部分，但是让当前的子视图控制器知道它即将被移除。在动画过程中，将新子视图控制器的视图移动到位并移除旧子视图控制器的视图。动画完成后，移除旧子视图控制器。

以下代码显示了如何使用过渡转换动画将一个子视图控制器替换成另一个子视图控制器的示例。在这个示例中，`transitionFromViewController:toViewController:duration:options:animations:completion:`方法会自动更新容器视图控制器的视图层次机构，不需要我们自己手动添加和删除视图。
```
- (void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC {
    // Prepare the two view controllers for the change.
    [oldVC willMoveToParentViewController:nil];
    [self addChildViewController:newVC];

    // Get the start frame of the new view controller and the end frame
    // for the old view controller. Both rectangles are offscreen.
    newVC.view.frame = [self newViewStartFrame];
    CGRect endFrame = [self oldViewEndFrame];

    // Queue up the transition animation.
    [self transitionFromViewController: oldVC toViewController: newVC
    duration: 0.25 options:0
    animations:^{
    
        // Animate the views to their final positions.
        newVC.view.frame = oldVC.view.frame;
        oldVC.view.frame = endFrame;
        
    }completion:^(BOOL finished) {
        // Remove the old view controller and send the final
        // notification to the new view controller.
        [oldVC removeFromParentViewController];
        [newVC didMoveToParentViewController:self];
    }];
}
```

#### 管理子视图控制器的外观更新

在将子视图控制器添加到容器视图控制器后，容器视图控制器会自动将外观相关的消息转发给子视图控制器。大多数情况下，这样能确保所有事件都正确发生。但是，有时默认行为可能会以无意义的顺序发送这些事件。例如，如果多个子视图控制器同时改变其视图状态，则可能需要合并这些更改，以使外观回调都以更合理的顺序同时发生。

要接管外观回调的责任，需要覆写容器视图控制器的`shouldAutomaticallyForwardAppearanceMethods`方法并返回`NO`。
```
- (BOOL) shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}
```
当有过渡转换动画发生时，根据需要调用子视图控制器的`beginAppearanceTransition:animated:`或者`endAppearanceTransition`方法。
```
-(void) viewWillAppear:(BOOL)animated {
    [self.child beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated {
    [self.child endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated {
    [self.child beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated {
    [self.child endAppearanceTransition];
}
```

#### 自定义容器视图控制器的几点建议

设计、开发和测试新的容器视图控制器需要时间。虽然每个视图控制器的行为是直截了当的，但整体控制起来可能相当复杂。在自定义容器控制器时，请考虑以下提示：
- 只访问子视图控制器的根视图。容器视图控制器只能访问每个子视图控制器的根视图，也就是子视图控制器的`view`属性，它不应该访问任何子视图控制器的其他视图。
- 子视图控制器应该对其容器视图控制器有最少的了解。子视图控制器应该关注自己的内容。如果容器视图控制器允许其行为受到子视图控制器的影响，则应该使用委托设计模式来管理这些交互。
- 首选使用常规视图来设计容器视图控制器。使用常规视图（而不是来自子视图控制器的视图）使我们有机会在简单的环境中测试布局约束和动画过渡转换。当常规视图能按照预期工作时，再将常规视图替换成子视图控制器的视图。

#### 将控制委派给子视图控制器

容器视图控制器可以将其自身外观的某些方面委托给其一个或多个子视图控制器。可以通过以下方式委派控制权：
- 让一个子视图控制器确定状态栏的样式。要将状态栏外观委托给子视图控制器，需要覆写容器视图控制器的`childViewControllerForStatusBarStyle`和`childViewControllerForStatusBarHidden`方法中的一个或者两个。
- 让子视图控制器指定自己的尺寸。具有灵活布局的容器视图控制器可以使用其子视图控制器的`preferredContentSize`属性来帮助确定子视图控制器的大小。

## 支持辅助功能

iOS系统为了帮助盲人进行人机交互，设计了VoiceOver读屏技术。VoiceOver能够读出屏幕上的信息，其属于辅助功能的一部分。有关让`UIViewController`支持辅助功能的详细信息，请参看[Supporting Accessibility](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/SupportingAccessibility.html#//apple_ref/doc/uid/TP40007457-CH12-SW1)。

## 保存和恢复状态

视图控制器在应用程序状态保存和恢复过程中起着重要作用。状态保存会在应用程序被挂起之前保存其当前配置，以便后续应用程序启动时恢复之前的配置。将应用程序恢复到以前的配置为用户节省来时间，并提供来更好的用户体验。

保存和恢复过程大都是自动的，但是需要我们告知系统应用程序的哪些部分要保存。保存应用程序的视图控制器的步骤如下：
- （必需）将恢复标识符分配给要保留其配置的视图控制器。
- （必需）告诉系统如何在启动时创建或定位新的视图控制器对象。
- （可选）对于每个视图控制器，存储能将视图控制器返回到其之前配置所需的任何特定配置数据。

有关保存和恢复过程的概述，可以参看[App Programming Guide for iOS](https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007072)。

### 标记需要保存的视图控制器

UIKit只会保存被标记需要保存的视图控制器。每个视图控制器都有一个`restorationIdentifier`属性，其默认值为`nil`，为该属性设置有效的字符串值将告诉UIKit应该保存视图控制器及其视图。我们可以以编程方式或在storyboard中为视图控制器分配恢复标识符。

**分配恢复标识符时，一定要记住，当前视图控制器层次结构中的所有父视图控制器也必须具有恢复标识符。**在保存过程中，UIKit从window的根视图控制器开始，遍历当前视图控制器层次结构。如果该层次结构中的视图控制器没有恢复标识符，则视图控制器及其所有子视图控制器和呈现的视图控制器都将被忽略。

### 选择有效的恢复标识符

UIKit会使用我们分配的恢复标识符去重新创建视图控制器，所以需要选择容易被代码识别的字符串来作为恢复标识符。如果UIKit无法自动创建一个视图控制器，其会要求我们自己手动创建，并为我们提供视图控制器及其所有父视图控制器的恢复标识符。这个标识符链标表示视图控制器的恢复路径，以及如何确定正在请求哪个视图控制器。恢复路径从根视图控制器开始，直至所请求的视图控制器。

恢复标识符通常是视图控制器的类名。如果在许多地方使用相同的类，则可能需要分配更有意义的值。例如，可以根据视图控制器管理的数据分配一个字符串。

每个视图控制器的恢复路径必须是唯一的。如果容器视图控制器有两个子视图控制器，容器视图控制器必须为每个子视图控制器分配一个唯一的恢复标识符。UIKit中的一些容器视图控制器会自动消除其子视图控制器的歧义，使得我们可以为每个子视图控制器使用相同的恢复标识符。例如，`UINavigationController`类会根据其子视图控制器在导航堆栈中的位置给其子视图控制器添加信息。

### 排除视图控制器组

要在恢复过程中排除整个视图控制器组，请将父视图控制器的恢复标识符设置为`nil`。下图显示了将视图控制器层次结构中的视图控制器的恢复标识符设为`nil`的影响。

![图7-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/state_vc_caveats_2x.png)

排除一个或者多个视图控制器并不会在随后的恢复过程中完全移除这些视图控制器。在应用程序启动时，任何视图控制器都是应用程序的默认配置的一部分，它们仍然会被创建，如下图所示。

![图7-2](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/state_vc_caveats_2_2x.png)

在自动保存过程中排除视图控制器并不会阻止我们去手动保存它。在恢复归档中，保存对视图控制器的引用可以保留视图控制器及其状态信息。例如，如果图7-1中的应用程序委托保存了导航控制器的三个子项，则它们的状态将被保留。在还原期间，应用程序委托可以重新创建这些视图控制器并将其推送到导航控制器的堆栈中。

### 保存视图控制器的视图

一些视图具有与视图相关的附加状态信息，例如我们可能想保存滚动视图的滚动位置。当视图控制器负责提供滚动视图的内容时，滚动视图本身负责保持其视觉状态。

要保存视图的状态，需要执行以下操作：
- 为视图的`restorationIdentifier`属性分配一个有效的字符串。
- 使用也具有有效的恢复标识符的视图控制器中的视图。
- 对于表视图和集合视图，分配一个遵循`UIDataSourceModelAssociation`协议的数据源对象。

为视图分配一个恢复标识符将告知UIKit应该将视图的状态写入恢复归档，当视图控制器稍后被恢复时，UIKit还恢复具有恢复标识符的任何视图的状态。

### 在应用程序启动时恢复视图控制器

在应用程序启动时，UIKit会尝试将应用程序恢复到之前的状态。此时，UIKit会要求应用程序创建（或定位）包含之前保存的用户界面的视图控制器。UIKit在尝试定位视图控制器时，会按照以下顺序去搜索：
1. 如果视图控制器有恢复类，UIkit会要求该类提供视图控制器。UIKit会调用关联的恢复类的`viewControllerWithRestorationIdentifierPath:coder:`方法来检索视图控制器。如果该方法返回`nil`，UIkit会假定应用程序不用重新创建视图控制器并且会停止查找。
2. 如果视图控制器没有关联恢复类，UIKit会要求应用程序委托提供视图控制器。UIKit调用应用程序委托的`application:viewControllerWithRestorationIdentifierPath:coder:`方法来查找没有恢复类的视图控制器。如果该方法返回`nil`，UIKit将尝试隐式查找视图控制器。
3. 如果具有正确恢复路径的视图控制器已经存在，UIKit就会使用该视图控制器对象。如果应用程序在启动时创建视图控制器（以编程方式或者从storyboard中加载），且视图控制器具有恢复标识符，则UIKit会根据其恢复路径隐式查找它们。
4. 如果视图控制器最初是从storyboarrd中加载的，则UIKit使用保存的storyboard信息来定位和创建它。UIKit将有关视图控制器的storyboard信息保存在恢复归档中，在恢复时，UIKit使用该信息来定位相同的storyboard文件，并且会在使用任何其他方式都没有查找到视图控制器的情况下实例化相应的视图控制器。

为视图控制器分配一个恢复类可以避免UIKit隐式地检索该视图控制器。使用恢复类可以更好地控制是否真的要创建视图控制器。例如，如果恢复类确定不应该重新创建视图控制器，则`viewControllerWithRestorationIdentifierPath:coder:`方法可以返回`nil`。当没有恢复类时，UIkit会尽其所能找到或者创建视图控制器，并将其恢复。

当使用恢复类时，`viewControllerWithRestorationIdentifierPath:coder:`方法应该创建一个类的新实例对象，执行最低限度的初始化，并返回结果对象。以下代码展示了一个如何使用此方法从storyboard中加载视图控制器的例子。由于视图控制器最初是从storyboard加载的，因此此方法使用`UIStateRestorationViewControllerStoryboardKey`键值从存档中获取storyboard。**注意，此方法不会尝试配置视图控制器的数据内容。当视图控制器的状态被解码后，才会去配置视图控制器的数据内容。**
```
+ (UIViewController*)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    MyViewController* vc;
    UIStoryboard* sb = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    if (sb) {
        vc = (PushViewController*)[sb instantiateViewControllerWithIdentifier:@"MyViewController"];
        vc.restorationIdentifier = [identifierComponents lastObject];
        vc.restorationClass = [MyViewController class];
    }
    return vc;
}
```
在手动重新创建视图控制器时，重新分配恢复标识符和恢复类是一个好习惯。恢复恢复标识符的最简单方法是获取`identifierComponents`数组中的最后一项，并将其分配给视图控制器。

对于在应用程序启动时从**main storyboard**文件中创建的对象，请勿为每个对象创建新的实例。请让UIKit隐式查找这些对象，或者使用应用程序委托对象的`application:viewControllerWithRestorationIdentifierPath:coder:`方法来查找现有对象。

### 编码和解码视图控制器的状态

对于每个要保存的对象，UIKit都会调用对象的`encodeRestorableStateWithCoder:`方法，使其有机会保存其状态。在恢复过程中，UIKit会调用对应的`decodeRestorableStateWithCoder:`方法来解码该状态并将其用于对象。对于视图控制器，这些方法的实现是可选的，但建议实现。可以使用它们来保存和恢复以下类型的信息：
- 关联引用所显示的任何数据（不是数据本身）。
- 对于容器视图控制器，关联引用其子视图控制器。
- 与当前选择有关的信息。
- 对于具有用户可配置视图的视图控制器，提供关于该视图当前配置的信息。

在编码和解码方法中，可以对编码器支持的对象和任何数据类型进行编码。对于除视图和视图控制器以外的所有对象，对象必须遵循`NSCoding`协议，并使用该协议的方法来写入其状态。对于视图和视图控制器，编码器并不使用`NSCoding`协议来保存对象的状态。取而代之的是，编码器保存对象的恢复标识符并将其添加到可保存对象的列表中，这会导致对象的`encodeRestorableStateWithCoder:`方法被调用。

在实现视图控制器的`encodeRestorableStateWithCoder:`和`decodeRestorableStateWithCoder:`方法时，必须调用`super`的该方法。调用`super`的该方法让父类有机会保存和恢复任何附加信息。以下代码展示来这些方法的一个示例实现，它们保存用于标识指定视图控制器的数字值。
```
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];

    [coder encodeInt:self.number forKey:MyViewControllerNumber];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];

    self.number = [coder decodeIntForKey:MyViewControllerNumber];
}
```
编码器对象在编码和解码过程并不共享。每个具有可保存状态的对象都会接收到自己的编码器对象。使用各自的编码器意味着我们不用担心密钥之间的命名空间冲突。但是，请不要使用`UIApplicationStateRestorationBundleVersionKey`、`UIApplicationStateRestorationUserInterfaceIdiomKey`和`UIStateRestorationViewControllerStoryboardKey`键名称。UIKit使用这些键来存储关于视图控制器状态的附加信息。

有关实现视图控制器的编码和解码的更多信息，请参看[UIViewController Class Reference](https://developer.apple.com/documentation/uikit/uiviewcontroller)。

### 保存和恢复视图控制器的几点建议

在视图控制器中添加对状态保存和恢复的支持时，请考虑一下准则：
- 请记住，我们可能不像保留所有视图控制器。在某些情况下，保留视图控制器可能没有意义。例如，如果应用程序正在显示更改，则可能需要取消操作并将应用程序还原到上一个屏幕。在这种情况下，我们不需要保留要求输入新密码信息的视图控制器。
- 避免在恢复过程中换掉视图控制器对象所属的类。状态保存系统对它保存的视图控制器的类进行进行编码。在恢复过程中，如果应用程序返回的对象的类不匹配（或者不是原始对象的子类），则系统不会要求视图控制器解码任何状态信息。
- 状态保存系统希望我们按照预期使用视图控制器。恢复过程依赖于视图控制器的包含关系来重建界面。如果我们没有正确使用容器视图控制器，保存系统将找不到视图控制器。例如，除非在相应的视图控制器之间存在包含关系，否则不要将视图控制器的视图嵌入到不同的视图中。

## 呈现一个视图控制器

在屏幕上显示视图控制器有两种方法：将其嵌入到容器视图控制器中或者呈现它。容器视图控制器提供了一个应用程序的主要导航，但正在被呈现的视图控制器也是一个重要的导航工具。我们可以使用呈现来在当前视图控制器上层直接显示一个新的视图控制器。通常情况下，在实现模态界面时，我们需要呈现一个视图控制器，但也可以将其用于其他目的。

`UIViewController`类支持呈现一个视图控制器，并可用于所有视图控制器对象。我们可以使用任何视图控制器来呈现其他的任何视图控制器，但UIKit可能会将请求重新路由到不同的视图控制器。正在被呈现的视图控制器会在其和呈现它的起始视图控制器之间创建一种关系，正在被呈现的视图控制器是起始视图控制器的`presentedViewController`，起始视图控制器是正在被呈现的视图控制器的`presentingViewController`。这种关系构成了视图控制器层次结构的一部分，并保持原样直到视图控制器被从屏幕上移除。

### 呈现和转场过渡过程

呈现一个视图控制器是将新内容动画化到屏幕上的快捷方式。内置于UIKit中的呈现机制允许我们使用内置或者自定义的动画显示一个新的视图控制器。实现内置的呈现和动画只需要很少的代码，UIKit会处理所有的工作。我们也可以创建自定义的呈现和动画，只需要少许额外处理，就能将其用于任何视图控制器。

#### 呈现样式

视图控制器的呈现样式控制其在屏幕上的外观。UIKit定义了许多标准的呈现样式，每种风格都有特定的外观和意图。我们也可以定义我们自己的自定义呈现样式。在设计应用程序时，请选择最适合我们正在尝试呈现的视图控制器界面的样式，并为视图控制器的`modalPresentationStyle`属性分配合适的值。

##### 全屏样式

全屏样式覆盖整个屏幕，防止与底层内容的交互。在水平常规环境中，只有一种全屏样式完全覆盖了底层内容。其他的全屏样式都包含遮罩视图或透明视图，以允许显示一部分底层视图控制器。在水平紧凑环境中，全屏呈现会自动适应`UIModalPresentationFullScreen`样式并覆盖所有底层内容。

下图显示了在水平常规环境中使用`UIModalPresentationFullScreen`，`UIModalPresentationPageSheet`和`UIModalPresentationFormSheet`样式被呈现的视图控制器的外观。在图中，左上方的绿色视图控制器呈现右上角的蓝色视图控制器，每种呈现样式的结果如下所示。对于某些呈现样式，UIKit会在两个视图控制器的内容之间插入遮罩视图。

![图8-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_PresentationStyles%20_fig_8-1_2x.png)

> **注意**：使用`UIModalPresentationFullScreen`样式来呈现视图控制器时，UIKit通常会在转场动画完成后删除底层视图控制器的视图。可以通过指定`UIModalPresentationOverFullScreen`样式来防止删除底层视图。当被呈现的视图控制器具有让底层视图内容显示的透明区域时，可以使用此样式。

当使用一种全屏呈现样式时，起始视图控制器必须覆盖整个屏幕。如果起始视图控制器没有覆盖整个屏幕，则UIKit逐步向上查看视图控制器层次结构，直到找到一个有效的视图控制器来全屏呈现另一个视图控制器。 如果找不到填充屏幕的中间视图控制器，则UIKit将使用窗口的根视图控制器。

##### 弹出样式

`UIModalPresentationPopover`样式在弹出视图中显示视图控制器。弹出样式对于显示附加信息或者与焦点、选定对象相关的项目列表非常有用。在水平常规环境中，弹出视图仅覆盖部分屏幕，如下图所示。在水平紧凑的环境中，默认情况下，弹出视图会适应`UIModalPresentationOverFullScreen`呈现样式。点击弹出视图之外的屏幕会自动移除弹出视图。

![图8-2](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_popover-style_2x.png)

因为弹出窗口会适配在水平紧凑环境中的全屏呈现，所以通常需要修改弹出窗口代码来处理适配。在全屏模式下，需要一种方法来移除被呈现的弹出窗口。可以通过添加一个按钮，将弹出窗口嵌入到一个可用的容器视图控制器中，或者改变适配行为本身。

##### 当前上下文样式

`UIModalPresentationCurrentContext`样式覆盖了界面中的特定视图控制器。使用上下文样式时，通过将视图控制器的`definesPresentationContext`属性值设为`YES`来指定要覆盖此视图控制器。下图显示了一个当前上下文样式的呈现，它只覆盖了分割视图控制器的一个子视图控制器。

![图8-3](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_CurrentContextStyles_2x.png)

> **注意**：当使用`UIModalPresentationFullScreen`样式来呈现一个视图控制器时，UIKit通常会在转场动画执行完成后删除处于被呈现的视图控制器之下的视图控制器的视图。可以通过指定`UIModalPresentationOverCurrentContext`样式来防止删除这些视图。当被呈现的视图控制器具有让底层内容显示的透明区域时，可以使用该样式。

定义了呈现上下文的视图控制器也可以定义在呈现过程中使用的转场动画。通常情况下，UIKit使用起始视图控制器的`modalTransitionStyle`属性值来在屏幕上动画视图控制器。如果呈现上下文视图控制器的`providesPresentationContextTransitionStyle`属性值为`YES`，则UIKit将使用该视图控制器的`modalTransitionStyle`属性值。

当切换到水平紧凑环境（横屏）时，当前上下文样式会适应`UIModalPresentationFullScreen`样式。要更改此行为，请使用自适应呈现委托来指定不同的呈现样式或视图控制器。

##### 自定义呈现样式

转场过渡呈现样式确定了用于呈现一个视图控制器的动画类型。对于官方提供的转场过渡呈现样式，可以将其中一种标准样式分配给需要呈现的视图控制器的`modalTransitionStyle`属性。呈现一个视图控制器时，UIKit会创建与该样式相对应的动画。例如，下图说明了标准的`UIModalTransitionStyleCoverVertical`滑动转场过渡样式如何为屏幕上的视图控制器生成动画。视图控制器B开始进入屏幕时，动画滑动到视图控制器A的顶部上方。当视图控制器B被移除时，动画反转，以便B向下滑动以显示A。

![图8-4](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_SlideTransition_fig_8-1_2x.png)


