import 'document_meta_stub.dart'
    if (dart.library.html) 'document_meta_web.dart';

void setPageMeta({required String title, String? description}) {
  setPageMetaImpl(title: title, description: description);
}

void resetPageMeta() {
  resetPageMetaImpl();
}
