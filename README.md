# UIViewController详解

## 概述

视图控制器管理着构成应用程序用户界面中的一部分视图，其负责加载和处理这些视图，管理与这些视图的交互，并协调视图对其展示的数据内容的变更作出响应。视图控制器还能与其他视图控制器对象协调工作，帮助管理应用程序的整体界面。

视图控制器的主要职责包括以下内容：
- 更新视图的内容来响应底层数据的变化。
- 响应用户与视图的交互。
- 调整视图尺寸并管理整个界面的布局。

## 视图控制器的作用

视图控制器是应用程序内部结构的基础。每个应用程序至少含有一个视图控制器，大多数应用程序都含有多个视图视图控制器。每个视图控制器管理着应用程序的用户界面，以及该界面和底层数据之间的交互。视图控制器也便于在不同用户界面之间的转换。

`UIViewController`类定义了一些方法和属性来管理视图、处理事件、从一个视图控制器切换到另一个视图控制器和协调应用程序的其他部分，可以通过继承`UIViewController`（或其子类之一）来添加实现应用程序行为所需的自定义代码。

有两种类型的视图控制器：
- 内容视图控制器，其管理着应用程序内容的一部分。
- 容器视图控制器，其收集来自于其他视图控制器的信息并以便于导航的方式呈现或者以不同方式呈现这些视图控制器的内容。

### 视图管理

视图控制器最重要的作用是管理视图的层次结构。每个视图控制器都含有一个包含所有视图控制器内容的根视图，可以添加需要显示内容的视图到该根视图中。下图显示了视图控制器和视图之间的内置关系，视图控制器总是具有对其根视图的强引用，并且每个视图都具有对其子视图的强引用。

![图2-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_ControllerHierarchy_fig_1-1_2x.png)

内容视图控制器自己管理其包含的所有视图，容器视图控制器管理其所包含的所有视图以及来自其一个或多个子视图控制器的**根视图**。容器视图控制器并不管理其子视图控制器的内容，只管理其子视图控制器的根视图。下图说明了`UISplitViewController`与其子视图控制器之间的关系。`UISplitViewController`管理其子视图的整体尺寸和位置，但子视图控制器管理这些视图的实际内容。

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

视图控制器负责呈现其视图，并使该呈现适应底层环境。每个iOS应用程序都应该能够在iPad上运行，并且可以在几种不同尺寸的iPhone上运行。不是为每个设备提供不同的视图控制器和视图层，而是使用单个视图控制器来更简单地调整其视图以适应不断变化的空间需求。

在iOS中，视图控制器需要处理粗粒度的变化和细粒度的变化。当视图控制器的特性改变时，会发生粗粒度的变化。特征是描述整体环境的属性，例如显示比例。其中两个最重要的特性是视图控制器的水平和垂直尺寸类别，是它们表示视图控制器在给定维度中有多少空间。可以使用size class changes来改变布局视图的方式，如下图所示。如果horizontal size class是规则的，视图控制器利用额外的水平空间来排列其内容。如果horizontal size class是紧凑的，视图控制器垂直排列其内容。

![图2-4](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_SizeClassChanges_fig_1-4_2x.png)

根据给定的size class，可以随时进行更细粒度的尺寸更改。当用户将iPhone从纵向旋转到横向时，size class可能不会改变，但屏幕尺寸通常会改变。在使用自动布局时，UIKt会自动调整视图的尺寸和位置以匹配新维度。视图控制器可以根据需要进行其他调整。

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

### 呈现一个视图控制器

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

应用程序可以在各种iOS设备上运行，并且视图控制器被设计为适应这些设备上不同尺寸的屏幕。并不是使用单独的视图控制器来管理不同屏幕上的内容，而是使用内置的适配性支持响应视图控制器中的尺寸和size class的更改。UIKit发送的通知使我们有机会对用户界面进行大规模和小规模的更改，而无需更改视图控制器代码的其余部分。

## 子类化视图控制器

### 设计UI

可以使用Xcode中的storyboard文件直观地定义视图控制器的UI，也可以以编程方式来创建UI。但storyboard可以将视图的内容可视化，并根据需要自定义视图层次结构。以可视化方式构建UI界面，可以让我们快速进行更改并能看到结果，而无需构建和运行应用程序。

下图显示了一个storyboard的例子。每个矩形区域代表一个视图控制器及其相关视图，视图控制器之间的箭头是视图控制器的关系和节点。关系将容器视图控制器连接到其子视图控制器。Segue可用于在界面中的视图控制器之间导航。

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

添加、删除或修改视图的尺寸或者位置时，也要添加和删除适用于这些视图的任何约束。对视图层次结构进行与布局相关的更改会导致UIKit将布局标记为脏。在下一个更新周期中，布局引擎使用当前布局约束条件计算视图的尺寸和位置，并将这些更改应用于视图层次结构。

### 管理视图布局

当视图的尺寸和位置发生变化时，UIKit将更新视图层次结构的布局信息。对于使用Auto Layout配置的视图，UIKit将使用Auto Layout引擎根据当前约束来更新布局。UIKit还会通知其他感兴趣的对象（如正在呈现的控制器）布局发生更改，以便它们可以做出相应的响应。

在布局过程中，UIKit会在几个时间点发出通知，以便我们可以执行其他与布局相关的任务。使用这些用纸来修改布局约束，或者在应用布局约束后对布局进行最终的调整。在布局过程中，UIKit为每个受影响的视图控制器执行以下操作：
- 根据需要更新视图控制器及其视图的特征集合。
- 调用视图控制器的`viewWillLayoutSubviews`方法。
- 调用当前`UIPresentationController`的`containerViewWillLayoutSubviews`方法。
- 调用视图控制器的根视图的`layoutSubviews`方法。此方法默认使用可用的约束来计算新的布局信息。然后该方法遍历视图层，并调用每个子视图的`layoutSubviews`方法。
- 将计算的布局信息应用于视图。
- 调用视图控制器的`viewDidLayoutSubviews`方法。
- 调用当前`UIPresentationController`对象的`containerViewDidLayoutSubviews`方法。

视图控制器可以使用`viewWillLayoutSubviews`和`viewDidLayoutSubviews`方法来执行可能影响布局过程的附加更新。在布局之前，可以添加或删除视图，更新视图的尺寸或位置，更新约束或更新其他视图相关的属性。布局之后，可以重新加载表格数据，更新其他视图的内容，或对视图的尺寸和位置进行最终调整。

## 实现一个容器视图控制器

容器视图控制器是将多个视图控制器的内容合并到单个用户界面中的一种方法。容器视图控制器通常使导航变得容易，并基于现有内容创建新的用户界面类型。UIKit中容器视图控制器的示例包括`UINavigationController`、`UITabBarController`和`UISplitViewController`，它们都可以方便在用户界面的不同部分之间进行导航。

### 设计自定义容器视图控制器

几乎在任何情况下，容器视图控制器都像其他任何内容视图控制器一样管理根视图和一些内容。区别在于容器视图控制器从其他视图控制器获取其内容的一部分。其获取的内容仅限于其他视图控制器的视图，这些视图嵌入在其自己的根视图层次结构中。容器视图控制器设置任何嵌入视图的尺寸和位置，但原始视图控制器仍然管理这些视图内的内容。

在设计容器视图控制器时，需要始终了解容器和包含的视图控制器之间的关系。视图控制器的关系可以帮助告知它们的内容应该如何显示在屏幕上，以及容器如何在内部管理它们。在设计过程中，需要搞清楚以下几个问题：
- 容器的作用是什么？其子视图控制器扮演什么样的角色？
- 多少个子视图控制器同时显示？
- 同级子视图控制器之间有什么关系（如果有的话）？
- 子视图控制器如何添加到容器或从容器中移除？
- 子视图控制器的尺寸和位置能改变吗？这些变化在什么情况下发生？
- 容器是否提供任何装饰或导航相关的视图？
- 容器视图控制器和子视图控制器之间如何通信？容器是否需要向`UIViewController`类定义的标准事件报告特定的事件？
- 容器的外观是否可以用不同的方式配置？如果可以，如何实现？

在定义了各种对象的角色之后，容器视图控制器的实现相对简单。UIKit唯一的要求就是在容器视图控制器和任何子视图控制器之间建立正式的父子关系。父子关系确保子视图控制器收到任何相关的系统消息。除此之外，大部分的实际工作都是在包含视图的布局和管理过程中发生的，每个容器都是不同的。我们可以将视图放置在容器的内容区域的任何位置，然后根据需要调整视图的尺寸。还可以将自定义视图添加到视图层次结构中，以提供装饰或者辅助导航。

### 示例：导航控制器

`UINavigationController`对象支持通过分层数据集来导航。导航界面一次显示一个子视图控制器。界面顶部的导航栏显示数据层次结构中当前位置，并显示后退按钮以向后移动一个级别。向下导航到另一个子视图控制器，并将子视图控制器添加到数据层次结构中。

视图控制器之间的导航由导航控制器及其子视图控制器共同管理。当用户与子视图控制器的按钮或表格进行交互后，子视图控制器要求导航控制器将新的视图控制器推入视图。子视图控制器处理新的视图控制器的内容的配置，但导航控制器管理过渡动画。导航控制器还管理导航栏，该导航栏显示用于解除最顶层视图控制器的后退按钮。

下图显示了导航控制器及其视图的结构。大多数内容区域由最顶层的子视图控制器填充，只有一小部分被导航栏占用。

![图5-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_structure-of-navigation-interface_5-1_2x.png)

在紧凑和常规的状态下，导航控制器一次只显示一个子视图控制器。导航控制器调整其子视图控制器以适应可用空间。

### 示例：分割控制器

`UISplitViewController`对象以主要-细节排列方式来显示两个视图控制器的内容。在这种排列中，一个视图控制器（主视图）的内容决定了其他视图控制器显示的细节。两个视图控制器的可见性是可配置的，但也受到当前环境的支配。在规则的水平环境中，分割视图控制器可以同时显示两个子视图控制器，或者可以隐藏主视图控制器并根据需要显示。在紧凑的环境中，分割视图控制器一次只显示一个视图控制器。

下图显示了在一个常规的水平环境中的分割视图界面及其视图的结构。分割视图控制器本身只有默认的容器视图。在这个例子中，两个子视图是并排显示的。子视图的尺寸是可配置的，主视图的可见性也是可配置的。

![图5-2](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG-split-view-inerface_5-2_2x.png)

### 在Interface Builder中配置容器

要在设计时创建父子容器关系，需要将一个容器视图对象添加到视图控制器中，如下图所示。容器视图对象是代表子视图控制器内容的占位符对象。使用该视图来调整和定位与容器中其他视图相关的子视图。

![图5-3](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/container_view_embed_2x.png)

当使用一个或多个容器视图加载视图控制器时，Interface Builder还会加载与这些视图关联的子视图控制器。子视图控制器必须与父视图控制器同时实例化，以便建立适当的父子关系。

如果不使用Interface Builder来设置父 - 子容器关系，则必须通过将每个子项添加到容器视图控制器来以编程方式创建这些关系。

### 实现自定义容器视图控制器

要实现一个容器视图控制器，必须建立容器视图控制器和其子视图控制器之间的关系。在尝试管理任何子视图控制器的视图之前，建立这些父子关系是必需的。这样做让UIKit知道容器视图控制器正在管理子视图控制器的尺寸和位置。我们可以在Interface Builder中创建这些关系，或以编程方式创建它们。

#### 将子视图控制器添加到内容

要以编程方式将子视图控制器合并到内容中，请执行以下操作，在相关的视图控制器之间创建父子关系：
- 调用容器视图控制器的`addChildViewController:`方法，此方法告诉UIKit容器视图控制器现在正在管理子视图控制器的视图。
- 设置好子视图控制器内容的尺寸和位置，将子视图控制器的根视图添加到容器视图控制器的视图层次结构中。
- 添加任何约束来管理子视图控制器的根视图的尺寸和位置。
- 调用子视图控制器的`didMoveToParentViewController:`方法。

以下代码展示了如何在容器视图控制器中嵌入一个子视图控制器。建立父子关系后，容器视图控制器设置其子视图控制器内容的框架，并将子视图控制器的根视图添加到自己的视图层次结构中。设置子视图控制器的根视图的尺寸很重要，能够确保视图在容器中正确显示。在添加视图之后，容器视图控制器调用子视图控制器的`didMoveToParentViewController:`方法，以使子视图控制器有机会响应视图所有权的更改。
```
- (void) displayContentController: (UIViewController*) content {
    [self addChildViewController:content];
    content.view.frame = [self frameForContentController];
    [self.view addSubview:self.currentClientView];
    [content didMoveToParentViewController:self];
}
```
**注意**，在上面的例子中，只调用了子视图控制器的`didMoveToParentViewController:`方法。容器视图控制器的`addChildViewController:`方法只会调用子视图控制器的`willMoveToParentViewController:`方法，我们必须自己手动调用子视图控制器的`didMoveToParentViewController:`。因为只有在将子视图嵌入容器的视图层次结构中后，才能调用此方法。

使用自动布局时，在将子对象添加到容器的视图层次结构后，在容器和子对象之间设置约束。添加的约束只会影响子视图控制器的根视图的尺寸和位置。请勿直接更改子视图层次结构中的根视图或任何其他视图的内容。

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

#### 子视图控制器之间的转场动画

当需要用一个子视图控制器动画替换另一个子视图控制器时，可以将子视图控制器的添加和删除合并到转场动画过程中。在执行动画前，请确保两个子视图控制器都是容器视图控制器内容的一部分，但是让当前的子视图控制器知道它即将被移除。在动画过程中，将新子视图控制器的视图移动到位并移除旧子视图控制器的视图。动画完成后，移除旧子视图控制器。

以下代码显示了如何使用转场动画将一个子视图控制器替换成另一个子视图控制器的示例。在这个示例中，`transitionFromViewController:toViewController:duration:options:animations:completion:`方法会自动更新容器视图控制器的视图层次机构，不需要我们自己手动添加和删除视图。
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
当有转场动画发生时，根据需要调用子视图控制器的`beginAppearanceTransition:animated:`或者`endAppearanceTransition`方法。
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
- 首选使用常规视图来设计容器视图控制器。使用常规视图（而不是来自子视图控制器的视图）使我们有机会在简单的环境中测试布局约束和转场动画。当常规视图能按照预期工作时，再将常规视图替换成子视图控制器的视图。

#### 将控制委派给子视图控制器

容器视图控制器可以将其自身外观的某些方面委托给其一个或多个子视图控制器。可以通过以下方式委派控制权：
- 让一个子视图控制器确定状态栏的样式。要将状态栏外观委托给子视图控制器，需要覆写容器视图控制器的`childViewControllerForStatusBarStyle`和`childViewControllerForStatusBarHidden`方法中的一个或者两个。
- 让子视图控制器指定自己的尺寸。具有灵活布局的容器视图控制器可以使用其子视图控制器的`preferredContentSize`属性来帮助确定子视图控制器的尺寸。

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

### 呈现和转场动画过程

呈现一个视图控制器是将新内容动画化到屏幕上的快捷方式。内置于UIKit中的呈现机制允许我们使用内置或者自定义的动画显示一个新的视图控制器。实现内置的呈现和动画只需要很少的代码，UIKit会处理所有的工作。我们也可以创建自定义的呈现和动画，只需要少许额外处理，就能将其用于任何视图控制器。

#### 呈现样式

视图控制器的呈现样式控制其在屏幕上的外观。UIKit定义了许多标准的呈现样式，每种风格都有特定的外观和意图。我们也可以定义我们自己的自定义呈现样式。在设计应用程序时，请选择最适合我们正在尝试呈现的视图控制器界面的样式，并为视图控制器的`modalPresentationStyle`属性分配合适的值。

##### 全屏样式

全屏样式覆盖整个屏幕，防止与底层内容的交互。在水平常规环境中，只有一种全屏样式完全覆盖了底层内容。其他的全屏样式都包含遮罩视图或透明视图，以允许显示一部分底层视图控制器。在水平紧凑环境中，全屏呈现会自动适应`UIModalPresentationFullScreen`样式并覆盖所有底层内容。

下图显示了在水平常规环境中使用`UIModalPresentationFullScreen`，`UIModalPresentationPageSheet`和`UIModalPresentationFormSheet`样式被呈现的视图控制器的外观。在图中，左上方的绿色视图控制器呈现右上角的蓝色视图控制器，每种呈现样式的结果如下所示。对于某些呈现样式，UIKit会在两个视图控制器的内容之间插入遮罩视图。

![图8-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_PresentationStyles%20_fig_8-1_2x.png)

> **注意**：使用`UIModalPresentationFullScreen`样式来呈现视图控制器时，UIKit通常会在转场动画完成后删除底层视图控制器的视图。可以通过指定`UIModalPresentationOverFullScreen`样式来防止删除底层视图。当被呈现的视图控制器具有让底层视图内容显示的透明区域时，可以使用此样式。

当使用一种全屏呈现样式时，起始视图控制器必须覆盖整个屏幕。如果起始视图控制器没有覆盖整个屏幕，则UIKit逐步向上查看视图控制器层次结构，直到找到一个有效的视图控制器来全屏呈现另一个视图控制器。 如果找不到填充屏幕的中间视图控制器，则UIKit将使用窗口的根视图控制器。

##### Popover样式

`UIModalPresentationPopover`样式在Popover中显示视图控制器。弹出样式对于显示附加信息或者与焦点、选定对象相关的项目列表非常有用。在水平常规环境中，Popover仅覆盖部分屏幕，如下图所示。在水平紧凑的环境中，默认情况下，Popover会适应`UIModalPresentationOverFullScreen`呈现样式。点击弹出视图之外的屏幕会自动移除Popover。

![图8-2](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_popover-style_2x.png)

因为Popover会自动适配在水平紧凑环境中的全屏呈现，所以通常需要修改Popover代码来处理适配。在全屏模式下，需要一种方法来移除被呈现的Popover。可以通过添加一个按钮，将Popover嵌入到一个可用的容器视图控制器中，或者改变适配行为本身。

##### 当前上下文样式

`UIModalPresentationCurrentContext`样式覆盖了界面中的特定视图控制器。使用上下文样式时，通过将视图控制器的`definesPresentationContext`属性值设为`YES`来指定要覆盖此视图控制器。下图显示了一个当前上下文样式的呈现，它只覆盖了分割视图控制器的一个子视图控制器。

![图8-3](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_CurrentContextStyles_2x.png)

> **注意**：当使用`UIModalPresentationFullScreen`样式来呈现一个视图控制器时，UIKit通常会在转场动画执行完成后删除处于被呈现的视图控制器之下的视图控制器的视图。可以通过指定`UIModalPresentationOverCurrentContext`样式来防止删除这些视图。当被呈现的视图控制器具有让底层内容显示的透明区域时，可以使用该样式。

定义了呈现上下文的视图控制器也可以定义在呈现过程中使用的转场动画。通常情况下，UIKit使用起始视图控制器的`modalTransitionStyle`属性值来在屏幕上动画视图控制器。如果呈现上下文视图控制器的`providesPresentationContextTransitionStyle`属性值为`YES`，则UIKit将使用该视图控制器的`modalTransitionStyle`属性值。

当切换到水平紧凑环境（横屏）时，当前上下文样式会适应`UIModalPresentationFullScreen`样式。要更改此行为，请使用自适应呈现委托来指定不同的呈现样式或视图控制器。

##### 自定义呈现样式

`UIModalPresentationCustom`样式允许我们使用自己定义的自定义样式来呈现一个视图控制器。创建自定义样式需要子类化`UIPresentationController`，并使用其方法来将任何自定义视图动画到屏幕上，同时设置需要被呈现的视图控制器的尺寸和位置。起始控制器还处理由于其所呈现的视图控制器的特性的变化而发生的任何适应。

#### 转场过渡样式

转场过渡样式确定了用于呈现一个视图控制器的动画类型。对于官方提供的转场过渡呈现样式，可以将其中一种标准样式分配给需要呈现的视图控制器的`modalTransitionStyle`属性。呈现一个视图控制器时，UIKit会创建与该样式相对应的动画。例如，下图说明了标准的`UIModalTransitionStyleCoverVertical`滑动转场过渡样式如何为屏幕上的视图控制器生成动画。视图控制器B开始进入屏幕时，动画滑动到视图控制器A的顶部上方。当视图控制器B被移除时，动画反转，以便B向下滑动以显示A。

![图8-4](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_SlideTransition_fig_8-1_2x.png)

可以使用动画对象和转场过渡委托来创建自定义转场。动画对象创建用于将视图控制器显示到屏幕上的过渡动画。转场过渡委托在适当的时候将动画对象提供给UIKit。

#### 呈现一个视图控制器的方式

UIViewController类提供了两种方式来显示视图控制器：
- `showViewController:sender:`和`showDetailViewController:sender:`方法提供了最适应和最灵活的方式来显示视图控制器。这些方法让起始控制器决定如何最好地处理呈现。例如，容器视图控制器可以让视图控制器作为一个子视图控制器来呈现，而不是以模态方式呈现。默认行为以模态方式呈现一个视图控制器。
- `presentViewController:animated:completion:`方式总是模态显示视图控制器。调用此方法的视图控制器可能最终不会处理此次呈现，但呈现始终是模态的。这种方法会适应在水平紧凑环境中的呈现样式。

`showViewController:sender:`和`showDetailViewController:sender:`方法是发起呈现的首选方式。视图控制器可以调用它们而不知道视图控制器层次结构的其余部分或当前视图控制器在该层次结构中的位置。这些方法可以在不编写条件代码路径的情况下，在应用程序的不同部分重新使用视图控制器。

### 呈现一个视图控制器

有以下几种方式来发起视图控制器的呈现：
- 使用segue自动呈现视图控制器。segue使用在Interface Builder中指定的信息来实例化并呈现视图控制器。
- 使用`showViewController:sender:`和`showDetailViewController:sender:`方法来显示视图控制器。在自定义视图控制器中，可以将这些方法的行为更改为更适合我们的视图控制器的行为。
- 调用`presentViewController:animated:completion:`方法以模态方式呈现视图控制器。

#### 显示视图控制器

当使用`showViewController:sender:`和`showDetailViewController:sender:`方法时，将新视图控制器添加到屏幕上的过程很简单：
- 创建需要呈现的视图控制器对象。在创建视图控制器时，需要使用任何需要执行其任务的数据对其进行初始化。
- 将视图控制器的`modalPresentationStyle`属性设置为需要的样式。这种样式可能不会在最终呈现中使用。
- 将视图控制器的`modalTransitionStyle`属性设置为需要的转场过渡动画样式。这种样式可能不会在最终呈现中使用。
- 调用当前视图控制器的`showViewController:sender:`和`showDetailViewController:sender:`方法。

UIKit会将对`showViewController:sender:`和`showDetailViewController:sender:`方法的调用转发给合适的视图控制器。该视图控制器可以决定如何最好地执行呈现，并可以根据需要更改呈现样式和转场过渡样式。例如，导航控制器可能会将视图控制器推到其导航堆栈上。

#### 模态呈现视图控制器

当直接呈现视图控制器时，需要告诉UIKit如何显示新的视图控制器以及如何动画显示到屏幕上：
- 创建需要呈现的视图控制器对象。在创建视图控制器时，需要使用任何需要执行其任务的数据对其进行初始化。
- 将视图控制器的`modalPresentationStyle`属性设置为需要的样式。
- 将视图控制器的`modalTransitionStyle`属性设置为需要的转场过渡动画样式。
- 调用当前视图控制器的`presentViewController:animated:completion:`方法。

调用`presentViewController:animated:completion:`方法的视图控制器可能不是实际发起模态呈现的视图控制器。呈现样式决定来如何呈现视图控制器，包括发起呈现的视图控制器所需的特性。例如，全屏呈现必须由覆盖全屏的视图控制器发起。如果当前视图控制器不合适，UIKit将遍历视图控制器层次结构，直到找到一个为止。UIKit在完成模态呈现后，会更新受影响的视图控制器的`presentingViewController`和`presentedViewController`属性。

#### 在Popover中呈现一个视图控制器

在呈现Popover之前，需要一些额外配置。在设置模态呈现样式为`UIModalPresentationPopover`后，配置以下与Popover相关的属性：
- 将视图控制器的`preferredContentSize`属性设置为所需的尺寸。
- 访问视图控制器的`popoverPresentationController`属性获得与其相关联的`UIPopoverPresentationController`对象，并使用该对象来设置Popover的锚点。只需要设置下列之一：
    - 将`barButtonItem`属性值设为一个`UIBarButtonItem`对象。
    - 将`sourceView`属性值设置为当前视图层中的某个视图，`sourceRect`属性值设置为`sourceView`中的某个特定区域。
    
可以使用`UIPopoverPresentationController`对象根据需要对Popover的外观进行其他调整。Popover控制器对象还支持设置委托对象来响应在呈现过程中的更改。例如，当Popover出现、消失或在屏幕上重新定位时，可以使用委托对象来响应。有关此对象的更多信息，可以参阅[UIPopoverPresentationController Class Reference](https://developer.apple.com/documentation/uikit/uipopoverpresentationcontroller)。

### 移除被呈现的视图控制器

要移除当前被呈现的视图控制器，需要调用该视图控制器的`dismissViewControllerAnimated:completion:`方法。也可以调用呈现该视图控制器的起始视图控制器的该方法来移除当前被呈现的视图控制器。当调用起始视图控制器的该方法时，UIKit会自动将移除请求转发给被呈现的视图控制器。

在移除视图控制器之前，请总是保持视图控制器中的重要信息。移除视图控制器会将其从视图控制器层次结构中删除，并将其视图从屏幕上移除。如果没有强引用该视图控制器，移除该视图控制器将释放与之关联的内存。

如果被呈现的视图控制器必须传输数据给发起呈现的视图控制器，则使用委托设计模式来促进传输。委托可以使在应用程序的不同部分来重用视图控制器变得简单。使用委托，被呈现的视图控制器会存储对实现来协议方法的委托对象的引用。当被呈现的视图控制器需要接收数据时，其会调用委托对象的协议方法。

### 在不同storyboard文件中的视图控制器之间发起呈现

我们可以在同一个storyboard文件中的视图控制器之间创建segue，但不能在不同storyboard文件中的视图控制器之间创建segue。当需要呈现一个存储在不同storyboard文件中的视图控制器时，必须在呈现其之前明确地实例化这个视图控制器，如下所示。该示例以模态方式呈现视图控制器，但我们也可以将其推到导航堆栈上或以其他方式显示。
```
UIStoryboard* sb = [UIStoryboard storyboardWithName:@"SecondStoryboard" bundle:nil];
MyViewController* myVC = [sb instantiateViewControllerWithIdentifier:@"MyViewController"];

// Configure the view controller.

// Display the view controller
[self presentViewController:myVC animated:YES completion:nil];
```

## 使用Segue

使用segue来定义应用程序界面的跳转流程。segue定义了storyboard文件中的两个视图控制器之间的转换。segue的起始点是启动segue的按钮、表格行或者手势识别器。segue的结束点是想要显示的视图控制器。segue总是呈现一个新的视图控制器，但是也可以使用unwind segue来移除视图控制器。

![图9-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/segue_defined_2x.png)

我们不需要以编程方式触发segue。在运行时，UIKit加载与视图控制器相关联的segue，并将它们连接到相应的元素。当用户与元素产生交互时，UIKit会加载相应的视图控制器，通知应用程序即将触发segue，并执行转换。可以使用UIKit发送的通知将数据传递到新的视图控制器或者防止此种情况发生。

### 在视图控制器之间创建一个segue

要在同一个storyboard文件中的视图控制器之间创建一个segue，请按住`Control`键并单击第一个视图控制器中的相应元素，然后拖动到目标视图控制器。segue的起始点必须是具有已经定义了action的视图或者对象，例如control、bar button item或者gesture recognizer。也可以从基于单元格的视图（如table view和collection view）创建segue。下图显示了创建一个当单元格被点击时显示一个新视图控制器的segue。

![图9-2](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/segue_creating_2x.png)

> **注意**：某些元素支持关联多个segue。例如，可以为cell上的button点击配置一个segue，同时也可以为cell点击配置另一个segue。

当松开鼠标按钮时，Interface Builder会提示我们选择要在两个视图控制器之间创建的关系类型，如下图所示。选择符合我们需要的转换的segue。

![图9-3](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/segue_creating_relationships_2x.png)

当为segue选择关系类型时，尽可能选择一个自适应segue。自适应segue会根据当前屏幕环境调整其行为。例如，Show segue的行为基于需要呈现的视图控制器而改变。非自适应segue适用于必须在iOS 7系统运行的应用程序。以下列出了自适应segue类型以及它们在应用程序中的行为：
- **Show (Push)** : 该segue使用目标视图控制器的`showViewController:sender:`方法来显示新的内容。对于大多数视图控制器，该segue在源视图控制器上以模态方式呈现新内容。一些视图控制器专门覆盖该方法并使用它来实现不同的行为。例如，导航控制器将新的视图控制器推到其导航堆栈上。UIKit使用`targetViewControllerForAction:sender:`方法来定位源视图控制器。
- **Show Detail (Replace)** : 该segue使用目标视图控制器的`showDetailViewController:sender:`方法来显示新的内容。其仅与嵌入在`UISplitViewController`对象内的视图控制器有关。通过该segue，分割视图控制器用新的内容替换它的第二个子视图控制器（细节控制器）。大多数其他控制器以模态方式呈现新内容。UIKit使用`targetViewControllerForAction:sender:`方法来定位源视图控制器。
- **Present Modally** : 该segue使用指定的呈现样式和转场过渡样式以模态方式显示视图控制器。定义了相应的呈现上下文的视图控制器会处理实际的呈现。
- **Present as Popover** : 在水平常规屏幕环境中，视图控制器显示在popover中。在水平紧凑屏幕环境中，视图控制器使用全屏呈现样式来被显示。

创建一个segue之后，选中segue对象并使用属性检查器为其分配一个标识符。在执行segue时，可以使用标识符来确定哪个segue被触发。如果视图控制器支持多个segue，那么这样做是特别有用的。标识符包含在执行segue时传递给视图控制器的`UIStoryboardSegue`对象中。

### 在运行时修改segue的行为

下图显示了当一个segue被触发时发生了什么。大多数工作发生在发起呈现的视图控制器中，其管理着到新视图控制器的转场过渡。新视图控制器的配置与以编码方式创建视图控制器并呈现它的过程基本相同。由于是在storyboard文件中配置segue，所以与segue关联的两个视图控制器必须在同一个storyboard文件中。

![图9-4](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_displaying-view-controller-using-segue_9-4_2x.png)

在执行segue期间，UIKit调用当前视图控制器的方法来提供机会让我们影响segue的结果。
- `shouldPerformSegueWithIdentifier:sender:`方法提供了阻止segue执行的机会。该方法返回`NO`会导致segue执行失败，但不会阻止其他行为的发生。例如，点击tableview的cell仍然会导致tableview调用任何相关的委托方法。
- 源视图控制器的`prepareForSegue:sender:`方法允许我们将数据从源视图控制器传递到目标视图控制器。传递给该方法的`UIStoryboardSegue`对象包含对目标视图控制器的引用以及其他与segue相关的信息。

### 创建一个unwind segue

unwind segue能够移除已经被呈现的视图控制器。可以在Interface Builder中通过关联一个按钮或者其他合适的对象到当前视图控制器的Exit对象来创建unwind segue。当用户点击按钮或者与适当的对象交互时，UIKit会搜索视图控制器层次结构来找到一个能够处理unwind segue的对象。然后移除当前视图控制器和任何中间视图控制器来展示与unwind segue关联的目标视图控制器。

创建一个unwind segue遵循以下步骤：
1. 选择unwind segue执行结束后应该显示在屏幕上的视图控制器。
2. 在选择的视图控制器中定义一个unwind 操作方法，这个操作方法的Objective-C语法为`- (IBAction)myUnwindAction:(UIStoryboardSegue*)unwindSegue`
3. 导航到发起unwind segue的视图控制器。
4. 按住Control键点击执行unwind segue的按钮（或其他对象）。该按钮（或其他对象）应该存在于需要被移除的视图控制器中。
5. 拖动到视图控制器顶部的`Exit`对象。
6. 在relationship panel中选择unwind操作方法。

![图9-5](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/segue_unwind_linking_2x.png)

在Interface Builder中创建相应的unwind segue之前，必须在发起unwind segue的视图控制器中定义一个unwind操作方法。该方法的存在是必需的，其告知Interface Builder有一个有效的unwind segue目标。

使用unwind操作方法的实现来执行应用程序中特定的任何任务。UIKit会自动移除视图控制器，而不需要我们手动移除发起segue的任何视图控制器。可以使用segue对象获取正在被移除的视图控制器，以便从其中回收数据。也可以使用unwind操作方法在unwind segue结束之前更新当前视图控制器。

### 以编程方式发起segue

segue通常是由在storyboard文件中创建的连接触发的。但是，有时可能无法在storyboard文件中创建segue，可能是因为无法确定目标视图控制器。例如，游戏应用程序可能会根据游戏的结果转场过渡到不同的界面。在这些情况下，可以使用当前视图控制器的`performSegueWithIdentifier:sender:`方法编程方式出发segue。

以下代码演示了从纵向到横向旋转时呈现特定视图控制器的segue。因为这种情况下的通知对象没有提供执行segue命令的有用信息，视图控制器就将自己指定为segue的发起者。
```
- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !isShowingLandscapeView)
    {
        [self performSegueWithIdentifier:@"DisplayAlternateView" sender:self];
        
        isShowingLandscapeView = YES;
    }
    // Remainder of example omitted.
}
```

### 创建自定义的segue

Interface Builder提供了从一个视图控制器转换到另一个视图控制器的所有标准方式。如果这些方式不能满足需求，也可以创建一个自定义segue。

#### segue的生命周期

要理解自定义segue如何工作，就需要了解segue对象的生命周期。segue对象是`UIStoryboardSegue`类或其子类的实例，应用程序永远不会直接创建segue对象。当一个segue被触发时，UIKit会自动创建segue对象。以下是segue被触发时所发生的事情：
1. 创建并初始化需要呈现的视图控制器。
2. 创建segue对象并调用其`initWithIdentifier:source:destination:`方法来初始化。`identifier`是在Interface Builder中为segue提供的唯一字符串，另外两个参数为参与转换的两个视图控制器对象。
3. 调用发起呈现的视图控制器的`prepareForSegue:sender:`方法。
4. 调用segue对象的`perform`方法。该方法执行转换以将新的视图控制器显示在屏幕上。
5. 释放被引用的segue对象。

#### 实现一个自定义segue

为了实现一个自定义segue，需要子类化`UIStoryboardSegue`并实现以下方法：
- 覆写`initWithIdentifier:source:destination:`方法，并使用该方法来初始化自定义的segue对象。需要首先调用`super`。
- 实现`perform`方法并使用该方法来配置转场过渡动画。

> **注意**：如果自定义segue类中添加了配置segue的属性，是无法在Interface Builder中配置这些属性的。但可以在触发segue的源视图控制器的`prepareForSegue:sender:`方法中配置自定义segue的附加属性。

以下代码展示了一个简单的自定义segue，其只是简单的呈现了目标视图控制器，没有使用任何动画，但可以根据需要来扩展该它。
```
- (void)perform
{
    // Add your own animation code here.

    [[self sourceViewController] presentViewController:[self destinationViewController] animated:NO completion:nil];
}
```

# 自定义转场动画

转场动画提供了与应用程序的界面更改有关的视觉反馈。UIKit提供了一组用于呈现一个视图控制器的标准转场动画样式，我们也可以使用自定义转场动画来实现特定的视觉效果。

## 转场动画序列

转场动画将一个视图控制器的内容替换为另一个视图控制器的内容。有两种类型的转场：present和dismiss。present转场会将新的视图控制器添加到应用程序的视图控制器结构层次中，而dismiss转场会从视图控制器层次结构中移除一个或者多个视图控制器。

实现转场动画需要许多对象协同工作。UIKit提供了转场过程中涉及的所有对象的默认版本，我们可以自定义所有对象或者仅仅子类化UIKit提供的默认对象。

### 转场动画委托对象

转场动画委托对象是转场动画和自定义呈现的起点，它是我们定义的遵循`UIViewControllerTransitioningDelegate`协议的对象。其工作是为UIKit提供以下对象：
- **Animator对象**：animator对象负责创建用于显示或者隐藏视图控制器的动画。转场动画委托对象可以提供对应的animator对象来呈现和移除视图控制器。animator对象需要遵循`UIViewControllerAnimatedTransitioning`协议。
- **交互式animator对象**：交互式animator对象使用触摸事件或者手势识别器来驱动自定义动画的校时，其遵循`UIViewControllerInteractiveTransitioning`协议。创建交互式animator对象的最简单方法是子类化`UIPercentDrivenInteractiveTransition`类并添加事件处理代码到子类中。其控制着动画的校时。如果需要自行创建特定的交互式animator对象，则必须自己渲染动画的每一帧。
- **Presentation controller**：presentation controller管理着视图控制器在屏幕上显示时的呈现样式。系统为内置的呈现样式提供了presentation controller，我们也可以为自定义的呈现样式提供自定义的presentation controller。

为视图控制器的`transitioningDelegate`属性值分配一个转场动画委托对象会告知UIKit需要执行自定义转场。转场动画委托对象可以选择其自身提供的对象。如果我们没有提供animator对象，则UIKit在视图控制器的`modalTransitionStyle`属性中使用标准转场动画。

图10-1显示了转场动画委托和animator对象与被呈现的视图控制器的关系。仅当视图控制器的`modalPresentationStyle`属性值设为`UIModalPresentationCustom`时，才使用presentation controller。

![图10-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_custom-presentation-and-animator-objects_10-1_2x.png)

### 自定义动画序列

当需要呈现的视图控制器的`transitioningDelegate`属性包含一个有效对象时，UIKit会使用我们提供的自定义animator对象来呈现此视图控制器。在准备转场动画时，UIKit会调用转场动画委托的`animationControllerForPresentedController:presentingController:sourceController:`方法来检索自定义animator对象。如果有对象可用，UIKit将执行以下步骤：
1. UIKit调用转场动画委托的`interactionControllerForPresentation:`方法来查看交互式animator对象是否可用。如果该方法返回`nil`，UIKit将执行动画而不需要发生用户交互。
2. UIKit调用animator对象的`transitionDuration:`方法来获取动画时长。
3. UIKit调用适当的方法来启动动画：
    - 对于非交互式动画，UIKit调用animator对象的`animateTransition:`方法。
    - 对于交互式动画，UIKit调用交互式animator对象的`startInteractiveTransition:`方法。
4. UIKit等待aniamtor对象调用转场动画上下文对象的`completeTransition:`方法。自定义animator对象会在动画执行完毕后，在动画的completion block中调用该方法。调用该方法结束了转场动画，并告知UIKit可以调用`presentViewController:animated:completion:`方法中的completion handler以及animator对象的`animationEnded:`方法。

移除视图控制器时，UIKit会调用转场动画委托的`animationControllerForDismissedController:`方法并执行以下步骤：
1. UIKit调用转场动画委托的`interactionControllerForDismissal:`方法来查看交互式animator对象是否可用。如果该方法返回`nil`，UIKit将执行动画而不需要发生用户交互。
2. UIKit调用animator对象的`transitionDuration:`方法来获取动画时长。
3. UIKit调用适当的方法来启动动画：
    - 对于非交互式动画，UIKit调用aniamtor对象的`animateTransition:`方法。
    - 对于交互式动画，UIKit调用交互式animator对象的`startInteractiveTransition:`方法。
4. UIKit等待animator对象调用转场动画上下文对象的`completeTransition:`方法。自定义animator对象会在动画执行完毕后，在动画的completion block中调用该方法。调用该方法结束了转场动画，并告知UIKit可以调用`dismissViewControllerAnimated:completion:`方法中的completion handler以及animator对象的`animationEnded:`方法。

> **重要**：在动画结束时调用`completeTransition:`方法是必需的。在调用该方法之前，UIKit不会结束转场动画并将控制器返回给应用程序。

### 转场动画上下文对象

在转场动画开始执行前，UIKit会创建一个转场动画上下文对象，该转场动画上下文对象会保存关于如何执行动画的信息。转场动画上下文对象是我们代码的重要组成部分，它实现了`UIViewControllerContextTransitioning`协议并存储对转场动画中涉及的视图控制器和视图的引用。它还存储有关如何执行转场动画的信息，包括动画是否为交互式。animator对象需要所有这些信息来设置和执行实际的动画。

> **重要**：在设置自定义动画时，请始终使用转场动画上下文对象中的对象和数据，不要使用自己管理的任何缓存信息。转场动画可能发生在各种情况下，其中一些情况可能会改变动画参数。转场动画上下文对象能够保证执行动画所需的信息正确，而在调用animator对象的方法时，我们自己缓存的信息可能已经过时。

图10-2显示了转场动画上下文对象如何与其他对象进行交互。animator对象在其`animateTransition:`方法中接收转场动画上下文对象，我们创建的动画应该在应该在提供的容器视图中执行。例如，当呈现一个视图控制器时，将该视图控制器的视图添加到容器视图中。容器视图可能是window或者常规视图，但其始终被配置去执行动画。

![图10-2](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_transitioning-context-object_10-2_2x.png)

有关转场动画上下文对象的更多信息，请参看[UIViewControllerContextTransitioning Protocol Reference](https://developer.apple.com/documentation/uikit/uiviewcontrollercontexttransitioning)。

### 转场动画协调器

对于系统提供的转场动画和自定义动画，UIKit都会创建一个转场动画协调器对象来促成我们可能需要执行的任何额外动画。除了呈现和移除视图控制器外，当屏幕旋转或者视图控制器的frame更改时，也可能会触发转场动画。所有的转场动画都意味着对视图层次结构的更改。转场动画协调器是一种跟踪这些更高并同时执行额外动画的方式。要访问转场动画协调器，请获取参与转场的视图控制器的`transitionCoordinator`属性，转场动画协调器仅在转场动画执行过程中存在。

图10-3显示了转场动画协调器与参与转换的视图控制器之间的关系。使用转场动画协调器获取有关转场动画的信息，并注册想要与转场动画一起同时执行的动画块。转场动画协调器遵循`UIViewControllerTransitionCoordinatorContext`协议，该协议提供时间信息、有关动画当前状态的信息以及转场过程中涉及的视图和视图控制器。当注册的动画快被执行时，同样会接收到一个具有含有相同信息的转场动画上下文对象。

![图10-3](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_transition-coordinator-objects_10-3_2x.png)

有关转场动画协调器对象的更多信息，请参看[UIViewControllerTransitionCoordinator Protocol Reference](https://developer.apple.com/documentation/uikit/uiviewcontrollertransitioncoordinator?language=objc)。
有关可用于配置动画的上下文信息的信息，请参看[UIViewControllerTransitionCoordinatorContext Protocol Reference](https://developer.apple.com/documentation/uikit/uiviewcontrollertransitioncoordinatorcontext?language=objc)。

## 使用自定义动画来呈现一个视图控制器

要使用自定义动画来呈现一个视图控制器，需要在现有视图控制器的操作方法中执行以下操作：
1. 创建需要呈现的视图控制器。
2. 创建自定义转场动画委托对象并将其分配给视图控制器的`transitioningDelegate`属性。转场动画委托的方法应该在被访问前创建并返回自定义的animator对象。
3. 调用`presentViewController:animated:completion:`方法来呈现视图控制器。

当我们调用`presentViewController:animated:completion:`方法时，UIKit会启动转场。转场会在runloop的下一周期开始执行并继续，直到自定义animator对象调用`completeTransition:`方法。交互式转场允许我们在转场过程中处理触摸事件，但非交互式转场会在aniamtor对象指定的持续时间内运行。

## 实现转场动画委托方法

转场动画委托的目的是创建并返回自定义animator对象。以下代码展示了转场动画委托方法的实现是多么简单。本示例创建并返回一个自定义aniamtor对象，大部分实际工作都由aniamtor对象本身处理。
```
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    MyAnimator* animator = [[MyAnimator alloc] init];
    return animator;
}
```
转场动画委托的其他方法的实现与上面的方法一样简单。可以结合自定义逻辑，根据应用程序的当前状态返回不同的aniamtor对象。有关转场动画委托方法的更多信息，可以参看[UIViewControllerTransitioningDelegate Protocol Reference](https://developer.apple.com/documentation/uikit/uiviewcontrollertransitioningdelegate?language=objc)。

## 实现自定义animator对象

animator对象是任何符合`UIViewControllerAnimatedTransitioning`协议的对象。animator对象创建在固定时间段内执行的动画。aniamtor对象的关键是其`animateTransition:`方法，可以使用该方法来创建实际的动画。动画过程大致分为以下几个部分：
1. 获取动画参数。
2. 使用Core Animation或者UIView动画方法创建动画。
3. 清理并完成转场动画。

### 获取动画参数

传递给`animateTransition:`方法的转场动画上下文对象包含执行动画时需要使用的数据。绝对不要使用自己的缓存信息或者从视图控制器获取的信息，因为可以从转场动画上下文对象中获取更多最新信息，并且呈现和移除视图控制器时会涉及视图控制器之外的对象。例如，使用presentation controller可能会添加一个背景视图作为呈现内容的一部分。转场动画上下文对象会考虑额外的视图和对象，并为我们提供正确的视图去执行动画。

- 两次调用`viewControllerForKey:`方法以获得转场过程中涉及的“from”和“to”视图控制器。**切勿**假设我们已经知道哪些视图控制器参与了转场，UIKit可能会在适应新的屏幕特性环境或者响应该应用程序的请求时更改视图控制器。
- 调用`containerView`方法来获取动画的容器视图，并将所有关键子视图添加到此视图上。例如，在呈现期间，将被呈现的视图控制器的视图添加到此视图。
- 调用`viewForKey:`方法获取需要被添加或者移除的视图。视图控制器的视图可能不是在转场动画期间添加或者删除的唯一视图。presentation controller可能会将某些视图插入到视图层次结构中，这些视图也必须被添加或者删除。`viewForKey:`方法返回包含需要添加或者删除的所有内容的根视图。
- 调用`finalFrameForViewController:`方法来获取被添加或者删除的视图的最终`frame`。

转场动画上下文对象使用“from”和“to”命名来标识转场中涉及的视图控制器、视图和frame。“from"视图控制器始终是其视图在转场动画刚开始时就在屏幕上的视图控制器，而“to”视图控制器是其视图在转场动画结束时可见的视图控制器。如图10-4所示，“from”和“to”视图控制器在呈现和移除之间交换位置。

![图10-4](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_from-and-to-objects_10-4_2x.png)

对于呈现视图控制器，请将“from”视图添加到容器视图层次结构中。对于移除视图控制器，请从容器视图层次结构中移除“from”视图。

### 创建转场动画

在典型的转场过程中，需要呈现的视图控制器的视图动画显示到屏幕上。其他视图也可能执行动画，该动画属于整个转场动画的一部分。动画的主要目标始终是视图被添加到视图层次结构中。

- 呈现动画：
    - 使用`viewControllerForKey:`和`viewForKey:`方法来得到转场过程中涉及的视图控制器和视图。
    - 设置"to"视图的起始位置，以及设置其他任何属性的起始值。
    - 从转场动画上下文对象的`finalFrameForViewController:`方法获取“to”视图的最终位置。
    - 添加“to”视图到容器视图上。
    - 创建动画。
        - 在动画Block中，将“to”视图从起始位置动画到在容器视图中的最终位置。同时，将其他任何属性也设置为它们的最终值。
        - 在完成Block中，调用`completeTransition:`方法并执行任何其他清理。

- 移除动画：
    - 使用`viewControllerForKey:`和`viewForKey:`方法来得到转场过程中涉及的视图控制器和视图。
    - 计算"from"视图的最终位置，此视图属于目前被移除的已经呈现的视图控制器。
    - 添加“to”视图到容器视图上。在执行呈现转场动画过程中，发起呈现的视图控制器的视图会在转场完成后被删除。因此，我们必须在移除转场动画过程中将该视图添加回容器视图中。
    - 创建动画。
        - 在动画Block中，将“from”视图从起始位置动画到在容器视图中的最终位置。同时，将其他任何属性也设置为它们的最终值。
        - 在完成Block中，从视图层中移除“from”视图并调用`completeTransition:`方法并执行需要的任何其他清理。
        
图10-5显示了一个自定义的呈现和移除转场动画，它们可以对角地呈现视图。在呈现过程中，需要呈现的视图从屏幕边缘开始沿着对角线向左上方移动，直至完全可见。在移除过程中，动画方向颠倒，视图向右下方移动，直到它完全离开屏幕。

![图10-5](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_custom-presentation-and-dismissal_10-5_2x.png)

以下代码显示了如何实现图10-5中的转场动画：
```
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Get the set of relevant objects.
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];

    // Set up some variables for the animation.
    CGRect containerFrame = containerView.frame;
    CGRect toViewStartFrame = [transitionContext initialFrameForViewController:toVC];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromVC];

    // Set up the animation parameters.
    if (self.presenting) {
        // Modify the frame of the presented view so that it starts
        // offscreen at the lower-right corner of the container.
        toViewStartFrame.origin.x = containerFrame.size.width;
        toViewStartFrame.origin.y = containerFrame.size.height;
    }else {
        // Modify the frame of the dismissed view so it ends in
        // the lower-right corner of the container view.
        fromViewFinalFrame = CGRectMake(containerFrame.size.width,containerFrame.size.height,toView.frame.size.width,toView.frame.size.height);
    }

    // Always add the "to" view to the container.
    // And it doesn't hurt to set its start frame.
    [containerView addSubview:toView];
    toView.frame = toViewStartFrame;

    // Animate using the animator's own duration value.
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (self.presenting) {
            // Move the presented view into position.
            [toView setFrame:toViewFinalFrame];
        }else {
            // Move the dismissed view offscreen.
            [fromView setFrame:fromViewFinalFrame];
        }
    }completion:^(BOOL finished){
        BOOL success = ![transitionContext transitionWasCancelled];

        // After a failed presentation or successful dismissal, remove the view.
        if ((self.presenting && !success) || (!self.presenting && success)) {
            [toView removeFromSuperview];
        }

        // Notify UIKit that the transition has finished
        [transitionContext completeTransition:success];
    }];
}
```

### 动画结束后的清理

在转场动画结束时，调用`completeTransition:`方法至关重要。调用该方法会告知UIKit转场动画已完成并且用户可能会开始使用所呈现的视图控制器，还会触发其他完成处理操作，包括发起呈现的视图控制器的`presentViewController:animated:completion:`方法和animator对象的`animationEnded:`方法的完成处理操作。调用`completeTransition:`方法的最佳位置在动画块的完成处理操作中。

因为转场动画在执行过程中能够被取消，所以应该使用转场动画上下文对象的`transitionWasCancelled`方法的返回值来确定需要进行的清理。当呈现被取消时，animator对象必须撤销对视图层次结构所做的任何修改。移除也需要采取类似的行动。

## 为转场动画添加交互性

使用动画交互的最简单方法是使用`UIPercentDrivenInteractiveTransition`对象。`UIPercentDrivenInteractiveTransition`对象与现有的animator对象配合使用来控制动画的时间，其使用我们提供的完成百分比来执行此操作。我们只需要配置好计算完成百分比和在每个新事件到达时更新完成百分比的代码。

我们可以直接使用`UIPercentDrivenInteractiveTransition`类，也可以使用其子类。如果使用其子类，则使用子类的`init`方（或者`startInteractiveTransition:`方法）来执行事件处理代码的一次性设置。之后，使用自定义的事件处理代码来计算新的完成百分比并调用`updateInteractiveTransition:`方法。当确定已完成转场时，请调用`finishInteractiveTransition`方法。

以下代码显示了`UIPercentDrivenInteractiveTransition`子类的`startInteractiveTransition:`方法的自定义实现。此方法设置了一个拖拽手势识别器来跟踪触摸事件，并将其与执行动画的容器视图相关联。该方法还保存了对转场动画上下文对象的引用以供以后使用。
```
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Always call super first.
    [super startInteractiveTransition:transitionContext];

    // Save the transition context for future reference.
    self.contextData = transitionContext;

    // Create a pan gesture recognizer to monitor events.
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpdate:)];
    self.panGesture.maximumNumberOfTouches = 1;

    // Add the gesture recognizer to the container view.
    UIView* container = [transitionContext containerView];
    [container addGestureRecognizer:self.panGesture];
}
```
每当有新的触摸事件传入时，手势识别器调用其关联的操作方法。实现操作方法时，可以使用手势识别器的状态信息来确定手势是成功、失败还是仍在进行中。同时，可以使用最新的触摸事件信息来计算新的完成百分比值。

以下代码显示了配置的拖拽手势识别器关联的操作方法。当有新事件传入时，此方法会使用触摸位置在垂直方向上移动的距离来计算动画的完成百分比。当手势结束时，完成转场。
```
- (void)handleSwipeUpdate:(UIGestureRecognizer *)gestureRecognizer {
    UIView* container = [self.contextData containerView];

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // Reset the translation value at the beginning of the gesture.
        [self.panGesture setTranslation:CGPointMake(0, 0) inView:container];
    }else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // Get the current translation value.
        CGPoint translation = [self.panGesture translationInView:container];

        // Compute how far the gesture has travelled vertically,
        // relative to the height of the container view.
        CGFloat percentage = fabs(translation.y / CGRectGetHeight(container.bounds));

        // Use the translation value to update the interactive animator.
        [self updateInteractiveTransition:percentage];
    }else if (gestureRecognizer.state >= UIGestureRecognizerStateEnded) {
        // Finish the transition and remove the gesture recognizer.
        [self finishInteractiveTransition];
        [[self.contextData containerView] removeGestureRecognizer:self.panGesture];
    }
}
```
> **重要**：我们计算出来的值代表着动画的完成百分比。对于交互式动画，可能需要避免非线性效应。例如，动画本身的初始速度、阻尼值和非线性完成曲线。这些效应倾向于将触摸位置与任何底层视图的移动分开。

## 创建与转场动画同时执行的动画

转场动画过程中涉及的视图控制器可以在转场动画过程中同时执行其他动画。例如，要呈现的视图控制器可能需要在转场过程中对其自己的视图层次结构进行动画处理，并在转场开始时添加运动效果或者其他视觉效果。任何对象都可以创建动画，只要其能访问发起呈现或者被呈现的视图控制器的`transitionCoordinator`属性即可。转场动画协调器只在转场过程中才存在。

要创建动画，请调用转场动画协调器的`animateAlongsideTransition:completion:`或者`animateAlongsideTransitionInView:animation:completion:`方法。我们提供的动画块将被存储直到转场动画开始，此时它们将会与其余的转场动画一起执行。

## 在转场动画中使用presentation controller

对于自定义呈现，我们可以提供自定义的presentation controller，为需要呈现的视图控制器提供自定义外观。presentation controller管理着与被呈现的视图控制器及其内容分离的任何视图。例如，放置在被呈现的视图控制器的视图后面的调光视图就由presentation controller管理。

我们可以在呈现的视图控制器的转场动画代理中提供自定义presentation controller（视图控制器的`modalTransitionStyle`属性值必须为`UIModalPresentationCustom`）。presentation controller与任何animator对象并行操作。随着animator对象将视图控制器的视图动画到其最终位置，presentation controller也会同时将任何其他视图动画到它们的最终位置。在转场结束时，presentation controller有机会对视图层次结构执行任何最终调整。

有关如何创建自定义presentation controller的信息，请参看[Creating Custom Presentations](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/DefiningCustomPresentations.html#//apple_ref/doc/uid/TP40007457-CH25-SW1);


# 创建自定义presentation controller

UIKit将视图控制器的内容与内容被呈现和显示在屏幕上的方式分开。呈现的视图控制器由底层的presentation controller对象管理，该对象管理用于显示视图控制器的视图的视觉样式。presentation controller可以执行以下操作：
- 设置所呈现的视图控制器的尺寸。
- 添加自定义视图来更改所呈现内容的视觉外观。
- 为其任何自定义视图提供转场动画。
- 当应用程序的屏幕环境发生变化时，调整所呈现内容的视觉外观。

UIKit为标准呈现样式提供了presentation controller，当我们将视图控制器的呈现样式设置为`UIModalPresentationCustom`并提供合适的转场动画委托时，UIKit会改为使用我们自定义的presentation controller。

## 自定义呈现的过程

当呈现一个呈现样式为`UIModalPresentationCustom`的视图控制器时，UIKit会查看一个自定义presentation controller来管理呈现过程。随着呈现的进行，UIKit会调用presentation controller的方法，使其有机会设置任何自定义视图并将视图动画到某个位置。

presentation controller与任何animator对象一起工作来实现整体转场。animator对象将视图控制器的内容动画显示到屏幕上，而presentation controller处理所有其他事情。通常情况下，自定义presentation controller会为其自己的视图创建动画。但是我们也可以覆写presentation controller的`presentedView`方法，让animator对象为所有或者部分视图创建动画。

在呈现过程中，UIKit：
1. 调用转场动画委托对象的`presentationControllerForPresentedViewController:presentingViewController:sourceViewController:`方法来检索我们自定义的presentation controller。
2. 如果存在animator对象或者交互式animator对象的话，会向转场动画委托对象请求获取它们。
3. 调用自定义presentation controller的`presentationTransitionWillBegin`方法。在该方法的实现中，应该将任何自定义视图添加到视图层次结构中，并为这些视图创建动画。
4. 调用presentation controller的`presentedView`方法获取需要呈现的视图。`presentedView`方法返回的视图由animator对象为其创建动画。通常情况下，该方法返回需要呈现的视图控制器的根视图。自定义presentation controller可以根据需要来决定是否使用自定义背景视图来替换该视图。如果确实指定了不同的视图，则必须将需要呈现的视图控制器的根视图嵌入到presentation controller的视图层次结构中。
5. 执行转场动画。转场动画包括animator对象创建的主要动画以及我们配置的与主要动画一起执行的任何动画。在动画过程中，UIKit会调用presentation controller的`containerViewWillLayoutSubviews`和`containerViewDidLayoutSubviews`方法，以便我们可以根据需要调整自定义视图的布局。
6. 在转场动画结束时，调用presentation controller的`presentationTransitionDidEnd:`方法。

在移除过程中，UIKit：
1. 从呈现的视图控制器中获取我们自定义的presentation controller。
2. 如果存在animator对象或者交互式animator对象的话，会向转场动画委托对象请求获取它们。
3. 调用presentation controller的`dismissalTransitionWillBegin`方法。在该方法的实现中，应该将任何自定义视图添加到视图层次结构中，并为这些视图创建动画。
4. 调用presentation controller的`presentedView`方法获取已经呈现的视图。
5. 执行转场动画。转场动画包括animator对象创建的主要动画以及我们配置的与主要动画一起执行的任何动画。在动画过程中，UIKit会调用presentation controller的`containerViewWillLayoutSubviews`和`containerViewDidLayoutSubviews`方法，以便我们能够删除任何自定义约束。
6. 在转场动画结束时，调用presentation controller的`dismissalTransitionDidEnd:`方法。

在呈现过程中，presentation controller的`frameOfPresentedViewInContainerView`和`presentedView`方法可能会被多次调用，因此这两个方法的实现应该尽量简单。另外，在`presentedView`方法的实现中不应该尝试去设置视图层次结构。在调用该方法时，应该已经设置好视图层次结构。

## 创建自定义presentation Controller

要实现自定义呈现样式，请子类化`UIPresentationController`并添加代码为自定义呈现创建视图和动画。创建自定义presentation Controller时，请考虑以下问题：
- 想添加哪些视图。
- 想要屏幕上的视图执行怎样的动画效果。
- 呈现的视图控制器的尺寸应该是多少。
- 呈现的内容应该如何在水平正常和水平紧凑的屏幕环境之间进行适应。
- 呈现完成后，是否移除发起呈现的视图控制器的视图。

所有这些决定都要求覆写`UIPresentationController`类的不同方法。

### 设置呈现的视图控制器的Frame

可以修改呈现的视图控制器的`frame`，使其仅填充部分可用空间。默认情况下，呈现的视图控制器的尺寸能够完全填充容器视图。要更改`frame`，请覆写presentation Controller的`frameOfPresentedViewInContainerView`方法。以下代码显示了一个示例，其中呈现的视图控制器的大小被改为仅覆盖容器视图的右半部分。在这种情况下，presentation Controller使用背景调光视图来覆盖容器视图的另一半。
```
- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect presentedViewFrame = CGRectZero;
    CGRect containerBounds = [[self containerView] bounds];

    presentedViewFrame.size = CGSizeMake(floorf(containerBounds.size.width / 2.0), containerBounds.size.height);
    
    presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width;
    
    return presentedViewFrame;
}
```

### 管理和动画自定义视图

自定义呈现样式通常涉及向呈现的内容中添加自定义视图。使用自定义视图来实现纯粹的视觉装饰或者使用它们将实际行为添加到呈现中。例如，背景视图可能包含手势识别器来跟踪呈现内容边界之外的特定操作。

presentation Controller负责创建和管理与呈现有关的所有自定义视图。通常情况下，在presentation Controller的初始化过程中创建自定义视图。以下代码显示了创建自己的调光视图的自定义视图控制器的初始化方法，此方法创建视图并执行一些最小配置。
```
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if(self)
    {
        // Create the dimming view and set its initial appearance.
        self.dimmingView = [[UIView alloc] init];
        
        [self.dimmingView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha 0.4]];
        
        [self.dimmingView setAlpha:0.0];
    }
    return self;
}
```
使用`presentationTransitionWillBegin`方法将自定义视图动画显示到屏幕上。在此方法的实现中，配置自定义视图并将其添加到容器视图中，如下代码所示。使用发起呈现或者呈现的视图控制器的转场动画协调器来创建任何动画。**切勿**在此方法中修改呈现的视图控制器的视图。animator对象负责将呈现的视图控制器动画显示到`frameOfPresentedViewInContainerView`方法返回的`frame`去。
```
- (void)presentationTransitionWillBegin
{
    // Get critical information about the presentation.
    UIView* containerView = [self containerView];
    
    UIViewController* presentedViewController = [self presentedViewController];

    // Set the dimming view to the size of the container's
    // bounds, and make it transparent initially.
    [[self dimmingView] setFrame:[containerView bounds]];
    [[self dimmingView] setAlpha:0.0];

    // Insert the dimming view below everything else.
    [containerView insertSubview:[self dimmingView] atIndex:0];

    // Set up the animations for fading in the dimming view.
    if([presentedViewController transitionCoordinator])
    {
        [[presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>context){
            // Fade in the dimming view.
            [[self dimmingView] setAlpha:1.0];
        } completion:nil];
    }else
    {
        [[self dimmingView] setAlpha:1.0];
    }
}
```
在呈现结束时，使用`presentationTransitionDidEnd:`方法来处理由于取消呈现所导致的任何清理。如果不满足阀值条件，交互式animator对象可能会取消转场动画。发生这种情况时，UIKit会调用`presentationTransitionDidEnd:`方法并传递`NO`值给该方法。当发生取消转场动画操作时，删除在呈现开始时添加的任何自定义视图，并将其他视图还原为之前的配置，如下所示。
```
- (void)presentationTransitionDidEnd:(BOOL)completed
{
    // If the presentation was canceled, remove the dimming view.
    if (!completed)
        [self.dimmingView removeFromSuperview];
}
```
当视图控制器被移除时，使用`dismissalTransitionDidEnd:`方法从视图层次结构中删除自定义视图。如果想要视图动画消失，请在`dismissalTransitionDidEnd:`方法中配置这些动画。以下代码显示了在前面的例子中移除调光视图的两种方法的实现。始终检查`dismissalTransitionDidEnd:`方法的参数以确定移除是成功还是被取消。
```
- (void)dismissalTransitionWillBegin
{
    // Fade the dimming view back out.
    if([[self presentedViewController] transitionCoordinator])
    {
        [[[self presentedViewController] transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>context) {
            [[self dimmingView] setAlpha:0.0];
        } completion:nil];
    }else
    {
        [[self dimmingView] setAlpha:0.0];
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    // If the dismissal was successful, remove the dimming view.
    if (completed)
        [self.dimmingView removeFromSuperview];
}
```

## 传递presentation Controller给UIKit

呈现一个视图控制器时，请执行以下操作来使用自定义presentation Controller显示视图控制器：
- 将需要呈现的视图控制器的`UIModalPresentationCustom`属性设置为`UIModalPresentationCustom`。
- 给需要呈现的视图控制器的`transitioningDelegate`属性分配一个转场动画委托对象。
- 实现转场动画委托对象的`presentationControllerForPresentedViewController:presentingViewController:sourceViewController:`方法。

当UIKit需要使用自定义presentation Controller时，会调用转场动画委托对象的`presentationControllerForPresentedViewController:presentingViewController:sourceViewController:`方法。该方法的实现应该以下代码那样简单，只需要创建自定义的presentation Controller，进行配置并返回。如果此方法返回`nil`，则UIKit会使用全屏呈现样式来呈现视图控制器。
```
- (UIPresentationController *)presentationControllerForPresentedViewController:
(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    MyPresentationController* myPresentation = [[MyPresentationController] initWithPresentedViewController:presented presentingViewController:presenting];

    return myPresentation;
}
```

## 适应不同的屏幕环境

在屏幕上呈现内容时，UIKit会在底层特征发生改变或者容器视图的尺寸发生变化时通知我们自定义的presentation Controller。这种变化通常发生在设备旋转过程中，但也可能发生在其他时间。可以使用trait和size通知来适当调整presentation Controller的自定义视图并更新为合适的呈现样式。

有关如何适应新的trait和size的信息，请参看[Building an Adaptive Interface](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/BuildinganAdaptiveInterface.html#//apple_ref/doc/uid/TP40007457-CH32-SW1)。


# 自适应和尺寸的变化

## 自适应模型

自适应界面能够充分利用屏幕的可用空间，适应性意味着能够调整内容以便其能够适合任何iOS设备。iOS中的自适应模型支持以简单但是动态的方式来重新排列和调整内容，以响应更改。当使用这种模型时，一个应用程序只需要很少的额外代码就可以适应不同的屏幕尺寸（如图12-1所示）。

![图12-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_AdaptiveModel_13-1_2x.png)

Auto Layout是构建自适应界面的重要工具。使用Auto Layout，我们可以定义管理视图控制器视图布局的规则（称为约束）。可以在Interface Builder中以可视化方式创建约束，也可以在代码中编程创建约束。当父视图的尺寸发生变化时，iOS系统将根据我们指定的约束条件自动调整视图的尺寸并重新定位其余视图。

特征（trait）是自适应模型的另一个重要组成部分。特征描述了视图控制器和视图必须运行的环境，特征可以帮助我们做出关于界面的高层决策。

### 特征的作用

当约束不足以管理布局时，视图控制器有几个机会去进行更改。视图控制器、视图和一些其他对象管理着一个特征集合，这些特征指定了与该对象关联的当前环境。下表描述了这些特征以及如何使用它们来影响用户界面。

| 特征 |示例 | 描述 |
|------|------|-------|
| horizontalSizeClass | UIUserInterfaceSizeClassCompact | 此特征表达了界面的一般宽度。使用它来做出粗略的布局决策，例如视图是垂直堆叠、并排显示、全部隐藏还是以其他方法显示。 |
| verticalSizeClass | UIUserInterfaceSizeClassRegular | 此特征表达了界面的一般高度。如果界面设计要求所有内容都适配在屏幕上而不滚动，请使用此特征来作出布局决策。 |
| displayScale | 2.0 | 此特征表达内容是显示在Retina显示屏上还是标准分辨率显示屏上。使用它（根据需要）来做出像素级布局决策或者选择要显示的图像版本。 |
| userInterfaceIdiom | UIUserInterfaceIdiomPhone | 此特征提供了向后兼容性，并表达了运行应用程序的设备类型。尽可能避免使用这个特征。对于布局决策，请改为使用horizontal 和 vertical size classes 代替。 |

使用特征来做出关于如何呈现用户界面的决策。在Interface Builder中构建界面时，使用特征来更改显示的视图和图像，或者使用特征来应用不同的约束集合。许多UIKit类（如UIImageAsset）使用指定的特征来裁剪它们提供的信息。

以下时一些提示，可以帮助我们了解何时使用不同类型的特征：
- 使用size class对界面进行粗略更改。size class更改是一个合适的时机去添加或删除视图，添加或删除子视图控制器或更改布局约束。我们也可以不做任何事情，并让界面使用其现有布局约束去自动适应。
- 切勿假设size class与视图的特定宽度或高度相符合。视图控制器的size class可能会因多种原因而发生更改。例如，iPhone上的容器视图控制器可能会使其某个子视图控制器在水平方向上固定来强制其以不同方式显示其内容。
- 使用Interface Builder为每个size class指定不同的布局约束。使用Interface Builder来指定约束比编程添加和移除约束要简单得多。视图控制器通过应用其storyboard的对应的约束来自动处理size class更改。
- 避免使用idiom信息来做出关于界面布局或界面内容的决策。在iPad和iPhone上运行的应用程序通常应显示相同的信息，并应该使用size class来进行布局决策。

### 特征和尺寸的改变会在何时发生?

特征的改变很少发生，但确实会发生。UIKit根据底层环境的变化来更新视图控制器的特征，size class特征比display scale特征更可能发生改变，idiom特征很少会改变。size class会由于以下原因而发生改变：
- 通常情况下，由于设备的旋转，视图控制器窗口的垂直或者水平size class发生改变。
- 容器视图控制器的垂直或者水平size class已改变。
- 当前视图控制器的垂直或者水平size class由其容器显式更改。

视图控制器层次结构中的size class更改会传递到任何子视图控制器。window对象作为该层次结构的最底层，为其根视图控制器提供baseline size class特征。当设备方向在纵向和横向之间变化时，window会更新其自己的size class信息并沿着视图控制器层次结构传递该信息。容器视图控制器可以将size class更改传递给未经修改的子视图控制器，也可以覆盖每个子视图控制器的特征。

在iOS 8以上系统版本中，window的原点（origin）始终位于左上角，当设备在横向和纵向之间旋转时，window的bounds会发生改变。window的尺寸的变化会与任何相应的特征变化一起沿着视图控制器层次结构向下传递。对于层次结构中的每个视图控制器，UIKit会调用以下方法来报告这些更改：
- `willTransitionToTraitCollection:withTransitionCoordinator:`方法告知每个相关的视图控制器其特征即将改变。
- `viewWillTransitionToSize:withTransitionCoordinator:`方法告知每个相关的视图控制器其尺寸即将改变。
- `traitCollectionDidChange:`方法告知每个相关的视图控制器，其特征现在已经改变了。

在沿着视图控制器层次结构传递信息时，UIKit仅在有变化需要告知时才将变化告知给视图控制器。如果容器视图控制器覆盖了其子视图控制器的size class，则当容器的size class改变时，不会告知其子视图控制器。同样，如果视图控制器的视图具有固定的高度和宽度，它也不会收到尺寸改变通知。

图12-2显示了在iPhone 6上发生旋转时视图控制器的特征和视图尺寸是如何更新的。从纵向到横向的旋转将屏幕的垂直size class从常规变为紧凑。size class更改后，相应视图的尺寸也更改，然后沿着视图控制器层次结构传递这些更改。将视图动画为新尺寸后，UIKit在调用视图控制器的`traitCollectionDidChange:`方法之前会应用size class和视图尺寸的更改。

![图12-2](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_RotationTraits_fig_13-2_2x.png)

### 不同设备的默认size class

每个iOS设备都有一组默认的size class，我们可以在设计界面时作为指导。下表列出了设备在纵向和横向上的size class，未列在表格中的设备与具有相同屏幕尺寸的设备具有相同的size class。

| 设备 | 纵向 | 横向 |
|------|-------|-------|
| iPad(all)<br>iPad Mini | Vertical size class: Regular<br>Horizontal size class: Regular | Vertical size class: Regular<br>Horizontal size class: Regular |
| iPhone 6 Plus | Vertical size class: Regular<br>Horizontal size class: Compact | Vertical size class: Compact<br>Horizontal size class: Regular |
| iPhone 6 | Vertical size class: Regular<br>Horizontal size class: Compact | Vertical size class: Compact<br>Horizontal size class: Compact |
| iPhone 5s<br>iPhone 5c<br>iPhone 5 | Vertical size class: Regular<br>Horizontal size class: Compact | Vertical size class: Compact<br>Horizontal size class: Compact |
| iPhone 4s | Vertical size class: Regular<br>Horizontal size class: Compact | Vertical size class: Compact<br>Horizontal size class: Compact |

> **重要**：切勿假设应用程序以特定的size class在设备上显示。在决定如何配置某个对象时，应始终检查从该对象的特征集合中得到的size class。

## 构建一个自适应界面

自适应界面应该对特征和尺寸的改变做出响应。在视图控制器级别，可以使用特征对显示的内容和该内容的布局进行粗略的确定。例如，在不同的size class之间切换时，可以选择更改视图属性，显示或者隐藏视图，或者显示完全不同的视图集。做出这些重大决策之后，可以选择使用尺寸更改来微调内容。

### 适应特征变化

特征为我们提供了一种在不同环境下配置应用程序使其有所不同的方式，我们可以使用它对界面进行粗略调整。对特征所做的大部分更改都可以直接在storyboard中完成，但有一些还需要额外的代码。

#### 配置storyboard以处理不同的size class

Interface Builder使我们可以轻松地将界面调整到不同的size class。storyboard编辑器支持配置不同size class的显示界面、在指定配置中删除视图以及指定不同的布局约束。 使用这些工具意味着不必在运行时以编程方式进行相同的更改。相反，UIKit会在当前size class更改时自动更新界面。

图13-1显示了用于在Interface Builder中配置界面的工具。size class查看控件改变了界面的外观。使用该控件查看给定size class的界面的外观。对于单个视图，使用安装控件来查看对于给定的size class配置是否存在视图。使用复选框左侧的加号（+）按钮添加新配置。

![图13-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/size_class_ib_setting_2x.png)

image asset是存储应用程序图片资源的首选方式。每个image asset包含同一图像的多个版本，每个版本均为特定配置而设计。除了为标准分辨率显示屏和Retina显示屏指定不同的图像外，还可以为不同的水平和垂直size class指定不同的图像。使用image asset进行配置时，`UIImageView`对象会自动选择与当前size class和分辨率相关联的图像。

图13-2显示了image asset的属性。更改宽度个高度属性为目录中的更多图像添加插槽。用这些图像填充这些插槽以用于每种size class组合。

![图13-2](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/size_class_image_asset_2x.png)

#### 更改子视图控制器的特征

子视图控制器默认继承父视图控制器的特征。对于size class特征，每个子视图控制器都可能没有与其父视图控制器相同的特征。例如，常规环境中的视图控制器可能想要为其一个或者多个子视图控制器配置一个紧凑的size class，来反映该子视图控制器的空间减小。在实现容器视图控制器时，可以通过调用容器视图控制器的`setOverrideTraitCollection:forChildViewController:`来修改子视图控制器的特征。

以下代码显示了如何创建一组新特征并将他们与子视图控制器关联。只需在父视图控制器执行这段代码一次。
```
UITraitCollection* horizTrait = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular];

UITraitCollection* vertTrait = [UITraitCollection
traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassCompact];

UITraitCollection* childTraits = [UITraitCollection
traitCollectionWithTraitsFromCollections:@[horizTrait, vertTrait]];

[self setOverrideTraitCollection:childTraits forChildViewController:self.childViewControllers[0]];
```


