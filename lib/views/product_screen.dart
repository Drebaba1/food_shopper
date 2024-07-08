import 'package:flutter/material.dart';
import 'package:food_shopper/controller/product_controller.dart';
import 'package:food_shopper/model/product_model.dart';

class ProductShowcaseScreen extends StatefulWidget {
  const ProductShowcaseScreen({super.key});

  @override
  State<ProductShowcaseScreen> createState() => _ProductShowcaseScreenState();
}

class _ProductShowcaseScreenState extends State<ProductShowcaseScreen> {
  List<ProductModel> allProducts = [];

  Future<List<ProductModel>> getProducts() async =>
      await ProductController.getProducts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: FutureBuilder(
          future: getProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              allProducts = snapshot.data!;
              return allProducts.isNotEmpty
                  ? GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: allProducts.length,
                      itemBuilder: (context, index) {
                        final product = allProducts[index];
                        return Card(
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        '₦${product.price.toStringAsFixed(0)}'),
                                    SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => ProductDialog(
                                              selectedProduct: product,
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        child: Text(
                                          'View Details',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Image.asset(
                              'assets/png/empty.png',
                            ),
                          ),
                          const Text(
                            'There is currently no product available',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          MaterialButton(
                            color: Colors.black,
                            onPressed: () {
                              setState(() {});
                            },
                            child: const Text(
                              'Tap to check again',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.asset('assets/png/error.png'),
                    ),
                    const Text(
                      'Error connecting to server',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    MaterialButton(
                      color: Colors.black,
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text(
                        'Tap to refresh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
                color: Colors.blue.shade900,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductDialog extends StatelessWidget {
  const ProductDialog({
    super.key,
    required this.selectedProduct,
  });

  final ProductModel selectedProduct;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedProduct.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₦${selectedProduct.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              // width: 200,
              // height: 200,
              child: Image.network(
                selectedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Quantity Remaining: ${selectedProduct.quantity.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              selectedProduct.description,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
