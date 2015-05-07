/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.calvin.videosforskills.ws;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import sun.misc.BASE64Decoder;

/**
 *
 * @author calvin
 */
public class UploadPhotoTest {

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

    public static void main(String[] args) throws Exception {
        UploadPhotoTest ws = new UploadPhotoTest();

        String path = ws.getClass().getResource("/").getPath();
        int lastNum = path.lastIndexOf("/classes/");


        String pathDirectory = path.substring(0, lastNum) + "/uploadPhotos//";
        File dirFile = new File(pathDirectory);
        if (!(dirFile.exists()) && !(dirFile.isDirectory())) {
            boolean creadok = dirFile.mkdirs();
        }
        ws.GenerateImage("aa", "222222.jpg", pathDirectory);
    }
}
