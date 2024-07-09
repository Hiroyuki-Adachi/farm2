import r from"os";import e from"process";var t={};var v=e;var a=r;var o=t=function(){if("Windows_NT"==a.type())return false;var r=/UTF-?8$/i;var e=v.env.LC_ALL||v.env.LC_CTYPE||v.env.LANG;return r.test(e)};var n=t;export default n;

