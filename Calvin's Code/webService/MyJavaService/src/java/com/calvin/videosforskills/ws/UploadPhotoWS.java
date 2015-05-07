/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.calvin.videosforskills.ws;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import javax.jws.WebService;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import sun.misc.BASE64Decoder;

/**
 *
 * @author calvin
 */
@WebService(serviceName = "UploadPhotoWS")
public class UploadPhotoWS {

    /**
     * Web service operation
     */
    @WebMethod(operationName = "uploadPhoto")
    public Boolean uploadPhoto(@WebParam(name = "photoBitStr") String photoBitStr, @WebParam(name = "fileName") String fileName) {
        //TODO write your implementation code here:
        String path = this.getClass().getResource("/").getPath();
        int lastNum = path.lastIndexOf("/WEB-INF/");


        String pathDirectory = path.substring(0, lastNum) + "/uploadPhotos//";
        File dirFile = new File(pathDirectory);
        if (!(dirFile.exists()) && !(dirFile.isDirectory())) {
            boolean creadok = dirFile.mkdirs();
        }
        return GenerateImage(photoBitStr, fileName, pathDirectory);
    }

    private boolean GenerateImage(String imgStr, String fileName, String pathDirectory) {//对字节数组字符串进行Base64解码并生成图片
        if (imgStr == null) //图像数据为空
        {
            return false;
        }
        BASE64Decoder decoder = new BASE64Decoder();
        try {
            //Base64解码
            byte[] b = decoder.decodeBuffer(imgStr);
            for (int i = 0; i < b.length; ++i) {
                if (b[i] < 0) {//调整异常数据
                    b[i] += 256;
                }
            }
            //生成jpeg图片
            String imgFilePath = pathDirectory + fileName;//新生成的图片
            OutputStream out = new FileOutputStream(imgFilePath);
            out.write(b);
            out.flush();
            out.close();
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
