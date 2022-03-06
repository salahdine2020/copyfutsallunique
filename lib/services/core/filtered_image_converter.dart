import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;

class FilteredImageConverter {
  static Future<File> convert({GlobalKey? globalKey}) async {
    var repaintBoundary = globalKey!.currentContext!.findRenderObject(); /// RenderRepaintBoundary
    //todo: ui.Image boxImage = await repaintBoundary?.toImage(pixelRatio: 1);
    //todo: ByteData? byteData = await boxImage.toByteData(format: ui.ImageByteFormat.png);
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/${Timestamp.now().toString()}.png');
    //todo: await file.writeAsBytes(byteData!.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
