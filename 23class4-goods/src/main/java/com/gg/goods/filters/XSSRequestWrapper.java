package com.gg.goods.filters;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;

import java.util.HashMap;
import java.util.Map;

/**
 * XSS请求包装器，用于过滤请求参数中的XSS攻击代码
 */
public class XSSRequestWrapper extends HttpServletRequestWrapper {

    private Map<String, String[]> filteredParameters;

    public XSSRequestWrapper(HttpServletRequest request) {
        super(request);
        this.filteredParameters = new HashMap<String, String[]>();
    }

    /**
     * 获取过滤后的请求参数
     */
    @Override
    public String getParameter(String name) {
        String value = super.getParameter(name);
        if (value != null) {
            return cleanXSS(value);
        }
        return null;
    }

    /**
     * 获取过滤后的请求参数数组
     */
    @Override
    public String[] getParameterValues(String name) {
        String[] values = super.getParameterValues(name);
        if (values == null) {
            return null;
        }

        // 检查是否已经过滤过
        if (filteredParameters.containsKey(name)) {
            return filteredParameters.get(name);
        }

        // 过滤每个参数值
        String[] filteredValues = new String[values.length];
        for (int i = 0; i < values.length; i++) {
            filteredValues[i] = cleanXSS(values[i]);
        }

        // 缓存过滤结果
        filteredParameters.put(name, filteredValues);
        return filteredValues;
    }

    /**
     * 获取过滤后的参数映射
     */
    @Override
    public Map<String, String[]> getParameterMap() {
        Map<String, String[]> originalMap = super.getParameterMap();
        Map<String, String[]> filteredMap = new HashMap<String, String[]>();

        for (Map.Entry<String, String[]> entry : originalMap.entrySet()) {
            String key = cleanXSS(entry.getKey());
            String[] values = getParameterValues(entry.getKey());
            filteredMap.put(key, values);
        }

        return filteredMap;
    }

    /**
     * 清理XSS攻击代码
     */
    private String cleanXSS(String value) {
        if (value == null) {
            return null;
        }

        // 移除常见的XSS攻击代码
        String clean = value;

        // 移除script标签
        clean = clean.replaceAll("(?i)<script.*?>.*?</script>", "");

        // 移除on事件处理器
        clean = clean.replaceAll("(?i)on\\w+\\s*=\\s*[\"'].*?[\"']", "");
        clean = clean.replaceAll("(?i)on\\w+\\s*=\\s*[^\"\\s]+", "");

        // 移除javascript:协议
        clean = clean.replaceAll("(?i)javascript:", "");

        // 移除data:URL
        clean = clean.replaceAll("(?i)data:\\w+/\\w+;base64,", "");

        // 转义HTML特殊字符
        clean = clean.replace("<", "&lt;");
        clean = clean.replace(">", "&gt;");
        clean = clean.replace("'", "&#39;");
        clean = clean.replace("\"", "&quot;");
        clean = clean.replace("&", "&amp;");

        return clean;
    }
}