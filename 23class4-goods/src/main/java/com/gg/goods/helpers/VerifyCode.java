package com.gg.goods.helpers;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Random;

public class VerifyCode {
    private int w = 120;
    private int h = 40;
    private Random r = new Random();
    private String[] fontNames = {"Arial", "Helvetica", "SansSerif"};
    private String codes = "23456789abcdefghjkmnopqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ";
    private Color bgColor = new Color(240, 240, 240);
    private String text;

    private Color randomColor() {
        int red = r.nextInt(100) + 50; // 50-150，避免颜色太暗
        int green = r.nextInt(100) + 50;
        int blue = r.nextInt(100) + 50;
        return new Color(red, green, blue);
    }

    private Font randomFont() {
        int index = r.nextInt(fontNames.length);
        String fontName = fontNames[index];
        int style = r.nextInt(2); // 0或1，避免使用过多样式
        int size = r.nextInt(4) + 24; // 24-28
        return new Font(fontName, style, size);
    }

    private void drawLine(BufferedImage image) {
        int num = 4;
        Graphics2D g2 = (Graphics2D) image.getGraphics();
        for (int i = 0; i < num; i++) {
            int x1 = r.nextInt(w);
            int y1 = r.nextInt(h);
            int x2 = r.nextInt(w);
            int y2 = r.nextInt(h);
            g2.setStroke(new BasicStroke(1.0F));
            g2.setColor(randomColor());
            g2.drawLine(x1, y1, x2, y2);
        }
    }

    // 绘制干扰点
    private void drawPoints(BufferedImage image) {
        int num = 50;
        Graphics2D g2 = (Graphics2D) image.getGraphics();
        for (int i = 0; i < num; i++) {
            int x = r.nextInt(w);
            int y = r.nextInt(h);
            g2.setColor(randomColor());
            g2.fillOval(x, y, 1, 1);
        }
    }

    private char randomChar() {
        int index = r.nextInt(codes.length());
        return codes.charAt(index);
    }

    private BufferedImage createImage() {
        BufferedImage image = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2 = (Graphics2D) image.getGraphics();
        g2.setColor(this.bgColor);
        g2.fillRect(0, 0, w, h);
        return image;
    }

    public BufferedImage getImage() {
        BufferedImage image = createImage();
        Graphics2D g2 = (Graphics2D) image.getGraphics();
        StringBuilder sb = new StringBuilder();

        // 设置抗锯齿
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

        // 向图片中画4个字符
        for (int i = 0; i < 4; i++) {
            String s = randomChar() + "";
            sb.append(s);
            float x = i * 1.0F * w / 4 + 5;

            // 添加随机旋转
            g2.setFont(randomFont());
            g2.setColor(randomColor());

            // 随机旋转角度，增强安全性
            int degree = r.nextInt(60) - 30; // -30到30度
            g2.rotate(Math.toRadians(degree), x, h / 2);
            g2.drawString(s, x, h - 8);
            g2.rotate(Math.toRadians(-degree), x, h / 2); // 恢复旋转
        }

        // 直接存储原始文本，不做大小写转换
        this.text = sb.toString();

        // 添加干扰线和点
        drawLine(image);
        drawPoints(image);

        return image;
    }

    public String getText() {
        return text;
    }

    public static void output(BufferedImage image, OutputStream out)
            throws IOException {
        javax.imageio.ImageIO.write(image, "JPEG", out);
    }
}