import 'dart:io';

import 'package:catolica/domain/usuario.dart';
import 'package:catolica/service/usuario_service.dart';
import 'package:catolica/utils/message_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final Usuario usuario;

  const EditProfileScreen({Key key, this.usuario}) : super(key: key);

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scafoldKey = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();

  String _imagePath = "";
  UsuarioService _usuarioService;

  Usuario _usuario;

  FocusNode _focusNome;
  FocusNode _focusEmail;

  @override
  void initState() {
    super.initState();
    this._focusNome = FocusNode();
    this._focusEmail = FocusNode();
    _usuario = widget.usuario;
  }

  @override
  void dispose() {
    this._focusNome.dispose();
    this._focusEmail.dispose();

    super.dispose();
  }

  _alterar() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _usuarioService.alterarUsuario(this._usuario, file: _imagePath.isNotEmpty ? File(_imagePath) : null).then((value) {
        Navigator.of(context).pop();
      }).catchError((error) {
        showError(error.message);
      });
    }
  }

  _selecionarFoto() {
    _scafoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 100,
        child: Column(
          children: [
            Container(
              height: 1,
              width: double.maxFinite,
              color: Colors.grey,
            ),
            InkWell(
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile = await picker.getImage(source: ImageSource.camera);
                final croppedFile = await ImageCropper.cropImage(
                    sourcePath: pickedFile.path,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    androidUiSettings: AndroidUiSettings(
                        toolbarTitle: 'Redimensionar',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false),
                    iosUiSettings: IOSUiSettings(
                      minimumAspectRatio: 1.0,
                    ));
                setState(() {
                  _imagePath = croppedFile.path;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  children: [Icon(Icons.camera_alt), Text("Câmera")],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              color: Colors.grey,
            ),
            InkWell(
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile = await picker.getImage(source: ImageSource.gallery);
                final croppedFile = await ImageCropper.cropImage(
                    sourcePath: pickedFile.path,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    androidUiSettings: AndroidUiSettings(
                        toolbarTitle: 'Redimensionar',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false),
                    iosUiSettings: IOSUiSettings(
                      minimumAspectRatio: 1.0,
                    ));
                setState(() {
                  _imagePath = croppedFile.path;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  children: [Icon(Icons.insert_drive_file), Text("Galeria")],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _usuarioService = Provider.of<UsuarioService>(context);

    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(
        title: Text("Editar usuário"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 30),
            Center(
              child: InkWell(
                onTap: () {
                  _selecionarFoto();
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: _imagePath.isEmpty && (_usuario.foto == null || _usuario.foto.isEmpty)
                      ? Icon(Icons.camera_alt)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _imagePath.isNotEmpty
                              ? Image.file(
                                  File(_imagePath),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  _usuario.foto,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(100)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autofocus: true,
                focusNode: this._focusNome,
                initialValue: this._usuario.nome,
                validator: (nome) {
                  if (nome.isEmpty) {
                    return "Informe o nome";
                  }
                  return null;
                },
                onFieldSubmitted: (nome) {
                  this._focusNome.unfocus();
                  this._focusEmail.requestFocus();
                },
                onSaved: (nome) {
                  this._usuario = this._usuario.copyWith(nome: nome);
                },
                decoration: InputDecoration(hintText: "nome", labelText: "nome", icon: Icon(Icons.account_box)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                focusNode: _focusEmail,
                textInputAction: TextInputAction.next,
                initialValue: _usuario.email,
                enabled: false,
                validator: (email) {
                  if (email.isEmpty) {
                    return "Informe o email.";
                  }
                  return null;
                },
                onFieldSubmitted: (nome) {
                  this._focusEmail.unfocus();
                },
                onSaved: (email) {
                  this._usuario = this._usuario.copyWith(email: email);
                },
                decoration: InputDecoration(hintText: "email", labelText: "email", icon: Icon(Icons.email)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
              child: RaisedButton(
                child: Text("Alterar"),
                onPressed: () {
                  _alterar();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
