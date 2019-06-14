# active_storage

Send files to Rails Active Storage using direct upload.

## Getting Started

First, you instantiate an `ActiveStorage` object, passing it your Rails' backend 
url where `ActiveStorage::DirectUploadsController` (or your customization of it) 
is responding.  

```dart
var activeStorage = ActiveStorage(
  directUploadURL: 'http://localhost:3000/rails/active_storage/direct_uploads',
);
```

Then, you just have to invoke the `upload()` method, passing it a `File` 
instance along with its info, like this:

```dart
DirectUploadResponse response = await activeStorage.upload(
  fileName: 'picture.jpg',
  fileMimeType: 'image/jpeg',
  file: File('my/picture.jpg'),
);
```

The returned `DirectUploadResponse` object provides a `signedId` getter. You 
should set that value in the API request attribute that your Rails backend will
be setting on the `ActiveRecord` model attribute "powered by" `ActiveStorage` 
(i.e. annotated with `has_one_attached`). 

## Custom Headers

It's very likely that your Rails backend's upload endpoint is accessible to 
authenticated users only. In that case, you'll need to pass an `Authorization`
header together with the upload request. To do so, you just have to invoke the
`addHeader()` method on the `ActiveStorage` instance, before invoking the 
`upload()` method. Like this:

```dart
activeStorage.addHeader(
  'Authorization',
  'Bearer ae38e518bfb4e2b11c2e5cefffe4581e66af07296cfec4b2299ab54a74ef3d8c',
);
```

Another case when you might want to set a custom header is for adding 
`User-Agent` information to your upload requests.

## Upload Progress

When uploading large files, it's important to be able to provide some feedback 
to your users about the progress. To do so, you have the option to pass a 
callback function to the `upload()` method, which would get called as many times
as the number of byte chunks that are sent to the server, and every time would 
receive a `double` representing the upload progress percentage. Like this:

```dart
DirectUploadResponse response = await activeStorage.upload(
  fileName: 'large.jpg',
  fileMimeType: 'image/jpeg',
  file: File('pics/large.jpg'),
  onProgress: (percent) {
    print('Uploaded ${percent.toStringAsFixed(2)}%');
  },
);
```
