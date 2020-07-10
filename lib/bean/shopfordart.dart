//抽象出一个新的基类 Meta，用于存放 price 属性与 name 属性
class Meta {
  double price;
  String name;

  // 使用构造函数语法糖及初始化列表，简化了成员变量的赋值过程
  Meta(this.name, this.price);
}

// 定义商品 Item 类
class Item extends Meta with PrintHelper {
  int count; //商品数量

  Item(name, price, this.count) : super(name, price);

  double get totalPrice => price * count;

  // 重载了 + 运算符，合并商品为套餐商品
  Item operator +(Item item) =>
      Item(name + item.name, totalPrice + item.totalPrice, count + item.count);

  @override
  String getInfo() {
    return '$name $count $price';
  }
}

// 定义购物车类
// with 表示以非继承的方式复用了另一个类的成员变量及函数
class ShoppingCart extends Meta with PrintHelper {
  DateTime date;
  String code;
  List<Item> bookings;

  double get price =>
      bookings.reduce((value, element) => value + element).totalPrice;

//  ShoppingCart(name, this.code) : date = DateTime.now(), super(name, 0);

  // 默认初始化方法，转发到 withCode 里
  ShoppingCart({name}) : this.withCode(name, null);

  // withCode 初始化方法，使用语法糖和初始化列表进行赋值，并调用父类初始化方法
  ShoppingCart.withCode(name, this.code)
      : date = DateTime.now(),
        super(name, 0);

  // 使用多行字符串和内嵌表达式的方式，省去了无谓的字符串拼接
  // ?? 运算符表示为 code 不为 null，则用原值，否则使用默认值
  getInfo() {
    return '''
购物车信息:
-----------------------------
商品名称 数量 单价
${bookings.map((e) => e.getInfo()).join('\n')}

用户名: $name
优惠码: ${code ?? "没有"}
总价: $price
日期: $date
-----------------------------
        ''';
  }
}

abstract class PrintHelper {
  printInfo() => print(getInfo());

  String getInfo();
}

void main() {
  ShoppingCart sc = ShoppingCart.withCode('张三', '123456');
  sc.bookings = [Item('苹果', 10.0, 1), Item('鸭梨', 20.0, 2)];
  print(sc.getInfo());

  ShoppingCart sc2 = ShoppingCart(name: '李四');
  sc2.bookings = [Item('西瓜', 10.0, 3), Item('香蕉', 20.0, 4)];
  print(sc2.getInfo());

  //可以使用级联运算符“..”，在同一个对象上连续调用多个函数以及访问成员变量。
  ShoppingCart.withCode('张三', '123456')
    ..bookings = [Item('苹果', 10.0, 5), Item('鸭梨', 20.0, 6)]
    ..printInfo();
}
