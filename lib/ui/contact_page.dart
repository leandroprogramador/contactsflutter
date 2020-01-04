import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:contactsflutter/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool _userEdited;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(_editedContact.name ?? "Novo Contato"),
            backgroundColor: Colors.red,
          ),
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedContact.name == null || _editedContact.name.isEmpty) {
                FocusScope.of(context).requestFocus(_nameFocus);
              } else if (_editedContact.email == null ||
                  _editedContact.email.isEmpty) {
                FocusScope.of(context).requestFocus(_emailFocus);
              } else if (_editedContact.phone == null ||
                  _editedContact.phone.isEmpty) {
                FocusScope.of(context).requestFocus(_phoneFocus);
              } else {
                Navigator.pop(context, _editedContact);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image:
                          DecorationImage(
                            image: _editedContact.img != null
                                ? FileImage(File(_editedContact.img))
                                : AssetImage("images/person.png"),
                            fit: BoxFit.cover
                          ),

                    ),
                  ),
                  onTap: (){
                    ImagePicker.pickImage(source: ImageSource.camera).then((file){
                      if(file == null) return;
                      setState(() {
                        _editedContact.img = file.path;
                      });
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Nome"),
                  focusNode: _nameFocus,
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedContact.name = text;
                    });
                  },
                  controller: _nameController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "E-mail"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.email = text;
                  },
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                TextField(
                  focusNode: _phoneFocus,
                  decoration: InputDecoration(labelText: "Telefone"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.phone = text;
                  },
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                ),
              ],
            ),
          ),
        ),
        onWillPop: _requestPop
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Descartar alterações?"),
            content: Text("Se sair, as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);

                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
      return Future.value(false);

    } else{
      return Future.value(true);
    }
  }

}
