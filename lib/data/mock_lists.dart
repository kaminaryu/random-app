import 'package:i_bazaar/models/item.dart';

class MockLists {
  static const items = [
      Item(name: "LightSaber (Red)", price: "6.70",  desc: "It works 100%",                                   seller: "Khazin", stock: 12,  status: "Private",    imgSrc: "red_lightsaber.png"),
      Item(name: "Dragon Figurine",  price: "12.50", desc: "Rare collectible",                                seller: "Ali",    stock: 54,  status: "Private",    imgSrc: "dragon.png"),
      Item(name: "Green Boulder",    price: "3.20",  desc: "Mysterious stone",                                seller: "Sara",   stock: 34,  status: "Public",    imgSrc: "green_boulder.png"),
      Item(name: "Green Boulder",    price: "3.20",  desc: "Mysterious stone (small)",                        seller: "Sara",   stock: 1,   status: "Private",    imgSrc: "green_boulder.png"),
      Item(name: 'LightSaber (Red)', price: '6.70',  desc: 'It works 100%, barely used.',                     seller: "joe",    stock: 12,  status: "Public",  imgSrc: 'red_lightsaber.png'),
      Item(name: 'Dragon Figurine',  price: '12.50', desc: 'Rare collectible, hand-painted.',                 seller: "joe",    stock: 54,  status: "Public",  imgSrc: 'dragon.png'),
      Item(name: 'Green Boulder',    price: '3.20',  desc: 'Mysterious stone found in the woods.',            seller: "joe",    stock: 234, status: "Private", imgSrc: 'green_boulder.png'),
      Item(name: 'Crystal Vase',     price: '24.99', desc: 'Elegant crystal vase, perfect for flowers.',      seller: "joe",    stock: 8,   status: "Private", imgSrc: 'dragon.png'),
      Item(name: 'Vintage Watch',    price: '89.00', desc: 'Mechanical watch from the 1960s, still ticking.', seller: "joe",    stock: 3,   status: "Public",  imgSrc: 'red_lightsaber.png'),
      Item(name: 'Wooden Chair',     price: '45.00', desc: 'Handcrafted oak chair, comfortable and sturdy.',  seller: "joe",    stock: 15,  status: "Private", imgSrc: 'green_boulder.png'),
  ];
}
