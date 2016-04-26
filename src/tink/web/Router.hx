package tink.web;

import tink.url.Query;

@:genericBuild(tink.web.macros.Routing.buildRouter())
class Router<T> {
}

class RoutingContext<T> {
  public var path(default, null):Array<String>;
  public var query(default, null):Query;
  public var prefix(default, null):Array<String>;
  public var target(default, null):T;
  public var request(default, null):Request;
  
  public var fallback(default, null):RoutingContext<T>->Response;
  
  public function new(target, request, fallback = null, depth:Int = 0) {
    if (fallback == null)
      fallback = notFound;
    this.target = target;
    this.request = request;
    this.query = request.header.uri.query;
    this.path = request.header.uri.path.parts();
    this.prefix = this.path.splice(0, depth);
    trace(this.prefix + ' -- ' + this.path);
    this.fallback = fallback;
  }
  
  static function notFound(_):Response {
    return new tink.core.Error(NotFound, 'Not Found');
  }
}