import 'package:flutter/material.dart';
import 'package:food_cafe/main.dart';
import 'package:food_cafe/subt.dart';

class VegScreen extends StatefulWidget {
  const VegScreen({super.key});

  @override
  _VegScreenState createState() => _VegScreenState();
}

class _VegScreenState extends State<VegScreen> {
  late List<Map<String, dynamic>> _products;
  late List<Map<String, dynamic>> _subcategories;
  late Future<Map<String, dynamic>> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = fetchData().then((data) {
      setState(() {
        _products = (data['results'][3]['maincategory_products'] ?? [])
            .cast<Map<String, dynamic>>();
        _subcategories = (data['results'][3]['subcategories'] ?? [])
            .cast<Map<String, dynamic>>();
      });
      return data;
    }).catchError((error) {
      print('Error fetching data: $error');
      // ignore: invalid_return_type_for_catch_error
      return {};
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
                : const Icon(Icons.image_not_supported),
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
        title: const Text('Biryani & Rice'),
      ),
      body: FutureBuilder(
        future: _fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (_products.isNotEmpty) {
              return ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  final stringTitle = product['content_name'] ?? '';
                  final String stringSub =
                      product['content_price'][0]['saleprice'] ?? '';
                  final List contentImage = product['content_image'] ?? [];
                  final url = contentImage.isNotEmpty
                      ? contentImage[0]['thumbnail_image']
                      : null;

                  return ProductTile(
                    title: stringTitle,
                    subtitle: "Price $stringSub",
                    imageUrl: url,
                    onTap: () {
                      _handleProductTap(index);
                    },
                  );
                },
              );
            } else if (_subcategories.isNotEmpty) {
              return ListView.builder(
                itemCount: _subcategories.length,
                itemBuilder: (context, index) {
                  final subcategory = _subcategories[index];
                  final stringTitle = subcategory['content_name'] ?? '';
                  final String stringSub =
                      subcategory['content_price'][0]['saleprice'] ?? '';
                  final List contentImage = subcategory['content_image'] ?? [];
                  final url = contentImage.isNotEmpty
                      ? contentImage[0]['thumbnail_image']
                      : null;
                  return ProductTile(
                    title: stringTitle,
                    subtitle: "Price $stringSub",
                    imageUrl: url,
                    onTap: () {
                      _handleProductTap(index);
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          }
        },
      ),
    );
  }
}
