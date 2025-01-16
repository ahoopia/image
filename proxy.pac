function FindProxyForURL(url, host) {
    // 定义代理服务器和端口
    // var proxy1 = "192.168.1.1:8080";
   //var proxy2 = "192.168.18.44:7890";

    // 检查第一个代理是否可用
    // if (isResolvable(proxy2)) {
    //    return "PROXY " + proxy2;
    //}

    // 如果都不可用，直接连接
    return "PROXY 192.168.18.44:7890;DIRECT";
}