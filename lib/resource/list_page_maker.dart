import 'dart:async';
import 'package:admin_client/admin_client.dart';

typedef FutureOr<TableRow> ListPageRowMaker<T>(T model);

class ListPageMaker<T> {
  List<ColumnSpec> colSpec;

  ListPageRowMaker<T> rowMaker;

  // TODO actions
  // TODO filters
  // TODO table
  // TODO pagination

  ListPageMaker({this.colSpec, this.rowMaker}) {
    colSpec.insert(0, ColumnSpec(''));
  }

  View makeHeader() {
    return Box();
  }

  View makeFilter() {
    return Box();
  }

  Future<View> makeTable(List<T> model, Resource<T> r, Context ctx) async {
    final rows = new List<TableRow>.filled(model.length, null, growable: true);
    for (int i = 0; i < model.length; i++) {
      TableRow row = await rowMaker(model[i]);
      row.cells[''] = Box(children: [
        Button(
            text: '\u261b',
            fontSize: 24,
            callback: () {
              ctx.navigator.add(Route(r.readUrl));
            }),
        Button(
            text: '\u270D',
            fontSize: 24,
            callback: () {
              ctx.navigator.add(Route(r.updateUrl));
            }),
        Button(
            text: '\u00d7',
            fontSize: 24,
            color: Button.red,
            callback: () {
              // TODO delete
            }),
      ]);
      rows[i] = row;
    }
    return Box(children: [Table(spec: colSpec, rows: rows)]);
  }

  View makePaginator() {
    return Box();
  }

  Future<View> makeView(List<T> model, Resource<T> r, Context ctx) async {
    return Box(children: [
      makeHeader(),
      makeFilter(),
      await makeTable(model, r, ctx),
      makePaginator(),
    ]);
  }
}
