
// 定义商品 Item 类
class Item {
  double price;
  String name;
  Item(name, price) {
    this.name = name;
    this.price = price;
  }
}

// 定义购物车类
class ShoppingCart{
  String name;
  DateTime date;
  String code;
  List<Item> bookings;

  double price() {
    double sum = 0;
    for(Item item in bookings) {
      sum += item.price;
    }
    return sum;
  }

  ShoppingCart(name, code) {
    this.name = name;
    this.code = code;
    this.date = DateTime.now();
  }

  getInfo() {
    return '购物车信息:' +
        '\n-----------------------------' +
        '\n 用户名: ' + name+
        '\n 优惠码: ' + code +
        '\n 总价: ' + price().toString() +
        '\n 日期: ' + date.toString() +
        '\n-----------------------------';
  }

  void main() {
    ShoppingCart sc = ShoppingCart('张三', '123456');
    sc.bookings = [Item('苹果',10.0), Item('鸭梨',20.0)];
    print(sc.getInfo());
  }

}
