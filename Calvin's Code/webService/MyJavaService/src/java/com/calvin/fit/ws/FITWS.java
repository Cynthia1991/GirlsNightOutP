/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.calvin.fit.ws;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javapns.devices.Device;
import javapns.devices.implementations.basic.BasicDevice;
import javapns.notification.PushNotificationPayload;
import javapns.notification.PushedNotification;
import javapns.Push;

public class FITWS {
    public String sentNotification(String eventID, String content, String keyStore, String password, Boolean production, String deviceTokens,int badge,int function,String userID,String postFunction,String eventPostDBID,String timeCreated,String photoDic,String drinkDic,String textValue)
    {
        String result="";
        result=result+keyStore+"\n";
        result=result+password+"\n";
        try {
            content=content.replace("!@", " ");
            //message是一个json的字符串{“aps”:{“alert”:”iphone推送测试”}}
            PushNotificationPayload payLoad = PushNotificationPayload.complex();
            payLoad.addCustomDictionary("eventID",eventID);
            payLoad.addCustomDictionary("userID",userID);
            payLoad.addCustomDictionary("postFunction",postFunction);
            payLoad.addCustomDictionary("eventPostDBID",eventPostDBID);
            payLoad.addCustomDictionary("timeCreated",timeCreated);
            payLoad.addCustomDictionary("photoDic",photoDic);
            payLoad.addCustomDictionary("drinkDic",drinkDic);
            payLoad.addCustomDictionary("textValue",textValue);
            payLoad.addCustomDictionary("function",function);
            payLoad.addAlert(content);
            payLoad.addBadge(badge); // 图标小红圈的数值
//            payLoad.addSound("default"); // 铃音 默认

//            String keyStore= "/Users/calvin/Downloads/PushNotification.p12";//导出的证书
//            String password= "calvin";//此处注意导出的证书密码不能为空因为空密码会报错
            
//            String deviceToken = "3a5d893b423bdbcb7677dc811d5b03b0dee6956fe97e4db24bb679e3410d387d";//iphone手机获取的token
            String[] tokensArray=deviceTokens.split("!@");
            
            List<Device> devices = new ArrayList<Device>();
            for(int i=0;i<tokensArray.length;i++)
            {
                Device device = new BasicDevice();
                device.setToken(tokensArray[i]);
                devices.add(device);
            }

            for(int i=0;i<tokensArray.length;i++)
            {
                System.out.println("No."+i+" is:"+tokensArray[i]);
                result=result+"No."+i+" is:"+tokensArray[i]+"\n";

            }
            
            /* Decide how many threads you want to create and use */ 
            int threads = 30;


            /* Start threads, wait for them, and get a list of all pushed notifications */ 
            List<PushedNotification> notifications = Push.payload(payLoad, keyStore, password, production, threads, devices);           
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            List<PushedNotification> failedNotifications = PushedNotification.findFailedNotifications(notifications);
            List<PushedNotification> successfulNotifications = PushedNotification.findSuccessfulNotifications(notifications);
            int failed = failedNotifications.size();
            int successful = successfulNotifications.size();

            if (successful > 0 && failed == 0) {
                result=result+"successful:"+successful;
                System.out.println("successful"+successful);

            } 
            else if (successful == 0 && failed > 0) {
                result=result+"failed:"+failed;
                System.out.println("failed"+failed);
            } 
            else if (successful == 0 && failed == 0) {
                System.out.println("No notifications could be sent, probably because of a critical error");
            } 
            else {
            }
        } 
        catch (Exception e) {
            Logger.getLogger(com.calvin.fit.ws.FITWS.class.getName()).log(Level.SEVERE, null, e);
            result=result+e.getMessage();
        }
  
        return result;
    }
}