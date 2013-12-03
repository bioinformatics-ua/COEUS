<?xml version="1.0" encoding="UTF-8" ?>
<%@include file="/layout/style.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    String err = request.getParameter("f");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <style type="text/css">
            body {
                padding-top: 10px;
                padding-bottom: 40px;
                background-color: #f5f5f5;
            }

            .form-signin {
                max-width: 300px;
                padding: 19px 29px 29px;
                margin: 0 auto 20px;
                background-color: #fff;
                border: 1px solid #e5e5e5;
                -webkit-border-radius: 5px;
                -moz-border-radius: 5px;
                border-radius: 5px;
                -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
            }
            .form-signin .form-signin-heading,
            .form-signin .checkbox {
                margin-bottom: 10px;
            }
            .text-error{
                margin-left: 220px;
            }
            .form-signin input[type="text"],
            .form-signin input[type="password"] {
                font-size: 16px;
                height: auto;
                margin-bottom: 15px;
                padding: 7px 9px;
            }

        </style>
        <title>Setup Login</title>

    </head>
    <body>

        <div class="container">
            <div class="page-header">
                <h1 align="center">COEUS <small>Setup</small></h1>
            </div>
            <form class="form-signin" method="POST" action="j_security_check">
                <h2 class="form-signin-heading">Please sign in</h2>
                <input type="text" name="j_username" class="input-block-level form-control" placeholder="Tomcat User">
                    <input type="password" name="j_password" class="input-block-level form-control" placeholder="Password">

                        <button class="btn btn-primary btn-lg" type="submit">Sign in</button>
                        <%
                            if (err != null) {
                        %>
                        <br/><br/>
                        <div class="alert alert-danger">
                            <strong>Invalid Login!</strong> Check your <a href="../../documentation/#downloads">credentials</a>.
                        </div>
                        <%    }
                        %>
                        </form>

                        </div> 
                        </body>
                        </html>