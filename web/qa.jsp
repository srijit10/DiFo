<%-- 
    Document   : qa
    Created on : 3 Apr, 2017, 8:51:54 AM
    Author     : arka
--%>

<%@page import="DBControl.AnswerDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="javax.servlet.http.Part" %>
<%@page import="java.io.*" %>
<%@page import="DBControl.DBEngine" %>
<%@page import="DBControl.QuestionDAO" %>
<%@page import="model.Question" %>
<%@page import="model.Answer" %>
<%@page import="constants.Constants" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Question Thread | DiFo</title>
        
        <style type="text/css">
    	<%@include file="assets/bootstrap/css/bootstrap.min.css" %>
    	<%@include file="assets/css/form-elements.css" %>
    	<%@include file="my.css" %>
    	<%@include file="style.css" %>
    	<%@include file="css/style.css" %>
    	<%@include file="css/reset.css" %>
    	<%@include file="font-awesome.min.css" %>        
	</style>

        <script src="assets/js/jquery-1.11.1.min.js"></script>
	<script src="assets/bootstrap/js/bootstrap.min.js"></script>
	<script src="assets/js/jquery.backstretch.min.js"></script>
	<script src="assets/js/scripts.js"></script>
	<script src="js/modernizr.js"></script>
        
        <style type="text/css">
            #question-head {
                font-size: 20px; 
                color: #445668; 
                text-transform: uppercase;
                text-align: center; 
                margin: 0 0 35px 0; 
                text-shadow: 0px 1px 0px #f2f2f2;
            }
            
            #answer-start {
                font-size: 20px; 
                color: #445668; 
                text-align: center; 
                margin: 0 0 35px 0; 
                text-shadow: 0px 1px 0px #f2f2f2;
            }
        </style>
        
       
        
        <script type="text/javascript" >
            function add_answer(text) {
                if(text==="Logout") {
                    return true;
                } else if(text==="Login") {
                    alert('You must Login/Signup to answer question');
                    return false;
                }
            }
        </script>
    </head>
    <body  style="background: url('assets/img/talk2.png'); background-size: cover;">
        
        <%@include file="header.jsp" %>
        
        <%
            Question question = null;
            List<Answer> answers = null;
            try {
                DBEngine dbengine = new DBEngine();
                dbengine.establishConnection();
                try {
                    Connection con = dbengine.getConnection();
                    QuestionDAO questionDAO = new QuestionDAO(con);
                    String param = request.getParameter("param");
                    int id = Integer.parseInt(param);
                    question = questionDAO.getQuestionById(id);
                    session.setAttribute("current_question", id);
                    
                    AnswerDAO answerDAO = new AnswerDAO(con);
                    answers = answerDAO.getAnswersByQid(id);
                } catch(Exception ex) {
                    ex.printStackTrace();
                    out.println(Constants.DATABASE_CONN_ERR);
                }
                dbengine.closeConnection();
            } catch(Exception e) {
                e.printStackTrace();
                out.println(Constants.DATABASE_CONN_ERR);
            }
        %>
        
        <div id="question-wrapper">
            <div id="question-head">
                <%= question.getHead() %>
            </div>
            
            <div id="question-body">
                <%= question.getBody() %>
            </div>
            
            <div id="username">
                <%= question.getUsername() %>
            </div>
            
            <div id="timestamp">
                <%= question.getTimestamp() %>
            </div>
        </div>
        
        <div id="answer-start"> Answers </div>

        <div id="answers-wrapper">
            <%
                if(answers != null) {
                    for (Answer answer : answers) {
            %>
            <div id="answer" >
                <div id="answer-body"><%= answer.getBody() %></div>
                <div id="answer-username"><%= answer.getUsername() %></div>
                <div id="answer-timestamp"><%= answer.getTimestamp() %></div>
            </div>
            <%
                    }
                }
            %>
              
        </div>   
        
        <div id="write-answer">
            <form name="answer-form" action="addanswer.jsp" onsubmit="return add_answer('<%= text%>')" method="post">
                <input name="answer-body" type="text" id="answer-body" size="100" />
                <input name="submit_answer" type="submit"  id="submit-answer" value="Answer" />
            </form>
        </div>
    </body>
</html>
