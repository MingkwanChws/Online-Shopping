import 'package:flutter/material.dart';
import 'package:online_shop/components/bottom_navbar.dart';
import 'package:online_shop/screens_buyer/product_list_screen.dart';

class HomeBuyerScreen extends StatefulWidget {
  static const id = 'home_buyer';
  const HomeBuyerScreen({super.key});

  @override
  State<HomeBuyerScreen> createState() => _HomeBuyerScreenState();
}

class _HomeBuyerScreenState extends State<HomeBuyerScreen> {
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Badge(
              child: Icon(Icons.shopping_cart),
              isLabelVisible: true,
              label: Text('0'),
            ),
          )
        ],
        title: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            constraints: BoxConstraints(minHeight: 40),
            backgroundColor: MaterialStateProperty.all(Colors.grey[350]),
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
          );
        }, suggestionsBuilder:
                (BuildContext context, SearchController controller) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          });
        }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 250,
                child: Image.asset(
                  ('images/event.jpg'),
                  fit: BoxFit.cover,
                  // alignment: Alignment.bottomLeft,
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductListScreen(product_category: 'Trucks'),
                      ),
                    );
                  },
                  child: CategoryButton(
                    image: 'images/truck.png',
                    title: 'Trucks',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductListScreen(product_category: 'Desks'),
                      ),
                    );
                  },
                  child: CategoryButton(
                    image: 'images/desk.png',
                    title: 'Desks',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductListScreen(product_category: 'Obstacles'),
                      ),
                    );
                  },
                  child: CategoryButton(
                    image: 'images/obstacle.png',
                    title: 'Obstacles',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductListScreen(product_category: 'Tunings'),
                      ),
                    );
                  },
                  child: CategoryButton(
                    image: 'images/tunning.png',
                    title: 'Tunings',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductListScreen(product_category: 'Wheels'),
                      ),
                    );
                  },
                  child: CategoryButton(
                    image: 'images/wheel.png',
                    title: 'Wheels',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductListScreen(product_category: 'Tapes'),
                      ),
                    );
                  },
                  child: CategoryButton(
                    image: 'images/tape.png',
                    title: 'Tapes',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductListScreen(product_category: 'Completes'),
                      ),
                    );
                  },
                  child: CategoryButton(
                    image: 'images/complete.png',
                    title: 'Completes',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductListScreen(product_category: 'Playgrounds'),
                      ),
                    );
                  },
                  child: CategoryButton(
                    image: 'images/playground.png',
                    title: 'Playgrounds',
                  ),
                ),
              ],
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 20.0, top: 30, right: 20, bottom: 10),
              child: Text(
                'New Release',
                textAlign: TextAlign.end,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Row(
              children: [
                Product(
                  image: 'images/new_release1.png',
                  title: 'FLATFACE GOLD',
                  price: '1900฿',
                ),
                Product(
                  image: 'images/new_release2.png',
                  title: 'FLATFACE G4',
                  price: '1900฿',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Product extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  Product({required this.image, required this.title, required this.price});

  // const Product({
  //   super.key,
  // });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(
            image,
          ),
          Container(
            width: 120,
            color: Colors.grey[350],
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 120,
            padding: EdgeInsets.only(top: 10),
            child: Text(
              price,
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String image;
  final String title;

  CategoryButton({required this.image, required this.title});

  // const CategoryButton({
  //   super.key,
  // });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            width: 80,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                image,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Text(title),
      ],
    );
  }
}
