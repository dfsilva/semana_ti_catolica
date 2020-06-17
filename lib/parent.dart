import 'package:catolica/stores/hud_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class ParentWidget extends StatefulWidget {
  final Widget child;

  const ParentWidget(this.child, {Key key}) : super(key: key);

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  HudStore _hudStore;

  @override
  Widget build(BuildContext context) {
    this._hudStore = Provider.of<HudStore>(context);

    return Observer(
      builder: (ctx) => ModalProgressHUD(
        child: widget.child,
        inAsyncCall: this._hudStore.exibindo,
        opacity: 0.5,
        progressIndicator: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              _hudStore.msg,
              style: Theme.of(ctx).primaryTextTheme.subtitle2,
            )
          ],
        ),
      ),
    );
  }
}
