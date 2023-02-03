// routes.dart houses a comprehensive list of possible routes.
// A branch of route could be the endpoint or another Routes 


class Routes {
  bool isSentinel = false;
  RouteName route = RouteName('/');
  List<Routes> children = [];

  Routes(this.isSentinel, this.route);

  void setSentinel(bool isSentinel) {
    this.isSentinel = isSentinel;
  }

  void setRoute(RouteName route) {
    this.route = route;
  }

  void addChild(Routes routes) {
    this.children.add(routes);
  }

  RouteName getRouteName() {
    return this.route;
  }

  List<Routes> getChildren() {
    return this.children;
  }
}

class RouteName {
  // Default route is '/'.
  // '/' only possible iff the route node with this route name is sentinel (root).
  String name = '/';

  RouteName(this.name);

  String getName() {
    return name;
  }
}
