import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../Providers/product.dart';
import '../Providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const routeName = '/static-route';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  var _isLoading = false;
  final _form = GlobalKey<
      FormState>(); //we use global key when we need to interact with a widget inside our code like form here and global key can hook into the state of the widget
  var _editedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0);

  var _inItValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageURL': ''
  };

  Future<bool> validateImage(String imageUrl) async {
    Response res;
    try {
      res = await get(Uri.parse(imageUrl));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return false;
    }
    if (res.statusCode != 200) {
      setState(() {
        _isLoading = false;
      });
      return false;
    }
    Map<String, dynamic> data = res.headers;
    if (checkIfImage(data['content-type'])) {
      return true;
    }
    return false;
  }

  bool checkIfImage(String param) {
    if (param == 'image/jpeg' ||
        param == 'image/png' ||
        param == 'image/gif' ||
        param == 'image/jpg') {
      return true;
    }
    return false;
  }

  bool _isInIt = true;
  @override
  void didChangeDependencies() {
    //runs before builds
    //we do that (the bool condition) here to not run this method everytime the widget is rebuilt cuz did change dependecies runs multiple time but only when it is navigated to the first time
    if (_isInIt) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _inItValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          // 'imageURL': _editedProduct.imageUrl,
          'price': _editedProduct.price.toString()
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInIt = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  // final _priceFocusNode = FocusNode();
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    //   _priceFocusNode
    //       .dispose(); //if we use a focus nodes we have to dispose them after leaving the page cuz it will stick in memory so we need to prevent memory leak
    super.dispose();
  }

  // bool isValid(String imageUrl) {
  //   bool isURLValid = Uri.parse(imageUrl).host.isNotEmpty;

  //   return isURLValid;
  // }

  Future<void> _saveForm() async {
    final isValid = _form.currentState
        ?.validate(); //validate returns true if the returned value is null and if it string it return false
    if (!isValid!) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    if (!await validateImage(_imageUrlController.text)) {
      return;
    }
    setState(() {
      _isLoading = false;
    });

    _form.currentState?.save();
    if (_editedProduct.id.isNotEmpty) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occured!'),
            content: const Text('something went wrong'),
            actions: [
              TextButton(
                  onPressed: (() => Navigator.of(context).pop()),
                  child: const Text('okay'))
            ],
          ),
        );
      } //context is available here becuz we r in the state object

    }
    Navigator.of(context).pop();
  }

//  void _saveForm() async {
//     final isValid = _form.currentState
//         ?.validate(); //validate returns true if the returned value is null and if it string it return false
//     if (!isValid!) {
//       return;
//     }
//     setState(() {
//       _isLoading = true;
//     });
//     if (!await validateImage(_imageUrlController.text)) {
//       return;
//     }
//     setState(() {
//       _isLoading = false;
//     });

//     _form.currentState?.save();
//     if (_editedProduct.id.isNotEmpty) {
//       Provider.of<Products>(context, listen: false)
//           .updateProduct(_editedProduct.id, _editedProduct);
//       Navigator.pop(context);
//     } else {
//       Provider.of<Products>(context, listen: false)
//           .addProduct(_editedProduct)
//           .catchError((error) {
//         return showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: const Text('An error occured!'),
//             content: const Text('something went wrong'),
//             actions: [
//               TextButton(
//                   onPressed: (() => Navigator.of(context).pop()),
//                   child: const Text('okay'))
//             ],
//           ),
//         );
//       }).then((_) => Navigator.pop(
//               context)); //context is available here becuz we r in the state object
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: FittedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _saveForm();
                    });
                  },
                  icon: const Icon(Icons.save))
        ],
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            //form is a statefull widget
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _inItValues['title'],
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: ((value) => _form.currentState?.validate()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide a Title';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: newValue!,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        isFavorite: _editedProduct
                            .isFavorite); //here the is favorite is for us not to lose the previous favorite status when editing the product
                  },
                  // onFieldSubmitted: (_) =>
                  //     FocusScope.of(context).requestFocus(_priceFocusNode), //this is how the next works but it is default anyways
                ),
                TextFormField(
                  initialValue: _inItValues['price'],
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: ((value) => _form.currentState?.validate()),
                  onChanged: (value) => _form.currentState?.validate(),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide a price';
                    }
                    if (double.tryParse(value) == null) {
                      //tryparse return null if it is not a number
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'please enter a number greater than zero';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: double.parse(newValue!),
                        isFavorite: _editedProduct.isFavorite);
                  },
                  // focusNode: _priceFocusNode,
                ),
                TextFormField(
                  initialValue: _inItValues['description'],
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  onChanged: (_) => _form.currentState?.validate(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide a Description';
                    }
                    if (value.length < 10) {
                      return 'Should be at least 10 characters';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: newValue!,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        isFavorite: _editedProduct.isFavorite);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrlController.text.isEmpty
                          ? const Center(
                              child: Text(
                                'Enter Image URL',
                                textAlign: TextAlign.center,
                              ),
                            )
                          : FutureBuilder(
                              future: validateImage(_imageUrlController.text),
                              builder: (context, snapshot) {
                                var valid = snapshot.data;
                                if (!snapshot.hasData) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return valid!
                                      ? FittedBox(
                                          child: Image.network(
                                          _imageUrlController.text,
                                          errorBuilder:
                                              ((context, error, stackTrace) {
                                            return const Text('Not ok!');
                                          }),
                                        ))
                                      : const Center(
                                          child: Text(
                                            'Not valid!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        );
                                }
                              },
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        // initialValue: _inItValues['imageURL'], //we cant use initial value and controller at the same time so we will change the controller text value
                        //text form field take as much width as it can so wrapping it with a row will not work cuz rows give unconstraint width
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide an image URL';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          _form.currentState?.validate();
                        },
                        onEditingComplete: () {
                          setState(() {
                            FocusManager.instance.primaryFocus?.unfocus();
                          });
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: newValue!,
                              price: _editedProduct.price,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
