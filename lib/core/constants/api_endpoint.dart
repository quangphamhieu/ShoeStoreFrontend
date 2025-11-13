class ApiEndpoint {
  static const baseUrl = "https://localhost:7097/api"; // thay bằng port backend
  static const brands = "$baseUrl/brands";
  static const stores = "$baseUrl/store";
  static const suppliers = "$baseUrl/supplier";
  static const products = "$baseUrl/products"; // ASP.NET Core routes are case-insensitive
}
