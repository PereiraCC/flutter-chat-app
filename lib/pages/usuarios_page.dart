import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/models/usuario.dart';


class UsuariosPage extends StatefulWidget {

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: '1', nombre: 'Carlos', email: 'test1@test.com', online: true),
    Usuario(uid: '2', nombre: 'Maria', email: 'test2@test.com', online: false),
    Usuario(uid: '3', nombre: 'Melissa', email: 'test3@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {

    final usuario = Provider.of<AuthService>(context).usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre, style: TextStyle(color: Colors.black54)),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(  
          icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {

            //TODO: Desconectar el socket server
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          
          Container(  
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
            // child: Icon(Icons.offline_bolt, color: Colors.red)
          )

        ],
      ),
      body: SmartRefresher(  
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(  
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400],
        ),
        child: _ListViewUsuarios(usuarios: usuarios),
      ),
   );
  }

  _cargarUsuarios() async{

    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();

  }
}

class _ListViewUsuarios extends StatelessWidget {
  final List<Usuario> usuarios;

  const _ListViewUsuarios({
    Key key,
    @required this.usuarios,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _UsuarioListTile(usuario: usuarios[i]), 
      separatorBuilder: (_, i) => Divider(),
      itemCount: usuarios.length
    );
  }
}

class _UsuarioListTile extends StatelessWidget {

  final Usuario usuario;

  const _UsuarioListTile({
    Key key,
    @required this.usuario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar( 
        child: Text(usuario.nombre.substring(0,2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(  
        width: 10,
        height: 10,
        decoration: BoxDecoration(  
          color: usuario.online ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(100)
        ),
      ),
    );
  }
}