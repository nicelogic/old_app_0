// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   test('adds one to input values', () {
//     expect(1, 1);
//   });
// }

// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';

void main() async {
  final minio = Minio(
    endPoint: 'niceice.cn',
    accessKey: 'admin',
    secretKey: 'password',
    port: 9000,
    useSSL: true,
    // enableTrace: true,
  );

  const bucket = 'test';
  const object = 'custed.png';
  const copy1 = 'custed.copy1.png';
  const copy2 = 'custed.copy2.png';

  if (!await minio.bucketExists(bucket)) {
    await minio.makeBucket(bucket);
    const policy =
        '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS": ["*"]},"Action":["s3:GetBucketLocation","s3:ListBucket"],"Resource":  ["arn:aws:s3:::$bucket"]},{"Effect":"Allow","Principal":{"AWS":["*"]},"Action":  ["s3:GetObject"],"Resource":["arn:aws:s3:::$bucket/*"]}]}';
    await minio.setBucketPolicy(bucket, jsonDecode(policy));

    print('bucket $bucket created');
  } else {
    print('bucket $bucket already exists');
  }

  final poller = minio.listenBucketNotification(bucket, events: [
    's3:ObjectCreated:*',
  ]);
  poller.stream.listen((event) {
    print('--- event: ${event['eventName']}');
  });

  final region = await minio.getBucketRegion('test');
  print('--- object region:');
  print(region);

  final etag = await minio.fPutObject(bucket, object, 'test/$object');
  print('--- etag:');
  print(etag);

  try {
    final result = await minio.getObject(bucket, '123');
    print(result.contentLength);
  } catch (e) {
    print(e.toString());
  }

  // Stream<List<int>> data;
  // minio.putObject(bucket, object, data);

  final url = await minio.presignedGetObject(bucket, object, expires: 1000);
  print('--- presigned url:');
  print(url);

  final copyResult1 = await minio.copyObject(bucket, copy1, '$bucket/$object');
  final copyResult2 = await minio.copyObject(bucket, copy2, '$bucket/$object');
  print('--- copy1 etag:');
  print(copyResult1.eTag);
  print('--- copy2 etag:');
  print(copyResult2.eTag);

  await minio.fGetObject(bucket, object, 'test/$copy1');
  print('--- copy1 downloaded');

  await minio.listObjects(bucket).forEach((chunk) {
    print('--- objects:');
    for (var o in chunk.objects) {
      print(o.key);
    }
  });

  await minio.listObjectsV2(bucket).forEach((chunk) {
    print('--- objects(v2):');
    for (var o in chunk.objects) {
      print(o.key);
    }
  });

  final stat = await minio.statObject(bucket, object);
  print('--- object stat:');
  print(stat.etag);
  print(stat.size);
  print(stat.lastModified);
  print(stat.metaData);

  // await minio.removeObject(bucket, object);
  // print('--- object removed');

  // await minio.removeObjects(bucket, [copy1, copy2]);
  // print('--- copy1, copy2 removed');

  // await minio.removeBucket(bucket);
  // print('--- bucket removed');

  poller.stop();
  test('object storage repository test', () {
    expect(1, 1);
  });
}
