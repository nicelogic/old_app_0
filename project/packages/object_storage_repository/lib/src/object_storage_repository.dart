import 'dart:convert';
import 'dart:developer';

import 'package:minio/minio.dart';

class ObjectStorageRepository {
  final Minio _minio;

  ObjectStorageRepository(
      {required String httpUrl,
      required String accessKey,
      required String secretKey,
      required int port})
      : _minio = Minio(
            endPoint: httpUrl,
            accessKey: accessKey,
            secretKey: secretKey,
            port: port);

  Future<bool> isObjectExist(
      {required String userId, required String objectName}) async {
    try {
      await _minio.getObject('user/$userId', objectName);
      return true;
    } on MinioError catch (e) {
      log(e.toString());
      return false;
    }
  }

  uploadObject(
      {required String userId,
      required String objectName,
      required Stream<List<int>> data,
      Map<String, String>? metaData}) async {
    const bucket = 'user';
    if (!await _minio.bucketExists(bucket)) {
      await _minio.makeBucket(bucket);
      const policy =
          '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS": ["*"]},"Action":["s3:GetBucketLocation","s3:ListBucket"],"Resource":  ["arn:aws:s3:::$bucket"]},{"Effect":"Allow","Principal":{"AWS":["*"]},"Action":  ["s3:GetObject"],"Resource":["arn:aws:s3:::$bucket/*"]}]}';
      await _minio.setBucketPolicy(bucket, jsonDecode(policy));
      log('bucket $bucket created');
    } else {
      log('bucket $bucket already exists');
    }

    await _minio.putObject(bucket, '$userId/$objectName', data,
        metadata: metaData);
  }

  uploadImage({
    required String userId,
    required String objectName,
    required Stream<List<int>> data,
  }) async {
    
    await uploadObject(
        userId: userId,
        objectName: objectName,
        data: data,
        metaData: {'content-type': 'image/png'});
  }
}
