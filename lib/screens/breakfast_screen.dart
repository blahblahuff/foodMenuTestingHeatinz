import 'package:flutter/material.dart';
import 'package:food_cafe/main.dart';
import 'package:food_cafe/widgets/product_listing_card.dart';

class BreakfastScreen extends StatefulWidget {
  const BreakfastScreen({Key? key}) : super(key: key);

  @override
  _BreakfastScreenState createState() => _BreakfastScreenState();
}

class _BreakfastScreenState extends State<BreakfastScreen> {
  late List<Map<String, dynamic>> _products = [];
  late Future<Map<String, dynamic>> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = fetchData().then((data) {
      setState(() {
        _products = data['results'][4]['maincategory_products']
            .cast<Map<String, dynamic>>();
      });
      return data;
    }).catchError((error) {
      print('Error fetching data: $error');
    });
  }

  void _handleProductTap(int index) {
    final product = _products[index];
    final List contentImage = product['content_image'] ?? [];

    final url =
        contentImage.isNotEmpty ? contentImage[0]['thumbnail_image'] : null;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product['content_name'] ?? 'Name not available'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            url != null
                ? Image.network(url, fit: BoxFit.fill)
                : Icon(Icons.image),
            Text(
                'Price: \$${product['content_price'][0]['saleprice'] ?? 'Price not available'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('widget rebuld ');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breakfast'),
      ),
      body: _products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                // print('builde runnig');

                final product = _products[index];

                final stringTitle = product['content_name'] ?? '';
                final String stringSub =
                    product['content_price'][0]['saleprice'] ?? '';
                final List contentImage = product['content_image'] ?? [];
                print(contentImage);

                final url = contentImage.isNotEmpty
                    ? contentImage[0]['thumbnail_image']
                    : null;
                // final url =
                //     product['content_image'][0]['thumbnail_image'] ?? '';

                return ProductTile(
                  title: stringTitle,
                  subtitle: "Price $stringSub",
                  imageUrl: url,
                  onTap: () {
                    _handleProductTap(index);
                  },
                );
              },
            ),
    );
  }
}
