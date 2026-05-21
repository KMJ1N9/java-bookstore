package com.gg.goods.tags;

import com.gg.goods.filters.CSRFTokenManager;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.tagext.TagSupport;

import java.io.IOException;

/**
 * CSRF令牌标签，用于在JSP页面中生成CSRF令牌
 * 支持两种模式：
 * 1. 默认模式：生成隐藏表单字段
 * 2. JavaScript模式：生成JavaScript变量，可用于AJAX请求
 */
public class CSRFTokenTag extends TagSupport {

    // 令牌类型：hidden（默认，生成隐藏表单字段）或js（生成JavaScript变量）
    private String type = "hidden";

    // 自定义的令牌参数名，默认为CSRFTokenManager中定义的参数名
    private String paramName;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getParamName() {
        return paramName;
    }

    public void setParamName(String paramName) {
        this.paramName = paramName;
    }

    @Override
    public int doStartTag() throws JspException {
        HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
        String tokenName = (paramName != null) ? paramName : CSRFTokenManager.CSRF_PARAM_NAME;
        String token = CSRFTokenManager.getToken(request);

        try {
            if ("js".equalsIgnoreCase(type)) {
                // JavaScript模式：生成JavaScript变量
                generateJavaScriptToken(tokenName, token);
            } else {
                // 默认模式：生成隐藏表单字段
                generateHiddenInputToken(tokenName, token);
            }
        } catch (IOException e) {
            throw new JspException("生成CSRF令牌时发生错误", e);
        }

        return SKIP_BODY;
    }

    /**
     * 生成隐藏表单字段形式的CSRF令牌
     */
    private void generateHiddenInputToken(String tokenName, String token) throws IOException {
        StringBuilder html = new StringBuilder();
        html.append("\n<!-- CSRF Protection Token -->\n");
        html.append("<input type=\"hidden\" name=\"")
                .append(tokenName)
                .append("\" value=\"")
                .append(token)
                .append("\" />")
                .append("\n");
        pageContext.getOut().print(html.toString());
    }

    /**
     * 生成JavaScript变量形式的CSRF令牌，可用于AJAX请求
     */
    private void generateJavaScriptToken(String tokenName, String token) throws IOException {
        StringBuilder js = new StringBuilder();
        js.append("\n<!-- CSRF Protection Token for AJAX -->\n");
        js.append("<script type=\"text/javascript\">\n");
        js.append("// CSRF令牌，用于AJAX请求\n");
        js.append("var csrfToken = '").append(token).append("';\n");
        js.append("var csrfTokenName = '").append(tokenName).append("';\n");
        js.append("// 自动为jQuery AJAX请求添加CSRF令牌\n");
        js.append("if (window.jQuery) {\n");
        js.append("  jQuery.ajaxSetup({\n");
        js.append("    headers: {\n");
        js.append("      '").append(CSRFTokenManager.CSRF_HEADER_NAME).append("': csrfToken\n");
        js.append("    }\n");
        js.append("  });\n");
        js.append("}\n");
        js.append("</script>\n");
        pageContext.getOut().print(js.toString());
    }

    @Override
    public void release() {
        super.release();
        // 重置属性，确保标签实例重用时的正确性
        this.type = "hidden";
        this.paramName = null;
    }
}