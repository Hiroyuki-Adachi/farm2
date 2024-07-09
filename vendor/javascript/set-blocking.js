import o from"process";var t={};var n=o;t=function(o){[n.stdout,n.stderr].forEach((function(t){t._handle&&t.isTTY&&"function"===typeof t._handle.setBlocking&&t._handle.setBlocking(o)}))};var e=t;export default e;

