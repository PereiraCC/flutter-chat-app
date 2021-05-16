import 'package:chat/services/chat_service.dart';
import 'package:chat/services/usuarios_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_services.dart';

import 'package:chat/models/usuario.dart';


class UsuariosPage extends StatefulWidget {

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuariosService = new UsuariosService();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final usuario       = Provider.of<AuthService>(context).usuario;
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre, style: TextStyle(color: Colors.black54)),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(  
          icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {

            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          
          Container(  
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online) 
                    ? Icon(Icons.check_circle, color: Colors.blue[400])
                    : Icon(Icons.offline_bolt, color: Colors.red)
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

    this.usuarios = await usuariosService.getUsuarios();
    setState(() {});

    // await Future.delayed(Duration(milliseconds: 1000));
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
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');

      },
    );
  }
}