<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	Welcome
	<br />
	<input id="text" type="text" />
	<input type="button" onclick="fsxx()" value="发送消息 " />
	<hr />
	<button onclick="closeWebSocket()">关闭WebSocket连接</button>
	<hr />
	<div id="message"></div>
</body>

<script type="text/javascript">
	/**
		0：正在建立连接， WebSocket.OPENING
		1：已经建立连接， WebSocket.OPEN
		2：正在关闭连接， WebSocket.CLOSING
		3：已经关闭连接， WebSocket.CLOSE
	 **/

	var websocket = null;
	//判断当前浏览器是否支持WebSocket
	if ('WebSocket' in window) {
		websocket = new WebSocket("ws://localhost:7090/websocket/websocket");
	} else {
		alert('当前浏览器 Not support websocket')
	}

	//正在建立连接
	console.log("[readyState]-" + websocket.readyState); // 0

	//连接成功建立的回调方法
	websocket.onopen = function() {
		console.log('Connection established.')
		console.log("[readyState]-" + websocket.readyState); //1

		setMessageInnerHTML("WebSocket连接成功");
	}
	
	//连接发生错误的回调方法
	websocket.onerror = function() {
		console.log("[readyState]-" + websocket.readyState);//3
	    console.log('Connection error.')
		
		setMessageInnerHTML("WebSocket连接发生错误");
	};
	
	//连接关闭的回调方法
	websocket.onclose = function(event) {
		var code = event.code;
	    var reason = event.reason;
	    var wasClean = event.wasClean;
	    console.log("[readyState]-" + websocket.readyState);//3
	    console.log('Connection closed.')
	    console.log(code, reason, wasClean)
	    
		setMessageInnerHTML("WebSocket连接关闭");
	}

	//接收到消息的回调方法
	websocket.onmessage = function(event) {
		setMessageInnerHTML(event.data);
	}

	//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
	window.onbeforeunload = function() {
		closeWebSocket();
	}

	//将消息显示在网页上
	function setMessageInnerHTML(innerHTML) {
		document.getElementById('message').innerHTML += innerHTML + '<br/>';
	}

	//关闭WebSocket连接
	function closeWebSocket() {
		// 要关闭WebSocket连接，可以在任何时候调用close方法。
		websocket.close();
	}

	//发送消息
	function fsxx() {
		var message = document.getElementById('text').value;
		console.log("发送消息 ： " + message);
		websocket.send(message);
	}
</script>

</html>