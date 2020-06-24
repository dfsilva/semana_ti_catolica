import 'dart:io';

import 'package:catolica/service/usuario_service.dart';
import 'package:catolica/utils/message_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scafoldKey = GlobalKey<ScaffoldState>();

  final picker = ImagePicker();

  String _imagePath = "";

  UsuarioService _usuarioService;

  bool _showPassword = false;

  String _nome;
  String _email;
  String _senha;

  FocusNode _focusNome;
  FocusNode _focusEmail;
  FocusNode _focusSenha;

  @override
  void initState() {
    super.initState();
    this._focusNome = FocusNode();
    this._focusEmail = FocusNode();
    this._focusSenha = FocusNode();
  }

  @override
  void dispose() {
    this._focusNome.dispose();
    this._focusEmail.dispose();
    this._focusSenha.dispose();

    super.dispose();
  }

  _register() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _usuarioService.criarUsuario(_nome, _email, _senha, File(_imagePath)).catchError((error) {
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
        title: Text("Cadastrar-se"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 30),
            InkWell(
              onTap: () {
                _selecionarFoto();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3),
                child: Container(
                  height: MediaQuery.of(context).size.width / 4,
                  child: _imagePath.isEmpty ? Icon(Icons.camera_alt) : Image.file(File(_imagePath)),
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(6))),
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
                  this._nome = nome;
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
                validator: (email) {
                  if (email.isEmpty) {
                    return "Informe o email.";
                  }
                  return null;
                },
                onFieldSubmitted: (nome) {
                  this._focusEmail.unfocus();
                  this._focusSenha.requestFocus();
                },
                onSaved: (email) {
                  this._email = email;
                },
                decoration: InputDecoration(hintText: "email", labelText: "email", icon: Icon(Icons.email)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.send,
                focusNode: _focusSenha,
                validator: (senha) {
                  if (senha.isEmpty) {
                    return "Informe a senha.";
                  }
                  if (senha.length < 6) {
                    return "A senha deve conter mais de 6 caracteres.";
                  }
                  return null;
                },
                onFieldSubmitted: (nome) {
                  this._focusSenha.unfocus();
                  _register();
                },
                onSaved: (senha) {
                  this._senha = senha;
                },
                decoration: InputDecoration(
                    hintText: "senha",
                    labelText: "senha",
                    icon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            this._showPassword = !_showPassword;
                          });
                        })),
                obscureText: !_showPassword,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 5),
              child: RaisedButton(
                child: Text("Enviar"),
                onPressed: () {
                  _register();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
