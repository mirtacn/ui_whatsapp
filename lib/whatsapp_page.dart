import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ui_whatsapp/models/widgets/calls_view.dart';
import 'package:ui_whatsapp/models/widgets/camera_view.dart';
import 'package:ui_whatsapp/models/widgets/chat_view.dart';
import 'package:ui_whatsapp/models/widgets/status_view.dart';
import 'package:ui_whatsapp/theme.dart';

class WhatsAppPage extends StatefulWidget {
  const WhatsAppPage({Key? key}) : super(key: key);

  @override
  State<WhatsAppPage> createState() => _WhatsAppPageState();
}

class _WhatsAppPageState extends State<WhatsAppPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late IconData fabIcon;
  late CameraDescription firstCamera;

  @override
  void initState() {
    super.initState();
    fabIcon = Icons.message;
    initializeCamera();
    tabController = TabController(length: 4, vsync: this);
    tabController.index = 1;
    tabController.addListener(() {
      setState(() {
        switch (tabController.index) {
          case 0:
            fabIcon = Icons.camera;
            break;
          case 1:
            fabIcon = Icons.message;
            break;
          case 2:
            fabIcon = Icons.camera_alt;
            break;
          case 3:
            fabIcon = Icons.call;
            break;
          default:
        }
      });
    });
  }

  Future<void> initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    setState(() {
      firstCamera = cameras.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp"),
        backgroundColor: whatsAppGreen,
        actions: const [
          Icon(Icons.search),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.more_vert),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(text: "CHAT"),
            Tab(text: "STATUS"),
            Tab(text: "CALL"),
          ],
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          
          TakePictureScreen(camera: firstCamera),
          const ChatView(),
          const StatusView(),
          const CallsView(),
        ],
      ),
      floatingActionButton: tabController.index == 0
          ? null
          : FloatingActionButton(
              backgroundColor: whatsAppLightGreen,
              onPressed: () {},
              child: Icon(fabIcon),
            ),
    );
  }
}