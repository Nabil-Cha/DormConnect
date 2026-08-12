abstract class Routes {
  // Base routes
  static const String products = '/products';  // This is now our home route
  static const String home = '/';
  static const String settings = '/settings';

  // Product details route is nested under products
  static const String productDetails = '/:id'; // works with /:id and with :id 

  // Helper method for product details path
  static String productDetailsPath(int id) => '/products/$id';
}