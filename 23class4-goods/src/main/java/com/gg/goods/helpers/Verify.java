package com.gg.goods.helpers;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;

@Slf4j
public class Verify {

    public static void getVirify(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 设置响应头，防止浏览器缓存
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache, must-revalidate");
        response.setDateHeader("Expires", 0);
        response.setContentType("image/jpeg");

        // 创建验证码对象
        VerifyCode verifyCode = new VerifyCode();

        // 生成验证码图片
        BufferedImage image = verifyCode.getImage();

        // 获取验证码文本并转换为小写存储到session中，确保与前端处理一致
        String verifyText = verifyCode.getText().toLowerCase();

        // 存储验证码到session中
        request.getSession().setAttribute("vCode", verifyText);

        // 记录日志以便调试
        log.debug("生成验证码: {}, 转换为小写后存储: {}", verifyCode.getText(), verifyText);

        // 输出图片到响应流
        OutputStream out = response.getOutputStream();
        try {
            VerifyCode.output(image, out);
            out.flush();
        } finally {
            // 确保输出流被正确关闭
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                    // 记录关闭流时的异常，但不抛出
                    log.error("关闭输出流时发生异常", e);
                }
            }
        }
    }
}