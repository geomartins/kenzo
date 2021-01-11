import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer {
  view({String url}) {
    print('ooops');
    return SfPdfViewer.network(url);
  }
}
