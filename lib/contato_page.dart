import 'dart:io';

import 'package:liscacontatos/contato_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contato contact;

  ContactPage({required this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _telefoneController = TextEditingController();

  //final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _nameFocus = FocusNode();

  late Contato _editedContact;

  bool _userEdited = false;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contato();
    } else {
      _editedContact = Contato.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.nome;
      _emailController.text = _editedContact.email;
      _telefoneController.text = _editedContact.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.nome ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.nome != null && _editedContact.nome.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: const Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: _editedContact.imagem != null
                        ? DecorationImage(
                            image: FileImage(File(_editedContact.imagem)),
                            fit: BoxFit.cover)
                        : const DecorationImage(
                            image: AssetImage("images/person.png"),
                            fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  ImagePicker.platform
                      .pickImage(source: ImageSource.camera)
                      .then((file) {
                    if (file == null) return;
                    setState(() {
                      _editedContact.setImagem(file.path);
                    });
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.setNome(text);
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.setEmail(text);
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.setTelefone(text);
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      //perguntar
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text(
                  "Tem certeza que deseja sair, suas alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });

      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
