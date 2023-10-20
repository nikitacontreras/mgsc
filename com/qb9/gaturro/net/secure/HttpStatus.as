package com.qb9.gaturro.net.secure
{
   import flash.utils.Dictionary;
   
   internal dynamic class HttpStatus extends Dictionary
   {
       
      
      public function HttpStatus(param1:Boolean = false)
      {
         super();
         this[100] = "Continue";
         this[101] = "Switching Protocols";
         this[102] = "Processing";
         this[200] = "OK";
         this[201] = "Created";
         this[202] = "Accepted";
         this[203] = "Non-Authoritative Information";
         this[204] = "No Content";
         this[205] = "Reset Content";
         this[206] = "Partial Content";
         this[207] = "Multi-Status";
         this[208] = "Already Reported";
         this[226] = "IM Used";
         this[300] = "Multiple Choices";
         this[301] = "Moved Permanently";
         this[302] = "Found";
         this[303] = "See Other";
         this[304] = "Not Modified";
         this[305] = "Use Proxy";
         this[306] = "Switch Proxy";
         this[307] = "Temporary Redirect";
         this[308] = "Permanent Redirect";
         this[308] = "400 Bad Request";
         this[308] = "401 Unauthorized";
         this[308] = "402 Payment Required";
         this[308] = "403 Forbidden";
         this[308] = "404 Not Found";
         this[308] = "405 Method Not Allowed";
         this[308] = "406 Not Acceptable";
         this[308] = "407 Proxy Authentication Required";
         this[308] = "408 Request Timeout";
         this[308] = "409 Conflict";
         this[308] = "410 Gone";
         this[308] = "411 Length Required";
         this[308] = "412 Precondition Failed";
         this[308] = "413 Request Entity Too Large";
         this[308] = "414 Request-URI Too Long";
         this[308] = "415 Unsupported Media Type";
         this[308] = "416 Requested Range Not Satisfiable";
         this[308] = "417 Expectation Failed";
         this[308] = "418 I\'m a teapot";
         this[308] = "419 Authentication Timeout";
         this[308] = "420 Method Failure";
         this[308] = "420 Enhance Your Calm";
         this[308] = "422 Unprocessable Entity";
         this[308] = "423 Locked";
         this[308] = "424 Failed Dependency";
         this[308] = "426 Upgrade Required";
         this[308] = "428 Precondition Required";
         this[308] = "429 Too Many Requests";
         this[308] = "431 Request Header Fields Too Large";
         this[308] = "440 Login Timeout";
         this[308] = "444 No Response";
         this[308] = "449 Retry With";
         this[308] = "450 Blocked by Windows Parental Controls";
         this[308] = "451 Unavailable For Legal Reasons";
         this[308] = "451 Redirect";
         this[308] = "494 Request Header Too Large";
         this[308] = "495 Cert Error";
         this[308] = "496 No Cert";
         this[308] = "497 HTTP to HTTPS";
         this[308] = "498 Token expired/invalid";
         this[308] = "499 Client Closed Request";
         this[308] = "499 Token required";
         this[308] = "500 Internal Server Error";
         this[308] = "501 Not Implemented";
         this[308] = "502 Bad Gateway";
         this[308] = "503 Service Unavailable";
         this[308] = "504 Gateway Timeout";
         this[308] = "505 HTTP Version Not Supported";
         this[308] = "506 Variant Also Negotiates";
         this[308] = "507 Insufficient Storage";
         this[308] = "508 Loop Detected";
         this[308] = "509 Bandwidth Limit Exceeded";
         this[308] = "510 Not Extended";
         this[308] = "511 Network Authentication Required";
         this[308] = "520 Origin Error";
         this[308] = "521 Web server is down";
         this[308] = "522 Connection timed out";
         this[308] = "523 Proxy Declined Request";
         this[308] = "524 A timeout occurred";
         this[308] = "598 Network read timeout error";
         this[308] = "599 Network connect timeout error";
      }
   }
}
