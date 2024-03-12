import 'package:flutter/material.dart';
import 'package:food_cafe/main.dart';
import 'package:food_cafe/widgets/product_listing_card.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  late List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    fetchData().then((data) {
      setState(() {
        _products =
            data['results'][0]['offer_products'].cast<Map<String, dynamic>>();
      });
    }).catchError((error) {
      print('Error fetching data: $error');
    });
  }

  void _handleProductTap(int index) {
    final product = _products[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product['content_name'] ?? 'Name not available'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(product['content_image'][0]['thumbnail_image'],
                fit: BoxFit.fill),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer Page'),
      ),
      body: _products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                final stringTitle = product['content_name'];
                final String stringSub =
                    product['content_price'][0]['saleprice'];
                return ProductTile(
                  title: stringTitle,
                  subtitle: 'Price: \$${stringSub}',
                  imageUrl: product['content_image'][0]['thumbnail_image'],
                  onTap: () {
                    _handleProductTap(index);
                  },
                );
              },
            ),
    );
  }
}
