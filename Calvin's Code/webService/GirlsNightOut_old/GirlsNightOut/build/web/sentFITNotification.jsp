<%-- 
    Document   : sentFITNotification
    Created on : Oct 2, 2012, 1:02:46 PM
    Author     : calvin
--%>

<%@page import="com.FIT.WS.FITWS"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String eventID=request.getParameter("eventID"); 
    String userID=request.getParameter("userID"); 
    String postFunction=request.getParameter("postFunction"); 
    String eventPostDBID=request.getParameter("eventPostDBID"); 
    String timeCreated=request.getParameter("timeCreated"); 
    String photoDic=request.getParameter("photoDic"); 
    String drinkDic=request.getParameter("drinkDic"); 
    String textValue=request.getParameter("textValue"); 



    String content=request.getParameter("content"); 
    String deviceTokens=request.getParameter("deviceTokens"); 
    String badge=request.getParameter("badge"); 
    String function=request.getParameter("function"); 
    String productionFunction=request.getParameter("productionFunction"); 

    String keyStoreURL=request.getSession().getServletContext().getRealPath("/")+"FITPushNotification.p12";
    String password="calvin";
    Boolean production=false;
    if(productionFunction.equals("1"))
    {
        production=true;
    }
    FITWS g=new FITWS();
    String result=g.sentNotification(eventID, content, keyStoreURL, password, production,deviceTokens,Integer.valueOf(badge),Integer.valueOf(function),userID,postFunction,eventPostDBID,timeCreated,photoDic,drinkDic,textValue);
    out.println(result);
    
%>