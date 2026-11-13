import 'package:home_widget/home_widget.dart';

class IdeiaWidgetService {
  static const String nomeProvider =
      'com.example.livro_receitas.IdeiaWidgetProvider';

  static Future<bool> adicionarWidget() async {
    final suportado = await HomeWidget.isRequestPinWidgetSupported();

    if (suportado != true) {
      return false;
    }

    await HomeWidget.saveWidgetData<String>('ideia', 'Ideia');

    await HomeWidget.updateWidget(qualifiedAndroidName: nomeProvider);

    await HomeWidget.requestPinWidget(qualifiedAndroidName: nomeProvider);

    return true;
  }
}
