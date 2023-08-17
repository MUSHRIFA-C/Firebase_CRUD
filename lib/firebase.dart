import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseCrud extends StatefulWidget {
  const FirebaseCrud({Key? key}) : super(key: key);

  @override
  State<FirebaseCrud> createState() => _FirebaseCrudState();
}

class _FirebaseCrudState extends State<FirebaseCrud> {
  final CollectionReference _product =
  FirebaseFirestore.instance.collection('products');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _update(DocumentSnapshot documentSnapshot) async {
    _nameController.text = documentSnapshot['name'];
    _priceController.text = documentSnapshot['price'].toString();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Update',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * .3,
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown)),
                ),
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Price',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown)),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  final String name = _nameController.text;
                  final double price = double.parse(_priceController.text);

                  await _product.doc(documentSnapshot.id).update({
                    'name': name,
                    'price': price,
                  });

                  _nameController.text = '';
                  _priceController.text = '';

                  Navigator.pop(context);
                },
                child: Text('UPDATE'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _create() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Item',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * .3,
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown)),
                ),
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Price',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown)),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  final String name = _nameController.text;
                  final double price = double.parse(_priceController.text);

                  await _product.add({'name': name, 'price': price});

                  _nameController.text = '';
                  _priceController.text = '';

                  Navigator.pop(context);
                },
                child: Text('ADD'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _delete(String productId) async {
    await _product.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have successfully deleted a product',
        style: TextStyle(color: Colors.black),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          _create();
        },
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Firebase CRUD',
        ),
        centerTitle: true,
        backgroundColor: Colors.brown.shade600,
      ),
      body: StreamBuilder(
        stream: _product.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                documentSnapshot['name'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'RS ${documentSnapshot['price'].toString()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _update(documentSnapshot);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _delete(documentSnapshot.id);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                  ],
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: FirebaseCrud()));
}
