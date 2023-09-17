abstract class ApiClient {
  getRequest({required String url, Map<String, dynamic>? params});
  postRequest({required String url, Map<String, dynamic>? params});
  putRequest({required String url, Map<String, dynamic>? params});
  deleteRequest({required String url, Map<String, dynamic>? params});
}