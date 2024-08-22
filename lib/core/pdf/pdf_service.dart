import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:calcard_app/models/instrument_test.dart';

import '../../models/instrument_test_point.dart';

class PdfService {

  int pageCount = 1;
  List<pw.Table> tables = [];

  Future<String> savePdfToFile(Uint8List pdfData) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/test_overview.pdf');
    await file.writeAsBytes(pdfData);
    return file.path;
  }

  Future<Uint8List> generateTestOverviewPdf(InstrumentTest activeTest) async {
    _makeBottomTable(activeTest);
    final baseValues = activeTest.baseValues;
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: pw.Font.ttf(await rootBundle.load("fonts/arial.ttf")),
        bold: pw.Font.ttf(await rootBundle.load("fonts/arialbold.ttf")),
      ),
    );
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        activeTest.tester!.companyName,
                        style: pw.TextStyle(
                          font: pw.Font.helveticaBold(),
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueGrey800,
                        ),
                      ),
                      pw.Text(
                        'Electrical Test Instrument Accuracy Record',
                        style: pw.TextStyle(
                          font: pw.Font.helveticaBold(),
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueGrey400,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(activeTest.tester!.address),
                      pw.Text(activeTest.tester!.phone),
                      pw.Text(activeTest.tester!.email),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 24),
              pw.Table(
                border: pw.TableBorder.all(),
                children: _makeTopTable(activeTest),
              ),
              pw.SizedBox(height: 24),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Container(
                        color: PdfColors.blue400, // Set the background color
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'Baseline Reference',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Table(
                  columnWidths: {
                    0: const pw.FractionColumnWidth(0.13),
                    1: const pw.FractionColumnWidth(0.35),
                    2: const pw.FractionColumnWidth(0.35),
                    3: const pw.FractionColumnWidth(0.09),
                    4: const pw.FractionColumnWidth(0.08),
                  },
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      verticalAlignment: pw.TableCellVerticalAlignment.middle,
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.blueGrey200,
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Center(
                            child: pw.Text('Date',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.center),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(0),
                          child: pw.Column(
                            children: [
                              pw.SizedBox(height: 31),
                              pw.Center(
                                child: pw.Text(
                                  'Insulation Resistance (MΩ)',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Table(
                                  border: pw.TableBorder.all(),
                                  columnWidths: {
                                    0: const pw.FlexColumnWidth(),
                                    1: const pw.FlexColumnWidth(),
                                    2: const pw.FlexColumnWidth(),
                                    3: const pw.FlexColumnWidth(),
                                    4: const pw.FlexColumnWidth(),
                                  },
                                  children: [
                                    pw.TableRow(
                                      children: [
                                        pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                          child: pw.Align(
                                            alignment: pw.Alignment.center,
                                            child: pw.Text(
                                              style: const pw.TextStyle(
                                                fontSize: 11,
                                              ),
                                              '0.5\nMΩ',
                                              textAlign: pw.TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                          child: pw.Align(
                                            alignment: pw.Alignment.center,
                                            child: pw.Text(
                                              style: const pw.TextStyle(
                                                fontSize: 11,
                                              ),
                                              '1\nMΩ',
                                              textAlign: pw.TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                          child: pw.Align(
                                            alignment: pw.Alignment.center,
                                            child: pw.Text(
                                              style: const pw.TextStyle(
                                                fontSize: 11,
                                              ),
                                              '2\nMΩ',
                                              textAlign: pw.TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                          child: pw.Align(
                                            alignment: pw.Alignment.center,
                                            child: pw.Text(
                                              style: const pw.TextStyle(
                                                fontSize: 11,
                                              ),
                                              '10\nMΩ',
                                              textAlign: pw.TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                          child: pw.Align(
                                            alignment: pw.Alignment.center,
                                            child: pw.Text(
                                              style: const pw.TextStyle(
                                                fontSize: 11,
                                              ),
                                              '20\nMΩ',
                                              textAlign: pw.TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(0),
                          child: pw.Column(
                            children: [
                              pw.SizedBox(height: 31),
                              pw.Center(
                                child: pw.Text(
                                  'Continuity (Ω)',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Table(
                                  border: pw.TableBorder.all(),
                                  columnWidths: {
                                    0: const pw.FlexColumnWidth(),
                                    1: const pw.FlexColumnWidth(),
                                    2: const pw.FlexColumnWidth(),
                                    3: const pw.FlexColumnWidth(),
                                    4: const pw.FlexColumnWidth(),
                                  },
                                  children: [
                                    pw.TableRow(
                                      children: [
                                        pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                          child: pw.Align(
                                            alignment: pw.Alignment.center,
                                            child: pw.Text(
                                              style: const pw.TextStyle(
                                                fontSize: 11,
                                              ),
                                              '0.25\nΩ',
                                              textAlign: pw.TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                          child: pw.Align(
                                            alignment: pw.Alignment.center,
                                            child: pw.Text(
                                              style: const pw.TextStyle(
                                                fontSize: 11,
                                              ),
                                              '0.5\nΩ',
                                              textAlign: pw.TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                          child: pw.Align(
                                            alignment: pw.Alignment.center,
                                            child: pw.Text(
                                              style: const pw.TextStyle(
                                                fontSize: 11,
                                              ),
                                              '1\nΩ',
                                              textAlign: pw.TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                          child: pw.Align(
                                            alignment: pw.Alignment.center,
                                            child: pw.Text(
                                              style: const pw.TextStyle(
                                                fontSize: 11,
                                              ),
                                              '2\nΩ',
                                              textAlign: pw.TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                          child: pw.Align(
                                            alignment: pw.Alignment.center,
                                            child: pw.Text(
                                              style: const pw.TextStyle(
                                                fontSize: 11,
                                              ),
                                              '5\nΩ',
                                              textAlign: pw.TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Center(
                            child: pw.Text('Earth Fault Loop (Ω)',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.center),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Center(
                            child: pw.Text('RCD (ms)',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                  ]),
              pw.Table(
                columnWidths: {
                  0: const pw.FractionColumnWidth(0.13),
                  1: const pw.FractionColumnWidth(0.07),
                  2: const pw.FractionColumnWidth(0.07),
                  3: const pw.FractionColumnWidth(0.07),
                  4: const pw.FractionColumnWidth(0.07),
                  5: const pw.FractionColumnWidth(0.07),
                  6: const pw.FractionColumnWidth(0.07),
                  7: const pw.FractionColumnWidth(0.07),
                  8: const pw.FractionColumnWidth(0.07),
                  9: const pw.FractionColumnWidth(0.07),
                  10: const pw.FractionColumnWidth(0.07),
                  11: const pw.FractionColumnWidth(0.09),
                  12: const pw.FractionColumnWidth(0.08),
                },
                border: pw.TableBorder.all(),
                children: [
                  if (baseValues != null) ...[
                    pw.TableRow(
                      children: [
                        _buildTableCell(baseValues.date),
                        _buildTableCell('${baseValues.insulation[0]}'),
                        _buildTableCell('${baseValues.insulation[1]}'),
                        _buildTableCell('${baseValues.insulation[2]}'),
                        _buildTableCell('${baseValues.insulation[3]}'),
                        _buildTableCell('${baseValues.insulation[4]}'),
                        _buildTableCell('${baseValues.continuity[0]}'),
                        _buildTableCell('${baseValues.continuity[1]}'),
                        _buildTableCell('${baseValues.continuity[2]}'),
                        _buildTableCell('${baseValues.continuity[3]}'),
                        _buildTableCell('${baseValues.continuity[4]}'),
                        _buildTableCell('${baseValues.zs}'),
                        _buildTableCell('${baseValues.rcd}'),
                      ],
                    ),
                  ]
                ],
              ),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Container(
                        color: PdfColors.red400, // Set the background color
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'Monthly Checks',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              this.tables[0],
            ],
          );
        },
      ),
    );
    for(int i = 1; i < pageCount && i < tables.length; i++) {
      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(24),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          color: PdfColors.red400, // Set the background color
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Align(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              'Monthly Checks',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                tables[i],
              ],
            );
          },
        ),
      );
    };
    return pdf.save();
  }

  void _makeBottomTable(InstrumentTest activeTest) {
    List<pw.Table> tables = [];
    List<pw.TableRow> rows = [];
    InstrumentTestPoint testPoint;

    if (activeTest.testPoints.isNotEmpty) {
      for (testPoint in activeTest.testPoints!) {
        rows.add(
          pw.TableRow(
            children: [
              _buildTableCell(testPoint.date),
              _buildTableCell('${testPoint.insulation[0]}'),
              _buildTableCell('${testPoint.insulation[1]}'),
              _buildTableCell('${testPoint.insulation[2]}'),
              _buildTableCell('${testPoint.insulation[3]}'),
              _buildTableCell('${testPoint.insulation[4]}'),
              _buildTableCell('${testPoint.continuity[0]}'),
              _buildTableCell('${testPoint.continuity[1]}'),
              _buildTableCell('${testPoint.continuity[2]}'),
              _buildTableCell('${testPoint.continuity[3]}'),
              _buildTableCell('${testPoint.continuity[4]}'),
              _buildTableCell('${testPoint.zs}'),
              _buildTableCell('${testPoint.rcd}'),
            ],
          ),
        );

        if ((rows.length >= 14 && pageCount == 1) || rows.length >= 25) {
          pageCount++;
          tables.add(pw.Table(
            columnWidths: {
              0: const pw.FractionColumnWidth(0.13),
              1: const pw.FractionColumnWidth(0.07),
              2: const pw.FractionColumnWidth(0.07),
              3: const pw.FractionColumnWidth(0.07),
              4: const pw.FractionColumnWidth(0.07),
              5: const pw.FractionColumnWidth(0.07),
              6: const pw.FractionColumnWidth(0.07),
              7: const pw.FractionColumnWidth(0.07),
              8: const pw.FractionColumnWidth(0.07),
              9: const pw.FractionColumnWidth(0.07),
              10: const pw.FractionColumnWidth(0.07),
              11: const pw.FractionColumnWidth(0.09),
              12: const pw.FractionColumnWidth(0.08),
            },
            border: pw.TableBorder.all(),
            children: rows,
          ));
          rows = [];
        }
      }

      // Add the remaining rows
      if (rows.isNotEmpty) {
        tables.add(pw.Table(
          columnWidths: {
            0: const pw.FractionColumnWidth(0.13),
            1: const pw.FractionColumnWidth(0.07),
            2: const pw.FractionColumnWidth(0.07),
            3: const pw.FractionColumnWidth(0.07),
            4: const pw.FractionColumnWidth(0.07),
            5: const pw.FractionColumnWidth(0.07),
            6: const pw.FractionColumnWidth(0.07),
            7: const pw.FractionColumnWidth(0.07),
            8: const pw.FractionColumnWidth(0.07),
            9: const pw.FractionColumnWidth(0.07),
            10: const pw.FractionColumnWidth(0.07),
            11: const pw.FractionColumnWidth(0.09),
            12: const pw.FractionColumnWidth(0.08),
          },
          border: pw.TableBorder.all(),
          children: rows,
        ));
      }
      this.tables = tables;
    } else{
      this.tables = [pw.Table()];
    }
  }


  List<pw.TableRow> _makeTopTable(InstrumentTest activeTest) {
    List<Map<String, String>> leftValues = [];
    List<Map<String, String>> rightValues = [];

    if (activeTest.instrument!.make != "" ||
        activeTest.instrument!.model != "") {
      leftValues.add({
        'title': 'Instrument Make and Model',
        'value':
            '${activeTest.instrument!.make} ${activeTest.instrument!.model}'
      });
    }

    if (activeTest.tester!.name != "") {
      rightValues.add(
          {'title': 'Name of Test Engineer', 'value': activeTest.tester!.name});
    }

    if (activeTest.instrument!.serialNum != "") {
      leftValues.add({
        'title': 'Instrument Serial Number',
        'value': activeTest.instrument!.serialNum
      });
    }

    if (activeTest.tester!.NICEICNumber != "") {
      rightValues.add(
          {'title': 'NICEIC Number', 'value': activeTest.tester!.NICEICNumber});
    }

    if (activeTest.instrument!.acquisitionDate != "") {
      leftValues.add({
        'title': 'Instrument Acquisition Date',
        'value': activeTest.instrument!.acquisitionDate
      });
    }

    if (activeTest.tester!.calcardSerialNumber != "") {
      rightValues.add({
        'title': 'CalCard Serial Number',
        'value': activeTest.tester!.calcardSerialNumber
      });
    }

    List<pw.TableRow> rows = [];
    int maxLength = leftValues.length > rightValues.length
        ? leftValues.length
        : rightValues.length;

    for (int i = 0; i < maxLength; i++) {
      String leftTitle = i < leftValues.length ? leftValues[i]['title']! : '';
      String leftValue = i < leftValues.length ? leftValues[i]['value']! : '';
      String rightTitle =
          i < rightValues.length ? rightValues[i]['title']! : '';
      String rightValue =
          i < rightValues.length ? rightValues[i]['value']! : '';

      rows.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(leftTitle,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(leftValue),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(rightTitle,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(rightValue),
            ),
          ],
        ),
      );
    }
    return rows;
  }

  pw.Widget _buildTableCell(String text, [bool isHeader = false]) {
    // Convert numeric text to handle special cases
    String displayText = text == '-1.0' ? '-' : text;

    return pw.Container(
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8.0), // Adjust vertical padding here
        child: pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Text(
            displayText,
            style: pw.TextStyle(
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

}
