import 'package:shared_preferences/shared_preferences.dart';

/// variables containe values

abstract class SaveValues {
  Future<void> savevalueid1(String id);
  // /// --------- save etape widget
  // Future<void> savevalueetape1set(int etape1);
  // Future<void> savevalueetape2set(int etape1);
  // Future<void> savevalueetape3set(int etape1);
  // Future<void> savevalueetape4set(int etape1);
  // /// --------- save timer start values
  // Future<void> savevaluetimeretape1set({bool timer1 = false});
  // Future<void> savevaluetimeretape2set({bool timer2 = false});
  // Future<void> savevaluetimeretape3set({bool timer3 = false});
  // Future<void> savevaluetimeretape4set({bool timer4 = false});


}

abstract class GetValues {
  Future<String> getvalueid1();
  // /// ---------- get etape widget
  // Future<int> getvalueetape1set();
  // Future<int> getvalueetape2set();
  // Future<int> getvalueetape3set();
  // Future<int> getvalueetape4set();
  // /// ---------- get timer value start
  // Future<bool> getvaluetimeretape1set();
  // Future<bool> getvaluetimeretape2set();
  // Future<bool> getvaluetimeretape3set();
  // Future<bool> getvaluetimeretape4set();
}

abstract class DeletValues {
  Future<void> deletvalueid1();
  // /// ----------- delet etape save widget
  // Future<void> deletvalueetape1set();
  // Future<void> deletvalueetape2set();
  // Future<void> deletvalueetape3set();
  // Future<void> deletvalueetape4set();
  // /// ----------- delet save timer
  // Future<void> deletvaluetimeretape1set();
  // Future<void> deletvaluetimeretape2set();
  // Future<void> deletvaluetimeretape3set();
  // Future<void> deletvaluetimeretape4set();
}
/// class SaveValuesEtapes extends from abstract SaveValues to save values
class SaveValuesEtapes extends SaveValues{
  @override
  Future<void> savevalueid1(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    prefs.setString('id', id);
  }

  // @override
  // Future<void> savevalueetape1set(int etape1) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape1set');
  //   prefs.setInt('value_etape1set', etape1);
  // }
  // @override
  // Future<void> savevalueetape2set(int etape1) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape2set');
  //   prefs.setInt('value_etape2set', etape1);
  // }
  // @override
  // Future<void> savevalueetape3set(int etape1) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape3set');
  //   prefs.setInt('value_etape3set', etape1);
  // }
  // @override
  // Future<void> savevalueetape4set(int etape1) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape4set');
  //   prefs.setInt('value_etape4set', etape1);
  // }
  // @override
  // Future<void> savevaluetimeretape1set({bool timer1 = false}) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape1timerset');
  //   prefs.setBool('value_etape1timerset', timer1);
  // }
  // @override
  // Future<void> savevaluetimeretape2set({bool timer2 = false}) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape2timerset');
  //   prefs.setBool('value_etape2timerset', timer2);
  // }
  // @override
  // Future<void> savevaluetimeretape3set({bool timer3 = false}) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape3timerset');
  //   prefs.setBool('value_etape3timerset', timer3);
  // }
  // @override
  // Future<void> savevaluetimeretape4set({bool timer4 = false}) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape4timerset');
  //   prefs.setBool('value_etape4timerset', timer4);
  // }
}
/// class GetValuesEtapes extends from GetValues to get values
class GetValuesEtapes extends GetValues{

  @override
  Future<String> getvalueid1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    return id ?? "";
  }

  // @override
  // Future<int> getvalueetape1set() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int etape1 = prefs.getInt('value_etape1set');
  //   return etape1;
  // }
  // @override
  // Future<int> getvalueetape2set() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int etape1 = prefs.getInt('value_etape2set');
  //   return etape1;
  // }
  // @override
  // Future<int> getvalueetape3set() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int etape1 = prefs.getInt('value_etape3set');
  //   return etape1;
  // }
  // @override
  // Future<int> getvalueetape4set() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int etape1 = prefs.getInt('value_etape4set');
  //   return etape1;
  // }
  // @override
  // Future<bool> getvaluetimeretape1set() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool etape1 = prefs.getBool('value_etape1timerset') ?? false;
  //   return etape1;
  // }
  // @override
  // Future<bool> getvaluetimeretape2set() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool etape1 = prefs.getBool('value_etape2timerset') ?? false;
  //   return etape1;
  // }
  // @override
  // Future<bool> getvaluetimeretape3set() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool etape1 = prefs.getBool('value_etape3timerset') ?? false;
  //   return etape1;
  // }
  // @override
  // Future<bool> getvaluetimeretape4set() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool etape1 = prefs.getBool('value_etape4timerset') ?? false;
  //   return etape1;
  // }
}
/// class DeletValuesEtapes extends from DeletValues to delet one value or to delet all value
class DeletValuesEtapes extends DeletValues{

  @override
  Future<void> deletvalueid1() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
  }

  // @override
  // Future<void> deletvalueetape1set() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape1set');
  // }
  // @override
  // Future<void> deletvalueetape2set() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape2set');
  // }
  // @override
  // Future<void> deletvalueetape3set() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape3set');
  // }
  // @override
  // Future<void> deletvalueetape4set() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape4set');
  // }
  // @override
  // Future<void> deletvaluetimeretape1set() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape1timerset');
  // }
  // @override
  // Future<void> deletvaluetimeretape2set() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape2timerset');
  // }
  // @override
  // Future<void> deletvaluetimeretape3set() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape3timerset');
  // }
  // @override
  // Future<void> deletvaluetimeretape4set() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('value_etape4timerset');
  // }
}
