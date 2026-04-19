import 'dart:html' as html;

const _defaultTitle = 'Woxa — Institutional Brokers';
const _defaultDescription =
    'Access global liquidity through our curated network of elite financial institutions and market makers.';

void setPageMetaImpl({required String title, String? description}) {
  html.document.title = title;
  final meta = html.document.querySelector('meta[name="description"]');
  if (meta != null && description != null) {
    meta.setAttribute('content', description);
  }
}

void resetPageMetaImpl() {
  html.document.title = _defaultTitle;
  final meta = html.document.querySelector('meta[name="description"]');
  if (meta != null) {
    meta.setAttribute('content', _defaultDescription);
  }
}
